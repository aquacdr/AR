/***************************************************************************
 Name         : Controller_SLTitleAdvancementReportTest
 Created By   : Parul Gupta
 Description  : Test class for Controller_SLTitleAdvancementReport 
 Created Date : Jan 13, 2013                
****************************************************************************/
@isTest
private class Controller_SLTitleAdvancementReportTest{
       
    private static String testReportId = '00Ox0000000fI0eEAE';
    private static User usr;
  
    //----------------------------------------------------------------------------
    // Method Name  : testTitleAdvancementController
    // Description  : Method for Test Coverage of Class : Controller_SLTitleAdvancementReport 
    //----------------------------------------------------------------------------
    static testMethod void testTitleAdvancementController() {
        // This causes a fake response to be generated
        Test.setMock(HttpCalloutMock.class, new HTTPCalloutMockImpl()); 
        
        createTestData();
        system.runAs(usr){          
        Test.startTest();          
          Controller_SLTitleAdvancementReport ctrl = new Controller_SLTitleAdvancementReport ();
          //verify result
          system.assertEquals(testReportId, ctrl.selectedReport);
          
          String argString = ctrl.getReportArguments();
          
          //verify result
          system.assert(argString.contains('pv0'));
          
          ctrl.getReportData();
          //verify result
          system.assertEquals(testReportId, ctrl.reportId);
          system.assertEquals(1, ctrl.columnsToFreeze);
          system.assert(ctrl.salesLeaderDTO.filters.size() > 0);
          
          // Verify report filters functionality
          ReportFiltersController reportFiltersCtrl = new ReportFiltersController();
          reportFiltersCtrl.filters = ctrl.salesLeaderDTO.filters;
          reportFiltersCtrl.market = ctrl.salesLeaderDTO.market;
          system.assert(reportFiltersCtrl.getCampaignList().size() > 0);
          
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