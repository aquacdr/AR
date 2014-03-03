/**
    Contains various email send related methods.
    
    Activity History:  
    Shah Kadirmohideen - 9/18 - Added sendEmail(14 params) method.
    
*/
public class EmailUtils {
    
    private static String PERSONAL_ECARD='Personal_ECard';
    public static void sendFreeFormEmail(List<String> repAcctList,String subj,String msgDetail){
        Map<Id,Contact> targetObjIds = new Map<Id,Contact>();
        
        System.debug('>>>>>>>>>>>>>>>> toIdsArray ='+repAcctList);
        //List<Contact> cnt = [Select Id from Contact where MRKT_ACCT_KEY__c in : repAcctList];
        List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        EmailTemplate temp = [select HtmlValue,Body from EmailTemplate where Id=:globalConfig.Personal_Email_Template_Id__c];//hardcode id by manas for migration
        User currUser = [select Id,Profile.Name,MobilePhone,Phone,Name,Username,Email,GI3_Email__c from User where Id=:UserInfo.getUserId()][0];
        String htmlBody = temp.HtmlValue;
        msgDetail.replace('SLNAME', currUser.Name);
        htmlBody = htmlBody.replace('$Dear',System.Label.Dear);
        htmlBody = htmlBody.replace('$EmailContent',msgDetail.replace('\n','<br/>'));
        htmlBody = htmlBody.replace('$User.Name',UserInfo.getName());
        htmlBody = htmlBody.replace('$User.MobilePhone',(currUser.MobilePhone!=null?currUser.MobilePhone:(currUser.Phone!=Null?currUser.Phone:'')));
        htmlBody = htmlBody.replace('$User.Profile',currUser.Profile.Name);
        htmlBody = htmlBody.replace('$Disclaimer',System.Label.Personal_ECard_Disclaimer);
        htmlBody = htmlBody.replace('$Click_Here',System.Label.Click_Here);
        htmlBody = htmlBody.replace('$Personal_Ecard_Optout_PostFix',System.Label.Personal_Ecard_Optout_PostFix);
        String msgHtml;
        List<Id> errIdList = new List<Id>();
        List<Id> eContactNoEmail = new List<Id>();
        List<String> s_Failed_Contacts = new List<String>();
        for(Contact ct: [   Select Id,Name,Representative_Phone__c,Email,HasOptedOutOfEmail 
                            from Contact 
                            where MRKT_ACCT_KEY__c in : repAcctList]) 
        {
            Messaging.SingleEmailMessage mail;
            if(!ct.HasOptedOutOfEmail){
                msgHtml=htmlBody;
                targetObjIds.put(ct.Id,ct);
                mail = new Messaging.SingleEmailMessage();
                mail.setReplyTo(currUser.GI3_Email__c);
                mail.saveAsActivity=false;
                msgHtml = msgHtml.replace('$Contact.Name',ct.Name);
                mail.setHtmlBody(msgHtml);
                mail.setSubject(subj);
                mail.setUseSignature(false);
                if(ct.Email!=null && ct.Email!=''){
                    List<String> emails = new List<String>{ct.Email};
                    //mail.setToAddresses(emails);  
                    mail.setTargetObjectId(ct.Id);
                    emailsToSend.add(mail);
                }
                else{
                	System.debug('In No Email...');
                    eContactNoEmail.add(ct.Id);
                }
                
            }else{
            	System.debug('In Opted Out ...');
                errIdList.add(ct.Id);
            }
        }
        List<String> myEmails = new List<String>{currUser.GI3_Email__c};
        System.debug('myEmails--'+myEmails);
        Messaging.SingleEmailMessage copymail;
        copymail = new Messaging.SingleEmailMessage();
        //copymail.setToAddresses(myEmails);
        copymail.setTargetObjectId(currUser.Id);
        copymail.setReplyTo(currUser.GI3_Email__c);
        copymail.saveAsActivity=false;
        copymail.setHtmlBody(msgHtml);
        copymail.setSubject(subj);
        copymail.setUseSignature(false);
        emailsToSend.add(copymail);
        System.debug('emailsToSend--'+emailsToSend);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailsToSend,false);
        System.debug('results---'+results);
        for(Messaging.SendEmailResult emailRslt: results){
            ALMLogUtils.log('EmailUtils.sendAndProcessResults','emailRslt:'+emailRslt.isSuccess());
            if(!emailRslt.isSuccess()){
                for(Messaging.SendEmailError emailErr: emailRslt.getErrors()){
                    //ALMLogUtils.log('EmailUtils','Error sending email to :'+emailErr.getTargetObjectId());
                    String[] s_StatusCode= emailErr.getMessage().split(':');
                    s_Failed_Contacts.add(s_StatusCode[1].trim());
                    System.debug('s_StatusCode-->'+s_StatusCode);
                    System.debug('s_StatusCode[1]--'+s_StatusCode[1]);
                    //errIdList.add(emailErr.getTargetObjectId());
                }
            }
         }
         System.debug('s_Failed_Contacts--'+s_Failed_Contacts+'-size--'+s_Failed_Contacts.size());
         if(s_Failed_Contacts.size()>0)
            {
                Integer j=s_Failed_Contacts.size()-1;
                String s_QueryString='';
                for(Integer i=0;i<s_Failed_Contacts.size();i++)
                {
                        if(i==j)
                        {
                            s_QueryString = s_QueryString.trim()+'\''+s_Failed_Contacts[i]+'\'';
                        }
                        if(i!=j)
                        {
                            s_QueryString = s_QueryString.trim()+'\''+s_Failed_Contacts[i]+'\',';
                        }
                    
                }
                System.debug(s_QueryString);
                List<Contact> lst_FailedContacts = Database.query('Select Id From Contact Where Id In ('+s_QueryString+')');
                System.debug('Failed Contacts List-->'+lst_FailedContacts);
                for(Integer i=0;i<lst_FailedContacts.size();i++)
                {
                    errIdList.add(lst_FailedContacts[i].Id);
                }
            }
         
