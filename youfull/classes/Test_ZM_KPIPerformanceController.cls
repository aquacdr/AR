/***************************************************************************
 Name         : Test_ZM_KPIPerformanceController
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_KPIPerformanceController
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_ZM_KPIPerformanceController {
	static List<Sales_Org_Summary__c> lstSalesOrgSummary;
	static User zoneUser;
	static User divisionUser;
	
	//----------------------------------------------------------------------------
    // Method Name  : testKPIPerformance
    // Description  : Method for Test Coverage of Class : ZM_KPIPerformanceController
    //----------------------------------------------------------------------------
    static testMethod void testKPIPerformance() {
        createTestData();
        
        Test.StartTest();
        //test controller
        ApexPages.StandardController objController = new ApexPages.StandardController(lstSalesOrgSummary[0]);
        ZM_KPIPerformanceController con;
        System.runAs(zoneUser) {
            con = new ZM_KPIPerformanceController(objController);
            con.changeData();
            //verify result
            system.assertEquals(2, con.zoneKPIConfigTLSize);
            system.assertEquals(1, con.lstLastCampaign.size());
            system.assertEquals(1, con.lstCurrentCampaign.size());
            system.assertEquals(1, con.lstNextCampaign.size());
        }
        
        System.runAs(divisionUser) {
            con = new ZM_KPIPerformanceController(objController);
            con.changeData();
            
            //verify result
            system.assertEquals(0, con.lstLastCampaign.size());
            system.assertEquals(0, con.lstCurrentCampaign.size());
            system.assertEquals(0, con.lstNextCampaign.size());
            system.assertNotEquals(null, con.getOmniturePageName());
        }
        
        Test.StopTest();
        
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : createTestData
    // Description  : Method to create test data
    //----------------------------------------------------------------------------
    public static void createTestData(){
    	Profile zoneManagerProfile = [select id from profile where name = 'Avon Mkt 62 Zone Manager'];
        Profile divisionManagerProfile = [select id from profile where name = 'Avon Mkt 62 Division Manager'];
        
        //craeting test user role records
        UserRole u = TestDataHelper.createUserRole('Market DE (Demo)', null, true);
        UserRole u1 = TestDataHelper.createUserRole('TestDivision', u.Id, true);
        UserRole u2 = TestDataHelper.createUserRole('Zone DEZ01 Manager', u1.Id, true);
        UserRole u3 = TestDataHelper.createUserRole('Zone DEZ01 Owner', u2.Id, true);
        
        //creating test user records
        List<User> userLst = new List<User>();
        User donotUser = TestDataHelper.createUser('1', zoneManagerProfile.Id, false);
        donotUser.UserRoleId = u3.id;
        donotUser.MRKT_ID__c = 'DE';
        donotUser.DFALT_ZONE_CD__c = '201';
        donotUser.DFALT_DIV_NM__c = 'TestDivision';
        donotUser.ACCT_NR__c = '01';
        userLst.add(donotUser);
       
        zoneUser = TestDataHelper.createUser('2', zoneManagerProfile.Id, false);
        zoneUser.UserRoleId = u2.id;
        zoneUser.MRKT_ID__c = 'DE';
        zoneUser.DFALT_ZONE_CD__c = '201';
        zoneUser.DFALT_DIV_NM__c = 'TestDivision';
        zoneUser.ACCT_NR__c = '02';
        userLst.add(zoneUser);
        
        divisionUser = TestDataHelper.createUser('3', divisionManagerProfile.Id, false);
        divisionUser.UserRoleId = u1.id;
        divisionUser.MRKT_ID__c = 'DE';
        divisionUser.DFALT_ZONE_CD__c = '201';
        divisionUser.DFALT_DIV_NM__c = 'TestDivision';
        divisionUser.ACCT_NR__c = '03';
        userLst.add(divisionUser);
        insert userLst;
        
        system.runAs(donotUser){
        	//creating test market records
	        Market__c mkt = TestDataHelper.createMarket('test market', 'DE', false);
	        mkt.CMPGN_NR__c = '201302';
	        mkt.NEXT_1_CMPGN_NR__c = '201303';
	        mkt.PREV_1_CMPGN_NR__c = '201301';
	        insert mkt;
        
        	//creating test ZM_ZoneKPIConfig__c records
	        List<ZM_ZoneKPIConfig__c> zoneConfigLst = new List<ZM_ZoneKPIConfig__c>();
	        zoneConfigLst.add(TestDataHelper.createZoneKPIConfig('APPT0', 'Appointments', null, false));
	        zoneConfigLst.add(TestDataHelper.createZoneKPIConfig('APPT1', 'Appointments', 'APPT0', false));
	        zoneConfigLst.add(TestDataHelper.createZoneKPIConfig('APPT2', 'Appointments', 'APPT1', false));
	        zoneConfigLst.add(TestDataHelper.createZoneKPIConfig('APPT3', 'Appointments', null, false));
	        zoneConfigLst.add(TestDataHelper.createZoneKPIConfig('APPT4', 'Appointments', 'APPT3', false));
	        zoneConfigLst.add(TestDataHelper.createZoneKPIConfig('APPT5', 'Appointments', 'APPT4', false));
	        insert zoneConfigLst;
	        
	        //creating test ZM_MarketZoneKPIConfig__c records
	        List<ZM_MarketZoneKPIConfig__c> marketConfigLst = new List<ZM_MarketZoneKPIConfig__c>();
	        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 1', 'APPT0', mkt.id, '1', 'KPI Summary 1;Compass', null, false, 12, false));
	        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 2', 'APPT1', mkt.id, '2', 'KPI Summary 1;Compass;', null, false, 12, false));
	        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 3', 'APPT2', mkt.id, '3', 'KPI Summary 1;Compass;TL;', null, false, 12, false));
	        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 4', 'APPT3', mkt.id, '1', 'KPI Summary 2;Compass', null, false, 12, false));
	        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 5', 'APPT4', mkt.id, '2', 'KPI Summary 2;Compass;', null, false, 12, false));
	        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 6', 'APPT5', mkt.id, '3', 'KPI Summary 2;Compass;TL;', null, false, 12, false));  
	        insert marketConfigLst;
        	
        	//creating test Sales_Org_Summary__c records
	        lstSalesOrgSummary = new list<Sales_Org_Summary__c>();
	        lstSalesOrgSummary.add(TestDataHelper.createSalesOrSummaries('testSales', zoneUser.Id, mkt.Id, 'DE201303ZDEZ01', '201301', false));
	        lstSalesOrgSummary.add(TestDataHelper.createSalesOrSummaries('testSales1', zoneUser.Id, mkt.Id, 'DE201302ZDEZ01', '201302', false));
	        lstSalesOrgSummary.add(TestDataHelper.createSalesOrSummaries('testSales2', zoneUser.Id, mkt.Id, 'DE201301ZDEZ01', '201303', false)); 
        	insert lstSalesOrgSummary; 		
        }
          
    } 
}