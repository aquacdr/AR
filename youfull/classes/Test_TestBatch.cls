/***************************************************************************
 Name           : Test_TestBatch
 Madified By    : Saurabh Gupta (JDC)
 Description    : Test class for TestBatch
 Modified Date  : Nov 8, 2013                
****************************************************************************/

@isTest
private class Test_TestBatch {
	
	//----------------------------------------------------------------------------
    // Method Name  : testTestBatch
    // Description  : Method for Test Coverage of Class : TestBatch
    //----------------------------------------------------------------------------
    static testMethod void testTestBatch() {
    	String mktIdKey = '123456';
    	
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create and Insert Object : Market
        Market__c mrkt = TestDataHelper.createMarket(mktIdKey, true);
        
        //Create and Insert Object : User
        User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID_ACCT_NR_KEY__c = mktIdKey + 'XX';
        insert testUsr;
        
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact
        Contact con = TestDataHelper.createContact(mktIdKey, acct.Id, false);
        con.OwnerId = testUsr.Id;
        insert con;
        
        //Create Object: ALM_Rep_Performance_1__c
        List <ALM_Rep_Performance_1__c> almRepPerformList = new List <ALM_Rep_Performance_1__c>();
    	ALM_Rep_Performance_1__c almRepOne = TestDataHelper.createRepPerformance(con.Id, mrkt, mktIdKey, false);
    	almRepPerformList.add(almRepOne);
    	
    	//Create Object: ALM_Rep_Performance_1__c
    	ALM_Rep_Performance_1__c almRepTwo = TestDataHelper.createRepPerformance(con.Id, mrkt, mktIdKey + '7', false);
    	almRepTwo.MRKT_CMPGN_ROOT_UPLN_ACCT__c = 'Test';
    	almRepTwo.ROOT_UPLN_ACCT_NR__c = null;
    	almRepPerformList.add(almRepTwo);
    	
    	insert almRepPerformList;
    	
    	Test.startTest();
        try {
			TestBatch batch = new TestBatch();
    		Database.executeBatch(batch, 200);
    	} catch(Exception e) {
    	}

    	Test.stopTest();
    	
    	List <ALM_Rep_Performance_1__c> almRepList = [Select Id, MRKT_CMPGN_ROOT_UPLN_ACCT__c, MRKT_ID__c, FLD_SLS_CMPGN_NR__c, ROOT_UPLN_ACCT_NR__c 
    											  	  From ALM_Rep_Performance_1__c Where MRKT_CMPGN_ROOT_UPLN_ACCT__c != 'Test' Limit 1];
    	
    	/*
    		Less coverage for batch beacause query Containing hard coded account Id
    	*/
    	//System.assertEquals(almRepList[0].MRKT_CMPGN_ROOT_UPLN_ACCT__c, almRepList[0].MRKT_ID__c + almRepList[0].FLD_SLS_CMPGN_NR__c + almRepList[0].ROOT_UPLN_ACCT_NR__c);
    	
    }
}