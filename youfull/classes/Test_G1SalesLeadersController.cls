/***************************************************************************
 Name          : Test_G1SalesLeadersController
 Created By    : Barkha Jain (JDC)
 Description   : Test class for G1SalesLeadersController
 Created Date  : Nov 7, 2013                
****************************************************************************/
@isTest
private class Test_G1SalesLeadersController {
	
	static Market__c mkt;
    static String mrktId = '62';
    static User usr;
    static List<ALM_Rep_Performance_1__c> repLst;
    
	//----------------------------------------------------------------------------
    // Method Name  : testSalesLeadersCtrl
    // Description  : Method for Test Coverage of Class : G1SalesLeadersController
    //----------------------------------------------------------------------------
    static testMethod void testSalesLeadersCtrl() {
        createTestData();
    	
        PageReference pg = new PageReference('/apex/G1SalesLeaders');
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('mpCampaign', mkt.CMPGN_NR__c);
        
        Test.startTest();
        system.runAs(usr){  
        	G1SalesLeadersController ctrl = new G1SalesLeadersController();
        	//verify exception result
        	system.assertEquals(false, ctrl.g1SlsLdr_hasData);
        }
        
        //insert rep performance records
        insert repLst;	
        
        system.runAs(usr){ 	
        	G1SalesLeadersController ctrl = new G1SalesLeadersController();
        	//verify result
        	system.assertEquals(true, ctrl.g1SlsLdr_hasData);
        }
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
        Contact c = TestDataHelper.createContact('1234', acc.Id, false);
        c.MRKT_ACCT_KEY__c = mrktId + '1234';
        insert c;
        
        //creating test Genealogy records
        repLst = new List<ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', false);   
        rep.LFT_ND_ID__c = 0;
        rep.RGT_ND_ID__c = 5;
        rep.Genealogy_Level__c = 1;
        repLst.add(rep);
        
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(c.Id, mkt, '1235', false);  
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 2;
        rep1.REP_OMS_STUS_CD__c = '1';
        rep1.UPLN_ACCT_NR__c = '1234';
        rep1.Genealogy_Level__c = 2;
        rep1.SLS_ZONE_CD__c = 'XZ1';
        rep1.BRNCH_SCTN_CD__c = 'XZ1';
        repLst.add(rep1);        
    }
    
}