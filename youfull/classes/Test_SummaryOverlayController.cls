/***************************************************************************
 Name         : Test_SummaryOverlayController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for SummaryOverlayController
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_SummaryOverlayController {

	//---------------------------------------------------------------------------
    // Method Name  : testSummaryOverlay
    // Description  : Method for Test Coverage of Class : SummaryOverlayController
    //---------------------------------------------------------------------------
	static testmethod void testSummaryOverlay(){
    	
    	// Create test data
    	String mktIdKey = 'XX';
    	User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
    	testUsr.LDRSHP_TITL_LVL_NBR__c='4';
    	insert testUsr;	
    	
		Market__c mrkt = TestDataHelper.createMarket(mktIdKey, false);
	 	mrkt.OwnerId = testUsr.Id;
	 	insert mrkt;
	 	
	 	Account testAcct = TestDataHelper.createAccount('Test Acount', 'USD', true);
        List<Leader_Title__c> leaderTitles = TestDataHelper.createLeaderTitlesList(mrkt.Id, mktIdKey, true);
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        Contact ldrContact = TestDataHelper.createContact(mktIdKey, testAcct.Id, true);
        
        //Create contact along with ALM_Rep_Performance Data:Start
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(mrkt.ALM_Rep_Indicator__c);
        sObject s=targetType.newSObject();
        //s.put('GRP_ACTV_REP_CNT__c',876);
        s.put('EXGENRTN_1_GRP_ACTV_REP_CNT__c',234);
        s.put('GENTRTN_3_ACTV_REP_CNT__c',612);
        s.put('Name','Test');
        s.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(mrkt.CMPGN_NR__c));
        s.put('MRKT_ACCT_KEY__c', ldrContact.id);
        insert s;
             
        SummaryOverlay_Row_Config__c smrc = TestDataHelper.createSummaryOverlayRowConfig(mrkt.Id, true);
        SummaryOverlayController ctlr ;
        
        System.runAs(testUsr){       	
	        ctlr = new SummaryOverlayController();
	        ctlr.Cmpn_no = mrkt.CMPGN_NR__c;
	        ctlr.shc= new SiteHeaderController();
	        ctlr.shc.init();
	        ctlr.getinitializeSupportData();
	        System.assert(ctlr.cont_list.size() > 0);
	        System.assert((ctlr.cont_list.size()>0)&&(ctlr.cont_list[0].getSObjects(ctlr.obj_rel_to_query)!=NULL));       
        }
    }
}