/* 
Date            Who             Line#               Modification
============================================================================================
03-19-2012  Snehashis Ghosh                     Created.
04-27-2012  Milon Dey                           Test Case added
06-18-2012  Milon Dey                           Added Test case for Report Links
*/
public class SiteHeaderController {
    public User currUsr {get; set;}
    public Contact currUsrContact {get; set;}
    public String ldrTitle {get; private set;}
    public String sellerStatus {get; private set;}
    public String mktTagLabel {get; private set;}
    public Market__c market {get; private set;}
    public String userProfile {get; private set;}
    public MailPlan_Order_Oppty__c mailPlan {get; private set;}
    public Sales_Organization__c usrSlsOrg {get; private set;}
    public ALM_Global_Settings__c globalConfig {get; private set;}
    public Boolean showEarningOppty {get; private set;}
    public Boolean showZoneDivEarnOppty {get; private set;}
    public Boolean showHeader {get; private set;}
    public Boolean showSidebar {get; private set;}
    public String strTrendSetter{get; private set;}
    public static Integer strsize{get;set;}
    public String errorMessageLabel {get; private set;}
    public String userstatus {get; private set;}
    // Added by Raktim on 18th Jun 2013 - MailPlan
    public Boolean isPrior_MailPln {get; set;}
    public String nxtMailPlnClose{get; set;}
    
    public String strConvertedDate {get; set;}
    
    public String strNrtdDate{get;set;}
    
    public String cmpgn {get;private set;}
    
    public Boolean isNRTEnabled {get; set;}	//variabled added for NRT

    public String cmpgnOverlay {get; set;} // variable added by Raktim - 4thSep 2013
    
    public String userLang {get;set;} // variable added by Raktim - 07th Oct 2013 For Impersonation Issue Fix
    
    //Eoc
    
