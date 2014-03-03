/***************************************************************************
 Name           : SchedulerDeleteOldErrorRecordsTest
 Madified By    : Barkha Jain
 Description    : Test class for SchedulerDeleteOldErrorRecords
 Modified Date  : Jan 7, 2014                
****************************************************************************/
@isTest
private class SchedulerDeleteOldErrorRecordsTest{
    
    public static testMethod void testScheduler() {
      //creating test Apex Log Setting
      TestDataHelper.createApexLogSetting(true);
        
      Test.startTest();
      String CRON_EXPR = '0 0 0 3 9 ?';
      String jobId = System.schedule('testDeleteOldErrorRecordsSchedule', CRON_EXPR, new SchedulerDeleteOldErrorRecords());
      Test.stopTest();
      
      // Get the information from the CronTrigger API object       
      CronTrigger ct = [  SELECT id, CronExpression, TimesTriggered, NextFireTime
                  FROM CronTrigger WHERE id = :jobId];
      
      // Verify the expressions are the same  
      system.assertEquals(CRON_EXPR, ct.CronExpression);
    }

}