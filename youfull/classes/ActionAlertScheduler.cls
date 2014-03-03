global class ActionAlertScheduler implements Schedulable{
	global ActionAlertScheduler(){ }
    global void execute(SchedulableContext sc) {
        ActionAlertBatch alertBatch = new ActionAlertBatch(); 
        database.executebatch(alertBatch);
   	}
   
//@S-144891 : Commented by Blaine Rothrock on Nov 23    
   /*public static testMethod void testActionAlerts() {
    	Test.startTest();
    	String CRON_EXPR='0 0 0 3 9 ? 2022';
    	TestDataHelper testData = new TestDataHelper();
		String jobId = System.schedule('testActionAlertBatchSchedule',
										CRON_EXPR, new ActionAlertScheduler());
		// Get the information from the CronTrigger API object  
		    
		CronTrigger ct = [	SELECT id, CronExpression, TimesTriggered, NextFireTime
							FROM CronTrigger 
							WHERE id = :jobId];
		// Verify the expressions are the same  
		    
		System.assertEquals(CRON_EXPR, ct.CronExpression);
		// Verify the job has not run  
		System.assertEquals(0, ct.TimesTriggered);
    	Test.stopTest();
    }*/
}