/***************************************************************************
 Name          : Test_GenealogyRootNodeInfo 
 Created By    : Barkha Jain (JDC)
 Description   : Test class for GenealogyRootNodeInfo
 Created Date  : Oct 31, 2013                
****************************************************************************/
@isTest
private class Test_GenealogyRootNodeInfo {
	static String marketAccountkey;
	static Market__c mrkt;
	static Map<String, List<Genealogy_Field_Detail__c>> mapGenFlds;
	static Map<String, String> m_LeaderTitles;
	static List<Leader_Title__c> leader_titles;
	
	//----------------------------------------------------------------------------
    // Method Name  : testGenealogyRootNodeInfo
    // Description  : Method for Test Coverage of Class : GenealogyRootNodeInfo
    //----------------------------------------------------------------------------
    static testMethod void testGenealogyRootNodeInfo() {
    	createTestData();
    	
    	String queryObject = mrkt.ALM_Rep_Indicator__c.replace('__c','__r');
		Integer cmpgnNo = Integer.valueOf(mrkt.CMPGN_NR__c);
		
		PageReference pageRef = new PageReference('/apex/My_Sales_Leaders_Genealogy');
        pageRef.getParameters().put('pgId', '18');
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        GenealogyRootNodeInfo gObj = new GenealogyRootNodeInfo();
        gObj = new GenealogyRootNodeInfo(mrkt, mapGenFlds, cmpgnNo, marketAccountkey, m_LeaderTitles, leader_titles);
        system.assertEquals(1, gObj.leaderCount.size());
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
			mrkt.Genealogy_Root_Node_Section__c = 'field1';
			insert mrkt;
		}
		marketAccountkey = mrkt.Market_Id__c + ldrUsr.ACCT_NR__c;
		
		leader_titles = new List<Leader_Title__c>();
		Leader_Title__c leaderTitle = TestDataHelper.createLeaderTitle(mrkt.Id, 'DE', true);
		leader_titles.add(leaderTitle);
		m_LeaderTitles = new Map<String, String>();
		m_LeaderTitles.put(String.valueOf(leaderTitle.LDRSHP_TITL_LVL_NR__c), leaderTitle.LCL_LDRSHP_TITL_CD__c);
		
		Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
	    Contact c = TestDataHelper.createContact('1234', acc.Id, false);
	    c.MRKT_ACCT_KEY__c = marketAccountkey;
	    insert c;
	    
	    MailPlan_Order_Oppty__c mplan = TestDataHelper.createMPOrderOpp(mrkt.Id, '4', 'N', System.today().addDays(1+10), 
        											'M1', 'XZ1', 'M', false);
	    
	    ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mrkt, '1234', false);	
	    rep.MailPlan_Order_Oppty__c = mplan.Id;
	    insert rep;
	    
	    mapGenFlds = new Map<String, List<Genealogy_Field_Detail__c>>();
	    Genealogy_Field_Detail__c gFieldDetail = TestDataHelper.createGenealogyFieldDetail('field1', 'Number', 1, 
	    																		'Root', 'ALM_Rep_Performance_1:REP_OMS_STUS_CD__c', '1', true);
	    mapGenFlds.put('Root', new List<Genealogy_Field_Detail__c>{gFieldDetail});																		
	}
}