/***************************************************************************
 Name          : Test_G1CandidatesController
 Created By    : Barkha Jain (JDC)
 Description   : Test class for G1CandidatesController
 Created Date  : Nov 7, 2013                
****************************************************************************/
@isTest
private class Test_G1CandidatesController {
	
	static Market__c mkt;
    static String mrktId = '62';
    static User usr;
    static List<ALM_Rep_Performance_1__c> repLst;
    
	//----------------------------------------------------------------------------
    // Method Name  : testG1CandiadatesCtrl
    // Description  : Method for Test Coverage of Class : G1CandidatesController
    //----------------------------------------------------------------------------
    static testMethod void testG1CandiadatesCtrl() {
        createTestData();
    	
        PageReference pg = new PageReference('/apex/G1Candidates');
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('mpCampaign', mkt.CMPGN_NR__c);
        
        Test.startTest();
        system.runAs(usr){  
        	G1CandidatesController ctrl = new G1CandidatesController();
        	//verify exception result
        	system.assertEquals(null, ctrl.g1Cndt_hasData);
        }
        
        //insert rep performance record with user's accountNr
        insert repLst[0];		
        
        system.runAs(usr){  
        	G1CandidatesController ctrl = new G1CandidatesController();
        	//verify zero result
        	system.assertEquals(false, ctrl.g1Cndt_hasData);
        }
        
        //insert candidate record
        insert repLst[1];
        
        system.runAs(usr){ 	
        	G1CandidatesController ctrl = new G1CandidatesController();
        	//verify result
        	system.assertEquals(true, ctrl.g1Cndt_hasData);
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
        rep1.LDRSHP_TITL_LVL_NR__c = '0';
        rep1.UPLN_ACCT_NR__c = '1234';
        rep1.Genealogy_Level__c = 2;
        rep1.SLS_ZONE_CD__c = 'XZ1';
        rep1.BRNCH_SCTN_CD__c = 'XZ1';
        repLst.add(rep1);        
    }
}