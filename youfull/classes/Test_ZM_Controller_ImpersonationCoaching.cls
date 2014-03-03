/***************************************************************************
 Name         : Test_ZM_Controller_ImpersonationCoaching
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Controller_ImpersonationCoachingRec
 Created Date : Nov 7, 2013                
****************************************************************************/
@isTest
private class Test_ZM_Controller_ImpersonationCoaching {
	static String acctNbr = '123456';
    static String mrktId = 'DE';
    static Contact con1;
    static User usr;
    static ALM_Rep_Performance_1__c rep1;
     
	//----------------------------------------------------------------------------
    // Method Name  : testZMImpersonationCoaching
    // Description  : Method for Test Coverage of Class : ZM_Controller_ImpersonationCoachingRec
    //----------------------------------------------------------------------------
    static testMethod void testZMImpersonationCoaching() {
        createTestData();
        
        PageReference pageRef1 = Page.ZM_Impersonation_CoachingRecord;
        pageRef1.getParameters().put('id', con1.Id);
        pageRef1.getParameters().put('searchText', 'testSearch');
        pageRef1.getParameters().put('repDetailAcctNbr', acctNbr);
        Test.setCurrentPage(pageRef1);
        Test.startTest();
        
        System.runAs(usr){
        	ZM_Controller_ImpersonationCoachingRec ctrl = new ZM_Controller_ImpersonationCoachingRec();	
        	Pagereference pg = ctrl.autoRun();
        	//verify result (no ALM_Rep_Performance_1__c record found)
        	system.assert(pg.getUrl().contains('/apex/errorpage'));
        }
        
        // insert Combined Object data
        insert rep1;
        
        System.runAs(usr){
        	ZM_Controller_ImpersonationCoachingRec ctrl = new ZM_Controller_ImpersonationCoachingRec();	
        	ctrl.repDetailAcctNbr = null;
        	ctrl.callRepDetails();
        	//verify result
        	system.assertEquals(acctNbr, ctrl.repDetailAcctNbr);
        	
        	ctrl.saveSearchText();
        	Pagereference pg = ctrl.autoRun();
        	//verify result
        	system.assert(pg.getUrl().contains('/apex/YOUHome'));
        }
        
        con1.ACCT_NR__c = acctNbr + '7';
        update con1;
        rep1.ACCT_NR__c = con1.ACCT_NR__c;
        update rep1;        
        
        System.runAs(usr){
        	ZM_Controller_ImpersonationCoachingRec ctrl = new ZM_Controller_ImpersonationCoachingRec();	
        	Pagereference pg = ctrl.autoRun();
        	//verify result
        	system.assert(pg.getUrl().contains('/apex/errorpage?msg=Err_Msg_Impersonation'));
        } 
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method to create test data
    //----------------------------------------------------------------------------
    static void createTestData(){
    	usr = TestDataHelper.createUser(acctNbr, 'XZ1', ' Zone Manager', false);
        usr.MRKT_ID__c = mrktId;
        usr.MRKT_ID_ACCT_NR_KEY__c = mrktId + acctNbr;
        insert usr;
        
        // Creates Market Data
        Market__c mkt = TestDataHelper.createMarket('DE', false);
        System.runAs (usr) {
            mkt.Mail_Plan_Enabled__c = true;
            insert mkt;
        }
        
        // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', System.today().addDays(1+10), 
    											'M1', 'XZ1', 'M', true);
    											
        TestDataHelper.createALMGlobalSetting(true);
        // Creates Account Data
        System.runAs(usr){
	        Account testAcct = TestDataHelper.createAccount('Test Acount', 'USD', true);
	        // Creates Contact data
	        con1 = TestDataHelper.createContact(acctNbr, testAcct.Id, false);
	        con1.MRKT_ACCT_KEY__c = mrktId + acctNbr;
	        con1.MLPLN_CD__c = mlplnOrdOppty.MLPLN_CD__c;
	        con1.MRKT_ID__c = mrktId;
        	insert con1;
        }
        
        // Creates Combined Object data
        rep1 = TestDataHelper.createRepPerformance(con1.Id, mkt, acctNbr, false);
    }
}