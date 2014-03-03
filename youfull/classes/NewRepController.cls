/**
 * This class will be used to dynamically read the Genealogy Object associated
 * with Current User Market and create the NewRepReport.
 * @name NewRepController.cls
 * @author Cognizant
 * @date June 5th, 2013
 *
 */
public class  NewRepController
{   
    private Integer nCurrentPageNbr; 
    public List<String> tableHeader {get; private set;}
    public List<String> topRow {get; private set;}
    public List<Report_Config__c> lst_ReportLinks{get;set;} //For Report Link
    public Map<String,String> m_ImpersonateLeaders = new Map<String,String>();
    //Filtering Start
    public List<SelectOption> loaFList {get;set;}
    public List<SelectOption> campFList {get;set;}
    public String loaFselect {get;set;}
    public String loaFselect1 {get;set;}
    public String campFselect {get;set;}
    public String campFselect1 {get;set;}
    Map<String, String> mapLOAValues;
    String loaFiltrVal; //used locally for Download
    //Filtering END
    public String currUserLanguage {get;set;}
    public String s_CurrencySymbol{get;set;} //Used to show currency in report
    public String s_Impersonated_UserName{get;set;}
    public String s_Impersonated_Profile{get;set;}
    public String s_Impersonated_LDRTitlLvl{get;set;}
    public Boolean s_IsImpersonated{get;set;}
    protected Map<String, String> mktTagsMap;
    //Used for Pagination
    //public Integer TOTAL_RECORDS {get; set;}
    public Integer PAGE_SIZE;
    public List<List<String>> curOthRow {get; private set;}
    public List<boolean> lstTitleLevel {get; set;}
    //used for pagination end

    //Public variable for download report
    public List<List<List<String>>> listReportData {get;set;}
    public String strReportName {get;set;}
    public Boolean browserType {get;set;}
    public Integer nColspan {get; private set;}
    public String strBodyReportName {get; private set;}
    public Integer DOWNLOAD_LIMIT{get;set;}
    public String isAll {get; set;}
    public Boolean isDownlnWarning {get;set;}
    public Integer i_AccountNumberPos {get;set;}
    public Integer i_LeaderTitlePos{get;set;}
    public Map<String,Leader_Title__c> m_LeaderTitles = new Map<String,Leader_Title__c>();
    public String almRepIndicator {get; set;}
    //End of public variable for download report

    //Some CSS issues
    public Integer showTableBorderWidth {get;set;}//basically its tableHeaderWidth + 102;
    public Integer tableHeaderWidth {get;set;} //Total Always Display Width - 2 
    public Integer ADWidth {get;set;}
    
    //Added by Samudra
    public String ReportHeight {get; set;}
    public String ReportWidth {get; set;}
    public String NoOfColumns {get; set;}
    //Added by Samudra
    
    List<String> topRowCol;
    List<String> otherRowCol;
    public String userAccNr {get;set;}
    public String userProflName {get; set;} 
    public String userTitleLvlNumbr {get; set;} 
    public String usermrktacct {get; set;}
    public string omnture_suit {get; set;}
    public String mrktId {get;set;} //Used by EmailUtil
    public List<String> acctNbrList{get;set;}//Used to EmailUtil
    public String reportId {get;set;}
    Report_Config__c reportConfig;
    List<Leader_Title__c> Leader_Title;
    public String campagnNr {get; set;}
    String defaultqueryField;
    Map<String, String> colHeader;
    Map<String, String> colHeaderShort;
    List<String> topRowDataPos;
    List<String> otherRowDataPos;
    Map<String,List<String>> campInfo;
    Map<String,Decimal> campInfoSum;
    List<Integer> campList;
    String orderByClause;
    List<String> dummyList;
    Integer nbrOfCmp = 5;//Make it constant
    String lastColumPaginated;
    Boolean IsDev3 = false;
    Boolean IsCampNbr = true;
    Boolean IsTotCampNbr = true;
    public ALM_Global_Settings__c globalConfig {get; set;}
    public String currUserLocale{get;set;}
    public String emailForIndc {get; set;} // Used for Email Sending
    public String repDetailAcctNbr {get; set;} // Used for Coaching Page Invocation
    public List<boolean> lstEmailIndc {get; set;} // Used for Email Link generation

    public List<String> invisibleList {get; set;} // Used for invisible
    public String invisibleStr {get; set;}
    Integer noOfPiVar;
    public Integer numpages{get;set;}
    public PageReference errPage {get; set;}
    public Boolean isMailPlan {get; set;} // Added by raktim on 25Jun 2013 - Mail Plan
    public String emailAllUrl {get; set;}
    public Decimal leaderGenLevel;
    public Decimal leaderLeftId{get;set;}
    public Decimal leaderRightId{get;set;}
    public String leaderTreeAccNo{get;set;}
    public String downlineGenLevel{get;set;}
    
    
    
    public Market__c market{get;set;}

    public Class DataDetail{
        public String Data{get;set;}
        public String DataLong{get;set;}
        public String type{get;set;}
        public String vartype{get;set;}
        public String width{get;set;}
        public Integer Id{get;set;}
        public String shID{get;set;}
        public Integer sortOrder {get; set;} //0 for Asc 1 for Desc
        public String align{get;set;}
        public boolean isCurrency{get;set;}
        public boolean isHoverEnabled{get;set;}  //changed swarnava - defect id : 2352
        public String Col_Color{get;set;} //changed swarnava for New Rep Mockup
        public String Field_Api{get;set;}
        public boolean isflname{get;set;}
        public String flLabel{get;set;}
        public Integer flsortOrder{get;set;}
    }
    
    private Integer flsortOrder = 0;
    public List<DataDetail>  dataD {get;set;}

    // For Test Coverage
    public boolean isTest {get; set;}
    
    Boolean isDeleted = false;
    
    // For Mail Plan
    public String  mailPlnCampgn {get; set;}
    
    
    // For Comma Separation - added by Raktim on 6th Sept 2013
    public String  commaSeprtr {get; set;}    
    
    // For Decimal Separation - added by Raktim on 6th Sept 2013
    public String  decimlSeprtr {get; set;}
    
    
    public NewRepController(){
        isTest = false;
    }

    public NewRepController(ApexPages.StandardController controller) {
        //Not sure why this is needed...
    }

    public NewRepController(ApexPages.StandardSetController  controller) {
        con=controller;
        isTest = true;
        nCurrentPageNbr = 1;
       // initialized();
    }
    
    public String NewRepReportURL;
    
    public String getNewRepReportURL() {
        if(NewRepReportURL == null || NewRepReportURL == '')
            generateReportURL();
        return NewRepReportURL;
    }
    
    public void setNewRepReportURL (String strNewRepReportURL) {
        this.NewRepReportURL = strNewRepReportURL;
    }
    
    public void generateReportURL() {   
        if(NewRepReportURL ==null || NewRepReportURL == '') {
            String NewRepReportName = 'New_Business_Report_ALM_'+this.mrktId;
            List<Report> lstMTMTO = [SELECT ID, DeveloperName
                                     FROM Report
                                     WHERE DeveloperName = :NewRepReportName];
            if(lstMTMTO != null) {
                if(lstMTMTO[0].developerName == NewRepReportName)
                    NewRepReportURL = lstMTMTO[0].Id;
            }
        }
    }
    
