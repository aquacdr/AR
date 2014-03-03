//
//  Name            : ZM_Utility_KPIConfig
//  Description     : Controller 
//  Author          : V. Mittal
//  Created Date    : Feb, 2013
//  

public without sharing class ZM_Utility_KPIConfig {

    public Map<String,ZM_MarketZoneKPIConfig__c> getKPIConfigForMarketAndContext(String MarketId,string ContextName ){
    	
        Map<String,ZM_MarketZoneKPIConfig__c> MapKPIConfig=New Map<String, ZM_MarketZoneKPIConfig__c>();
        
        List<ZM_MarketZoneKPIConfig__c> lstMarketZone=[Select ZM_ZoneKPIConfigName__c, SortOrder__c, OwnerId, Name, Market__c,
        														 MarketUsesDefault__c, MarketDefaultPlan__c, Id, Context__c,
        														 Goal_To_Maximize_Override__c  
											           From ZM_MarketZoneKPIConfig__c  
											           WHERE Market__c= :MarketId AND Context__c includes (:ContextName)
											           order by SortOrder__c];
											           
        for(ZM_MarketZoneKPIConfig__c objMarketZoneKPIConfig: lstMarketZone){
            MapKPIConfig.put(objMarketZoneKPIConfig.ZM_ZoneKPIConfigName__c,objMarketZoneKPIConfig);
        }
        
        system.debug('ZM_Utility_KPIConfig.getKPIConfigForMarketAndContext returned map => ' + MapKPIConfig);
        return MapKPIConfig;
    }
    
    
	/*
	* creates collection of iterable input fields
	* the input page iterates this collection and displays
	* corresponding input Actual fields
	*/
	public Map<String, String> createMapInputFields(List<ZM_MarketZoneKPIConfig__c> listMConfig, Map<String, ZM_ZoneKPIConfig__c> mapZConfig) {
		Map<String, String> result = new Map<String, String>();
		ZM_ZoneKPIConfig__c zConfig = null;
		
		if (listMConfig == null || listMConfig.size() == 0 || mapZConfig == null || mapZConfig.size() == 0) {
			return null;
		}
		
		for (ZM_MarketZoneKPIConfig__c mConfig : listMConfig) {
			zConfig = mapZConfig.get(mConfig.ZM_ZoneKPIConfigName__c);
			result.put(zConfig.CustomLabel__c, zConfig.ActualField__c);
		}
		
		return result;
	}
	
	/*
	* creates collection of iterable KPIs with fields
	* the input and output pages iterate through this collection and display
	* corresponding fields
	*/
	public Map<String, ZM_ZoneKPIConfig__c> createMapFields(List<ZM_MarketZoneKPIConfig__c> listMConfig, Map<String, ZM_ZoneKPIConfig__c> mapZConfig) {
		ZM_ZoneKPIConfig__c zConfig = null;
		Map<String, ZM_ZoneKPIConfig__c> result = new Map<String, ZM_ZoneKPIConfig__c>();
		
		if (listMConfig == null || listMConfig.size() == 0 || mapZConfig == null || mapZConfig.size() == 0) {
			return null;
		}
		
		// Added by Raktim on 22nd Oct, 2013 - Defect 3228 Fix
		listMConfig.sort();		
		// EoC
		
		list<String> fieldSort = new list<String>();
		for (ZM_MarketZoneKPIConfig__c mConfig : listMConfig) {
			zConfig = mapZConfig.get(mConfig.ZM_ZoneKPIConfigName__c);
			result.put(zConfig.CustomLabel__c, zConfig);
			
		}
		
		return result;
	}
	
	/*
	* method will return all the custom setting (ZM_ZoneKPIConfig__c) data/rows for a given CONFIG_NAME
	* logic used to get the required data is:
	*   1. Fetch the ZM_MarketZoneKPIConfig__c records with the given contectId and markert Id
	*   2. Use the data from above point, to get the related custom setting data with same CONFIG_NAME
	*/
    public List<ZM_ZoneKPIConfig__c> getZoneKPIConfig(string MarketId,string ContextName){

    	string strQuery='Select ZM_ZoneKPIConfigName__c, SortOrder__c, OwnerId, Name, Market__c, MarketUsesDefault__c, MarketDefaultPlan__c,Id,Context__c From ZM_MarketZoneKPIConfig__c where Context__c includes (\'' +ContextName+ '\') and Market__c=\''+MarketId +'\'order by SortOrder__c';
    	system.debug('strQuery:'+strQuery);

    	List<ZM_MarketZoneKPIConfig__c> lstMarketZone=Database.query(strQuery);
    	system.debug('lstMarketZone:'+lstMarketZone);
    	
    	Map<String,ZM_ZoneKPIConfig__c> Map_CustomValueRecords = ZM_ZoneKPIConfig__c.getAll();
    	system.debug('Map_CustomValueRecords:'+Map_CustomValueRecords);
    	
    	List<ZM_ZoneKPIConfig__c> result= new List<ZM_ZoneKPIConfig__c>();
    	
    	for(ZM_MarketZoneKPIConfig__c objZMMZKPIC: lstMarketZone){
    			system.debug('objZMMZKPIC.ZM_ZoneKPIConfigName__c:'+objZMMZKPIC.ZM_ZoneKPIConfigName__c);
    			if(Map_CustomValueRecords.get(objZMMZKPIC.ZM_ZoneKPIConfigName__c)!=null){
    				result.add(Map_CustomValueRecords.get(objZMMZKPIC.ZM_ZoneKPIConfigName__c) );
    			}	
    	}
    	return result;
    	
    } 
    
    /* 
    * Method to get all the MarketZoneKPIContent records related to MarketZoneKPIConfig which is stated just before today
    * and where Language Code matches the one of logged-in user's language code.
    */
    public static Map<String,ZM_MarketZoneKPIContent__c> getMarketZoneKPIContentMap() {
    	
    	// Create a Map of marketZonConfigName as Key and MarketZoneKPIContent record as its value
    	Map<String,ZM_MarketZoneKPIContent__c> mapMarketZoneKPIContent = new Map<String,ZM_MarketZoneKPIContent__c>();
    	
    	for(ZM_MarketZoneKPIContent__c mzkc : [select Id, MarketZoneKPIConfig__c, MarketZoneKPIConfig__r.ZM_ZoneKPIConfigName__c, SuggestedActivities__c
    							from ZM_MarketZoneKPIContent__c where Start_Date__c < today and Language_Code__c =: Userinfo.getLanguage() 
    							order by Start_Date__c ASC ]) {
    								
    		mapMarketZoneKPIContent.put(mzkc.MarketZoneKPIConfig__r.ZM_ZoneKPIConfigName__c, mzkc);
    	}
    	
    	// return the above created map
    	return mapMarketZoneKPIContent;
    }
}