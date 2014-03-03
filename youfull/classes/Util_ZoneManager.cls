public with sharing class Util_ZoneManager{

    public string strProfileName{get; set;}
    public string strLanguage{get; set;}
    public string strMRKTID{get; set;}
    public string strMarketRecordId{get;set;}
    public string strDefaltDivNM{get; set;}
    public string strDefaltZoneCD{get; set;}
    public string strPriorCmpgnNR{get; set;}
    public string strCurrentCmpgnNR{get; set;}
    public string strNextCmpgnNR{get; set;}
    public string strMailPlanCmpgnNR{get; set;}
    public string strUserId {get; set;}
    public boolean hideNextCampaign {get; set;}
    public boolean hideLastCampaignAnalysis {get; set;}
    public boolean hideSuggestedActivities {get; set;}
    
    public string strCombObjName {get; set;}
    
    public string strAcctNbr {get; set;}

    List<SelectOption> zoneList = new List<SelectOption>();
    
    //variables needed for zone functionality
    public Boolean isLeadEnabled {get; set;}
    public Boolean isMailPlanEnabled {get; set;}
    public Boolean isAccessToMultipleZones {get; set;}
    
    public List<Market__c> lstmarket;

    public void SetVariable() {
        
        strProfileName = '';
        strLanguage='';          
        strMRKTID = '' ;
        strDefaltDivNM = '';
        strDefaltZoneCD = '';
        
        strPriorCmpgnNR = '';
        strCurrentCmpgnNR = '' ;
        strNextCmpgnNR = '';
        strUserId = UserInfo.getUserId();
        
        strCombObjName = '';
        strAcctNbr = '';
        isAccessToMultipleZones = false;
        
        system.debug('strUserId'+strUserId);
        List<User> lstuserDetails = [select Id, LanguageLocaleKey , Profile.Name, MRKT_ID__c, DFALT_DIV_NM__c, DFALT_ZONE_CD__c, ACCT_NR__c from user where id=:strUserId LIMIT 1];
        System.debug('lstuserDetails:'+lstuserDetails);

        // Initialize campaign
        lstmarket = new List<Market__c> ();
  
        // set the information for logged in user
        if(!lstuserDetails.isEmpty()){
            strProfileName = lstuserDetails[0].Profile.Name;          
            strMRKTID = lstuserDetails[0].MRKT_ID__c;
            system.debug('strMRKTID:'+strMRKTID);
            strDefaltDivNM = lstuserDetails[0].DFALT_DIV_NM__c;
            strDefaltZoneCD = lstuserDetails[0].DFALT_ZONE_CD__c;
            strLanguage = lstuserDetails[0].LanguageLocaleKey;
            strAcctNbr = lstuserDetails[0].ACCT_NR__c;
            lstmarket = [SELECT Id, Market_Id__c, Hide_Next_Campaign__c, Is_ALMPLUS_Enabled__c, Hide_Suggested_Activities__c, Hide_Last_Campaign_Analysis__c, 
                            PREV_1_CMPGN_NR__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c, Mail_Plan_Enabled__c, ALM_Rep_Indicator__c
                         FROM Market__c WHERE Market_Id__c = :strMRKTID]; // New Field added - Mail Plan by Raktim on 28thJun 2013
            System.debug('lstmarket:'+lstmarket);
        }
        
        // Set the market related information
        if(!lstmarket.isEmpty()){
          // Modified by Raktim - Mail Plan on 28thJun 2013
            hideNextCampaign = lstmarket[0].Hide_Next_Campaign__c;
            if(!lstmarket[0].Mail_Plan_Enabled__c)
            {
                strCurrentCmpgnNR = lstmarket[0].CMPGN_NR__c;
                strPriorCmpgnNR = lstmarket[0].PREV_1_CMPGN_NR__c;
            }
            // Market is a mailplan market if lstmarket[0].Mail_Plan_Enabled__c == true
            else{ 
                if(lstuserDetails[0].Profile.Name.contains(ALMConstants.ZONE)){
                    //strCurrentCmpgnNR = MailPlanUtils.getMailPlanCampaignZMDM(lstuserDetails[0].DFALT_ZONE_CD__c, lstmarket[0].Market_Id__c);
                    String zones = getZones(lstmarket[0].Id);
                    try{
                        strMailPlanCmpgnNR = MailPlanUtils.getMailPlanCampaignZMDM(zones, lstmarket[0].Market_Id__c);
                    }catch(Exception e){
                        System.debug('\n Caught Exception in ZM_Utility for Mail Plan '+e.getMessage());
                        strCurrentCmpgnNR = lstmarket[0].CMPGN_NR__c;
                    }
                    /*check if Market campaign is same as mailplan campaign
                     Then we will set prior campaign same as market prior campagin. else
                     we will set prior campaign as Market current campaign
                     if(strCurrentCmpgnNR == lstmarket[0].CMPGN_NR__c){
                        strPriorCmpgnNR = lstmarket[0].PREV_1_CMPGN_NR__c;
                    }else{
                        strPriorCmpgnNR = lstmarket[0].CMPGN_NR__c;
                    }
                    */
                    /* On 9/8/2013 based on Cristina/ Rasmi suggestion
                       Display NEXT Campaign if the Mail Plan is closed; Otherwise, display only CLOSED and OPERATIONAL campaigns only
                       
                    */
                    if(strMailPlanCmpgnNR == lstmarket[0].CMPGN_NR__c){
                        strPriorCmpgnNR = lstmarket[0].PREV_1_CMPGN_NR__c;
                        strCurrentCmpgnNR = lstmarket[0].CMPGN_NR__c;
                        hideNextCampaign = true;
                    }else{
                        strPriorCmpgnNR = lstmarket[0].PREV_1_CMPGN_NR__c;
                        strCurrentCmpgnNR = lstmarket[0].CMPGN_NR__c;
                        hideNextCampaign = false;
                    }
                    
                }else //if(lstuserDetails[0].Profile.Name.contains(ALMConstants.DIVISION))
                {
                    //changed by Milon
                    //MailPlanUtils mp = new MailPlanUtils();
                    //MailPlan_Order_Oppty__c mop =   mp.getMailPlanForDivManager(lstuserDetails[0]);
                    strCurrentCmpgnNR = lstmarket[0].CMPGN_NR__c;
                    strPriorCmpgnNR = lstmarket[0].PREV_1_CMPGN_NR__c;
                }

                
            }
            strNextCmpgnNR = lstmarket[0].NEXT_1_CMPGN_NR__c;
            System.debug('\n ### strCurrentCmpgnNR --> '+strCurrentCmpgnNR+', strNextCmpgnNR --> '+strNextCmpgnNR+', strPriorCmpgnNR --> '+strPriorCmpgnNR);
            strMarketRecordId = lstmarket[0].Id;
            hideSuggestedActivities = lstmarket[0].Hide_Suggested_Activities__c;
            hideLastCampaignAnalysis = lstmarket[0].Hide_Last_Campaign_Analysis__c;
            strCombObjName = lstmarket[0].ALM_Rep_Indicator__c;
            system.debug('strMarketRecordId:'+strMarketRecordId);
            
            //whether lead is enabled for market
            isLeadEnabled = lstmarket[0].Is_ALMPLUS_Enabled__c;
            isMailPlanEnabled = lstmarket[0].Mail_Plan_Enabled__c;
        }
    }
    
    /*        
    public List<SelectOption> getZoneList() {

            if (strProfileName.contains('Division')) {
                for(Sales_Organization__c slsOrg : [Select SLS_ZONE_CD__c, SLS_DIV_NM__c 
                        From Sales_Organization__c
                        where SLS_ORG_LVL_CD__c='Z'
                        and Market__r.Market_Id__c = :strMRKTID
                        and SLS_DIV_NM__c = :strDefaltDivNM Order by SLS_ZONE_CD__c]) {
                    zoneList.add(new SelectOption(slsOrg.SLS_ZONE_CD__c, slsOrg.SLS_ZONE_CD__c));                                    
                }                    
            }
        return zoneList;
    } */
    
    public List<SelectOption> getZoneList() {
    
        if (strProfileName.contains('Division'))
          return getZoneListForDivisionMgr();
        else if (strProfileName.contains('Zone'))
          return getZoneListZonalManager();
        else
          return getZoneListForDivisionMgr();
        
    }
    
    /* Get all the zones related to logged in user and return them as list of SelectOptions */
    public List<SelectOption> getZoneListForDivisionMgr() {
        Set<String> zoneNameSet = getVisibleZoneSet();
        system.debug('zoneNameSet = ' + zoneNameSet);
        for(String zoneName : zoneNameSet) {
            zoneList.add(new SelectOption(zoneName, zoneName));
        }           
        zoneList.sort();
        return zoneList;
    }

    /* Get all the zones related to logged in user and return them as comma-delimited list */
    public String getVisibleZonesAsDelimitedString() {
        String zoneString = '';
        Set<String> zoneNameSet = getVisibleZoneSet();
        for(String zoneName : zoneNameSet) {
            zoneString += '\'' + zoneName + '\',';
        }
        zoneString = (zoneString.length() > 0) ? zoneString.left(zoneString.length() - 1) : '\'\'';
        return zoneString;
    }
    
    
    
    /* Get all the Divisions related to logged in user and return them as comma-delimited list */
    public String getVisibleDivisionsAsDelimitedString() {
        String divString = '';
        Set<String> divNameSet = getVisibleDivisionSet();
        for(String divName : divNameSet) {
            divString += '\'' + divName + '\',';
        }
        divString = (divString.length() > 0) ? divString.left(divString.length() - 1) : '\'\'';
        return divString;
    }
    
    public List<SelectOption> getZoneListZonalManager() {
        System.debug('\n ### strMarketRecordId '+strMarketRecordId+', Userinfo.getUserId() '+Userinfo.getUserId()+', strCurrentCmpgnNR '+strCurrentCmpgnNR);
        zoneList = new List<SelectOption>();        
        if (strProfileName.contains('Zone')){
            list<Sales_Org_Summary__c> lstCampaigns= [ select SLS_ORG_DESC_TXT__c 
                                                         from Sales_Org_Summary__c 
                                                        where ZONE_MGR__c=:Userinfo.getUserId()  
                                                            //and (OPERTNL_CMPGN_NR__c =: strCurrentCmpgnNR or OPERTNL_CMPGN_NR__c =: strPriorCmpgnNR or OPERTNL_CMPGN_NR__c =: strNextCmpgnNR ) 
                                                            and FLD_SLS_CMPGN_NR__c = :strCurrentCmpgnNR 
                                                            and MRKT_KEY__c = :strMarketRecordId
                                                            and SLS_ORG_LVL_DESC_TXT__c = 'Z'
                                                        order by SLS_ORG_DESC_TXT__c asc ];   
                                                        
            System.debug('\n ### lstCampaigns '+lstCampaigns);
            Set<String> uniqueSlsOrgDesc = new Set<String>();
            if(lstCampaigns.size()>0){
                set<string> setSLSORGDESCTXT = new set<string>();
                for(Sales_Org_Summary__c campaigns : lstCampaigns) {
                    setSLSORGDESCTXT.add(campaigns.SLS_ORG_DESC_TXT__c);
                }
                for(string strSet : setSLSORGDESCTXT) {
                    zoneList.add(new SelectOption(strSet, strSet));
                }
                /*
                for(Sales_Org_Summary__c campaigns : lstCampaigns) {
                    if(uniqueSlsOrgDesc.contains(campaigns.SLS_ORG_DESC_TXT__c))
                        continue;
                    zoneList.add(new SelectOption(campaigns.SLS_ORG_DESC_TXT__c, campaigns.SLS_ORG_DESC_TXT__c));
                }*/
            }
        }
        zoneList.sort();
        return zoneList;
    }
    
    /* Get all the zones visible by the logged in user and return them as list of Strings*/
    public Set<String> getVisibleZoneSet() {
        Set<String> zoneSet = new Set<String>();    
        
        System.debug('getVisibleZoneSet: '+strMarketRecordId);
                
        List<Sales_Org_Summary__c> salesOrgList=[select id, SLS_ORG_DESC_TXT__c
                                                    from Sales_Org_Summary__c
                                                    where MRKT_KEY__c = :strMarketRecordId 
                                                    and SLS_ORG_LVL_DESC_TXT__c = 'Z'];

        if (salesOrgList.size() > 0) {
            System.debug('salesOrgList: '+salesOrgList);
            for (Sales_Org_Summary__c slsOrg : salesOrgList) {
                system.debug ('sls org id = ' + slsOrg.Id); 
                system.debug ('sls_org_desc_txt = ' + slsOrg.SLS_ORG_DESC_TXT__c); 
                zoneSet.add(slsOrg.SLS_ORG_DESC_TXT__c);
            }
        }
        system.debug('zoneSet size = ' + zoneSet.size());
        system.debug('zoneSet =' + zoneSet);
        return zoneSet;
    }
    
    /* Get all the divisions visible by the logged in user and return them as list of Strings*/
    public Set<String> getVisibleDivisionSet() {
        Set<String> zoneSet = new Set<String>();
        
        System.debug('getVisibleDivisionSet: '+strMarketRecordId);
                    
        List<Sales_Org_Summary__c> salesOrgList=[select SLS_ORG_DESC_TXT__c
                                                    from Sales_Org_Summary__c
                                                    where MRKT_KEY__c = :strMarketRecordId 
                                                    and SLS_ORG_LVL_DESC_TXT__c = 'D'];

        if (salesOrgList.size() > 0) {
            for (Sales_Org_Summary__c slsOrg : salesOrgList) {
                zoneSet.add(slsOrg.SLS_ORG_DESC_TXT__c);
            }
        }
        return zoneSet;
    }
    
    public static String getSalesOrgSummaryFields() {
        String[] fieldNames = new String[]{};
        Schema.SObjectField[] salesOrgSummaryFields = Schema.getGlobalDescribe().get('Sales_Org_Summary__c').getDescribe().fields.getMap().values();
        
        for(Schema.SObjectField fld : salesOrgSummaryFields ) {
            fieldNames.add(fld.getDescribe().getName());
        }
        
        return String.join(fieldNames, ', ');
    }
    
    
    /* Method to determine whether user has downline as TL or PM*/
    public Boolean hasTLDonwlines(List<Selectoption> Zones, String acctNbr, Double cmpgnNbr, String objname)
    {
        //System.debug('\n #####  acctNbr :: '+acctNbr+', cmpgnNbr :: '+cmpgnNbr+', objname :: '+objname);
        
        Set<string> zoneSet = new Set<string>();
        Set<string> sosSet = new Set<string>();
        String zoneString = '';
        String slsString = '';
        
        if(Zones.size() > 0){
            for(Selectoption z : Zones){
                zoneSet.add(z.getValue());
                String temp = this.strMRKTID + strCurrentCmpgnNR + 'Z' + z.getValue();
                sosSet.add(temp);
            }
            
            for(String zoneName : zoneSet) {
                zoneString += '\'' + zoneName + '\',';
            }
            
            boolean first = true;
            for(String sosName : sosSet) {
                if (first){
                slsString += '\'' + sosName + '\'' ;
                first = false;
                }else{
                slsString += ',\'' + sosName + '\'';
                }
            }
            
         } else {
            slsString += '\' \'';   
        }
        
        //System.debug('\n #####  zoneString 1 :: '+zoneString);    
        
        zoneString = (zoneString.length() > 0) ? zoneString.left(zoneString.length() - 1) : '\'\'';
        
        //System.debug('\n #####  zoneString 2 :: '+zoneString);
        //' AND ROOT_UPLN_ACCT_NR__c = ' + '\'' + acctNbr + '\' AND SLS_ZONE_CD__c IN ( '+zoneString+') '+
        /* Commented by Milon on 7/23/2013
        String tl_soql = 'SELECT LDR_TYP__c FROM '+objname+' WHERE FLD_SLS_CMPGN_NR__c = '+cmpgnNbr+ 
                          ' AND ROOT_UPLN_ACCT_NR__c = ' + '\'' + acctNbr + '\' AND SLS_ZONE_CD__c IN ( '+zoneString+') '+
                          ' AND LDR_TYP__c = \''+'TL'+'\' LIMIT 1';
         
         */     
         System.debug('slsString ---'+slsString);             
        String tl_soql = 'SELECT ID FROM Sales_Org_Summary__c  WHERE '+
                          ' SLS_ORG_SUMRY_KEY__c IN ( '+slsString+') '+
                          ' AND ( TITL_0_TL_STF_CNT__c > 0 ' +
                          ' OR TITL_1_TL_STF_CNT__c > 0 ' +   
                          ' OR TITL_2_TL_STF_CNT__c > 0 ' + 
                          ' OR TITL_3_TL_STF_CNT__c > 0 ' +  
                          ' OR TITL_4_TL_STF_CNT__c > 0 )';                   
        
        System.debug('\n #####  tl_soql \n'+tl_soql);
        
        List<Sobject> lstResult = Database.query(tl_soql);
        
        if( lstResult != null && lstResult.size() > 0 )
            return true;
        
        return false;
    }
    
    public String getZones(Id id)
    {
        String zones = '';
        System.debug('\n #### ID -->> '+id+', Userinfo.getUserId() :: '+Userinfo.getUserId());
        list<Sales_Org_Summary__c> lstSLSOrgs= [ select SLS_ORG_DESC_TXT__c 
                                                   from Sales_Org_Summary__c 
                                                   where ZONE_MGR__c=:Userinfo.getUserId() 
                                                   and MRKT_KEY__c = :id
                                                   and SLS_ORG_LVL_DESC_TXT__c = 'Z'
                                                   order by SLS_ORG_DESC_TXT__c asc ];   
        System.debug('\n #### lstSLSOrgs  -->> ' +lstSLSOrgs);                                         
        Set<String> uniqueSlsOrgDescSet = new Set<String>();
        if(lstSLSOrgs.size()>0)
        {
            for(Sales_Org_Summary__c slsOrg : lstSLSOrgs) {
                    uniqueSlsOrgDescSet.add(slsOrg.SLS_ORG_DESC_TXT__c);
            }  
            
            // To track if the user has access to multiple zones
            if(uniqueSlsOrgDescSet.size() > 1) {
                isAccessToMultipleZones = true; 
            }
        }
               
        for(String zoneName : uniqueSlsOrgDescSet) {
                zones += '\'' + zoneName + '\',';
        }
        zones = (zones.length() > 0) ? zones.left(zones.length() - 1) : '\'\'';
        System.debug('\n ######### USER ZONE LIST '+zones);
        return zones;
        
    }
    
}