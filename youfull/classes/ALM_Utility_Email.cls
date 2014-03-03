/***************************************************************************
 Name          : ALM_Utility_Email
 Created By    : Barkha Jain
 Description   : Util class for all mail sending items  
 Created Date  : Feb 12, 2014               
****************************************************************************/
public without sharing class ALM_Utility_Email{
    
    private static String PERSONAL_ECARD = 'Personal_ECard';
    
    public static void sendFreeFormEmail(List<String> repAcctList, String subj, String msgDetail){
        Map<Id,Contact> targetObjIds = new Map<Id,Contact>();
        
        List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        EmailTemplate temp = [select HtmlValue,Body from EmailTemplate where Id=:globalConfig.Personal_Email_Template_Id__c];//hardcode id by manas for migration
        User currUser = [select Id,Profile.Name,MobilePhone,Phone,Name,Username,Email,GI3_Email__c from User where Id = :UserInfo.getUserId()][0];
        
        String htmlBody = temp.HtmlValue;
        msgDetail.replace('SLNAME', currUser.Name);
        htmlBody = htmlBody.replace('$Dear',System.Label.Dear);
        htmlBody = htmlBody.replace('$EmailContent',msgDetail.replace('\n','<br/>'));
        htmlBody = htmlBody.replace('$User.Name',UserInfo.getName());
        htmlBody = htmlBody.replace('$User.MobilePhone',(currUser.MobilePhone != null ? currUser.MobilePhone : (currUser.Phone != Null ? currUser.Phone : '')));
        htmlBody = htmlBody.replace('$User.Profile',currUser.Profile.Name);
        htmlBody = htmlBody.replace('$Disclaimer',System.Label.Personal_ECard_Disclaimer);
        htmlBody = htmlBody.replace('$Click_Here',System.Label.Click_Here);
        htmlBody = htmlBody.replace('$Personal_Ecard_Optout_PostFix',System.Label.Personal_Ecard_Optout_PostFix);
        
        String msgHtml;
        List<Id> errIdList = new List<Id>();
        List<Id> eContactNoEmail = new List<Id>();
        List<String> s_Failed_Contacts = new List<String>();
        for(Contact ct: [   Select Id, Name, Representative_Phone__c, Email, HasOptedOutOfEmail 
                            from Contact 
                            where MRKT_ACCT_KEY__c in : repAcctList]) {
            Messaging.SingleEmailMessage mail;
            if(!ct.HasOptedOutOfEmail){
                msgHtml = htmlBody;
                targetObjIds.put(ct.Id, ct);
                mail = new Messaging.SingleEmailMessage();
                mail.setReplyTo(currUser.GI3_Email__c);
                mail.saveAsActivity = false;
                msgHtml = msgHtml.replace('$Contact.Name',ct.Name);
                mail.setHtmlBody(msgHtml);
                mail.setSubject(subj);
                mail.setUseSignature(false);
                if(ct.Email != null && ct.Email != ''){
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
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailsToSend, false);
        
        for(Messaging.SendEmailResult emailRslt : results){
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
         
         if(s_Failed_Contacts.size()>0){
            Integer j=s_Failed_Contacts.size()-1;
            String s_QueryString='';
            for(Integer i=0;i<s_Failed_Contacts.size();i++){
                if(i==j){
                    s_QueryString = s_QueryString.trim()+'\''+s_Failed_Contacts[i]+'\'';
                }
                if(i!=j){
                    s_QueryString = s_QueryString.trim()+'\''+s_Failed_Contacts[i]+'\',';
                }                    
            }
            List<Contact> lst_FailedContacts = Database.query('Select Id From Contact Where Id In ('+s_QueryString+')');
            for(Integer i=0;i<lst_FailedContacts.size();i++){
                errIdList.add(lst_FailedContacts[i].Id);
            }
         }         
         processErrors(errIdList,targetObjIds,null,subj,msgDetail,eContactNoEmail);
    }
    
    public static void sendEmail(List<String> repAcctList, String templateId){
        Map<Id,Contact> targetObjIds = new Map<Id,Contact>();
        
        for(Contact ct: [Select Id, Name, Representative_Phone__c, Email, HasOptedOutOfEmail 
                         from Contact where MRKT_ACCT_KEY__c in : repAcctList]) {
            targetObjIds.put(ct.Id,ct);
        }
        sendEmail(targetObjIds,templateId);
    }
 
    public static void sendEmail(Map<Id,Contact> contactIdMap, String templateId){
        List<Id> repsToEmail = new List<Id>();
        List<Id> errorIds = new List<Id>();
        List<Id> eContactNoEmail = new List<Id>();
        
        //Optin functionality addition
        String fldName = [Select Folder.name from EmailTemplate where id = :templateId].Folder.Name ;
        ALMLogUtils.log('EmailUtils.sendEmail(Map,templateId)','>>>>>>>> This is Opt in Folder name'+fldName);
        for(Id repId : contactIdMap.keySet()){
            if(contactIdMap.get(repId).Email != null && (!contactIdMap.get(repId).HasOptedOutOfEmail || fldName.contains('_OPTIN'))){
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
        errorIds.addAll(sendEmail(repsToEmail, templateId));
        processErrors(errorIds, contactIdMap, templateId, null, null, eContactNoEmail);
    }
    
    private static void processErrors( List<Id> errIdList,Map<Id,Contact> contactIdMap,
                                       String templateId,String subject,String msgBody,List<Id> eContactNoEmail){
        //For Reps that errored out, remove them from the original list
        //subhamay 102011
        String strTempSubject = '';
        //eoc subhamay 102011
        Map<Id, Contact> errRepDetails = new Map<Id, Contact>();
        
        //added by CS to capture list of contacts with no email.
        Map<Id, Contact> errorContactNoEmails = new Map<Id, Contact>();
        
        for(Id ctId : errIdList){
            errRepDetails.put(ctId,contactIdMap.get(ctId));
            contactIdMap.remove(ctId);
        }
        
        if(eContactNoEmail.size() > 0){
            for(Id ctId : eContactNoEmail){
                errorContactNoEmails.put(ctId,contactIdMap.get(ctId));
                contactIdMap.remove(ctId);
            }
        }
        
        EmailTemplate template;
        if(templateId != null){
            template = [select Subject, Description from EmailTemplate where Id = :templateId];
        }
        
        String successMsg = '';
        String failMsg = '';
        String noEmail = '';
            
        if(errRepDetails.values() != null){
            for(Contact ct : errRepDetails.values()){
                ALMLogUtils.log('EmailUtils.processErrors','Failed To sent Email to Rep:'+ct);
                failMsg += System.Label.Name +':'+ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                        ', '+System.Label.eMail2+': '+(ct.Email==null?'':ct.Email)+','+System.Label.Opted_Out+': '+(ct.HasOptedOutOfEmail==true?System.Label.Yes:System.Label.No)+';';
            }
        }
        
        if(errorContactNoEmails.values() != null){
            for(Contact ct : errorContactNoEmails.values()){
               noEmail += System.Label.Name +':'+ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
                        ', '+System.Label.eMail2+': '+(ct.Email==null?'':ct.Email)+','+System.Label.Opted_Out+': '+(ct.HasOptedOutOfEmail==true?System.Label.Yes:System.Label.No)+';';
            }
        }
        
        if(contactIdMap.values() != null){
            for(Contact ct : contactIdMap.values()){
                successMsg += System.Label.Name +':'+ct.Name+', '+System.Label.Phone+': '+(ct.Representative_Phone__c==null?'':ct.Representative_Phone__c)+
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
        ECard_History__c ecardHistory = new ECard_History__c( OwnerId = UserInfo.getUserId(),
                                                            //subhamay 102011
                                                            Name = strTempSubject,
                                                            DetailSubject__c = (template != null ? template.Subject : ''),
                                                            //eoc subhamay 102011
                                                            Success__c = successMsg,
                                                            Status__c = 'Sent',
                                                            Success_Count__c = contactIdMap.values().size(),
                                                            Failed_Count__c = errRepDetails.values().size(),
                                                            No_Email_Count__c = errorContactNoEmails.values().size(),
                                                            Failed__c = failMsg,
                                                            No_Email__c = noEmail
                                                            );
        //Set the Subject and Message detail if passed 
        if(subject != null){
            //subhamay 102011
            ecardHistory.DetailSubject__c = subject; 
            if(subject.length() > 80){ 
                ecardHistory.Name = subject.substring(0, 80);
            } else {
                ecardHistory.Name = subject;
            }
            //subhamay 102011
        }
        if(msgBody != null){
            eCardHistory.Personal_Ecard_Message__c = msgBody;
        }
        ALMLogUtils.log('EmailUtils.processErrors','ecardhistory:'+ecardHistory);
        insert ecardHistory;
    }
    
    public static List<Id> sendEmail(List<ID> targetObjIds, String templateId){
        List<ID> errIdList = new List<ID>();
        if(targetObjIds.size() > 0){
            Messaging.SingleEmailMessage mail;
            User currUser = [select Id, Username, Email,GI3_Email__c from User where Id = :UserInfo.getUserId()][0];
            List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
            for(Id trgId : targetObjIds){
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
    
    public static List<Id> sendEmail(List<Id> targetObjIds, String templateId, String replyTo){
        return sendEmail(targetObjIds, templateId, replyTo, replyTo);  
    }

    public static List<Id> sendEmail(List<Id> targetObjIds, String templateId, String replyTo, String senderName){
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
    
     public static List<Id> sendEmail(List<User> targetUsers, String templateId, String replyTo, String senderName){
        List<ID> errIdList = new List<ID>();
        List<Id> targetObjIds = new List<Id>();
        Map<Id,List<String>> toAddresses = new Map<Id,List<String>>();
        if(targetUsers.size() > 0){
            Messaging.SingleEmailMessage mail;
            List<Messaging.Email> emailsToSend = new List<Messaging.Email>();
            List<String> usrEmails;
            for(User usr : targetUsers){
                usrEmails = toAddresses.get(usr.Id);
                if(usrEmails == null){
                    usrEmails = new List<String>();
                    toAddresses.put(usr.Id,usrEmails);
                }
                if(usr.Email != usr.GI3_Email__c){
                    usrEmails.add(usr.GI3_Email__c);
                }
            }
        }
        return sendEmail(targetUsers, toAddresses, templateId, replyTo, senderName, false);   

    }
    
    public static List<Id> sendEmail(List<User> targetUsers,Map<Id,List<String>> addlRecipients,
                                        String templateId,String replyTo,String senderName,Boolean setContext){
        List<ID> errIdList = new List<ID>();
        List<Id> targetObjIds = new List<Id>();
        List<String> toAddresses;
        List<OrgWideEmailAddress> orgWideEmail;
        if(replyTo == null){
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
    
    public static Boolean sendEmail(String fromName, Boolean useOrgWideEmailAddressAsFromAddress, String[] tos, String[] ccs, String[] bccs, String replyTo, String subject, String body, boolean isHtmlEmail, 
            boolean useSignature, String templateId, String whatId, String targetObjectId, Boolean saveAsActivity) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        if (useOrgWideEmailAddressAsFromAddress == true) {
            List<OrgWideEmailAddress> orgWideEmail = [Select Id from OrgWideEmailAddress limit 1];
            if (orgWideEmail.size() == 1) {
                mail.setOrgWideEmailAddressId(orgWideEmail.get(0).Id);
            }
        }
        else if (fromName != null) 
            mail.setSenderDisplayName(fromName);
        
        if (ccs != null) 
            mail.setCcAddresses(ccs);
        if (bccs != null) 
            mail.setBccAddresses(bccs);
        if (replyTo != null) 
            mail.setReplyTo(replyTo);
        
        mail.setToAddresses(tos);        
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
        if (templateId != null) {
            mail.setTemplateId(templateId);
        }
        if (whatId != null) {
            mail.setWhatId(whatId);
        }
        if (targetObjectId != null) {
            mail.setTargetObjectId(targetObjectId);
        }
        mail.setSaveAsActivity(saveAsActivity); 
        
        if (!Test.isRunningTest()) {
            List<Id> errorIds = sendAndProcessResults(new Messaging.SingleEmailMessage[]{mail});
            if (errorIds.size() > 0) 
                return false;
        }       
        return true;
    }
    
    private static List<Id> sendAndProcessResults(List<Messaging.Email> emailsToSend){
        List<Id> errIdList = new List<Id>();
        List<String> s_Failed_Entities = new List<String>();
        
        ALMPlusUtils.getRemainingEmailLimit();  //just displayes the governor limits
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailsToSend,false); //updated by Snehashis on 11/21 to do testing on Email deliverability
        ALMLogUtils.log('EmailUtils.sendAndProcessResults','Checking result Size:'+results.size()+'--->'+results);
        
        for(Messaging.SendEmailResult emailRslt: results){
            ALMLogUtils.log('EmailUtils.sendAndProcessResults','emailRslt:'+emailRslt.isSuccess());
            if(!emailRslt.isSuccess()){
                for(Messaging.SendEmailError emailErr : emailRslt.getErrors()){
                    String[] s_StatusCode = emailErr.getMessage().split(':');
                    s_Failed_Entities.add(s_StatusCode[1].trim());
                }
            }
        }
        if(s_Failed_Entities.size() > 0){
            String s_ObjectType = '';            
            String s_Failed_EntityType = s_Failed_Entities[0].substring(0,3);            
            Schema.DescribeSObjectResult C = Contact.SObjectType.getDescribe();
            Schema.DescribeSObjectResult L = Lead.SObjectType.getDescribe();
            Schema.DescribeSObjectResult U = User.SObjectType.getDescribe();
            
            if(s_Failed_EntityType == C.getKeyPrefix()){
                s_ObjectType = 'Contact';
            }
            if(s_Failed_EntityType == U.getKeyPrefix()){
                s_ObjectType = 'User';
            }
            if(s_Failed_EntityType == L.getKeyPrefix()){
                s_ObjectType = 'Lead';
            }
            
            Integer j = s_Failed_Entities.size()-1;
            String s_QueryString = '';
            
            for(Integer i = 0; i < s_Failed_Entities.size(); i++){
                if(i == j){
                    s_QueryString = s_QueryString.trim()+'\''+s_Failed_Entities[i]+'\'';
                }
                if(i != j){
                    s_QueryString = s_QueryString.trim()+'\''+s_Failed_Entities[i]+'\',';
                }
            }
            
            List<sObject> lst_FailedEntities = Database.query('Select Id From ' + s_ObjectType + ' Where Id In ('+s_QueryString+')');
            for(Integer i = 0; i < lst_FailedEntities.size(); i++){
                errIdList.add(lst_FailedEntities[i].Id);
            }
        }
        return errIdList;        
    }
}