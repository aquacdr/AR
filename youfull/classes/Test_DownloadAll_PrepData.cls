/***************************************************************************
 Name         : Test_DownloadAll_PrepData
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for DownloadAll_PrepData
 Created Date : Nov. 07, 2013                
****************************************************************************/

@isTest
private class Test_DownloadAll_PrepData {
	//----------------------------------------------------------------------------
    // Method Name  : testDownloadAll_PrepData
    // Description  : Method for Test Coverage of Class : DownloadAll_PrepData
    //----------------------------------------------------------------------------  
    public static testmethod void testDownloadAll_PrepData() {
    	
    	String mktIdKey = 'TESTDOWN';
    	Market__c mrkt;
    	
    	//Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create and Insert Object : User
        List <User> usrList = new List <User>();
        
        User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID__c = mktIdKey;
        testUsr.LDRSHP_TITL_LVL_NBR__c = '2';
        usrList.add(testUsr);
        
        insert usrList;
        
        System.runAs(testUsr) {
            //Create and Insert Object : Market
            mrkt = TestDataHelper.createMarket(mktIdKey, false);
            mrkt.OwnerId = testUsr.Id;
            insert mrkt;
        }
    	
    	//Create and Insert Object : DownloadAll_GenIndex__c
    	DownloadAll_GenIndex__c downloadAllGen = TestDataHelper.createDownloadAllGenIndex(mktIdKey, mrkt.CMPGN_NR__c, true);
    	
    	//Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Acct Down', 'USD', true);
    	
    	Contact con = TestDataHelper.createContact(mktIdKey, String.valueOf(acct.Id), true);
    	
    	//Create and Insert Object : ALM_Rep_Performance_1__c
    	ALM_Rep_Performance_1__c almRep = TestDataHelper.createRepPerformance(con.Id, mrkt, mktIdKey, false);
        almRep.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
        almRep.MRKT_ID__c = mktIdKey;
        almRep.ACCT_NR__c = mktIdKey;
        almRep.Name = '1';
        insert almRep; 
    	
    	PageReference pageRef = Page.DownloadAll_PrepData;
        pageRef.getParameters().put('acctKey', mktIdKey);
        Test.setCurrentPageReference(pageRef);
    	
    	Test.startTest();
    	DownloadAll_PrepData downAllData = new DownloadAll_PrepData();
    	downAllData.updateUserGenIndex();
    	
    	List <ALM_Rep_Performance_1__c> almRepList = [Select Id, Name From ALM_Rep_Performance_1__c Where Id =: almRep.Id];
    	System.assertEquals(almRepList != null, true);
    	Test.stopTest();
    	
    }
}