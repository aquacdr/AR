/**************************************************************************************
 Name         : Test_BusinessPlanController 
 Modified By  : Barkha Jain (JDC)
 Description  : Test class for BusinessPlanControllerNew
 Created Date : Nov 15, 2013     
***************************************************************************************/
@isTest
private class Test_BusinessPlanController {

    static String mktIdKey = '62';
    static String acctNr = '123456';
    static String sURL = '';
    static Market__c mrkt;
    static User testUsr;
    static Leader_Title__c title;
    static Contact con1;
    
    //----------------------------------------------------------------------------
    // Method Name  : testBusinessPlan
    // Description  : Method for Test Coverage of Class : BusinessPlanController
    //----------------------------------------------------------------------------  
    static testMethod void testBusinessPlan() {
        testCreateDataBusinessPlan();
        
        Business_Plan_Parameter__c testBPpar;
        Business_Plan__c businessPlan;
        
        PageReference pageRef1 = Page.BusinessPlan;
        pageRef1.getParameters().put('repDetailAcctNbr', acctNr); 
        pageRef1.getParameters().put('acctkey', acctNr); 
        test.setCurrentPage(pageRef1);
        
        String sUrl1 = Apexpages.currentPage().getURL();
        if(sUrl1.contains('businessplan')) {
            sUrl1 = sUrl1.replace('businessplan', 'BusinessPlan');
        }
        pageRef1 = new PageReference(sUrl1);
        Test.setCurrentPageReference(pageRef1);
        
        test.startTest();
        System.runAs(testUsr) {
            BusinessPlanControllerNew bpCntr1 = new BusinessPlanControllerNew();
            //Create Object: Business_Plan_Parameter__c
            testBPpar = TestDataHelper.createBusinessPlanParameter(mrkt.Id, true);
            
            //Without Creating Business_Plan__c
            bpCntr1.BPAction();
            bpCntr1.callRepDetails();
            system.assertEquals(bpCntr1.isBusinessplan, true);
            
            //Create Object: Business_Plan__c
            businessPlan = TestDataHelper.createBusinessPlan(mrkt.Market_Id__c, testUsr, testBPpar.Id, true);
            
            //After Creating Business_Plan__c and Business_Plan_Parameter__c
            bpCntr1.BPAction();
            bpCntr1.callRepDetails();
            system.assertEquals(bpCntr1.isBusinessplan, true);
        }
        
        ApexPages.currentPage().getParameters().put('AccKey', acctNr);
        System.runAs(testUsr) {
            BusinessPlanControllerNew bpCntr1 = new BusinessPlanControllerNew();
            bpCntr1.coachParam = 'Test';
            bpCntr1.BPAction();
            bpCntr1.callRepDetails();
            system.assertEquals(bpCntr1.isBusinessplan, true);
            
            BusinessPlanControllerNew ctrl = new BusinessPlanControllerNew(new CoachRecordController());
            ctrl.getControllerRef();   
            ctrl.dummy();         
        }
        
        test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testBusinessPlanNew
    // Description  : Method for Test Coverage of Class : BusinessPlanController
    //----------------------------------------------------------------------------
    static testMethod void testBusinessPlanNew() {
        testCreateDataBusinessPlan();
        // Creating Business Plan data
        
        PageReference pageRef = Page.BusinessPlan;
        pageRef.getParameters().put('AccKey', acctNr);        
        Test.setCurrentPageReference(pageRef);
                        
        sUrl = Apexpages.currentPage().getURL();
        if (sUrl.contains('businessplan')) {
            sUrl = sUrl.replace('businessplan', 'BusinessPlan');
        }
        
        pageRef = new PageReference(sUrl);
        Test.setCurrentPageReference(pageRef);
        test.startTest();
        System.runAs(testUsr) {
            // Creating Business Plan Parameter data 
            Business_Plan_Parameter__c testBPpar = TestDataHelper.createBusinessPlanParameter(mrkt.Id, true);
            
            //Create Object: Sales_Leader_History__c
            List <Sales_Leader_History__c> salesLeaderList = new List <Sales_Leader_History__c>();
            Sales_Leader_History__c salesLeaderOne = TestDataHelper.createSalesLeaderHistory(con1.Id, false);
            salesLeaderOne.FLD_SLS_CMPGN_NR__c = 191202.0;
            salesLeaderList.add(salesLeaderOne);
            Sales_Leader_History__c salesLeaderTwo = TestDataHelper.createSalesLeaderHistory(con1.Id, false);
            salesLeaderTwo.FLD_SLS_CMPGN_NR__c = 191201.0;
            salesLeaderList.add(salesLeaderTwo);
            insert salesLeaderList;
            
            //Create Objet: Business_Plan__c            
            Business_Plan__c businessPlan = TestDataHelper.createBusinessPlan(mrkt.Market_Id__c, testUsr, testBPpar.Id, false);
            businessPlan.Mrkt_Id_Acct_Nr_Key__c = testUsr.MRKT_ID_ACCT_NR_KEY__c;
            businessPlan.Market_Id__c = mrkt.Market_Id__c;
            businessPlan.IsDeleted__c = false;
            businessPlan.Is_BP_Saved__c = true; 
            businessPlan.PRSNL_DEV_PLN_ACTN3__c = 'TEST_PLN3';
            businessPlan.TOP_SLR_ACTN3__c = 'TEST_TOP_SLR_3';
            businessPlan.Long_Term_Dreams__c = 'TEST_LONTRMDRM';
            businessPlan.RSNG_STR_DEV_ACTN2__c = 'TEST_RSNGSTAR_ACT';
            businessPlan.FLWUP_MTG_60__c = System.today(); 
            businessPlan.Personal_Achievement__c = 'TEST_PRSN_ACHV';
            businessPlan.LDRSHP_TITL_ACTN2__c = 'TEST_LDR_TITLE';
            businessPlan.Short_Term_Goals__c = 'TEST_SHRT_GL';
            businessPlan.Unit_Achievement__c = 'TEST_UNT_ACHV';
            businessPlan.Key_Learnings__c = 'TEST_KEY_LRNG';
            businessPlan.RECR_ACTN1__c = 'TEST_RECR_ACT_1'; 
            businessPlan.Campaign_Numbers__c = '191202.0;191203.0;191204.0;191205.0;191206.0;191207.0;191208.0;191209.0;191210.0;191211.0;191212.0';
            businessPlan.CMPGN_NR__c = '191203.0';
            businessPlan.Current_campaign__c = '191203.0'; 
            businessPlan.NEXT_1_CMPGN_NR__c = '191204.0'; 
            businessPlan.NEXT_2_CMPGN_NR__c = '191204.0'; 
            businessPlan.NEXT_3_CMPGN_NR__c = '191205.0'; 
            businessPlan.NEXT_4_CMPGN_NR__c = '191206.0'; 
            businessPlan.NEXT_5_CMPGN_NR__c='191207.0'; 
            businessPlan.NEXT_6_CMPGN_NR__c = '191208.0';
            businessPlan.Business_Plan_Parameter__c = testBPpar.Id; 
            insert businessPlan;
            
            BusinessPlanControllerNew bpCntr = new BusinessPlanControllerNew();
            bpCntr.isBlankPlan = true;            
            bpCntr.BPAction();          
            bpCntr.savePage();            
            bpCntr.shortTermGoals = 'short';
            bpCntr.longTermGoals = 'long';
            bpCntr.personalAcheivementPY = 'personal';
            bpCntr.unitAcheivementPY = 'unit';
            bpCntr.keyLearnings = 'key';
            bpCntr.recruiting_ActStr1 = 'testact';
            bpCntr.recruiting_ActStr2 = 'testact';
            bpCntr.recruiting_ActStr3 = 'testact';
            bpCntr.activity_ActStr1 = 'testact';
            bpCntr.activity_ActStr2 = 'testact';
            bpCntr.activity_ActStr3 = 'testact';
            bpCntr.topSeller_ActStr1 = 'testact';
            bpCntr.topSeller_ActStr2 = 'testact';
            bpCntr.topSeller_ActStr3 = 'testact';
            bpCntr.topSeller_Candidates = 'testact';
            bpCntr.leadership_ActStr1 = 'testact';
            bpCntr.leadership_ActStr2 = 'testact';
            bpCntr.leadership_ActStr3 = 'testact';
            bpCntr.leadership_Candidates = 'testact';
            bpCntr.perDev_ActStr1 = 'testact';
            bpCntr.perDev_ActStr2 = 'testact';
            bpCntr.perDev_ActStr3 = 'testact';
            bpCntr.perDev_ActStr4 = 'testact';
            bpCntr.perDev_ActStr5 = 'testact';
            bpCntr.perDev_ActStr6 = 'testact';
            bpCntr.rising_ActStr1 = 'testact';
            bpCntr.rising_ActStr2 = 'testact';
            bpCntr.rising_ActStr3 = 'testact';
            bpCntr.rising_Candidates = 'testact';
            bpCntr.followup30 = '08/01/2012';
            bpCntr.followup60 = '09/01/2012';
            bpCntr.followup90 = '10/01/2012';
            
            bpCntr.savePage();            
            bpCntr.BPAction();
            bpCntr.cancelChanges();            
            bpCntr.startNewPlan();            
            bpCntr.processPage();             
            bpCntr.savePage();          
            bpCntr.getOmniturePageName();
        }
        test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method to create test data
    //----------------------------------------------------------------------------
    static void testCreateDataBusinessPlan() {
        List<User> users = new List<User>();
        //Create and Insert Object : User
        testUsr = TestDataHelper.createUser(acctNr, 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID_ACCT_NR_KEY__c = mktIdKey + acctNr;
        testUsr.MRKT_ID__c = mktIdKey;
        users.add(testUsr);
        User zmUsr = TestDataHelper.createUser(acctNr+'1', 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        zmUsr.MRKT_ID__c = mktIdKey;
        users.add(zmUsr);
        User dmUsr = TestDataHelper.createUser(acctNr+'2', 'XZ1', 'Avon Mkt 62 Division Manager', false);
        dmUsr.MRKT_ID__c = mktIdKey;
        users.add(dmUsr);
        insert users;
        
        //Create and Insert Object : Market
        mrkt = TestDataHelper.createMarket(mktIdKey, false);
        mrkt.Allow_Freeform_Email__c = 'Avon Leader; Avon Division Manager';
        mrkt.Market_Currency_Symbol__c = '₱';
        mrkt.OwnerId = testUsr.Id;
        mrkt.Is_ALMPLUS_Enabled__c = true;
        mrkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        mrkt.X90_Day_Camp_CNT__c = 6;
        mrkt.Business_Plan_KPIs__c = 'Personal_Volume_dollar;Personal_Appointments;Qualified_Personal_Appointments;G1_Removals;G1_Active_Representatives;G1_Activity_Rate;Total_Unit_Sales_dollor;';
        mrkt.CMPGN_NR__c = '191203';
        mrkt.NEXT_1_CMPGN_NR__c = '191204';
        mrkt.PREV_1_CMPGN_NR__c = '191202';
        mrkt.CMPGN_STRT_DT__c = date.valueOf('1912-04-02');
        mrkt.CMPGN_END_DT__c = date.valueOf('1912-04-30');
        insert mrkt;
        
        // Create Object: Leader Title
        title = TestDataHelper.createLeaderTitle(mrkt.Id, mrkt.Market_Id__c, true);
        
        //create Object: Calendar
        List <Calendar__c> calendars = new List <Calendar__c>();
        List <String> perPerfKeys = new List <String>();
        List <String> acctNbrLst = new List <String>();
        for (Integer i = 191201; i < 191212; i++) {
            //calendars
            Calendar__c tempFutCal = TestDataHelper.createCalendar(i, mrkt.Market_Id__c, 1912, mrkt.Id, false);
            calendars.add(tempFutCal);
            String ppkey = mrkt.Market_Id__c + String.valueOf(i) + '636363';
            acctNbrLst.add(String.valueOf(i) + '636363');
            perPerfKeys.add(ppkey);
        }
        
        for (Integer j = 191109; j < 191116; j++) {
            Calendar__c tempHistCal = TestDataHelper.createCalendar(j, mrkt.Market_Id__c, 1911, mrkt.Id, false);
            calendars.add(tempHistCal);
            String ppkey = mrkt.Market_Id__c + String.valueOf(j) + '636363';
            perPerfKeys.add(ppkey);
        }
        insert calendars;
        
        TestDataHelper.createALMGlobalSetting(true);
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact
        List <Contact> lstContact = new List <Contact>();
        con1 = TestDataHelper.createContact(mktIdKey, acct.Id, false);
        con1.OwnerId = testUsr.Id;
        con1.MRKT_ACCT_KEY__c = mktIdKey + testUsr.ACCT_NR__c;      
        lstContact.add(con1);
         
        Contact con2 = TestDataHelper.createContact(mktIdKey + '01', acct.Id, false);
        con2.OwnerId = testUsr.Id;
        lstContact.add(con2);
        Contact con3 = TestDataHelper.createContact('XX' + '02', acct.Id, false);
        con3.OwnerId = testUsr.Id;
        lstContact.add(con3);
        Contact con4 = TestDataHelper.createContact('XX' + '03', acct.Id, false);
        con4.OwnerId = testUsr.Id;
        lstContact.add(con4);
        
        insert lstContact;    
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List <ALM_Rep_Performance_1__c> lstRepPerf = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(con1.Id, mrkt, mktIdKey, false);
        rep1.Name = 'Test REP1';
        rep1.ACCT_NR__c = mktIdKey;
        rep1.Genealogy_Level__c = 0;
        rep1.CurrencyISOCode = 'USD';
        rep1.MRKT_ID__c = mrkt.Market_ID__c;
        rep1.MRKT_ACCT_KEY__c = lstContact[0].Id;
        rep1.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
        rep1.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
        rep1.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey;
        rep1.REP_OMS_STUS_CD__c = '1';
        rep1.AVON_LOA_1_6_IND__c = 'Y';
        rep1.LDRSHP_LOA_NR__c = 1;
        rep1.LDRSHP_TITL_LVL_NR__c = '1';
        rep1.ROOT_UPLN_ACCT_NR__c = mktIdKey;
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 8;
        lstRepPerf.add(rep1);
        
        ALM_Rep_Performance_1__c rep2 = TestDataHelper.createRepPerformance(con1.Id, mrkt, mktIdKey, false);
        rep2.Name = 'Test REP1'; 
        rep2.ACCT_NR__c = mktIdKey + '01';
        rep2.UPLN_ACCT_NR__c = mktIdKey;
        rep2.Genealogy_Level__c = 1;
        rep2.CurrencyISOCode = 'USD';
        rep2.MRKT_ID__c = mrkt.Market_ID__c;
        rep2.MRKT_ACCT_KEY__c = lstContact[1].Id;
        rep2.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
        rep2.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
        rep2.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey + '01';
        rep2.REP_OMS_STUS_CD__c = '1';
        rep2.AVON_LOA_1_6_IND__c = 'Y';
        rep2.LDRSHP_LOA_NR__c = 1;
        rep2.LDRSHP_TITL_LVL_NR__c = '1';
        rep2.ROOT_UPLN_ACCT_NR__c = mktIdKey;
        rep2.UPLN_ACCT_KEY__c = con1.Id;
        rep2.LFT_ND_ID__c = 0;
        rep2.RGT_ND_ID__c = 9;
        lstRepPerf.add(rep2);
        
        insert lstRepPerf;
        
        //Create Object: X90DBP_settings__c
        List <X90DBP_settings__c> x90DBPList = new List <X90DBP_settings__c>();
        X90DBP_settings__c x90DBPOne = TestDataHelper.createX90DBPSetting('X90DBP1', 'Personal_Volume_dollar', false);
        x90DBPOne.isHeader__c = 'true';
        x90DBPList.add(x90DBPOne);
        
        X90DBP_settings__c x90DBPTwo = TestDataHelper.createX90DBPSetting('X90DBP2', 'Personal_Appointments', false);
        x90DBPTwo.isFuture__c = 'false';
        x90DBPList.add(x90DBPTwo);
        
        X90DBP_settings__c x90DBPThree = TestDataHelper.createX90DBPSetting('X90DBP3', 'Qualified_Personal_Appointments', false);
        x90DBPList.add(x90DBPThree);
        
        X90DBP_settings__c x90DBPFour = TestDataHelper.createX90DBPSetting('X90DBP4', 'G1_Removals', false);
        x90DBPList.add(x90DBPFour);
        
        X90DBP_settings__c x90DBPFive = TestDataHelper.createX90DBPSetting('X90DBP5', 'G1_Active_Representatives', false);
        x90DBPList.add(x90DBPFive);
        
        X90DBP_settings__c x90DBPSix = TestDataHelper.createX90DBPSetting('X90DBP6', 'G1_Activity_Rate', false);
        x90DBPList.add(x90DBPSix);
        
        X90DBP_settings__c x90DBPSeven = TestDataHelper.createX90DBPSetting('X90DBP7', 'Total_Unit_Sales_dollor', false);
        x90DBPList.add(x90DBPSeven);
        insert x90DBPList;
                 
        //Create Object: Locale_Date_Format__c
        Locale_Date_Format__c locale = TestDataHelper.createLocaleDateFormat(true);
    }    
}