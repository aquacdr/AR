/***************************************************************************
 Name          : ALM_Model_User_ZoneManager
 Created By    : Fay Salwen
 Description   : Concrete Model class for Zone Manager users
 Created Date  : Feb 19, 2014               
****************************************************************************/

public with sharing class ALM_Model_User_ZoneManager extends ALM_Model_User_AreaManager {
	
	
    //=================================================================//
    // Allow access if and only if the Zone of the repPerformnace is one 
    // of the ones that this Zone Manager has in visible list
    //=================================================================//
	Boolean isAccessPermitted(ALM_Rep_Performance_1__c repPerformance) {
		return getVisibleZoneSet().contains(repPerformance.SLS_ZONE_CD__c);
	}

}