/***************************************************************************
 Name          : ALM_Model_User_AreaManager
 Created By    : Fay Salwen
 Description   : Model class for user, superclass for both Zone and Division Manager
 Created Date  : Feb 19, 2014               
****************************************************************************/

public virtual class ALM_Model_User_AreaManager extends ALM_Model_User {
    
    protected Set<String> zoneList;
    
    // =================================================================//
    // ----------------- CONSTRUCTORS AND INITIALIZERS -----------------
    // =================================================================//
    
    public override ALM_Model_User initialize(User userParam) {
        super.initialize(userParam);
        // Currently sets zones proactively (since always used), but could be done as lazy load
        zoneList = getVisibleZones();
        return this;
    }
    
    // =================================================================//
    // -------------------- PUBLIC INSTANCE METHODS --------------------
    // =================================================================//

    //=================================================================//
    // Return the set of Zones this user has access to, using the cached value
    //=================================================================//   
    protected Set<String> getZones() {
        if (zoneList == null) {
            zoneList = getVisibleZones();
        }
        return zoneList;
    }

    // =================================================================//
    // -------------- PROTECTED/PRIVATE INSTANCE METNODS ---------------
    // =================================================================//

    //=================================================================//
    // Return the set of Zones this user has access to
    // Determine which based on the access to SalesOrgSummary, assuming
    // Salesforce security has been properly configured for SalesOrgSummary
    //=================================================================//   
    protected Set<String> getVisibleZones() {
       return getVisibleSalesOrgSummaries('Z');
    }
    
    //=================================================================//
    // Return the set of SalesOrgSummaries this user has access to
    // for the provided typeCode (either 'Z' for Zone or 'D' for Division)
    //=================================================================//   
    protected Set<String> getVisibleSalesOrgSummaries(String typeCode) {
        Set<String> salesOrgSet = new Set<String>();
                
        List<Sales_Org_Summary__c> salesOrgList=[SELECT Id, SLS_ORG_DESC_TXT__c
                                                    FROM Sales_Org_Summary__c
                                                    WHERE MRKT_KEY__r.Market_Id__c = :userData.MRKT_ID__c 
                                                    AND SLS_ORG_LVL_DESC_TXT__c = :typeCode];

        if (salesOrgList.size() > 0) {
            System.debug('salesOrgList: '+salesOrgList);
            for (Sales_Org_Summary__c salesOrg : salesOrgList) {
                system.debug ('salesOrg.Id = ' + salesOrg.Id + 'and salesOrg.SLS_ORG_LVL_DESC_TXT__c = ' + salesOrg.SLS_ORG_DESC_TXT__c); 
                salesOrgSet.add(salesOrg.SLS_ORG_DESC_TXT__c);
            }
        }
        system.debug('salesOrgSet size = ' + salesOrgSet.size() + ' and salesOrgSet =' + salesOrgSet);
        return salesOrgSet;
    }

    //=================================================================//
    // Return a Boolean to indicate whether this user has access to more than one Zone
    //=================================================================//
    public Boolean isMultipleZone() {
        return zoneList.size() > 1;
    }

}