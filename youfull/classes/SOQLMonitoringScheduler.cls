/**
* To run this scheduler every 5 hours copy paste the below code
* in developer Console
* SOQLMonitoringScheduler soqlM = new SOQLMonitoringScheduler();
* String cronStr = '0 0,5, * * *';
* System.schedule('SOQLMonitoringScheduler', cronStr , soqlM);
* 
**/

global class SOQLMonitoringScheduler implements Schedulable{
  global SOQLMonitoringScheduler(){ }
    global void execute(SchedulableContext sc) {
        SOQLMonitoringBatch soqlBatch = new SOQLMonitoringBatch(); 
        database.executebatch(soqlBatch);
     }
     
     //@S-144891 : Commented by Blaine Rothrock on Nov 23
     /*public static testMethod void testSOQLMonitoring() {
      Test.startTest();
      String CRON_EXPR='0 0 0 3 9 ? 2022';
      TestDataHelper testData = new TestDataHelper();
	  String jobId = System.schedule('testSOQLMonitoringSchedule',
	                    CRON_EXPR, new SOQLMonitoringScheduler());
	  // Get the information from the CronTrigger API object       
	  CronTrigger ct = [  SELECT id, CronExpression, TimesTriggered, NextFireTime
	              FROM CronTrigger 
	              WHERE id = :jobId];
	  // Verify the expressions are the same  
	        
	  System.assertEquals(CRON_EXPR, ct.CronExpression);
	  // Verify the job has not run  
	  System.assertEquals(0, ct.TimesTriggered);
	  Test.stopTest();
	  }*/
     
 }