/***************************************************************************
 Name           : Test_SOQLMonitoringScheduler
 Madified By    : Barkha Jain (JDC)
 Description    : Test class for SOQLMonitoringScheduler
 Modified Date  : Nov 8, 2013                
****************************************************************************/
@isTest
private class Test_SOQLMonitoringScheduler {
	
	//----------------------------------------------------------------------------
    // Method Name  : testSOQLMonitoring
    // Description  : Method for Test Coverage of Class : SOQLMonitoringScheduler
    //----------------------------------------------------------------------------
    public static testMethod void testSOQLMonitoring() {
      Test.startTest();
      String CRON_EXPR = '0 0 0 3 9 ?';
      String jobId = System.schedule('testSOQLMonitoringSchedule', CRON_EXPR, new SOQLMonitoringScheduler());
	  Test.stopTest();
	  
	  // Get the information from the CronTrigger API object       
	  CronTrigger ct = [  SELECT id, CronExpression, TimesTriggered, NextFireTime
	              FROM CronTrigger WHERE id = :jobId];
	  
	  // Verify the expressions are the same  
	  system.assertEquals(CRON_EXPR, ct.CronExpression);
    }
}