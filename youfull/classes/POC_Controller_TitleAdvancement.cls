/***************************************************************************
 Name          : POC_Controller_TitleAdvancement 
 Created By    : Fay Salwen 
 Description   : POC of Title Advancement Controller 
 Created Date  : Dec 20, 2013                
****************************************************************************/

public with sharing class POC_Controller_TitleAdvancement {
	
    private User currentUser;
    public String userProfile {get;set;}
    private Market__c market;
    private ALM_Rep_Performance_1__c repPerformance;
    
    private List<SelectOption> campaignList = new List<SelectOption>();    
    private List<SelectOption> titleList = new List<SelectOption>();
    private List<SelectOption> reportList = new List<SelectOption>();
    private List<SelectOption> searchTypeList = new List<SelectOption>();

    public String selectedCampaign {get; set;}
    public String selectedTitle {get; set;}
    public Id selectedReport {get; set;}
    public String selectedSearchType {get; set;}
    public String searchString {get; set;}
    
    private AnalyticReportParser reportParser;
 
	//==============================================================================================//
  	//Constructor
  	//==============================================================================================//
    public POC_Controller_TitleAdvancement() {   

        initializeData();  
        
        /*
        if (market.Mail_Plan_Enabled__c) {
        	List<Sobject> list = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, usr.ACCT_NR__c, usr.MRKT_ID__c);  
        	this.selectedStandard = getMailPlanCampaign(lst_CombinedObj);
        }
        */
        
    }

	//==============================================================================================//
  	//Initialize the user, market, report, title data
  	//==============================================================================================//    
    private void initializeData() {
        // Initialize user
        currentUser = [SELECT Id, Profile.Name, MRKT_ID__c, ACCT_NR__c, DFALT_DIV_NM__c, DFALT_ZONE_CD__c, User.LanguageLocaleKey, UserRole.Name 
                from User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        userProfile = currentUser.Profile.Name;
            
        // Initialize market
        this.market = [SELECT Id, Market_Id__c, PREV_1_CMPGN_NR__c, Mail_Plan_Enabled__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c,  
                       Omniture_Suite_Name__c, Mgr_Omniture_Suite_Name__c  FROM Market__c 
                        where Market_Id__c = :currentUser.MRKT_ID__c];
                        
        //Set the campaign number.  For now, just use operational.  Will need to be modified for Mailplan handling.
        this.selectedCampaign = this.market.CMPGN_NR__c;
       
		// Initialize repPerformance
		String genealogyKey = this.market.Market_Id__c + selectedCampaign + currentUser.ACCT_NR__c;
        system.debug('---------------- genealogyKey-------------------'+genealogyKey);
		this.repPerformance = [SELECT Id, ACCT_NR__c, FLD_SLS_CMPGN_NR__c, ROOT_UPLN_ACCT_NR__c, LFT_ND_ID__c, RGT_ND_ID__c, REP_OMS_STUS_CD__c, LDRSHP_TITL_LVL_NR_NUMBER__c
										From ALM_Rep_Performance_1__c
										Where Genealogy_Key__c = :genealogyKey limit 1];
		     
        // Initialize the list of reports
        for(ZM_Report_Translation__c z : [Select z.Sort_Order__c
                                               , z.Report_URL__c
                                               , z.Report_Label__c
                                               , z.Report_Id__c
                                               , z.Market_Id__c
                                               , z.Language_Code__c
                                               , z.Id
                                               , z.Application_Context__c
                                               , z.Report_Role__c 
                                            From ZM_Report_Translation__c z
                                           where Language_Code__c = :currentUser.LanguageLocaleKey
                                            and Market_Id__c includes(:currentUser.MRKT_ID__c)
                                            and Application_Context__c includes ('Title Advancement')
                                           order by sort_order__c]){
                                           	
            if(currentUser.Profile.Name == null || currentUser.Profile.Name.containsIgnoreCase(z.Report_Role__c))
                reportList.add(new SelectOption(z.Report_Id__c, z.Report_Label__c));
                 
        }
        
        //Initialize the list of titles
        titleList.add(new SelectOption('0,1,2,3,4', 'All Paid Titles'));
        for(Leader_Title__c t : [Select t.Market__c, t.LANG_CD__c, t.LDRSHP_TITL_LVL_NR__c, t.LDRSHP_TITL_LVL_NR_NUMBER__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c
        									From Leader_Title__c t
        									where LANG_CD__c = :currentUser.LanguageLocaleKey
        									and Market__c = :this.market.Id
        									order by Market__c, LANG_CD__c, LDRSHP_TITL_LVL_NR_NUMBER__c]) {
        	titleList.add(new SelectOption(t.LDRSHP_TITL_LVL_NR__c, t.LCL_LDRSHP_TITL_LANG_DESC_TXT__c));
       	}

    }
    
	//==============================================================================================//
  	//Dummy placeholder method
  	//==============================================================================================//
    public void doNothing(){ }

	//==============================================================================================//
  	//Use data on Market to provide a list of SelectOptions for prior, current, and next campaign
  	//==============================================================================================//    
	public List<SelectOption> getCampaignList() {      
        List<SelectOption> options = new List<SelectOption>();        
        options.add(new SelectOption(market.PREV_1_CMPGN_NR__c, market.PREV_1_CMPGN_NR__c)); // Prior
        options.add(new SelectOption(market.CMPGN_NR__c, market.CMPGN_NR__c)); 				 // Current
        options.add(new SelectOption(market.NEXT_1_CMPGN_NR__c, market.NEXT_1_CMPGN_NR__c)); // Next
        return options;
    }
    
	//==============================================================================================//
  	//Use cached data from Leader_Title__c to provide a list of SelectOptions for the different Leader Title levels
  	//==============================================================================================//    
	public List<SelectOption> getTitleList() {
        return titleList;
    }

	//==============================================================================================//
  	//Use cached data from ZM_Report_Translation__c to provide a list of SelectOptions to represent the different Reports
  	//==============================================================================================//          
    public List<SelectOption> getReportList() {
        return reportList;
    }
    
	//==============================================================================================//
  	//Provide a static list of SelectOptions for the search types, namely Name and Account
  	//==============================================================================================//    
	public List<SelectOption> getSearchTypeList() {      
        List<SelectOption> options = new List<SelectOption>();        
        options.add(new SelectOption('Full Name', 'Full Name'));
        options.add(new SelectOption('Account Number', 'Account Number'));
        return options;
    }
    
	//==============================================================================================//
  	//Get the list of parameters to be sent to the report for filtering
  	//==============================================================================================//    
	public List<String> getReportArgumentList() {
      List<String> arguments = new List<String>();
      arguments.add(this.market.Market_Id__c);
      arguments.add(this.selectedCampaign);
      arguments.add(this.currentUser.ACCT_NR__c);
      arguments.add(this.repPerformance.ROOT_UPLN_ACCT_NR__c);
      arguments.add(String.valueOf(this.repPerformance.LFT_ND_ID__c));
      arguments.add(String.valueOf(this.repPerformance.RGT_ND_ID__c));
      arguments.add('1');
      arguments.add(this.selectedTitle);
      if(searchString != null && searchString.trim() != ''){
      	arguments.add(selectedSearchType);
      	arguments.add(searchString);
      }
      return arguments;
	}
	
    //=================================================================//
    //Get report data through analytics api call
    //=================================================================//
    public PageReference getReportData() {
      IalmReportService reportCallout = almAnalyticsAPIImp.getInstance();
      String sfdcServerName = Apexpages.currentpage().getheaders().get('X-Salesforce-Forwarded-To');
      // URL.getSalesforceBaseUrl().toExternalForm()
      if(String.isBlank(sfdcServerName)) {
        sfdcServerName = 'prerelna1.pre.salesforce.com';
      }      
      System.debug('---------------- this.selectedReportID-------------------'+this.selectedReport);

      String json = reportCallout.getAnalyticsReportResponse(sfdcServerName, this.selectedReport, null, null);
      reportParser = new AnalyticReportParser(json);
      return null;
    }
  
    //=================================================================//
    //Get report data into apex:datatable
    //=================================================================//
    public Component.Apex.DataTable getReportDataTable(){
      /*if(reportParser != null){
      Component.Apex.DataTable tbl = reportParser.getVFDataTable();
      return tbl;
      }else{*/
        return null;
      //}
    }
    
}