public class NewRepControllerTest 
{
    public static String mktIdKey = 'XX';
    
    public static testmethod void testNewRepBusiness()
    {
        TestDataHelper testData =   new TestDataHelper();
    
        Market__c mrkt = testData.createMarket();
        mrkt.Market_Id__c = 'DE';
        mrkt.Allow_Freeform_Email__c = 'Avon Leader; Avon Mkt DE Division Manager';
        mrkt.Market_Currency_Symbol__c = '₱';
        update  mrkt;
         
       User ldrUsr;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            ldrUsr = testData.createLeaderUser(mktIdKey);
            ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
            ldrUsr.IsActive = true;
            update ldrUsr;
        
            mrkt.OwnerId = ldrUsr.Id;
            update  mrkt;
        }
        
        
        //Added by Rupayan
        Report_Print__c rp = new Report_Print__c(Fixed_columns__c=0,
                              Height__c=0,
                              Width__c=0,
                              Name = mrkt.Market_Id__c);
         insert rp;
        //Creating Leader Title Objects
        testData.createLeaderTitles();  
        
        List<Report_Config__c> lstRepCnfg = testData.createReportConfig();
        lstRepCnfg[5].Include_Recruits__c = true;
        lstRepCnfg[5].Include_Removed_Reps__c = false;
        update lstRepCnfg[5];
        
        List<Calendar__c> lstCalndr = new List<Calendar__c>();
        
        Calendar__c cal = new Calendar__c(CMPGN_NR__c=201203.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2012, Market__c=mrkt.Id, Name='TestCal1');
        lstCalndr.add(cal);
        
        cal = new Calendar__c(CMPGN_NR__c=201202.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2012, Market__c=mrkt.Id, Name='TestCal2');
        lstCalndr.add(cal);
        
        cal = new Calendar__c(CMPGN_NR__c=201201.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2012, Market__c=mrkt.Id, Name='TestCal3');
        lstCalndr.add(cal);
        
        cal = new Calendar__c(CMPGN_NR__c=201117.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2011, Market__c=mrkt.Id, Name='TestCal4');
        lstCalndr.add(cal);
        
        cal = new Calendar__c(CMPGN_NR__c=201116.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2011, Market__c=mrkt.Id, Name='TestCal5');
        lstCalndr.add(cal);
        
        insert lstCalndr;
        
        String loa = 'LOA (1-6)'; 
        
        
        /* -- Cut Portions START -- */
        Account testAcct = new Account(Name='Test Acount');
        insert testAcct;
        
