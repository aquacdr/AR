/***************************************************************************
 Name         : Test_ActionAlertBatch 
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ActionAlertBatch
 Created Date : Oct. 24, 2013                
****************************************************************************/
@isTest
private class Test_ActionAlertBatch {
	
	//----------------------------------------------------------------------------
    // Method Name  : testActionAlertBatch
    // Description  : Method for Test Coverage of Class : ActionAlertBatch
    //----------------------------------------------------------------------------
	public static testmethod void testActionAlertBatch(){
		//create custom setting
		TestDataHelper.createALMGlobalSetting(true);
		
		Profile profile = [Select Id, Name from Profile where Name Like '%Avon Leader%' limit 1];
      	//create test user
      	User user = TestDataHelper.createUser('1', profile.Id, false);
      	user.Action_Alert_Enabled__c = true;
      	user.Action_Alert_Time__c = system.now().hour();
      	user.MRKT_ID__c = '1234';
      	user.SMS_Address__c = 'test@avon.com';
      	user.Action_Alert_1__c = 'Orders Not submitted';
        user.Action_Alert_Frequency__c = 'Daily';
        user.Action_Alert_View__c = 'Selling Month';
        user.MRKT_ID_ACCT_NR_KEY__c = '1234';
      	insert user;
		
		//create test market
		Market__c mrkt = TestDataHelper.createMarket('test market', '1234', false);
        mrkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        mrkt.Mail_Plan_Enabled__c = true;
        mrkt.CMPGN_NR__c = '1234567';
        insert mrkt;
        
        //create test account
        Account acc = TestDataHelper.createAccount('test', 'USD', true);
        //create test contact
        Contact con = TestDataHelper.createContact('1234', acc.Id, true);
        
        System.runAs(user){
	        TestDataHelper.createActionItem('Item 1', 'Downline', 'Leader', 'Rising Stars', 'Coaching Others', 'GRP_RISNG_STAR_CNT__c', 'Number', true);
	        TestDataHelper.createRepPerformance(con.Id, mrkt, '1234', true);
	        
	        Test.startTest();
	        ActionAlertBatch alertBatch = new ActionAlertBatch();
	        Database.executeBatch(alertBatch, 200);
	        Test.stopTest();
        }
        
        //verify result
        List<Action_Alert__c> alerts = [select Id,Type__c from Action_Alert__c where OwnerId =:user.Id];
        if(alerts.size() > 0) {
            System.assert(alerts.size() == 1);
            System.assert(alerts[0].Type__c == 'Orders Not submitted');
        }
    }
}