@isTest
private class MyTeamReportCmpControllerTest {
    private static TestDataHelper tdh = new TestDataHelper();
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
    
    /*
        Scenario:
        uplineUser has 2 people in the downline: downlineUser1 and downlineUser2
    */
    
    private static testMethod void testMTRCreateData(){
        //create market
        mkt = tdh.createMarket(demoMktCode);
        //create upline user
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            uplineUser = tdh.createLeaderUser(uplineAcctNr);
        }
        //tdh.createAccount();
        //create contact, personal perf. downline summary
        //Contact c = createContact(mkt, uplineAcctNr, uplineUser.Id);
        //tdh.createContact(uplineAcctNr, uplineUser.Id);
        
        
        /*
        
        tdh.createListContact(new List<String>{uplineAcctNr}, uplineUser.Id);
        tdh.createMyBusiness(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        tdh.createLdrDwnSumm(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        //create download users
        User downlineOneUser;
        User downlineTwoUser;
        User downlineThreeUser;
        System.runAs ( thisUser ) {
            downlineOneUser = tdh.createLeaderUser(downlineOneAcctNr);
            downlineTwoUser = tdh.createLeaderUser(downlineTwoAcctNr);
            downlineThreeUser = tdh.createLeaderUser(downlineThreeAcctNr);
        }
        
        //create genealogy, personal perf. downline summary for downline users 
        tdh.createGenealogyData(downlineOneAcctNr, uplineUser.Id, uplineAcctNr);
        tdh.createGenealogyData(downlineTwoAcctNr, uplineUser.Id, uplineAcctNr);
        tdh.createGenealogyData(downlineThreeAcctNr, uplineUser.Id, downlineTwoAcctNr);
        
        //Add badge titles and downline only indicator
        List<My_Business__c> ppList = [SELECT Id, ACCT_NR__c, DWNLN_ONLY_IND__c, LDRSHP_TITL_LVL_NR__c FROM My_Business__c
                                                WHERE ACCT_NR__c IN (:uplineAcctNr, :downlineOneAcctNr, :downlineTwoAcctNr, :downlineThreeAcctNr)];
        
        
        for(My_Business__c mb: ppList) {
            
            if(mb.ACCT_NR__c == uplineAcctNr || mb.ACCT_NR__c == downlineTwoAcctNr) {
                mb.DWNLN_ONLY_IND__c = 'N';
            }
            else if(mb.ACCT_NR__c == downlineOneAcctNr || mb.ACCT_NR__c == downlineThreeAcctNr) {
                mb.DWNLN_ONLY_IND__c = 'Y';
            }
            
            mb.LDRSHP_LOA_NR__c = 1.0;
            mb.LOA_NR__c = 1.0;
            mb.LDRSHP_TITL_LVL_NR__c = '1';
        }
        
        update ppList;
        
        */
        
        
        tdh.createGenealogyData(uplineAcctNr, uplineUser.Id, 3);
        
