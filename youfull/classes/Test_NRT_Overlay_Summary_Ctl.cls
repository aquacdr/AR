/***************************************************************************
 Name          : Test_NRT_Overlay_Summary_Ctl 
 Modified By   : Parul Gupta (JDC)
 Description   : Test class for NRT_Overlay_Summary_Ctl
 Modified Date : Nov 7, 2013                
****************************************************************************/
@isTest
private  class Test_NRT_Overlay_Summary_Ctl {
	
	public static String mktIdKey = 'XX';
	static Market__c mrkt;
	static User ldrUsr;
	static Account testAcct;
	static Contact con1;
	static ALM_Rep_Performance_1__c rep1;
	static Sales_Org_Summary__c sos;
	static Order_1__c  order1;
	
	//---------------------------------------------------------------------------
    // Method Name  : runGeneralCoverage
    // Description  : Method for Test Coverage for NRT_Overlay_Summary_Ctl
    //---------------------------------------------------------------------------
    static testMethod void runGeneralCoverage() {
    	
    	createBaseData();    	
		System.runAs(ldrUsr)
	    {
	    	ApexPages.currentPage().getParameters().put('mpCampaign', '201313');
	    	NRT_Overlay_Summary_Ctl clone = new NRT_Overlay_Summary_Ctl();
	    	clone.getNrtTimestamp();
	    	clone.getNrtEnabled();
	    	rep1.MRKT_CMPGN_SLS_ZONE_CD__c = mrkt.Market_Id__c+'201313'+'1';
		    rep1.LDRSHP_TITL_LVL_NR__c = '1';
		    rep1.LOA_NR__c = 0;
		    update rep1;
		    
	    	NRT_Overlay_Summary_Ctl.refreshData(rep1.ACCT_NR__c
									           ,mrkt.Market_Id__c
									           ,(Decimal.ValueOf(201313))
									           ,'', false, false);
		   
		   
		   	NRT_Overlay_Summary_Ctl.refreshData(rep1.ACCT_NR__c
									          ,mrkt.Market_Id__c
									          ,(Decimal.ValueOf(201313))
									          ,'1', true, true);	    
	    }
    }
    
    static void createBaseData(){
    	// Creating market data
    	mrkt = TestDataHelper.createMarket(mktIdKey, false);
        mrkt.Market_Currency_Symbol__c = '₱';
    	mrkt.CMPGN_NR__c = '201313';
    	mrkt.NRT_Enabled__c = true;
        insert  mrkt;
        
        // Create Leader User 
        ldrUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
     	ldrUsr.MRKT_ID__c = mktIdKey;
     	insert ldrUsr;
     	
        mrkt.OwnerId = ldrUsr.Id;
        update  mrkt;
        		
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        
        // Creating Account and contact data
        testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);        
              
       	con1 = TestDataHelper.createContact('1234', testAcct.id, false);
        con1.MRKT_ACCT_KEY__c = mrkt.Market_Id__c + '1234';
        con1.ownerId = ldrUsr.Id;
        insert con1;
        
        // Creating ALM Rep Performance
        rep1 = TestDataHelper.createALMRepPerformance('1234', null, '1234',
    										0, con1.Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.CMPGN_NR__c),
    										mrkt.CMPGN_NR__c,  
    										1, 8, true);
 		
 		// Create Sales Org Summary
 		sos = TestDataHelper.createSalesOrSummaries('Test SOS', null, mrkt.Id, 
    									 		null, mrkt.CMPGN_NR__c, true);
      	
      	// Create Order
      	order1 = TestDataHelper.createOrder('1234', mrkt,
    									rep1.Id, sos.Id,
    									true);
	}
    
}