    // Added by Raktim
    public SiteHeaderController()
    {
        this.showEarningOppty=false;
        this.isPrior_MailPln = false;
        this.showZoneDivEarnOppty=false;
        
        try
        {
            this.currUsr = [Select  Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                    LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,TRNDSTTR_IND__c,ACCT_NR__c,
                                    DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name,Is_Eligible__c,Opt_In__c,Out_of_Office__c,
                                    LDRSHP_TITL_LVL_NBR__c
                            From User
                            where Id = :UserInfo.getUserId()];
                            
             this.market = [     Select      Id,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, Name,LastModifiedDate, 
                                            Market_Id__c, Mail_Plan_Enabled__c, CURRNT_CMPGN_RMN_DAY_CNT__c, 
                                            CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_END_DT__c,ALM_Rep_Indicator__c,
                                            LAST_UPDT_DT__c,GI3_Keep_Alive_URL__c,CURRENT_CAMPAIGN_NR__c,NEXT_1_CMPGN_NR__c,
                                            Site_Maintenance_Enabled__c,Omniture_Suite_Name__c,Conditions_Of_Use_URL__c,
                                            Security_and_Privacy_URL__c,eCard_Status_Message_Header__c,MailPlan_LndingPg_Deflt__c,
                                            Campaign_Report_Override_URL__c,Is_ALMPLUS_Enabled__c,ALMPlus_Calendar__c,
                                            Omniture_RSID__c,CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c,CURRNT_CMPGN_ONLN_RMN_DAY_CNT__c, NRT_Enabled__c
                                    From    Market__c   
                                    where   Market_Id__c =:currUsr.MRKT_ID__c];
             
           //changed by swarnava:Start TL
           String acctno=this.currUsr.ACCT_NR__c;
           String mrktId=this.currUsr.MRKT_ID__c;
           
           userLang = this.currUsr.LanguageLocaleKey; // Added by Raktim - 07th Oct 2013 For Impersonation Issue Fix
           
            //String camp_no=String.valueOf(this.market.CMPGN_NR__c);
            Double camp_no = Double.valueOf(String.valueOf(this.market.CMPGN_NR__c));
           // Apexpages.currentPage().getParameters().put('IsBranchEnable', String.valueOf(this.market.Is_Branche__c));
           // String strcombobj='Select Id,TITL_STUS__c FROM  '+this.market.ALM_Rep_Indicator__c+' WHERE  ACCT_NR__c =:acctno AND MRKT_ID__c =:mrktId AND OPERTNL_CMPGN_NR__c =:camp_no LIMIT 1';
            String strcombobj='Select Id,TITL_STUS__c FROM  '+this.market.ALM_Rep_Indicator__c+' WHERE  ACCT_NR__c =:acctno AND MRKT_ID__c =:mrktId AND FLD_SLS_CMPGN_NR__c =:camp_no LIMIT 1';
            //System.debug('querystringlandingpage---->'+strcombobj);
            try
            {
                if(this.currUsr.Profile.Name == ALMConstants.LEADER_PROFL_NAME)
                    userstatus=(String)Database.query(strcombobj)[0].get('TITL_STUS__c');
                System.debug('usertstatus---->'+userstatus+'--'+camp_no+'--'+acctno);                
            }catch(Exception e)
            {
                System.debug('Could not find ALM REP Performance Data');
            }
            ////changed by swarnava:eND TL  
         	
            strConvertedDate =  market.LAST_UPDT_DT__c.format();//.format(ALMConstants.UPDATE_DATE_FRMT);    //market.LAST_UPDT_DT__c; -- Commented by Snehashis
            strNrtdDate = NRT_Utils.getLastUpdatedTimeStamp(market.Market_Id__c);
           //change added for NRT
           isNRTEnabled = market.NRT_Enabled__c;
           //NRT change end
                           
           if(market.Mail_Plan_Enabled__c)       
           {
                    String acct_no_mp=ApexPages.CurrentPage().getParameters().get('acctkey');
                    acct_no_mp=(acct_no_mp==null?currUsr.ACCT_NR__c:acct_no_mp);  //impersonation logic changed by swarnava
                    try
                    {
                        List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(market.ALM_Rep_Indicator__c, acct_no_mp, market.Market_Id__c);
                        
                        // Setting Campaign Value - added by Raktim - 4thSep 2013 - START
                        cmpgnOverlay = getMailPlanCampaign(lst_CombinedObj);
                        // End 
                    
                        if(ApexPages.CurrentPage().getParameters().get('campaign')=='current' || ApexPages.CurrentPage().getParameters().get('campaignId')==market.CMPGN_NR__c){
                        	cmpgn = market.CMPGN_NR__c;
                        }else if(ApexPages.CurrentPage().getParameters().get('campaign')=='prior' || ApexPages.CurrentPage().getParameters().get('campaignId')==market.PREV_1_CMPGN_NR__c){
                        	cmpgn = market.PREV_1_CMPGN_NR__c;
                        }else if(ApexPages.CurrentPage().getParameters().get('campaign')=='next' || ApexPages.CurrentPage().getParameters().get('campaignId')==market.NEXT_1_CMPGN_NR__c){
                        	cmpgn = market.NEXT_1_CMPGN_NR__c;
                        }else {
                        	cmpgn = getMailPlanCampaign(lst_CombinedObj);
                        }
                        
                        /*cmpgn = ApexPages.CurrentPage().getParameters().get('campaign')=='current'?market.CMPGN_NR__c:getMailPlanCampaign(lst_CombinedObj); 
                    	System.debug('is current --> '+ApexPages.CurrentPage().getParameters().get('campaign')=='current');
                    	System.debug('cmpgn --> '+cmpgn);*/
                    	
                    	//Below Line comment by Milon on 8/29
                       //nxtMailPlnClose = ((String)lst_CombinedObj[0].getsObject('MailPlan_Order_Oppty__r').get('NEXT_MLPLN_TO_CLOS_CD__c'));
                        MailPlanUtils mailPlanUtil = new MailPlanUtils(this.market);
                        nxtMailPlnClose = mailPlanUtil.getNextMailPlansToClose();
                        
                        if(nxtMailPlnClose != null && !nxtMailPlnClose.trim().equals('')){
                            nxtMailPlnClose = nxtMailPlnClose;
                        }else{
                            nxtMailPlnClose = '';
                        }
                        
                    }catch(Exception e){
                        System.debug('\n Caught Exception in SiteHeader for Mail Plan '+e.getMessage());
                        cmpgn = market.CMPGN_NR__c;
                        cmpgnOverlay = market.CMPGN_NR__c;  //added by Raktim - 4thSep 2013
                        nxtMailPlnClose = '';
                    }
                    
            }else{
                cmpgn = market.CMPGN_NR__c;
                cmpgnOverlay = market.CMPGN_NR__c;  //added by Raktim - 4thSep 2013
            }
            
            Apexpages.currentPage().getParameters().put('mpCampaign', cmpgn); 
            Apexpages.currentPage().getParameters().put('mpsellingdefaultlanding', (this.market.MailPlan_LndingPg_Deflt__c?'Y':'N'));
            Apexpages.currentPage().getParameters().put('operatnCampaign', this.market.CMPGN_NR__c); 
            Apexpages.currentPage().getParameters().put('userLangCD', userLang); // Added by Raktim - 07th Oct 2013 For Impersonation 
            															         // Issue Fix
            Apexpages.currentPage().getParameters().put('operatnCampaign', this.market.CMPGN_NR__c);
            System.debug('SiteHeaderController mpCampaign --> '+cmpgn+', cmpgnOverlay --> '+cmpgnOverlay);             
            
         }catch(Exception e){
            System.debug('\n #Exception Caught --> '+e.getMessage());
            System.debug('\n #Exception Line Number --> '+e.getLineNumber());
        }
         
    } // EOC
    
