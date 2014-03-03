/*
** Apex Class/Controller Name           : LandingPageConfigController 
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Transfers information about Landing Page configurability
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** April 25, 2012.  Created
** 
*/

public without sharing class LandingPageConfigController { 
    public List<Landing_Page_Component__c> listComponent{get;set;}
    public String qr {get;set;}
    public String searchText {get;set;}
    public Boolean isImpersonation {get; set;}
    public String username {get; set;}
    public String queryParam {get; set;} //for impersonation and other
    public String marketId {get; set;}
    public String profileId {get; set;}
    public boolean emailAllowed {get; set;}
    public String campaignNumber {get; set;}
    
    //for campaign switching logic
    public String Campaign {get;set;}
    public String priorCampaign {get;set;}
    public String currentcampaign {get;set;}
    public User currUser {get;set;}        //changed for omniture
    public Market__c currMarket{get;set;}  //changed for omniture
    public User loggedUser{get;set;} //added for omniture
    public ALM_Global_Settings__c globalConfig {get; set;}
    public String userstatus{get;set;}
    
    private LandingPageUtils lpu;
   // private String campaignNumber;
    private Leader_Title__c currLeader;
    private MarketLeaderTitleUtils ltu;
    private Map<String, Leader_Title__c> mapLeaderTitle = new Map<String, Leader_Title__c>();
    private Boolean isPrior;
    private Boolean isValid;
    
    // Added by Raktim on 21Jun 2013 - Mail Plan
    private Boolean isNext;
    public MailPlan_Order_Oppty__c mailPlan {get; private set;}
    public Boolean isMailPln {get; set;}
    public Boolean isCurrCampMyDefault  {get; set;}
    public Boolean isSellingCampMyDefault  {get; set;}
    public String mailPlanCampaignNumbr {get; set;}
    public Boolean isLandingPage_MailPln {get; set;}
    public boolean isTL {get; set;}  //Added by swarnava:TL
    
    
    //private Profile currProfile;
    private Map<String, String> queryParams;
    public String repDetailAcctNbr {get; set;}
    
    public LandingPageConfigController() {
        isValid = true; // by default everything is valid
        isMailPln = false; // by default this is false - Added by Raktim on 21Jun 2013 Mail Plan
        isCurrCampMyDefault = false; // by default this is false - Added by Raktim on 24Jun 2013 Mail Plan
        isSellingCampMyDefault = false; // by default this is false - Added by Raktim on 24Jun 2013 Mail Plan
        isLandingPage_MailPln = false; // by default this is false - Added by Raktim on 24Jun 2013 Mail Plan
        
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
        emailAllowed = false; // by default email NOT allowed
        queryParams = ApexPages.currentPage().getParameters();
        queryParam = ''; // DON'T REMOVE THIS!!!
        System.debug('============ LandingPageConfigController. query parameters : ' + queryParams);
        isImpersonation = false; // by default impersonation is OFF 
        username = '';
        queryParams.put(ALMConstants.IMPERSON_RETURN_PAGE, LandingPageUtils.removeUrlParamsAll(ApexPages.currentPage().getUrl())); // by default it contains real name of landing page
        isPrior = LandingPageUtils.isPreviousCampaign(ApexPages.currentPage().getParameters().get(ALMConstants.CAMPAIGN));
        System.debug('============ LandingPageConfigController. isPrior : ' + isPrior);
        
        // Added by Raktim on 21Jun 2013 - Mail Plan
        isNext = LandingPageUtils.isNextCampaign(ApexPages.currentPage().getParameters().get(ALMConstants.CAMPAIGN));
        System.debug('============ LandingPageConfigController. isNext : ' + isNext);
        
        
        String imperson = ApexPages.currentPage().getParameters().get(ALMConstants.IMPERSON_PARAM_NAME);
        System.debug('===================== LandingPageConfig Controller. Impersonation : ' + imperson);
        
        //fist get infr of logged in user
        currUser = [SELECT Id, Profile.Id, Profile.Name, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1]; 
        System.debug('===================== LandingPageConfig Controller. User: ' + currUser + ' User Division: ' + currUser.DFALT_DIV_NM__c + ' User MarketAcctKey: ' + currUser.MRKT_ID_ACCT_NR_KEY__c);
        loggedUser=currUser;
        this.marketId = currUser.MRKT_ID__c;
        
        // Added by Swarnava for TL:Start
        String temp_acc_no;
        if(ApexPages.CurrentPage().getParameters().get('acctkey')!=null)
        temp_acc_no=this.marketId+ApexPages.CurrentPage().getParameters().get('acctkey');
        else
        temp_acc_no=currUser.MRKT_ID_ACCT_NR_KEY__c;
        Contact currUsrContact = [SELECT  Name,LDR_TYP__c, MLPLN_CD__c, SLS_ZONE_CD__c FROM Contact WHERE MRKT_ACCT_KEY__c =:temp_acc_no];
        isTL = (currUsrContact.LDR_TYP__c=='TL'?true:false);
        // Added by Swarnava for TL:End
        
        //current market of the user
        if (currUser.MRKT_ID__c != null) {
            this.marketId = currUser.MRKT_ID__c;
            this.profileId = currUser.Profile.Id;
                                
            currMarket = [SELECT CMPGN_NR__c, Market_Currency_Symbol__c, Id, Allow_Freeform_Email__c , Omniture_Suite_Name__c, PREV_1_CMPGN_NR__c, 
                                 NEXT_1_CMPGN_NR__c, Mail_Plan_Enabled__c, CURRNT_CMPGN_RMN_DAY_CNT__c, MailPlan_LndingPg_Deflt__c, ALM_Rep_Indicator__c
                                 FROM Market__c 
                                 WHERE Market_Id__c = :currUser.MRKT_ID__c LIMIT 1];
                                
            //campaignNumber = (isPrior ? currMarket.PREV_1_CMPGN_NR__c : currMarket.CMPGN_NR__c);
            // Added by Raktim on 21Jun 2013 - Mail Plan
            isLandingPage_MailPln = currMarket.MailPlan_LndingPg_Deflt__c;
            if(currMarket.Mail_Plan_Enabled__c){
                isMailPln = true;
                String combinedObjName = currMarket.ALM_Rep_Indicator__c; //replace('__c', '__r')
               // MailPlanUtils mailPlanUtils = new MailPlanUtils(currMarket);
               // mailPlanUtils.repDetail = currUsrContact;   
                
                //mailPlan = mailPlanUtils.getMailPlan(this.currUser);
                String acct_no_mp=ApexPages.CurrentPage().getParameters().get('acctkey');
                acct_no_mp=(acct_no_mp==null?currUser.ACCT_NR__c:acct_no_mp);  //impersonation logic changed by swarnava
                try
                {
                    List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(combinedObjName, acct_no_mp, currUser.MRKT_ID__c);
                    System.debug('===================== LandingPageConfig Controller. lst_CombinedObj \n ' + lst_CombinedObj);
                    //mailPlanCampaignNumbr = YOUUtil.getCampaignNumbrMailPlan(mailPlan.CMPGN_NR__c);
                
                    mailPlanCampaignNumbr = getMailPlanCampaign(lst_CombinedObj);                              
                    System.debug('===================== LandingPageConfig1 Controller. mailPlanCampaignNumbr -->> ' + mailPlanCampaignNumbr);
                    
                }catch(Exception e){
                    System.debug('\n Caught Exception in LandingPageConfig for Mail Plan '+e.getMessage());
                    mailPlanCampaignNumbr = currMarket.CMPGN_NR__c;
                }
                
                if(mailPlanCampaignNumbr != null && !mailPlanCampaignNumbr.trim().equals(''))
                {
                    campaignNumber = mailPlanCampaignNumbr;
                    /*if(campaignNumber == currMarket.CMPGN_NR__c){
                        isCurrCampMyDefault = true;
                    }else if(campaignNumber == currMarket.NEXT_1_CMPGN_NR__c){
                        isSellingCampMyDefault = true;  
                    }*/
                    if(isLandingPage_MailPln){
                        isSellingCampMyDefault = true;  
                    }else{
                        isCurrCampMyDefault = true;
                    }
                    
               }else{
                    //isCurrCampMyDefault = true;
                    if(isLandingPage_MailPln){
                        isSellingCampMyDefault = true;  
                    }
                    campaignNumber = currMarket.CMPGN_NR__c;
               }
                
            }
            
            if(isPrior){
                campaignNumber = currMarket.PREV_1_CMPGN_NR__c;
                isCurrCampMyDefault     = false;
                isSellingCampMyDefault  = false;
                
            }else if(isNext){  //campainNumber logic changed by swarnava as suggested by milon
                campaignNumber = currMarket.NEXT_1_CMPGN_NR__c;
                isCurrCampMyDefault     = false;
                isSellingCampMyDefault  = false;
                
            }else{
                if(!currMarket.Mail_Plan_Enabled__c)
                    isCurrCampMyDefault = true;                             
                
                /*
                campaignNumber = (currMarket.Mail_Plan_Enabled__c ? 
                                   (mailPlanCampaignNumbr != null && !Apexpages.currentPage().getURL().contains(ALMConstants.CURRENT_CAMPAIGN) ? 
                                        mailPlanCampaignNumbr : currMarket.CMPGN_NR__c) : currMarket.CMPGN_NR__c);
                */
                campaignNumber = (currMarket.Mail_Plan_Enabled__c ? 
                                   (mailPlanCampaignNumbr != null && ApexPages.currentPage().getParameters().get('campaign')!='current' && isSellingCampMyDefault ? 
                                        mailPlanCampaignNumbr : currMarket.CMPGN_NR__c) : currMarket.CMPGN_NR__c);
                
                
            }
            Apexpages.currentPage().getParameters().put('mpCampaign', campaignNumber);
            System.debug('============ LandingPageConfigController. campaignNumber : ' + campaignNumber);
            System.debug('============ LandingPageConfigController.isCurrCampMyDefault : ' + isCurrCampMyDefault);
            System.debug('============ LandingPageConfigController. isSellingCampMyDefault : ' + isSellingCampMyDefault);
          
            
            
        } else {
            System.debug('====================== EXCEPTION. LandingPageConfigController. Market Id is required for User.');
            throw new InconsistentDataException();
        }
        
        //for impersonation user another user information using user key
        //if (imperson != null && imperson.length() > 0) {
        if (imperson != null && imperson.length() > 0) { 
            //if (LandingPageUtils.isImpersonationValid(currUser.MRKT_ID__c, currUser.ACCT_NR__c, campaignNumber, imperson)) {
            if (LandingPageUtils.isImpersonationValid(currUser.Profile.Name, currUser.MRKT_ID__c, currUser.DFALT_ZONE_CD__c, currUser.DFALT_DIV_NM__c, currUser.ACCT_NR__c, campaignNumber, imperson)) {
                isImpersonation = true; 
                currUser = [SELECT Id, Profile.Id, Profile.Name,  MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c  FROM User WHERE MRKT_ID_ACCT_NR_KEY__c = :(currUser.MRKT_ID__c + imperson) LIMIT 1]; 
                queryParams.put(ALMConstants.IMPERSON_PARAM_NAME, imperson);
            } else {
                
                // invalid impersonation attempt
                isValid = false; // invalidate the page and stop loading
                //throw new InconsistentDataException();
                //impersonation error handling
            }
        } else if (currMarket.Allow_Freeform_Email__c != null || currMarket.Allow_Freeform_Email__c != '') {
                queryParams.remove(ALMConstants.IMPERSON_PARAM_NAME);
                emailAllowed = LandingPageUtils.isEmailAllowedForProfile(currUser.Profile.Name, currMarket.Allow_Freeform_Email__c);
        }
        
        if (isValid) { // only if non-impersonated or valid impersonation
            System.debug('====================== LandingPage. is emailing allowed : ' + emailAllowed);
            username = currUser.Name; // used for impersonation
            queryParam =  LandingPageUtils.makeUrlParams(queryParams, '?'); 
            System.debug('===================== LandingPageConfig Controller. queryParam: ' + queryParam);
            System.debug('===================== LandingPageConfig Controller. impersonation : ' + isImpersonation + '   username : ' + username);
            
            System.debug('====================== LandingPageConfigController. CALLED.');
            String query = null;
            currentcampaign = 'selected';
            
            //utility classes 
            lpu = new LandingPageUtils();
            ltu = lpu.getLeaderTitleUtil();
            
            
            //leader titles for badge title of the user 
            mapLeaderTitle = ltu.initializeAndRetMapLT(currUser); 
            LandingPageUtils.debugMap(mapLeaderTitle, 'Leader_Title__c');
            
            System.assert(currUser.Profile.Name != null, 'Profile Name is missing');
            System.assert(currUser.LDRSHP_TITL_LVL_NBR__c != null,'User Title is missing');
            
            List<String> fields = new String[] {'Component_Header_Color__c', 'Display_Row__c', 'Horizontal_Position__c', 'Landing_Page_Config__c', 'Number_of_rows_to_display__c',
                                                'VF_Page_Name__c', 'Name', 'Is_Full_Report_Link_Available__c','Full_Report_Link_URL__c', 'component_title__c','Is_summary_overlay_display__c'};
            //List<String> userTypes = new String[] {currUser.Profile.Name};
            List<String> userTypes;                               //for Transition Leaders change by swarnava:Start     
            if(!isTL)                                    
            userTypes = new String[] {currUser.Profile.Name};
            else
            userTypes = new String[] {'Avon Transition Leader'};  //for Transition Leaders change by swarnava:End
            List<String> titleTypes = new String[] {currUser.LDRSHP_TITL_LVL_NBR__c};
             
            System.assert(currMarket.Id != null);
            /*System.debug('\n ======= userTypes ====== \n'+userTypes);
            System.debug('\n ======= titleTypes ====== \n'+titleTypes);
            System.debug('\n ======= currMarket.Id '+currMarket.Id);*/
            
            //SOQL for this profile and user 
            query = LandingPageUtils.generateQueryLPComponent(fields, userTypes, titleTypes, currMarket.Id);
            qr = query;
            System.debug('====================== LandingPageConfigController. Query : ' + query);
            listComponent = Database.query(query);
            
            LandingPageUtils.debugList(listComponent, 'Landing_Page_Component__c');
        }
    }
    
    public Pagereference priorCampaign() {
        PageReference pageRef = ApexPages.currentPage();
        pageref.getParameters().put('campaign','prior');

        priorCampaign = 'selected';
        currentcampaign = '';
        return pageRef;
    }
    
    public Pagereference currentCampaign() {
        PageReference pageRef = ApexPages.currentPage();
        pageref.getParameters().put('campaign','current');
        
        priorCampaign = '';
        currentcampaign = 'selected';
        return pageRef;
    }
    
    // Added by Raktim on 21Jun 2013 - Mail Plan
    public Pagereference nextCampaign() {
        PageReference pageRef = ApexPages.currentPage();
        pageref.getParameters().put('campaign','next');
        
        priorCampaign = '';
        currentcampaign = 'selected';
        return pageRef;
    }
    
    // Added by Swarnava on 25Jun 2013 - Mail Plan
    public String getMailPlanCampaign(List<Sobject> lstSObj) {
        String campaignNumbr = '';
        
        campaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lstSObj[0].getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
        System.debug('\n #### campaignNumbr ---- >>> '+campaignNumbr);
        
        return campaignNumbr;
    }
    
    // used to validate impersonation in <apex:page action="{!isValidLandingPage}">
    public PageReference isValidLandingPage() {
        PageReference result = null;
        if (!isValid) { // is false for invalid impersonation
            System.debug('>>>> Limit Check'+Limits.getDmlStatements()); // use errorHandler and ErrorPage
            String errorId = ErrorHandler.handleError('This downline cannot be accessed.');
            result = Page.ErrorPage;
            result.getParameters().put('errId',errorId);
        }
        
        return result;
    }
      //added by Snehashis
    public PageReference callRepDetails() {
        //Line below added by prakash on 09/24 to debug impersonation issue.
        System.debug('=====in callRepDetails====='); 
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        System.debug('=====repDetailAcctNbr value =====' + repDetailAcctNbr);
        return null;
    }
    
    // ADDED BY Vijay Mittal FOR SEARCH COMPONENT POPUP WINODOW
    public Pagereference saveSearchText() {
        searchText = Apexpages.currentPage().getParameters().get(ALMConstants.SEARCH_URL_PARAM);
        return null;
    }
    // CHNAGES BY Vijay Mittal ENDS HERE
    
    public String getOmniturePageName() {
        return ALMPlusUtils.generateOmniturePageName((isImpersonation)?'ImpersonatedSLDashBoard':'SLDashBoard', null, loggedUser.Profile.Name);
    }
    
    public string getBatchTimeStamp(){
        return NRT_Utils.getLastUpdatedTimeStampBatch(marketId);
    }
   
    class InconsistentDataException extends Exception {
    }
}