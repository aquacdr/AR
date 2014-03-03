/***************************************************************************
 Name         : Test_ActionAlertScheduler 
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ActionAlertScheduler
 Created Date : Oct. 24, 2013                
****************************************************************************/
@isTest
private class Test_ActionAlertScheduler {
	
	//---------------------------------------------------------------------------
    // Method Name  : testActionAlerts
    // Description  : Method for Test Coverage of Class : ActionAlertScheduler
    //---------------------------------------------------------------------------
	public static testMethod void testActionAlerts() {
    	Test.startTest();
    	String CRON_EXPR='0 0 0 3 9 ? 2022';
    	
		String jobId = System.schedule('testActionAlertBatchSchedule', CRON_EXPR, new ActionAlertScheduler());
		
		// Get the information from the CronTrigger API object  
		CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
						  FROM CronTrigger 
						  WHERE id = :jobId];
		
		// Verify the expressions are the same  
		System.assertEquals(CRON_EXPR, ct.CronExpression);
		
		// Verify the job has not run  
		System.assertEquals(0, ct.TimesTriggered);
    	Test.stopTest();
    }
}