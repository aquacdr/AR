/***************************************************************************
 Name          : Test_MyTeamReportCmpController 
 Modified By   : Parul Gupta (JDC)
 Description   : Test class for MyTeamReportCmpController
 Modified Date : Oct 29, 2013                
****************************************************************************/
@isTest
private class Test_MyTeamReportCmpController {
    private static String currentCmpgn = '201204';
    private static String priorCmpgn = '201203';
    private static String uplineAcctNr = 'upln1';
    private static String downlineOneAcctNr = 'downl1';
    private static String downlineTwoAcctNr = 'downl2';
    private static String downlineThreeAcctNr = 'downl3';
    private static String demoMktCode = 'DE';
    private static Market__c mkt;
    private static User uplineUser;
    private static Integer MaxPgLimit;
    
    //---------------------------------------------------------------------------
    // Method Name  : testMTR
    // Description  : Method for Test Coverage for MyTeamReportCmpController
    //---------------------------------------------------------------------------
    private static testMethod void testMTR(){  
        MaxPgLimit = 500;
        
        createMTRTestData(); 
        
        //XDE_Genealogy__c
        PageReference mtrPage = Page.MyTeamReport;
        Test.setCurrentPageReference(mtrPage);
        Test.startTest();
        System.runAs(uplineUser){
            Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                    WHERE CMPGN_NR__c = 201304 LIMIT 1];
            System.debug('calendar -> '+calendar);
            
            MyTeamReportCmpController mtrc = new MyTeamReportCmpController();
            mtrc.ReportType = 'MyTeamReport';
            mtrc.IsTList = false;
            
            //Load controller
            mtrc.getLoadController();

            //=============Text Search==================
            mtrc.TextSearchType.AccountNumber = uplineAcctNr;
            mtrc.PagedTeamSOQLBuilder.PageNumber = 1;
            mtrc.TextSearchType.TextSearch = downlineOneAcctNr;
            mtrc.TextSearchType.TSCriteria = 'AccountNumber';
            mtrc.TextSearchType.SortBy = 'MRKT_ACCT_KEY__r.LastName';
            mtrc.TextSearchType.IsAscending = true;
            mtrc.AF_AccountNum = uplineAcctNr;
            mtrc.AF_PageAction = '';
            mtrc.AF_SearchType = 'TextSearch';
    
            mtrc.GetPagedGenealogy();
            
            System.debug(mtrc.JSONResults);
            System.debug(mtrc.TeamPrintColumnList);
            System.debug(mtrc.GenealogyWrapperList);
            //==========================================
            
            //=============Filter==================
            mtrc.FilterSearchType.AccountNumber = uplineAcctNr;
            mtrc.PagedTeamSOQLBuilder.PageNumber = 1;
            mtrc.FilterSearchType.Who = 'All_Badge_Titles';
            mtrc.FilterSearchType.What = 'All_Data';
            mtrc.FilterSearchType.SortBy = '';
            mtrc.FilterSearchType.IsAscending = true;
            mtrc.AF_AccountNum = uplineAcctNr;
            mtrc.AF_PageAction = '';
            mtrc.AF_SearchType = 'Filter';
    
            mtrc.GetPagedGenealogy();
            
            System.debug(mtrc.JSONResults);
            System.debug(mtrc.TeamPrintColumnList);
            System.debug(mtrc.GenealogyWrapperList);
            //=====================================
            
            //=====================================
            
            //Page Action
            mtrc.AF_PageAction = 'First';
            
            mtrc.DoGenealogyPageAction();
            
            mtrc.AF_PageAction = 'Next';
            
            mtrc.DoGenealogyPageAction();
            
            mtrc.AF_PageAction = 'Previous';
            
            mtrc.DoGenealogyPageAction();
            
            mtrc.AF_PageAction = 'Last';
            
            mtrc.DoGenealogyPageAction();
            
            
           mtrc.AF_PageAction = '1';
            
            mtrc.DoGenealogyPageNumberAction();
            
          
            //Expand
            
            /*mtrc.AF_AccountNum = downlineTwoAcctNr;
            mtrc.AF_PageAction = '';
            mtrc.AF_SearchType = 'TextSearch';
    
            mtrc.ExpandGenealogy();
            
            System.debug(mtrc.JSONResults);
            System.debug(mtrc.TeamPrintColumnList);
            System.debug(mtrc.GenealogyWrapperList);*/
            
            
            mtrc.computeAttachmentId();
            mtrc.getMTReportURL();
            mtrc.getMTOReportURL();
           //Up the coverage
            SObject obj = mtrc.OriginalUserTeam;
            Boolean flag = mtrc.IsMyTeamReportType;
            String lbl = mtrc.AllLabel;
            lbl = mtrc.GenerationLabel;
            lbl = mtrc.FirstLastNameLabel;
            lbl = mtrc.LastFirstNameLabel;
            lbl = mtrc.TListLabel;
            
            MyTeamReportCmpController.MiniGenealogy mg = new MyTeamReportCmpController.MiniGenealogy();
            
            mg.AccountId = '';
            mg.Generation = '';
            mg.IsExpanded = false;
            
            //=====================================
            //GenealogySOQLBuilder
            
            
            Set<String> queryFieldSet = new Set<String>();
            List<SObject> genealogyList = null;
            
            queryFieldSet.add('Id');
            queryFieldSet.add('ACCT_NR__c');
            queryFieldSet.add('ALL_DWNLN_CNT__c');
            queryFieldSet.add('Genealogy_Level__c');
            queryFieldSet.add('UPLN_ACCT_NR__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.FirstName');
            queryFieldSet.add('MRKT_ACCT_KEY__r.LastName');
            
            String whereClause = ' OPERTNL_CMPGN_NR__c = \'' + currentCmpgn  + '\' AND ACCT_NR__c = \'' + downlineOneAcctNr + '\'' +
                                  ' AND MRKT_ID__c = \''+ 'DE' + '\'' ;
        
            Map<String,String> queryOptionsMap = new Map<String,String>();
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('ORDER BY','MRKT_ACCT_KEY__r.LastName');
        
            GenealogySOQLBuilder gsb = new GenealogySOQLBuilder('DE', downlineOneAcctNr, queryFieldSet);
            //gsb.queryFieldSet = queryFieldSet;
            
            //Where Clause Only
            genealogyList = gsb.queryNew(queryOptionsMap);
            
            //Where Clause and Order By
            queryOptionsMap.put('ORDER BY', 'MRKT_ACCT_KEY__r.FirstName');
            genealogyList = gsb.queryNew(queryOptionsMap);
            
            //Where Clause, Order By, Limit Clause
            queryOptionsMap.put('LIMIT', '1000');
            genealogyList = gsb.queryNew(queryOptionsMap);
            
            //Need access to GROUP BY or HAVING use this method?
            
            //Valid options to pass to map:
            //'WHERE', 'WITH', 'GROUP BY', 'HAVING', 'ORDER BY', 'LIMIT', 'OFFSET'
            
            
            
            //genealogyList = gsb.query(queryOptionsMap);
            
            // Not using ZeroGeneration method from GenealogySOQLBuilder
                    
            Set<String> accountNumberSet = new Set<String>();
            accountNumberSet.add(uplineAcctNr);
            //genealogyList = gsb.queryZeroGeneration(Integer.valueOf(currentCmpgn), accountNumberSet);

            //=====================================
            
            //=====================================
            //MTRConfigUtility

            MTRConfigUtility.CreatePersonalKey('DE', Integer.valueOf(currentCmpgn), uplineAcctNr);
            MTRConfigUtility.CreateBranchSummaryKey('DE', Integer.valueOf(currentCmpgn), uplineAcctNr, 'Brnch');
                
            MTRConfigUtility.GetExceptionRule('MRKT_ACCT_KEY__r.FirstName');
            MTRConfigUtility.GetExceptionRule('LDRSHP_TITL_LVL_NR__c');
            MTRConfigUtility.GetExceptionRule('LDRSHP_LOA_NR__c');
            
            if(mtrc.GenealogyWrapperList.size() > 0) {
                MTRConfigUtility.ParseExceptionRuleField('Name', 'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', mtrc.GenealogyWrapperList[0]);
                MTRConfigUtility.ParseExceptionRuleField('Name', 'MRKT_ACCT_KEY__r.FirstName', mtrc.GenealogyWrapperList[0]);
                MTRConfigUtility.ParseExceptionRuleField('LLOALOA', 'LDRSHP_LOA_NR__c, LOA_NR__c', mtrc.GenealogyWrapperList[0]);
                MTRConfigUtility.ParseExceptionRuleField('LLOALOA', 'LDRSHP_LOA_NR__c', mtrc.GenealogyWrapperList[0]);
                
                MTRConfigUtility.ReadProperty(mtrc.GenealogyWrapperList[0].Genealogy, 'Name');
                MTRConfigUtility.ReadProperty(mtrc.GenealogyWrapperList[0].Genealogy, 'MRKT_ACCT_KEY__r.FirstName');
                
                MTRConfigUtility.WriteProperty(mtrc.GenealogyWrapperList[0].Genealogy, 'Name', 'TestGenealogy1');
                MTRConfigUtility.WriteProperty(mtrc.GenealogyWrapperList[0].Genealogy, 'MRKT_ACCT_KEY__r.FirstName', 'TestGenealogy1');
            }
            
            //TList
            ApexPages.currentPage().getParameters().put('accountId', '001');
            ApexPages.currentPage().getParameters().put('acctKey', null);
            
            MTRConfigUtility.GetMTRLanguageCode(true);
            
            //Impersonation
            ApexPages.currentPage().getParameters().put('accountId', null);
            ApexPages.currentPage().getParameters().put('acctKey', '001');
            
            MTRConfigUtility.GetMTRLanguageCode(false);
            
            //No querystring
            ApexPages.currentPage().getParameters().put('accountId', null);
            ApexPages.currentPage().getParameters().put('acctKey', null);
            
            MTRConfigUtility.GetMTRLanguageCode(false);
            
            //Added by Rupayan:
            /*Boolean execBadge = MTRConfigUtility.HasExecutiveBadgeTitle(mkt.id,uplineAcctNr);
            String dateString = 'Tue Jun 05 00:00:00 GMT 2012';
            Date d = MTRConfigUtility.ConvertStringToDate(dateString);
            Map<String, Contact> acctNumContactMap = MTRConfigUtility.GetContacts(mkt.Market_Id__c,accountNumberSet);
            Boolean accExists = MTRConfigUtility.MTRUserAccountExists(true);
            Report_Config__c dummyRep = createReportConfig(mkt.id);
            DropdownComponentController dropdown= new DropdownComponentController(); 
            dropdown.userTitleNumber = '1';
            dropdown.marketId = mkt.Market_Id__c;
            dropdown.profileName = 'Avon Leader';
            dropdown.impersonate = false;
            dropdown.currentReportType = ALMConstants.REPORT_TYPE_MYTEAM_REPORT;
            List<SelectOption> l= dropdown.getDropdownSelectOptions();*/
            //=====================================
        }
        Test.stopTest();
        
    }
     
    //---------------------------------------------------------------------------
    // Method Name  : testMTROth
    // Description  : Method for Test Coverage for MyTeamReportCmpController
    //---------------------------------------------------------------------------
     private static testMethod void testMTROth(){   
        
        MaxPgLimit =2;
        createMTRTestData();
        
        PageReference mtrPage = Page.MyTeamReport;
        Test.setCurrentPageReference(mtrPage);
        ApexPages.currentPage().getParameters().put('who', 'All_Badge_Titles');
        ApexPages.currentPage().getParameters().put('campaignId','201304');
        Test.startTest();
        
        
        System.runAs(uplineUser){
            
            Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                    WHERE CMPGN_NR__c = 201304 LIMIT 1];
            
            MyTeamReportCmpController mtrc = new MyTeamReportCmpController();
            mtrc.ReportType = ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT;
            mtrc.IsTList = false;
            mtrc.getLoadController();
            mtrc.IsTList = true;
            mtrc.getLoadController();
            mtrc.provideAccountAccess();
            mtrc.computeAttachmentId();
            
            mtrc.getOmniturePageName();
            MyTeamReportCmpController.updateUserGenIndex(mkt.ALM_Rep_Indicator__c,mkt.CMPGN_NR__c,mkt.Market_Id__c,uplineAcctNr);
            
            Set<String> accountNumberSet = new Set<String>();
            accountNumberSet.add(uplineAcctNr);
            
            //Added by Rupayan:
            Boolean execBadge = MTRConfigUtility.HasExecutiveBadgeTitle(mkt.id,uplineAcctNr);
            String dateString = 'Tue Jun 05 00:00:00 GMT 2012';
            Date d = MTRConfigUtility.ConvertStringToDate(dateString);
            Map<String, Contact> acctNumContactMap = MTRConfigUtility.GetContacts(mkt.Market_Id__c,accountNumberSet);
            Boolean accExists = MTRConfigUtility.MTRUserAccountExists(true);
            Report_Config__c dummyRep = createReportConfig(mkt.id);
            DropdownComponentController dropdown= new DropdownComponentController(); 
            dropdown.userTitleNumber = '1';
            dropdown.marketId = mkt.Market_Id__c;
            dropdown.profileName = 'Avon Leader';
            dropdown.impersonate = false;
            dropdown.currentReportType = ALMConstants.REPORT_TYPE_MYTEAM_REPORT;
            List<SelectOption> l= dropdown.getDropdownSelectOptions();
         }
         Test.stopTest();
     }
    
    // Method to create report config record
    private static Report_Config__c createReportConfig(String mktId){
        
        Report_Config__c rc = TestDataHelper.createReportConfig('Team Report', mktId, 
                                    'Title_Advancement', 'Avon Leader',
                                    null, null, null, null, '1',
                                    null, maxPgLimit,
                                    true);        
        return rc;
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
    
    
    // Method creates MTR test data
    private static void createMTRTestData(){
                        
        // Create upline user
        uplineUser = TestDataHelper.createUser(uplineAcctNr, 'XZ1', 'Avon Leader', true);
        
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true); 
        Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);        
        List<Contact> lstContact = new List<Contact>();
        Integer noOfLevels = 4;
        
        // Create leader contact
        Contact leaderContact=TestDataHelper.createContact(uplineAcctNr, testAcct.id, true);
        
        // Create 2^noOfLevels account numbers        
        for (Integer accntNrIndex=0;accntNrIndex <(Math.pow(2,noOfLevels)-1);accntNrIndex++) {
           lstContact.add(TestDataHelper.createContact(uplineAcctNr + '_' + accntNrIndex, testAcct.id, false)); 
        }       
        insert lstContact;
        
        // Create market
        mkt = TestDataHelper.createMarket(demoMktCode, true);
      
        // Update user
        uplineUser.MRKT_ID__c=mkt.Market_Id__c;
        uplineUser.MRKT_ID_ACCT_NR_KEY__c=mkt.Market_Id__c+uplineAcctNr;
        update uplineUser; 
        
        // Create Genealogy records
        TestDataHelper.createGenealogyData(uplineAcctNr, mkt, noOfLevels, leaderContact, lstContact, true);
        TestDataHelper.createMarketShare(uplineUser.id, null, mkt.id, 'Edit', true);
       
        // Create report config
        Report_Config__c rc  = TestDataHelper.createReportConfig('Team Report', mkt.Id, 
                                    'Title_Advancement', 'Avon Leader',
                                    null, null, null, null, '1', null, maxPgLimit, true);        
        // Create report columns
        createReportColumns(rc.id);
        // Create report filters
        createReportFilters(rc.id);        
        // Create campaign calendars
        createCampaignCalendarRecords(mkt); 
    }
}