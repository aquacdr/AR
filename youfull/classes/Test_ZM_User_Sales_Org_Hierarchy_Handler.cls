/***************************************************************************
 Name         : Test_ZM_User_Sales_Org_Hierarchy_Handler
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_User_Sales_Org_Hierarchy_Handler
 Created Date : Oct 29, 2013                
****************************************************************************/
@isTest
private class Test_ZM_User_Sales_Org_Hierarchy_Handler {
	
	//----------------------------------------------------------------------------
    // Method Name  : testUSOHierarchy
    // Description  : Method for Test Coverage of Class : ZM_User_Sales_Org_Hierarchy_Handler
    //----------------------------------------------------------------------------
    static testMethod void testUSOHierarchy() {
        Profile profile = [select id from profile where name like '%System Administrator%'];
        //create the user
        User usr = TestDataHelper.createUser('1', profile.Id, false);
		usr.MRKT_ID__c = '62';
		usr.ACCT_NR__c = '12345';
		insert usr;
		
		//create or retrieve the group
		Group g = new Group( Name = 'Mrkt '+usr.MRKT_ID__c+' Z '+usr.ACCT_NR__c, Type = 'Regular');
		insert g;
		
		system.runAs(usr){
			//create the market
			Market__c mkt = TestDataHelper.createMarket('test market', 'DE', false);
	        mkt.CMPGN_NR__c = '201302';
	        mkt.NEXT_1_CMPGN_NR__c = '201303';
	        mkt.PREV_1_CMPGN_NR__c = '201301';
	        insert mkt;
	                    
			//create the User_Sales_Org_Hierarchy__c record
			User_Sales_Org_Hierarchy__c u = new User_Sales_Org_Hierarchy__c();
			u.SLS_ORG_LVL_CD__c = 'Z';
			u.SLS_ORG_CD__c = '111';
			u.Market__c = mkt.Id; 
			u.MRKT_ID__c = '62';
			u.MRKT_ID_ACCT_NR_SLS_ORG_KEY__c = '620000000129660111'; 
	        u.ACCT_NR__c = '12345';
	        
	        Test.startTest();
	        //call the insert method
	        insert u;
			//verify results
			system.assert([select count() from GroupMember] > 0);
			
			//call the delete method
			delete u;
			Test.stopTest();
		}
    }
}