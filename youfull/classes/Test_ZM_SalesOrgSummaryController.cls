/***************************************************************************
 Name         : Test_ZM_SalesOrgSummaryController
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_SalesOrgSummaryController
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_ZM_SalesOrgSummaryController {
     
     //----------------------------------------------------------------------------
     // Method Name  : testSalesOrgSummaryController
     // Description  : Method for Test Coverage of Class : ZM_SalesOrgSummaryController
     //----------------------------------------------------------------------------
     static testMethod void testSalesOrgSummaryController() {
     	
     	// Create test data
        User u1 = TestDataHelper.createUser('62', '601', 'Avon Mkt 62 Zone Manager', true);        
        Market__c mark = TestDataHelper.createMarket('62', false);
        mark.CMPGN_NR__c = '201302';
        mark.PREV_1_CMPGN_NR__c = '201301';
        mark.NEXT_1_CMPGN_NR__c = '201303';
        mark.Hide_Next_Campaign__c = true;
        insert mark;   
        
        // Create Congig records
        List<ZM_MarketZoneKPIConfig__c> marketZoneKPIConfigs = new List<ZM_MarketZoneKPIConfig__c>(); 
        ZM_MarketZoneKPIConfig__c ZMMarketConfig = TestDataHelper.createMarketZoneKPIConfig('Config 1', 'APPT', mark.Id, '1', 'KPI Summary 1;Compass', 'USD', true, 1, false);
        marketZoneKPIConfigs.add(ZMMarketConfig);
        ZMMarketConfig = TestDataHelper.createMarketZoneKPIConfig('Config 2', 'RMOVL', mark.Id, '2', 'KPI Summary 1;Compass', 'USD', true, 1, false);
        marketZoneKPIConfigs.add(ZMMarketConfig);
        insert marketZoneKPIConfigs;
        
        List<ZM_ZoneKPIConfig__c> zoneKPIConfigs = new List<ZM_ZoneKPIConfig__c>();
        ZM_ZoneKPIConfig__c ZMZoneKPIConfig = TestDataHelper.createZoneKPIConfig('APPT', 'Appointments', null, false);
        ZMZoneKPIConfig.CountOfRisingStarsField__c = 'APPT_RSNG_STR_CNT__c';
		ZMZoneKPIConfig.CountAtRiskField__c = 'APPT_TAR_CNT__c';
		ZMZoneKPIConfig.Goal_To_maximize__c = true;
		zoneKPIConfigs.add(ZMZoneKPIConfig);
		ZMZoneKPIConfig = TestDataHelper.createZoneKPIConfig('RMOVL', 'Appointments', null, false);
        ZMZoneKPIConfig.CountOfRisingStarsField__c = 'RMOVL_RSNG_STR_CNT__c';
		ZMZoneKPIConfig.Goal_To_maximize__c = false;
		zoneKPIConfigs.add(ZMZoneKPIConfig);
		insert zoneKPIConfigs;
      	
      	// Create Sales_Org_Summary__c records
        List<Sales_Org_Summary__c> salesOrg = new list<Sales_Org_Summary__c>();
        salesOrg.add(createSalesOrgSummary(u1.id, u1.id,
    									'601', '201303', false));
        salesOrg.add(createSalesOrgSummary(u1.id, u1.id,
    									'601', '201302', false));      
        salesOrg.add(createSalesOrgSummary(u1.id, u1.id,
    									'601', '201301', false));
        insert salesOrg;
        
        Test.StartTest();       
        System.runAs(u1) {
        	PageReference pg = new PageReference('/apex/ZM_BusinessPlan');
            Test.setCurrentPageReference(pg);
            ApexPages.currentPage().getParameters().put('SLSORGDESCTXT', '601');
        	ApexPages.StandardController objController = new ApexPages.StandardController(salesOrg[0]);
        	ZM_SalesOrgSummaryController con = new ZM_SalesOrgSummaryController(objController);
        	con.changeData();
            con.strZoneNrSOS='601';
            con.ZoneSalesOrg();
            con.starCount(5);
            con.saveAsPDF();
            con.saveAsDraft();
            system.assertEquals(con.lstSalesOrgSummary.size(),1);
            con.getOmniturePageName();                
        }
        
        Test.StopTest();       
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSalesOrgSummary
    // Description  : Create and Insert object : Sales_Org_Summary__c
    //---------------------------------------------------------------------------
    public static Sales_Org_Summary__c createSalesOrgSummary(String ownerId, String zoneManagerId,
    									String slsDescTxt, String oprCampaignNumber, boolean isInsert) {
    										   	
    	Sales_Org_Summary__c salesOrgSummary = new Sales_Org_Summary__c (OwnerId = ownerId, 
										    	ZONE_MGR__c=zoneManagerId, 
										    	ACTV_REP_CNT__c=300, 
										    	UPR_CNT__c=8, 
										    	SLS_ORG_DESC_TXT__c=slsDescTxt, 
										    	OPERTNL_CMPGN_NR__c=oprCampaignNumber, 
										    	FLD_SLS_CMPGN_NR__c = oprCampaignNumber,  
										    	TITLD_STF_CNT__c=8,  
										    	RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, 
										    	TITL_0_STF_CNT__c=8,  
										    	UPR_DIV_RNK_CNT__c=100, 
										    	RNSTMT_DIV_RNK__c=100, 
										    	UPR_PLAN_SPPY_CNT__c=9,
										    	RMOVL_PLAN_CNT__c=6, 
										    	LOA_1_6_NET_SLS_DIV_RNK__c=100, 
										    	RTURN_NET_SLS_AMT__c=1500.00, 
										    	RMOVL_SPPY_CNT__c=8, 
										    	LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00, 
										    	RMOVL_PLAN_SPPY_CNT__c=8,    
										    	NET_SLS_SPPY_AMT__c=1555000.00, 
										    	LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, 
										    	RNSTMT_PLAN_CNT__c=5, 
										    	RMOVL_CNT__c=9, 
										    	TITLD_STF_DIV_RNK__c=100,   
										    	RNSTMT_CNT__c=2,   
										    	ACTV_REP_PLAN_SPPY_CNT__c=1500, 
										    	NET_SLS_DIV_RNK__c=100, 
										    	TITL_0_STF_PLAN_SPPY_CNT__c=9,  
										    	APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, 
										    	TITL_0_STF_DIV_RNK__c=100, 
										    	LOA_1_6_NET_SLS_AMT__c=30000.00,  
										    	  UPR_PLAN_CNT__c=9, 
										    	  ACTV_REP_DIV_RNK__c=100,
										    	  RNSTMT_SPPY_CNT__c=7, 
										    	  LOA1_NET_SLS_DIV_RNK__c=100, 
										    	  ACTV_REP_SPPY_CNT__c=1600, 
										    	  LOA1_NET_SLS_AMT__c=1000.00,  
										    	  RMOVL_DIV_RNK__c=100, 
										    	  LOA1_NET_SLS_SPPY_AMT__c=1000.00, 
										    	  NET_SLS_PLAN_SPPY_AMT__c=1555000.00, 
										    	  LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, 
										    	  TITLD_STF_SPPY_CNT__c=9, 
										    	  TITL_0_STF_SPPY_CNT__c=9,  
										    	  APPT_DIV_RNK__c=100, 
										    	  UPR_SPPY_CNT__c=9, 
										    	  APPT_PLAN_CNT__c=12, 
										    	  LOA_1_6_NET_SLS_PLAN_AMT__c=322000.00, 
										    	  RTURN_NET_SLS_DIV_RNK__c=100, 
										    	  Analysis_Done__c=false, 
										    	  RTURN_NET_SLS_SPPY_AMT__c=1550.00,
										    	  APPT_PLAN_SPPY_CNT__c=15, 
										    	  NET_SLS_PLAN_AMT__c=500000.00,  
										    	  RNSTMT_PLAN_SPPY_CNT__c=7, 
										    	  APPT_SPPY_CNT__c=15, 
										    	  ACTV_REP_PLAN_CNT__c=200, 
										    	  LOA1_NET_SLS_PLAN_AMT__c=100000.00,
										    	  TITLD_STF_PLAN_SPPY_CNT__c=9, 
										    	  RTURN_NET_SLS_PLAN_AMT__c=1500.00, 
										    	  TITLD_STF_PLAN_CNT__c=9); 
    	if (isInsert) {
    		insert salesOrgSummary;
    	}
    	
    	return salesOrgSummary;
    }
}