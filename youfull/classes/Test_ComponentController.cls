/***************************************************************************
 Name          : Test_ComponentController
 Created By    : Barkha Jain (JDC)
 Description   : Test class for ComponentController
 Created Date  : Nov 6, 2013                
****************************************************************************/
@isTest
private class Test_ComponentController {
	static Market__c mkt;
    static String mrktId = 'DE';
    static User usr;
    static ALM_Rep_Performance_1__c rep;
    
	//----------------------------------------------------------------------------
    // Method Name  : testComponentController
    // Description  : Method for Test Coverage of Class : ComponentController
    //----------------------------------------------------------------------------
    static testMethod void testComponentController() {
    	createTestData();
    	
        PageReference pg = new PageReference('/apex/ELRisingStars');
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('mpCampaign', mkt.CMPGN_NR__c);
        ApexPages.currentPage().getParameters().put('acctkey', '1234');
        
        Test.startTest();
        system.runAs(usr){  
        	ComponentController ctrl = new ComponentController();
        	Pagereference result = ctrl.isValidPage();
        	//verify result
        	system.assertNotEquals(null, result.getParameters().get('errId'));
        }
        
        //insert ALM_Rep_Performance_1__c record	
        insert rep;
        
        system.runAs(usr){	
        	ComponentController ctrl = new ComponentController();
        	
        	rep = [select Id, MailPlan_Order_Oppty__r.CMPGN_NR__c from ALM_Rep_Performance_1__c where Id =:rep.Id limit 1];
        	//test getMailPlanCampaign method
        	try{
        		ctrl.getMailPlanCampaign(new List<ALM_Rep_Performance_1__c>{rep});
        	}catch(Exception e){}
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
            mkt = TestDataHelper.createMarket(mrktId, false);
            mkt.Mail_Plan_Enabled__c = true;
            insert mkt;
        }
        
        Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
    	Contact c = TestDataHelper.createContact('1234', acc.Id, false);
    	c.MRKT_ACCT_KEY__c = mrktId + '1234';
    	insert c;
    	
    	MailPlan_Order_Oppty__c mplan = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', System.today().addDays(1+10), 
    											'M1', 'XZ1', 'M', false);
    
    	rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', false);	
    	rep.MailPlan_Order_Oppty__c = mplan.Id;
    	rep.LFT_ND_ID__c = 0;
	    rep.RGT_ND_ID__c = 5;
	    
	    Landing_Page_Config__c config = TestDataHelper.createLandingPageConfig(mkt.Id, 'All', 'All', true);
	    TestDataHelper.createLadingPageComponent(config.Id, 'ELRisingStars', true);
       
    }
}