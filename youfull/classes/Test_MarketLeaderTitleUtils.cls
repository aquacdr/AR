/***************************************************************************
 Name         : Test_MarketLeaderTitleUtils 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for MarketLeaderTitleUtils
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_MarketLeaderTitleUtils {

	//---------------------------------------------------------------------------
    // Method Name  : testLeaderTitles
    // Description  : Method for Test Coverage of Class : MarketLeaderTitleUtils
    //---------------------------------------------------------------------------
	static testmethod void testLeaderTitles(){
		String marktId = 'DE';
			
		User testUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);	
		testUsr.MRKT_ID__c = marktId;
		insert testUsr;
		
		Market__c market = TestDataHelper.createMarket(marktId, true);
		List<Leader_Title__c> leaderTitles = TestDataHelper.createLeaderTitlesList(market.Id, marktId, true);
		
		System.runAs(testUsr){		
			MarketLeaderTitleUtils ctlr = new MarketLeaderTitleUtils();
			ctlr.initialize(testUsr);
			system.assert(ctlr.getLeaderTitle('1') != null);
			
			List<Leader_Title__c> tempList = ctlr.initializeAndRetList(testUsr);
			system.assert(tempList.size() == 8);			
			
			ctlr.initialize(testUsr, '1');
			system.assert(ctlr.getLeaderTitle('1') != null);
			system.assert(ctlr.initializeAndRetTitle(testUsr,'1').LCL_LDRSHP_TITL_LANG_DESC_TXT__c == 'Title 1');
			
			ctlr.initializeAndRetTitle(testUsr,'1');
			ctlr.initializeAndRetList(testUsr);
			ctlr.initializeAndRestListSortedByTitleNumber(market.id, testUsr.LanguageLocaleKey);
			ctlr.initializeAndRetMapLT(testUsr);
			
			ctlr.initializeAndRestListSortedByTitleNumber(null, null);
			system.assert(MarketLeaderTitleUtils.findELeaders(marktId).size() > 0);
			system.assert(ctlr.getLeaderTitle().size() > 0);
		}    	
    }
}