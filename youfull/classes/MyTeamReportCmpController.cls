public class MyTeamReportCmpController {

    public ALM_Global_Settings__c globalConfig {get; set;}  //added by swarnava for Omniture
    public String Omniture_Suite_Name{get;set;}    //added by swarnava for Omniture
    public String MRKT_ID_ACCT_NR_KEY{get;set;}    //added by swarnava for Omniture
    public String loggeduserTitleLevelNbr{get;set;}  //added by swarnava for Omniture
    public String loggedProfileName{get;set;}
    public String currUsrLocale{get;set;} //added by Chandeep
    public boolean isMailPlan{get;set;} //added by swarnava
    public boolean Is_Brach_Enable{get;set;} //added by swarnava for MailPlan Branch Availability
    //Avon Market Id that is used to specify the Genealogy object, Report Config, and Report Filter that we are going to use
    private String m_MarketId = '-1';
    public String currcampaign{get;set;}
    public boolean toland{get;set;}
    public boolean nrtEnabled{get;set;}
    
    //Flag that tells methods and functions dealing with Genealogy that we are only Expanding, not Paging, Filtering, Text Searching or Sorting
    private Boolean m_IsExpanding = false;

    //Genealogy objects of the top user
    private SObject m_OriginalUserTeam = null;

    private Map<String, String> m_LeaderTitleMap = new Map<String, String>();
    
    //OriginalUserTeam  
    public SObject OriginalUserTeam { 
        get {
            
            return m_OriginalUserTeam;
        }
    }

    //Report Type
    public String ReportType { get; set; }
    
    //OnSimpleGenerationRowCallback
    public String OnSimpleGenerationRowCallback { get; set; }
    
    //TList
    public Boolean IsTList { get; set; }
    
    //Account whose downline we will load into our grid
    public String AccountNum { get; set; }
    public String almRepIndicator {get; set;}
    public String RootUplineAccountNum {get; set;}
    public Decimal LeaderLeftId {get; set;}
    public Decimal LeaderRightId {get; set;}
    
    //title level
    public String userTitleLevelNbr{get;set;}  //Changed from private to public for Omniture
    
    //TList Account Key
    public String TListAccountKey { get; set; }
    
    //Impersonation Account Key
    public String ImpersonationAccountKey { get; set; }
    
    //Language code that we are going to use on the page
    public String LangCD { get; set; }
    
    //Salesforce Market Id that is used to specify the Genealogy object, Report Config, and Report Filter that we are going to use
    public Id SFDC_MarketId { get; private set; }
    
    
    public String AvonMarketId {
        get {
            return m_MarketId;
        }
        set {
            m_MarketId = value;
        }
    }

    //YOU Date Format
    public String YOUDateFormat { get; private set; }
    
    //Id of Report Config that we are using in our report
    public Id ReportConfigId { get; private set; }
    
    //Report Title
    public String ReportTitle { get; private set; }
    
    // Comma Separator - added by Raktim on 6th Sept, 2013
    public String commaSepartr{get;set;}
    
    //Is My Team Report Type
    public Boolean IsMyTeamReportType {
    
        get {
        
            return MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType);  
        }
    }
    
    //Invalid Downline Access
    public Boolean InvalidDownlineAccess { get; private set; }
    
    //Last Error Id
    public String LastErrorId { get; private set; }
    

    public String AllLabel {
        
        get {
            
            String allLabel = this.AllLabel;
        
            if(allLabel == null) {
                allLabel = MTRConfigUtility.getJSFixedAllLabel();   
            }
            
            return allLabel;
        }
    }
    
    
    public String GenerationLabel {
        
        get {
            
            String genLabel = this.GenerationLabel;
            
            if(genLabel == null) {
                genLabel = MTRConfigUtility.getJSFixedGenerationLabel();    
            }
            
            return genLabel;
        }
    }
    
    
    public String FirstLastNameLabel {
        
        get {
            
            String firstLastNameLabel = this.FirstLastNameLabel;
            
            if(firstLastNameLabel == null) {
                firstLastNameLabel = MTRConfigUtility.getJSFixedFirstLastNameLabel();   
            }
            
            return firstLastNameLabel;
        }
    }
    
    // Added by Raktim on 25th Mar, 2013
   // public String ImgURLLabel {get; set;}//EoC
    
    
    public String LastFirstNameLabel {
        
        get {
            
            String lastFirstNameLabel = this.LastFirstNameLabel;
            
            if(lastFirstNameLabel == null) {
                lastFirstNameLabel = MTRConfigUtility.getJSFixedLastFirstNameLabel();   
            }
            
            return lastFirstNameLabel;
        }
    }
        
        
    public String TListLabel {
        
        get {
            
            String tListLabel = this.TListLabel;
            
            if(tListLabel == null) {
                tListLabel = MTRConfigUtility.getJSFixedTListLabel();   
            }
            
            return tListLabel;
        }
    }
    
    //Allows to access different SearchType polymorphically
    public MTRSearchOptions.MTRBaseSearch SearchType { get; set; }
    
    //Search Type for regular searches
    public MTRSearchOptions.MTRRegularSearch RegularSearchType { get; set; }
    
    //Search Type for text searches
    public MTRSearchOptions.MTRTextSearch TextSearchType { get; set; }
    
    //Search Type for filters
    public MTRSearchOptions.MTRFilterSearch FilterSearchType { get; set; }

    //Gets genealogy objects from the database, paged
    public MTRPagedSOQLBuilder PagedTeamSOQLBuilder { get; set; }
    
    //Gets genealogy objects from database, used in top user retrieval and row expanding
    public MTRSOQLBuilder TeamSOQLBuilder { get; set; }
    
    //Team ColumnOrderList
    public List<String> T_ColumnOrderList { get; private set; }
    
    //Personal Sales ColumnOrderList
    public List<String> PS_ColumnOrderList { get; private set; }
    
    //Team ColumnOrderMap
    public Map<String,MTRSOQLBuilder.ColumnInfo> T_ColumnInfoMap { get; private set; }

    //Personal Sales ColumnOrderMap
    public Map<String,MTRSOQLBuilder.ColumnInfo> PS_ColumnInfoMap { get; private set; }
        
        
    //Used as global variables for paging actions, row expansion, and search type
    public String AF_AccountNum { get; set; }
    public String AF_PageAction { get; set; }
    public String AF_SearchType { get; set; }
    
    //AF_RefreshMetadata
    public Boolean AF_RefreshMetadata { get; set; }
    
    
    public String HTTPBaseSalesforceUrl { get; private set; }
    
    //Flag that controls how the checkboxes are shown in the datagrid
    public String AllowFreeEmailsFor { get; private set; }
    
    //Email Allowed
    public Boolean EmailAllowed { get; private set; }
    
    //Download Info JSON
    public String DownloadInfoJSON { get; private set; }
    
    
    //*******
    
    public List<MTRPrintColumn> TeamPrintColumnList { get; set; }
    public List<MTRPrintColumn> MergePrintColumnList { get; set; }
    public List<MTRPrintColumn> PersonalPrintColumnList { get; set; }
    public List<MTRPrintColumn> BranchPrintColumnList { get; set; }
    public List<String> ColumnOrderList { get; set; }
    
    public transient List<GenealogyWrapper> GenealogyWrapperList  { get; set; } 
    
    public String m_Impersonated_UserName {get; set;}
    
    //*******
    
    public String MTReportURL;
    
    public String getMTReportURL() {
        if(MTReportURL == null || MTReportURL == '') 
            generateReportURL();
        return MTReportURL;
    }
    
    public void setMTReportURL(String strMTReportURL) {
        this.MTReportURL = strMTReportURL;
    }
    
    public String MTOReportURL;
    
    public String getMTOReportURL() {
        if(MTOReportURL == null || MTOReportURL == '')
            generateReportURL();
        return MTOReportURL;
    }
    
    public void setMTOReportURL(String strMTOReportURL) {
        this.MTOReportURL = strMTOReportURL;
    }
    
    public void generateReportURL() {
        System.debug('===generateReportURL entering===' );
        
        if(MTReportURL ==null || MTReportURL == '' || MTOReportURL ==null || MTOReportURL == '') {
            
            //String MTReportName = 'Title_Advancement_'+this.AvonMarketId;
            //String MTOReportName = 'My_Team_Order_Report_'+this.AvonMarketId;
            String MTReportName = 'Title_Advancement_Report_ALM_'+this.AvonMarketId;
            String MTOReportName = 'Team_Order_Report_ALM_'+this.AvonMarketId;
            System.debug('===MTReportName String===' + MTReportName);
            System.debug('===MTOReportName String==' + MTOReportName);
            List<Report> lstMTMTO = [SELECT ID, DeveloperName
                                     FROM Report
                                     WHERE DeveloperName = :MTReportName
                                        OR DeveloperName = :MTOReportName];
                                        
            if(lstMTMTO != null) {
                for(Report report : lstMTMTO) {
                    if(report.developerName == MTReportName)
                        this.MTReportURL = report.Id;
                    else if(report.developerName == MTOReportName)
                        this.MTOReportURL = report.Id;
                }
            }
        }
        
        System.debug('MTReportURL --> '+this.MTReportURL+' MTOReportURL --> '+this.MTOReportURL);
    }
    
    //*******
    
    //JSON result from either page, page action, and row expansion
    public transient String JSONResults { get; set; }    

    //Data Transport Object used to transfer Genealogy data from server-side to client-side
    private class GenealogyDTO {
        
        public GenealogyDTO() {
            
        }
        
        public List<GenealogyWrapper> GenTeamList { get; set; } 
    }
    
    public class MiniGenealogy {
        
        public MiniGenealogy() {
            
            this.AccountId = '';
            this.Generation = '0';
            this.IsExpanded = false;
        }
        
        public String AccountId { get; set; }
        public String Generation { get; set; }
        public Boolean IsExpanded { get; set; }
    }
    
    public class DownloadDTO {
        
        public DownloadDTO() {
            
            this.ReportTitle = '';
            this.ReportDownloadName = '';
            this.ReportType = '';
            this.MiniGenealogyList = new List<MiniGenealogy>();
            this.CampaignId = '0';
            this.ZGenAccountId = '-1';
            this.SFDCMarketId = null;
            this.LangCD = '';
            this.BranchCode = '';
            this.VisibleColumnNames = new List<String>();
            this.profileName = '';
            this.userTitleLevelNbr = '';
            
        }
        
        public String ReportTitle { get; set; }
        public String ReportDownloadName { get; set; }
        public String ReportType { get; set; }
        public List<MiniGenealogy> MiniGenealogyList { get; set; }
        public String CampaignId { get; set; }
        public String ZGenAccountId { get; set; }
        public Id SFDCMarketId { get; set; }
        public String LangCD { get; set; }
        public String BranchCode { get; set; }
        public List<String> VisibleColumnNames { get; set; }
        public String profileName { get; set; }
        public String userTitleLevelNbr { get; set; }
    }
    
    public PageReference errPage {get; set;}
    
    public MyTeamReportCmpController() {
   // this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();  //added by swarnava for Omniture
    }
    
    /*public String putcomma(String typ,String data)
  {
     if(typ=='Number' && data!=null)
     {    
         Decimal s = Decimal.valueOf(data);
          return String.valueOf(Math.floor(s).format());
     }
     else if(typ=='Currency' && data != null)
     {
         Decimal s = Decimal.valueOf(data);
         return String.valueOf(s.format());
     }
     else return data;
  }*/
    
    public String getLoadController() {
        System.debug('\n ######### getLoadController START ');
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();  //added by swarnava for Omniture
        
        //String imgUrl = System.Label.Email_MTURL;
        
        //ImgURLLabel = MTRConfigUtility.getJSFixedImgURLLabel();
        
        this.ValidateParameters();
        
        if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT) {
            if(IsTList==false)                                     //changed by swarnava for Team List
            this.ReportTitle = System.Label.My_Team;
            else
            this.ReportTitle = System.Label.T_List;
        }
        else if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
            if(IsTList==false)                                     //changed by swarnava for Team List Order
            this.ReportTitle = System.Label.My_Team_Orders;
            else
            this.ReportTitle = System.Label.T_ListOrder;
        }
        else if(this.ReportType == ALMConstants.REPORT_TYPE_G1APPT) {
            this.ReportTitle = System.Label.G1_Appointments;
        }
        else if(this.ReportType == ALMConstants.REPORT_TYPE_RISINGSTARS) {
            this.ReportTitle = System.Label.Rising_Stars;
        }
        else if(this.ReportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT) {
            if(IsTList==false)                                     //changed by raktim for Title Advancement
              this.ReportTitle = System.Label.Title_Advancement;
            else
              this.ReportTitle = System.Label.T_ListOrder;
        }
        
        this.YOUDateFormat = '';
        
        this.InvalidDownlineAccess = false;
        this.LastErrorId = '-1';
        
        this.AF_AccountNum = '-1';
        this.AF_PageAction = '';
        
        this.AF_RefreshMetadata = false;
        
        this.RegularSearchType = new MTRSearchOptions.MTRRegularSearch();
        this.TextSearchType = new MTRSearchOptions.MTRTextSearch();
        this.FilterSearchType = new MTRSearchOptions.MTRFilterSearch();
        
        //Decide which search type we are going to utilize based on query string availability
        if(isQueryStringParamValid(ApexPages.currentPage().getParameters().get('campaignId')) 
            && isQueryStringParamValid(ApexPages.currentPage().getParameters().get('who'))) {
            System.debug('\n ##### 1 ----- ');
            this.FilterSearchType.CampaignId = ApexPages.currentPage().getParameters().get('campaignId');
            this.FilterSearchType.Who = ApexPages.currentPage().getParameters().get('who');
            this.FilterSearchType.What = ApexPages.currentPage().getParameters().get('what');
            this.AF_SearchType = 'Filter';
            System.debug('\n ##### 1 ----- this.FilterSearchType.Who '+this.FilterSearchType.Who);
            System.debug('\n ##### 1 ----- this.FilterSearchType.What '+this.FilterSearchType.What);
        }
        else if(isQueryStringParamValid(ApexPages.currentPage().getParameters().get('textsearch')) && isQueryStringParamValid(ApexPages.currentPage().getParameters().get('tscriteria'))) {
            System.debug('\n ##### 2 ----- ');
            this.TextSearchType.TextSearch = ApexPages.currentPage().getParameters().get('textsearch');
            this.TextSearchType.TSCriteria = ApexPages.currentPage().getParameters().get('tscriteria');
            this.AF_SearchType = 'TextSearch';
        }
        else {
           //this.AF_SearchType = 'Regular';
            System.debug('\n ##### 3 ----- ');
            //Make Filter our default Search Type
            this.AF_SearchType = 'Filter';
        }
        
        //Make selected search type generic
        this.SearchType = MakeCurrentSearchTypeGeneric(this.AF_SearchType);
        
        this.SearchType.IsTList = this.IsTList;
        
        this.HTTPBaseSalesforceUrl = MTRConfigUtility.getHTTPBaseSalesforceUrl();
            
        this.AllowFreeEmailsFor = 'All';
    
        this.JSONResults = '';
        
        PopulateUserBasedObjects();
        
        DownloadDTO downloadDTO = new DownloadDTO();
        
        downloadDTO.ReportTitle = this.ReportTitle;
        downloadDTO.ReportType = this.ReportType;
        downloadDTO.ZGenAccountId = this.AccountNum;
        downloadDTO.SFDCMarketId = this.SFDC_MarketId;
        downloadDTO.userTitleLevelNbr = this.userTitleLevelNbr;
        downloadDTO.profileName = this.profileName;
        downloadDTO.LangCD = this.currUsrLocale; // Added by Raktim on 11th Sept, 2013 - Market Tag in Download
                                                 // and Print of Report issue. 
        
        this.DownloadInfoJSON = JSON.serialize(downloadDTO);
        
        Boolean impersonate = ImpersonationAccountKey == null ? false : true;
        DropdownComponentController dcc = new DropdownComponentController();
        String impAcctKey; 
        String paramWho;
        String reportTypeLocal = this.ReportType;
        
        //modified by GAZIZ start
        if(this.ImpersonationAccountKey != null) {
            impAcctKey = this.ImpersonationAccountKey.substring(2,this.ImpersonationAccountKey.length()); 
        }
            
        System.debug('========================== MyTeamReportCmpController. BEFORE PARAMETER READ');
        if (isQueryStringParamValid(ApexPages.currentPage().getParameters().get('who'))) {
            paramWho = ApexPages.currentPage().getParameters().get('who');
            if (paramWho.equalsIgnoreCase(ALMConstants.REPORT_FILTER_TYPE_G1SALESLEADERS)) {
                reportTypeLocal = ALMConstants.REPORT_TYPE_G1SALESLEADERS ;
            } else if (paramWho.equalsIgnoreCase(ALMConstants.REPORT_FILTER_TYPE_G1CANDIDATES)) {
                reportTypeLocal = ALMConstants.REPORT_TYPE_G1CANDIDATES ;
            }
        }
        System.debug('========================== MyTeamReportCmpController. AFTER PARAMETER READ');
        System.debug('========================== MyTeamReportCmpController. reportTypeLocal is :' + reportTypeLocal);
            
            
        //reportLinks = dcc.getReportLinks(this.AvonMarketId, this.profileName, this.userTitleLevelNbr, impersonate, impAcctKey, 'My_Team'); 
            reportLinks = dcc.getReportLinks(this.AvonMarketId, this.profileName, this.userTitleLevelNbr, impersonate, impAcctKey, reportTypeLocal); // modified by Gaziz
        //modified by GAZIZ end 
        
        return '';
    }
    
    public void ValidateParameters() {
        
        if(this.IsTList && isQueryStringParamValid(ApexPages.currentPage().getParameters().get('accountId'))) {
            this.TListAccountKey = ApexPages.currentPage().getParameters().get('accountId');
        }
        
        if(isQueryStringParamValid(ApexPages.currentPage().getParameters().get('acctKey'))) {
            this.ImpersonationAccountKey = ApexPages.currentPage().getParameters().get('acctKey');
        }
        
        if(!MTRConfigUtility.IsReportTypeSupported(this.ReportType)) {
            throw new ArgumentException('MyTeamReportCmpController::ValidateParameters Exception Error=The specified ReportType is not supported.');
        }
    
        if(MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) && this.OnSimpleGenerationRowCallback != null && this.OnSimpleGenerationRowCallback.length() > 0) {
            throw new ArgumentException('MyTeamReportCmpController::ValidateParameters Exception Error=The OnSimpleGenerationRowCallback callback function is not available for this ReportType.');
        }
        
        if(!MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) && (this.OnSimpleGenerationRowCallback == null || this.OnSimpleGenerationRowCallback.length() == 0)) {
            throw new ArgumentException('MyTeamReportCmpController::ValidateParameters Exception Error=A callback function is required for OnSimpleGenerationRowCallback is required for this ReportType.');
        }
    }
    
    public Boolean isQueryStringParamValid(String param) {
        
        return (param != null && param.length() > 0);
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
    
     public void revokeAccountAccess()
    {
        /*PermissionSet ps=[Select Id From PermissionSet where Name='View_All'];
        List<PermissionSetAssignment> psaQuery=new List<PermissionSetAssignment>();
        psaQuery=[Select Id From PermissionSetAssignment where AssigneeId=:UserInfo.getUserId() and PermissionSetId=:ps.Id ];
        if(psaQuery.size()>0){
            delete psaQuery;
        }*/
    
    }
    
    private String ValidateAccessToDownline(MTRSOQLBuilder mtrSOQLBuilder, String acctKey) {
        
        User user = [SELECT Id, ACCT_NR__c, Profile.Name, MRKT_ID__c, DFALT_DIV_NM__c, DFALT_ZONE_CD__c FROM User
            WHERE Id=:UserInfo.getUserId() LIMIT 1];
            
        MTRSOQLBuilder.CampaignRetrievalDTO campaignRetrievalDTO = mtrSOQLBuilder.GetCampaignValues();
        String campaign = String.valueOf(campaignRetrievalDTO.CampaignValues.CurrentCampaign);
        String errorId = '-1';


    // Old logic, replaced by Fay on 2/2/2013 to share the logic used in the landing page  
    //if(!GenealogySOQLBuilder.isAcctNrInDownline(user.ACCT_NR__c, acctKey, String.valueOf(campaignRetrievalDTO.CampaignValues.CurrentCampaign), this.AvonMarketId)){
  
    // Share the logic from the landing page, checks validity for Zone/Division, as well as for downline  
    if (!LandingPageUtils.isImpersonationValid(user.Profile.Name, user.MRKT_ID__c, user.DFALT_ZONE_CD__c, user.DFALT_DIV_NM__c, user.ACCT_NR__c, campaign, acctKey)) {        
            
             errorId = ErrorHandler.handleError('This downline cannot be accessed.');           
        }
        
        return errorId;
    }
    
    //Loads top-level user information and intialized SOQLBuilder classes
    private void PopulateUserBasedObjects() {
   
        List<SObject> teamList = null;
        MTRSearchOptions.MTRRegularSearch regularSearchType = new MTRSearchOptions.MTRRegularSearch();
        
        LoadUserObject();       
        LoadSFDCMarketData();
   
        system.debug('report type --> '+ this.ReportType);
   
        PagedTeamSOQLBuilder = new MTRPagedSOQLBuilder(this.SFDC_MarketId, this.ReportType, this.profileName, this.userTitleLevelNbr, this.LangCD);
        
        TeamSOQLBuilder = new MTRSOQLBuilder(this.SFDC_MarketId, this.ReportType, this.profileName, this.userTitleLevelNbr, this.LangCD);
        PagedTeamSOQLBuilder.isTList=IsTList;//added by swarnava for Team List
        TeamSOQLBuilder.isTList=IsTList;//added by swarnava for Team List 
 
        //Load top-level user
        regularSearchType.AccountNumber = this.AccountNum;
        regularSearchType.IsTList = this.IsTList;
        
        TeamSOQLBuilder.SetSearchType(regularSearchType);
    
        teamList = TeamSOQLBuilder.GetZeroGenerationRecords();

        this.ReportConfigId = TeamSOQLBuilder.ReportConfigId;
        
        if(teamList.size() == 0) {
            throw new ArgumentException('MyTeamReportCmpController::LoadUserInfo Exception Error=No Main Account was found.');
        }
        else {
            m_OriginalUserTeam = teamList[0];
        }
        
        this.RootUplineAccountNum = String.valueOf(m_OriginalUserTeam.get('ROOT_UPLN_ACCT_NR__c'));
        this.LeaderLeftId = (Decimal)(m_OriginalUserTeam.get('LFT_ND_ID__c'));
        this.LeaderRightId = (Decimal)(m_OriginalUserTeam.get('RGT_ND_ID__c'));
        
    }
    
    private void LoadUserObject() {
        
        List<User> userList = new List<User>();
        
        //SA: forced to do 1 additional soql because acctkey only contains account number (without market code)
        User loggedInUser = [   SELECT Profile.Name, Name, Id, ACCT_NR__c, MRKT_ID__c, LanguageLocaleKey,LocaleSidKey, LDRSHP_TITL_LVL_NBR__c ,MRKT_ID_ACCT_NR_KEY__c
                                FROM User
                                WHERE Id=:UserInfo.getUserId() LIMIT 1];
        
        String mktId = loggedInUser.MRKT_ID__c;
        this.MRKT_ID_ACCT_NR_KEY = loggedInUser.MRKT_ID_ACCT_NR_KEY__c;  //added by swarnava for Omniture
        this.loggeduserTitleLevelNbr=loggedInUser.LDRSHP_TITL_LVL_NBR__c; //added by swarnava for Omniture
        this.loggedProfileName=loggedInUser.Profile.Name;  //added by swarnava for Omniture
        this.currUsrLocale = loggedInUser.LocaleSidKey;  
        
        // Comma Separator Change - added by Raktim on 6th Sept, 2013 START
        System.debug('\n ------ MyTeamReportCmpController. currUsrLocale '+loggedInUser.LocaleSidKey+', LanguageLocaleKey '+loggedInUser.LanguageLocaleKey);
        commaSepartr = YOUUtil.getLocaleSeparator(this.currUsrLocale)[0];
        System.debug('\n ------ MyTeamReportCmpController. commaSepartr '+commaSepartr);
        // Comma Separator Change - added by Raktim on 6th Sept, 2013 END
        
          
        if(this.IsTList && this.TListAccountKey != null) {
            userList = [SELECT Profile.Name, Id, Name, ACCT_NR__c, MRKT_ID__c, LanguageLocaleKey, LDRSHP_TITL_LVL_NBR__c,MRKT_ID_ACCT_NR_KEY__c FROM User
            WHERE MRKT_ID_ACCT_NR_KEY__c=:this.TListAccountKey LIMIT 1];
        }
        else if(this.ImpersonationAccountKey != null) {
            userList = [SELECT Profile.Name, Id, Name, ACCT_NR__c, MRKT_ID__c, LanguageLocaleKey, LDRSHP_TITL_LVL_NBR__c,MRKT_ID_ACCT_NR_KEY__c FROM User
            WHERE MRKT_ID_ACCT_NR_KEY__c=:(mktId + this.ImpersonationAccountKey) LIMIT 1];
        }
        else {
            userList.add(loggedInUser); 
        }
        
        if(userList.size() == 0) {
            throw new InvalidOperationException('MyTeamReportCmpController::LoadUserObject Exception Error=Could not find the specified user account. TListAccountKey: ' + 
                                                this.TListAccountKey + ' ImpersonationAccountKey: ' + this.ImpersonationAccountKey);
        }
        
        this.profileName = userList[0].Profile.Name;
        this.m_Impersonated_UserName = userList[0].Name;
        this.AccountNum = userList[0].ACCT_NR__c;
        this.AvonMarketId = userList[0].MRKT_ID__c;
        this.LangCD = userList[0].LanguageLocaleKey;
        this.userTitleLevelNbr = userList[0].LDRSHP_TITL_LVL_NBR__c;
        
    }
    
    public String profileName{get;set;}    //Changed by swarnava from private to public for omniture
    
    private void LoadSFDCMarketData() {
        
        Market__c market = [SELECT Id, Market_Id__c,CMPGN_NR__c, Allow_Free_Emails_For__c, Mail_Plan_Enabled__c,MailPlan_LndingPg_Deflt__c, Allow_Freeform_Email__c,Omniture_RSID__c, Omniture_Suite_Name__c, ALM_Rep_Indicator__c, Is_Branch__c,NRT_Enabled__c 
                              FROM Market__c 
                             WHERE Market_Id__c=:this.AvonMarketId LIMIT 1];
        Profile profile = null;
        
        this.SFDC_MarketId = market.Id;
        this.isMailPlan=market.Mail_Plan_Enabled__c;
        this.almRepIndicator = market.ALM_Rep_Indicator__c;
        this.AllowFreeEmailsFor = market.Allow_Free_Emails_For__c;
        this.Omniture_Suite_Name = market.Omniture_Suite_Name__c;  //added by swarnava for Omniture
        this.Is_Brach_Enable=market.Is_Branch__c;   //added by swarnava for MailPlan
        this.currcampaign=market.CMPGN_NR__c;
        this.toland=market.MailPlan_LndingPg_Deflt__c;
        this.nrtEnabled = market.NRT_Enabled__c;
        System.debug('Is_Branch_Enable-->'+this.Is_Brach_Enable);
        
        if(market.Allow_Freeform_Email__c != null && market.Allow_Freeform_Email__c.length() > 0) {
            //commented out by SA, 6/18/2012, profileName should be initialized in the LoadUserObject() method
            //profile = [SELECT Name FROM Profile WHERE Id = :Userinfo.getProfileId()];
            
            //this.profileName = profile.Name;
            
            this.EmailAllowed = MTRConfigUtility.MultiPicklistContains(market.Allow_Freeform_Email__c, this.profileName);
        }
        

        YOU_Date_Format__c ydf = YOU_Date_Format__c.getInstance();
        
        if(ydf != null) {
            this.YOUDateFormat = ydf.Date_Format__c;
        }
    }
    
    //Loads Genealogy objects from database for paging, page action, and row expansion
    private GenealogyDTO LoadGenealogy(MTRSearchOptions.MTRBaseSearch searchType) {
        System.debug('\n ########## 22222222222222222 LoadGenealogy');
        List<SObject> teamList = null;
        List<SObject> zgList = null;
        GenealogyDTO genealogyDTO = new GenealogyDTO();
        TransformMTRGenealogyList transformMTRGenealogyList = new TransformMTRGenealogyList();
        MTRSOQLBuilder mtrSOQLBuilder = null;
        
        System.debug('searchType --> '+searchType);
        transformMTRGenealogyList.SearchForDownline = searchType.SearchForDownline;

        this.InvalidDownlineAccess = false;
        this.LastErrorId = '-1';
        
        //Not expanding, so we are going to use paging SOQLBuilder and add top-level user to beginning of array
        if(!m_IsExpanding) {
            System.debug('\n ########## 22222222222222222 m_IsExpanding ');
            if(searchType.ReverseNameSortColumnName != null && searchType.ReverseNameSortColumnName.length() > 0) {
        
                PagedTeamSOQLBuilder.Reset();
            }
            
            PagedTeamSOQLBuilder.SetSearchType(searchType);
            
            teamList = new List<SObject>();

          this.LastErrorId = this.ValidateAccessToDownline(PagedTeamSOQLBuilder, this.AccountNum);
       
            if(this.LastErrorId != '-1') {
                this.InvalidDownlineAccess = true;  
            }

            if(!this.InvalidDownlineAccess) {
                System.debug('\n ########## 1111111111111');
                if(PagedTeamSOQLBuilder.CampaignTypeChanged) {
                    try{
                        zgList = PagedTeamSOQLBuilder.GetZeroGenerationRecords();
                        
                        m_OriginalUserTeam = zgList[0];
                        
                    }catch(Exception e){
                        System.Debug('\n Exception Caught in MyTeamReportCmpController \n'+e);
                        
                        String errorId = ErrorHandler.handleError('NO RECORD FOUND For Campaign');
                        errPage = Page.ErrorPage;
                        errPage.getParameters().put('errId',errorId);
                    }
               
                    /*
                    if(zgList.size() == 0) {
                        throw new ArgumentException('MyTeamReportCmpController::LoadGenealogy Exception Error=No Main Account was found.');
                    }
                    else {
                        m_OriginalUserTeam = zgList[0];
                    }*/
                }
                
                if(PagedTeamSOQLBuilder.leaderInfo == null || PagedTeamSOQLBuilder.leaderInfo.accNo != searchType.AccountNumber){
                    PagedTeamSOQLBuilder.GetZeroGenerationRecords();
                }
                
                teamList.addAll(PagedTeamSOQLBuilder.GetRecords());
                
                if(m_OriginalUserTeam != null) {
                    
                    if(teamList.size() == 0) {
                        
                        teamList.add(m_OriginalUserTeam);
                    }
                    else {
                        
                        teamList.add(0, m_OriginalUserTeam);
                    }
                }
            }
            
            searchType.ReverseNameSortColumnName = '';
            mtrSOQLBuilder = PagedTeamSOQLBuilder;
        }
        else {
            System.debug('\n ########## 3333333333333333');
            if(!MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType)) {
                throw new InvalidOperationException('MyTeamReportCmpController::LoadGenealogy Exception Error=Genealogy Expansion is not supported with this ReportType.'); 
            }
            
            //Else, let us use the non-paging SQLBuilder
            
            TeamSOQLBuilder.MainAccountNumber = this.AccountNum;
            
            TeamSOQLBuilder.SetSearchType(searchType);
            
            if(TeamSOQLBuilder.leaderInfo == null || TeamSOQLBuilder.leaderInfo.accNo != searchType.AccountNumber){
                TeamSOQLBuilder.GetZeroGenerationRecords();
            }
            
            teamList = TeamSOQLBuilder.GetRecords();
    
            mtrSOQLBuilder = TeamSOQLBuilder;
        }
        
        if(mtrSOQLBuilder.AdjustedSortField != null && mtrSOQLBuilder.AdjustedSortField.length() > 0) {
            searchType.SortBy = mtrSOQLBuilder.AdjustedSortField;
        }

        //system.debug(mtrSOQLBuilder.SearchType.AccountNumber);
        system.debug(':::::mtrSOQLBuilder.leaderInfo.accNo:::::' + mtrSOQLBuilder.leaderInfo.accNo);
        system.debug(':::::searchType.AccountNumber:::::' + searchType.AccountNumber);

        // At this point, after GetRecords Method of SOQLBuilder, the leaderInfo should be populated
        system.debug(':::::::mtrSOQLBuilder.leaderInfo:::::::' + mtrSOQLBuilder.leaderInfo);
        
        // Udpate the Left and Right indexes based on the leaderInfo
        this.LeaderLeftId  = mtrSOQLBuilder.leaderInfo.leftId;
        this.LeaderRightId = mtrSOQLBuilder.leaderInfo.rightId;

        transformMTRGenealogyList.GenealogyList = MTRConfigUtility.ConvertToWrapperNew(teamList, mtrSOQLBuilder.FullyQualifiedColumnNameSet, this.AvonMarketId, mtrSOQLBuilder.SelectedNameLabel, mtrSOQLBuilder.IsFutureOrPresentCampaign, mtrSOQLBuilder.leaderInfo.genLevel);
        /*System.debug('\n ####### transformMTRGenealogyList.GenealogyList '+transformMTRGenealogyList.GenealogyList.size());
        for(GenealogyWrapper gen : transformMTRGenealogyList.GenealogyList){
            System.debug('\n ####### transformMTRGenealogyList.GenealogyList LOOP INSIDE');
            System.debug('\n ####### transformMTRGenealogyList.GenealogyList LOOP INSIDE NAME >> '+gen.Name);
            
        }*/
        transformMTRGenealogyList.ColumnInfoMap = mtrSOQLBuilder.ColumnInfoMap;
        transformMTRGenealogyList.ColumnInfoMap2 = mtrSOQLBuilder.ColumnInfoMap2;
        transformMTRGenealogyList.ColumnOrderList = mtrSOQLBuilder.ColumnOrderList;
        transformMTRGenealogyList.ColumnOrderList2 = mtrSOQLBuilder.ColumnOrderList2;
        transformMTRGenealogyList.FullyQualifiedColumnNameSet = mtrSOQLBuilder.FullyQualifiedColumnNameSet;
        transformMTRGenealogyList.IsTList = this.IsTList;
        transformMTRGenealogyList.IncludeRemovedReps = mtrSOQLBuilder.IncludeRemovedReps;
        
        transformMTRGenealogyList.IncludedMergeColumnNameSet.addAll(mtrSOQLBuilder.PersonalMergeColumnNameSet);
        /*
        for(GenealogyWrapper gen : transformMTRGenealogyList.GenealogyList){
            System.debug('\n ####### transformMTRGenealogyList.GenealogyList 111 LOOP INSIDE');
            System.debug('\n ####### transformMTRGenealogyList.GenealogyList 111 LOOP INSIDE NAME >> '+gen.Name);
            
        }    */                
        
        if(!m_IsExpanding && this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
    
            transformMTRGenealogyList.IncludeBranchSummary = true;
            transformMTRGenealogyList.BranchSummary = mtrSOQLBuilder.BranchSummary; 
        }
            
        transformMTRGenealogyList.ExpandAll = true;
        
        transformMTRGenealogyList.DoTransformation();
        
        
        if(!m_IsExpanding && this.AF_RefreshMetadata) {
            
            this.T_ColumnOrderList = this.PagedTeamSOQLBuilder.ColumnOrderList;
            this.PS_ColumnOrderList = this.PagedTeamSOQLBuilder.ColumnOrderList2;
            
            this.T_ColumnInfoMap = this.PagedTeamSOQLBuilder.ColumnInfoMap;
            this.PS_ColumnInfoMap = this.PagedTeamSOQLBuilder.ColumnInfoMap2;
        }
        else {
            this.T_ColumnOrderList = new List<String>();
            this.PS_ColumnOrderList = new List<String>();
            
            this.T_ColumnInfoMap = new Map<String,MTRSOQLBuilder.ColumnInfo>();
            this.PS_ColumnInfoMap = new Map<String,MTRSOQLBuilder.ColumnInfo>();
        }
        
        this.TeamPrintColumnList = transformMTRGenealogyList.TeamPrintColumnList;
        this.MergePrintColumnList = transformMTRGenealogyList.MergePrintColumnList;
        this.PersonalPrintColumnList = transformMTRGenealogyList.PersonalPrintColumnList;
        this.BranchPrintColumnList = transformMTRGenealogyList.BranchPrintColumnList;
        this.ColumnOrderList = transformMTRGenealogyList.ReturnColumnOrderList;
        this.GenealogyWrapperList = transformMTRGenealogyList.ReturnGenealogyList;
        /*for(GenealogyWrapper gen : transformMTRGenealogyList.GenealogyList){
            System.debug('\n ####### GenealogyWrapperList 111 LOOP INSIDE');
            System.debug('\n ####### GenealogyWrapperList 111 LOOP INSIDE NAME >> '+gen.Name);
            
        } */
        
        
        // For Encoding Logic from :: to ' added by Nalin Kumar
        if(GenealogyWrapperList.size()>0)
        { 
        String InterimName;
        String InterimSponsor;
        for(GenealogyWrapper gen : GenealogyWrapperList){
            
            InterimName=String.valueOf(gen.Name);
            InterimSponsor=String.valueOf(gen.Sponsor);
            InterimName=InterimName.replace('\'','::');
            InterimSponsor=InterimSponsor.replace('\'','::');
            gen.Name=InterimName;
            gen.Sponsor=InterimSponsor;
        }
        
        for(MTRPrintColumn mteam : TeamPrintColumnList)
        {
         System.debug('\n ####### TeamPrintColumnList info '+mteam);
        } 
        }                
        //
        System.debug('GenealogyWrapperList size-->'+GenealogyWrapperList.size());
        System.debug('GenealogyWrapperList --> '+GenealogyWrapperList);
        
        genealogyDTO.GenTeamList = null;
        
        return genealogyDTO;
    }
    
    //JSON string for paged results
    private String GeneratePagedJSONResultString(String jsonString) {
        
        System.debug('jsonString:->'+jsonString); 
        return '{\"Records\":' + jsonString + ', \"PageNumber\": ' + PagedTeamSOQLBuilder.PageNumber + ', \"PageTotal\": '+ PagedTeamSOQLBuilder.PageTotal +', \"HasNext\": '+ PagedTeamSOQLBuilder.HasNext +', \"HasPrevious\": ' + PagedTeamSOQLBuilder.HasPrevious + ' , \"TotalRecords\": ' + PagedTeamSOQLBuilder.TotalRecords + ', \"CampaignTypeChanged\":' + PagedTeamSOQLBuilder.CampaignTypeChanged + ', \"IsDrillable\": ' + PagedTeamSOQLBuilder.IsDrillable + ', \"IsSortable\": '+ PagedTeamSOQLBuilder.IsSortable +', \"DefaultSortColumn\": \"'+ PagedTeamSOQLBuilder.DefaultSortColumn +'\", \"SortIsAscending\": '+ PagedTeamSOQLBuilder.SortIsAscending +', \"LastErrorId\": \"' + this.LastErrorId  + '\"}';
    }
    
    //JSON string for last error Id only
    private String GenerateLastErrorJSONResultString() {
        
        return '{\"LastErrorId\": \"' + this.LastErrorId  + '\"}';
    }
    
    private MTRSearchOptions.MTRBaseSearch MakeCurrentSearchTypeGeneric(String stype) {
        System.debug('\n ##### MakeCurrentSearchTypeGeneric stype '+stype);
        MTRSearchOptions.MTRBaseSearch searchType = null;
        
        stype = stype.toLowerCase();
        
        if(stype == 'regular') {
            searchType = this.RegularSearchType; 
        }
        else if(stype == 'textsearch') {
            searchType = this.TextSearchType;
        }
        else if(stype == 'filter') {
            searchType = this.FilterSearchType;
        }
        else {
            throw new ArgumentException('MyTeamReportCmpController::MakeCurrentSearchTypeGeneric Exception Error=The specified Search Type is not valid.');
        }
        System.debug('\n ##### MakeCurrentSearchTypeGeneric searchType '+searchType);
        return searchType;
    }

    //Genealogy page action for paging, used by regular, text, and filtering search
    public PageReference GetPagedGenealogy() {
        System.debug('\n ######## GetPagedGenealogy 1 ');
        m_IsExpanding = false;
   
        this.SearchType = MakeCurrentSearchTypeGeneric(this.AF_SearchType);
        
        if(this.AF_SearchType == 'TextSearch') {
            System.debug('\n ######## GetPagedGenealogy TextSearch ');
            Boolean isValid = true;
            
            if(TextSearchType.TextSearch.trim().length() == 0) {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.Err_Msg_Search_Keyword));
                isValid = false;
            }
            else if(TextSearchType.TSCriteria == 'AccountNumber' && TextSearchType.TextSearch.length() < 3) {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.Err_Msg_Min_Acct_Num));
                isValid = false;
            }
            else if(TextSearchType.TSCriteria == 'Name' && TextSearchType.TextSearch.length() <= 2) {

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.Err_Msg_Min_Chars));
                isValid = false;                
            }
            
            if(!isValid) {
                return null;
            }
        }
        
        this.SearchType.IsTList = this.IsTList;
        System.debug('\n ######## GetPagedGenealogy 2 ');
        GenealogyDTO genealogyDTO = LoadGenealogy(this.SearchType);
        System.debug('\n ######## GetPagedGenealogy 3 ');
        if(this.InvalidDownlineAccess) {
            this.JSONResults = GenerateLastErrorJSONResultString();
        }
        else {
            
            String jsonString = JSON.serialize(genealogyDTO);
            System.debug('jsonString after actionFunction:'+jsonString);
            this.JSONResults = GeneratePagedJSONResultString(jsonString);
        }
		return null;
    }
    
    //Genealogy page action for page number action
    //added by Supriyo on March 19, 2013 for TA/ MTO pagination change
    public PageReference DoGenealogyPageNumberAction() {
        this.AF_RefreshMetadata = false;
        
        m_IsExpanding = false;
        
        String pageNumber = this.AF_PageAction.toLowerCase();
        
        PagedTeamSOQLBuilder.setpageNumber(Integer.valueOf(pageNumber));
        System.debug('DoGenealogyPageNumberAction PagedTeamSOQLBuilder --> '+pageNumber);
        
        this.SearchType.ReverseNameSortColumnName = '';
        
        GenealogyDTO genealogyDTO = LoadGenealogy(this.SearchType);
             
        if(this.InvalidDownlineAccess) {
            this.JSONResults = GenerateLastErrorJSONResultString();
        }
        else {
            
            String jsonString = JSON.serialize(genealogyDTO);
            
            this.JSONResults = GeneratePagedJSONResultString(jsonString);
        }
        
        return null;
    }

    //Genealogy page action for paging action
    public PageReference DoGenealogyPageAction() {
        
        this.AF_RefreshMetadata = false;
        
        m_IsExpanding = false;
        
        String pageAction = this.AF_PageAction.toLowerCase();
  
        if(pageAction == 'first') {
            PagedTeamSOQLBuilder.First();
        }
        else if(pageAction == 'last') {
            PagedTeamSOQLBuilder.Last();
        }
        else if(pageAction == 'previous') {
            PagedTeamSOQLBuilder.Previous();
        }
        else if(pageAction == 'next') {
            PagedTeamSOQLBuilder.Next();
        }
        else {
            throw new ArgumentException('MyTeamReportCmpController::DoGenealogyPageAction Exception Error=The specified PageAction is not valid.');
        }
   
        this.SearchType.ReverseNameSortColumnName = '';
        
        GenealogyDTO genealogyDTO = LoadGenealogy(this.SearchType);
             
        if(this.InvalidDownlineAccess) {
            this.JSONResults = GenerateLastErrorJSONResultString();
        }
        else {
            
            String jsonString = JSON.serialize(genealogyDTO);
            
            this.JSONResults = GeneratePagedJSONResultString(jsonString);
        }
        
        return null;
    }
    
    //Genealogy page action for row expansion
    public PageReference ExpandGenealogy() {
        
        if(!MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType)) {
            throw new InvalidOperationException('MyTeamReportCmpController::ExpandGenealogy Exception Error=Genealogy Expansion is not supported with this ReportType.');   
        }
        
        this.AF_RefreshMetadata = false;
        
        m_IsExpanding = true;
        
        this.SearchType = MakeCurrentSearchTypeGeneric(this.AF_SearchType);
        
        MTRSearchOptions.MTRFilterSearch filterSearchType = new MTRSearchOptions.MTRFilterSearch();
   
        filterSearchType.CampaignId = MTRSOQLBuilder.MakeCampaignKey(this.PagedTeamSOQLBuilder.SelectedPreviousCampaign, this.PagedTeamSOQLBuilder.SelectedCurrentCampaign);
        filterSearchType.AccountNumber = this.AF_AccountNum;
        System.debug('AF_AccountNum --> '+AF_AccountNum);
        filterSearchType.SearchForDownline = true;
        filterSearchType.IsTList = this.IsTList;
        filterSearchType.SortBy = this.SearchType.SortBy;
        filterSearchType.IsAscending = this.SearchType.IsAscending;
        filterSearchType.ReverseNameSortColumnName = this.SearchType.ReverseNameSortColumnName;
        
        GenealogyDTO genealogyDTO = LoadGenealogy(filterSearchType);
        
        String jsonString = JSON.serialize(genealogyDTO);
        
        this.JSONResults = jsonString;
        
        return null;
    }
    public List<SelectOption> reportLinks { get; set; }   
    
    /*
    //returns select options for the dropdown
    public List<SelectOption> reportLinks {
        get {
            if(reportLinks == null){
                Boolean impersonate = ImpersonationAccountKey == null ? false : true;
                DropdownComponentController dcc = new DropdownComponentController();
                reportLinks = dcc.getReportLinks(this.AvonMarketId, this.profileName, this.userTitleLevelNbr, impersonate, this.ImpersonationAccountKey);           
            }
            //throw new ArgumentException('reportLinks: ' + reportLinks + ' profileName: ' + profileName + ' userTitleLevelNbr: ' + userTitleLevelNbr + ' ImpersonationAccountKey: ' + ImpersonationAccountKey + ' AvonMarketId: '  + AvonMarketId);
            return reportLinks;
        }
        set;
    }*/
    
    public String attachmentId { get; set;}
    
    
    public PageReference computeAttachmentId() {
            //if(attachmentId == null){
                attachmentId = 'NONE';
                System.debug('PagedTeamSOQLBuilder.AllDownlineCountTotal: ' + PagedTeamSOQLBuilder.AllDownlineCountTotal);
                System.debug('PagedTeamSOQLBuilder.MaxPageLimit: ' + PagedTeamSOQLBuilder.MaxPageLimit);
                if(PagedTeamSOQLBuilder.AllDownlineCountTotal > PagedTeamSOQLBuilder.MaxPageLimit){
                    List<CDW_Market_Report__c> mktReports = [   SELECT  Name, Report_Code__c, User_Type_Index__c 
                                                                FROM    CDW_Market_Report__c 
                                                                WHERE   Market__r.Market_Id__c = : this.AvonMarketId 
                                                                        AND name= :ALMConstants.BRANCH_REPORT 
                                                                        AND Profile__c = :this.profileName LIMIT 1 ];                                                               
                                                                                        
                    System.debug('mktReports: ' + mktReports);
                    if(mktReports.size() > 0 ){
                        String currentCmpgnNum = String.valueOf(PagedTeamSOQLBuilder.GetCampaignValues().CampaignValues.CurrentCampaign);
                        String fileName =   mktReports[0].User_Type_Index__c + this.AccountNum + '-' + 
                                            mktReports[0].Report_Code__c + '-' + 
                                            formatCampaignForCDWReport(currentCmpgnNum) + '.xls'; //TODO: make the naming convention configuration driven!
                        
                        System.debug('fileName: ' + fileName);
                        List<Attachment> attachments = [select id from Attachment
                                                            where name = :fileName 
                                                            and parent.id = :mktReports[0].id 
                                                            order by CreatedDate desc
                                                            limit 1];
                        if(attachments.size() > 0){
                            attachmentId = attachments[0].id;
                        }
                        System.debug('attachmentId: ' + attachmentId);                      
                    }
                }
            //}
            
            return null; 
    }
    
    //cmpgnNum has format of 201203, method returns 0312
    private String formatCampaignForCDWReport(String cmpgnNum) {
        Integer len = cmpgnNum.length();
        return cmpgnNum.substring(len-2,len) + cmpgnNum.substring(2,4);
    }
    public String getOmniturePageName() {                //added by swarnava for Omniture
        return ALMPlusUtils.generateOmniturePageName((IsTList)?ReportType+'TList':ReportType, null, profileName);
    }          //added for Omniture
    /*
    public PageReference getAttachmentId() {
        attachmentId = '00PZ0000000UGgI';
        return null;
    }
   */
   
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
    
    public string getBatchTimeStamp(){
    	return NRT_Utils.getLastUpdatedTimeStampBatch(AvonMarketId);
    }
    
    public string getNrtTimeStamp(){
    	return NRT_Utils.getLastUpdatedTimeStamp(AvonMarketId);
    }
    
}