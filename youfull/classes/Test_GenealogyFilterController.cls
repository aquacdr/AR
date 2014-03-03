/***************************************************************************
 Name          : Test_GenealogyFilterController
 Modified By   : Barkha Jain (JDC)
 Description   : Test class for GenealogyFilterController
 Modified Date : Oct 31, 2013                
****************************************************************************/
@isTest
public class Test_GenealogyFilterController {
    
    //----------------------------------------------------------------------------
    // Method Name  : testGenealogyFilterCtrl
    // Description  : Method for Test Coverage of Class : GenealogyFilterController
    //----------------------------------------------------------------------------
    private static testMethod void testGenealogyFilterCtrl(){
        //create test user
        User testUsr = TestDataHelper.createUser('U123456', 'XZ1', 'Avon Leader', true);       
        
        //create test market        
        Market__c mrkt;       
        System.runAs(testUsr){
            mrkt = TestDataHelper.createMarket('DE', true);
        }
        //crete test report cofig       
        Report_Config__c rpc = TestDataHelper.createReportConfig('config 1', mrkt.Id, 'Title_Advancement', null, 
                                                        null, null, null, null, null, null, null, true);
        
        //create report filters      
        List<Report_Filter__c> reportFilters = new List<Report_Filter__c>();
        reportFilters.add(TestDataHelper.createReportFilter(rpc.Id, 'testfilter', null, null, 'Who', 'All_Badge_Titles', '1', false));
        reportFilters.add(TestDataHelper.createReportFilter(rpc.Id, 'testfilter1', null, null, 'What', 'G1_Candidate', '2', false));
        insert reportFilters;
        
        Calendar__c cal = TestDataHelper.createCalendar(201304, 'DE', null, mrkt.Id, true);
        Leader_Title__c leaderTitle = TestDataHelper.createLeaderTitle(mrkt.Id, 'DE', true);
        
        Test.startTest();
        System.runAs(testUsr){
            ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true); 
            Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
            Contact c = TestDataHelper.createContact('U123456', acc.Id, true);
            
            GenealogyFilterController gfc = new GenealogyFilterController();
            gfc.isMailPlan = true;
            gfc.ReportConfigId = rpc.Id;
            gfc.CurrentCampaign = 201304;
            gfc.FutureCampaign = 201304;
            gfc.InternalSelectedCampaignId = String.valueOf(201304);
            gfc.SFDC_MarketId = mrkt.Id;
            gfc.LangCD = testUsr.LanguageLocaleKey;
            gfc.NumberOfHistoricalCampaigns = 1;
            gfc.getLoadController();
            gfc.RefreshFilters();
            gfc.getRefreshcamnparam();
            gfc.getPriorCampaign(201209);
            
            ECard_History__c ech = new ECard_History__c(Success__c = 'testsuccessstring', Failed__c = 'testfailstring', No_Email__c = 'testnoemailstring');
            insert ech;
            ApexPages.currentPage().getParameters().put('id', ech.Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(c);
            MyMessageDetailController testmdc = new MyMessageDetailController(sc);
            //verify result
            system.assert(gfc.CampaignList.size() == 1);
        }
        
        System.runAs(testUsr){
            GenealogyFilterController gfc = new GenealogyFilterController();
            gfc.ReportConfigId = rpc.Id;
            gfc.CurrentCampaign = 201304;
            gfc.FutureCampaign = 201305;
            gfc.isMailPlan = true;
            gfc.InternalSelectedCampaignId = String.valueOf(201305);
            gfc.SFDC_MarketId = mrkt.Id;
            gfc.LangCD = testUsr.LanguageLocaleKey;
            gfc.NumberOfHistoricalCampaigns = 1;
            gfc.getLoadController();
            //verify result
            system.assert(gfc.CampaignList.size() == 1);            
        }
        Test.stopTest();
       
    }
}