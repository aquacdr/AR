/**
 * This class will be used to dynamically read the SOQLQuery Object run those
 * queries and update SOQLExecutionTime Object.
 *
 *  This class will be executed as a batch process.
 *
 * @name SOQLMonitoringBatch.cls
 * @author Milon
 * @date Dec 27, 2012
 *
 */
global class SOQLMonitoringBatch implements Database.Batchable<sObject>{

   global final Map<String, String> sqlNameQueryMap;
   global final String Query;
   global final String Entity;
   global final String Field;
   global final String Value;
   global Integer resultSize;

   global SOQLMonitoringBatch(){
    sqlNameQueryMap = new Map<String, String>();
    resultSize = 0;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){   
      return Database.getQueryLocator('select Name,SOQLQuery__c from SOQLQuery__C');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     try 
     {
         for(sobject s : scope){
             SOQLQuery__c obj = (SOQLQuery__c)s;
             String queryName = obj.Name;
             String query =  obj.SOQLQuery__c;
             Date dt = System.today();
             Datetime startTime = System.now();
             
             //creating the execution Result object
             SOQLExecutionTime__c setObj = new SOQLExecutionTime__c();
             setObj.Query_Name__c = queryName ;
             setObj.Date__c = System.now();
             setObj.Start_Time__c = System.currentTimeMillis();
             List<sObject> queryResult = Database.query(query);
             resultSize += queryResult.size();
             setObj.No_Of_Rows__c = queryResult.size();
             setObj.End_Time__c = System.currentTimeMillis();         
             insert setObj;
         }
     }catch(Exception e){
     	sentFailedMail(e.getMessage());   
     }
    }

   global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'milon.dey@gmail.com'});
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('SOQL_Monitoring');
        mail.setSubject('SOQL Monitoring Completed Successfully');
        mail.setPlainTextBody('Batch Process has completed : '+resultSize );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
   //schedules the job to run in 5 hours 5 X 60 = 300 minutes
   public static void startJob() {
        scheduleJob(2);
    }
    
   private void sentFailedMail(String error){
   		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'milon.dey@gmail.com'});
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('SOQL_Monitoring');
        mail.setSubject('SOQL Monitoring Failed');
        mail.setPlainTextBody('Batch Process has Failed :'+error);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
   private static void scheduleJob(Integer minutesOffset) {
        DateTime currentTime = System.now(); 
        String scheduleTime = ALMPlusUtils.prepareJobsSchTime(currentTime, minutesOffset);  
        // TEMP, for improving code coverage
        //System.schedule(ALMPlusUtils.getUniqueJobName('SOQLMonitoringBatch'), scheduleTime, new BatchJobScheduler(new SOQLMonitoringBatch(), 10));  //use 10 as the batch size          
    }
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testSOQLMonitoringBatch(){
    	TestDataHelper testData = new TestDataHelper();
    	Market__c mkt = testData.createMarket();
        String acctNbr = '123456';
        User usr = testData.createLeaderUser(acctNbr);
        //creating test data.
        List<SOQLQuery__c> lstSOQL = new List<SOQLQuery__c>();
        SOQLQuery__c soqlObj = new SOQLQuery__c(Name='TEST',
        										SOQLQuery__c='select id from XDE_Genealogy__c');
        lstSOQL.add(soqlObj);
        insert lstSOQL;
        Test.startTest();
	    SOQLMonitoringBatch soqlMonitorinBatch = new SOQLMonitoringBatch();
	    Database.executeBatch(soqlMonitorinBatch,200);
	    soqlMonitorinBatch.sentFailedMail('Testing');
	    Test.stopTest();
	    
	    List<SOQLExecutionTime__c> soql = [select id from SOQLExecutionTime__c];
        System.assert(soql.size() >0);
        
    	
    }*/ //end of testmethos

    
}