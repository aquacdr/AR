/***************************************************************************
 Name         : JobDeleteOldErrorRecordsTest
 Created By   : Barkha Jain (JDC)
 Description  : Test class for JobDeleteOldErrorRecords
 Created Date : Jan 7, 2014                
****************************************************************************/
@isTest
private class JobDeleteOldErrorRecordsTest{
    
    //----------------------------------------------------------------------------
    // Method Name  : testDeleteOldErrorRecordsBatch
    // Description  : Method for Test Coverage of Class : JobDeleteOldErrorRecords
    //----------------------------------------------------------------------------
    public static testmethod void testDeleteOldErrorRecordsBatch(){ 
        //creating test Apex Log Setting
        TestDataHelper.createApexLogSetting(true);
        
        //creating test Error Messages records
        List<Error_Message__c> errMsgsLst = new List<Error_Message__c>();
        for(Integer i=0; i<10; i++){
            errMsgsLst.add(TestDataHelper.createErrorMessage('Test', 'Test Error'+i, false));
        }
        insert errMsgsLst;
        
        Test.startTest();
        //test batch code
        JobDeleteOldErrorRecords deleteBatch = new JobDeleteOldErrorRecords();
        Database.executeBatch(deleteBatch, 200);
        Test.stopTest();
        
        //verify result
        system.assertEquals(5, [select count() from Error_Message__c]);
    }   
    
}