        List<Contact> lstContact = new List<Contact>();
        Date apptDate = date.parse('12/27/2009');
        Contact con1    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey,
                                            Email='test1@avon.com',FirstName=mktIdKey+'First1',LastName=mktIdKey+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey, MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con1);
                                          
        Contact con2    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey+'01',
                                            Email='test2@avon.com',FirstName=mktIdKey+'01'+'First2',LastName=mktIdKey+'01'+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            /*LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'01' , MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id, REP_BRTH_DT__c =System.today()
                                          );
        
        lstContact.add(con2); 
        
        Contact con3    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey+'02',
                                            Email='test3@avon.com',FirstName=mktIdKey+'02'+'First3',LastName=mktIdKey+'02'+'Last3',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'02', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id, REP_BRTH_DT__c =System.today()
                                          );
        
        lstContact.add(con3);
        
        Contact con4    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey+'03',
                                            Email='test3@avon.com',FirstName=mktIdKey+'03'+'First4',LastName=mktIdKey+'03'+'Last4',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                         /*   LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'03', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id, REP_BRTH_DT__c =System.today()
                                          );
        
        lstContact.add(con4);
        
        insert lstContact;   
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        
        // LEADER
        
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
                                            );
        lstRepPerf.add(rep1);
        ALM_Rep_Performance_1__c rep11 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
                                            );
        lstRepPerf.add(rep11);
                                        
        ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'01' ,
                                                UPLN_ACCT_NR__c = mktIdKey, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7
                                            );
        lstRepPerf.add(rep2);
        ALM_Rep_Performance_1__c rep21 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'01' ,
                                                UPLN_ACCT_NR__c = mktIdKey, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7
                                            );
        lstRepPerf.add(rep21);
                                            
        ALM_Rep_Performance_1__c rep3 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'02' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6
                                            );
        lstRepPerf.add(rep3);
        ALM_Rep_Performance_1__c rep31 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'02' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6
                                            );
        lstRepPerf.add(rep31);
                                            
        ALM_Rep_Performance_1__c rep4 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'03' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'02', Genealogy_Level__c = 3,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[3].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 4, RGT_ND_ID__c = 5
                                            );
        lstRepPerf.add(rep4);
        insert lstRepPerf;
               
        
        PageReference pageRef = Page.NewRepReport;
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('acctkey', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        PageRef.getParameters().put('CNO', mrkt.CMPGN_NR__c);
        PageRef.getParameters().put('LOA', loa);
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'last');
        PageRef.getParameters().put('pagename' , '1');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getHeaders().put('User-Agent', 'MSIE9');
        Test.setCurrentPage(pageRef);
        
        // Formulating query       
       String query = 'SELECT ACCT_NR__c,'+
                            'Genealogy_Level__c,'+
                            'MRKT_ACCT_KEY__r.LastName,'+
                            'MRKT_ACCT_KEY__r.FirstName,'+
                            'MRKT_ACCT_KEY__r.ACCT_NR__c,'+
                            'MRKT_ACCT_KEY__r.Email,'+
                            'SLS_ZONE_CD__c,'+
                            'LOA_NR__c,'+
                            'BRNCH_SCTN_CD__c,'+
                            'PRSNL_SLS_AMT__c,'+
                            'BOOK1_GRP_UNIT_SLS_AMT__c,'+
                            'PC1_INVC_AWRD_SLS_AMT__c,'+
                            'MRKT_ACCT_KEY__r.Representative_Phone__c,'+
                            'UPLN_ACCT_NR__c,'+
                            'MRKT_ACCT_KEY__r.REP_BRTH_DT__c,'+
                            'MRKT_ACCT_KEY__r.REP_APPT_DT__c,'+
                            'LDRSHP_TITL_LVL_NR__c,'+
                            'BRCHR_CNT__c,'+
                            'CUST_CNT__c FROM ALM_Rep_Performance_1__c'+
                            ' WHERE OPERTNL_CMPGN_NR__c=\''+mrkt.CMPGN_NR__c+'\' AND ROOT_UPLN_ACCT_NR__c=\''+ldrUsr.ACCT_NR__c+'\' AND '+
                            ' Genealogy_Level__c in (1, 2, 3) '+
                            ' ORDER BY LOA_NR__c asc, PRSNL_SLS_AMT__c desc';
                         
                         system.debug(query);   
       
        System.runAs(ldrUsr)
        {
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);
            NewRepController controller = new NewRepController(sc);
            controller.initialized();
                        
            controller.populateCon();
 			controller.getOmniturePageName();
            controller.sortOther();
            controller.download_click();
            controller.downloadAll();
            controller.downloadPage();
            controller.filterReport();     

            controller.callRepDetails();
            controller.printRedirect();
            controller.refreshPage();
            controller.previous();
            controller.next(); 
            controller.gotopage();
            controller.setNewRepReportURL('My_New_Representative_62_');
 		    controller.getNewRepReportURL();
            
            Boolean statusPrev = controller.hasPrevious;
            integer pageNumbr = controller.pageNumber;
            Boolean statusNext = controller.hasNext;
            
            System.assert(controller.emailForIndc == 'G1');
            System.assert(statusPrev == false);
            System.assert(statusNext == false);
            System.assert(pageNumbr == 1);            
            
        }
        
        
        lstRepCnfg[5].Include_Recruits__c = false;
        lstRepCnfg[5].Include_Removed_Reps__c = false;
        update lstRepCnfg[5];
        
        mrkt.Allow_Freeform_Email__c = 'Avon Mtk DE Zone Manager';
        update  mrkt;        
        
        pageRef = Page.NewRepReport;
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'first');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('prtinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getHeaders().put('User-Agent', 'MSIE9');
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);
            NewRepController controller = new NewRepController(sc);
            controller.initialized();
                        
            controller.populateCon();
            controller.setPrintVar();
            controller.download_click();
            controller.downloadPage();
            controller.callRepDetails();
            controller.pagination();
            controller.printRedirect();
                        
            Boolean statusPrev = controller.hasPrevious;
            integer pageNumbr = controller.pageNumber;
            Boolean statusNext = controller.hasNext;
            
            System.assert(controller.emailForIndc == '');
            System.assert(statusPrev == false);
            System.assert(statusNext == false);
            System.assert(pageNumbr == 1);           
            
        }
        
        
        mrkt.Allow_Free_Emails_For__c = 'All';
        mrkt.Allow_Freeform_Email__c = 'Avon Leader;Avon Mkt DE Zone Manager';
        update  mrkt;
        
        lstRepCnfg[5].Include_Recruits__c = true;
        lstRepCnfg[5].Include_Removed_Reps__c = false;
        update lstRepCnfg[5];
        
        
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('acctkey', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        //PageRef.getParameters().put('CNO', mrkt.SPPY_CMPGN_NR__c);
        PageRef.getParameters().put('CNO', mrkt.PREV_1_CMPGN_NR__c);
        PageRef.getParameters().put('LOA', loa);
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'next');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('prtinvisibleStr' , 'SHPI~SH8~SH5');
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);
            NewRepController controller = new NewRepController(sc);
            controller.initialized();
                        
            controller.populateCon();
            controller.getOmniturePageName();
            controller.sortOther();
            controller.download_click();
            controller.setPrintVar();
            controller.downloadAll();
            controller.downloadPage();
            controller.filterReport();        
            controller.callRepDetails();
            controller.pagination();
            controller.next();  
            controller.printRedirect(); 
            
            Boolean statusPrev = controller.hasPrevious;
            integer pageNumbr = controller.pageNumber;
            Boolean statusNext = controller.hasNext;   
            
            controller.downloadMyReport();
            
            controller.downloadAll();
            controller.downloadThisReport();
            
            System.assert(controller.emailForIndc == 'All');
            System.assert(statusPrev == false);
            System.assert(statusNext == false);
            System.assert(pageNumbr == 1);
            
        }
        
        
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('acctkey', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        PageRef.getParameters().put('CNO', mrkt.SPPY_CMPGN_NR__c);
        PageRef.getParameters().put('LOA', loa);
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'previous');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('prtinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getHeaders().put('User-Agent', '');
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
            /*ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);*/
            NewRepController controller1 = new NewRepController();
            controller1.initialized();
            
        } 
      

    }
}