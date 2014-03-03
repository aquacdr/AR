/***************************************************************************
 Name          : Test_GenerateMTRExcelController
 Modified By   : Barkha Jain (JDC)
 Description   : Test class for GenerateMTRExcelController
 Modified Date : Oct 31, 2013                
****************************************************************************/
@isTest
private class Test_GenerateMTRExcelController{

    private static String currentCmpgn = '201304';
    private static String priorCmpgn = '201303';
    private static String uplineAcctNr = 'upln1';
    private static String demoMktCode = 'DE';
    private static Market__c mkt;
    private static User uplineUser;
    
    /*
        Scenario:
        uplineUser has 2 people in the downline: downlineUser1 and downlineUser2
    */
    private static testMethod void testGenerateMTRExcel(){
        createMTRTestData();
        
        PageReference mtrPage = Page.MyTeamReport;
        Test.setCurrentPageReference(mtrPage);
        
        System.runAs(uplineUser){
            Test.startTest();        
            GenerateMTRExcelController gmec = new GenerateMTRExcelController();
            MyTeamReportCmpController.DownloadDTO downloadDTO = new MyTeamReportCmpController.DownloadDTO();
        
            downloadDTO.ReportTitle = 'Team Report';
            downloadDTO.ReportType = ALMConstants.REPORT_TYPE_MYTEAM_REPORT;
            downloadDTO.ZGenAccountId = uplineAcctNr;
            downloadDTO.SFDCMarketId = mkt.Id;
            downloadDTO.userTitleLevelNbr = uplineUser.LDRSHP_TITL_LVL_NBR__c;
            downloadDTO.profileName = 'Avon Leader';
            downloadDTO.CampaignId = MTRSOQLBuilder.MakeCampaignKey(Integer.valueOf(priorCmpgn), Integer.valueOf(currentCmpgn));
            downloadDTO.ReportDownloadName = 'Download';
            downloadDTO.ReportDownloadName = 'Download';
            gmec.DownloadInfo = JSON.serialize(downloadDTO);
            gmec.DownloadWYSIWYGExcel();
            gmec.CompleteExcelDownload();
            gmec.GetAvonMarketId(mkt.Id);
            
            Test.stopTest();
        }
        
    }
    
