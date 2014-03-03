/***************************************************************************
 Name          : Test_GenealogyOverlayInfo 
 Created By    : Barkha Jain (JDC)
 Description   : Test class for GenealogyOverlayInfo
 Created Date  : Oct 31, 2013                
****************************************************************************/
@isTest
private class Test_GenealogyOverlayInfo {
	static String marketAccountkey;
	static Market__c mrkt;
	
	//----------------------------------------------------------------------------
    // Method Name  : testGenealogyOverlayInfo
    // Description  : Method for Test Coverage of Class : GenealogyOverlayInfo
    //----------------------------------------------------------------------------
	private static testMethod void testGenealogyOverlayInfo(){
		createTestData();
		
		Test.startTest();
		String queryObject = mrkt.ALM_Rep_Indicator__c.replace('__c','__r');
		Integer cmpgnNo = Integer.valueOf(mrkt.CMPGN_NR__c);
		
		GenealogyOverlayInfo gObj = new GenealogyOverlayInfo();
		GenealogyOverlayInfo genOverlayInfo = new GenealogyOverlayInfo(mrkt.Id, queryObject, true, cmpgnNo, marketAccountkey, 'en_US', 'N');
		system.assertEquals(1, genOverlayInfo.overlayLeaderCount.size());
		Test.stopTest();
	}
	
	//----------------------------------------------------------------------------
    // Method Name  : createTestData
    // Description  : Method for creating dummy test data
    //----------------------------------------------------------------------------
	static void createTestData(){
		TestDataHelper.createALMGlobalSetting(true);
		User ldrUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', true);
		
		system.runAs(ldrUsr){
			mrkt = TestDataHelper.createMarket('DE', false);
			mrkt.Genealogy_Overlay_Section__c = 'field1';
			insert mrkt;
		}
		marketAccountkey = mrkt.Market_Id__c + ldrUsr.ACCT_NR__c;
		
		Leader_Title__c leaderTitle = TestDataHelper.createLeaderTitle(mrkt.Id, 'DE', true);
		
		Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
	    Contact c = TestDataHelper.createContact('1234', acc.Id, false);
	    c.MRKT_ACCT_KEY__c = marketAccountkey;
	    insert c;
	    
	    MailPlan_Order_Oppty__c mplan = TestDataHelper.createMPOrderOpp(mrkt.Id, '4', 'N', System.today().addDays(1+10), 
        											'M1', 'XZ1', 'M', false);
	    
	    ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mrkt, '1234', false);	
	    rep.MailPlan_Order_Oppty__c = mplan.Id;
	    insert rep;
	    
	    Genealogy_Field_Detail__c gFieldDetail = TestDataHelper.createGenealogyFieldDetail('field1', 'Number', 1, 
	    																		'Overlay', 'ALM_Rep_Performance_1:LDRSHP_TITL_LVL_NR__c', '1', true);
	}
}