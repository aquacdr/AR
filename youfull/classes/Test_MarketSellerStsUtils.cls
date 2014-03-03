/***************************************************************************
 Name          : Test_MarketSellerStsUtils 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for MarketSellerStsUtils
 Created Date  : Oct 30, 2013                
****************************************************************************/
@isTest
private class Test_MarketSellerStsUtils {

	//---------------------------------------------------------------------------
    // Method Name  : testLeaderTitles
    // Description  : Method for Test Coverage for MarketSellerStsUtils
    //--------------------------------------------------------------------------
    public static testmethod void testLeaderTitles(){		
		String marktId = '62';
			
		User testUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);	
		testUsr.MRKT_ID__c = marktId;
		insert testUsr;
		
		Market__c mkt = TestDataHelper.createMarket(marktId, true);
        TestDataHelper.createSellerStatusList(mkt.Id, true); 
        
        System.runAs(testUsr){
        	Test.startTest();
        	MarketSellerStsUtils ctlr = new MarketSellerStsUtils();
			ctlr.initialize(testUsr);
			ctlr.getSellerStatus();
			system.assert(ctlr.getSellerStatus('SELLSTS1') == 'Seller Status 1');
			ctlr.initialize(testUsr,'SELLSTS1');
			system.assert(ctlr.getSellerStatus('SELLSTS1') == 'Seller Status 1');
			Test.stopTest();
		}
    	
    }
}