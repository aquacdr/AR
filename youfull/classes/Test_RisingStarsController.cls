/***************************************************************************
 Name          : Test_RisingStarsController
 Created By    : Barkha Jain (JDC)
 Description   : Test class for RisingStarsController
 Created Date  : Nov 6, 2013                
****************************************************************************/
@isTest
private class Test_RisingStarsController {
    static Market__c mkt;
    static String mrktId = 'DE';
    static User usr;
    
    //----------------------------------------------------------------------------
    // Method Name  : testRisingStarsController
    // Description  : Method for Test Coverage of Class : RisingStarsController
    //----------------------------------------------------------------------------
    static testMethod void testRisingStarsController() {
        createTestData();
        
        ApexPages.currentPage().getParameters().put('mpCampaign', mkt.CMPGN_NR__c);
        
        Test.startTest();   
        system.runAs(usr){  
            RisingStarsController ctrl = new RisingStarsController();
            //verify result
            system.assert(ctrl.rsngStrs_hasData);
        }
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method to create test data
    //----------------------------------------------------------------------------
    private static void createTestData(){
        TestDataHelper.createALMGlobalSetting(true);
        //creating test user
        usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = mrktId;
        usr.MRKT_ID_ACCT_NR_KEY__c = mrktId + '1234';
        insert usr;
                        
        System.runAs(usr){
            mkt = TestDataHelper.createMarket(mrktId, true);
        }
        
        Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
        Contact c = TestDataHelper.createContact('1235', acc.Id, false);
        c.MRKT_ACCT_KEY__c = mrktId + '123501';
        insert c;
        
        //creating test Genealogy records
        List<ALM_Rep_Performance_1__c> repLst = new List<ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', false);   
        rep.LFT_ND_ID__c = 0;
        rep.RGT_ND_ID__c = 5;
        repLst.add(rep);
        
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(c.Id, mkt, '1235', false);  
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 2;
        rep1.RSNG_STR_IND__c = 'Y' ;
        rep1.EXEC_RSNG_STR_IND__c = 'Y';
        rep1.ROOT_UPLN_ACCT_NR__c = '1234';
        repLst.add(rep1);
        insert repLst;
    }

}