        /*
        
        Account testAcct = new Account(Name='Test Acount');
        insert testAcct;
        
        List<Contact> lstContact = new List<Contact>();
        Date apptDate = date.parse('12/27/2009');
        Contact con1    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=uplineAcctNr,
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'First1',LastName=uplineAcctNr+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr, MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=uplineUser.Id,
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con1);
                                          
        Contact con2    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=uplineAcctNr+'01',
                                            Email='test2@avon.com',FirstName=uplineAcctNr+'01'+'First2',LastName=uplineAcctNr+'01'+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'01' , MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=uplineUser.Id, REP_BRTH_DT__c =System.today()
                                          );
        
        lstContact.add(con2); 
        
        Contact con3    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=uplineAcctNr+'02',
                                            Email='test3@avon.com',FirstName=uplineAcctNr+'02'+'First3',LastName=uplineAcctNr+'02'+'Last3',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'02', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=uplineUser.Id, REP_BRTH_DT__c =System.today()
                                          );
        
        lstContact.add(con3);
        
        Contact con4    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=uplineAcctNr+'03',
                                            Email='test3@avon.com',FirstName=uplineAcctNr+'03'+'First4',LastName=uplineAcctNr+'03'+'Last4',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                         //   LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'03', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=uplineUser.Id, REP_BRTH_DT__c =System.today()
                                          );
        
        lstContact.add(con4);
        
        insert lstContact;   
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        
        // LEADER
        
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,
                                                DWNLN_ONLY_IND__c = 'N'
                                            );
        lstRepPerf.add(rep1);
        ALM_Rep_Performance_1__c rep11 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.PREV_1_CMPGN_NR__c + uplineAcctNr,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,
                                                DWNLN_ONLY_IND__c = 'Y'
                                            );
        lstRepPerf.add(rep11);
                                        
        ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'01' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7,
                                                DWNLN_ONLY_IND__c = 'N'
                                            );
        lstRepPerf.add(rep2);
        ALM_Rep_Performance_1__c rep21 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'01' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.PREV_1_CMPGN_NR__c + uplineAcctNr+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7,
                                                DWNLN_ONLY_IND__c = 'Y'
                                            );
        lstRepPerf.add(rep21);
                                            
        ALM_Rep_Performance_1__c rep3 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'02' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6,
                                                DWNLN_ONLY_IND__c = 'N'
                                            );
        lstRepPerf.add(rep3);
        ALM_Rep_Performance_1__c rep31 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'02' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.PREV_1_CMPGN_NR__c + uplineAcctNr+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6,
                                                DWNLN_ONLY_IND__c = 'Y'
                                            );
        lstRepPerf.add(rep31);
                                            
        ALM_Rep_Performance_1__c rep4 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'03' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr+'02', Genealogy_Level__c = 3,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[3].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'03' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',LOA_NR__c = 1.0,
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 4, RGT_ND_ID__c = 5,
                                                DWNLN_ONLY_IND__c = 'Y'
                                            );
        lstRepPerf.add(rep4);
        insert lstRepPerf;
        
        
        */
        
        
        
        //share market 
        Market__Share mShare = new Market__Share();
        mShare.UserOrGroupId = uplineUser.id;
        mShare.ParentId = mkt.id;
        mShare.AccessLevel = 'Edit';
        insert mShare;
        
        //create report config
        Report_Config__c rc = createReportConfig(mkt.Id);
        
        //create report columns
        createReportColumns(rc.id);
        createReportFilters(rc.id);
        
        //create campaign calendar
        createCampaignCalendarRecords(mkt); 
        
