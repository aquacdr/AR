/***************************************************************************
 Name          : Test_RecordBuilder
 Created By    : Barkha Jain (JDC)
 Description   : Test class for RecordBuilder
 Created Date  : Nov 6, 2013                
****************************************************************************/
@isTest
private class Test_RecordBuilder {
	
	//----------------------------------------------------------------------------
    // Method Name  : testRecordBuilder
    // Description  : Method for Test Coverage of Class : RecordBuilder
    //----------------------------------------------------------------------------
    static testMethod void testRecordBuilder() {
    	User usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
    	usr.LDRSHP_TITL_LVL_NBR__c = '1';
    	insert usr;
    	
    	Business_Plan_Parameter__c pParam = new Business_Plan_Parameter__c(Name = 'Test Param');
    	Business_Plan__c bp = new Business_Plan__c(Mrkt_Id_Acct_Nr_Key__c = 'DE1234', Market_Id__c = 'DE' );
    	
        System.runAs(usr){
        	insert pParam;
        	
        	bp.Business_Plan_Parameter__c = pParam.Id;
        	insert bp;
        }
        
        Test.startTest();
        Map<String, String> fieldValues = RecordBuilder.buildRecord(bp.Id);
        //verify result
        system.assert(fieldValues.get('Mrkt_Id_Acct_Nr_Key__c') == 'DE1234');
        Test.stopTest();
    }
}