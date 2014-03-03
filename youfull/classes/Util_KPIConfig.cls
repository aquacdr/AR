/***************************************************************************
 Name          : Util_KPIConfig 
 Description   : Demo version of Utility Class to support the Sales Leader KPIs
 Created By    : Fay Salwen 
 Created Date  : Dec 26, 2013                
****************************************************************************/

public with sharing class Util_KPIConfig{
    
    //==============================================================================================//
    //Constructor
    //==============================================================================================//
    public Util_KPIConfig() {  
        
    }   
    
    //==============================================================================================//
    //Return all the custom setting (SL_ZoneKPIConfig__c) data/rows for a given representative
    //==============================================================================================//
    public static List<SL_KPIConfig__c> getKPIConfigsForRepPerformanceAndContext(ALM_Rep_Performance_1__c repPerf, String context){
        return getKPIConfigsForMarketAndTitleTypeAndContext(repPerf.MRKT_KEY__c, repPerf.NXT_TITL_LVL_KEY__r.LDRSHP_TITL_TYPE_NR__c, context);
    }

    //==============================================================================================//
    //Return all the custom setting (SL_ZoneKPIConfig__c) data/rows for a given Market, Title Type, and Context
    //Logic used to get the required data is:
    //   1. Fetch the SL_MarketKPIConfig__c records with the given contectId and markert Id
    //   2. Use the data from above point, to get the related custom setting data with same CONFIG_NAME
    //==============================================================================================//
    public static List<SL_KPIConfig__c> getKPIConfigsForMarketAndTitleTypeAndContext(String marketId, String titleType, String context){

        String logMessage = 'POC_SL_Utility_KPIConfig::getKPIConfigsForMarketAndTitleTypeAndContext::Method Parameters::marketId = '
                            + marketId + ', titleType = ' + titleType + ', context = ' + context;
        
        ALMLogUtils.log(logMessage);
        String strQuery = 'Select SL_KPIConfigName__c, SortOrder__c, Market__c, Leader_Title_Type__c, Context__c From SL_Market_KPIConfig__c Where Leader_Title_Type__c = \''+titleType+'\' AND Context__c includes (\'' +context+ '\') AND Market__c=\''+marketId +'\'order by SortOrder__c';
        System.debug('strQuery:'+strQuery);
        List<SL_Market_KPIConfig__c> marketConfigs;
        try{
            marketConfigs = Database.query(strQuery);
            System.debug('marketConfigs:' + marketConfigs);
        }catch(Exception ex){
            ALMLogUtils.log(ex);
        }
        
        Map<String,SL_KPIConfig__c> mapKPIConfigs = SL_KPIConfig__c.getAll();
        System.debug('mapKPIConfigs:' + mapKPIConfigs);
        
        List<SL_KPIConfig__c> lstKPIConfigs = new List<SL_KPIConfig__c>();
        
        for(SL_Market_KPIConfig__c marketConfig: marketConfigs){
                System.debug('marketConfig.SL_KPIConfigName__c:'+marketConfig.SL_KPIConfigName__c);
                if(mapKPIConfigs.get(marketConfig.SL_KPIConfigName__c) != null){
                    lstKPIConfigs.add(mapKPIConfigs.get(marketConfig.SL_KPIConfigName__c) );
                }   
        }
        
        return lstKPIConfigs;       
    } 
}