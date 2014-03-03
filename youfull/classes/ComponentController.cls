/*
** Apex Class/Controller Name           : TitleAchievmentController
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Parent class for all Landing Page Component Controllers
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** May 9: Created
** 
*/

public virtual class ComponentController {
    public Boolean isPrior {get; set;}
    // Added by Raktim on 21Jun 2013 - Mail Plan
    private Boolean isNext;
    public MailPlan_Order_Oppty__c mailPlan {get; private set;}
    public Boolean isMailPln {get; set;}//added by swarnava
    public Integer G1ActiveBaseCnt {get; set;}//added by swarnava
    
    public String impersonate {get; set;}
    
    public String currencyCharacter {get; set;}
    public String userLang {get;set;}
    public String userLocale {get;set;}
    public String username {get; set;}
    public String marketId {get; set;}
    public String profileId {get; set;}
    public PageReference redPage {get; set;} // for exception handling
    public Landing_Page_Component__c componentConfig {get; set;}
    public String viewFullReportURL {get; set;}
    public String myTeamReportLink {get; set;}
    public String myTeamOrdersReportLink {get; set;}
    public String Mail_Plan_Code {get; set;}
    public String Mail_Plan_Zone_Code {get; set;}
    public Boolean isSellingCampMyDefault  {get; set;}
    public Boolean isCurrCampMyDefault {get; set;}
    public Boolean isLandingPage_MailPln {get; set;}
    
    
    protected Map<String, Leader_Title__c> mapLeaderTitle = new Map<String, Leader_Title__c>();
    protected MarketLeaderTitleUtils leaderUtils = null;
    protected Leader_Title__c currLeader = null;
    protected Map<String, Custom_Message__c> mapCMessages = null;
    protected Decimal leaderLevelNumber;
    protected String leaderLevel;
    protected String leaderType; // EL or UL or SEL or ...
    protected LandingPageUtils lpu;
    public Market__c currMarket{get; private set;} 
    protected User currUser;
    protected String profileName;
    protected String userKey = null;
    protected String userLeadershipSummaryKey = null;
    protected String userPersonalPerformanceKey = null;
    protected Map<String, Contact> mapContact;
    protected Map<String, String> pageAllParams;
    protected String originalUrl;
    protected String campaignNumber; // filter current and prior campaigns
    protected boolean emailAllowed ;
    //protected My_Business__c personalPerformance;
    //protected Leader_Downline_Summary__c leaderDownline;
    
    protected SObject almRepPerformance;
    
    protected String [] fieldsCustomMessage ; // String parameters for Custom Messages
    protected String [] userTypes ;
    protected String [] titleTypes ;
    protected String numberOfRowsToDisplay ; //information from configuration
    protected Integer eachRowHeight ; //information from configuration
    protected String reportString; //adjustment to report links for impersonation and campaign toggle
    protected Boolean isValid; // if page loaded without problems. Exception handling
    protected String exceptionText; // passed to ErrorHandler
    
    public Boolean isBranch {get; set;}  // variable added - Mail Plan
    public Integer Exec_Ttl_num{get; set;}
    
    public Boolean isQPAEnabled {get; set;}  // variable added by Raktim - G1 Dashboard Change, on 26th Sept 2013
    public Boolean isDisplayQPA {get; set;}  // variable added by Subhamay - show/hide QPA, on 8th Oct 2013
    
    public ComponentController() {
        isPrior = false; //by default show current campaign
        emailAllowed = false; // by default email NOT allowed
        isBranch = false; // by default isBranch not shown
        reportString = ''; //by default current campaign and NO impersonation
        isQPAEnabled = false;  // by default QPA NOT Enabled - G1 Dashboard Change, on 26th Sept 2013
        isDisplayQPA = false;  // variable added by Subhamay - show/hide QPA, on 8th Oct 2013
        campaignNumber = ApexPages.currentPage().getParameters().get('mpCampaign');
        System.debug('============ ComponentController. query parameters : ' + ApexPages.currentPage().getParameters());
        String imperson = ApexPages.currentPage().getParameters().get(ALMConstants.IMPERSON_PARAM_NAME);
        System.debug('===================== ComponentController. Impersonation : ' + imperson);
        isSellingCampMyDefault = false; // by default this is false - Added by Raktim on 24Jun 2013 Mail Plan
        isLandingPage_MailPln = false; // by default this is false - Added by Raktim on 24Jun 2013 Mail Plan
        
        // Modified query by Raktim on 24Jun 2013
        currUser = [Select Id, LocaleSidKey, Profile.Name, MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c from User where Id = :UserInfo.getUserId() limit 1]; 
        
        /** Following lines added by Raktim for Impersonation Issue on 7th Oct 2013 - START **/
        this.userLang = currUser.LanguageLocaleKey;
        this.userLocale = currUser.LocaleSidKey;
        /** Following lines added by Raktim for Impersonation Issue on 7th Oct 2013 - END **/
        
        if (imperson != null && imperson.length() > 0) {
            currUser = [Select Id, LocaleSidKey, MRKT_ID__c, Profile.Name, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c from User where MRKT_ID_ACCT_NR_KEY__c = :(currUser.MRKT_ID__c + imperson) limit 1]; 
        } 
        
        myTeamOrdersReportLink='';
        myTeamReportLink='';
        
        profileName = currUser.Profile.Name;
        try {
            
            String isPriorStr;
            // pull data from the prior campaign
            isPrior = LandingPageUtils.isPreviousCampaign(ApexPages.currentPage().getParameters().get(ALMConstants.CAMPAIGN));
            isNext = LandingPageUtils.isNextCampaign(ApexPages.currentPage().getParameters().get(ALMConstants.CAMPAIGN));
            /*if ((isPriorStr = ) != null) {
                if (isPriorStr.equalsIgnoreCase(ALMConstants.PRIOR_CAMPAIGN)) {
                    isPrior = true;  
                } else if (isPriorStr.equalsIgnoreCase(ALMConstants.CURRENT_CAMPAIGN)) {
                    isPrior = false;  
                }
            }*/
            
            /** Following Lines are blocked by Raktim for IMPERSONATION Language Issue on 7th Oct 2013 - START **/
            /*
            //user language
            if (currUser.LanguageLocaleKey != null) {
                this.userLang = currUser.LanguageLocaleKey;
            }
            if (currUser.LocaleSidKey!= null) {
                this.userLocale = currUser.LocaleSidKey;
            }
            */
            /** Following Lines are blocked by Raktim for IMPERSONATION Language Issue on 7th Oct 2013 - END **/
            System.debug('===================== ComponentController. User Language : ' + this.userLang);
            System.debug('===================== ComponentController. User Locale: ' + this.userLocale);
            
            
            // user must be Avon Leader, must have account number 
            if (profilename != null && profileName == ALMConstants.LEADER_PROFL_NAME &&
                                 currUser.MRKT_ID__c != null && currUser.ACCT_NR__c != null) { // market Id is critical for everything
                                     
                this.marketId = currUser.MRKT_ID__c;
                this.profileId = currUser.Profile.Id;
                username = currUser.Name;
                
                currMarket = [SELECT CMPGN_NR__c, Market_Currency_Symbol__c, Id, SPONSOR_QLFYING_ORD_AMT__c,Number_of_Exec_Leader_Title__c,NRT_Enabled__c,
                                     CMPGN_END_DT__c, CMPGN_STRT_DT__c, Market_Id__c, PREV_1_CMPGN_NR__c, Allow_Freeform_Email__c, Is_Branch__c, 
                                     ALM_Rep_Indicator__c, NEXT_1_CMPGN_NR__c, Mail_Plan_Enabled__c,MailPlan_LndingPg_Deflt__c, CURRNT_CMPGN_RMN_DAY_CNT__c,
                                     QPA_Enabled__c, isDisplayQPA__c FROM Market__c 
                                    WHERE Market_Id__c = :currUser.MRKT_ID__c LIMIT 1]; // New fields are added to be retrieved - Mail Plan 
                                                                                        // QPA_Enabled__c field added by Raktim on 26th Sept 2013
                                                                                        // for G1 Appt dashboard query change 
                 //determine campaign number 
                //campaignNumber = (isPrior ? currMarket.PREV_1_CMPGN_NR__c : currMarket.CMPGN_NR__c);
                Exec_Ttl_num=(Integer)currMarket.Number_of_Exec_Leader_Title__c;//added by swarnava for CORE
                isQPAEnabled = (currMarket.QPA_Enabled__c)? true : false; // QPA Enabled flag set from Market by Raktim on 26th Sept 2013
                isDisplayQPA = (currMarket.isDisplayQPA__c)? true : false; // variable added by Subhamay - show/hide QPA, on 8th Oct 2013
                isMailPln=currMarket.Mail_Plan_Enabled__c;
                if(currMarket.Is_Branch__c) {isBranch = true;}
                isLandingPage_MailPln = currMarket.MailPlan_LndingPg_Deflt__c;
                if(isMailPln){
                	if(ApexPages.CurrentPage().getParameters().get('campaign')=='current'){
                		campaignNumber = currMarket.CMPGN_NR__c;	
                	}else if(ApexPages.CurrentPage().getParameters().get('campaign')=='prior'){
                		campaignNumber = currMarket.PREV_1_CMPGN_NR__c;
                	}else if(ApexPages.CurrentPage().getParameters().get('campaign')=='next'){
                		campaignNumber = currMarket.NEXT_1_CMPGN_NR__c;
                	}else
                		campaignNumber=(isLandingPage_MailPln?campaignNumber:currMarket.CMPGN_NR__c);
                }	
                if (campaignNumber != null) { // to reach this marketId, accountNumber and campaign number must exist 
                    
                    userKey = LandingPageUtils.getMarketAccountKey(currUser.MRKT_ID__c, currUser.ACCT_NR__c);
                    userPersonalPerformanceKey = LandingPageUtils.getPersonalPerformanceKey(currUser.MRKT_ID__c, campaignNumber, currUser.ACCT_NR__c );
                    userLeadershipSummaryKey = LandingPageUtils.getLeadershipSummaryKey(currUser.MRKT_ID__c, campaignNumber, currUser.ACCT_NR__c);
                    System.debug('===================== ComponentController. User Key: ' + userKey);
                    System.debug('===================== ComponentController. PPKey: ' + userPersonalPerformanceKey);
                    System.debug('===================== ComponentController. LSKey: ' + userLeadershipSummaryKey);
                    System.debug('===================== ComponentController. operation campaign number: ' + campaignNumber);
                    
                    //gets information for specific campaign for specific user
                    /*
                    
                    personalPerformance =  [SELECT 
                                               FAP_CNT__c, //ri
                                               FAP_AWD_SLS_AMT__c, //ri
                                               CTD_AWRD_SLS_AMT__c, //ts
                                               LCL_TOP_SLR_LVL_KEY__c,
                                               PD_TITL_LVL_NR__c, // for prior campaigns
                                               LDRSHP_TITL_LVL_NR__c,
                                               INVCD_SLS_AMT__c, //pv
                                               SUBMTD_SLS_AMT__c,  //pv
                                               SUBMTD_AWRD_SLS_AMT__c,
                                               INVC_AWRD_SLS_AMT__c
                                            FROM My_Business__c
                                            WHERE Personal_Performance_Key__c = :userPersonalPerformanceKey LIMIT 1];
                                            //AND OPERTNL_CMPGN_NR__c = :campaignNumber LIMIT 1];
                    
                    
                    leaderDownline =  [SELECT 
                                        GRP_FAP_CNT__c, //li
                                        GRP_UNIT_SLS_AMT__c,
                                        GRP_BLCKD_UNIT_SLS_AMT__c, //ts
                                        GRP_INVCD_SLS_AMT__c,
                                        GRP_SUBMTD_SLS_AMT__c, //ts
                                        TTL_LEG_CNT__c, //g1
                                        YTD_GRP_BLCKD_UNIT_SLS_AMT__c, //ts
                                        GENTRTN_1_ACTV_REP_CNT__c,
                                        GRP_SUBMTD_AWRD_SLS_AMT__c,
                                        GRP_SUBMTD_BLCKD_SLS_AMT__c,
                                        GRP_INVCD_BLCKD_SLS_AMT__c,
                                        GRP_INVC_AWRD_SLS_AMT__c,
                                        GRP_INVC_RTURN_AWRD_SLS_AMT__c  
                                       FROM Leader_Downline_Summary__c
                                       WHERE Leadership_Summary_Key__c = :userLeadershipSummaryKey LIMIT 1];
                                       //AND OPERTNL_CMPGN_NR__c = :campaignNumber LIMIT 1];
                    */    
                    //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query             
                    String query = 'Select ACCT_NR__c,FAP_CNT__c, FAP_AWD_SLS_AMT__c, CTD_AWRD_SLS_AMT__c, LCL_TOP_SLR_LVL_KEY__c, PD_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR__c, INVCD_SLS_AMT__c, SUBMTD_SLS_AMT__c, ' + 
                                          ' SUBMTD_AWRD_SLS_AMT__c,INVC_AWRD_SLS_AMT__c,GRP_FAP_CNT__c, GRP_UNIT_SLS_AMT__c, GRP_BLCKD_UNIT_SLS_AMT__c, GRP_INVCD_SLS_AMT__c, GRP_SUBMTD_SLS_AMT__c, TTL_LEG_CNT__c, ' +
                                          ' YTD_GRP_BLCKD_UNIT_SLS_AMT__c, MRKT_INVC_SLS_AMT__c, MRKT_INVC_GRP_SLS_AMT__c, GENTRTN_1_ACTV_REP_CNT__c, GRP_SUBMTD_AWRD_SLS_AMT__c,GRP_SUBMTD_BLCKD_SLS_AMT__c , GRP_INVCD_BLCKD_SLS_AMT__c, GRP_INVC_AWRD_SLS_AMT__c, GRP_INVC_RTURN_AWRD_SLS_AMT__c ,G1_ACTV_BASE_CNT__c '+(isMailPln ?', MailPlan_Order_Oppty__r.MLPLN_CD__c,MailPlan_Order_Oppty__r.SLS_ZONE_CD__c ':' ')+
                                          ' FROM ' + currMarket.ALM_Rep_Indicator__c + ' WHERE  ACCT_NR__c = \'' + currUser.ACCT_NR__c + '\'  AND MRKT_ID__c = \'' + currUser.MRKT_ID__c + '\' AND FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber) + ' LIMIT 1';
                    
                    system.debug('\n ######## query --> '+query);
                    
                    almRepPerformance = Database.query(query);                 
                    G1ActiveBaseCnt=Integer.valueOf(almRepPerformance.get('G1_ACTV_BASE_CNT__c'));
                    
                    if(isMailPln)
                    {
                      try{
                      	Mail_Plan_Code = (String)almRepPerformance.getSObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c'); 
                      	system.debug('\n ######## isMailPln Mail_Plan_Code --> '+Mail_Plan_Code); 
                      }catch(Exception e){
                      	system.debug('\n GOT EXCEPTION for MAIL PLAN CODE, setting it BLANK :: '+e); 	
                      	Mail_Plan_Code = '';
                      }
                      
                      try{           
                      	Mail_Plan_Zone_Code = (String)almRepPerformance.getSObject('MailPlan_Order_Oppty__r').get('SLS_ZONE_CD__c');
                      	system.debug('\n ######## isMailPln Mail_Plan_Zone_Code --> '+Mail_Plan_Zone_Code);
                      }catch(Exception e){
                      	system.debug('\n GOT EXCEPTION for MAIL PLAN ZONE CODE, setting it BLANK :: '+e); 	
                      	Mail_Plan_Zone_Code = '';
                      }
                       
                    }                  
                    // leaderLevel = (isPrior ? personalPerformance.LDRSHP_TITL_LVL_NR__c : personalPerformance.PD_TITL_LVL_NR__c); DELETE REDUNDANT
                    leaderLevel = String.valueOf(almRepPerformance.get('LDRSHP_TITL_LVL_NR__c'));
                    //this information must exist in order to continue
                    /*
                    if (personalPerformance == null || leaderDownline == null || leaderLevel == null ) {
                        throw new InconsistentDataException('Personal Performance or Leader Downline Summary or TitleLevelNumber on Personal Performance is missing');
                    }
                    */
                }
                // is email allowed for this profile
                if (imperson == null && (currMarket.Allow_Freeform_Email__c != null || currMarket.Allow_Freeform_Email__c != '')) {
                    emailAllowed = LandingPageUtils.isEmailAllowedForProfile(currUser.Profile.Name, currMarket.Allow_Freeform_Email__c);
                }
                
                List<String> fieldsConfig = new String[] { 'Landing_Page_Config__c', 'Number_of_rows_to_display__c', 'Full_Report_Link_URL__c',
                                                    'VF_Page_Name__c', 'Name', 'Height__c'}; 
                List<String> userTypes = new String[] {currUser.Profile.Name};
                List<String> titleTypes = new String[] {leaderLevel};
                System.assert(currMarket.Id != null);
                
                //SOQL for this profile and user 
                String query = LandingPageUtils.generateQueryLPComponent(fieldsConfig, userTypes, titleTypes, currMarket.Id);
                System.debug('====================== ComponentController. Query : ' + query);
                List<Landing_Page_Component__c> listComponent = Database.query(query);
                if (listComponent != null) {
                    for (Landing_Page_Component__c comp: listComponent) {
                        System.debug('====================== ComponentController. /apex/' + comp.VF_Page_Name__c + ' VS ' + LandingPageUtils.removeUrlParamsAll(ApexPages.currentPage().getUrl()));
                        if (('/apex/' + comp.VF_Page_Name__c).equalsIgnoreCase(LandingPageUtils.removeUrlParamsAll(ApexPages.currentPage().getUrl()))) {
                            this.componentConfig = comp;
                            break;
                        }
                    }
                }
                
                numberOfRowsToDisplay = ALMConstants.DEFAULT_NUMBER_OF_RECORDS;
                
                if (componentConfig != null) { // get number of rows and report link from configuration
                    System.debug('\n ####### numberOfRowsToDisplay 1 ======= '+numberOfRowsToDisplay+', componentConfig.Number_of_rows_to_display__c '+componentConfig.Number_of_rows_to_display__c);
                    numberOfRowsToDisplay = (componentConfig.Number_of_rows_to_display__c != null ? String.valueOf(componentConfig.Number_of_rows_to_display__c) : ALMConstants.DEFAULT_NUMBER_OF_RECORDS); // how many records to diplay either default contast or configuration setting
                    eachRowHeight = (componentConfig.Height__c != null ? Integer.valueOf(componentConfig.Height__c) : ALMConstants.DEFAULT_HEIGHT_OF_ROWS); // height of each row
                    //reportLinks
                    System.debug('\n ##### isMailPln '+isMailPln+', isPrior '+isPrior);
                    if (!isMailPln && isPrior) { // prior campaign reports
                        System.debug('\n ##### 1 isMailPln '+isMailPln+', isPrior '+isPrior);
                        reportString = reportString + 'campaignId=' + campaignNumber;
                    }else if(isMailPln)
                    {
                       System.debug('\n ##### 2 isMailPln '+isMailPln+', isPrior '+isPrior);
                       reportString = reportString + 'campaignId=' + campaignNumber+'&CNO='+campaignNumber; //Mail Plan Change
                    }
                    
                    if (imperson != null) { //impersonated reports
                        reportString = (reportString.length() > 0 ? reportString + '&' : '') + 'acctKey=' + currUser.ACCT_NR__c;//LandingPageUtils.getMarketAccountKey(marketId, currUser.ACCT_NR__c); 
                    }
                    viewFullReportURL = (String)componentConfig.Full_Report_Link_URL__c ;
                    if (viewFullReportURL != null && viewFullReportURL.length() > 0 && reportString != null && reportString.length() > 0) {
                        viewFullReportURL = viewFullReportURL + (viewFullReportURL.contains('?') ? '&' : '?') + reportString; 
                    }
                    
                    /**** Changes for MT & MTO icon link from dashboard, by Raktim on 30thJul 2013 - START ****/
                    //myTeamReportLink = '/apex/MyTeamReport?pgId=2&tscriteria=AccountNumber' + (reportString.length() > 0 ? '&' + reportString : '');  //used in downline components for each downline
                    //myTeamOrdersReportLink = '/apex/MyTeamOrdersReport?pgId=3&tscriteria=AccountNumber' + (reportString.length() > 0 ? '&' + reportString : '');  //used in downline components for each downline
                    
                    myTeamReportLink = '/apex/MyTeamReport?pgId=2' + (reportString.length() > 0 ? '&' + reportString : '');  //used in downline components for each downline
                    myTeamOrdersReportLink = '/apex/MyTeamOrdersReport?pgId=3' + (reportString.length() > 0 ? '&' + reportString : '');  //used in downline components for each downline
                    
                    /**** Changes for MT & MTO icon link from dashboard, by Raktim on 30thJul 2013 - END ****/
                    
                }
                System.debug('====================== ComponentController. componentConfig: ' + componentConfig);
                System.debug('====================== ComponentController. numberOfRowsToDisplay: ' + numberOfRowsToDisplay);
                System.debug('====================== ComponentController. viewFullReportURL: ' + viewFullReportURL);
                System.debug('====================== ComponentController. myTeamReportLink : ' + myTeamReportLink);
                System.debug('====================== ComponentController. myTeamOrdersReportLink : ' + myTeamOrdersReportLink);
                System.debug('====================== ComponentController . Current User : ' + currUser);
                System.debug('================ Avon Leader has read persmission for Market__c');
            
            } else {
                throw new InconsistentDataException('User Market Id or Account Number is missing. User must have Leader Profile');
            }
            
            
            //determine currency character
            if (currMarket.Market_Currency_Symbol__c != null) {
                currencyCharacter = currMarket.Market_Currency_Symbol__c; 
            } else {
                currencyCharacter = '';
            }
            
            
            //some util classes instances
            leaderUtils = new MarketLeaderTitleUtils();
            lpu = new LandingPageUtils();
            
            //prepare information for pulling custom messages
            fieldsCustomMessage = new String[] {'SL_Title__c', 'Message_Text__c', 'User_Type__c', 'Message_URL__c', 'Message_Name__c', 'Component_Name_Picklist__c'};
            System.assert(profileName != null, 'Profile Name missing');
            System.assert(leaderLevel != null, 'User Title Level Number missing');
            userTypes = new String[] {profileName};
            titleTypes = new String[] {leaderLevel};
            
            //find out leadership information for user
            mapLeaderTitle = leaderUtils.initializeAndRetMapLT(currUser); 
            System.debug('====================== Component Controller . mapLeaderTitle : ' + mapLeaderTitle);
            currLeader = mapLeaderTitle.get(currUser.LDRSHP_TITL_LVL_NBR__c);
            System.debug('====================== Component Controller . Current Leader : ' + currLeader);
            
            pageAllParams = ApexPages.currentPage().getParameters().clone(); //store all parameters and use for impersonation and other
            originalUrl = pageAllParams.get(ALMConstants.IMPERSON_RETURN_PAGE); // MODIFY consider impact of impersonation
            System.debug('=========== Component Controller. Original Url: ' + originalUrl);
            //pageAllParams.remove(ALMConstants.IMPERSON_RETURN_PAGE);
            
            
        } catch (Exception e) {
            // if something wrong, redirect to error page
            // look at <page action=...>
            System.debug(e);            
            exceptionText = e.getMessage();
            isValid = false;
        }
    }
    
    // used to validate impersonation in <apex:page action="{!isValidLandingPage}">
    public PageReference isValidPage() {
        PageReference result = null;
        if (!isValid) { // is false for invalid impersonation
            System.debug('>>>> Limit Check'+Limits.getDmlStatements()); // use errorHandler and ErrorPage
            //String errorId = ErrorHandler.handleError('Inconsistent Data Exception');
            String errorId = ErrorHandler.handleError(exceptionText);
            result = Page.ErrorPage;
            result.getParameters().put('errId',errorId);
        }
        
        return result;
    }
    
    // Added by Swarnava on 25Jun 2013 - Mail Plan
    public String getMailPlanCampaign(List<Sobject> lstSObj) {
        String campaignNumbr = '';
        
        campaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lstSObj[0].get('MailPlan_Order_Oppty__r.CMPGN_NR__c'));
        System.debug('\n #### campaignNumbr ---- >>> '+campaignNumbr);
        
        return campaignNumbr;
    }
    
    
    //custom exceptions
    public class InconsistentDataException extends Exception {
    }
}