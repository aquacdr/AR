/***************************************************************************
 Name         : Test_MyActionItemsController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for MyActionItemsController
 Created Date : Oct. 28, 2013                
****************************************************************************/

@isTest
private class Test_MyActionItemsController { 
    
    //----------------------------------------------------------------------------
    // Method Name  : testMyActionItemsController
    // Description  : Method for Test Coverage of Class : MyActionItemsController
    //----------------------------------------------------------------------------  
    public static testmethod void testMyActionItemsController() {
        String mktIdKey = '55';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.Mail_Plan_Enabled__c = true;
        insert marketOne;
        
        //Create User
        User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID__c = mktIdKey; 
        insert testUsr;
        
        //Create Object: Action_Items__c
        List <Action_Items__c> actionItemList = TestDataHelper.createActionItems(true);
        
        //Create Object: Market_Action_Items__c
        List <Market_Action_Items__c> marketActionItemList = TestDataHelper.createMarketActionItems(String.valueOf(marketOne.Id), actionItemList, true);
        
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact  
	    Contact con = TestDataHelper.createContact('123456', acct.Id, true);
        
        PageReference pageRefOne = Page.MyActionItems;
        pageRefOne.getParameters().put(ALMConstants.CAMPAIGN, 'current;next');
        Test.setCurrentPageReference(pageRefOne);
               
        //test case for markets do not have Mailplan
        Test.startTest();
        System.runAs(testUsr) {
            MyActionItemsController objController = new MyActionItemsController();
            objController.init();   
            System.assertEquals(objController.cmpnNbr.size(), 1);
        }
        Test.stopTest();
        
        //test case for markets enables Mailplan
        marketOne.Mail_Plan_Enabled__c = true;
        update marketOne;
        
        List <MailPlan_Order_Oppty__c> mplst = new List <MailPlan_Order_Oppty__c>();
        
        MailPlan_Order_Oppty__c mpOne = TestDataHelper.createMPOrderOpp(marketOne.Id, '4', 'N', System.today().addDays(1+10), 
        											'M'+1, 'XZ1', 'M'+1, true); 
        mplst.add(mpOne);
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List <ALM_Rep_Performance_1__c> lstRepPerf = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(con.Id, marketOne, mktIdKey, false);
        rep1.MailPlan_Order_Oppty__c =  mpOne.Id;
        lstRepPerf.add(rep1);
        insert lstRepPerf;
        
               
        List <String> mktKeyLst = new List <String>();
        mktKeyLst.add(marketOne.Market_Id__c + marketOne.CMPGN_NR__c + testUsr.ACCT_NR__c);
        mktKeyLst.add(marketOne.Market_Id__c + marketOne.NEXT_1_CMPGN_NR__c + testUsr.ACCT_NR__c);
        
        String uplineAcctNr = testUsr.ACCT_NR__c;
        
        List <ALM_Rep_Performance_1__c> ppList = [SELECT Id, MailPlan_Order_Oppty__c, AVG_GENRTN_3_UNIT_COMM_PCT__c, AVG_GENRTN_3_DISTR_SLS_PCT__c, 
                                                  AVG_GENRTN_2_UNIT_COMM_PCT__c, OPERTNL_CMPGN_NR__c 
                                                  FROM ALM_Rep_Performance_1__c
                                                  WHERE ACCT_NR__c =: uplineAcctNr];
        List <MailPlan_Order_Oppty__c> tmpMp = new List <MailPlan_Order_Oppty__c>();
        for (MailPlan_Order_Oppty__c mp : mplst) {
            for (ALM_Rep_Performance_1__c ar : ppList) {
                if (ar.OPERTNL_CMPGN_NR__c.contains(mp.CMPGN_NR__c)) {
                    ar.MailPlan_Order_Oppty__c = mp.Id;
                    tmpMp.add(mp);
                }
            }                           
        }
        update ppList;
        
        //Testing for Current Campaign Scenarios
        PageReference pageRef = Page.MyActionItems;
        pageRef.getParameters().put('sidebar', '1');
        pageRef.getParameters().put('campaign', 'current');
        Test.setCurrentPageReference(pageRef);
        
        System.runAs(testUsr) {
            MyActionItemsController objController = new MyActionItemsController();
            objController.init();
            System.assertEquals(objController.cmpnNbr.size(), 1);
        }
        //Testing for Next Campaign Scenarios
        PageReference pageRefnxt = Page.MyActionItems;
        pageRefnxt.getParameters().put('sidebar', '1');
        pageRefnxt.getParameters().put('campaign', 'next');
        Test.setCurrentPageReference(pageRefnxt);
        
        System.runAs(testUsr) {
            MyActionItemsController objController = new MyActionItemsController();
            objController.init();
            System.assertEquals(objController.cmpnNbr.size(), 1);
        }
        
        //Testing for No Campaign Scenarios
        PageReference pageRefnoc = Page.MyActionItems;
        pageRefnoc.getParameters().put('campaign', 'Current');
        Test.setCurrentPageReference(pageRefnoc);
        System.runAs(testUsr) {
            MyActionItemsController objController = new MyActionItemsController();
            objController.init();
            System.assertEquals(objController.cmpnNbr.size(), 1); 
        }
        
        //Testing for Prior Campaign Scenarios
        PageReference pageRefPrior = Page.MyActionItems;
        pageRefPrior.getParameters().put('campaign', 'prior');
        Test.setCurrentPageReference(pageRefPrior);
        System.runAs(testUsr) {
            MyActionItemsController objController = new MyActionItemsController();
            objController.init();
            System.assertEquals(objController.cmpnNbr.size(), 1); 
        }
    }

}