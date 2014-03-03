/***************************************************************************
 Name         : Test_ZM_Utility_KPIConfig
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Utility_KPIConfig
 Created Date : Nov 7, 2013                
****************************************************************************/
@isTest 
private class Test_ZM_Utility_KPIConfig {
	
	//----------------------------------------------------------------------------
    // Method Name  : testKPIConfigUtility
    // Description  : Method for Test Coverage of Class : ZM_Utility_KPIConfig
    //----------------------------------------------------------------------------
    static testMethod void testKPIConfigUtility() {
        //creating test market records
        Market__c mkt = TestDataHelper.createMarket('DE', true);
    
    	//creating test ZM_ZoneKPIConfig__c records
        Map<String, ZM_ZoneKPIConfig__c> zoneConfigMap = new Map<String, ZM_ZoneKPIConfig__c>();
        zoneConfigMap.put('APPT0', TestDataHelper.createZoneKPIConfig('APPT0', 'Appointments', null, false));
        zoneConfigMap.put('APPT1', TestDataHelper.createZoneKPIConfig('APPT1', 'Appointments', 'APPT0', false));
        zoneConfigMap.put('APPT2', TestDataHelper.createZoneKPIConfig('APPT2', 'Appointments', 'APPT1', false));
        insert zoneConfigMap.values();
        
        //creating test ZM_MarketZoneKPIConfig__c records
        List<ZM_MarketZoneKPIConfig__c> marketConfigLst = new List<ZM_MarketZoneKPIConfig__c>();
        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 1', 'APPT0', mkt.id, '1', 'KPI Summary 1;Compass', null, false, 12, false));
        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 2', 'APPT1', mkt.id, '2', 'KPI Summary 1;Compass;', null, false, 12, false));
        marketConfigLst.add(TestDataHelper.createMarketZoneKPIConfig('Config 3', 'APPT2', mkt.id, '3', 'KPI Summary 1;Compass;TL;', null, false, 12, false)); 
        insert marketConfigLst;
        
        //creating ZM_MarketZoneKPIContent__c record
        ZM_MarketZoneKPIContent__c content = new ZM_MarketZoneKPIContent__c(MarketZoneKPIConfig__c = marketConfigLst[0].Id, 
        					Start_Date__c = Date.today().addDays(-1), Language_Code__c = Userinfo.getLanguage());
        insert content;
        
        Test.startTest();
        ZM_Utility_KPIConfig util = new ZM_Utility_KPIConfig();
        
        //test createMapInputFields method
        Map<String, String> fieldsMap = util.createMapInputFields(marketConfigLst, zoneConfigMap);
        //verify result
        system.assertEquals('APPT_CNT__c', fieldsMap.get('Appointments'));
        
        //test getKPIConfigForMarketAndContext method
        system.assertEquals(3, util.getKPIConfigForMarketAndContext(mkt.id, 'KPI Summary 1').size());
        
        //test getZoneKPIConfig method
        system.assertEquals(1, util.getZoneKPIConfig(mkt.id, 'TL').size());
        
        //test createMapFields method
        system.assert(util.createMapFields(marketConfigLst, zoneConfigMap).containsKey('Appointments'));
        
        //test getMarketZoneKPIContentMap method
        system.assertEquals(1, ZM_Utility_KPIConfig.getMarketZoneKPIContentMap().size());
        Test.stopTest();
    }
}