/***************************************************************************
 Name          : JobDeleteOldErrorRecords 
 Description   : Batch that wipes out old Error_Message__c data
 Created By    : Barkha Jain 
 Created Date  : Jan 7, 2014                
****************************************************************************/
global class JobDeleteOldErrorRecords implements Database.Batchable<sObject>{
    private Integer maxAllowedRecords;
    private String query = '';
    
    //Default constructor
    global JobDeleteOldErrorRecords (){
        ApexLogSettings__c logSetting = ApexLogSettings__c.getInstance('Default');
        maxAllowedRecords = Integer.valueOf(logSetting.MaxRecords__c);
        
        Integer maxDays = Integer.valueOf(logSetting.MaxDays__c);
        query = 'Select Id From Error_Message__c where CreatedDate < LAST_N_DAYS:'+maxDays;             
    }
    
    //parametric constructor with query string
    global JobDeleteOldErrorRecords(String queryStr){
        query = queryStr;
    }
    
    //Start the batch
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){     
        delete scope;
    }
    
    //finish the batch
    global void finish(Database.BatchableContext BC){
        Integer recordCount = [select count() from Error_Message__c];
        
        //if no. of records greater than maximum allowed records
        if(recordCount > maxAllowedRecords){
            Integer countForDeletion = recordCount - maxAllowedRecords;
            String queryStr = 'Select Id from Error_Message__c Order By CreatedDate limit '+countForDeletion;
            
            //execute batch again to delete extra records
            JobDeleteOldErrorRecords deleteBatch = new JobDeleteOldErrorRecords(queryStr); 
            database.executebatch(deleteBatch);
        }
    }

}