@isTest
public class GenealogyFilterControllerTest 
{
    private static testMethod void testGenerateMTRExcel()
    {
        TestDataHelper testData =   new TestDataHelper();
        Market__c mrkt = testData.createMarket();
        update  mrkt;
        
        User testUsr = testData.createLeaderUser('U123456');       
        testUsr.LDRSHP_TITL_LVL_NBR__c='1';
        update testUsr;
                
        mrkt.OwnerId = testUsr.Id;
        update mrkt;
                
        Report_Config__c rpc=new Report_Config__c(Market__c=mrkt.Id, Report_Type__c = 'Title_Advancement');
        insert rpc;
        
        Report_Filter__c abc=new Report_Filter__c(Name='testfilter',Filter_Key__c='All_Badge_Titles',Report_Config__c=rpc.Id,Filter_Type__c='Who');
        insert abc;
        Report_Filter__c abc1=new Report_Filter__c(Name='testfilter',Filter_Key__c='G1_Candidate',Report_Config__c=rpc.Id,Filter_Type__c='What');
        insert abc1;
        
        /*
        Report_Filter__c abc2=new Report_Filter__c(Name='testfilter',Filter_Key__c='Leader_Downline_Summary__r:TSRP_GRP_UNIT_SLS__c,SPPY_TSRP_GRP_UNIT_SLS__c',Report_Config__c=rpc.Id,Filter_Type__c='What');
        insert abc2;
        */
        
        Calendar__c cal=new Calendar__c(Market__c=mrkt.Id, CMPGN_NR__c=201304 /*,PRIOR_CMPGN_NR__c='201302'*/);
        insert cal;
        
        
        Leader_Title__c leaderTitle = new Leader_Title__c ( LANG_CD__c='en_US', LCL_LDRSHP_TITL_LANG_DESC_TXT__c='Title 01',
                                                      LDRSHP_TITL_LVL_NR__c='2', Market__c=mrkt.Id, MRKT_ID__c = mrkt.Market_Id__c,
                                                      LCL_LDRSHP_TITL_CD__c = 'SEL');
        insert leaderTitle;
        
        
        DownloadAll_GenIndex__c downldAllGnIndx = new DownloadAll_GenIndex__c ( Accnt_Nr__c = testUsr.ACCT_NR__c, Data_Object_Name__c = mrkt.ALM_Rep_Indicator__c,
                                                                                Gen_Index__c = 0, Market_Id__c = mrkt.Market_Id__c, SelectedCampaign__c = mrkt.CMPGN_NR__c);
        insert downldAllGnIndx;
        
        System.runAs(testUsr)
        {
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
            
            ECard_History__c ech=new ECard_History__c(Success__c='testsuccessstring',Failed__c='testfailstring',No_Email__c='testnoemailstring');
            insert ech;
            
            ApexPages.currentPage().getParameters().put('id', ech.Id);
            Contact c=testData.createContact('U123456',testUsr.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(c);
            MyMessageDetailController testmdc=new MyMessageDetailController(sc);
            
            System.assert(gfc.CampaignList.size() == 1);
        }
        
        
        System.runAs(testUsr)
        {
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
            
            System.assert(gfc.CampaignList.size() == 1);
            
        }
        
    }
}