    // Method creates MTR test data
    private static void createMTRTestData(){
                        
        // Create upline user
        uplineUser = TestDataHelper.createUser(uplineAcctNr, 'XZ1', 'Avon Leader', true);
        
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true); 
        Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);        
        List<Contact> lstContact = new List<Contact>();
        Integer noOfLevels = 4;
        
        // Create leader contact
        Contact leaderContact = TestDataHelper.createContact(uplineAcctNr, testAcct.id, true);
        
        // Create 2^noOfLevels account numbers
        for (Integer accntNrIndex = 0; accntNrIndex <(Math.pow(2,noOfLevels)-1); accntNrIndex++) {
           lstContact.add(TestDataHelper.createContact(uplineAcctNr + '_' + accntNrIndex, testAcct.id, false)); 
        }       
        insert lstContact;
       
        // Create market
        Market__c userMkt = TestDataHelper.createMarket(uplineAcctNr, true);
        mkt = TestDataHelper.createMarket(demoMktCode, true);
      
        // Update user
        uplineUser.MRKT_ID__c = mkt.Market_Id__c;
        uplineUser.MRKT_ID_ACCT_NR_KEY__c = mkt.Market_Id__c+uplineAcctNr;
        update uplineUser; 
        
        // Create Genealogy records
        TestDataHelper.createGenealogyData(uplineAcctNr, mkt, noOfLevels, leaderContact, lstContact, true);
        TestDataHelper.createMarketShare(uplineUser.id, null, mkt.id, 'Edit', true);
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        
        // LEADER
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(lstContact[0].Id, mkt, uplineAcctNr, false);
        rep1.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'06';
        rep1.DWNLN_ONLY_IND__c = 'N';
        rep1.Genealogy_Level__c = 0;
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 8;
        lstRepPerf.add(rep1);
        
        ALM_Rep_Performance_1__c rep11 = TestDataHelper.createRepPerformance(lstContact[0].Id, mkt, uplineAcctNr, false);
        rep11.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.PREV_1_CMPGN_NR__c + uplineAcctNr+'09';
        rep11.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c);
        rep11.OPERTNL_CMPGN_NR__c = mkt.PREV_1_CMPGN_NR__c;
        rep11.DWNLN_ONLY_IND__c = 'Y';
        rep11.Genealogy_Level__c = 0;
        rep11.LFT_ND_ID__c = 1;
        rep11.RGT_ND_ID__c = 8;
        lstRepPerf.add(rep11);
        
        ALM_Rep_Performance_1__c rep2 = TestDataHelper.createRepPerformance(lstContact[1].Id, mkt, uplineAcctNr+'01', false);
        rep2.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'08';
        rep2.DWNLN_ONLY_IND__c = 'N';
        rep2.Genealogy_Level__c = 1;
        rep2.LFT_ND_ID__c = 2;
        rep2.RGT_ND_ID__c = 7;
        lstRepPerf.add(rep2);
        
        ALM_Rep_Performance_1__c rep21 = TestDataHelper.createRepPerformance(lstContact[1].Id, mkt, uplineAcctNr+'01', false);
        rep21.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.PREV_1_CMPGN_NR__c + uplineAcctNr+'01';
        rep21.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c);
        rep21.OPERTNL_CMPGN_NR__c = mkt.PREV_1_CMPGN_NR__c;
        rep21.DWNLN_ONLY_IND__c = 'Y';
        rep21.Genealogy_Level__c = 1;
        rep21.LFT_ND_ID__c = 2;
        rep21.RGT_ND_ID__c = 7;
        lstRepPerf.add(rep21);
        
        ALM_Rep_Performance_1__c rep3 = TestDataHelper.createRepPerformance(lstContact[2].Id, mkt, uplineAcctNr+'02', false);
        rep3.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'07';
        rep3.DWNLN_ONLY_IND__c = 'N';
        rep3.Genealogy_Level__c = 2;
        rep3.LFT_ND_ID__c = 3;
        rep3.RGT_ND_ID__c = 6;
        lstRepPerf.add(rep3);
        
        ALM_Rep_Performance_1__c rep31 = TestDataHelper.createRepPerformance(lstContact[2].Id, mkt, uplineAcctNr+'02', false);
        rep31.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.PREV_1_CMPGN_NR__c + uplineAcctNr+'02';
        rep31.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c);
        rep31.OPERTNL_CMPGN_NR__c = mkt.PREV_1_CMPGN_NR__c;
        rep31.DWNLN_ONLY_IND__c = 'Y';
        rep31.Genealogy_Level__c = 2;
        rep31.LFT_ND_ID__c = 3;
        rep31.RGT_ND_ID__c = 6;
        lstRepPerf.add(rep31);
                                            
        ALM_Rep_Performance_1__c rep4 = TestDataHelper.createRepPerformance(lstContact[3].Id, mkt, uplineAcctNr+'03', false);
        rep4.Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'03';
        rep4.DWNLN_ONLY_IND__c = 'N';
        rep4.Genealogy_Level__c = 3;
        rep4.LFT_ND_ID__c = 4;
        rep4.RGT_ND_ID__c = 5;
        lstRepPerf.add(rep4);
        insert lstRepPerf;
       
        // Create report config
        Report_Config__c rc  = TestDataHelper.createReportConfig('Team Report', mkt.Id, 
                                    'Title_Advancement', 'Avon Leader',
                                    null, null, null, null, '1', null, 500, true);   
        // Create report print     
        TestDataHelper.createReportPrint(demoMktCode, 3, 800, 600, true);
        // Create report columns
        createReportColumns(rc.id);
        // Create report filters
        createReportFilters(rc.id);        
        // Create campaign calendars
        createCampaignCalendarRecords(mkt); 
    }
    
    
    // Method to create campaign calendar records
    private static void createCampaignCalendarRecords(Market__c mrkt){
        List<Calendar__c> campaignCalendarList = new List<Calendar__c>();
       
        Calendar__c cal = TestDataHelper.createCalendar(Decimal.valueOf(mrkt.CMPGN_NR__c), mrkt.Market_Id__c, null, mrkt.Id, false);
        cal.CURRNT_IND__c = 'Y';
        cal.PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c; 
        campaignCalendarList.add(cal);
        cal = TestDataHelper.createCalendar(Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c), mrkt.Market_Id__c, null, mrkt.Id, false);
        cal.PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c; 
        campaignCalendarList.add(cal);
        cal = TestDataHelper.createCalendar(Decimal.valueOf(mrkt.NEXT_1_CMPGN_NR__c), mrkt.Market_Id__c, null, mrkt.Id, false);
        cal.PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c; 
        campaignCalendarList.add(cal);      
        insert campaignCalendarList;      
    }
    
    // Method to create report columns
    private static void createReportColumns(String reportConfigId){
        
        List<Report_Column_New__c> rcList = new List<Report_Column_New__c>();
        rcList.add(TestDataHelper.createReportColumn(reportConfigId, 'Name',
                             1, 'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', 
                             'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', 'Frozen',
                             'Text', 'Always Displayed', false));
        rcList.add(TestDataHelper.createReportColumn(reportConfigId, 'LLOA / LOA',
                             2, 'LDRSHP_LOA_NR__c, LOA_NR__c', 
                             null, 'Scrollable',
                             'Text', 'Default Shown', false));                                                   
        rcList.add(TestDataHelper.createReportColumn(reportConfigId, 'Badge Title',
                             3, 'LDRSHP_TITL_LVL_NR__c', 
                             null, 'Scrollable',
                             'Text', 'Default Shown', false));
        insert rcList;      
    }
    
    // Method to create report filters
    private static void createReportFilters(String reportConfigId){
        List<Report_Filter__c> rfList = new List<Report_Filter__c>();
        rfList.add(TestDataHelper.createReportFilter(reportConfigId, 'All Badge Titles', 
                                            'LDRSHP_TITL_LVL_NR__c != \'-999\'', 
                                            'All', 'Who', 'All_Badge_Titles', '', false));
        rfList.add(TestDataHelper.createReportFilter(reportConfigId, 
                                'All Data', 'LDRSHP_TITL_LVL_NR__c != \'-999\'', 
                                'All', 'What', 'All_Data', '', false));     
        insert rfList;      
    }
}