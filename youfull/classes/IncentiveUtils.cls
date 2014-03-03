/*
** Apex Class/Controller Name           : IncentiveUtils
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Utility methods for Incentive__c object
** 
** Triggers Spawned                     :
**
** Change Log (Put the latest entry on top) :
** March 22, 2012.  Created
** 
*/

public class IncentiveUtils {
    Map<String, Incentive__c> mapTypeIncentive = new Map<String, Incentive__c>();
    
    // return map of 'Type__c'_+_'LDRSHP_TITL_LVL_NR__c' to Incentive
    public Map<String, Incentive__c> retMapTypeTitleIncentive(User currUser, Market__c market) {
        mapTypeIncentive = new Map<String, Incentive__c>();
        
        List<Incentive__c> li = [SELECT INCNTV_REQ_CNT__c, Type__c,
                                        TITL_LVL_NR__c, INCNTV_PRODCT_NM__c
                                 FROM Incentive__c
                                 WHERE Market__r.Market_Id__c = :currUser.MRKT_ID__c
                                 AND  CMPGN_NR__c = :market.CMPGN_NR__c
                                 //AND Type__c = 'Team'
                                 //AND TITL_LVL_NR__c = :currUser.LDRSHP_TITL_LVL_NR__c
                                 AND LANG_CD__c = :currUser.LanguageLocaleKey];
                                 
        if (li != null && li.size() > 0) {
            for (Incentive__c i : li) {
                mapTypeIncentive.put(i.Type__c.toLowerCase() + '_+_' + i.TITL_LVL_NR__c.toLowerCase(), i);
            }
        }
        
        return mapTypeIncentive;
    }
    

}