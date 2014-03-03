/***************************************************************************
 Name         : Test_ZM_SalesOrgSummaryTriggerHandler
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_SalesOrgSummaryTriggerHandler
 Created Date : Oct 29, 2013                
****************************************************************************/
@isTest
private class Test_ZM_SalesOrgSummaryTriggerHandler {
	
	//----------------------------------------------------------------------------
    // Method Name  : testSalesOrgTrigger
    // Description  : Method for Test Coverage of Class : ZM_SalesOrgSummaryTriggerHandler
    //----------------------------------------------------------------------------
    static testMethod void testSalesOrgTrigger() {
    	UserRole u = TestDataHelper.createUserRole('Mrkt DE Z 201 Owner', null, true);
        Profile zoneManagerProfile = [select id from profile where name = 'Avon Mkt 62 Zone Manager'];
        
        //creating test user
        User user = TestDataHelper.createUser('1', zoneManagerProfile.Id, false);
        user.UserRoleId = u.id;
        user.MRKT_ID__c = 'DE';
        user.DFALT_ZONE_CD__c = 'DEZ01';
        user.DFALT_DIV_NM__c = 'TestDivision';
        user.ACCT_NR__c = '01';
        insert user;
        
        list<Sales_Org_Summary__c> lstSalesOrgSummary = new list<Sales_Org_Summary__c>();
        System.runAs(user){
	        //creating test market
	        Market__c mkt = TestDataHelper.createMarket('test market', 'DE', false);
	        mkt.CMPGN_NR__c = '201211';
	        mkt.NEXT_1_CMPGN_NR__c = '201211';
	        mkt.PREV_1_CMPGN_NR__c = '201211';
	        insert mkt;
	        
	        //creating test Sales_Org_Summary__c records
	        lstSalesOrgSummary.add(TestDataHelper.createSalesOrSummaries('201211 Sales Org Summary', user.Id, mkt.Id, 'DE201303ZDEZ01', '201211', false));
	        lstSalesOrgSummary.add(TestDataHelper.createSalesOrSummaries('201211 Sales Org Summary1', user.Id, mkt.Id, 'DE201302ZDEZ01', '201211', false));
	        lstSalesOrgSummary[1].SLS_ORG_LVL_DESC_TXT__c = 'D';
	        
	        Test.startTest();
	        insert lstSalesOrgSummary;        
	        Test.stopTest();
        }
        
        //verify results
        Sales_Org_Summary__c soss = [select id, ownerid from Sales_Org_Summary__c where id = :lstSalesOrgSummary[0].id];
        system.assertEquals(user.id, soss.ownerid);
        
        soss = [select id, ownerid, ZONE_MGR__c from Sales_Org_Summary__c where id = :lstSalesOrgSummary[1].id];
        system.assertEquals(soss.ZONE_MGR__c, soss.ownerid);        
    }
}