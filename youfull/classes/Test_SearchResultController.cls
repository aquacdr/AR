/***************************************************************************
 Name          : Test_SearchResultController 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for SearchResultController
 Created Date  : Nov 7, 2013                
****************************************************************************/
@isTest
private class Test_SearchResultController {

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
    
    //---------------------------------------------------------------------------
    // Method Name  : testSearchResultController
    // Description  : Method for Test Coverage for SearchResultController
    //---------------------------------------------------------------------------
    static testMethod void testSearchResultController() {
      createTestData();  
      PageReference pageRef = Page.searchPage;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put('campaign', 'current');
        PageRef.getParameters().put(ALMConstants.SEARCH_URL_PARAM, downlineOneAcctNr);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            SearchResultController searchController = new SearchResultController();
            searchController.keyword=downlineOneAcctNr;
            searchController.defaultKeyword=downlineOneAcctNr;
            searchController.option='accountnumber';
            searchController.getInitialized();           
            searchController.doSearch();
            System.assert(searchController.resultList.size() > 0);
            searchController.FirstPageList();
            searchController.LastPageList();
            searchController.getCurrentPageList();
            searchController.NextPageList();
            searchController.PrevPageList();
            searchController.getNumberOfPages();
            searchController.getLast();
            searchController.getPrevious();
            searchController.getNext();
            searchController.viewLink();
        }
    }
        
     // Method creates test data
    private static void createTestData() {
        
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        
        // Create market data
        mkt = TestDataHelper.createMarket(demoMktCode, false);
        mkt.Mail_Plan_Enabled__c = true;
        insert mkt;
      
        // Create Users        
        List<User> users = new List<User>();
            uplineUser = TestDataHelper.createUser(uplineAcctNr, 'XZ1', 'Avon Leader', false);
            uplineUser.MRKT_ID__c = mkt.Market_Id__c;
            users.add(uplineUser);
            downlineOneUser = TestDataHelper.createUser(downlineOneAcctNr, 'XZ1', 'Avon Leader', false);
            downlineOneUser.MRKT_ID__c = mkt.Market_Id__c;
            users.add(downlineOneUser);
            downlineTwoUser = TestDataHelper.createUser(downlineTwoAcctNr, 'XZ1', 'Avon Leader', false);
            downlineTwoUser.MRKT_ID__c = mkt.Market_Id__c;
            users.add(downlineTwoUser);
            downlineThreeUser = TestDataHelper.createUser(downlineThreeAcctNr, 'XZ1', 'Avon Leader', false);
            downlineThreeUser.MRKT_ID__c = mkt.Market_Id__c;
            users.add(downlineThreeUser);
            downlineFourUser = TestDataHelper.createUser(downlineFourAcctNr, 'XZ1', 'Avon Leader', false);
            downlineFourUser.MRKT_ID__c = mkt.Market_Id__c;
            users.add(downlineFourUser);
            insert users;       
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
            con1.MRKT_ACCT_KEY__c = mkt.Market_Id__c + uplineAcctNr + '0' + index;
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
                                            1, 8, false));                                                                                      
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'01', uplineAcctNr, uplineAcctNr,
                                            1, lstContact[1].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mrkt.CMPGN_NR__c,  
                                            2, 3, false));                                              
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'02', uplineAcctNr, uplineAcctNr,
                                            1, lstContact[2].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            4, 5, false));      
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'03', uplineAcctNr+'02', uplineAcctNr,
                                            1, lstContact[3].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            6, 7, false));                                                    
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'04', uplineAcctNr+'02', uplineAcctNr,
                                            1, lstContact[3].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            6, 7, false));      
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(uplineAcctNr+'05', uplineAcctNr, uplineAcctNr,
                                            1, lstContact[4].Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            6, 7, false));
        insert lstRepPerf;
    }
    
}