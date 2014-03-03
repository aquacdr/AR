/***************************************************************************
 Name          : Controller_SLMyTeamOrdersReportTest
 Created By    : Barkha Jain
 Description   : Test class for Controller_SLMyTeamOrdersReport and SalesLeader_DTO
 Created Date  : Jan 13, 2014                
****************************************************************************/
@isTest
private class Controller_SLMyTeamOrdersReportTest{
    private static String testReportId = '00Ox0000000fI0eEAE';
    private static User usr;
    
    //----------------------------------------------------------------------------
    // Method Name  : testMyTeamOrdersController
    // Description  : Method for Test Coverage of Class : Controller_SLMyTeamOrdersReport
    //----------------------------------------------------------------------------
    static testMethod void testMyTeamOrdersController() {
        // This causes a fake response to be generated
        Test.setMock(HttpCalloutMock.class, new HTTPCalloutMockImpl());
        
        PageReference pg = Page.SLMyTeamOrdersReport;
        pg.getParameters().put('CampaignNumber', '201314');
        Test.setCurrentPage(pg);
        
        createTestData();
        system.runAs(usr){          
            Test.startTest();
            
            Controller_SLMyTeamOrdersReport ctrl = new Controller_SLMyTeamOrdersReport();
            //verify result
            system.assert(ctrl.reportList.size() > 0);
            system.assertEquals(testReportId, ctrl.selectedReport);
            
            String argString = ctrl.getReportArguments();
            //verify result
            system.assert(argString.contains('pv0'));
            system.assert(ctrl.salesLeaderDTO.showFilters);
            system.assert(ctrl.salesLeaderDTO.filterLogic.contains('1 AND 2 AND 3'));
            
            ctrl.getReportData();
            //verify result
            system.assertEquals(testReportId, ctrl.reportId);
            system.assertEquals(1, ctrl.columnsToFreeze);
            
            ctrl.doNothing();
            Test.stopTest();
        }
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : createTestData
    // Description  : Method to create dummy data for testing
    //----------------------------------------------------------------------------
    static void createTestData(){
        String acctNbr = '123456';
        String marketId = 'XX';
        
        //creating test user
        usr = TestDataHelper.createUser(acctNbr, 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = marketId;
        usr.MRKT_ID_ACCT_NR_KEY__c = marketId + acctNbr;
        insert usr;
        
        Market__c mkt = TestDataHelper.createMarket(marketId, true);        
        
        Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);   
        Contact con1 = TestDataHelper.createContact(acctNbr, testAcct.Id, false);       
        con1.MRKT_ACCT_KEY__c = marketId + acctNbr;
        insert con1;
        
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(con1.Id, mkt, acctNbr, false);
        rep1.Genealogy_Key__c = marketId + mkt.CMPGN_NR__c + acctNbr;
        insert rep1;
        
        ZM_Report_Translation__c z = TestDataHelper.createReportTranslation('Test Report', testReportId, marketId, 1, 
                                      usr.LanguageLocaleKey, 'My Team Orders;Title Advancement', 'Avon Leader', true);
        
    }
}