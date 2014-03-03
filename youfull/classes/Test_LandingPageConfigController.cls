/***************************************************************************
 Name          : Test_LandingPageConfigController 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for LandingPageConfigController
 Created Date  : Nov 9, 2013                
****************************************************************************/
@isTest
private class Test_LandingPageConfigController {

	static Account testAcct;    
    private static String lang = 'en_US';
    private static String currentCmpgn = '201204';
    private static String priorCmpgn = '201203';
    private static String uplineAcctNr = 'upln1';
    private static String downlineOneAcctNr = uplineAcctNr+'01';
    private static String downlineOneZoneNumber = 'DW1';
    private static String downlineOneProfileName = 'Avon Leader';
    private static String downlineTwoAcctNr = uplineAcctNr+'02';
    private static String downlineThreeAcctNr = uplineAcctNr+'03';
    private static String downlineFourAcctNr = uplineAcctNr+'04';
    private static String demoMktCode = 'DE';
    private static Market__c mkt;
    private static User uplineUser, downlineOneUser, downlineTwoUser, downlineThreeUser, downlineFourUser;
    private static List<ALM_Rep_Performance_1__c> lstRepPerf;
    private static Map<String, Contact> mapContact;
    private static MailPlan_Order_Oppty__c mpOpp;
    
    //---------------------------------------------------------------------------
    // Method Name  : testLandingPageConfigController
    // Description  : Method for Test Coverage for LandingPageConfigController
    //---------------------------------------------------------------------------
    static testMethod void testLandingPageConfigController() {
        createTestData();
        
        //Landing Page
        PageReference pageRef = Page.YOUHome;
        PageRef.getParameters().put('pageId','1');
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            LandingPageConfigController lpController = new LandingPageConfigController();              
            lpController.priorCampaign();
            lpController.currentCampaign();
            lpController.nextCampaign();
            lpController.saveSearchText();
            lpController.getOmniturePageName();
            lpController.callRepDetails();
            LandingPageUtils.setBattery(new BatteryChartParams(), 100, 50, 200); 
            LPDownlineWrapper wrapper = new LPDownlineWrapper();           
            List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, uplineAcctNr, mkt.Market_ID__c);
            System.assert(lpController.getMailPlanCampaign(lst_CombinedObj) != null);
        }
        
        // Test landing page for mail plan market
        Market__c mpmarket=[Select Id,Mail_Plan_Enabled__c from Market__c where Market_Id__c=:uplineUser.MRKT_ID__c];
        mpmarket.Mail_Plan_Enabled__c=true;
        update mpmarket;
        
        System.runAs(uplineUser){
            LandingPageConfigController lpController = new LandingPageConfigController();              
            lpController.priorCampaign();
            lpController.currentCampaign();
            lpController.nextCampaign();
            lpController.saveSearchText();
            lpController.getOmniturePageName();
            lpController.callRepDetails();
            List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, uplineAcctNr, mkt.Market_ID__c);
            System.assert(lpController.getMailPlanCampaign(lst_CombinedObj) != null);
        }
    }
    
     // Method creates test data
    private static void createTestData() {
        
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        
        // Create market data
        mkt = TestDataHelper.createMarket(demoMktCode, true);
        
        // Create leader titles
        List<Leader_Title__c> leaderTitles = TestDataHelper.createLeaderTitlesList(mkt.id, mkt.Market_Id__c, true);
        
        // Create Mail Plan Order
    	DateTime d = System.now().addDays(15);
    	Date mpDate = date.newinstance(d.year(), d.month(), d.day());
        mpOpp = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', mpDate, true);
        
        // Create Users        
        List<User> users = new List<User>();
            uplineUser = TestDataHelper.createUser(uplineAcctNr, 'XZ1', 'Avon Leader', false);
            uplineUser.MRKT_ID__c = mkt.Market_Id__c;
            uplineUser.MRKT_ID_ACCT_NR_KEY__c = mkt.Market_Id__c + uplineAcctNr;
            users.add(uplineUser);
            downlineOneUser = TestDataHelper.createUser(downlineOneAcctNr, 'XZ1', 'Avon Leader', false);
            downlineOneUser.MRKT_ID__c = mkt.Market_Id__c;
            downlineOneUser.MRKT_ID_ACCT_NR_KEY__c = mkt.Market_Id__c + downlineOneAcctNr;
            users.add(downlineOneUser);
            downlineTwoUser = TestDataHelper.createUser(downlineTwoAcctNr, 'XZ1', 'Avon Leader', false);
            downlineTwoUser.MRKT_ID__c = mkt.Market_Id__c;
            downlineTwoUser.MRKT_ID_ACCT_NR_KEY__c = mkt.Market_Id__c + downlineTwoAcctNr;
            users.add(downlineTwoUser);
            downlineThreeUser = TestDataHelper.createUser(downlineThreeAcctNr, 'XZ1', 'Avon Leader', false);
            downlineThreeUser.MRKT_ID__c = mkt.Market_Id__c;
            downlineThreeUser.MRKT_ID_ACCT_NR_KEY__c = mkt.Market_Id__c + downlineThreeAcctNr;
            users.add(downlineThreeUser);
            downlineFourUser = TestDataHelper.createUser(downlineFourAcctNr, 'XZ1', 'Avon Leader', false);
            downlineFourUser.MRKT_ID__c = mkt.Market_Id__c;
            downlineFourUser.MRKT_ID_ACCT_NR_KEY__c = mkt.Market_Id__c + downlineFourAcctNr;
            users.add(downlineFourUser);
            insert users; 
        
        // Create custom messages   
        TestDataHelper.createCustomMessages(mkt, uplineUser.Id);      
        mapContact = new Map<String, Contact>();
             
        // Creating Account and contact data
        testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);        
                   
        List<Contact> lstContact = new List<Contact>();
        Contact con1;
        for(Integer index = 0;index < 6;index++){
            con1 = TestDataHelper.createContact(uplineAcctNr, testAcct.id, false);
            con1.Email = 'test' + index + '@avon.com';
            con1.FirstName = uplineAcctNr + 'First' + index;
            con1.LastName = uplineAcctNr + 'Last' + index;          
            if(index >= 3){
                con1.OwnerId = users[2].Id;
            }else{
                con1.OwnerId = users[index].Id;
            }
            con1.ACCT_NR__c = uplineAcctNr + '0' + index;
            if(index > 0){            
            	con1.MRKT_ACCT_KEY__c = mkt.Market_Id__c + uplineAcctNr + '0' + index;
            }else{
            	con1.MRKT_ACCT_KEY__c = mkt.Market_Id__c + uplineAcctNr;
            }
            lstContact.add(con1);
        }
        insert lstContact;
       
        // Insert ALM Rep Performance records for each contact for each campaign
        lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        createALMRepPerformanceRecords(lstContact, mkt);        
    }
       
     // Method inserts ALM Rep Performance records for each contact for each campaign
    private static void createALMRepPerformanceRecords(List<Contact> lstContact,
                                                                    Market__c mrkt){
                                                                        
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr, null, uplineAcctNr,
                                            0, lstContact[0].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            1, 8, 1000, 1500, null, null, null, '1', false)); 
                                                                                        
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'01', uplineAcctNr, uplineAcctNr,
                                            1, lstContact[1].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mrkt.CMPGN_NR__c,  
                                            2, 3, 1000, 1500, null, null, null, '1', false));
                                                    
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'02', uplineAcctNr, uplineAcctNr,
                                            1, lstContact[2].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            4, 5, 1000, 1500, null, null, null, '0', false)); 
                                                         
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'03', uplineAcctNr+'02', uplineAcctNr,
                                            1, lstContact[3].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            6, 7, 1000, 1500, 2000, null, null, '2', false));                                                    
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'04', uplineAcctNr+'02', uplineAcctNr,
                                            1, lstContact[3].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            6, 7, 1000, 1500, 2000, 500, 700, '7', false));      
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'05', uplineAcctNr, uplineAcctNr,
                                            1, lstContact[4].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            6, 7, 1000, 1500, 2000, 500, 700, '7', false));
        for(ALM_Rep_Performance_1__c almRep : lstRepPerf){
        	almRep.MailPlan_Order_Oppty__c = mpOpp.Id;
        }
        insert lstRepPerf;
    }
}