    public PageReference initialized(){ 
        // Initialization - Start
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting(); 
        isMailPlan = false ; // false by default set - added by raktim on 25Jun 2013 - Mail Plan
        
        SiteHeaderController obj_Controller = new SiteHeaderController();
        
        this.mailPlnCampgn = Apexpages.currentPage().getParameters().get('mpCampaign');
        System.debug(Logginglevel.DEBUG,'Hello World');
        System.debug('mailPlnCampgn : '+this.mailPlnCampgn);
        
        String isSellingCmpgn_Deflt_Landng = Apexpages.currentPage().getParameters().get('mpsellingdefaultlanding');
        System.debug('\n ####### isSellingCmpgn_Deflt_Landng -->>. '+isSellingCmpgn_Deflt_Landng);
        
        String operationalCampaign = Apexpages.currentPage().getParameters().get('operatnCampaign');
        System.debug('\n ####### operationalCampaign -->>. '+operationalCampaign);
        
        tableHeader = new List<String>();
        topRow = new List<String>();
        curOthRow = new List<List<String>>(); 
        lst_ReportLinks = new List<Report_Config__c>();
        reportId = ApexPages.currentPage().getParameters().get('reportId');
        defaultqueryField = 'ACCT_NR__c';
        topRowCol = new List<String>();
        otherRowCol = new List<String>();
        dataD = new List<DataDetail>();
        DOWNLOAD_LIMIT = 0;
        tableHeaderWidth = 0;
        ADWidth = 0;
        showTableBorderWidth = 0;
        s_IsImpersonated=false;
        topRowDataPos = new List<String>();
        otherRowDataPos = new List<String>();
        loaFList = new List<SelectOption>();
        campFList = new List<SelectOption>();
        campList = new List<Integer>();
        s_CurrencySymbol='';
        invisibleList = new List<String>();
        noOfPiVar = 0;
        emailForIndc = '';
        lstEmailIndc = new List<Boolean>();
        lstTitleLevel = new List<Boolean>();
        // End of Initialization
        emailAllUrl = System.Label.YOU_NEWREP_ALL_CHKBX;
        //Market__c market;
        User currUsr;
        User currLogUser;
        String s_User;
        String campaign;
        Integer campaignNr;
        List<Report_Column_New__c> RepColumns;
        try{
            //Logic for impersonate
            String s_Impersonated_User = Apexpages.currentPage().getParameters().get('acctkey');
            
            /** Change done by Raktim on 18th Oct 2013 START **/
            //campaign = isSellingCmpgn_Deflt_Landng == 'Y' ? mailPlnCampgn : operationalCampaign;
                        
            if(Apexpages.currentPage().getParameters().get('CNO') == null)
                campaign = isSellingCmpgn_Deflt_Landng == 'Y' ? mailPlnCampgn : operationalCampaign;
            else
                campaign = Apexpages.currentPage().getParameters().get('CNO');
            System.debug('\n ####### campaign when page is loaded --> '+campaign);
            /** Change done by Raktim on 18th Oct 2013 END **/
            
            //system.debug('\n #### s_Impersonated_User ::: '+s_Impersonated_User);
            if(s_Impersonated_User!=null && s_Impersonated_User.trim()!=''){
                ///system.debug('\n #### s_Impersonated_User 111 ::: '+s_Impersonated_User);
                currLogUser=[SELECT Id, Profile.Id, Profile.Name, DFALT_ZONE_CD__c, 
                DFALT_DIV_NM__c, MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, 
                Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c 
                FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                
                /*campaignNr = YOUUtil.getCurrentCampaignNumber(currLogUser.MRKT_ID__c);
                campaign = String.valueOf(campaignNr);     */
               // campaign = mailPlnCampgn;
               
                System.debug('\n #### s_Impersonated_User 111 campaign ::: '+campaign);
                Boolean IsImp = LandingPageUtils.isImpersonationValid(currLogUser.Profile.Name, 
                                currLogUser.MRKT_ID__c, currLogUser.DFALT_ZONE_CD__c, 
                                currLogUser.DFALT_DIV_NM__c, currLogUser.ACCT_NR__c, 
                                campaign, s_Impersonated_User);
                System.debug('\n #### s_Impersonated_User 111 IsImp ::: '+IsImp);                               
                if (IsImp){
                    User u = [Select Id,Name,LanguageLocaleKey,MRKT_ID__c,
                                ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c,Profile.Name,
                                LDRSHP_TITL_LVL_NBR__c 
                                from User 
                                where ACCT_NR__c =: s_Impersonated_User
                                and MRKT_ID__c=:currLogUser.MRKT_ID__c Limit 1];
                            s_User=u.Id;
                            s_Impersonated_UserName=u.Name;
                            s_IsImpersonated = true;
                            s_Impersonated_Profile=u.Profile.Name;
                            s_Impersonated_LDRTitlLvl=u.LDRSHP_TITL_LVL_NBR__c;
                }else {
                    s_User = UserInfo.getUserId();
                }
            }else{
                s_User = UserInfo.getUserId();
            }

            //impersonate end
            currUsr = [SELECT Id, MRKT_ID__c, LanguageLocaleKey, LocaleSidKey,Name, 
                        FirstName, MRKT_ID_ACCT_NR_KEY__c, ACCT_NR__c, 
                        Profile.Name, LDRSHP_TITL_LVL_NBR__c
                        FROM   User
                        WHERE  Id = :s_User];        
            this.userAccNr = currUsr.ACCT_NR__c; 
            userProflName =  currUsr.Profile.Name;
            userTitleLvlNumbr = currUsr.LDRSHP_TITL_LVL_NBR__c;
            usermrktacct=currUsr.MRKT_ID_ACCT_NR_KEY__c;
            currUserLanguage=currUsr.LanguageLocaleKey;
            currUserLocale=currUsr.LocaleSidKey;
            
            /** Comma , Decimal Separation Change on 6th Sept by Raktim - START **/
            List<String> lstSeprtn =  YOUUtil.getLocaleSeparator(currUserLocale);
            commaSeprtr = lstSeprtn[0];
            decimlSeprtr = lstSeprtn[1];
            /** Comma , Decimal Separation Change on 6th Sept by Raktim - END **/
            
        if(userProflName.contains('Leader') || 
                userProflName.contains('Division') || 
                userProflName.contains('Zone') ){
            Leader_Title = new List<Leader_Title__c>();
            market = [SELECT Id, Name, Market_Id__c,CMPGN_NR__c, 
                        Allow_Free_Emails_For__c, 
                        Allow_Freeform_Email__c ,
                        ALM_Rep_Indicator__c,
                        Omniture_Suite_Name__c,
                        Market_Currency_Symbol__c,
                        Mail_Plan_Enabled__c, NEXT_1_CMPGN_NR__c, PREV_1_CMPGN_NR__c, NRT_Enabled__c
                        FROM   Market__c
                        WHERE  Market_Id__c =:currUsr.MRKT_ID__c];
            
            this.mrktId = market.Market_Id__c;
            this.almRepIndicator = market.ALM_Rep_Indicator__c;
            this.isMailPlan = (market.Mail_Plan_Enabled__c ? true : false); // added by raktim on 25Jun 2013 - Mail Plan
            
            if(this.isMailPlan){
                //this.campagnNr = mailPlnCampgn; 
                this.campagnNr = campaign;
            }else{
                this.campagnNr = market.CMPGN_NR__c;    
            }
            //this.campagnNr = market.CMPGN_NR__c;
            this.omnture_suit=market.Omniture_Suite_Name__c;
            this.mktTagsMap = MarketTagUtils.getYouMktTags( this.mrktId, currUserLanguage);
            if(market.Market_Currency_Symbol__c!=null){
                this.s_CurrencySymbol=market.Market_Currency_Symbol__c;
            }
            if(market.Allow_Freeform_Email__c.contains(userProflName))
                this.emailForIndc   =   market.Allow_Free_Emails_For__c;

            //SiteHeaderController obj_Controller = new SiteHeaderController();
            obj_Controller.currUsr=currUsr;
             if(s_IsImpersonated){
                if(obj_Controller.getReportLinks(this.mrktId, 
                    this.userProflName,currUsr.LDRSHP_TITL_LVL_NBR__c,true).size()>0){
                for(Report_Config__c obj_RC : obj_Controller.getReportLinks(
                    this.mrktId, s_Impersonated_Profile,s_Impersonated_LDRTitlLvl,true)){
                    // Added by Raktim  - defect id : 2400
                    if(obj_RC.Report_Type__c != ALMConstants.REPORT_TYPE_MYNEWREP_REPCONFIG) 
                    // End of Addition
                        lst_ReportLinks.add(obj_RC);
                }
            }
            }else{
                if(obj_Controller.getReportLinks(this.mrktId, 
                    this.userProflName,currUsr.LDRSHP_TITL_LVL_NBR__c,false).size()>0){
                for(Report_Config__c obj_RC : obj_Controller.getReportLinks(
                    this.mrktId, this.userProflName,currUsr.LDRSHP_TITL_LVL_NBR__c,false)){
                    // Added by Raktim  - defect id : 2400 
                    if(obj_RC.Report_Type__c != ALMConstants.REPORT_TYPE_MYNEWREP_REPCONFIG)
                    // End of Addition
                        lst_ReportLinks.add(obj_RC);
                }
            }
            }

            String userTypes = '\''+userProflName+'\'';
            String titleLevels = '\''+userTitleLvlNumbr+'\'';
            String campaignNo = ApexPages.currentPage().getParameters().get('CNO');
            String loaFiltr  = ApexPages.currentPage().getParameters().get('What'); 
            System.debug('\n ######## this.campagnNr >>>>. '+this.campagnNr+', campaignNo --- '+campaignNo);
            if(campaignNo == null){
                this.campFselect = this.campagnNr;
            }else {
                this.campFselect = campaignNo;
            }
            System.debug('\n ######## this.campFselect >>>>. '+this.campFselect);
            //No use of YouUtil here Requirement is different
            Integer curFsel =    Integer.valueOf(this.campFselect);
            System.debug(' curFsel'+curFsel);
            for(Calendar__c cal : [SELECT CMPGN_NR__c FROM Calendar__c 
                                    WHERE CMPGN_NR__c < :curFsel 
                                    AND MRKT_ID__c = :mrktId 
                                    ORDER by CMPGN_NR__c desc 
                                    LIMIT :nbrOfCmp]){
                    System.debug('DATA '+cal.CMPGN_NR__c);
                    campList.add(Integer.valueOf(cal.CMPGN_NR__c));
             }
            ///////
            String soqlToExec = 'SELECT Applicable_to__c, Default_Sort__c, '+
                                'Include_Recruits__c, Include_Removed_Reps__c, '+
                                'Order_Criteria__c, TITL_LVL_NBR__c, Name ,Report_Id__c, '+
                                'Page_Size__c ,Dowload_Limit__c, Number_of_Historical_Cmpgns_for_Filter__c '+
                                'FROM Report_Config__c '+
                                'WHERE Market__r.Market_Id__c =\''+mrktId+'\' '+
                                'AND Applicable_to__c includes ('+userTypes+') ' +  
                                'AND TITL_LVL_NBR__c includes ('+titleLevels+') ' +
                                'AND Report_Id__c =\''+reportId+'\'';
            System.debug('##### SOQL to Print '+soqlToExec);
            reportConfig = Database.query(soqlToExec);
            if(this.reportConfig != null){
                PAGE_SIZE = Integer.valueOf(reportConfig.Page_Size__c);
                DOWNLOAD_LIMIT = Integer.valueOf(reportConfig.Dowload_Limit__c);
                orderByClause = String.valueOf(reportConfig.Order_Criteria__c);
                RepColumns = [SELECT r.Name,  r.Fully_Qualified_Name__c,
                                r.Fully_Qualified_Name2__c,r.Width__c,
                                r.Visibility__c,r.Type__c,r.Is_Hover_enabled__c,r.Color__c,//changed swarnava - defect id : 2352
                                r.Column_Group_Name__c
                                FROM Report_Column_New__c r 
                                WHERE r.Report_Config__r.Report_Id__c =:reportId 
                                AND r.is_hidden__c = false
                                AND r.Visibility__c IN ('Default Shown','Always Displayed')
                                ORDER BY r.Display_Order__c asc];

                Integer pos = 0;
                for (Report_Column_New__c col : RepColumns ){
                    DataDetail d = new DataDetail();
                    d.Field_Api = col.Fully_Qualified_Name2__c;
                    System.debug('\n ####### COL NAME :::: '+col.Name);
                    if(mktTagsMap.get(col.Fully_Qualified_Name2__c)!=null){
                        tableHeader.add(mktTagsMap.get(col.Fully_Qualified_Name2__c));
                        d.Data = mktTagsMap.get(col.Fully_Qualified_Name2__c);
                        d.DataLong=mktTagsMap.get(col.Fully_Qualified_Name2__c);
                    }else{
                        if(String.valueOf(col.Fully_Qualified_Name__c).contains('LDRSHP_TITL_LVL_NR__c')){
                            System.debug('In here....Mapping Title.....'+col.Fully_Qualified_Name__c);
                            if((ApexPages.currentPage().getParameters().get('CNO'))!=null && 
                                String.valueOf(ApexPages.currentPage().getParameters().get('CNO'))!=String.valueOf(this.campagnNr)){
                                d.Data = ALMReportLabels.getReportShortColumn('Paid Title');
                                d.DataLong=ALMReportLabels.getColumnHeader('Paid Title');
                                tableHeader.add(ALMReportLabels.getReportShortColumn('Paid Title'));
                            }else{
                                d.Data = ALMReportLabels.getReportShortColumn('Badge Title');
                                d.DataLong=ALMReportLabels.getColumnHeader('Badge Title');
                                tableHeader.add(ALMReportLabels.getReportShortColumn('Badge Title'));
                            }
                        }else if (String.valueOf(col.Fully_Qualified_Name__c).contains('_GRP_UNIT_SLS_AMT__c')){
                            d.Data = ALMReportLabels.getReportShortColumn(col.Name).replace('N',this.campFselect.substring(4,6));
                            d.DataLong = ALMReportLabels.getColumnHeader(col.Name).replace('N',this.campFselect.substring(4,6));
                            tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name).replace('N',this.campFselect.substring(4,6)));
                        }else if (String.valueOf(col.Fully_Qualified_Name__c).contains('_INVC_AWRD_SLS_AMT__c')){
                            Integer i = Integer.valueOf(col.Fully_Qualified_Name__c.substring(2,3));
                            System.debug('IIIIII '+i);
                            System.debug('campList '+campList.size());
                            d.Data = ALMReportLabels.getReportShortColumn(col.Name).replace('N',String.valueOf(campList.get(i-1)).substring(4,6));
                            d.DataLong = ALMReportLabels.getColumnHeader(col.Name).replace('N',String.valueOf(campList.get(i-1)).substring(4,6));
                            tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name).replace('N',String.valueOf(campList.get(i-1)).substring(4,6)));
                        }else if (String.valueOf(col.Fully_Qualified_Name__c).contains('PRSNL_SLS_AMT__c')){
                            d.Data = ALMReportLabels.getReportShortColumn(col.Name).replace('N',this.campFselect.substring(4,6));
                            d.DataLong = ALMReportLabels.getColumnHeader(col.Name).replace('N',this.campFselect.substring(4,6));
                            tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name).replace('N',this.campFselect.substring(4,6)));
                        }else if (String.valueOf(col.Fully_Qualified_Name__c).contains('MailPlan_Order_Oppty__r') && isMailPlan){ //col.Is_MailPlan__c
                            //d.Data = ALMReportLabels.getReportShortColumn(col.Name).replace('N',this.campFselect.substring(4,6));
                            //d.DataLong = ALMReportLabels.getColumnHeader(col.Name).replace('N',this.campFselect.substring(4,6));
                            //tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name).replace('N',this.campFselect.substring(4,6)));
                            
                            d.Data = ALMReportLabels.getReportShortColumn(col.Name);
                            d.DataLong=ALMReportLabels.getColumnHeader(col.Name);
                            tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name));
                        }else if (String.valueOf(col.Fully_Qualified_Name__c).contains('MRKT_ACCT_KEY__r.FirstName,MRKT_ACCT_KEY__r.LastName')){
                            d.isflname = true;
                            d.flLabel=ALMReportLabels.getReportColumnLabel(col.Name);
                            d.flsortOrder = 0;
                            d.Data = ALMReportLabels.getReportShortColumn(col.Name);
                            d.DataLong=ALMReportLabels.getColumnHeader(col.Name);
                            tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name));
                        }
                      else{
                            d.Data = ALMReportLabels.getReportShortColumn(col.Name);
                            d.DataLong = ALMReportLabels.getColumnHeader(col.Name);
                            tableHeader.add(ALMReportLabels.getReportShortColumn(col.Name));
                        }
                    }

                        d.type = col.Visibility__c;
                        d.Id = pos;
                        d.vartype = col.Type__c;
                        if (col.Column_Group_Name__c != '' && col.Column_Group_Name__c != null){
                            if (col.Column_Group_Name__c == 'Personal Information'){
                                d.shID = 'SHPI';
                                noOfPiVar = noOfPiVar + 1;
                            }else {
                                d.shID = 'SH'+pos; //Since we are not handling other value of pick list
                            }

                        }else {
                            d.shID = 'SH'+pos;
                        }
                        if(col.Fully_Qualified_Name2__c=='MRKT_ACCT_KEY__r.ACCT_NR__c'){
                            i_AccountNumberPos=pos; 
                        }
                        if(col.Fully_Qualified_Name2__c=='LDRSHP_TITL_LVL_NR__c'){
                            i_LeaderTitlePos=pos;   
                        }
                        d.width = String.Valueof(col.Width__c);
                        d.isCurrency=false;
                        if(col.Type__c=='Currency'){
                                d.isCurrency=true;
                        }
                        if (col.Type__c == 'Number' || col.Type__c=='Currency'){
                            d.align = 'right';
                        }else {
                            d.align = 'left';
                        }
                        d.sortOrder  = -1;
                        d.Col_Color=col.Color__c;//added swarnava for New Rep Mockup
                        dataD.add(d);
                        topRowCol.add(col.Fully_Qualified_Name__c);
                        otherRowCol.add(col.Fully_Qualified_Name2__c);
                        //tableHeader.add(colHeaderShort.get(col.Name));
                        
                        topRowDataPos.add(col.Fully_Qualified_Name__c);
                        otherRowDataPos.add(col.Fully_Qualified_Name2__c);
                        if (col.Visibility__c == 'Always Displayed'){
                            tableHeaderWidth += Integer.valueOf(col.Width__c); 
                            ADWidth += Integer.valueOf(col.Width__c);                             
                            ADWidth += 11; //handing the padding 5+5+1
                        }
                    pos = pos + 1;
                }//end of column for
            }//end of report configd.Field_Api = col.Fully_Qualified_Name2__c;.
            showTableBorderWidth = tableHeaderWidth + 90;
            tableHeaderWidth = tableHeaderWidth - 2;
            ADWidth  += 55; //adding the checkbox column
            ADWidth  += 11; //adding the checkbox column  padding 5+5+1
            
             Leader_Title = [Select Id,LDRSHP_TITL_LVL_NR__c,LANG_CD__c,LCL_LDRSHP_TITL_CD__c,LCL_LDRSHP_TITL_LANG_DESC_TXT__c 
                                From Leader_Title__c 
                                Where MRKT_ID__c =:this.mrktId and LANG_CD__c=:currUserLanguage];
                                    
             if(Leader_Title.size()>0){
                for(Leader_Title__c obj_Leader_Title : Leader_Title){
                    m_LeaderTitles.put(obj_Leader_Title.LDRSHP_TITL_LVL_NR__c,obj_Leader_Title);
                    m_ImpersonateLeaders.put(obj_Leader_Title.LCL_LDRSHP_TITL_CD__c,obj_Leader_Title.LDRSHP_TITL_LVL_NR__c);
                }
            }
            
            ///FILTERING START
            /*
            campFList.add(new SelectOption(this.campagnNr, this.campagnNr));
            if( isMailPlan )
            {
                if(!campagnNr.equals(this.market.CMPGN_NR__c)){
                    campFList.add(new SelectOption(this.market.CMPGN_NR__c, this.market.CMPGN_NR__c));  
                }   
            }*/
            if( isMailPlan ){
            
                //if(campagnNr.equals(this.market.CMPGN_NR__c)){
                    campFList.add(new SelectOption(this.market.NEXT_1_CMPGN_NR__c, this.market.NEXT_1_CMPGN_NR__c));
                    campFList.add(new SelectOption(this.market.CMPGN_NR__c, this.market.CMPGN_NR__c));
                //} 
            }else{
                campFList.add(new SelectOption(this.market.CMPGN_NR__c, this.market.CMPGN_NR__c));
            }
            campFList.add(new SelectOption(this.market.PREV_1_CMPGN_NR__c, this.market.PREV_1_CMPGN_NR__c));
            
            mapLOAValues    = new Map<String, String>();
            for(Report_Filter__c rf : [SELECT  Filter_Key__c, Filter_Criteria__c
                                       FROM  Report_Filter__c r
                                       WHERE r.Report_Config__r.Report_Id__c = :this.reportId
                                       order by r.Filter_Key__c] )
            {
                mapLOAValues.put(rf.Filter_Key__c, rf.Filter_Criteria__c);
                System.debug(' ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c) -->'+ rf.Filter_Key__c);
                loaFList.add(new SelectOption(rf.Filter_Key__c , ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c)));
                System.debug(rf.Filter_Key__c+' ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c) --> '+ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c));
            }
            
            if( isMailPlan ){
                if(campaignNo != null && campaignNo.equals(market.PREV_1_CMPGN_NR__c)){
                    mapLOAValues.remove(ALMConstants.OPEN_MAIL_PLAN_REPORT_KEY);
                    
                    for(integer i =0; i < loaFList.size(); i++){
                        Selectoption s = loaFList[i];
                        if(s.getValue().equals(ALMConstants.OPEN_MAIL_PLAN_REPORT_KEY)){
                            loaFList.remove(i);
                            isDeleted = true;
                        }   
                    }
                }
            }
            /*
            List<Integer> prevCampaignLst;
            Integer noOfHistCampaings   =   Integer.valueOf(reportConfig.Number_of_Historical_Cmpgns_for_Filter__c);
            if(noOfHistCampaings > 0){
                prevCampaignLst = new List<Integer>();  
                Integer i_CurrCampagnNr =    Integer.valueOf(campagnNr);
                for(Calendar__c cal : [SELECT CMPGN_NR__c FROM Calendar__c 
                                           WHERE MRKT_ID__c = :mrktId 
                                           AND CMPGN_NR__c < :i_CurrCampagnNr 
                                           ORDER BY CMPGN_NR__c DESC 
                                           LIMIT :noOfHistCampaings]){
                    prevCampaignLst.add(cal.CMPGN_NR__c.intValue());
                }
            }
            mapLOAValues    = new Map<String, String>();
            for(Report_Filter__c rf : [SELECT  Filter_Key__c, Filter_Criteria__c
                                       FROM  Report_Filter__c r
                                       WHERE r.Report_Config__r.Report_Id__c = :this.reportId
                                       order by r.Filter_Key__c] )
            {
                mapLOAValues.put(rf.Filter_Key__c, rf.Filter_Criteria__c);
                System.debug(' ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c) -->'+ rf.Filter_Key__c);
                loaFList.add(new SelectOption(rf.Filter_Key__c , ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c)));
                System.debug(rf.Filter_Key__c+' ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c) --> '+ALMReportLabels.getReportFilterLabel(rf.Filter_Key__c));
            }
            //Populating List Start
            campFList.add(new SelectOption(this.campagnNr,this.campagnNr));//campaign Text display changed by swarnava - Defect ID : 2401
            Integer track = 1;
            
            for(Integer counter = 0; counter < prevCampaignLst.size(); counter++){
                String prevCmpgnNr =    String.valueOf(prevCampaignLst[counter]);
                if(counter > 0){
                    campFList.add(new SelectOption(prevCmpgnNr, System.Label.Prior_Campaign+' -'+track));
                    track++;
                }else{
                    campFList.add(new SelectOption(prevCmpgnNr,prevCmpgnNr));//campaign Text display changed by swarnava - Defect ID : 2401    
                }  
                prevCmpgnNr = '';
            }
            */
            if(loaFiltr == null){
                //loaFselect =   System.Label.LOA_1_6; 
                loaFselect =   'LOA_0_6';
            }else {
                loaFselect = loaFiltr;
            }
            loaFiltrVal = mapLOAValues.get(loaFselect);
            System.debug('\n ####### loaFiltrVal -- >>> '+loaFiltrVal);
            
            /** This section is changed as per mail from business, by Raktim on 19th Sept, 2013 - START **/
            if(reportConfig.Include_Recruits__c){
                //loaFiltrVal+= ' And REP_OMS_STUS_CD__c=\'-2\' ';
                if(!reportConfig.Include_Removed_Reps__c){
                  //loaFiltrVal+= ' And REP_OMS_STUS_CD__c != \'0\' ';
                  loaFiltrVal+= ' And REP_OMS_STUS_CD__c in (\'-2\', \'1\') ';
                } 
            }else{
                if(!reportConfig.Include_Removed_Reps__c){
                    loaFiltrVal+=' And REP_OMS_STUS_CD__c=\'1\' ';
                }else{
                    loaFiltrVal+=' And REP_OMS_STUS_CD__c!=\'-2\' ';
                }   
            }
            /** This section is changed as per mail from business, by Raktim on 19th Sept, 2013 - END **/
            //Filter End
            
            //Adding the current campaign as well
            campList.add(curFsel);
            invisibleStr = Apexpages.currentPage().getParameters().get('invisibleStr');
            createTopRow();
            initializeCon(this.campFselect, loaFiltrVal);
        }//end of Leader Profile
        }catch (Exception e){
            System.debug('INIT ERROR '+e);
            String errorId = ErrorHandler.handleError(e.getMessage());
            errPage = Page.ErrorPage;
            errPage.getParameters().put('errId',errorId);
            return errPage;
        }
        return null;
    }//end of initialized

    void createTopRow(){
        Set<String> queryFieldSet = new Set<String>();
        List<SObject> genealogyList = null;
        for (String col: topRowCol){
            if (col.contains(',')) //handling the case of firstname,lastname
            {
                queryFieldSet.add(col.split('\\,', 2)[0]);
                queryFieldSet.add(col.split('\\,', 2)[1]);
            }else {
                queryFieldSet.add(col);
            }
            
        }
        queryFieldSet.add('ROOT_UPLN_ACCT_NR__c');
        queryFieldSet.add('Genealogy_Level__c');
        queryFieldSet.add('LFT_ND_ID__c');
        queryFieldSet.add('RGT_ND_ID__c');
        
        GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(this.mrktId, userAccNr, queryFieldSet); //Specify market
        
        // Now create Query Options for First Level
        Map<String, String> queryOptionsMap = new Map<String, String>();
        System.debug('\n ####### campagnNr ####### '+campagnNr);
        String whereClause = 'ACCT_NR__c = \''+userAccNr+'\''+
                            //' AND OPERTNL_CMPGN_NR__c = \''+campagnNr+'\''+
                            ' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(campagnNr)+
                            ' AND MRKT_ID__c = \''+this.mrktId+'\'';

        queryOptionsMap.put('WHERE',whereClause);
        queryOptionsMap.put('LIMIT','1');
        genealogyList = gsb.queryNew(queryOptionsMap);
        SObject topgen = genealogyList[0];

        leaderGenLevel = (Decimal)(topgen.get('Genealogy_Level__c'));
        leaderLeftId = (Decimal)(topgen.get('LFT_ND_ID__c'));
        leaderRightId = (Decimal)(topgen.get('RGT_ND_ID__c')); 
        // If the root of the tree is logged in user itself, then the same is the root upline acc number
        // Else, we use the field value to determine the tree identification
        leaderTreeAccNo = (Integer.valueOf(topgen.get('Genealogy_Level__c')) == 0) ? userAccNr:String.valueOf(topgen.get('ROOT_UPLN_ACCT_NR__c'));

        //Creating the first row list 
        for (String col : topRowDataPos ){
            System.debug('\n ###### Col ---- '+col);
            topRow.addAll(getReportFormattedString(col, topGen));
        }// end of for
    }//end of createTopRow

    //Instantiate the StandardSetController  
    public ApexPages.StandardSetController con{get; set;}  

    public void initializeCon(String campNo, String loa) {
        String orderBy = null;
        initializeCon(campNo, loa,orderBy);
    }
    // instantiate the StandardSetController from a query locator
    public void initializeCon(String campNo, String loa,String orderBy) {
                
        System.debug('\n ####### campNo >>>> '+campNo);
        System.debug('\n ####### loa >>>> '+loa);
        if(con == null) {
            String othLevelSOQL = 'SELECT '+defaultqueryField ;    
            otherRowCol.add('LDRSHP_TITL_LVL_NR__c');
            Set<String> s = new Set<String>();
            s.add(defaultqueryField);
            for(String columnUnique : otherRowCol){
                s.add(columnUnique);
            }
            
            GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(this.mrktId, userAccNr, s); //Specify market
            Map<String, String> queryOptionsMap = new Map<String, String>();

            String whereClause = 'ROOT_UPLN_ACCT_NR__c = \''+leaderTreeAccNo+'\'' +
                                 //' AND OPERTNL_CMPGN_NR__c = \''+campNo+'\'' +    /*campagnNr */
                                 ' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(campNo)+
                                 ' AND LFT_ND_ID__c > '+leaderLeftId +
                                 ' AND RGT_ND_ID__c < '+leaderRightId +
                                 ' AND MRKT_ID__c = \''+this.mrktId+'\' AND '+loa+
                                 ' AND Genealogy_Level__c in ('+(leaderGenLevel+1)+','+(leaderGenLevel+2)+','+(leaderGenLevel+3)+')';//changed by swarnava
            System.debug('WHERE CLAUSE: '+whereClause);
            queryOptionsMap.put('WHERE',whereClause);
            String localOrderBy;
            if (orderBy != null){
                localOrderBy = orderBy + ','+orderByClause;
            }else{
                localOrderBy = orderByClause;
            }
            queryOptionsMap.put('ORDER BY',localOrderBy);
            this.downlineGenLevel = (leaderGenLevel+1)+','+(leaderGenLevel+2)+','+(leaderGenLevel+3);
            
            con = new ApexPages.StandardSetController(Database.getQueryLocator(gsb.generateQueryNew(queryOptionsMap)));
            numpages=(Integer)Math.ceil((Decimal)con.getResultSize()/PAGE_SIZE);
            System.debug('FULL QUERY' +gsb.generateQueryNew(queryOptionsMap));
            System.debug('WHERE CLAUSE: '+whereClause);
            System.debug('WHERE CLAUSE: '+orderByClause);
            // sets the number of records in each page set
            if(!isTest)
                con.setPageSize(PAGE_SIZE);
            populateCon();
        }else {
            populateCon();
        }
    }
    
    public void populateCon(){
        List<SObject> otherGen =  con.getRecords();
        System.debug('otherGensieze '+otherGen.size());
        if(lstEmailIndc != null)
            lstEmailIndc.clear();
        if(lstTitleLevel != null)   
            lstTitleLevel.clear();
        
        if(curOthRow != null)   
            curOthRow.clear(); //clearing the list
            
        acctNbrList = new List<String>(); 
        for(SObject acct : otherGen){
            String actnr = String.valueOf(acct.get(defaultqueryField));
            acctNbrList.add(actnr);
        }

        //creating other row list
        for (SObject down : otherGen){
            
            Integer Badgeval = Integer.valueOf(down.get('LDRSHP_TITL_LVL_NR__c'));
                    //System.debug('Account Number-->'+down.get('ACCT_NR__c')+'-->'+Badgeval);
            if (Badgeval != null){
                if(Badgeval>=0){
                        lstTitleLevel.add(true);
                }else{
                        lstTitleLevel.add(false);
                }
            }else {
                lstTitleLevel.add(false);
            }
                    
            List<String> otheEle = new List<String>();   
            for (String col : otherRowDataPos ) {
                if(this.emailForIndc.equals('')){
                        lstEmailIndc.add(false);
                }else{
                    if(this.emailForIndc.equals('All')){
                        lstEmailIndc.add(true); 
                    }else if(this.emailForIndc.equals('G1')){
                        if(col.equals('Genealogy_Level__c')){
                            //String val = String.valueOf(down.get(col));
                            
                            // Calculate new Gen Index here
                            
                            Decimal val =  (Decimal)down.get(col) - leaderGenLevel;
                            if(val == 1){
                                lstEmailIndc.add(true);
                            }else{
                                lstEmailIndc.add(false);
                            }
                            down.put(col, val);
                            
                        }
                    }
                }
                
                otheEle.addAll(getReportFormattedString(col, down));
            }//end of for col
            System.debug('HAPPY');
            curOthRow.add(otheEle);
        }//end of for down                
    }//end of populateCon


    private List<List<List<String>>> createReport(){
        Integer counter = 0;
        Integer blockLimit = 1000;
        List<List<List<String>>> downloadAllList = new List<List<List<String>>>(); 
        List<List<String>> downloadAll = new List<List<String>>(); 
        //GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(mrktId); //Specify market
        Set<String> selClause = new Set<String>();
        selClause.add(defaultqueryField);
        System.debug('\n ###### createReport 1 ######## ');
        System.debug(' createReport invisibleStr  :'+this.invisibleStr);
        System.debug(' this.campFselect  :'+this.campFselect);
        
        for (String col : otherRowCol){
            selClause.add(col);
        }
        
        GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(mrktId, userAccNr, selClause);
        Map<String, String> queryOptionsMap = new Map<String, String>();
        
        String whereClause = 'ROOT_UPLN_ACCT_NR__c = \''+this.leaderTreeAccNo+'\'' +
                             //' AND OPERTNL_CMPGN_NR__c = \''+this.campFselect+'\'' +
                             ' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(this.campFselect)+
                             ' AND LFT_ND_ID__c > '+this.leaderLeftId +
                             ' AND RGT_ND_ID__c < '+this.leaderRightId +
                             ' AND MRKT_ID__c = \''+this.mrktId+'\'' +
                             ' AND Genealogy_Level__c in (1, 2, 3)' ;        

        queryOptionsMap.put('WHERE',whereClause);
        queryOptionsMap.put('ORDER BY','Genealogy_Level__c ASC, UPLN_ACCT_NR__c ASC, MRKT_ACCT_KEY__r.LastName ASC');
        queryOptionsMap.put('LIMIT','2100');
        
        //if(!isTest)
        {   
            System.debug('MILON BEFORE');
            List<SObject> otherGen =  gsb.queryNew(queryOptionsMap);
            System.debug('MILON AFTER');
            //creating other row list
            for (SObject down : otherGen){
                List<String> otheEle = new List<String>();   
                
                for (String col : otherRowDataPos ) {
                    otheEle.addAll(getReportFormattedString(col, down));
                }//end of for col
                downloadAll.add(otheEle);
                counter++;
                //load 1000 records in master List and create new List obj.
                if(counter == blockLimit) {
                    downloadAllList.add(downloadAll);
                    counter = 0;
                    downloadAll = null;
                    downloadAll = new List<List<String>>();
                }
            }//end of for down
            //load remaining records in master List
            if(downloadAll.size() < blockLimit) {
                System.debug('downloadAll.size() '+downloadAll.size());
                downloadAllList.add(downloadAll);
            }
        }
        
        return downloadAllList;
    }//End of create report
    
    /*  Method added by Raktim for Mail Plan 1Jul 2013 */
    public PageReference setLOAFilters()
    {
        String mrktCampaignNr  = Apexpages.currentPage().getParameters().get('selectedCmpgn');
        this.campFselect1 = mrktCampaignNr;
        String cmpgParam = (Apexpages.currentPage().getParameters().get('CNO') != null ? Apexpages.currentPage().getParameters().get('CNO') : '');
        System.debug('\n ### mrktCampaignNr >> '+mrktCampaignNr+', cmpgParam >> '+cmpgParam);
        System.debug('\n ### isDeleted >> '+isDeleted);
        
        if((mrktCampaignNr.equals(market.PREV_1_CMPGN_NR__c))  && isMailPlan) //mrktCampaignNr.equals(market.PREV_1_CMPGN_NR__c) || (cmpgParam.equals(market.PREV_1_CMPGN_NR__c))) && isMailPlan
        {
            for(Integer i = 0; i < loaFList.size() ; i++)
            {
                Selectoption so =   loaFList[i];
                String val = so.getValue();
                if(val.equals(ALMConstants.OPEN_MAIL_PLAN_REPORT_KEY)){
                    loaFList.remove(i);
                    isDeleted = true;
                    break;
                }
            }
            
        }else if(isMailPlan){
            
            if(isDeleted){
                loaFList.add(new SelectOption(ALMConstants.OPEN_MAIL_PLAN_REPORT_KEY , ALMReportLabels.getReportFilterLabel(ALMConstants.OPEN_MAIL_PLAN_REPORT_KEY)));  
                
                isDeleted = false;
            }
            
        }       
        
        return null;
            
    }//End

    public PageReference sortOther(){
     String mytype = Apexpages.currentPage().getParameters().get('stype');
     Integer id = Integer.valueOf(Apexpages.currentPage().getParameters().get('sid'));
     String field_api;
     System.debug('Type '+mytype);
     System.debug('ID '+id);
     if(mytype=='flname'){
         for (DataDetail d : dataD ){
            if(d.Id == id){
                field_api = d.Field_Api;
                System.debug('<<<<<<<<<<FIELD API>>>>>>>>>>>'+d.Field_Api);
                if(d.flsortOrder == 0){
                    d.flsortOrder = 1;
                    this.flsortOrder = 1;
                    d.flLabel = ALMReportLabels.getReportColumnLabel('MRKT_ACCT_KEY__r.FirstName,MRKT_ACCT_KEY__r.LastName');
                    String orderby;
                    if ((d.sortOrder == 0) || (d.sortOrder == -1)){
                    	orderby = 'MRKT_ACCT_KEY__r.FirstName ASC,MRKT_ACCT_KEY__r.LastName ASC';
                    	lastColumPaginated = 'A'+','+id+','+mytype;
                    	dataD[id].sortOrder = 0;
                    }else{
                    	orderby = 'MRKT_ACCT_KEY__r.FirstName DESC,MRKT_ACCT_KEY__r.LastName DESC';
                    	lastColumPaginated = 'D'+','+id +','+mytype;
                    }
                    this.con = null;
                    initializeCon(this.campFselect, this.loaFiltrVal,orderby);
                }else{
                    d.flsortOrder = 0;
                    this.flsortOrder = 0;
                    d.flLabel = ALMReportLabels.getReportColumnLabel('MRKT_ACCT_KEY__r.LastName,MRKT_ACCT_KEY__r.FirstName');
                    String orderby;
                    if ((d.sortOrder == 0) || (d.sortOrder == -1)){
                    	orderby = 'MRKT_ACCT_KEY__r.LastName ASC,MRKT_ACCT_KEY__r.FirstName ASC';
                    	lastColumPaginated = 'A'+','+id+','+mytype;
                    	dataD[id].sortOrder = 0;
                    }else{
                    	orderby = 'MRKT_ACCT_KEY__r.LastName DESC,MRKT_ACCT_KEY__r.FirstName DESC';
        				lastColumPaginated = 'D'+','+id +','+mytype;
                    }
                    this.con = null;
                    initializeCon(this.campFselect, this.loaFiltrVal,orderby);
                }
            }//end of if d.Id
         }//End of for Detail D
     }else {
     
     if ((dataD[id].sortOrder == 1) || (dataD[id].sortOrder == -1)){
        //this.curOthRow= YouUtil.sortbycolasc(this.curOthRow, Integer.valueOf(id), mytype );
        dataD[id].sortOrder = 0;
        lastColumPaginated = 'A'+','+id+','+mytype;
        String orderby = dataD[id].Field_Api + ' ASC';
        this.con = null;
        initializeCon(this.campFselect, this.loaFiltrVal,orderby);
     }else {
        //this.curOthRow= YouUtil.sortbycoldesc(this.curOthRow, Integer.valueOf(id), mytype );
        dataD[id].sortOrder = 1;
        lastColumPaginated = 'D'+','+id +','+mytype;
        String orderby = dataD[id].Field_Api + ' DESC';
        this.con = null;
        initializeCon(this.campFselect, this.loaFiltrVal,orderby);
     }

     //For sorting image 
     for (DataDetail d : dataD ){
         if (d.id != id){
             d.sortOrder = -1;
         }
     }
     }
     /*
     //Email indicator
     lstEmailIndc.clear();
     acctNbrList.clear();
    lstTitleLevel.clear();
     if(this.emailForIndc.equals('')){
        lstEmailIndc.add(false);
     }else{
        if(this.emailForIndc.equals('All')){
            lstEmailIndc.add(true); 
        }else if(this.emailForIndc.equals('G1')){
            for (List<String> col : this.curOthRow ){
                String val = String.valueOf(col[0]);
                if(val.equals('1')){
                    lstEmailIndc.add(true);
                }else{
                    lstEmailIndc.add(false);
                }
            }
        }
     }
     for(List<String> col : this.curOthRow){
        acctNbrList.add(String.valueOf(col[i_AccountNumberPos]));
     }
    for(List<String> col : this.curOthRow){
        //if(!isTest){
        if(m_ImpersonateLeaders.get(col[i_LeaderTitlePos])!=null){
            if(Integer.valueOf(m_ImpersonateLeaders.get(col[i_LeaderTitlePos]))>=0){
                lstTitleLevel.add(true);
            }else{
                lstTitleLevel.add(false);
            }   
        }else {
            lstTitleLevel.add(false);
        }  
       //}   
     }
     */
     System.debug('lstTitleLevel.size :'+lstTitleLevel.size());
     //End email indicator
     return null;
    }
    
    
    private void sortPaginate(){
        if (lastColumPaginated != '' && lastColumPaginated != null ){
            String sortOrder = lastColumPaginated.split('\\,', 3)[0];
            String sortCol = lastColumPaginated.split('\\,', 3)[1];
            String sortType = lastColumPaginated.split('\\,', 3)[2];
            if (sortOrder == 'A'){
                this.curOthRow= YouUtil.sortbycolasc(this.curOthRow, Integer.valueOf(sortCol), sortType );
            }else {
                this.curOthRow= YouUtil.sortbycoldesc(this.curOthRow, Integer.valueOf(sortCol), sortType );
            }
        }
        //Email indicator
        lstEmailIndc.clear();
        acctNbrList.clear();
    lstTitleLevel.clear();
        if(this.emailForIndc.equals('')){
            lstEmailIndc.add(false);
        }else{
            if(this.emailForIndc.equals('All')){
                lstEmailIndc.add(true); 
            }else if(this.emailForIndc.equals('G1')){
                for (List<String> col : this.curOthRow ){
                    String val = String.valueOf(col[0]);
                    if(val.equals('1')){
                        lstEmailIndc.add(true);
                    }else{
                        lstEmailIndc.add(false);
                    }
                }
            }
     }
     for(List<String> col : this.curOthRow){
        acctNbrList.add(String.valueOf(col[i_AccountNumberPos]));
     }
            for(List<String> col : this.curOthRow){
            //if(!isTest){  
            if(m_ImpersonateLeaders.get(col[i_LeaderTitlePos])!=null){
                if(Integer.valueOf(m_ImpersonateLeaders.get(col[i_LeaderTitlePos]))>=0){
                    lstTitleLevel.add(true);
                }
                else{
                    lstTitleLevel.add(false);
                }   
            }else {
                lstTitleLevel.add(false);
            }
            //}
            }
     //End email indicator           
    }

    public PageReference pagination(){
        String paginationType = Apexpages.currentPage().getParameters().get('pgtype');
        if (paginationType == 'next'){
            next();
        }else if (paginationType == 'previous'){
            previous();
        }else if (paginationType == 'first'){
            first();
        }else if (paginationType == 'last'){
            last();
        }

        return null;
    }

 //Boolean to check if there are more records after the present displaying records  
    public Boolean hasNext{  
        get{  
            return con.getHasNext();  
        }  
        set;  
    }  
   
    //Boolean to check if there are more records before the present displaying records  
    public Boolean hasPrevious  {  
        get  {  
            return con.getHasPrevious();  
        }  
        set;  
    }
    
    //Page number of the current displaying records  
    public Integer pageNumber  {  
        get  {  
            return con.getPageNumber();  
        }  
        set;  
    }  

    // returns the first page of records
    public PageReference first() {
        con.first();
        populateCon();
        sortPaginate();
        return null;
    }
 
    // returns the last page of records
    public PageReference last() {
        con.last();
        populateCon();
        sortPaginate();
        return null;
    }

    // returns the previous page of records
    public PageReference previous() {
         if(!isTest)
          con.previous();
        populateCon();
        sortPaginate();
        return null;
    }
 
    // returns the next page of records
    public PageReference next() {
        if(!isTest)
          con.next();
        populateCon();
        sortPaginate();
        return null;
    }
    
    public PageReference gotopage() {
        con.setpageNumber(Integer.valueof(Apexpages.currentPage().getParameters().get('pagename')));
        populateCon();
        sortPaginate();
        return null;  
    }

    public void downloadAll(){
       this.isAll = 'ALL';
    }
    
    public PageReference downloadPage(){
       this.isAll = 'Page';
       return this.downloadThisReport();
    }
    
    public PageReference downloadThisReport(){
        listReportData = new List<List<List<String>>>();
        List<List<String>> listheader = new List<List<String>>();
        List<List<String>> listData = new List<List<String>>();
        List<List<List<String>>> headerData = new List<List<List<String>>>();
        List<List<List<String>>> tableData = new List<List<List<String>>>();
        PageReference pageRef = new PageReference('/apex/NewRepReportDwnld');
        pageRef.setRedirect(false);
        Integer SIZE=5;
        nColspan = tableHeader.size();
        strBodyReportName = reportConfig.Name;
        listheader.add(tableHeader);
        headerData.add(listheader);

        //WYSISYG start
        invisibleList = new List<String>();
        if (invisibleStr != '' && invisibleStr != null){
            invisibleList = invisibleStr.split('~');
            nColspan = nColspan - invisibleList.size();
        }else {
            invisibleList = null;
        }
        System.debug('\n ###### invisibleStr ---> '+invisibleStr);
        if (invisibleStr.contains('SHPI')){
            nColspan = nColspan - (noOfPiVar - 1);
        }
        
        //WYSISYG end
        listData.add(topRow);
        listReportData.addall(headerData);
        System.debug('\n ###### isAll ---> '+isAll);
        if (isAll == 'ALL'){
            listReportData.addall(createReport());
        }else {
            
            if(listData != null && listData.size() > 0) // Top Row removed - from 'DOWNLOAD THIS PAGE' 
                listData.remove(0);                    // on 6th Sept, 2013
            
            listData.addall(curOthRow);
            tableData.add(listData);
            listReportData.addall(tableData);
        }
        Date currdate = System.today();
        String strMonth = 
            (String.valueOf(currdate.month()).length() == 1)? '0'+String.valueOf(currdate.month()):String.valueOf(currdate.month());
        String strDay = 
            (String.valueOf(currdate.day()).length() == 1)? '0'+String.valueOf(currdate.day()):String.valueOf(currdate.day());
        String strRepId = 
            (reportConfig.Report_Id__c != null)? reportConfig.Report_Id__c : mrktId+'000';
        strReportName = System.label.Report +'_'+ strRepId +'_'+ currdate.year() + strMonth + strDay;
        //strReportName = 'ReportdownloadTest';
        System.debug('Download report name: '+strReportName);
        System.debug('isALL '+isAll);
        String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');    
        if(userAgent != null && userAgent.contains('MSIE')) {
            browserType = true;
        } else {
            browserType = false;
        }     
        //System.debug('Content :'+pageRef);   
        return pageRef;
    }

    public void downloadMyReport() 
    {
        PermissionSet ps=[Select Id From PermissionSet where Name='View_All'];
        System.debug('>>>>'+UserInfo.getUserId());
        List<PermissionSetAssignment> psaQuery=new List<PermissionSetAssignment>();
        psaQuery=[Select Id From PermissionSetAssignment where AssigneeId=:UserInfo.getUserId() and PermissionSetId=:ps.Id ];
        if(psaQuery.size()==0){
            PermissionSetAssignment psa=new PermissionSetAssignment(PermissionSetId=ps.Id,AssigneeId=UserInfo.getUserId());
            insert psa;
        }
    }    

    public PageReference download_click(){
        this.invisibleStr = Apexpages.currentPage().getParameters().get('allinvisibleStr');
        System.debug(' invisibleStr  :'+this.invisibleStr);
        return null;
    }

    public PageReference setPrintVar(){
        invisibleStr = Apexpages.currentPage().getParameters().get('prtinvisibleStr');
        System.debug(' invisibleStr  :'+invisibleStr);
        return null;
    }
    
    public void provideAccountAccess()
    {
        PermissionSet ps=[Select Id From PermissionSet where Name='View_All'];
        System.debug('>>>>'+UserInfo.getUserId());
        List<PermissionSetAssignment> psaQuery=new List<PermissionSetAssignment>();
        psaQuery=[Select Id From PermissionSetAssignment where AssigneeId=:UserInfo.getUserId() and PermissionSetId=:ps.Id ];
        if(psaQuery.size()==0){
            PermissionSetAssignment psa=new PermissionSetAssignment(PermissionSetId=ps.Id,AssigneeId=UserInfo.getUserId());
            insert psa;
        }
    }

     public PageReference printRedirect() {
        //Added by Samudra
        Report_Print__c reportPrint = [Select Fixed_columns__c, Height__c, Width__c
                                       From Report_Print__c
                                       Where Name =:this.mrktId];
                                       
        if(reportPrint <> null){
            NoOfColumns = String.valueOf(reportPrint.Fixed_columns__c);
            ReportHeight = String.valueOf(reportPrint.Height__c);
            ReportWidth = String.valueOf(reportPrint.Width__c);
            System.debug('==========================================ReportWidth' + ReportWidth );
        }
        
        //Added By Samudra
        
        System.debug(' invisibleStr  :'+invisibleStr);
        if(invisibleList != null)
          invisibleList.clear();
        if (invisibleStr != '' && invisibleStr != null){
            invisibleList = invisibleStr.split('~');
        }else {
            invisibleList = null;
        }
        if(!isTest)
          nCurrentPageNbr = con.getPageNumber();
        System.debug('strCurrentPageNbr: '+nCurrentPageNbr);
        PageReference pageRef = Page.NewRepReportPrt;
        
        nColspan = tableHeader.size();
        strBodyReportName = reportConfig.Name;
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    public PageReference refreshPage() {
        PageReference pageRef = Page.NewRepReport;
        pageRef.getParameters().put('reportid', reportId);
        pageRef.getParameters().put('CNO',this.campFselect);
        pageRef.getParameters().put('LOA',this.loaFselect);
        pageRef.getParameters().put('pgId','9');
        pageRef.getParameters().put('invisibleStr',invisibleStr);
        System.debug('Set current page number: '+nCurrentPageNbr);
        System.debug('isTest: '+isTest);
        System.debug('invisibleStr: '+invisibleStr);
        if(!isTest)
          con.setPageNumber(nCurrentPageNbr);
        return pageRef;
    }
    
    
    //For Coaching Page Invocation - Start
    public PageReference callRepDetails() {
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
    }// End of method

    public PageReference setLOA()
    {
        String mrktLoa  = Apexpages.currentPage().getParameters().get('selectedLoa');
        System.debug('mrktLoa '+mrktLoa);
        this.loaFselect1 = mrktLoa;
        this.loaFselect = mrktLoa;
        if (this.campFselect1 == null)
            this.campFselect1 = this.campFselect;
        System.debug('this.loaFselect1 '+this.loaFselect1);
        System.debug('this.loaFselect '+this.loaFselect);
        System.debug('this.campFselect1 '+this.campFselect1);
        return null;
            
    }//End
    
    //add byy Sg
    public PageReference filterReport(){
        PageReference pageref = Page.NewRepReport;
        pageRef.getParameters().put('reportid', ApexPages.currentPage().getParameters().get('reportid'));
        if (this.campFselect1 == null){
            pageRef.getParameters().put('CNO',this.campFselect);
        }else{
            pageRef.getParameters().put('CNO',this.campFselect1);
        }
        
        if (this.loaFselect1 == null){
            pageRef.getParameters().put('What',this.loaFselect);
        }else{
            pageRef.getParameters().put('What',this.loaFselect1);
        }
        //pageRef.getParameters().put('CNO',this.campFselect);
        System.debug('this.campFselect1 '+this.campFselect1);
        //pageRef.getParameters().put('CNO',this.campFselect1);
        System.debug('this.loaFselect1 '+this.loaFselect1);
       // pageRef.getParameters().put('What',this.loaFselect1);
        if(ApexPages.currentPage().getParameters().get('acctkey')!=null){
            pageRef.getParameters().put('acctkey',ApexPages.currentPage().getParameters().get('acctkey'));
        }
        pageRef.setRedirect(true);
        return pageRef;
        }      
           
    public String getOmniturePageName() {
        return ALMPlusUtils.generateOmniturePageName('NewRepReport', null, userProflName);
    }
    
    private List<String> getReportFormattedString(String col, SObject down){
        List<String> otheEle = new List<String>();
        System.debug('COL  ::: '+col);
        try{
            if (col.contains(',')){
                    String data = '';
                    for (String name: col.split('\\,', 2) ){
                        if (name.contains('.')){
                            String Objname = name.split('\\.', 2)[0];
                            String fieldName = name.split('\\.', 2)[1];
                            String myname =  String.valueOf(down.getsObject(Objname).get(fieldName));
                            if (data.length() == 0){
                                data = myname;
                            }else {
                            	if (this.flsortOrder == 1){
                                	data = data +' '+myname;
                            	}else{
                            		data = myname +' '+data;
                            	}
                            	
                            }
                        }else {
                            data += String.valueOf(down.get(col));
                        }
                    }
                    otheEle.add(data);
               }else if (col.contains('.')) {
                    String Objname = col.split('\\.', 2)[0];
                    String fieldName = col.split('\\.', 2)[1];
                    try{
                        String val = String.valueOf(down.getsObject(Objname).get(fieldName));
                        if (val == '' || val == null){
                            otheEle.add('-');
                        }else{
                            otheEle.add(val);
                        }
                    }catch (Exception e){
                        otheEle.add('-');
                    }
              }else {
                    String val = String.valueOf(down.get(col));
                    if (col=='NXT_DUE_DT__c'||col == 'REP_APPT_DT__c' || col == 'REP_BRTH_DT__c' || col=='LDRSHP_TITL_LVL_NR__c'){
                        String datim = String.valueOf(down.get(col));
                        if (datim != '' && datim != null){
                           /* if (col == 'MRKT_ACCT_KEY__r.REP_APPT_DT__c'){
                                String im = datim.split(' ',2)[0];
                                val = im.split('-',3)[2]+'/'+im.split('-',3)[1]+'/'+im.split('-',3)[0];
                            }else if (col == 'MRKT_ACCT_KEY__r.REP_BRTH_DT__c'){
                                String im = datim.split(' ',2)[0];
                                val = im.split('-',3)[2]+'/'+im.split('-',3)[1];
                            }else */if (col == 'NXT_DUE_DT__c'){
                                String im = datim.split(' ',2)[0];
                                val = im.split('-',3)[2]+'/'+im.split('-',3)[1]+'/'+im.split('-',3)[0];
                            }else if(col=='LDRSHP_TITL_LVL_NR__c'){
                                if(m_LeaderTitles.size()>0){
                                    System.debug('In Here...');
                                    if(m_LeaderTitles.get(String.valueOf(down.get(col)))!=null){
                                        Leader_Title__c obj_Title = m_LeaderTitles.get(String.valueOf(down.get(col)));
                                        val=obj_Title.LCL_LDRSHP_TITL_CD__c;
                                    }else{
                                        val='';
                                    }       
                                }
                            }else {
                                val = datim.split(' ',2)[0];
                            }                            
                        }else {
                            val = datim;
                        }
                    }
                    else if(col == 'Genealogy_Level__c'){
                        
                        val = String.valueOf(Decimal.valueOf(val) - leaderGenLevel);
                        
                    }
                    if (val == '' || val == null){
                        otheEle.add('-');
                    }else{
                        otheEle.add(val);
                    }
             }
             
        }catch (Exception e){
            System.debug('inside catch'+e);   
            String errorId = ErrorHandler.handleError(e.getMessage());  
        }
        return otheEle;
    }
    
    // remote action method to udpate the Gen Level of the logged in user in ustom settings
    // Doing this in remote function, so that it can be called from the JS, just when the user clicks the 'Download All' link.
    // This method udpates the gen level, only when the download All link is clicked, so as to not use incorrect value of some other 
    // logged in user
      
    @RemoteAction
    public static void updateUserGenIndex(String almRepIndicator, String campaign, String marketId, String accNr){
        
        List<SObject> repRecords;
        Id loggedInUserId = UserInfo.getUserId();
        //String repPerfQuery='select Genealogy_Level__c from ' + almRepIndicator + ' where OPERTNL_CMPGN_NR__c =\'' + campaign + '\' and MRKT_ID__c =\'' + marketId + '\' and ACCT_NR__c=\'' + accNr + '\' limit 1'; 
        String repPerfQuery='select Genealogy_Level__c from ' + almRepIndicator + ' where FLD_SLS_CMPGN_NR__c =' + Double.valueOf(campaign) + ' and MRKT_ID__c =\'' + marketId + '\' and ACCT_NR__c=\'' + accNr + '\' limit 1';
        System.debug('===REP PERFORMANCE QUERY IS=====' +repPerfQuery);
        
        try{
            repRecords=Database.query(repPerfQuery);
        }
        catch(Exception e){
            System.debug('====Download All Gen Index Query Exception====' + e);
        }
        
        if(repRecords != null && repRecords.size()==1){
            // Now try to fetch the custom setting for this user
            DownloadAll_GenIndex__c genIndexCustomSetting = DownloadAll_GenIndex__c.getInstance(loggedInUserId);  
        
            if(genIndexCustomSetting == null || genIndexCustomSetting.Id == null){
                // Insert new one
                genIndexCustomSetting.SetupOwnerId = loggedInUserId;
            }
            Decimal genLevel=(Decimal)repRecords.get(0).get('Genealogy_Level__c');
            genIndexCustomSetting.Gen_Index__c=genLevel;
            genIndexCustomSetting.Market_Id__c=marketId;
            genIndexCustomSetting.SelectedCampaign__c=campaign;
            genIndexCustomSetting.Accnt_Nr__c=accNr;
            upsert genIndexCustomSetting;
        }
               
    }
    
     public string getNrtTimeStamp(){
        if(market.NRT_Enabled__c)
            return NRT_Utils.getLastUpdatedTimeStamp(market.Market_Id__c);
         else
            return '';
    }
}