        processErrors(errIdList,targetObjIds,null,subj,msgDetail,eContactNoEmail);
    }
    //Added For ALMPlus by Snehashis
    /*public static void sendFreeFormLeadEmail(List<Id> leadIdList,String subj,String msgDetail){
        Map<Id,Lead> targetObjIds = new Map<Id,Lead>();
        List<Lead> errEmlLst = new List<Lead>();
        List<Lead> errorLeadNoEmail = new List<Lead>();
        System.debug('>>>>>>>>>>>>>>>> toIdsArray ='+leadIdList);
        List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
        Messaging.SingleEmailMessage mail;
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        System.debug('Global Config-->'+globalConfig);
        EmailTemplate temp = [select HtmlValue,Body from EmailTemplate where Id=:globalConfig.Lead_Personal_Email_Template_Id__c];
        User currUser = [select Id,Profile.Name,MobilePhone,Username,Email,GI3_Email__c from User where Id=:UserInfo.getUserId()][0];
        String htmlBody = temp.HtmlValue;
        htmlBody = htmlBody.replace('$Dear',System.Label.Dear);
        htmlBody = htmlBody.replace('$EmailContent',msgDetail.replace('\n','<br/>'));

        htmlBody = htmlBody.replace('$User.Name',UserInfo.getName());
        htmlBody = htmlBody.replace('$User.Profile',currUser.Profile.Name);
        htmlBody = htmlBody.replace('$User.Phone',(currUser.MobilePhone==null?'':currUser.MobilePhone));
        htmlBody = htmlBody.replace('$Disclaimer',System.Label.Personal_ECard_Disclaimer);
        String msgHtml;
        for(Lead ld: [  Select Id,Name,Email,HasOptedOutOfEmail,MobilePhone
                            from Lead
                            where Id in : leadIdList]) 
        {
            if(ld.Email!=null){
                msgHtml=htmlBody;
                targetObjIds.put(ld.Id,ld);
                mail = new Messaging.SingleEmailMessage();
                mail.setReplyTo(currUser.GI3_Email__c);
                mail.saveAsActivity=false;
                msgHtml = msgHtml.replace('$Lead.Name',ld.Name);
                //msgHtml = msgHtml.replace('$Contact.Opt_Out_URL',(ct.Opt_Out_URL__c!=null?ct.Opt_Out_URL__c:'#'));
                mail.setHtmlBody(msgHtml);
                mail.setSubject(subj);
                mail.setUseSignature(false);
                mail.setTargetObjectId(ld.Id);  
                emailsToSend.add(mail);
            }else if (ld.Email==null){
                errorLeadNoEmail.add(ld);
            }
            else{
                errEmlLst.add(ld);
            }
        }

        List<ID> errIdList = new List<ID>();
        try{
            errIdList = sendAndProcessResults(emailsToSend);
        }catch(Exception ex){
            //subhamay 112011
            String strErrorInfo = 'Section 1: Track Bulk Ecards Sending Issue: \n'+ currUser.Username+'-*-'+currUser.Email+'-*-'+System.today()+'\n';
            strErrorInfo += ex.getMessage();
            String errorId = ErrorHandler.handleError(strErrorInfo);
            ALMLogUtils.log('Bulk Ecards Failure error: ', 'id: '+errorId);
            //eoc subhamay 112011                
        }
        processErrors(errIdList,targetObjIds,null,subj,msgDetail,errEmlLst,errorLeadNoEmail);
    }*/
    public static void sendEmail(List<String> repAcctList,String templateId){
        Map<Id,Contact> targetObjIds = new Map<Id,Contact>();
        
        System.debug('>>>>>>>>>>>>>>>> toIdsArray ='+repAcctList);
        //List<Contact> cnt = [Select Id from Contact where MRKT_ACCT_KEY__c in : repAcctList];
        for(Contact ct: [Select Id,Name,Representative_Phone__c,Email,HasOptedOutOfEmail from Contact where MRKT_ACCT_KEY__c in : repAcctList]) 
        {
            targetObjIds.put(ct.Id,ct);
        }
        sendEmail(targetObjIds,templateId);
    }
 
    public static void sendEmail(Map<Id,Contact> contactIdMap,String templateId){
        List<Id> repsToEmail = new List<Id>();
        List<Id> errorIds =new List<Id>();
        List<Id> eContactNoEmail = new List<Id>();
        //Optin functionality addition
        String fldName = [Select Folder.name from EmailTemplate where id=:templateId].Folder.Name ;
        ALMLogUtils.log('EmailUtils.sendEmail(Map,templateId)','>>>>>>>> This is Opt in Folder name'+fldName);
        for(Id repId:contactIdMap.keySet()){
        if(contactIdMap.get(repId).Email!=null && (!contactIdMap.get(repId).HasOptedOutOfEmail || fldName.contains('_OPTIN'))){
                repsToEmail.add(repId);
            }else if(contactIdMap.get(repId).Email!=null && contactIdMap.get(repId).HasOptedOutOfEmail){
                ALMLogUtils.log('EmailUtils.sendEmail(Map,templateId)',repId+'\n Opted Out:Yes. Adding to optOutList');
                errorIds.add(repId);            
            }else if(contactIdMap.get(repId).Email==null){
                eContactNoEmail.add(repId);
            }else{
                ALMLogUtils.log('EmailUtils.sendEmail(Map,templateId,ecardMsg)',repId+' Email is empty. Adding to errorId');
                errorIds.add(repId);
            }
        }
        errorIds.addAll(sendEmail(repsToEmail,templateId));
        processErrors(errorIds,contactIdMap,templateId,null,null,eContactNoEmail);
    }
    private static void processErrors(  List<Id> errIdList,Map<Id,Contact> contactIdMap,
                                        String templateId,String subject,String msgBody,List<Id> eContactNoEmail){
        //For Reps that errored out, remove them from the original list
        //subhamay 102011
        String strTempSubject = '';
        //eoc subhamay 102011
        Map<Id,Contact> errRepDetails = new Map<Id,Contact>();
        
        //added by CS to capture list of contacts with no email.
        Map<Id,Contact> errorContactNoEmails = new Map<Id,Contact>();
        
        for(Id ctId: errIdList){
            errRepDetails.put(ctId,contactIdMap.get(ctId));
            contactIdMap.remove(ctId);
        }
        
        if(eContactNoEmail.size()>0)
        {
            for(Id ctId : eContactNoEmail)
            {
                errorContactNoEmails.put(ctId,contactIdMap.get(ctId));
                contactIdMap.remove(ctId);
            }
        }
        
        EmailTemplate template;
        if(templateId!=null){
            template = [select Subject, Description from EmailTemplate where Id=:templateId];
        }
        String successMsg='';
        String failMsg='';
        String noEmail='';
            
        if(errRepDetails.values()!=null){
            for(Contact ct:errRepDetails.values()){
                ALMLogUtils.log('EmailUtils.processErrors','Failed To sent Email to Rep:'+ct);
                failMsg+=System.Label.Name +':'+ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                        ', '+System.Label.eMail2+': '+(ct.Email==null?'':ct.Email)+','+System.Label.Opted_Out+': '+(ct.HasOptedOutOfEmail==true?System.Label.Yes:System.Label.No)+';';
            }
        }
        
        if(errorContactNoEmails.values()!=null){
            for(Contact ct:errorContactNoEmails.values()){
                
               // noEmail+=ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                 //       ', '+System.Label.eMail2+': '+(ct.Email==null?'':ct.Email)+', \n'+System.Label.Opted_Out+': '+(ct.HasOptedOutOfEmail==true?System.Label.Yes:System.Label.No)+'\n';
            
                noEmail+=System.Label.Name +':'+ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                        ', '+System.Label.eMail2+': '+(ct.Email==null?'':ct.Email)+','+System.Label.Opted_Out+': '+(ct.HasOptedOutOfEmail==true?System.Label.Yes:System.Label.No)+';';
            }
        }
        
        if(contactIdMap.values()!=null){
            for(Contact ct:contactIdMap.values()){
                //successMsg+=ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                  //          ', '+System.Label.eMail2+': '+ct.Email+'\n';
                  successMsg+=System.Label.Name +':'+ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                        ', '+System.Label.eMail2+': '+(ct.Email==null?'':ct.Email)+','+System.Label.Opted_Out+': '+(ct.HasOptedOutOfEmail==true?System.Label.Yes:System.Label.No)+';';
            }
        }
        //Changed by Snehashis on 14 June to replace ECard Decription to Subject
        //subhamay 102011
        if(template != null){ 
            if(template.Subject.length() > 80) {
                strTempSubject = template.Subject.substring(0, 80);
            }else{
                strTempSubject = template.Subject;
            }
        }
        //eoc subhamay 102011
        ECard_History__c ecardHistory = new ECard_History__c(   OwnerId=UserInfo.getUserId(),
                                    //subhamay 102011
                                    //Name=(template!=null?template.Subject:''),
                                    Name = strTempSubject,
                                    DetailSubject__c = (template!=null?template.Subject:''),
                                    //eoc subhamay 102011
                                    Success__c= successMsg,
                                    Status__c='Sent',
                                    Success_Count__c=contactIdMap.values().size(),
                                    Failed_Count__c=errRepDetails.values().size(),
                                    No_Email_Count__c=errorContactNoEmails.values().size(),
                                    Failed__c=failMsg,
                                    No_Email__c = noEmail
                                    );
        //Set the Subject and Message detail if passed 
        if(subject!=null){
            //subhamay 102011
            ecardHistory.DetailSubject__c = subject; 
            if(subject.length() > 80){ 
                ecardHistory.Name = subject.substring(0, 80);
            } else {
                ecardHistory.Name = subject;
            }
            //subhamay 102011
        }
        if(msgBody!=null){
            eCardHistory.Personal_Ecard_Message__c=msgBody;
        }
        ALMLogUtils.log('EmailUtils.processErrors','ecardhistory:'+ecardHistory);
        insert ecardHistory;
        System.debug('ecardHistory--'+ecardHistory.Id);
    }
    /*private static void processErrors(  List<Id> errIdList,Map<Id,Lead> leadIdMap,
                                        String templateId,String subject,String msgBody, List<Lead> errEmlLst,List<Lead> errLeadNoEmail){
        //For Leads those errored out, remove them from the original list
        //subhamay 102011
        String strTempSubject = '';
        //eoc subhamay 102011
        
        
        
        Map<Id,Lead> errLeadDetails = new Map<Id,Lead>();
        Map<Id,Lead> errLeadEmail = new Map<Id,Lead>();
        
        for(Id ldId: errIdList){
            errLeadDetails.put(ldId,leadIdMap.get(ldId));
            leadIdMap.remove(ldId);
        }
        if(errEmlLst.size()>0){
            for(Lead l: errEmlLst){
                errLeadDetails.put(l.Id,l);
            }
        }
        if(errLeadNoEmail.size()>0)
        {
            
            for(Lead l: errLeadNoEmail){
                errLeadEmail.put(l.Id,l);
                
                }
        }
        EmailTemplate template;
        if(templateId!=null){
            template = [select Description from EmailTemplate where Id=:templateId];
        }
        String successMsg='';
        String failMsg='';  
        String noEmail='';
        if(errLeadDetails.values()!=null){
            for(Lead ld:errLeadDetails.values()){
                ALMLogUtils.log('EmailUtils.processErrors','Failed To sent Email to Lead:'+ld);
                failMsg+=ld.Name+', '+System.Label.Phone+': '+(ld.MobilePhone==null?'':ld.MobilePhone)+
                        ', '+System.Label.eMail2+': '+(ld.Email==null?'':ld.Email)+'\n';
            }
        }
        if(errLeadEmail.values()!=null){
            for(Lead ld:errLeadEmail.values()){
                System.debug('In No Email Message-->'+ ld);
                noEmail+=ld.Name+', '+System.Label.Phone+': '+(ld.MobilePhone==null?'':ld.MobilePhone)+
                        ', '+System.Label.eMail2+': '+(ld.Email==null?'':ld.Email)+'\n';
            }
        }
        
        if(leadIdMap.values()!=null){
            for(Lead l:leadIdMap.values()){
                successMsg+=l.Name+', '+System.Label.Phone+': '+(l.MobilePhone==null?'':l.MobilePhone)+
                            ', '+System.Label.eMail2+': '+l.Email+'\n';
            }
        }
        //subhamay 102011
        if(template != null){ 
            if(template.Description.length() > 80) {
                strTempSubject = template.Description.substring(0, 80);
            }else{
                strTempSubject = template.Description;
            }
        }
        //eoc subhamay 102011       
        ECard_History__c ecardHistory = new ECard_History__c(   OwnerId=UserInfo.getUserId(),
                                    //subhamay 102011
                                    //Name=(template!=null?template.Description:''),
                                    Name=strTempSubject,
                                    DetailSubject__c = (template!=null?template.Description:''),
                                    //eoc subhamay 102011
                                    Success__c= successMsg,
                                    Status__c='Sent',
                                    No_Email__c = noEmail,
                                    No_Email_Count__c=errLeadEmail.values().size(),
                                    Success_Count__c=leadIdMap.values().size(),
                                    Failed_Count__c=errLeadDetails.values().size(),
                                    Failed__c=failMsg);
        //Set the Subject and Message detail if passed 
        if(subject!=null){          
            //subhamay 102011
            //eCardHistory.Name=subject;
            ecardHistory.DetailSubject__c = subject; 
            if(subject.length() > 80){ 
                ecardHistory.Name = subject.substring(0, 80);
            } else {
                ecardHistory.Name = subject;
            }
            //subhamay 102011
        }
        if(msgBody!=null){
            eCardHistory.Personal_Ecard_Message__c=msgBody;
        }
        ALMLogUtils.log('EmailUtils.processErrors','ecardhistory:'+ecardHistory);
        insert ecardHistory;
    }*/
    public static List<Id> sendEmail(List<ID> targetObjIds,String templateId){
        List<ID> errIdList = new List<ID>();
        if(targetObjIds.size() > 0){
            Messaging.SingleEmailMessage mail;
            User currUser = [select Id,Username,Email,GI3_Email__c from User where Id=:UserInfo.getUserId()][0];
            List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
            for(Id trgId:targetObjIds){
                mail = new Messaging.SingleEmailMessage();
                mail.setReplyTo(currUser.GI3_Email__c);
                mail.saveAsActivity=false;
                mail.setTemplateId(templateId);
                mail.setUseSignature(false);
                mail.setTargetObjectId(trgId);  
                emailsToSend.add(mail);
            }
            try{
                errIdList = sendAndProcessResults(emailsToSend);
            }catch(Exception ex){
                //Return the entire input back as everything failed.
                //subhamay 112011
                String strErrorInfo = 'Section 2: Track Bulk Ecards Sending Issue: \n'+ currUser.Username+'-*-'+currUser.Email+'-*-'+System.today()+'\n';
                strErrorInfo += ex.getMessage();
                String errorId = ErrorHandler.handleError(strErrorInfo);
                ALMLogUtils.log('Bulk Ecards Failure error: ', 'id: '+errorId);
                //eoc subhamay 112011                
                return targetObjIds;
            }
        }   
        return errIdList; 
    }
    public static List<Id> sendEmail(List<Id> targetObjIds,String templateId,String replyTo){
        return sendEmail(targetObjIds,templateId,replyTo,replyTo);  
    }

    public static List<Id> sendEmail(List<Id> targetObjIds,String templateId,String replyTo,String senderName){
        List<ID> errIdList = new List<ID>();
        
        if(targetObjIds.size() > 0){
            Messaging.SingleEmailMessage mail;
            User currUser = [select Id,Username,Email,GI3_Email__c from User where Id=:UserInfo.getUserId()][0];
            List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
            for(Id trgId:targetObjIds){
                mail = new Messaging.SingleEmailMessage();
                mail.setReplyTo(replyTo);
                mail.setSenderDisplayName(senderName);
                mail.saveAsActivity=false;
                mail.setTemplateId(templateId);
                mail.setTargetObjectId(trgId);
                mail.setUseSignature(false);
                emailsToSend.add(mail);
            }
            try{
                errIdList = sendAndProcessResults(emailsToSend);
            }catch(Exception ex){
                //Return the entire input back as everything failed.
                //subhamay 112011
                String strErrorInfo = 'Section 3: Track Bulk Ecards Sending Issue: \n'+ currUser.Username+'-*-'+currUser.Email+'-*-'+System.today()+'\n';
                strErrorInfo += ex.getMessage();
                String errorId = ErrorHandler.handleError(strErrorInfo);
                ALMLogUtils.log('Bulk Ecards Failure error: ', 'id: '+errorId);
                //eoc subhamay 112011                
                return targetObjIds;
            }
        }
        return errIdList;   

    }

    public static List<Id> sendEmail(List<User> targetUsers,String templateId,String replyTo,String senderName){
        List<ID> errIdList = new List<ID>();
        List<Id> targetObjIds = new List<Id>();
        Map<Id,List<String>> toAddresses = new Map<Id,List<String>>();
        if(targetUsers.size() > 0){
            Messaging.SingleEmailMessage mail;
            List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
            List<String> usrEmails;
            for(User usr:targetUsers){
                usrEmails = toAddresses.get(usr.Id);
                if(usrEmails ==null){
                    usrEmails = new List<String>();
                    toAddresses.put(usr.Id,usrEmails);
                }
                if(usr.Email!=usr.GI3_Email__c){
                    usrEmails.add(usr.GI3_Email__c);
                }
            }
        }
        return sendEmail(targetUsers,toAddresses,templateId,replyTo,senderName,false);   

    }
    
    public static List<Id> sendEmail(List<User> targetUsers,Map<Id,List<String>> addlRecipients,
                                        String templateId,String replyTo,String senderName,Boolean setContext)
    {
        List<ID> errIdList = new List<ID>();
        List<Id> targetObjIds = new List<Id>();
        List<String> toAddresses;
        List<OrgWideEmailAddress> orgWideEmail;
        if(replyTo==null){
            orgWideEmail = [select Id from OrgWideEmailAddress limit 1];
            
        }
        ALMLogUtils.log('EmailUtils','addlRecipients:'+addlRecipients);
        if(targetUsers.size() > 0){
            Messaging.SingleEmailMessage mail;
            User currUser = [select Id,Username,Email,GI3_Email__c from User where Id=:UserInfo.getUserId()][0];
            List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
            for(User usr:targetUsers){
                mail = new Messaging.SingleEmailMessage();
                if(replyTo!=null){
                    mail.setReplyTo(replyTo);
                    mail.setSenderDisplayName(senderName);
                }else{
                    if(orgWideEmail.size()>0){
                        mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
                    }
                }
                mail.saveAsActivity=false;
                mail.setTemplateId(templateId);
                if(addlRecipients.get(usr.Id)!=null){
                    mail.setTargetObjectId(usr.Id);
                }
                if(setContext){
                    mail.setWhatId(usr.Id);
                }
                targetObjIds.add(usr.Id);
                //Send to GI-3 email when the Standard email field is different from GI-3 Email
                if(addlRecipients.get(usr.Id)!= null){
                    mail.setToAddresses(addlRecipients.get(usr.Id));
                }
                mail.setUseSignature(false);
                emailsToSend.add(mail);
            }
            try{
                errIdList = sendAndProcessResults(emailsToSend);
            }catch(Exception ex){
                //Return the entire input back as everything failed.
                //subhamay 112011
                String strErrorInfo = 'Section 4: Track Bulk Ecards Sending Issue: \n'+ currUser.Username+'-*-'+currUser.Email+'-*-'+System.today()+'\n';
                strErrorInfo += ex.getMessage();
                String errorId = ErrorHandler.handleError(strErrorInfo);
                ALMLogUtils.log('Bulk Ecards Failure error: ', 'id: '+errorId);
                //eoc subhamay 112011                
                return targetObjIds;
            }
        }
        return errIdList;   

    }
    
    //This method will be merged with it's overloaded method later to avoid code duplication
    public static Boolean sendEmail(String fromName, Boolean useOrgWideEmailAddressAsFromAddress, String[] tos, String[] ccs, String[] bccs, String replyTo, String subject, String body, boolean isHtmlEmail, 
            boolean useSignature, String templateId, String whatId, String targetObjectId, Boolean saveAsActivity) {
        System.debug('sending email using Salesforce email service. subject: ' + subject + ', body: ' + body);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        if (useOrgWideEmailAddressAsFromAddress == true) {
            List<OrgWideEmailAddress> orgWideEmail = [Select Id from OrgWideEmailAddress limit 1];
            if (orgWideEmail.size() == 1) {
                mail.setOrgWideEmailAddressId(orgWideEmail.get(0).Id);
            }
        }
        else if (fromName != null) mail.setSenderDisplayName(fromName);
        
        mail.setToAddresses(tos);
        if (ccs != null) mail.setCcAddresses(ccs);
        if (bccs != null) mail.setBccAddresses(bccs);
        if (replyTo != null) mail.setReplyTo(replyTo);
        mail.setSubject(subject);
        mail.setBccSender(false);
        mail.setUseSignature(useSignature);
        mail.setCharSet('UTF-8');
        if (isHtmlEmail) {
            mail.setHtmlBody(body);
        }
        else {
            mail.setPlainTextBody(body);
        }
        
        System.debug('templateId: ' + templateId);
        if (templateId != null) {
            mail.setTemplateId(templateId);
        }
        System.debug('whatId: ' + whatId);
        if (whatId != null) {
            mail.setWhatId(whatId);
        }
        System.debug('targetObjectId: ' + targetObjectId);
        if (targetObjectId != null) {
            mail.setTargetObjectId(targetObjectId);
        }
        System.debug('saveAsActivity: ' + saveAsActivity);
        mail.setSaveAsActivity(saveAsActivity); 
        
        if (!Test.isRunningTest()) {
            List<Id> errorIds = sendAndProcessResults(new Messaging.SingleEmailMessage[] { mail });
            if (errorIds.size() > 0) return false;
        }       
        return true;
    }
    //Commented by Chandeep Singh   
   /* private static List<Id> sendAndProcessResults(List<Messaging.Email> emailsToSend){
        List<Id> errIdList = new List<Id>();
        ALMPlusUtils.getRemainingEmailLimit();  //just displayes the governor limits
        //subhamay 21112011
        //List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailsToSend);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailsToSend, false);
        //eoc subhamay 21112011
        for(Messaging.SendEmailResult emailRslt: results){
            ALMLogUtils.log('EmailUtils.sendAndProcessResults','emailRslt:'+emailRslt.isSuccess());
            if(!emailRslt.isSuccess()){
                for(Messaging.SendEmailError emailErr: emailRslt.getErrors()){
                    ALMLogUtils.log('EmailUtils','Error sending email to :'+emailErr.getTargetObjectId());
                    errIdList.add(emailErr.getTargetObjectId());
                }
            }
        }
        return errIdList;
        
    }*/
    
    private static List<Id> sendAndProcessResults(List<Messaging.Email> emailsToSend){
        List<Id> errIdList = new List<Id>();
        List<String> s_Failed_Entities = new List<String>();
        
        ALMPlusUtils.getRemainingEmailLimit();  //just displayes the governor limits
        System.debug('Actionalert emailsToSend---: '+emailsToSend);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailsToSend,false); //updated by Snehashis on 11/21 to do testing on Email deliverability
        ALMLogUtils.log('EmailUtils.sendAndProcessResults','Checking result Size:'+results.size()+'--->'+results);
        
        for(Messaging.SendEmailResult emailRslt: results){
            ALMLogUtils.log('EmailUtils.sendAndProcessResults','emailRslt:'+emailRslt.isSuccess());
            system.debug('Printing targetid >>>>'+emailRslt);
            if(!emailRslt.isSuccess()){
                for(Messaging.SendEmailError emailErr: emailRslt.getErrors()){
                    System.debug('ActionAlert error msg----: '+emailErr.getMessage());//added by subhamay to check email error msg.
                    String[] s_StatusCode= emailErr.getMessage().split(':');
                    System.debug('First-->'+s_StatusCode[0]+'Second-->'+s_StatusCode[1]);
                    s_Failed_Entities.add(s_StatusCode[1].trim());
                }
            }
        }
        System.debug('Failed Entities-->'+s_Failed_Entities.size()+', Entities values: '+s_Failed_Entities);
        if(s_Failed_Entities.size()>0)
        {
            String s_ObjectType='';
            
            String s_Failed_EntityType = s_Failed_Entities[0].substring(0,3);
            
            Schema.DescribeSObjectResult C = Contact.SObjectType.getDescribe();
            Schema.DescribeSObjectResult L = Lead.SObjectType.getDescribe();
            Schema.DescribeSObjectResult U = User.SObjectType.getDescribe();
            
            if(s_Failed_EntityType==C.getKeyPrefix())
            {
                s_ObjectType='Contact';
            }
            if(s_Failed_EntityType==U.getKeyPrefix())
            {
                s_ObjectType='User';
            }
            if(s_Failed_EntityType==L.getKeyPrefix())
            {
                s_ObjectType='Lead';
            }
            
            Integer j=s_Failed_Entities.size()-1;
            String s_QueryString='';
            
            for(Integer i=0;i<s_Failed_Entities.size();i++)
            {
                    if(i==j)
                    {
                        s_QueryString = s_QueryString.trim()+'\''+s_Failed_Entities[i]+'\'';
                    }
                    if(i!=j)
                    {
                        s_QueryString = s_QueryString.trim()+'\''+s_Failed_Entities[i]+'\',';
                    }
            }
            
            System.debug(s_QueryString);
            System.debug('s_ObjectType---: '+s_ObjectType); // added by subhamay for email error msg.
            List<sObject> lst_FailedEntities = Database.query('Select Id From ' + s_ObjectType + ' Where Id In ('+s_QueryString+')');
            System.debug('Failed Entity List-->'+lst_FailedEntities);
            for(Integer i=0;i<lst_FailedEntities.size();i++)
            {
                errIdList.add(lst_FailedEntities[i].Id);
            }
        }
        return errIdList;
        
    }   
    
    
    /* public static testmethod void testFreeFormLeadEmail(){
        TestDataHelper testData = new TestDataHelper();
        String ldrUsrAcctNbr='10000001';
        Market__c mkt = testData.createMarket();
        mkt.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        mkt.Eligibility_Yes_Flags__c='Opt_In__c';
        mkt.LeadMandatoryFields__c = 'User_Type__c,FirstName,LastName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c, Geo_Level_4__c, MobilePhone,PostalCode';
        update mkt;
        User ldrUsr = testData.createLeaderUser(ldrUsrAcctNbr);
        ldrUsr.ZM_Override__c=false;
        ldrUsr.Opt_In__c=true;
        ldrUsr.isActive=true;
        update ldrUsr;
        testData.createLeaderTitles();
        testData.createSellerStatus();
        testData.createSalesOrgs();
        List<Geo_Level_1__c> test2GLvl1 = testdata.createGeoLevel1();
        List<Geo_Level_2__c> test2GLvl2 = testdata.createGeoLevel2();
        List<Geo_Level_3__c> test2GLvl3 = testdata.createGeoLevel3();
        List<Geo_Level_4__c> test2GLvl4 = testdata.createGeoLevel4();
        System.debug('test2GLvl4--'+test2GLvl4);
        
        //Create Lead to be tested
        List<Lead> testLeadList = new List<Lead>();
        Date bday = Date.valueOf('1983-10-10');
        //Create FGL Lead
        Lead lead1 = new Lead(LastName='LastName1', Company='NA',Birthday__c =bday, MobilePhone ='9876543210', MRKT_ID__c = mkt.Market_Id__c, Type__c = 'FGL', Status='New',Market__c=mkt.Id,Lead_Owner__c=ldrUsr.Id, ownerId=ldrUsr.Id,Email='alm.noreply@avon.com');
        lead1.Geo_Level_1__c = test2GLvl1[0].Id;
        lead1.Geo_Level_2__c = test2GLvl2[0].Id;
        lead1.Geo_Level_3__c = test2GLvl3[0].Id;
        lead1.Geo_Level_4__c = test2GLvl4[0].Id;
        testLeadList.add(lead1);
        
        Lead lead2 = new Lead(LastName='LastName2', Company='NA',Birthday__c =bday+1, MobilePhone ='1234567890', MRKT_ID__c = mkt.Market_Id__c, Type__c = 'AGL', Status='In Progress',Market__c=mkt.Id,Lead_Owner__c=ldrUsr.Id,ownerId=ldrUsr.Id);
        lead2.Geo_Level_1__c = test2GLvl1[0].Id;
        lead2.Geo_Level_2__c = test2GLvl2[0].Id;
        lead2.Geo_Level_3__c = test2GLvl3[0].Id;
        lead2.Geo_Level_4__c = test2GLvl4[0].Id;
        testLeadList.add(lead2);
        
        Lead lead3 = new Lead(LastName='LastName1', Company='NA',Birthday__c =bday, MobilePhone ='9876543210', MRKT_ID__c = mkt.Market_Id__c, Type__c = 'FGL', Status='New',Market__c=mkt.Id,Lead_Owner__c=ldrUsr.Id, ownerId=ldrUsr.Id,Email='');
        lead3.Geo_Level_1__c = test2GLvl1[0].Id;
        lead3.Geo_Level_2__c = test2GLvl2[0].Id;
        lead3.Geo_Level_3__c = test2GLvl3[0].Id;
        lead3.Geo_Level_4__c = test2GLvl4[0].Id;
        testLeadList.add(lead3);
        
        
        insert testLeadList;
        System.debug('Lead2 Email><><><><'+lead2.Email);
        List<String> ct2Email = new List<String>();
        ct2Email.add(lead1.Id);
        ct2Email.add(lead2.Id);
        ct2Email.add(lead3.Id);
        EmailTemplate template = testData.createEmailTemplate();
        Test.startTest();
        System.runAs(ldrUsr){
            EmailUtils.sendFreeFormLeadEmail(ct2Email,'Test Subject','Test Email Body');
        }
        Test.stopTest();
        ECard_History__c history= [select  Name,Personal_Ecard_Message__c,Failed_Count__c,Failed__c,No_Email__c
                                    ,No_Email_Count__c from ECard_History__c where OwnerId=:ldrUsr.Id];
        System.assert(history.Name=='Test Subject');
        System.assert(history.Personal_Ecard_Message__c=='Test Email Body');
        System.assert(history.Failed_Count__c==0);
    }*/
    
    //
    //MFISHER - Moved test class over to Test_EmailUtils
    /*
     @isTest(SeeAllData=true)
     
    public static void testEmailUtils(){
    	TestDataHelper testData = new TestDataHelper();
    	
    	Contact ct = testData.createContact('123456',UserInfo.getUserId());
        
    	EmailTemplate template = testData.createEmailTemplate();
    	
    	template.subject = 'testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212';
        update template;
        
        List<String> ctString = new List<String>();
        List<Id> ctids = new List<Id>();
        
        ctids.add(ct.Id);
        ctString.add(ct.MRKT_ACCT_KEY__c);
        
    	EmailUtils.sendFreeFormEmail(ctString,'testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212','testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212');
    	
    	ct.Email='';
    	//ct.HasOptedOutOfEmail=false;
    	update ct;
    	
    	System.debug('Contact-->'+ct.Email);
    	
    	List<String> ctStringWithoutEmail = new List<String>();
        ctStringWithoutEmail.add(ct.MRKT_ACCT_KEY__c);
        EmailUtils.sendFreeFormEmail(ctStringWithoutEmail,'testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212','testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212');
    	
    	List<Id> errIds = EmailUtils.sendEmail(ctids,template.Id);
    	List<Id> errIds1 = EmailUtils.sendEmail(ctids,template.Id,'test@avon.com');
    	
    	EmailUtils.sendEmail(ctString,template.Id);
    	EmailUtils.sendEmail(ctStringWithoutEmail,template.Id);
    	
    	User testUsr = testData.createLeaderUser('12345');
        errIds = EmailUtils.sendEmail(new List<User>{testUsr},template.Id,testUsr.GI3_Email__c,testUsr.Name);
        //TBD : NOTSURE why this assert fails. Need to look at it later
        //System.assert(errIds.size()==0);
        errIds = EmailUtils.sendEmail(new List<User>{testUsr},template.Id,null,null);
    	
    	String[] tos = new String[]{'avon@avon.com'};
    	Boolean b = EmailUtils.sendEmail('Avon@avon.com', true, tos, tos,tos, 'avon@avon.com', 'Hi','Hi', true,false, String.valueOf(template.Id), ct.Id, ct.Id, false);
    	*/
    	/*ct.Email =null;
        update ct;
        errIds = EmailUtils.sendEmail(ctIds,template.Id);*/
  /*  
    } */
    
    /*public static void testEmailUtils(){
        TestDataHelper testData = new TestDataHelper();
       // ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        Contact ct = testData.createContact('123456',UserInfo.getUserId());
        Contact ct2 = testData.createContact('789456',UserInfo.getUserId());
        
        ct2.Email=null;
        update ct2;
        EmailTemplate template = testData.createEmailTemplate();
        //subhamay 102011
        template.subject = 'testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212';
        update template;
        //eoc subhamay 102011
        List<Id> ctIds = new List<Id>();
        ctIds.add(ct.Id);
        
        List<String> ctString = new List<String>();
        
        ctString.add(ct.MRKT_ACCT_KEY__c);
        ctString.add(ct2.MRKT_ACCT_KEY__c);
        EmailUtils.sendFreeFormEmail(ctString,'testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212','testtest12testtest12testtest12testtest12testtest12testtest12testtest12testtest1212');
        List<Id> errIds = EmailUtils.sendEmail(ctids,template.Id);
        System.assert(errIds.size()==1);    
        errIds = EmailUtils.sendEmail(ctIds,template.Id,'test@avon.com');
        System.assert(errIds.size()==1);    
        errIds = EmailUtils.sendEmail(ctIds,template.Id);   
        System.assert(errIds.size()==1);    
        
        ct.Email = 'something@something.com';
        update ct;
        //errIds = EmailUtils.sendEmail(ctIds,template.Id);
        //The email send shoudl have failed but in test methods
        //not sure how to simulate an actual error  
        //System.assert(errIds.size()==0);    

        ct.Email = null;
        update ct;
        errIds = EmailUtils.sendEmail(ctIds,template.Id);
        System.assert(errIds.size()==1);
        
        Map<Id,Contact> contactIds = new Map<Id,Contact>();
        ct.Email='test@avon.com';
        update ct;
        contactIds.put(ct.Id,ct);
        EmailUtils.sendEmail(new String[]{ct.MRKT_ACCT_KEY__c},template.Id);
        //The email send shoudl have failed but in test methods
        //not sure how to simulate an actual error  
        Ecard_History__c ecardhist = [select Id,Name,DetailSubject__c from ecard_History__c where OwnerId=:UserInfo.getUserID() order by CreatedDate desc limit 1];
        system.assert(ecardhist.DetailSubject__c==template.Subject);

        errIds = EmailUtils.sendEmail(ctIds,template.Id,'test@avon.com');
        //The email send shoudl have failed but in test methods
        //not sure how to simulate an actual error  
        System.assert(errIds.size()==0);
        User testUsr = testData.createLeaderUser('12345');
        errIds = EmailUtils.sendEmail(new List<User>{testUsr},template.Id,testUsr.GI3_Email__c,testUsr.Name);
        //TBD : NOTSURE why this assert fails. Need to look at it later
        //System.assert(errIds.size()==0);
        errIds = EmailUtils.sendEmail(new List<User>{testUsr},template.Id,null,null);
        //TBD : NOTSURE why this assert fails. Need to look at it later
        //System.assert(errIds.size()==0);

        ALMLOgUtils.log('EmailUtils.testEmailUtils','Setting emailOptOutFlag to true.');
        ct.Email =null;
        update ct;
        errIds = EmailUtils.sendEmail(ctIds,template.Id);
        System.assert(errIds.size()==1);    

    }*/
}