        /*
        createGenealogyData(String acctNbr, String ownrId);
        */
    }
    
    private static testMethod void testMTR(){  
    	MaxPgLimit = 500;
    	testMTRCreateData(); 
    	
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
     
     private static testMethod void testMTROth(){   
     	/*
     	PageReference mtrPage = Page.MyTeamReport;
     	
        Test.setCurrentPageReference(mtrPage);
        ApexPages.currentPage().getParameters().put('campaignId','201204');
        Test.startTest();
     	
     	MaxPgLimit =2;
     	testMTRCreateData();
     	*/
     	
     	MaxPgLimit =2;
     	testMTRCreateData();
     	
     	PageReference mtrPage = Page.MyTeamReport;
     	Test.setCurrentPageReference(mtrPage);
        ApexPages.currentPage().getParameters().put('campaignId','201304');
        Test.startTest();
     	
     	
        System.runAs(uplineUser){
     		/*
     		MyTeamReportCmpController mtrc = new MyTeamReportCmpController();
     		Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                    WHERE CMPGN_NR__c = 201304 LIMIT 1];
            System.debug('\n testMTROth calendar @@@@@@ -> '+calendar);
            */
            Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                    WHERE CMPGN_NR__c = 201304 LIMIT 1];
            System.debug('\n testMTROth calendar @@@@@@ -> '+calendar);
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
            //mtrc.AF_AccountNum = uplineAcctNr;
            
            /*MTRSearchOptions.MTRFilterSearch filterSearchType = new MTRSearchOptions.MTRFilterSearch();
   
	        filterSearchType.CampaignId = MTRSOQLBuilder.MakeCampaignKey(mkt.CMPGN_NR__c, mkt.PREV_1_CMPGN_NR__c);
	        filterSearchType.AccountNumber = downlineTwoAcctNr;
	        filterSearchType.SearchForDownline = true;
	        filterSearchType.IsTList = false;
            
            
            mtrc.AF_AccountNum = downlineTwoAcctNr;
            mtrc.AF_PageAction = '';
            mtrc.AF_SearchType = 'TextSearch';
            mtrc.TeamSOQLBuilder.SelectedPreviousCampaign = Integer.valueOf(mkt.CMPGN_NR__c);
            mtrc.TeamSOQLBuilder.SelectedCurrentCampaign = Integer.valueOf(mkt.PREV_1_CMPGN_NR__c);
            
            mtrc.ExpandGenealogy();*/
            
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
    
    //test data creating methods
    private static Report_Config__c createReportConfig(String mktId){
        
        Report_Config__c rc = new Report_Config__c();
        
        rc.Name = 'Team Report';
        rc.Report_Type__c = 'Title_Advancement'; //Modified by Rupayan from My_Team
        rc.Market__c = mktId;
        rc.Applicable_To__c = 'Avon Leader';
        rc.TITL_LVL_NBR__c = '1';
        rc.T_List_Page_Size__c = 500;
        rc.Page_Size__c = 200;
        rc.Max_Page_Limit__c = maxPgLimit;
        rc.Number_of_Historical_Cmpgns_for_Filter__c = 1;
        
        insert rc;
        return rc;
    } 
    
    private static void createCampaignCalendarRecords(Market__c mrkt){
        List<Calendar__c> campaignCalendarList = new List<Calendar__c>();
        campaignCalendarList.add(new Calendar__c(Market__c = mrkt.Id, CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c), MRKT_ID__c = mrkt.Market_Id__c, CURRNT_IND__c = 'Y',  PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c));
        campaignCalendarList.add(new Calendar__c(Market__c = mrkt.Id, CMPGN_NR__c = Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c), MRKT_ID__c = mrkt.Market_Id__c, PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c));
        campaignCalendarList.add(new Calendar__c(Market__c = mrkt.Id, CMPGN_NR__c = Decimal.valueOf(mrkt.NEXT_1_CMPGN_NR__c), MRKT_ID__c = mrkt.Market_Id__c, PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c));
        insert campaignCalendarList;
        
        /*
        Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                WHERE CMPGN_NR__c = :campaignNumber LIMIT 1];
        */
        //System.debug('\n ######## campaignCalendarList \n '+campaignCalendarList);
    }
    
    private static void createReportColumns(String reportConfigId){
        
        List<Report_Column_New__c> rcList = new List<Report_Column_New__c>();
        
        rcList.add(new Report_Column_New__c(Name = 'Name', Report_Config__c = reportConfigId, Width__c=109, Display_Order__c = 1, Fully_Qualified_Name__c = 'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName',  
                                        Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', Column_Display_Type__c = 'Frozen', Type__c = 'Text', Visibility__c = 'Always Displayed'));
        rcList.add(new Report_Column_New__c(Name = 'LLOA / LOA', Report_Config__c = reportConfigId, Width__c=109, Display_Order__c = 2, Fully_Qualified_Name__c = 'LDRSHP_LOA_NR__c, LOA_NR__c',  
                                        Column_Display_Type__c = 'Scrollable', Type__c = 'Text', Visibility__c = 'Default Shown'));
        rcList.add(new Report_Column_New__c(Name = 'Badge Title', Report_Config__c = reportConfigId, Width__c=109, Display_Order__c = 3, Fully_Qualified_Name__c = 'LDRSHP_TITL_LVL_NR__c',  
                                        Column_Display_Type__c = 'Scrollable', Type__c = 'Text', Visibility__c = 'Default Shown'));
        insert rcList;      
    }
    
    private static void createReportFilters(String reportConfigId){
        
        List<Report_Filter__c> rfList = new List<Report_Filter__c>();
        
        rfList.add(new Report_Filter__c(Name = 'All Badge Titles', Report_Config__c = reportConfigId, Filter_Criteria__c = 'LDRSHP_TITL_LVL_NR__c != \'-999\'',  Generations_Depth__c ='All', Is_Rep_List_Restricted__c = true,
                                        Filter_Type__c = 'Who', Is_Drillable__c = true, Is_Sortable__c = true, Filter_Key__c = 'All_Badge_Titles', Sort_Order__c = ''));
        rfList.add(new Report_Filter__c(Name = 'All Data', Report_Config__c = reportConfigId, Filter_Criteria__c = 'LDRSHP_TITL_LVL_NR__c != \'-999\'',  Generations_Depth__c ='All', Is_Rep_List_Restricted__c = true,
                                        Filter_Type__c = 'What', Is_Drillable__c = true, Is_Sortable__c = true, Filter_Key__c = 'All_Data', Sort_Order__c = ''));       
        insert rfList;      
    }
        
    private static Account createAccount(){
        Account a = new Account(name='testAccount');
        insert a;
        return a;
    }
}