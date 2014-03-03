/*
'------------------------------------------------------------------------------------------
'Organization                       :   AVON
'Trigger/Class/Page Name            :   MessageDetailController   
'Author                             :   Cognizant 
'Developer                          :   Chandeep Singh
'Description                        :   
'Dependencies                       :   <If any, on another Class/Trigger. If it is a test class, write down the name of the class,method it is testing>    
'Change history                     :
'------------------------------------------------------------------------------------------
'   Change No.     Date            Developer       Comments
'------------------------------------------------------------------------------------------
'           
'------------------------------------------------------------------------------------------

*/

public class MyMessageDetailController {
    
    public List<COutputObject> l_get_SuccessResults {get;set;}
    public List<COutputObject> l_get_FailureResults {get;set;}
    public List<COutputObject> l_get_NoEmailResults {get;set;}
    public ALM_Global_Settings__c globalConfig {get; set;}
    public User currUsr{get;set;}
    public Market__c market{get;set;}
    
    public List<ECard_History__c> eCardHistory {get; private set;}
    
    public MyMessageDetailController(ApexPages.StandardController con){
        try{
            this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
            currUsr = [Select  Id,MRKT_ID__c,Name,LastName, LanguageLocaleKey, FirstName,MRKT_ID_ACCT_NR_KEY__c,Profile.Name,LDRSHP_TITL_LVL_NBR__c
            from User
             where   Id = :UserInfo.getUserId()]; 
     
            market = [select Id,Market_Id__c,Omniture_Suite_Name__c
            from Market__c
            where Market_Id__c =:currUsr.MRKT_ID__c];
            this.eCardHistory = [ Select 
                                    Failed__c, Failed_Count__c, Id, No_Email__c, 
                                    No_Email_Count__c, Success__c, Success_Count__c 
                                    From 
                                        ECard_History__c
                                    Where   
                                        Id =:Apexpages.currentPage().getParameters().get('id')];
            if(this.eCardHistory.size()>0){
                getRecords(this.eCardHistory);
            }
       }
        catch(Exception e){
            System.debug('Exception e-->'+e.getMessage());
        }
    }
    public MyMessageDetailController(){
        
    }
    
    public List<COutputObject> getRecords(List<ECard_History__c> l_ECardsHistory){
        try{
                for(ECard_History__c obj : l_ECardsHistory){
                    if(obj.Success__c!=null && obj.Success__c!=''){
                        getSuccessRecords(obj.Success__c);
                    }
                    if(obj.Failed__c!=null && obj.Failed__c!=''){
                        getFailureRecords(obj.Failed__c);
                    }
                    if(obj.No_Email__c!=null && obj.No_Email__c!=''){
                        getNoEmailRecords(obj.No_Email__c);
                    }
                }
        }
        catch(Exception e){
            System.debug('Exception e-->'+e.getMessage());
        }
        return null;
    }
    public List<COutputObject> getSuccessRecords(String s_Success_Records){
        try{
                l_get_SuccessResults = new List<COutputObject>();
                String[] s_Resolve_Success_String = s_Success_Records.split(';');
                if(s_Resolve_Success_String.size()>0){
                    for(Integer i=0;i<s_Resolve_Success_String.size();i++){
                        l_get_SuccessResults.add(new COutputObject(s_Resolve_Success_String[i]));   
                    } 
                }
                return l_get_SuccessResults;
        }
        catch(Exception e){
            System.debug('Exception e-->'+e.getMessage());
            return null;
        }
    }
    public List<COutputObject> getFailureRecords (String s_Failure_Records){
        try{
                l_get_FailureResults = new List<COutputObject>();
                String[] s_Resolve_Failure_String = s_Failure_Records.split(';');
                if(s_Resolve_Failure_String.size()>0){
                    for(Integer i=0;i<s_Resolve_Failure_String.size();i++){
                        l_get_FailureResults.add(new COutputObject(s_Resolve_Failure_String[i]));   
                    } 
                }
                return l_get_FailureResults;
        }
        catch(Exception e){
            System.debug('Exception e-->'+e.getMessage());
        }
        return null;
    }
    public List<COutputObject> getNoEmailRecords(String s_NoMail_Records){
        try{
                l_get_NoEmailResults = new List<COutputObject>();
                String[] s_Resolve_NoMail_String = s_NoMail_Records.split(';');
                if(s_Resolve_NoMail_String.size()>0){
                    for(Integer i=0;i<s_Resolve_NoMail_String.size();i++){
                        l_get_NoEmailResults.add(new COutputObject(s_Resolve_NoMail_String[i]));    
                    } 
                }
                return l_get_NoEmailResults;
        }
        catch(Exception e){
            System.debug('Exception e-->'+e.getMessage());
        }
        return null;
    }
    
    public class COutputObject
    {
        public String s_Name {get;set;}
        public String s_Phone {get;set;}
        public String s_Email {get;set;}
        public String s_OptOut {get;set;}
        
        public COutputObject(String s_Concatenated_Value)
        {   if(s_Concatenated_Value!=null){
                String[] s_Fields = s_Concatenated_Value.split(',');
                if(s_Fields.size()>0){
                    for(Integer i=0;i<s_Fields.size();i++){
                        String [] s_FieldValues = s_Fields[i].split(':');
                        if(s_FieldValues[0].trim()==System.Label.Name){
                                s_Name = (s_FieldValues[1].trim()!=null) ? s_FieldValues[1].trim():'';
                            }
                        if(s_FieldValues[0].trim()==System.Label.Phone){
                                s_Phone = (s_FieldValues[1].trim()!=null) ? s_FieldValues[1].trim():'';
                            }
                        if(s_FieldValues[0].trim()==System.Label.eMail2){
                                s_Email = (s_FieldValues[1].trim()!=null) ? s_FieldValues[1].trim():'';
                            }
                        if(s_FieldValues[0].trim()==System.Label.Opted_Out){
                                s_OptOut = (s_FieldValues[1].trim()!=null) ? ((s_FieldValues[1].trim()=='Y') ? 'Y' :'N' ):'N';
                            }
                    }
                }
            }                       
        }
    }
    public String getOmniturePageName()         
   {return ALMPlusUtils.generateOmniturePageName('MyMessageDetail', null, currUsr.Profile.Name);    }
   
   
 }