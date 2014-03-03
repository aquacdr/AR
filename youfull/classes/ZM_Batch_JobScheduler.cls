/**
  Reusable job scheduler which can schedule any batch apex. 
  
  Shah Kadirmohideen - 9/25/2011 - Created
  Rupayan Basu    - 1/11/2013 - Migrated
*/
global class ZM_Batch_JobScheduler implements Schedulable { 
  private Database.Batchable<SObject> batchApexObject;
  private Integer batchSize;
  
  //Public constructor used to pass the batch apex object which is later used to invoke.
  public ZM_Batch_JobScheduler(Database.Batchable<SObject> batchApexObject, Integer batchSize) {
    this.batchApexObject = batchApexObject;
    this.batchSize = batchSize;
  }
  
  //Private constructor is used to avoid creating instance of this class without passing 
  //any value for the batchApexObject variable
  private ZM_Batch_JobScheduler() {
    //do nothing
  }
   
  //Execute method which contains the logic to invoke the batch apex code based on the batchApexObject variable.
    global void execute(SchedulableContext sc) {
    Database.executebatch(batchApexObject, batchSize);
    }
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*@isTest
    static void runTest()
    {
    	Database.Batchable<SObject> b;
    	
    	ZM_Batch_JobScheduler bs = new ZM_Batch_JobScheduler(b, 1);
    	Datetime sysTime = System.now();
         sysTime = sysTime.addSeconds(20);
         String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
         SchedulableContext sc;
         try{
         	bs.execute(sc);
         }
         catch(Exception e){}
   	     System.schedule('Test_ZM_Batch_JobScheduler - ' + sysTime.getTime(), chron_exp, bs);
    }*/
}