    public PageReference init()
    {
        System.debug('Page-->'+ Apexpages.currentPage().getUrl());
        this.globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        this.userProfile = currUsr.Profile.Name;
        
        // Added by FS on 1/23/2013 to support Zone Manager impersonation
        this.showHeader = (this.userProfile == 'Avon Leader');
        this.showSidebar = this.showHeader;
        errorMessageLabel = ApexPages.CurrentPage().getParameters().get('msg');
        if (errorMessageLabel == null) {
            errorMessageLabel = 'Err_Msg_Default';
        }
    
        if(this.currUsr.TRNDSTTR_IND__c != null) {
            this.strTrendSetter = this.currUsr.TRNDSTTR_IND__c;
        } else {
            this.strTrendSetter = '';
        }
        
        try{
            List<String> mktTagSubjAreas = new List<String>();
            mktTagSubjAreas.add('User');
            MarketTagUtils mktTags = new MarketTagUtils();
            mktTags.initialize(mktTagSubjAreas,currUsr.LanguageLocaleKey);
            this.mktTagLabel = mktTags.getLabel('User','Market Tag 1');
            
            if(market.Site_Maintenance_Enabled__c){
                //@TODO: Adjust maintainence page coding
                Pagereference pageRef = Page.ShowMarketdocument;
                pageRef.getParameters().put('type','Site Maintenance');
                pageRef.setRedirect(false);
                return pageRef;
            }else{
                if(this.userProfile=='Avon Leader'){
                    MarketLeaderTitleUtils ldrTitlUtils = new MarketLeaderTitleUtils();
                    ldrTitlUtils.initialize(currUsr,currUsr.LDRSHP_TITL_LVL_NBR__c);
                    this.ldrTitle = ldrTitlUtils.getLeaderTitle(currUsr.LDRSHP_TITL_LVL_NBR__c);
                    MarketSellerStsUtils sellStsUtils = new MarketSellerStsUtils();
                    if (market.Mail_Plan_Enabled__c){
                        // Added by Raktim on 18th Jun 2013 - MailPlan
                        if(Apexpages.currentPage().getUrl().contains(ALMConstants.PRIOR_CAMPAIGN)){
                            this.isPrior_MailPln = true;
                        }
                        //Eoc                    
                    }
            }
            List<Sales_Organization__c> tempSlsOrg = [  Select  SLS_REGN_NM__c,
                                                                SLS_DIV_CD__c
                                                        From    Sales_Organization__c 
                                                        where   SLS_DIV_CD__c=:this.currUsr.DFALT_DIV_NM__c
                                                        and     SLS_ORG_LVL_CD__c='D' and Market__c=:this.market.Id];
                
            if(tempSlsOrg.size()>0){
                this.usrSlsOrg = tempSlsOrg[0]; 
            }
            
          /**
            * Added by SA 5/27/2012
            * Handle language code for My Team-based reports
            */
            
           ApexPages.currentPage().getParameters().put('langcd', MTRConfigUtility.GetMTRLanguageCode(false));
           
          /**
            * Added by SA 7/13/2012
            * Handle invalid accounts for My Team-based reports
            */
            
          Boolean accountExists = MTRConfigUtility.MTRUserAccountExists(false);
           
          if(!accountExists) {
                    
           Pagereference errorRef  =   ErrorHandler.handleError(new InvalidOperationException('The account you are trying to access for T-List viewing or Impersonation does not exist.'));
                    
           return errorRef;
          }
               
        }
        }catch(exception ex){
    //  @TODO: handle error 
        //  return ErrorHandler.handleError(ex); 
        }
        return null;            
    }
    
