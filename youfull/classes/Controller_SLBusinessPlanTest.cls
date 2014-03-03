/**************************************************************************************
 Name         : Controller_SLBusinessPlanTest
 Modified By  : Barkha Jain 
 Description  : Test class for Controller_SLBusinessPlan
 Created Date : Jan 21, 2014     
***************************************************************************************/
@isTest
private class Controller_SLBusinessPlanTest{
    static String mktIdKey = '62';
    static String acctNr = '123456';
    static User testUsr;
    
    //----------------------------------------------------------------------------
    // Method Name  : testBusinessPlan
    // Description  : Method for Test Coverage of Class : BusinessPlanController
    //----------------------------------------------------------------------------  
    static testMethod void testBusinessPlan() {
        // Creating Business Plan data
        testCreateDataBusinessPlan();
        
        PageReference pageRef = Page.SLBusinessPlan;
        Test.setCurrentPageReference(pageRef);
                        
        test.startTest();
        System.runAs(testUsr) {
            Controller_SLBusinessPlan ctrl = new Controller_SLBusinessPlan();
            system.assert(!ctrl.isInProgPlan);
            
            ctrl.BP.Short_Term_Goals__c = 'test goal';
            ctrl.saveBP();
            //verify result
            system.assert(ctrl.isInProgPlan);
            system.assert([select count() from Business_Plan__c where Is_BP_Saved__c = true] > 0);
            
            //start new plan
            ctrl.startNewPlan();
            //verify result
            system.assertEquals(null, ctrl.BP.Short_Term_Goals__c);
            system.assert(!ctrl.isInProgPlan);
            
            //save the new BP
            ctrl.BP.Short_Term_Goals__c = 'test goal 2';
            ctrl.saveBP();
            system.assert(ctrl.isInProgPlan);
            //verify result (existing should be marked as deleted)
            system.assert([select count() from Business_Plan__c where IsDeleted__c = true] > 0);
            
            ctrl = new Controller_SLBusinessPlan();
            system.assertEquals('test goal 2', ctrl.BP.Short_Term_Goals__c);
            system.assert(ctrl.isInProgPlan);
            
            ctrl.BP.Short_Term_Goals__c = 'test goal';
            ctrl.saveBP();
            system.assert([select count() from Business_Plan__c where IsDeleted__c = true] == 0);
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
        Market__c mrkt = TestDataHelper.createMarket(mktIdKey, false);
        mrkt.Market_Currency_Symbol__c = '₱';
        mrkt.OwnerId = testUsr.Id;
        mrkt.Is_ALMPLUS_Enabled__c = true;
        mrkt.Business_Plan_KPIs__c = 'Personal_Volume_dollar;Personal_Appointments;Qualified_Personal_Appointments;G1_Removals;G1_Active_Representatives;G1_Activity_Rate;Total_Unit_Sales_dollor;';
        insert mrkt;
        
        //insert custom settings
        TestDataHelper.createALMGlobalSetting(true);
        TestDataHelper.createApexLogSetting(true);
        
        //create Object: Calendar
        List <Calendar__c> calendars = new List <Calendar__c>();
        for (Integer i = 201301; i < 201312; i++) {
            calendars.add(TestDataHelper.createCalendar(i, mrkt.Market_Id__c, 2013, mrkt.Id, false));            
        }        
        for (Integer j = 201209; j < 201216; j++) {
            calendars.add(TestDataHelper.createCalendar(j, mrkt.Market_Id__c, 2012, mrkt.Id, false));            
        }
        insert calendars;        
        
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact
        List <Contact> lstContact = new List <Contact>();
        Contact con1 = TestDataHelper.createContact(acctNr, acct.Id, false);
        con1.OwnerId = testUsr.Id;
        con1.MRKT_ACCT_KEY__c = mktIdKey + testUsr.ACCT_NR__c;      
        lstContact.add(con1);
         
        Contact con2 = TestDataHelper.createContact(acctNr + '01', acct.Id, false);
        con2.OwnerId = testUsr.Id;
        lstContact.add(con2);        
        insert lstContact;    
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List <ALM_Rep_Performance_1__c> lstRepPerf = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(lstContact[0].Id, mrkt, acctNr, false);
        rep1.Genealogy_Level__c = 0;
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 8;
        lstRepPerf.add(rep1);
        
        ALM_Rep_Performance_1__c rep2 = TestDataHelper.createRepPerformance(con2.Id, mrkt, acctNr+'1', false);
        rep2.ROOT_UPLN_ACCT_NR__c = acctNr;
        rep2.Genealogy_Level__c = 1;
        rep2.LFT_ND_ID__c = 0;
        rep2.RGT_ND_ID__c = 9;
        lstRepPerf.add(rep2);        
        insert lstRepPerf;        
        
        // Creating Business Plan Parameter data 
        Business_Plan_Parameter__c testBPpar = TestDataHelper.createBusinessPlanParameter(mrkt.Id, true);
        
        //Create Object: Sales_Leader_History__c
        List <Sales_Leader_History__c> salesLeaderList = new List <Sales_Leader_History__c>();
        Sales_Leader_History__c salesLeaderOne = TestDataHelper.createSalesLeaderHistory(con1.Id, false);
        salesLeaderOne.FLD_SLS_CMPGN_NR__c = 201303.0;
        salesLeaderList.add(salesLeaderOne);
        
        Sales_Leader_History__c salesLeaderTwo = TestDataHelper.createSalesLeaderHistory(con1.Id, false);
        salesLeaderTwo.FLD_SLS_CMPGN_NR__c = 201302.0;
        salesLeaderList.add(salesLeaderTwo);
        insert salesLeaderList;            
    } 

}