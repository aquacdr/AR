/***************************************************************************
 Name         : Test_IncentivesController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for IncentivesController
 Created Date : Nov. 01, 2013                
****************************************************************************/

@isTest
private class Test_IncentivesController {

	//----------------------------------------------------------------------------
    // Method Name  : testIncentivesController
    // Description  : Method for Test Coverage of Class : IncentivesController
    //----------------------------------------------------------------------------  
    public static testmethod void testIncentivesController() {
    	String mktIdKey = '62';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.CMPGN_NR__c = '1';
        marketOne.Mail_Plan_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('1111', 'XZ1', 'Avon Leader', false);
        testUsr.ACCT_NR__c = '1111';
        testUsr.MRKT_ID__c = mktIdKey;
        testUsr.MRKT_ID_ACCT_NR_KEY__c = testUsr.MRKT_ID__c + '1111';
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('11117', 'XZ2', 'Avon Leader', false);
        testUsrOne.MRKT_ID__c = mktIdKey;
        usrList.add(testUsrOne);
        
        insert usrList;
        
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact
	    Contact con = TestDataHelper.createContact('1111', acct.Id, true);
        
        //Create Object: Incentive__c
        List <Incentive__c> incentiveList = new List <Incentive__c>();
        Incentive__c incentiveOne = TestDataHelper.createIncentive(String.valueOf(marketOne.Id), marketOne.CMPGN_NR__c, false);
        incentiveList.add(incentiveOne);
        
        Incentive__c incentiveTwo = TestDataHelper.createIncentive(String.valueOf(marketOne.Id), marketOne.CMPGN_NR__c, false);
        incentiveTwo.Type__c = 'personal';
        incentiveList.add(incentiveTwo);
        
        insert incentiveList;
        
        //Create Object: MailPlan_Order_Oppty__c
        MailPlan_Order_Oppty__c mailPlanOrder = TestDataHelper.createMPOrderOpp(String.valueOf(marketOne.Id), '4', 'N', System.today().addDays(1+10), 
                                                                                'M' + 1, 'XZ1', 'M' + 1, true);
                                                                                
        //Create Object: ALM_Rep_Performance_1__c
        List <ALM_Rep_Performance_1__c> almRepList = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c almRepPerform = TestDataHelper.createRepPerformance(String.valueOf(con.Id), marketOne, '1111', false);
	    almRepPerform.ACCT_NR__c = '1111';
	    almRepPerform.MRKT_ID__c = mktIdKey;
	    almRepPerform.FLD_SLS_CMPGN_NR__c = 1.0;
	    almRepPerform.LCL_TOP_SLR_LVL_KEY__c = '1';
	    almRepPerform.MailPlan_Order_Oppty__c = mailPlanOrder.Id;
	    almRepList.add(almRepPerform);
    	
    	insert almRepList;
    	
    	//Create Object: Seller_Status__c
    	List <Seller_Status__c> sellerStatusList = TestDataHelper.createSellerStatusList(String.valueOf(marketOne.Id), false);
    	sellerStatusList[0].MRKT_ID__c = testUsr.MRKT_ID__c;
    	sellerStatusList[0].LCL_TOP_SLR_LVL_KEY__c = '1';
    	sellerStatusList[0].LANG_CD__c = testUsr.LanguageLocaleKey;
    	
    	insert sellerStatusList;
    	
    	PageReference pageRefOne = Page.Incentives;
        pageRefOne.getParameters().put(ALMConstants.IMPERSON_PARAM_NAME, '1111');
        Test.setCurrentPageReference(pageRefOne);
        
    	System.runAs(testUsr) {
    		Test.startTest();
	    	ComponentController compCntrl = new ComponentController();
	    	
	    	IncentivesController incentCntrl = new IncentivesController();
	    	Test.stopTest();
    	}
    	
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testIncentivesControllerOne
    // Description  : Method for Test Coverage of Class : IncentivesController
    //----------------------------------------------------------------------------  
    public static testmethod void testIncentivesControllerOne() {
    	String mktIdKey = '123456';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.CMPGN_NR__c = '1';
        marketOne.Mail_Plan_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
        testUsr.ACCT_NR__c = mktIdKey;
        testUsr.MRKT_ID_ACCT_NR_KEY__c = testUsr.MRKT_ID__c + '1111';
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser(mktIdKey + '7', 'XZ2', 'Avon Leader', false);
        testUsrOne.ACCT_NR__c = mktIdKey;
        usrList.add(testUsrOne);
        
        insert usrList;
        
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact
	    Contact con = TestDataHelper.createContact(mktIdKey, acct.Id, true);
        
        //Create Object: Incentive__c
        List <Incentive__c> incentiveList = new List <Incentive__c>();
        Incentive__c incentiveOne = TestDataHelper.createIncentive(String.valueOf(marketOne.Id), marketOne.CMPGN_NR__c, false);
        incentiveList.add(incentiveOne);
        
        Incentive__c incentiveTwo = TestDataHelper.createIncentive(String.valueOf(marketOne.Id), marketOne.CMPGN_NR__c, false);
        incentiveTwo.Type__c = 'personal';
        incentiveList.add(incentiveTwo);
        
        insert incentiveList;
        
        //Create Object: MailPlan_Order_Oppty__c
        MailPlan_Order_Oppty__c mailPlanOrder = TestDataHelper.createMPOrderOpp(String.valueOf(marketOne.Id), '4', 'N', System.today().addDays(1+10), 
                                                                                'M' + 1, 'XZ1', 'M' + 1, true);
                                                                                
        //Create Object: ALM_Rep_Performance_1__c
        List <ALM_Rep_Performance_1__c> almRepList = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c almRepPerform = TestDataHelper.createRepPerformance(String.valueOf(con.Id), marketOne, mktIdKey, false);
	    almRepPerform.ACCT_NR__c = mktIdKey;
	    almRepPerform.MRKT_ID__c = mktIdKey + '7';
	    almRepPerform.FLD_SLS_CMPGN_NR__c = 1.0;
	    almRepPerform.LCL_TOP_SLR_LVL_KEY__c = '1';
	    almRepPerform.MailPlan_Order_Oppty__c = mailPlanOrder.Id;
	    almRepPerform.LDRSHP_TITL_LVL_NR__c = '111';
	    almRepList.add(almRepPerform);
    	
    	insert almRepList;
    	
    	PageReference pageRefOne = Page.Incentives;
        pageRefOne.getParameters().put(ALMConstants.IMPERSON_PARAM_NAME, '1111');
        Test.setCurrentPageReference(pageRefOne);
        
    	System.runAs(testUsr) {
    		Test.startTest();
	    	ComponentController compCntrl = new ComponentController();
	    	
	    	IncentivesController incentCntrl = new IncentivesController();
	    	Test.stopTest();
    	}
    }
}