/***************************************************************************
 Name         : Test_CoachRecordController 
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for CoachRecordController, PersonalInfoHandeller 
 Created Date : Oct. 25, 2013                
****************************************************************************/
@isTest
private class Test_CoachRecordController {  
    
    //----------------------------------------------------------------------------
    // Method Name  : testCoachController
    // Description  : Method for Test Coverage of Class : CoachRecordController, PersonalInfoHandeller 
    //----------------------------------------------------------------------------
    static testMethod void testCoachController() {
        String mktIdKey = 'TESTCOACH';
        String mktIdKeyOne = 'TEST1';
        
        String testUsrAcctNbr = '100001';   
        String contactAcctNbr = '100002';
        List <Market__c> marketList = new List <Market__c>();
        Market__c mrkt;
        Market__c mrktOne;
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create and Insert Object : User
        List <User> usrList = new List <User>();
        
        User testUsr = TestDataHelper.createUser(testUsrAcctNbr, 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID__c = mktIdKey;
        testUsr.LDRSHP_TITL_LVL_NBR__c = '2';
        usrList.add(testUsr);
        
        insert usrList;
        
        System.runAs(testUsr) {
            //Create and Insert Object : Market
            mrkt = TestDataHelper.createMarket(mktIdKey, false);
            mrkt.OwnerId = testUsr.Id;
            mrkt.Section_Ldrship__c = 'Current President Club Status';
            mrkt.Rep_Detail_Columns__c = 'Badge Title';
            mrkt.Section_PSB__c = 'Badge_Title';
            marketList.add(mrkt);
            
            //Create and Insert Object : Market
            mrktOne = TestDataHelper.createMarket(mktIdKeyOne, false);
            mrktOne.OwnerId = testUsr.Id;
            mrktOne.Section_Ldrship__c = 'Current President Club Status';
            mrktOne.Rep_Detail_Columns__c = 'Badge Title';
            mrktOne.Section_PSB__c = 'Badge_Title';
            marketList.add(mrktOne);
            
            insert marketList;
        }
        
        //Create Object: Rep_Detail_Field__c
        List <Rep_Detail_Field__c> repDetailList = new List <Rep_Detail_Field__c>();
        Rep_Detail_Field__c repDetailOne = TestDataHelper.createRepDetailField('Badge Title', false);
        repDetailList.add(repDetailOne);
        
        Rep_Detail_Field__c repDetailTwo = TestDataHelper.createRepDetailField('Badge_Title', false);
        repDetailTwo.Group__c = 'PSB';
        repDetailList.add(repDetailTwo);
        
        Rep_Detail_Field__c repDetailThree = TestDataHelper.createRepDetailField('Current President Club Status', false);
        repDetailThree.Group__c = 'LDR_TUS';
        repDetailList.add(repDetailThree);
        
        Rep_Detail_Field__c repDetailFour = TestDataHelper.createRepDetailField('Test Rep Detail 4', false);
        repDetailFour.Group__c = 'LDR_UI_G1';
        repDetailList.add(repDetailFour);
        
        Rep_Detail_Field__c repDetailFive = TestDataHelper.createRepDetailField('Paid Title', false);
        repDetailFive.Group__c = 'LDR_UI_G2';
        repDetailList.add(repDetailFive);
        
        Rep_Detail_Field__c repDetailSix = TestDataHelper.createRepDetailField('Test Rep Detail 6', false);
        repDetailSix.Group__c = 'LDR_UI_G3';
        repDetailList.add(repDetailSix);
        
        Rep_Detail_Field__c repDetailSeven = TestDataHelper.createRepDetailField('Test Rep Detail 7', false);
        repDetailSeven.Group__c = 'EUP';
        repDetailList.add(repDetailSeven);
        
        insert repDetailList;
        
        //Create Object: Calender__c
        List <Calendar__c> calendarList = new List <Calendar__c>();
        Calendar__c c1 = TestDataHelper.createCalendar(201306.00, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c1);
        
        Calendar__c c2 = TestDataHelper.createCalendar(201305.00, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c2);
        
        Calendar__c c3 = TestDataHelper.createCalendar(201304.00, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c3);
        
        Calendar__c c4 = TestDataHelper.createCalendar(201303.00, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c4);
        
        insert calendarList;
        
        List <Leader_Title__c> leaderTitleList = TestDataHelper.createLeaderTitlesList(String.valueOf(mrkt.Id), mrkt.Market_Id__c, true);
        List <Seller_Status__c> sellerStatusList = TestDataHelper.createSellerStatusList(String.valueOf(mrkt.Id), true);
        List <Sales_Organization__c> salesOrgList = TestDataHelper.createSalesOrgsList(String.valueOf(mrkt.Id), mrkt.Market_Id__c, true);
                
        //Create object of MarketLeaderTitleUtils
        MarketLeaderTitleUtils leaderTitlUtils = new MarketLeaderTitleUtils();
        leaderTitlUtils.initialize(testUsr);
        
        MailPlan_Order_Oppty__c mlplnOrdOppty = TestDataHelper.createMPOrderOpp(String.valueOf(mrkt.Id), '4', 'N', System.today().addDays(1+10), 
                                                                                'M' + 1, 'XZ1', 'M' + 1, true);
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Acct Coach', 'USD', true);
        
        //Create Contact
        List <Contact> conList = new List <Contact>();
        Contact con = TestDataHelper.createContact(mktIdKey, String.valueOf(acct.Id), false);
        con.MRKT_ACCT_KEY__c = mktIdKey + testUsrAcctNbr;
        conList.add(con);
        
        Contact conOne = TestDataHelper.createContact(mktIdKey + '1', String.valueOf(acct.Id), false);
        conOne.MRKT_ACCT_KEY__c = mktIdKey + mktIdKey;
        conList.add(conOne);
        
        insert conList;       
        
        List <ALM_Rep_Performance_1__c> almRepList = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c almRep1 = TestDataHelper.createRepPerformance(con.Id, mrkt, testUsrAcctNbr, false);
        almRep1.MailPlan_Order_Oppty__c = mlplnOrdOppty.Id;
        almRep1.Name = '1';
        almRepList.add(almRep1);
        
        ALM_Rep_Performance_1__c almRep2 = TestDataHelper.createRepPerformance(con.Id, mrktOne, testUsrAcctNbr, false);
        almRep2.MailPlan_Order_Oppty__c = mlplnOrdOppty.Id;
        almRep2.Name = '2';
        almRepList.add(almRep2);
        
        insert almRepList;
                                
        List <Sales_Leader_History__c> salesLeaderList = new List <Sales_Leader_History__c>();                              
        Sales_Leader_History__c salesLeader1 = TestDataHelper.createSalesLeaderHistory(con.Id, false);
        salesLeaderList.add(salesLeader1);
                            
        Sales_Leader_History__c salesLeader2 = TestDataHelper.createSalesLeaderHistory(con.Id, false);
        salesLeaderList.add(salesLeader2);
                            
        Sales_Leader_History__c salesLeader3 = TestDataHelper.createSalesLeaderHistory(con.Id, false);
        salesLeaderList.add(salesLeader3);
        
        insert salesLeaderList;
        
        PageReference pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey', testUsrAcctNbr);
        Test.setCurrentPage(pageRef);
        
        System.runAs(testUsr) {
            Test.startTest();
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
            
            ctrl.displayPSB = true;
            ctrl.displayLeadership = true;
            ctrl.displayEUP = true;
            System.assertEquals(ctrl.togglePSB() == null, true);
            System.assertEquals(ctrl.toggleLeadership() == null, true);
            System.assertEquals(ctrl.toggleEUP() == null, true);
            
            ctrl.displayPSB = null;
            ctrl.displayLeadership = null;
            ctrl.displayEUP = null;
            System.assertEquals(ctrl.displayPSB == false, true);
            System.assertEquals(ctrl.displayLeadership == false, true);
            System.assertEquals(ctrl.displayEUP == false, true);
            
            ctrl.displayPSB = false;
            ctrl.togglePSB();
            System.assertEquals(ctrl.displayPSB == true, true);
            
            ctrl.displayLeadership = false;
            ctrl.toggleLeadership();
            System.assertEquals(ctrl.displayLeadership == true, true);
            
            ctrl.displayEUP = false;
            ctrl.toggleEUP();
            System.assertEquals(ctrl.displayEUP == true, true);
            
            ctrl.currentUser = testUsr;
            //ctrl.getPrintFunction();
            Test.stopTest();
        }
        
        System.runAs(testUsr) {
            mrkt.Section_Ldrship__c = 'Test Rep Detail 4';
            update mrkt;
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
        }
        
        System.runAs(testUsr) {
            mrkt.Section_Ldrship__c = 'Paid Title';
            update mrkt;
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
        }
        
        System.runAs(testUsr) {
            mrkt.Section_Ldrship__c = 'Test Rep Detail 6';
            update mrkt;
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
        }
        
        System.runAs(testUsr) {
            mrkt.Section_EUP__c = 'Test Rep Detail 7';
            update mrkt;
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
        }
        
        pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey', null);
        PageRef.getParameters().put('repDetailAcctNbr', testUsrAcctNbr);
        Test.setCurrentPage(pageRef);
        
        con.REP_HM_PHON_NR__c = '';
        con.REP_WORK_PHONE_NR__c = '9999977777';
        update con;
        
        testUsr.LDRSHP_TITL_LVL_NBR__c = '-1';
        update testUsr;
        
        System.runAs(testUsr) {
            mrkt.X90_Day_Camp_CNT__c = 6;
            update mrkt;
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();            
        }

        pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey', null);
        PageRef.getParameters().put('repDetailAcctNbr', null);
        Test.setCurrentPage(pageRef);
        
        testUsr.LDRSHP_TITL_LVL_NBR__c = '1';
        update testUsr;
        
        System.runAs(testUsr) {
            mrkt.X90_Day_Camp_CNT__c = 2;
            mrkt.Market_Currency_Symbol__c = null;
            mrkt.LAST_UPDT_DT__c = null;
            update mrkt;
            
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
            ctrl.getOmniturePageName4Coach();
        }
    }
}