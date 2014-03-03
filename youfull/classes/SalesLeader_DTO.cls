/***************************************************************************
 Name          : SalesLeader_DTO 
 Created By    : Barkha Jain
 Description   : Utility class for Sales Leader reports
 Created Date  : Jan 10, 2014                
****************************************************************************/
public with sharing class SalesLeader_DTO {
    public User currentUser{get;set;}
    public Market__c market {get;set;}
    public ALM_Rep_Performance_1__c repPerformance{get;set;}
    
    public boolean showFilters {get;set;}   
    public List<ReportFilter> filters {get;set;}
    public String filterLogic {get;set;} 
    
    public Boolean isModeRun {get; set;} 
    public String applicationContext {get; set;}
    public String selectedCampaign {get;set;}
    public String reportTranslationId {get;set;}
    public String reportTranslationLabel {get;set;}
    public boolean showParameters {get;set;}   
    public String selectedReportId {get;set;}
    
    public List<SelectOption> campaignList {get;set;}
      
    private String sfdcServerName;        
    private ALM_ServiceInt_Report reportCallout {get;set;}
    private Map<String, String> pageParamsMap;
    Map<Id, ZM_Report_Translation__c> reportsTranslationMap;
    
    //Constructor
    public SalesLeader_DTO(){
        showFilters = false;
        pageParamsMap = new Map<String, String>();
    	
        initializeData();
    }
    
    //==============================================================================================//
    //Initialize the user, market, report, title data
    //==============================================================================================// 
    private void initializeData() {
    	// creating map of Page parameters for case-insensitive match
    	Map<String, String> pageParamsTemp = Apexpages.currentpage().getParameters();
    	for(String key : pageParamsTemp.keySet()){
    		pageParamsMap.put(key.toLowerCase(), pageParamsTemp.get(key));
    	}
    	
    	if(pageParamsMap.containsKey('mode') && pageParamsMap.get('mode').equalsIgnoreCase('run')){
    		isModeRun = true;
    	}else{
    		isModeRun = false;
    	}
    	
    	if(pageParamsMap.containsKey('context')){
    		applicationContext = PageParamsMap.get('context');
    	}
    	
    	if(pageParamsMap.containsKey('campaign')){
    		selectedCampaign = PageParamsMap.get('campaign');
    	}
    	if(PageParamsMap.containsKey('reporttranslation')){
    		reportTranslationId = PageParamsMap.get('reporttranslation');
    		for(ZM_Report_Translation__c zm : [Select Id, Report_Label__c,
                                               showParameters__c
                                           	   From ZM_Report_Translation__c
                                           	   where id =: reportTranslationId]){
            	reportTranslationLabel = zm.Report_Label__c;
            	showParameters = zm.showParameters__c;                        	   	
            }
    	}else{
    		showParameters = false;
    	}
    	
    	if(PageParamsMap.containsKey('subreportid')){
    		selectedReportId = PageParamsMap.get('subreportid');
    	}
    	
        sfdcServerName = Apexpages.currentpage().getheaders().get('X-Salesforce-Forwarded-To'); 
        if(String.isBlank(sfdcServerName)) {
            sfdcServerName = 'prerelna1.pre.salesforce.com';
        }         
        reportCallout = ALM_ServiceInt_ReportAnalyticsAPI.getInstance();
        // Initialize user
        currentUser = [SELECT Id, Profile.Name, MRKT_ID__c, ACCT_NR__c, LanguageLocaleKey 
                       from User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            
        // Initialize market
        this.market = [SELECT Id, Market_Id__c, CMPGN_NR__c, PREV_1_CMPGN_NR__c, NEXT_1_CMPGN_NR__c, Allow_Freeform_Email__c 
                       FROM Market__c 
                       where Market_Id__c = :currentUser.MRKT_ID__c];
                        
        //Set the campaign number.  For now, just use operational.  Will need to be modified for Mailplan handling.
        if(selectedCampaign == null){
        	this.selectedCampaign = this.market.CMPGN_NR__c;
        }
       
        // Initialize repPerformance
        String genealogyKey = this.market.Market_Id__c + selectedCampaign + currentUser.ACCT_NR__c;
        fetchALMRepPerformance(genealogyKey);
        populateCampaignList();       
    }
    
    //==============================================================================================//
    // Fetching fetchALMRepPerformance
    //==============================================================================================// 
    private void fetchALMRepPerformance(String genealogyKey){
   		for(ALM_Rep_Performance_1__c repRecord : [SELECT Id, ACCT_NR__c, ROOT_UPLN_ACCT_NR__c, 
   								LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c
                                From ALM_Rep_Performance_1__c
                                Where Genealogy_Key__c = :genealogyKey limit 1]){
             this.repPerformance = repRecord;        	
        }
    }
    
    //==============================================================================================//
    // Check if free form emails allowed for current user's profile
    //==============================================================================================// 
    public boolean checkIsEmailAllowedForProfile(){
    	if(market.Allow_Freeform_Email__c != null && market.Allow_Freeform_Email__c.contains(currentUser.Profile.Name)){
    		return true;
    	}
    	return false;
    }
    
    //==============================================================================================//
    //Use data on Market to provide a list of SelectOptions for prior, current, and next campaign
    //==============================================================================================//    
    public void populateCampaignList() {      
        campaignList = new List<SelectOption>();        
        campaignList.add(new SelectOption(market.PREV_1_CMPGN_NR__c, market.PREV_1_CMPGN_NR__c)); // Prior
        campaignList.add(new SelectOption(market.CMPGN_NR__c, market.CMPGN_NR__c));               // Current
        campaignList.add(new SelectOption(market.NEXT_1_CMPGN_NR__c, market.NEXT_1_CMPGN_NR__c)); // Next
    }
    
    //==============================================================================================//
    //Set selectedCampaign in report filter
    //==============================================================================================//      
    public void setSelectedCampaignFilter(){
    	String genealogyKey = this.market.Market_Id__c + selectedCampaign + currentUser.ACCT_NR__c;
        fetchALMRepPerformance(genealogyKey);
    	if(selectedCampaign != null && filters != null && filters.size() > 0){
           for(ReportFilter filter : filters){
           		if(filter.apiName.equalsIgnoreCase(ALMConstants.ROOT_UPLINE_ACCOUNT_NUMBER)){
                    filter.value = this.repPerformance.ROOT_UPLN_ACCT_NR__c;
                }else if(filter.apiName.equalsIgnoreCase(ALMConstants.LEFT_NODE_ID)){
                    filter.value = String.valueOf(this.repPerformance.LFT_ND_ID__c);
                }else if(filter.apiName.equalsIgnoreCase(ALMConstants.RIGHT_NODE_ID)){
                    filter.value = String.valueOf(this.repPerformance.RGT_ND_ID__c);
                }      
	            else if(filter.apiName.equalsIgnoreCase(ALMConstants.CAMPAIGN_NUMBER)){
	           	   filter.value = selectedCampaign;           
	           }           	
           } 	   
    	}
    }
    
    //=================================================================//
    // Method populates report filters for given reportId
    //=================================================================//
    public void populateReportFilters(String reportId){
    	describeReport(reportId);
	    if(filters != null && filters.size() > 0){
	    	selectedReportId = reportId;
	    	setUserSpecificReportParameters();                    	                       
       	}
        if(showParameters){
        	showFilters = true;
        } 
	    else{
	    	showFilters = false;
	   	}
    }
    
    //=================================================================//
    //Method describes report by calling Analytic API Report Describe
    //=================================================================//
    public void describeReport(String reportId){
        if(reportId != null){               
            String describeResult = reportCallout.getAnalyticsReportDescribe(sfdcServerName, reportId);            
            try{
                ALM_Utility_AnalyticsReportParser parser = new ALM_Utility_AnalyticsReportParser(describeResult);
                filterLogic = parser.getReportFilterLogic();
                filters = parser.getReportFilters();
            }catch(Exception ex){
                ALMLogUtils.log(ex);
            }                       
        }   
    }   
    
    //=================================================================//
    // Method sets user specific values for some specific filter params
    //=================================================================//
    public void setUserSpecificReportParameters(){
        // Fetch secured report parameters, set user specific values for them and hide them
        Map<String, Secured_Filter_Parameters__c> securedParams = Secured_Filter_Parameters__c.getAll();
        for(ReportFilter filter : filters){
            if(securedParams.containsKey(filter.apiName)){
                if(filter.apiName.equalsIgnoreCase(ALMConstants.MARKET_ID)){
                    filter.value = this.market.Market_Id__c;
                }else if(filter.apiName.equalsIgnoreCase(ALMConstants.ROOT_UPLINE_ACCOUNT_NUMBER)){
                    filter.value = this.repPerformance.ROOT_UPLN_ACCT_NR__c;
                }else if(filter.apiName.equalsIgnoreCase(ALMConstants.LEFT_NODE_ID)){
                    filter.value = String.valueOf(this.repPerformance.LFT_ND_ID__c);
                }else if(filter.apiName.equalsIgnoreCase(ALMConstants.RIGHT_NODE_ID)){
                    filter.value = String.valueOf(this.repPerformance.RGT_ND_ID__c);
                }                   
            }
            if(filter.apiName.equalsIgnoreCase(ALMConstants.CAMPAIGN_NUMBER)){
                //filter.showFilter = true;
                filter.value = selectedCampaign;                
            }
            else if(filter.apiName.equalsIgnoreCase(ALMConstants.LEVEL_TITLE_NUMBER)){
                filter.showFilter = true;
                filter.value = '0,1,2,3,4';
            }
            else if(filter.apiName.equalsIgnoreCase(ALMConstants.GENERATION)){
                filter.showFilter = true;
            }          
            else if(filter.value == ''){
                filter.showFilter = true;
            }else if(filter.apiName.equalsIgnoreCase(ALMConstants.ACCOUNT_NUMBER) && filter.value != ''){
                filter.value = String.valueOf(this.repPerformance.ACCT_NR__c);                  
            }
            
            if(reportsTranslationMap.get(selectedReportId).Report_Label__c.contains('Removed Representatives')
            	&& filter.apiName.equalsIgnoreCase(ALMConstants.REMOVAL_CAMPAIGN)){
            	filter.value = String.valueOf(this.market.PREV_1_CMPGN_NR__c);
        	}
        	
            // Set filter value from url paramaters if exist
            String paramValue = getParamValue(filter.label);
            if(paramValue != null){
            	filter.value = paramValue;
            }
            
        }       
    }
    
    //=================================================================//
    //Get url param value from filter label
    //=================================================================//
    private String getParamValue(String label){
    	String paramName = label.replaceAll(' ', '').toLowerCase();
    	if(pageParamsMap.containsKey(paramName))
    		return pageParamsMap.get(paramName);
    		
    	return null;
    }
    
    //=================================================================//
    //Get report arguments for download
    //=================================================================//
    public String getReportArgumentsForDownload(){
        String argList = '';
        if (filters != null && filters.size() > 0) {            
            for (Integer index = 0; index < filters.size(); index++) {
                if(index == 0){
                    argList += 'pv' + index + '=' + filters[index].value;
                }else{
                    argList += '&pv' + index + '=' + filters[index].value;
                }               
            }
        }
        return argList;
    }
    
    //==============================================================================================//
    //Use cached data from ZM_Report_Translation__c to provide a Map of ReportId to translation record
    //==============================================================================================//
    public Map<Id, ZM_Report_Translation__c> getReportTranslationsMap(){      
        reportsTranslationMap = new Map<Id, ZM_Report_Translation__c>();
        for(ZM_Report_Translation__c z : [Select Sort_Order__c
                                               , Report_URL__c
                                               , Report_Label__c
                                               , Report_Id__c
                                               , Market_Id__c
                                               , Language_Code__c
                                               , Id
                                               , Application_Context__c
                                               , Report_Role__c 
                                               , NumberOfColumnstoFreeze__c,
                                               showParameters__c
                                           From ZM_Report_Translation__c z
                                           where Language_Code__c = :currentUser.LanguageLocaleKey
                                            and Market_Id__c includes(:currentUser.MRKT_ID__c)
                                            and Application_Context__c includes (:applicationContext)
                                           order by sort_order__c]){
             if(currentUser.Profile.Name == null || currentUser.Profile.Name.containsIgnoreCase(z.Report_Role__c))
                reportsTranslationMap.put(z.Report_Id__c, z);              
         }
        return reportsTranslationMap;
    }
    
    //==============================================================================================//
    // Method to uddate the Gen Level of the logged in user in custom settings
    //==============================================================================================//
    public void updateUserGenIndex(){
        Id loggedInUserId = UserInfo.getUserId();
        if(repPerformance != null){
            // Now try to fetch the custom setting for this user
            DownloadAll_GenIndex__c genIndexCustomSetting = DownloadAll_GenIndex__c.getInstance(loggedInUserId);  
        
            if(genIndexCustomSetting == null || genIndexCustomSetting.Id == null){
                // Insert new one
                genIndexCustomSetting = new DownloadAll_GenIndex__c();
                genIndexCustomSetting.SetupOwnerId = loggedInUserId;
            }
            
            // Retrieving gen level of rep Record and updating user's custom setting record
            Decimal genLevel = (Decimal)repPerformance.get('Genealogy_Level__c');
            genIndexCustomSetting.Gen_Index__c = genLevel;
            genIndexCustomSetting.Market_Id__c = currentUser.MRKT_ID__c;
            genIndexCustomSetting.SelectedCampaign__c = selectedCampaign;
            genIndexCustomSetting.Accnt_Nr__c = currentUser.ACCT_NR__c;
            upsert genIndexCustomSetting;
        }               
    }
    
    //==============================================================================================//
    // Returning the Map of column name to set of values for that column
    //==============================================================================================//
    public Map<String, Set<String>> getMapOfColumnsValueSet(String reportId, List<String> fieldNames){
    	Set<String> valueSet;
    	Map<String, Set<String>> mapColumnValueSets = new Map<String, Set<String>>();
    	
    	if(reportId != null){               
            String describeResult = reportCallout.getAnalyticsReportResponse(sfdcServerName, reportId, filterLogic, filters);            
            try{
           		ALM_Utility_AnalyticsReportParser parser = new ALM_Utility_AnalyticsReportParser(describeResult);
           		for(String fName : fieldNames){
                	valueSet = parser.getSetOfColumnValues(fName);
                	mapColumnValueSets.put(fName, valueSet);
           		}
            }catch(Exception ex){
            	ALMLogUtils.log(ex);
            }                       
        }
        return mapColumnValueSets;
    }
}