    //get all report links
    public List<Report_Config__c> getReportLinks(){
        return getReportLinksInternal(this.market.Market_Id__c, currUsr.Profile.Name, currUsr.LDRSHP_TITL_LVL_NBR__c, false);
        
    }
    
    /**
    * Added by SA 5/17/2012
    * Returns Report_Config__c records based on the passed mkt id, and user profile name
    */
    public List<Report_Config__c> getReportLinks(String mktId, String userProfileName, String userTitleNbr, Boolean isImpersonation){
       return getReportLinksInternal(mktId, userProfileName, userTitleNbr, isImpersonation);
    }
    
    /**
    * Modified by SA 6/4/2012 - internally used method to fetch report config records
    */
    private List<Report_Config__c> getReportLinksInternal(String mktId, String userProfileName, String userTitleNbr, Boolean isImpersonation){
        try {
            String query = 'Select r.TITL_LVL_NBR__c, r.Report_URL__c, r.Report_Type__c, r.Report_Id__c, r.Name, r.Report_Sequence__c,' + 
                           ' r.Market__r.Market_Id__c, r.Market__c, r.Id, r.Applicable_to__c From Report_Config__c r ';
                           
            String whereClause = ' where r.Market__r.Market_Id__c =: mktId ';
            if(isImpersonation)
                whereClause += ' AND Is_Impersonation_Applicable__c = true ';
            whereClause += ' order by r.Report_Sequence__c asc';
            query += whereClause;
            List<Report_Config__c> allReportConfig = (List<Report_Config__c>) Database.query(query);
            /*List<Report_Config__c> allReportConfig = [Select r.TITL_LVL_NBR__c, r.Report_URL__c, r.Report_Type__c, r.Report_Id__c, r.Name, r.Report_Sequence__c, 
                                                    r.Market__r.Market_Id__c, r.Market__c, r.Id, r.Applicable_to__c From Report_Config__c r
                                                    where r.Market__r.Market_Id__c =: mktId order by r.Report_Sequence__c asc];
                                                    
            */                                        
            List<Report_Config__c> myReports = new List<Report_Config__c>();
            if(allReportConfig.size()>0){   
                for(Report_Config__c rc: allReportConfig){
                    set<String> reportProfiles = new set<String>();
                    if(rc.Applicable_to__c <> null)
                  {
                      reportProfiles.addAll(rc.Applicable_to__c.split(';'));
                      if(reportProfiles.contains(userProfileName)){
                          set<String> titleNos = new set<String>();
                          titleNos.addAll(rc.TITL_LVL_NBR__c.split(';'));
                          if(titleNos.contains(userTitleNbr)){
                              myReports.add(rc);
                          }
                      }
                  }
                }
        }                                                  
        return myReports;
        }
        catch(Exception e){
            return null;
        }
    }
    
    
    public PageReference showEarningOpportunity(){
        this.showEarningOppty=true;
        return null;
    }
    
    public SiteHeaderController getControllerRef(){
        return this;
    }
    
    public String getMailPlanCampaign(List<Sobject> lstSObj) {
        String campaignNumbr = '';
        
        if (!lstSObj.isEmpty()) {
            campaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lstSObj[0].getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
        }
        System.debug('\n #### campaignNumbr ---- >>> '+campaignNumbr);
        
        return campaignNumbr;
    }
    
}