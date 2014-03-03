public virtual class MTRSOQLBuilder {

    //Overall QuerySet Limit for query
    protected Integer OVERALL_QUERYSET_LIMIT = -1;
    
    //Report Type
    private String m_ReportType = '';
        
    //Lang CD for Report Config
    private String m_LangCD = '';
    
    //SFDC Market Id used to get Report Config and Genealogy objects from database
    private Id m_SFDCMarketId = null;
    
    // Rep Indicator of the Market
    private String marketRepIndicator;
    
    //Main Account Number
    private String m_MainAccountNumber = '-1';
    
    //Page Size
    private Integer m_PageSize = 0;
    
    //Cached query columns from Report Config retrieval function
    private String m_CachedQueryColumns = '';
    
    //Calendar
    private Calendar__c m_Calendar = null;
    
    //Badge Title that can influence the query output
    protected String BadgeTitle { get; set; }
    
    //Sponsor Qualifying Order Amount
    protected Decimal SponsorQualifyingOrderAmount { get; set; }

    //Search Type
    protected MTRSearchOptions.MTRBaseSearch SearchType { get; set; }
    
    //Flag that indicates to remove Report Config's cached query columns next time when GetRecords is called
    //Used with SFDCMarketId
    protected Boolean ReportConfigIsModified { get; set; }
    
    //Page Size Is Modified
    protected Boolean PageSizeIsModified { get; set; }
    
    //Order Criteria
    protected String OrderCriteria { get; set; }
    
    //SA market tag labels
    protected Map<String, String> mktTagsMap;
    
        
    public boolean isTList=false;//added by swarnava for Team List

    public LeaderInfo leaderInfo {get; set;}

    public class LeaderInfo {
        
        public String accNo{get; set;}
        public Decimal leftId{get; set;}
        public Decimal rightId{get; set;}
        public Decimal genLevel{get; set;}
        public String rootUplnAccNo {get; set;}
        
        public LeaderInfo(String accNo, String rootUplnAccNo, Decimal leftId, Decimal rightId, Decimal genLevel){
            this.accNo = accNo;
            this.rootUplnAccNo = rootUplnAccNo;
            this.leftId = leftId;
            this.rightId = rightId;
            this.genLevel = genLevel;
        }
        
    }

    //Simplified and light-weight object to store column information gathered
    public class ColumnInfo {
        
        public ColumnInfo() {
            
            this.Name = '';
            this.FullName = '';
            this.ColumnType = '';
            this.ColumnDisplayType = '';
            this.ColumnGroupName = '';
            this.FullyQualifiedName = '';
            this.Visibility = '';
            this.Width = 0;
            this.is_Hover_Enabled=true;//changed swarnava
        }

        public ColumnInfo(String name, String fullName, String columnType, String columnDisplayType, String columnGroupName, String fullyQualifiedName, String visibility, Decimal width,boolean ihe) {
            
            this.Name = name;
            this.FullName = fullName;
            this.ColumnType = columnType;
            this.ColumnDisplayType = columnDisplayType;
            this.ColumnGroupName = columnGroupName;
            this.FullyQualifiedName = fullyQualifiedName;
            this.Visibility = visibility;
            this.Width = width;
            this.is_Hover_Enabled=ihe;//changed swarnava
        }
        
        public String Name { get; set; }
        public String FullName { get; set; }
        public String ColumnType { get; set; }
        public String ColumnDisplayType { get; set; }
        public String ColumnGroupName { get; set; }
        public String FullyQualifiedName { get; set; }
        public String Visibility { get; set; }
        public Decimal Width { get; set; }
        public boolean is_Hover_Enabled { get; set; }
    }

    public class AllDownlineCountDTO {
        
        public AllDownlineCountDTO() {
            this.AllDownlineCount = 0;
            this.IsMaxPageLimitReached = false;
        }
    
        public Decimal AllDownlineCount { get; private set; }
        public Boolean IsMaxPageLimitReached { get; private set; }
    }
    
    public class CampaignDTO {
        
        public CampaignDTO() {
            this.PreviousCampaign = 0;
            this.CurrentCampaign = 0;
        }
    
        public Integer PreviousCampaign { get; private set; }
        public Integer CurrentCampaign { get; private set; }
    }
    
    public class CampaignRetrievalDTO { 
        
        public CampaignRetrievalDTO() {
            this.CampaignValues = new CampaignDTO();
            this.CurrentCampaignCalendar = null;
            this.CampaignSource = '';
        }
        
        public CampaignDTO CampaignValues { get; set; }
        public Calendar__c CurrentCampaignCalendar { get; set; }
        public String CampaignSource { get; set; }
    }
    
    private class ReportFilterDTO {
        
        public ReportFilterDTO() {
            
        }
        
        public Map<String, Report_Filter__c> ReportFilterMap { get; set; }
        public String SOQLFilterCriteria { get; set; }
    }
    
    //Avon Market Id used to get Report Config and Genealogy objects from database
    public String AvonMarketId { get; private set; }
    
    //Look at m_SFDCMarketId comments.
    public Id SFDCMarketId { 
        get {
            return m_SFDCMarketId;
        } 
        set {
            this.SFDCMarketIdChanging(value); //We cannot override a property in Apex so lets include a virtual method
            m_SFDCMarketId = value;
        }
     }

    //Report Type
    public String ReportType {
        get {
            return m_ReportType;
        }
        set {
            String tempReportType = value;
            
            if(!MTRConfigUtility.IsReportTypeSupported(tempReportType)) {
                throw new ArgumentException('MTRSOQLBuilder::ReportType Exception Error=The specified ReportType is not supported.');
            }
            
            m_ReportType = tempReportType;
            this.ReportConfigIsModified = true;
        }
    }
    
    //Id of Report Config that has been loaded
    public Id ReportConfigId { get; private set; }
    
    //Look at m_LangCD comments.
    public String LangCD {
        get {
            return m_LangCD;
        }
        set {
            m_LangCD = value;
            this.ReportConfigIsModified = true;
        }
    }
    
    //Main Account Number
    public String MainAccountNumber { 
        get {
            return m_MainAccountNumber;
        }
        set {
            m_MainAccountNumber = value;
            this.ReportConfigIsModified = true;
        }
     }
    
    //Column information gathered from Report Config
    public Map<String, ColumnInfo> ColumnInfoMap { get; private set; }

    //Column information gathered from Report Config
    public Map<String, ColumnInfo> ColumnInfoMap2 { get; private set; }
        
    //Order in which the columns should appear in
    public List<String> ColumnOrderList { get; private set; }

    //Order in which the columns should appear in
    public List<String> ColumnOrderList2 { get; private set; }
    
    //Fully Qualified Column Names
    public Set<String> FullyQualifiedColumnNameSet { get; private set; }
    
    //Personal Merge Column Names
    public Set<String> PersonalMergeColumnNameSet { get; private set; }
    
    //Exclusive Column Names that should be pulled from database
    public Set<String> VisibleColumnNameSet { get; set; }
    
    //StrictColumnGroupVisibility
    public Boolean StrictColumnGroupVisibility { get; set; }
    
    //MaxPageLimit
    public Integer MaxPageLimit { get; private set; }
    
    //All Downline Count Total
    public Decimal AllDownlineCountTotal { get; private set; }
    
    //Max Page Limit Reached
    public Boolean MaxPageLimitReached { get; private set; }
    
    //Page Size
    public Integer PageSize { 
        get {
            return m_PageSize;
        }
        
        set {
            
            m_PageSize = value;
            this.PageSizeIsModified = true;
        }
    }
    
    //Selected Previous Campaign
    public Integer SelectedPreviousCampaign { get; private set; }
    
    //Selected Current Campaign
    public Integer SelectedCurrentCampaign { get; private set; }
    
    //Campaign Type Changed
    public Boolean CampaignTypeChanged { get; private set; }
    
    //Market Future Campaign Number
    public Integer MarketFutureCampaign { get; private set; }
    
    //Market Current Campaign Number
    public Integer MarketCurrentCampaign { get; private set; }
    
    //Historical Campaign Total
    public Integer HistoricalCampaignTotal { get; private set; }
    
    
    public Boolean IsFutureOrPresentCampaign {
        get {
            
            this.LoadCampaignInfo();
            
            CampaignRetrievalDTO campaignRetrievalDTO = this.GetCampaignValues();
            
            return (this.MarketFutureCampaign == campaignRetrievalDTO.CampaignValues.CurrentCampaign
                        || this.MarketCurrentCampaign == campaignRetrievalDTO.CampaignValues.CurrentCampaign);
        }
    }
    
    //Included Removed Reps
    public Boolean IncludeRemovedReps { get; set; }

    //Indicates whether selected filter is drillable
    public Boolean IsDrillable { get; private set; }
    
    //Indicates whether selected filter is sortable
    public Boolean IsSortable { get; private set; }
    
    //Indicates whether selected filter is rep list restricted
    public Boolean IsRepListRestricted { get; private set; }
    
    //Selected Name Label
    public String SelectedNameLabel { get; private set; }
    
    //Default Sort Column from Filter
    public String DefaultSortColumn { get; private set; }
    
    //Adjusted Sort Field
    public String AdjustedSortField { get; private set; }
    
    //Default Sort Direction
    public Boolean SortIsAscending { get; private set; }

    //Branch Summary
    public Branch_Summary__c BranchSummary { get; private set; }
    
    //SA 6/12/2012
    private String profileName;
    private String userTitleLevelNbr;
    
    public MTRSOQLBuilder() {
        Initialize(null, '', '', '', '', null);
    }
    
    public MTRSOQLBuilder(Id sfdcMarketId, String reportType, String profileName, String userTitleLevelNbr, String langCD) {
        Initialize(sfdcMarketId, reportType, profileName, userTitleLevelNbr, langCD, null);
    }
    
    public MTRSOQLBuilder(Id sfdcMarketId, String reportType, String profileName, String userTitleLevelNbr, String langCD, MTRSearchOptions.MTRBaseSearch searchType) {
        Initialize(sfdcMarketId, reportType, profileName, userTitleLevelNbr, langCD, searchType);
    }
    
    
    
    protected virtual void Initialize(Id sfdcMarketId,
                        String reportType,
                        String profileName,
                        String userTitleLevelNbr,
                        String langCD,
                        MTRSearchOptions.MTRBaseSearch searchType) {
        this.ReportConfigIsModified = false;                
        this.SFDCMarketId = sfdcMarketId;
        
        if(sfdcMarketId != null){
            this.marketRepIndicator = [select ALM_Rep_Indicator__c from Market__c where Id =: sfdcMarketId limit 1].ALM_Rep_Indicator__c;
        }
        
        this.userTitleLevelNbr = userTitleLevelNbr;
        this.profileName = profileName;
        
        if(reportType != null && reportType.trim().length() > 0) {
            this.ReportType = reportType;
        }
        
        this.LangCD = langCD;
        this.MainAccountNumber = '-1';
        this.BadgeTitle = '';
        this.SponsorQualifyingOrderAmount = 0;
        
        if(searchType != null) {
            this.SetSearchType(searchType);
        }
        this.ColumnInfoMap = new Map<String, ColumnInfo>();
        this.ColumnInfoMap2 = new Map<String, ColumnInfo>();
        this.ColumnOrderList = new List<String>();
        this.ColumnOrderList2 = new List<String>();
        this.FullyQualifiedColumnNameSet = new Set<String>();
        this.PersonalMergeColumnNameSet = new Set<String>();
        this.VisibleColumnNameSet = new Set<String>();
        this.StrictColumnGroupVisibility = true;
        this.MaxPageLimit = 500;
        this.AllDownlineCountTotal = 0;
        this.PageSize = 3;
        this.PageSizeIsModified = false;
        this.OrderCriteria = '';
        this.IncludeRemovedReps = false;
        this.CampaignTypeChanged = false;
        this.SelectedPreviousCampaign = 0;
        this.SelectedCurrentCampaign = 0;
        this.MarketFutureCampaign = 0;
        this.MarketCurrentCampaign = 0;
        this.HistoricalCampaignTotal = 0;
        this.IsDrillable = true;
        this.IsSortable = true;
        this.IsRepListRestricted = false;
        this.SelectedNameLabel = '';
        this.DefaultSortColumn = '';
        this.AdjustedSortField = '';
        this.SortIsAscending = true;
        this.BranchSummary = null;      
        this.mktTagsMap = MarketTagUtils.getYouMktTags(this.SFDCMarketId, this.LangCD);
        System.debug('\n #### 1111111 mktTagsMap  '+mktTagsMap);

    }   

    
    //Overridable method that is called when SFDCMarketId property is touched
    protected virtual void SFDCMarketIdChanging(Id newMarketId) {
        
        if(newMarketId != null) {
            
            Market__c market = [SELECT Id, Market_Id__c FROM Market__c
                                    WHERE Id = :newMarketId];
                                    
            if(market == null) {
                throw new ArgumentException('MTRSOQLBuilder::Exception Error=Could not find SFDC Market Id.');
            }
                    
            this.AvonMarketId = market.Market_Id__c;
        }
        
        this.ReportConfigIsModified = true;
    }
    
    //Makes sure that we can support incoming Search Type
    protected void IsSearchSupportedCheck(MTRSearchOptions.MTRBaseSearch searchType) {
        
        Set<String> supportedSearchSet = new Set<String>();
        
        supportedSearchSet.add('MTRRegularSearch');
        supportedSearchSet.add('MTRTextSearch');
        supportedSearchSet.add('MTRFilterSearch');
        
        if(!supportedSearchSet.contains(GetSupportedSearchClassName(searchType))) {
            
            throw new ArgumentException('MTRSOQLBuilder::IsSearchSupportCheck Exception Error=The Search Type object that was provided is not supported.');
        }
    }
    
    //Gets class type as literal value
    protected String GetSupportedSearchClassName(MTRSearchOptions.MTRBaseSearch searchType) {
        
        String className = '';
        
        if(searchType instanceof MTRSearchOptions.MTRRegularSearch) {
            className = 'MTRRegularSearch';
        }
        else if(searchType instanceof MTRSearchOptions.MTRTextSearch) {
            className = 'MTRTextSearch';
        }
        else if(searchType instanceof MTRSearchOptions.MTRFilterSearch) {
            className = 'MTRFilterSearch';
        }
        
        return className;
    }
    
    //Gets Search Type to utilize in SOQLBuilder.  Please note we clone the incoming search type to stop modification by reference from
    //affecting the caching scheme in place
    public virtual void SetSearchType(MTRSearchOptions.MTRBaseSearch searchType) {
    
        IsSearchSupportedCheck(searchType);
        
        if(!MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) && searchType instanceof MTRSearchOptions.MTRTextSearch) {
            
            throw new InvalidOperationException('MTRSOQLBuilder::SetSearchType Exception Error=TextSearch is not supported by this ReportType.');
        }
        
        if(!MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) && searchType.SearchForDownline) {
            
            throw new InvalidOperationException('MTRSOQLBuilder::SetSearchType Exception Error=SearchForDownline is not supported by this ReportType.');
        }
        
        if(!MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) && searchType.IsTList) {
            
            throw new InvalidOperationException('MTRSOQLBuilder::SetSearchType Exception Error=TList is not supported by this ReportType.');
        }
        
        if(searchType instanceof MTRSearchOptions.MTRTextSearch && searchType.SearchForDownline) {
            
            throw new InvalidOperationException('MTRSOQLBuilder::SetSearchType Exception Error=SearchForDownline parameter is not supported by this SearchType.');
        }
        
        if((searchType.ReverseNameSortColumnName != null && searchType.ReverseNameSortColumnName.length() > 0) && (searchType.SortBy == null || searchType.SortBy.length() == 0)) {
            
            throw new InvalidOperationException('MTRSOQLBuilder::SetSearchType Exception Error=Must have sort criteria when ReverseNameSortColumnName is populated.');
        }
        
        MTRSearchOptions.MTRBaseSearch newSearchType = searchType.clone();
        
        this.SearchType = newSearchType;
        this.BadgeTitle = MTRConfigUtility.GetUserBadgeTitle(this.SFDCMarketId, this.GetMainAccountNumberForConfig());
    }
    
    private String MergeFields(String query, String previousCampaign, String currentCampaign) {
        
        if(query.indexOf('[[PV]]') > -1 && MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType)) {
            
            if(this.BadgeTitle == 'SEL') {
                query = query.replace('[[PV]]', 'GRP_BLCKD_UNIT_SLS_AMT__c DESC, PRSNL_SLS_AMT__c DESC');
            }
            else {
                query = query.replace('[[PV]]', 'GRP_UNIT_SLS_AMT__c DESC, PRSNL_SLS_AMT__c DESC');
            }
        }
                                
        if(query.indexOf('[[CurrentCampaign]]') > -1 && currentCampaign != null && currentCampaign.length() > 0 && currentCampaign != '0') {
            query = query.replace('[[CurrentCampaign]]', currentCampaign);
        }
        
        if(query.indexOf('[[PreviousCampaign]]') > -1 && previousCampaign != null && previousCampaign.length() > 0 && previousCampaign != '0') {
            query = query.replace('[[PreviousCampaign]]', previousCampaign);
        }
        
        return query;
    }
    
    private String MakeValueSafe(String inputValue, String defaultValue) {
        
        if(inputValue == null) {
            inputValue = defaultValue;
        }
        
        return inputValue;
    }
    
    protected String GetMainAccountNumberForConfig() {
        
        String accountNum = '-1';
        
        if(this.MainAccountNumber != '-1') {
            accountNum = this.MainAccountNumber;
        }
        else if(this.SearchType != null){
            accountNum = this.SearchType.AccountNumber;
        }
        
        return accountNum;
    }
    
    protected void LoadCampaignInfo() {
        
        if(m_CachedQueryColumns.trim().length() == 0 || this.ReportConfigIsModified) {
            
            Market__c market = this.GetMarketInfoForQuery(this.SFDCMarketId);
            
            if(market.Is_Future_Campaign_Filter_Available__c != null && market.Is_Future_Campaign_Filter_Available__c) {
                this.MarketFutureCampaign = Integer.valueOf(market.NEXT_1_CMPGN_NR__c);
            }
        
            this.MarketCurrentCampaign = Integer.valueOf(market.CMPGN_NR__c);
            this.SponsorQualifyingOrderAmount = market.SPONSOR_QLFYING_ORD_AMT__c;
        }
    }
    
    //Gets Report Config information from database.  Populates CachedQueryColumns, Column Info Map, and Column Order List of this class.
    protected String GetColumnsFromReportConfig() {
    
        Market__c market = null;
        
        this.LoadCampaignInfo();
        
        if(m_CachedQueryColumns.trim().length() == 0 || this.ReportConfigIsModified) {
            
            this.ColumnInfoMap.Clear();
            this.ColumnInfoMap2.Clear();
            this.ColumnOrderList.Clear();
            this.ColumnOrderList2.Clear();
            
            if(this.FullyQualifiedColumnNameSet != null) {
                this.FullyQualifiedColumnNameSet.Clear();
            }
            
            this.PersonalMergeColumnNameSet.Clear();
            
            Map<String, String> visibilityMap = new Map<String, String>();
            List<Report_Config__c> reportConfigList = null;
            List<Report_Column_New__c> reportColumnList = null;
            Set<String> uniqueColumnSet = new Set<String>();
            Report_Config__c reportConfig = null;
            AllDownlineCountDTO allDownlineCountDTO = null;
            ColumnInfo columnInfo = null;
            ColumnInfo cloneColumnInfo = null;
            String firstLastNameLabel = MTRConfigUtility.getJSFixedFirstLastNameLabel();
            String lastFirstNameLabel = MTRConfigUtility.getJSFixedLastFirstNameLabel();
            String reportConfigReportType = '';
            String queryColumns = '';
            String fullyQualifiedName = '';
            String tmpFullyQualifiedName = '';
            String ruleType = '';
            String columnName = '';
            String fullColumnName = '';
            String groupColumnName = '';
            String visibility = '';
            Integer firstColumnOffset = 0;
            Integer highestFrozenDisplayOrder = 0;
            Integer lastFrozenColumnIndex = -1;
            Boolean reverseNameSortFirstLastName = (this.SearchType.ReverseNameSortColumnName != null && this.SearchType.ReverseNameSortColumnName.length() > 0 && this.SearchType.ReverseNameSortColumnName == firstLastNameLabel) ? true : false;
            Boolean reverseNameSortLastFirstName = (this.SearchType.ReverseNameSortColumnName != null && this.SearchType.ReverseNameSortColumnName.length() > 0 && this.SearchType.ReverseNameSortColumnName == lastFirstNameLabel) ? true : false;
        
            //commented by Supriyo Mar 1, 2013
            /*if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT) {
                if(this.isTList ==false)          //added by swarnava for Team List
                  reportConfigReportType = 'My_Team';
                else
                  reportConfigReportType ='T_List';
            }
            else -- Enabled by Snehashis on 17 jul 13 
            if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
                if(this.isTList ==false)            //added by swarnava for Team List Order
                  reportConfigReportType = 'My_Team_Order';
                else
                  reportConfigReportType ='T_ListOrder';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT) {
                if(this.isTList ==false)            //added by swarnava for Team List Order
                  reportConfigReportType = 'Title_Advancement';
                else
                  reportConfigReportType ='T_ListOrder';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_G1APPT) {
                reportConfigReportType = 'G1_Appointments';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_RISINGSTARS) {
                reportConfigReportType = 'Rising_Stars';
            }*/
            
            system.debug('Report Type - > '+ this.ReportType);
            
            //added by Supriyo same as previous code on Mar 1, 2013
            if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT) {
                reportConfigReportType = 'Title_Advancement';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
                reportConfigReportType = 'My_Team_Order';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_G1APPT) {
                reportConfigReportType = 'G1_Appointments';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_RISINGSTARS) {
                reportConfigReportType = 'Rising_Stars';
            }
            else if(this.ReportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT) {
                reportConfigReportType = 'Title_Advancement';
            }
            
            System.debug('reportConfigReportType --> '+reportConfigReportType);
            reportConfigList = [SELECT Id, Name, Market__c, Max_Page_Limit__c, Page_Size__c, T_List_Page_Size__c, Include_Removed_Reps__c, Number_of_Historical_Cmpgns_for_Filter__c, Order_Criteria__c,
                 (
                    SELECT Id, Name, Fully_Qualified_Name__c, Fully_Qualified_Name2__c, Type__c, Column_Display_Type__c, Column_Group_Name__c, Visibility__c, Width__c, Personal_Merge__c, Display_Order__c,Is_Hover_enabled__c
                    FROM Report_Column__r
                    ORDER BY Display_Order__c, Column_Group_Name__c
                 )
              FROM Report_Config__c
              WHERE Report_Type__c = :reportConfigReportType
              AND Market__c = :this.SFDCMarketId
              AND Applicable_to__c INCLUDES (:this.profileName)
              AND TITL_LVL_NBR__c INCLUDES (:this.userTitleLevelNbr) LIMIT 1];
            
            if(reportConfigList.size() == 0) {
                throw new InvalidOperationException('MTRSOQLBuilder::GetColumnsFromReportConfig Exception Error=Could not find the specified Report Config: ' + 
                                                    'Profile: ' + this.profileName + ' Title Nbr: ' + this.userTitleLevelNbr + ' Report Type: ' + reportConfigReportType);
            }
            
            reportConfig = reportConfigList[0];
            
            this.ReportConfigId = reportConfig.Id;
            this.OrderCriteria = reportConfig.Order_Criteria__c;
            
            this.MaxPageLimit = (Integer)reportConfig.Max_Page_Limit__c;
            
            if(!this.PageSizeIsModified) {
                
                if(this.SearchType.IsTList) {
                    this.PageSize = (Integer)reportConfig.T_List_Page_Size__c;
                }
                else {
                    this.PageSize = (Integer)reportConfig.Page_Size__c;
                }
            }
            
            this.IncludeRemovedReps = reportConfig.Include_Removed_Reps__c;
            allDownlineCountDTO = this.IsMaxPageLimitReached(this.GetMainAccountNumberForConfig(), this.IncludeRemovedReps);
           
            this.AllDownlineCountTotal = allDownlineCountDTO.AllDownlineCount;
            this.MaxPageLimitReached = allDownlineCountDTO.IsMaxPageLimitReached; 
            
            this.HistoricalCampaignTotal = (Integer)reportConfig.Number_of_Historical_Cmpgns_for_Filter__c;
            
            reportColumnList = reportConfig.Report_Column__r;
            
            uniqueColumnSet.add('Id');
            uniqueColumnSet.add('Name');
            uniqueColumnSet.add('ACCT_NR__c');
            uniqueColumnSet.add('MRKT_ACCT_KEY__c');
            uniqueColumnSet.add('DWNLN_ONLY_IND__c');
            uniqueColumnSet.add('ALL_DWNLN_CNT__c');
            uniqueColumnSet.add('ALL_DOWNLN_CNT_WITH_REMV__c');
            uniqueColumnSet.add('Gen_1_Total_Titled_Leader_Candidates__c');
            
            if(this.MaxPageLimitReached) {
                uniqueColumnSet.add('GENRTN_1_TITL_STF_CNT__c');
            }
            
            uniqueColumnSet.add('Genealogy_Level__c');
            uniqueColumnSet.add('UPLN_ACCT_NR__c');
            
            columnName = MTRConfigUtility.getJSFixedAllLabel();
            
            if(this.VisibleColumnNameSet.contains(columnName) || this.VisibleColumnNameSet.size() == 0) {
                this.ColumnOrderList.add(columnName);
                firstColumnOffset++;
            }
            
            columnName = MTRConfigUtility.getJSFixedGenerationLabel();
            
            if(this.VisibleColumnNameSet.contains(columnName) || this.VisibleColumnNameSet.size() == 0) {
                this.ColumnOrderList.add(columnName);
                firstColumnOffset++;
            }
            
            ALMReportLabels.reportType = this.ReportType;
            
            system.debug(reportColumnList);    
            
            for(Integer n = 0; n <= reportColumnList.size() - 1; n++) {
        
                fullyQualifiedName = this.ParseFullyQualifiedName(reportColumnList[n].Fully_Qualified_Name__c);
                System.debug('\n fullyQualifiedName COLUMN ----- '+fullyQualifiedName);
                tmpFullyQualifiedName = fullyQualifiedName.replace(' ', '');
                
                ruleType = MTRConfigUtility.GetExceptionRule(tmpFullyQualifiedName);
                
                //Check if a field is a market tag
                if(fullyQualifiedName.contains('TAG')){
                  //System.debug('\n MARKET TAG ----------------');
                    columnName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(mktTagsMap.get(tmpFullyQualifiedName), ''));
                    //System.debug('\n MARKET TAG tmpFullyQualifiedName ---- '+tmpFullyQualifiedName);
                    fullColumnName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(mktTagsMap.get(tmpFullyQualifiedName), ''));
                }
                else{
                    columnName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnLabel(tmpFullyQualifiedName),''));
                    fullColumnName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnFullNameLabel(tmpFullyQualifiedName),columnName));
                    System.debug('\n ### columnName ----- '+columnName);
                    System.debug('\n ### fullColumnName ----- '+fullColumnName);
                }
                
                system.debug(':::::::::::::' + columnName + fullyQualifiedName + tmpFullyQualifiedName) ;
                
                groupColumnName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnGroupLabel(reportColumnList[n].Column_Group_Name__c),reportColumnList[n].Column_Group_Name__c));
                //System.debug('\n ### groupColumnName ----- '+groupColumnName);
        //System.debug('\n @@@@@@ groupColumnName ######### \n '+groupColumnName);
                if(this.StrictColumnGroupVisibility && groupColumnName != null && groupColumnName.length() > 0) {
                    //System.debug('\n @@@@@@ AAAAAAAAAAAAAAA ');
                    if(visibilityMap.get(groupColumnName) == null) {
                      //System.debug('\n @@@@@@ BBBBBBBBB ');
                        visibilityMap.put(groupColumnName, reportColumnList[n].Visibility__c);
                    }
                }
                
                if(visibilityMap.get(groupColumnName) != null && 
                  !((fullyQualifiedName.contains(ALMConstants.EMAIL)) || ((fullyQualifiedName.contains(ALMConstants.PHONE)))
                    || ((fullyQualifiedName.contains(ALMConstants.BIRTH_DATE))) || ((fullyQualifiedName.contains(ALMConstants.ANNIV_DATE)))))  // Added by Raktim
                {
                  //System.debug('\n @@@@@@ CCCCCCCCCCCCCC ');
                    visibility = visibilityMap.get(groupColumnName);
                }
                else {
                  
                    visibility = reportColumnList[n].Visibility__c;
                    //System.debug('\n @@@@@@ DDDDDDDDDDDDDD visibility -- '+visibility);
                }
                
                if(reportColumnList[n].Column_Display_Type__c == 'Frozen' && reportColumnList[n].Display_Order__c > highestFrozenDisplayOrder) {
                    highestFrozenDisplayOrder = (Integer)reportColumnList[n].Display_Order__c;
                    lastFrozenColumnIndex = n;
                }
                
                if(this.VisibleColumnNameSet.contains(columnName) || this.VisibleColumnNameSet.size() == 0) {
                    
                    if(reportColumnList[n].Personal_Merge__c) {
                        this.PersonalMergeColumnNameSet.add(columnName);
                    }
                
                    if(tmpFullyQualifiedName != null && tmpFullyQualifiedName.length() > 0) {
                        
                        uniqueColumnSet.addAll(tmpFullyQualifiedName.split(','));
                        
                        columnInfo = new ColumnInfo(columnName, fullColumnName, MTRConfigUtility.EscapeBadJavascriptChars(reportColumnList[n].Type__c), MTRConfigUtility.EscapeBadJavascriptChars(reportColumnList[n].Column_Display_Type__c), groupColumnName, tmpFullyQualifiedName, MTRConfigUtility.EscapeBadJavascriptChars(visibility), reportColumnList[n].Width__c,reportColumnList[n].Is_Hover_enabled__c);
                        //changed swarnava
                        this.ColumnInfoMap.put(columnName, columnInfo);
                        this.ColumnOrderList.add(columnName);
                        
                        if(ruleType == 'Name') {
            
                            cloneColumnInfo = CloneReverseNameColumnInfo(columnInfo);
                            
                            if(cloneColumnInfo != null) {
                                this.ColumnInfoMap.put(cloneColumnInfo.Name, cloneColumnInfo);
                                
                                if(reportColumnList[n].Personal_Merge__c) {
                                    this.PersonalMergeColumnNameSet.add(cloneColumnInfo.Name);
                                }
                            }
                            
                            if(reverseNameSortFirstLastName) {
                                
                                this.SelectedNameLabel = firstLastNameLabel;
                                this.ColumnOrderList.set(this.ColumnOrderList.size() - 1, firstLastNameLabel);
                            }
                            else if(reverseNameSortLastFirstName) {
                                
                                this.SelectedNameLabel = lastFirstNameLabel;
                                this.ColumnOrderList.set(this.ColumnOrderList.size() - 1, lastFirstNameLabel);
                            }
                            else if((this.OrderCriteria == null || this.OrderCriteria.length() == 0) 
                            && (this.SelectedNameLabel == null || this.SelectedNameLabel.length() == 0)
                            && columnName == firstLastNameLabel) {
                                
                                this.SelectedNameLabel = lastFirstNameLabel;
                                this.OrderCriteria = 'Genealogy_Level__c, MRKT_ACCT_KEY__r.LastName ASC';
                                this.ColumnOrderList.set(this.ColumnOrderList.size() - 1, lastFirstNameLabel);
                            }
                            else if(this.SelectedNameLabel != null && this.SelectedNameLabel.length() > 0) {
                                
                                this.ColumnOrderList.set(this.ColumnOrderList.size() - 1, this.SelectedNameLabel);
                            }
                            //final else added by Rupayan
                            else {
                                this.SelectedNameLabel = lastFirstNameLabel;    
                            }
                        }
                        else if(ruleType == 'BadgeTitle') {
                            
                            if(tmpFullyQualifiedName.indexOf('LDRSHP_TITL_LVL_NR__c') > -1) {
                                uniqueColumnSet.add('PD_TITL_LVL_NR__c');
                            }
                            else if(tmpFullyQualifiedName.indexOf('PD_TITL_LVL_NR__c') > -1) {
                                uniqueColumnSet.add('LDRSHP_TITL_LVL_NR__c');
                            }
                            
                            cloneColumnInfo = CloneOppositeBadgeTitleColumnInfo(columnInfo);
                            
                            if(cloneColumnInfo != null) {
                                this.ColumnInfoMap.put(cloneColumnInfo.Name, cloneColumnInfo);
                                
                                if(reportColumnList[n].Personal_Merge__c) {
                                    this.PersonalMergeColumnNameSet.add(cloneColumnInfo.Name);
                                }
                            }
                        }
                    }
                    
                    //tmpFullyQualifiedName = reportColumnList[n].Fully_Qualified_Name2__c;
                    tmpFullyQualifiedName = reportColumnList[n].Fully_Qualified_Name__c;
    
                    if(tmpFullyQualifiedName != null && tmpFullyQualifiedName.length() > 0) {
                        
                        system.debug('::::::::::::::' + tmpFullyQualifiedName);
                        system.debug('::::::::::::::' + columnName);
                        
                        tmpFullyQualifiedName = tmpFullyQualifiedName.replace(' ', '');
                        
                        uniqueColumnSet.addAll(tmpFullyQualifiedName.split(','));
                        
                        columnInfo = new ColumnInfo(columnName, fullColumnName, MTRConfigUtility.EscapeBadJavascriptChars(reportColumnList[n].Type__c), MTRConfigUtility.EscapeBadJavascriptChars(reportColumnList[n].Column_Display_Type__c), groupColumnName, tmpFullyQualifiedName, MTRConfigUtility.EscapeBadJavascriptChars(visibility), reportColumnList[n].Width__c,reportColumnList[n].Is_Hover_enabled__c);
                        //changed swarnava
                        this.ColumnInfoMap2.put(columnName, columnInfo);
                        this.ColumnOrderList2.add(columnName);
                        
                        if(ruleType == 'Name') {
                            cloneColumnInfo = CloneReverseNameColumnInfo(columnInfo);
                            
                            if(cloneColumnInfo != null) {
                                this.ColumnInfoMap2.put(cloneColumnInfo.Name, cloneColumnInfo);
                            }
                            
                            if(reverseNameSortFirstLastName) {
                                this.ColumnOrderList2.set(this.ColumnOrderList2.size() - 1, firstLastNameLabel);
                            }
                            else if(reverseNameSortLastFirstName) {
                                this.ColumnOrderList2.set(this.ColumnOrderList2.size() - 1, lastFirstNameLabel);
                            }
                            else if(this.SelectedNameLabel != null && this.SelectedNameLabel.length() > 0) {
                                
                                this.ColumnOrderList2.set(this.ColumnOrderList2.size() - 1, this.SelectedNameLabel);
                            }
                        }
                        else if(ruleType == 'BadgeTitle') {
                            
                            if(tmpFullyQualifiedName.indexOf('LDRSHP_TITL_LVL_NR__c') > -1) {
                                uniqueColumnSet.add('PD_TITL_LVL_NR__c');
                            }
                            else if(tmpFullyQualifiedName.indexOf('PD_TITL_LVL_NR__c') > -1) {
                                uniqueColumnSet.add('LDRSHP_TITL_LVL_NR__c');
                            }
                            
                            cloneColumnInfo = CloneOppositeBadgeTitleColumnInfo(columnInfo);
                            
                            if(cloneColumnInfo != null) {
                                this.ColumnInfoMap2.put(cloneColumnInfo.Name, cloneColumnInfo);
                            }
                        }
                    }
                
                } 
                
                system.debug('+++++++++++++' + this.ColumnOrderList2);
                system.debug('+++++++++++++ ColumnOrderList ::::::::: ' + this.ColumnOrderList);
                system.debug('+++++++++++++' + this.ColumnInfoMap2);
                system.debug('+++++++++++++' + this.ColumnInfoMap);
                          
                
            }
            
            /* Following lines blocked for removal of TeamList Column from MTO / TA - by Raktim
             * on 10thApr, 2013 started
             *
             * Following lines are unblocked on 16thApr, 2013
             *
             * Following lines are blocked on 29thApr, 2013
             *
             */
            /*
            if(this.MaxPageLimitReached && lastFrozenColumnIndex > -1) {
                
                columnName = MTRConfigUtility.getJSFixedTListLabel();
            
                if(this.VisibleColumnNameSet.contains(columnName) || this.VisibleColumnNameSet.size() == 0) {
                    this.ColumnOrderList.add(firstColumnOffset + (lastFrozenColumnIndex + 1), columnName);
                }
            }
            */
            /* --- End of Change --- */
            
            for(String column: uniqueColumnSet) {
                
                if(queryColumns.length() == 0) {
                    queryColumns = column;
                }
                else {
                    queryColumns += ', ' + column;
                }
            }
        
            this.FullyQualifiedColumnNameSet = uniqueColumnSet;
            
            m_CachedQueryColumns = queryColumns;
                
            this.ReportConfigIsModified = false;
        }
        
        
        return m_CachedQueryColumns;
    }
    
    protected AllDownlineCountDTO IsMaxPageLimitReached(String accountId, Boolean includeRemovedReps) {
        
        AllDownlineCountDTO allDownlineCountDTO = new AllDownlineCountDTO();
        Decimal allDownlineCountRemoved = 0;
        Decimal allDownlineCount = 0;
    
        if(this.SearchType.SelectIds == null || this.SearchType.SelectIds.size() == 0) {
            List<SObject> objList = null;
            CampaignRetrievalDTO campaignRetrievalDTO = this.GetCampaignValues();
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            objList = Database.query('SELECT Id, ALL_DWNLN_CNT__c, ALL_DOWNLN_CNT_WITH_REMV__c FROM '+this.marketRepIndicator+' WHERE ACCT_NR__c = \''+ String.escapeSingleQuotes(accountId)+ '\' AND MRKT_ID__c = \'' + this.AvonMarketId + '\' AND FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignRetrievalDTO.CampaignValues.CurrentCampaign) + '  LIMIT 1');
            if(objList.size() > 0 && objList[0] != null) {
                if(includeRemovedReps) {
                    allDownlineCountRemoved = (objList[0].get('ALL_DOWNLN_CNT_WITH_REMV__c') != null) ? (Decimal)objList[0].get('ALL_DOWNLN_CNT_WITH_REMV__c'): 0; 
                    if(allDownlineCountRemoved > this.MaxPageLimit) {
                        allDownlineCountDTO.AllDownlineCount = allDownlineCountRemoved;
                        allDownlineCountDTO.IsMaxPageLimitReached = true;
                    }               
                }
                else {
                    allDownlineCount = (objList[0].get('ALL_DWNLN_CNT__c') != null) ? (Decimal)objList[0].get('ALL_DWNLN_CNT__c') : 0;
                    if(allDownlineCount > this.MaxPageLimit) {
                        allDownlineCountDTO.AllDownlineCount = allDownlineCount;
                        allDownlineCountDTO.IsMaxPageLimitReached = true;
                    }
                }
                
                if(this.SearchType.IsTList || !MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType)) {
                    allDownlineCountDTO.IsMaxPageLimitReached = false;
                }
            }
        }
        
        return allDownlineCountDTO;
    }
    
    protected Market__c GetMarketInfoForQuery(Id sfdcMarketId) {
    
        Market__c market = [SELECT Id, Is_Future_Campaign_Filter_Available__c, CMPGN_NR__c, CMPGN_NR_NUMBER__c, NEXT_1_CMPGN_NR__c, SPONSOR_QLFYING_ORD_AMT__c, CMPGN_STRT_DT__c FROM Market__c
                                WHERE Id = :sfdcMarketId];
                                
        return market;
    }
    
    public static String MakeCampaignKey(Integer previousCampaign, Integer currentCampaign) {
        
        return 'CMPGN' + previousCampaign + '_' + currentCampaign;
    }
    
    public static CampaignDTO ParseCampaignValues(String campaignId) {
        
        String[] arrCampaignNumbers = null;
        CampaignDTO campaignDTO = new CampaignDTO();
        
        if(campaignId != null && campaignId.length() > 0) {
                
            if(campaignId.startsWith('CMPGN') && campaignId.indexOf('_') > -1) {
                
                campaignId = campaignId.replace('CMPGN', '');
                
                arrCampaignNumbers = campaignId.split('_');
                
                if(arrCampaignNumbers.size() >= 2) {
                
                    campaignDTO.PreviousCampaign = Integer.valueOf(arrCampaignNumbers[0]);
                    campaignDTO.CurrentCampaign = Integer.valueOf(arrCampaignNumbers[1]);
                   // ApexPages.currentPage().getParameters().put('CmpgnSeltd',String.valueOf(campaignDTO.CurrentCampaign));//ADDED SWARNAVA
                }
            }
        }
        
        return campaignDTO;
    }
    
    public CampaignRetrievalDTO GetCampaignValues() { 
        
        CampaignRetrievalDTO campaignRetrievalDTO = new CampaignRetrievalDTO();
        CampaignDTO campaignDTO = null;
        Boolean foundCampaign = false;
        
        if(this.SearchType != null && this.SearchType instanceof MTRSearchOptions.MTRFilterSearch) {
        
            MTRSearchOptions.MTRFilterSearch filterSearchType = (MTRSearchOptions.MTRFilterSearch)this.SearchType;
                
            if(filterSearchType.CampaignId != null && filterSearchType.CampaignId.length() > 0) {
                
                campaignDTO = MTRSOQLBuilder.ParseCampaignValues(filterSearchType.CampaignId);
                
                campaignRetrievalDTO.CampaignValues = campaignDTO;
                campaignRetrievalDTO.CampaignSource = 'Filter';
                ApexPages.currentPage().getParameters().put('CmpgnSeltd',String.valueOf(campaignDTO.CurrentCampaign));//ADDED SWARNAVA
                foundCampaign = true;
            }
        }
        
        if(!foundCampaign && this.SelectedCurrentCampaign != null && this.SelectedCurrentCampaign != 0) {
            
            campaignRetrievalDTO.CampaignValues.PreviousCampaign = this.SelectedPreviousCampaign;
            campaignRetrievalDTO.CampaignValues.CurrentCampaign = this.SelectedCurrentCampaign;
            campaignRetrievalDTO.CampaignSource = 'Selected';
            foundCampaign = true;
        }
        
        if(!foundCampaign) {
            this.LoadCampaignInfo();
        }
        
        if(!foundCampaign && this.MarketCurrentCampaign != null && this.MarketCurrentCampaign != 0) {
            if(ApexPages.CurrentPage().getParameters().get('campaignId')!=null)
            campaignRetrievalDTO.CampaignValues.CurrentCampaign =Integer.valueOf(ApexPages.CurrentPage().getParameters().get('campaignId'));
            else{
            if(ApexPages.CurrentPage().getParameters().get('mpCampaign')==null) //changed by swarnava for mailplan markets:Start
            campaignRetrievalDTO.CampaignValues.CurrentCampaign = this.MarketCurrentCampaign;
            else campaignRetrievalDTO.CampaignValues.CurrentCampaign =(ApexPages.CurrentPage().getParameters().get('mpsellingdefaultlanding')=='Y'?Integer.valueOf(ApexPages.CurrentPage().getParameters().get('mpCampaign')):this.MarketCurrentCampaign);//changed by swarnava for mailplan markets:End
             // else campaignRetrievalDTO.CampaignValues.CurrentCampaign =Integer.valueOf(ApexPages.CurrentPage().getParameters().get('mpCampaign'));//changed by swarnava for mailplan markets:End
             }
            campaignRetrievalDTO.CampaignSource = 'Current';
            foundCampaign = true;
        }
        
        if(!foundCampaign) {
            throw new InvalidOperationException('MTRSOQLBuilder::GetCampaignValues Exception Error=To utilize the GetCampaignValues method, please pass a Filter SearchType to this class or call the GetColumnsFromReportConfig function to get the CurrentCampaign from the Market object.');
        }
        
        if(m_Calendar != null && m_Calendar.CMPGN_NR__c == campaignRetrievalDTO.CampaignValues.CurrentCampaign) {
            campaignRetrievalDTO.CurrentCampaignCalendar = m_Calendar;
        }
        else {
            m_Calendar = GetCalendarByCampaignNumber(campaignRetrievalDTO.CampaignValues.CurrentCampaign);
            campaignRetrievalDTO.CurrentCampaignCalendar = m_Calendar;
            
            if(campaignRetrievalDTO.CampaignSource == 'Current' && m_Calendar != null && m_Calendar.PRIOR_CMPGN_NR__c != null) {
                campaignRetrievalDTO.CampaignValues.PreviousCampaign = Integer.valueOf(m_Calendar.PRIOR_CMPGN_NR__c);
            }
        }
        
        return campaignRetrievalDTO;
    }
    
    protected Calendar__c GetCalendarByCampaignNumber(Integer campaignNumber) {
        
        Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                    WHERE CMPGN_NR__c = :campaignNumber LIMIT 1];
        
        return calendar;
    }
    
    protected String ParseFullyQualifiedName(String fullyQualifiedName) {
    
        String ruleType = MTRConfigUtility.GetExceptionRule(fullyQualifiedName);

        if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT && fullyQualifiedName.indexOf('GRP_UNIT_SLS_AMT__c') > -1 && this.BadgeTitle == 'SEL') {
            fullyQualifiedName = fullyQualifiedName.replace('GRP_UNIT_SLS_AMT__c', 'GRP_BLCKD_UNIT_SLS_AMT__c');
        }
        else if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER && fullyQualifiedName.indexOf('BOOK1_GRP_UNIT_SLS_AMT__c') > -1 && this.BadgeTitle == 'SEL') {
            fullyQualifiedName = fullyQualifiedName.replace('BOOK1_GRP_UNIT_SLS_AMT__c', 'BOOK1_BLCKD_UNIT_SLS_AMT__c');
        }
        else if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER && fullyQualifiedName.indexOf('BOOK2_GRP_UNIT_SLS_AMT__c') > -1 && this.BadgeTitle == 'SEL') {
            fullyQualifiedName = fullyQualifiedName.replace('BOOK2_GRP_UNIT_SLS_AMT__c', 'BOOK2_BLCKD_UNIT_SLS_AMT__c');
        }   
        else if(fullyQualifiedName.indexOf('LDRSHP_TITL_LVL_NR__c') > -1 && this.GetSupportedSearchClassName(this.SearchType) == 'MTRFilterSearch') {
            
            CampaignRetrievalDTO campaignRetrievalDTO = this.GetCampaignValues();
    
            if(this.MarketFutureCampaign != campaignRetrievalDTO.CampaignValues.CurrentCampaign && this.MarketCurrentCampaign != campaignRetrievalDTO.CampaignValues.CurrentCampaign) {
                fullyQualifiedName = fullyQualifiedName.replace('LDRSHP_TITL_LVL_NR__c', 'PD_TITL_LVL_NR__c');
            }
        }
        
        return fullyQualifiedName;
    }
    
    protected ColumnInfo CloneReverseNameColumnInfo(ColumnInfo columnInfo) {
        
        String[] arData = null;
        ColumnInfo cloneColumnInfo = null;
        String newFullyQualifiedName = '';
        
        arData = columnInfo.FullyQualifiedName.split(',');
        
        if(arData.size() >= 2) {
            
            cloneColumnInfo = columnInfo.Clone();
             
            newFullyQualifiedName = String.escapeSingleQuotes(arData[1]) + ', ' + String.escapeSingleQuotes(arData[0]);
            newFullyQualifiedName = newFullyQualifiedName.replace(' ', '');
            
            if(newFullyQualifiedName.contains('TAG')){
                cloneColumnInfo.Name = mktTagsMap.get(newFullyQualifiedName);
                cloneColumnInfo.FullName = mktTagsMap.get(newFullyQualifiedName);
            }
            else{
                cloneColumnInfo.Name = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnLabel(newFullyQualifiedName),''));
                cloneColumnInfo.FullName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnFullNameLabel(newFullyQualifiedName),cloneColumnInfo.Name));
            }
            cloneColumnInfo.FullyQualifiedName = newFullyQualifiedName; 
        }
        
        return cloneColumnInfo;
    }
    
    protected ColumnInfo CloneOppositeBadgeTitleColumnInfo(ColumnInfo columnInfo) {
        
        String[] arData = null;
        ColumnInfo cloneColumnInfo = null;

        if(columnInfo.FullyQualifiedName != null && columnInfo.FullyQualifiedName.indexOf(',') == -1) {
            
            cloneColumnInfo = columnInfo.Clone();
            
            if(columnInfo.FullyQualifiedName.indexOf('LDRSHP_TITL_LVL_NR__c') > -1) {
                
                cloneColumnInfo.FullyQualifiedName = 'PD_TITL_LVL_NR__c';
            }
            else if(columnInfo.FullyQualifiedName.indexOf('PD_TITL_LVL_NR__c') > -1) {
                
                cloneColumnInfo.FullyQualifiedName = 'LDRSHP_TITL_LVL_NR__c';
            }
            
            if(cloneColumnInfo.FullyQualifiedName.contains('TAG')){
                cloneColumnInfo.Name = mktTagsMap.get(cloneColumnInfo.FullyQualifiedName);
                cloneColumnInfo.FullName = mktTagsMap.get(cloneColumnInfo.FullyQualifiedName);
            }
            else{
                cloneColumnInfo.Name = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnLabel(cloneColumnInfo.FullyQualifiedName),''));
                cloneColumnInfo.FullName = MTRConfigUtility.EscapeBadJavascriptChars(this.MakeValueSafe(ALMReportLabels.getReportColumnFullNameLabel(cloneColumnInfo.FullyQualifiedName),cloneColumnInfo.Name));
            }
        }
        
        return cloneColumnInfo;
    }
    
    //Gets specified filters in Search Type object from database and builds query
    protected ReportFilterDTO GetCriteriaFromReportFilter(Id reportConfigId, Set<String> filterKeySet) {
        
        Map<Id, Report_Filter__c> reportFilterMap = new Map<Id, Report_Filter__c>([SELECT Id, Name, Filter_Key__c, Filter_Type__c, Filter_Criteria__c, Generations_Depth__c, Is_Drillable__c, Is_Sortable__c, Is_Rep_List_Restricted__c, Sort_Order__c FROM Report_Filter__c
                                                WHERE Report_Config__c = :reportConfigId 
                                                AND Filter_Key__c IN :filterKeySet]);
        Map<String, Report_Filter__c> newReportFilterMap = new Map<String, Report_Filter__c>();
                                                
        ReportFilterDTO reportFilterDTO = new ReportFilterDTO();
        String soqlFilterCriteria = '';
        
        for(Report_Filter__c reportFilter: reportFilterMap.values()) {
            
            if(soqlFilterCriteria.length() == 0) {
                soqlFilterCriteria = reportFilter.Filter_Criteria__c;
            }
            else {
                soqlFilterCriteria += ' AND ' + reportFilter.Filter_Criteria__c;
            }
            
            newReportFilterMap.put(reportFilter.Filter_Type__c, reportFilter);
        }
        
        reportFilterDTO.ReportFilterMap = newReportFilterMap;
        reportFilterDTO.SOQLFilterCriteria = soqlFilterCriteria;

        return reportFilterDTO;
    }
    
    protected String GetColumnNameByPartialSortField(String sortField, Boolean startsWithMatch) {
        
        String columnName = '';
        Boolean foundMatch = false;
        
        sortField = sortField.toLowerCase();
        
        for(ColumnInfo columnInfo: this.ColumnInfoMap.values()) {
            
            if((startsWithMatch && columnInfo.FullyQualifiedName.toLowerCase().startsWith(sortField)) 
                    || (!startsWithMatch && columnInfo.FullyQualifiedName.toLowerCase().indexOf(sortField) > -1)) {
                columnName = columnInfo.Name;
                foundMatch = true;
                break;
            }
        }
        
        if(!foundMatch) {

            for(ColumnInfo columnInfo: this.ColumnInfoMap2.values()) {
                
                if((startsWithMatch && columnInfo.FullyQualifiedName.toLowerCase().startsWith(sortField))
                    || (!startsWithMatch && columnInfo.FullyQualifiedName.toLowerCase().indexOf(sortField) > -1)) {
                    columnName = columnInfo.Name;
                    break;
                }
            }           
        }
        
        return columnName;
    }
    
    protected void DisableTList() {
        
        String tListColumnName = MTRConfigUtility.getJSFixedTListLabel();
        
        this.MaxPageLimitReached = false;
        
        for(Integer n = 0; n <= this.ColumnOrderList.size() - 1; n++) {
            
            if(this.ColumnOrderList[n] == tListColumnName) {

                this.ColumnOrderList.remove(n);
                    
                break;
            }
        }
        
        this.FullyQualifiedColumnNameSet.remove('GENRTN_1_TITL_STF_CNT__c');
    }
    
    //Generates SOQL query based on Search Type object
    protected String GenerateSOQLQuery() {
        System.debug('\n @@@@@@@@@@  GenerateSOQLQuery 1 ');
        List<String> dupeSortList = new List<String>();
        Set<String> sortExistsSet = new Set<String>();
        Set<String> filterKeySet = new Set<String>();
        String[] arrCampaignNumbers = null;
        String[] arrSortBy = null;
        ReportFilterDTO reportFilterDTO = null;
        Market__c market = null;
        Report_Filter__c reportFilter = null;
        CampaignRetrievalDTO campaignRetrievalDTO = null;
        CampaignDTO campaignDTO = null;
        MTRSearchOptions.MTRTextSearch textSearchType = null;
        MTRSearchOptions.MTRFilterSearch filterSearchType = null;
        SObject obj = null;
        String query = '';
        String querySortBy = '';
        String queryGenerationDepth = '';
        String columns =  this.GetColumnsFromReportConfig();
        String adjustedAccountId = String.escapeSingleQuotes(this.SearchType.AccountNumber);
        String firstLastNameLabel = MTRConfigUtility.getJSFixedFirstLastNameLabel();
        String lastFirstNameLabel = MTRConfigUtility.getJSFixedLastFirstNameLabel();
        String repStatusField = 'REP_OMS_STUS_CD__c';
        String accountIds = '';
        String leadershipNumbers = '';
        String previousCampaign = '';
        String currentCampaign = '';
        String filterCriteria = '';
        String whoSortBy = '';
        String whatSortBy = '';
        String searchTypeSortBy = '';
        String sortDirection = '';
        String firstSortBy = '';
        String adjustedFirstSortBy = '';
        String ruleType = '';
        Integer whoGenDepthNumber = 0;
        Integer whatGenDepthNumber = 0;
        Integer generationTotal = 0;
        Integer position = -1;
        Boolean searchByList = (this.SearchType.SelectIds != null && this.SearchType.SelectIds.size() > 0);
        String rootUplineAcc = this.leaderInfo.rootUplnAccNo;
        Decimal leaderLevel = this.leaderInfo.genLevel;
        Decimal leaderLeftId = this.leaderInfo.leftId;
        Decimal leaderRightId = this.leaderInfo.rightId; 
        Boolean whoIsSpecial = false;
        Boolean isDrillable = true;
        Boolean isSortable = true;
        Boolean isRepListRestricted = false;
        Boolean hasFilterSortBy = false;
        Boolean sortByGen = false;
        
        repStatusField = repStatusField.toUpperCase();
        
        this.AdjustedSortField = '';
        
        this.BranchSummary = null;
        
        system.debug(this.SearchType.SelectIds);
        system.debug(this.SearchType.SelectIds.size());
        
        query = 'SELECT [[columns]] FROM '+ this.marketRepIndicator ;        
        //System.debug('\n @@@@@@@@@@  GenerateSOQLQuery 1222222222222222 ');
        if(searchByList) {
            
            for(String tempId: this.SearchType.SelectIds) {
                
                if(accountIds.length() == 0) {
                    accountIds = '\'' + String.escapeSingleQuotes(tempId) + '\'';
                }
                else {
                    accountIds += ', \'' + String.escapeSingleQuotes(tempId) + '\'';
                }
                /*
                if(accountIds.length() == 0) {
                    accountIds = '\'' + String.escapeSingleQuotes(tempId) + '\'';
                }
                else {
                    
                    // Assuming here that this will never occor. Multiple expansion account ids
                    // will not be passed. To track such a case,a dding exception here.
                    //throw new ArgumentException('MTRSOQLBuilder::GenerateSOQLQuery Exception Error=Multiple account ids selected for expansion');
                    
                    accountIds += ', \'' + String.escapeSingleQuotes(tempId) + '\'';
                }
                */
            }
            if(this.SearchType.SelectIds.size() > 1){
                query += '  WHERE ACCT_NR__c IN (' + accountIds + ') ';
            }
            //SearchForDownline is only supported by MyTeam ReportType
            else if(MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) && this.SearchType.SearchForDownline) {
                
                query += '  WHERE UPLN_ACCT_NR__c IN (' + accountIds + ') AND Genealogy_Level__c = [[parentGenPlus1]] ';
            }
            else {
            
                query += '  WHERE ACCT_NR__c IN (' + accountIds + ') '; 
            }
        }
        else {
    
            //Make sure we always have UPLN_GEN_INDX__c = 1 for non-MyTeam ReportType searches
            if(!this.SearchType.SearchForDownline && (this.SearchType instanceof MTRSearchOptions.MTRTextSearch 
                        || this.SearchType instanceof MTRSearchOptions.MTRFilterSearch)) {
                        
                //query += '  WHERE UPLN_ACCT_NR__c = \'[[accountNum]]\'';
                query += '  WHERE ROOT_UPLN_ACCT_NR__c = \''+ rootUplineAcc  +'\' AND LFT_ND_ID__c > '+leaderLeftId+ ' AND RGT_ND_ID__c < ' + leaderRightId +' ';
            }
            else if((this.SearchType.SearchForDownline && this.SearchType instanceof MTRSearchOptions.MTRFilterSearch) 
                        || this.SearchType instanceof MTRSearchOptions.MTRRegularSearch) {
                query += '  WHERE UPLN_ACCT_NR__c = \'[[accountNum]]\' AND Genealogy_Level__c = [[parentGenPlus1]] ';
            }
        }
    
         //System.debug('\n @@@@@@@@@@  GenerateSOQLQuery 333333333333333333333333 ');
        //TextSearch is for MyTeam Report Type only
        if(MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType)  && this.SearchType instanceof MTRSearchOptions.MTRTextSearch) {
            System.debug('\n ======= IF ============== NOW');
            //System.debug('\n @@@@@@@@@@  GenerateSOQLQuery 44444444444 ');
            textSearchType = (MTRSearchOptions.MTRTextSearch)this.SearchType;

            campaignRetrievalDTO = this.GetCampaignValues();
            
            String adjustedTSCriteria = textSearchType.TSCriteria.toLowerCase();
            
            previousCampaign = String.valueOf(campaignRetrievalDTO.CampaignValues.PreviousCampaign);
            currentCampaign = String.valueOf(campaignRetrievalDTO.CampaignValues.CurrentCampaign);
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            query += ' AND FLD_SLS_CMPGN_NR__c = '+ Double.valueOf(campaignRetrievalDTO.CampaignValues.CurrentCampaign);    
            
            if(!searchByList) {
                
                if(adjustedTSCriteria == 'name') {
                    query += ' AND MRKT_ACCT_KEY__r.LastName LIKE \'' + String.escapeSingleQuotes(textSearchType.TextSearch) + '%\'';
                }
                else if(adjustedTSCriteria == 'accountnumber') {
                    query += ' AND ACCT_NR__c LIKE \'' + String.escapeSingleQuotes(textSearchType.TextSearch) + '%\'';
                }
                else if(adjustedTSCriteria == 'branch') {
                    query += ' AND BRNCH_NM__c LIKE \'' + String.escapeSingleQuotes(textSearchType.TextSearch) + '%\'';
                    
                    if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
                        //modification by Supriyo April 12, 2013 as in MTO search by branch was giving error    
                        /*String branchSummaryKey = MTRConfigUtility.CreateBranchSummaryKey(this.AvonMarketId, campaignRetrievalDTO.CampaignValues.CurrentCampaign, this.SearchType.AccountNumber, textSearchType.TextSearch);
                        
                        this.BranchSummary = [SELECT Id, BRNCH_SCTN_CD__c, BOOK1_GRP_UNIT_SLS_AMT__c, BOOK2_GRP_UNIT_SLS_AMT__c, GRP_UNIT_SLS_AMT__c, GRP_FAP_CNT__c, GRP_BRCHR_CNT__c, GRP_BAL_AMT__c, GRP_PAST_DUE_AMT__c, SPPY_GRP_UNIT_SLS_AMT__c, YTD_GRP_UNIT_SLS_AMT__c FROM Branch_Summary__c 
                            WHERE Branch_Summary_Key__c = :branchSummaryKey LIMIT 1];*/
                        this.BranchSummary = [SELECT Id, BRNCH_SCTN_CD__c, BOOK1_GRP_UNIT_SLS_AMT__c, BOOK2_GRP_UNIT_SLS_AMT__c, GRP_UNIT_SLS_AMT__c, GRP_FAP_CNT__c, GRP_BRCHR_CNT__c, GRP_BAL_AMT__c, GRP_PAST_DUE_AMT__c, SPPY_GRP_UNIT_SLS_AMT__c, YTD_GRP_UNIT_SLS_AMT__c FROM Branch_Summary__c 
                            WHERE MRKT_ID__c = :this.AvonMarketId
                            AND CMPGN_NR__c = :campaignRetrievalDTO.CampaignValues.CurrentCampaign
                            AND BRNCH_SCTN_CD__c LIKE :String.escapeSingleQuotes(textSearchType.TextSearch)
                            LIMIT 1];
                    }
                    
                    this.IsDrillable = false;
                }
                
                if(this.MaxPageLimitReached) {
                    
                    this.DisableTList();
                    this.IsDrillable = false;
                }
            }
        }
        else if(this.SearchType instanceof MTRSearchOptions.MTRFilterSearch) {
            System.debug('\n ======= ELSE IF ============== NOW');
            filterSearchType = (MTRSearchOptions.MTRFilterSearch)this.SearchType;
            System.debug('filterSearchType-->'+filterSearchType);
            System.debug('\n ======= ELSE IF filterSearchType.CampaignId ============== '+filterSearchType.CampaignId);
            if(filterSearchType.CampaignId != null && filterSearchType.CampaignId.length() > 0) {
                
                campaignDTO = MTRSOQLBuilder.ParseCampaignValues(filterSearchType.CampaignId);
                System.debug('\n ======= campaignDTO.PreviousCampaign :: '+campaignDTO.PreviousCampaign);
                System.debug('\n ======= campaignDTO.CurrentCampaign :: '+campaignDTO.CurrentCampaign);
                System.debug('\n ======= this.SelectedCurrentCampaign :: '+this.SelectedCurrentCampaign);
                System.debug('\n ======= this.MarketFutureCampaign :: '+this.MarketFutureCampaign);
                System.debug('\n ======= this.MarketCurrentCampaign :: '+this.MarketCurrentCampaign);
                previousCampaign = String.valueOf(campaignDTO.PreviousCampaign);
                currentCampaign = String.valueOf(campaignDTO.CurrentCampaign);
                
                Boolean cachedIsFutureOrPresentCmpgn = (this.SelectedCurrentCampaign == this.MarketFutureCampaign || this.SelectedCurrentCampaign == this.MarketCurrentCampaign);
                Boolean currentIsFutureOrPresentCmpgn = (campaignDTO.CurrentCampaign == this.MarketFutureCampaign || campaignDTO.CurrentCampaign == this.MarketCurrentCampaign);
                System.debug('\n ======= cachedIsFutureOrPresentCmpgn :: '+cachedIsFutureOrPresentCmpgn);
                System.debug('\n ======= currentIsFutureOrPresentCmpgn :: '+currentIsFutureOrPresentCmpgn);
                if(this.SelectedCurrentCampaign != 0 && cachedIsFutureOrPresentCmpgn != currentIsFutureOrPresentCmpgn) {
                    System.debug('\n ======= currentIsFutureOrPresentCmpgn 1');
                    this.CampaignTypeChanged = true;
                }
                else {
                    System.debug('\n ======= currentIsFutureOrPresentCmpgn 2');
                    this.CampaignTypeChanged = true;
                }
                        
                this.SelectedCurrentCampaign = campaignDTO.CurrentCampaign;
                
                //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
                query += ' AND FLD_SLS_CMPGN_NR__c = '+ Double.valueOf(this.SelectedCurrentCampaign);
                
                if(!searchByList) {
                    
                    if(this.ReportType == ALMConstants.REPORT_TYPE_G1APPT) {
        
                        campaignRetrievalDTO = this.GetCampaignValues();
                        
                     //   query += ' AND (REP_OMS_STUS_CD__c = \'-2\'';
                        query += ' OR (REP_OMS_STUS_CD__c = \'1\' AND REP_APPT_CMPGN_NR_NUMBER__c = ' + campaignRetrievalDTO.CampaignValues.CurrentCampaign  + ')';
                        query += ' OR (REP_OMS_STUS_CD__c = \'1\' AND REP_APPT_CMPGN_NR_NUMBER__c < ' + campaignRetrievalDTO.CampaignValues.CurrentCampaign + ' AND FRST_ORDR_AMT__c > ' + this.SponsorQualifyingOrderAmount;
                        query += ' AND FRST_ORDER_DUE_DT__c > ' +  String.valueOf(campaignRetrievalDTO.CurrentCampaignCalendar.CMPGN_STRT_DT__c) + '))';
                    }
                    else if(this.ReportType == ALMConstants.REPORT_TYPE_RISINGSTARS) {
                    
                        List<Leader_Title__c> leaderTitleList = [SELECT Id, LDRSHP_TITL_LVL_NR__c FROM Leader_Title__c WHERE MRKT_ID__c = :this.AvonMarketId AND EXEC_IND__c = 'Y'];
                        
                        for(Leader_Title__c leaderTitle: leaderTitleList) {
                    
                            if(leadershipNumbers.length() == 0) {
                                leadershipNumbers = '\'' + leaderTitle.LDRSHP_TITL_LVL_NR__c + '\'';
                            }
                            else {
                                leadershipNumbers += ', \'' + leaderTitle.LDRSHP_TITL_LVL_NR__c + '\'';
                            }
                        }
                
                        query += ' AND (LDRSHP_TITL_LVL_NR__c IN (' + leadershipNumbers + ')';
                        query += ' OR (RSNG_STR_IND__c = \'Y\' OR EXEC_RSNG_STR_IND__c = \'Y\'))';
                    }
                }
            }
            
            system.debug('@@@@@@@@@@@@@@@@' + filterSearchType.Who);
            
            if(!searchByList && MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType)) {
            
                if(filterSearchType.Who != null && filterSearchType.Who.length() > 0) {
                    
                    if(filterSearchType.Who.startsWith('TITL')) {
                        if(filterSearchType.Who.contains('SELGR'))
                        {
                            String whoFilter = filterSearchType.Who.replace('TITL','');
                            whoFilter = whoFilter.replace('SELGR','');
                            query += ' AND LDRSHP_TITL_LVL_NR__c IN ('+whoFilter+ ')';
                        }
                        else
                        {
                            query += ' AND LDRSHP_TITL_LVL_NR__c = \'' + String.escapeSingleQuotes(filterSearchType.Who.replace('TITL','')) + '\'';
                        }
                        whoIsSpecial = true;
                    }
                    else if(filterSearchType.Who.startsWith('PTITL')) {
                        if(filterSearchType.Who.contains('SELGR'))
                        {
                            String whoFilter = filterSearchType.Who.replace('PTITL','');
                            whoFilter = whoFilter.replace('SELGR','');
                            query += ' AND LDRSHP_TITL_LVL_NR__c IN ('+whoFilter+ ')';
                        }
                        else
                        {
                            query += ' AND PD_TITL_LVL_NR__c = \'' + String.escapeSingleQuotes(filterSearchType.Who.replace('PTITL','')) + '\'';
                        }
                        whoIsSpecial = true;
                    }
                    else {
            
                        filterKeySet.add(String.escapeSingleQuotes(filterSearchType.Who));
                    }
                }   
    
                if(filterSearchType.What != null && filterSearchType.What.length() > 0 && filterSearchType.What.toLowerCase() != 'all') {
            
                    filterKeySet.add(String.escapeSingleQuotes(filterSearchType.What));
                }   
            }
           
            if(filterKeySet.size() > 0) {
                if(filterKeySet.contains('All_Badge_Titles') && filterKeySet.size()>1){
                    filterKeySet.remove('All_Badge_Titles');
                     sortByGen= true;
                }
                if(filterKeySet.contains('All_Generations') && filterKeySet.size()>1){
                    filterKeySet.remove('All_Generations');
                    sortByGen= true;
                }
                reportFilterDTO = GetCriteriaFromReportFilter(this.ReportConfigId, filterKeySet);
                
                if(!whoIsSpecial) {
                    
                    reportFilter = reportFilterDTO.ReportFilterMap.get('Who');
                    
                    if(reportFilter != null) {
                    
                        isDrillable = reportFilter.Is_Drillable__c;
                        isSortable = reportFilter.Is_Sortable__c;
                        isRepListRestricted = reportFilter.Is_Rep_List_Restricted__c;

                        whoGenDepthNumber = (reportFilter.Generations_Depth__c != null && reportFilter.Generations_Depth__c.length() > 0 && reportFilter.Generations_Depth__c != 'All') ? Integer.valueOf(reportFilter.Generations_Depth__c) : 0;
                        
                        if(reportFilter.Sort_Order__c != null && reportFilter.Sort_Order__c.length() > 0) {
                            whoSortBy = reportFilter.Sort_Order__c;
                        }
                    }
                }
                
                reportFilter = reportFilterDTO.ReportFilterMap.get('What');
                
                if(reportFilter != null) {
            
                    if(isDrillable) {
                        isDrillable = reportFilter.Is_Drillable__c;
                    }
                    
                    if(isSortable) {
                        isSortable = reportFilter.Is_Sortable__c;
                    }
                    
                    if(isRepListRestricted) {
                        isRepListRestricted = reportFilter.Is_Rep_List_Restricted__c;
                    }
                    
                    whatGenDepthNumber = (reportFilter.Generations_Depth__c != null && reportFilter.Generations_Depth__c.length() > 0 && reportFilter.Generations_Depth__c != 'All') ? Integer.valueOf(reportFilter.Generations_Depth__c) : 0;
                    
                    if(reportFilter.Sort_Order__c != null && reportFilter.Sort_Order__c.length() > 0) {
                        whatSortBy = reportFilter.Sort_Order__c;
                    }
                }
                
                this.IsDrillable = isDrillable;
                this.IsSortable = isSortable;
                this.IsRepListRestricted = isRepListRestricted;
                
                
                if(reportFilterDTO.SOQLFilterCriteria.length() > 0) {
                
                    query += ' AND ' + reportFilterDTO.SOQLFilterCriteria;
                    
                    filterCriteria = reportFilterDTO.SOQLFilterCriteria;
                }
                
                if(!searchByList && !this.SearchType.SearchForDownline && (whoGenDepthNumber > 0 || whatGenDepthNumber > 0)) {
            
                    if(whoGenDepthNumber >= whatGenDepthNumber) {
                        generationTotal = whoGenDepthNumber;
                    }
                    else {
                        generationTotal = whatGenDepthNumber;
                    }
                    
                    for(Integer n = (Integer)leaderLevel+1; n <= generationTotal+(Integer)leaderLevel; n++) {
                        
                        if(queryGenerationDepth.length() == 0) {
                            queryGenerationDepth = String.valueOf(n);
                        }
                        else {
                            queryGenerationDepth += ', ' + String.valueOf(n);
                        }
                    }
                    
                    query += ' AND Genealogy_Level__c IN (' + queryGenerationDepth + ')';
                }
                System.debug('WhoSort --> '+whoSortBy+' whatSortBy --> '+whatSortBy);
                if(whoSortBy.length() > 0 || whatSortBy.length() > 0) {
                    
                    dupeSortList.addAll(whatSortBy.split(','));
                    dupeSortList.addAll(whoSortBy.split(','));
                    
                    if(sortByGen){
                        dupeSortList.add('Genealogy_Level__c ASC');
                    }
                    
                    for(String sortBy: dupeSortList) {
                        
                        sortBy = sortBy.trim();
                        
                        if(sortBy.length() > 0 && !sortExistsSet.contains(sortBy)) {
                            System.debug('\n ####### 1 sortBy.length() > 0 && !sortExistsSet.contains(sortBy)) ');
                            if(querySortBy.length() == 0) {
                                if(sortByGen){
                                    querySortBy='Genealogy_Level__c ASC';
                                }
                                else{
                                    querySortBy = String.escapeSingleQuotes(sortBy);
                                }
                                System.debug('\n ####### 1 sortBy.length() > 0 && !sortExistsSet.contains(sortBy)) querySortBy '+querySortBy);
                            }
                            else {
                                System.debug('\n ####### 1 sortBy.length() > 0 && !sortExistsSet.contains(sortBy)) Else');
                                querySortBy += ', ' + String.escapeSingleQuotes(sortBy);
                                System.debug('\n ####### 1 sortBy.length() > 0 && !sortExistsSet.contains(sortBy)) Else querySortBy '+querySortBy);
                            }
                  
                            sortExistsSet.add(sortBy);
                        }
                    }
                    
                    hasFilterSortBy = true;
                    
                }
            }
            
            
            //Handle T-List scenario when filter IsRepListRestricted or when there are no filters
            if(!searchByList) {
                System.debug('\n ### filterKeySet.size() '+filterKeySet.size());
                System.debug('\n ### this.IsRepListRestricted '+this.IsRepListRestricted);
                System.debug('\n ### this.MaxPageLimitReached '+this.MaxPageLimitReached);
                
                if(filterKeySet.size() > 0 && !this.IsRepListRestricted) {
                    System.debug('\n ### 11111111111');
                    this.DisableTList();
                }
                else if((filterKeySet.size() > 0 && this.IsRepListRestricted && this.MaxPageLimitReached )   //&& this.MaxPageLimitReached
                            || (filterKeySet.size() == 0 && this.MaxPageLimitReached) && (this.ReportType.equals(ALMConstants.REPORT_TYPE_MYTEAM_ORDER))) {  //&& this.MaxPageLimitReached
                        System.debug('\n ### 22222222222222');
                        if(filterSearchType.Who!='G1_Candidate'){
                            //Changed by Milon on 10/25 for Defect 3011 request by Cristina.
                            query += ' AND GENRTN_1_STF_CNT__c > 0';
                            //query += ' AND GENRTN_1_TITL_STF_CNT__c > 0'; // query += ' AND GENRTN_1_STF_CNT__c > 0';
                        }
                        //query += ' AND GENRTN_1_TITL_STF_CNT__c > 0';
                        
                    
                }
            }
        }
        //System.debug('\n @@@@@@@@@@  GenerateSOQLQuery 66666666666666666 ');
        if(!searchByList && MTRConfigUtility.IsMyTeamReportCompatible(this.ReportType) 
            && ((this.SearchType instanceof MTRSearchOptions.MTRFilterSearch && filterCriteria.toUpperCase().indexOf(repStatusField) == -1) 
                    || this.SearchType instanceof MTRSearchOptions.MTRTextSearch)) {
            
            if(this.IncludeRemovedReps) {
                query += ' AND (REP_OMS_STUS_CD__c = \'1\'  OR  REP_OMS_STUS_CD__c = \'0\')';
            }
            else {
                query += ' AND REP_OMS_STUS_CD__c = \'1\'';
            }
        }
        
        if(!searchByList && this.SearchType.IsTList) {
            this.IsDrillable = false;
        }
        
        query = query.replace('[[columns]]', columns).replace('[[accountNum]]', adjustedAccountId);
        // Replace every occurence of parentGenPlus in the query
        // Assuming here that only sigle digit levels are present
        
        while(query.contains('[[parentGenPlus')){
        
            Integer levelInc = Integer.valueOf(query.substring(query.IndexOf('[[parentGenPlus')+15, query.IndexOf('[[parentGenPlus')+16));
            query = query.replace('[[parentGenPlus'+levelInc+']]', String.valueOf(leaderLevel+levelInc));
            
        }
        
        if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT || this.ReportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT)     
            query += ' AND LDRSHP_TITL_LVL_NR_NUMBER__c > =0';
        
        if(this.SearchType.SortBy != null && this.SearchType.SortBy.length() > 0) {
            
            if(this.SearchType.IsAscending) {
                sortDirection = 'ASC';
            }
            else {
                sortDirection = 'DESC';
            }
            
            arrSortBy = String.escapeSingleQuotes(this.SearchType.SortBy).split(',');
            
            for(String tempSortBy: arrSortBy) {
                
                if(searchTypeSortBy.length() == 0) {
                    searchTypeSortBy = tempSortBy.trim() + ' ' + sortDirection;
                }
                else {
                    searchTypeSortBy += ', ' + tempSortBy.trim() + ' ' + sortDirection;
                }
            }
            
            if(querySortBy.length() == 0) {
                System.debug('\n ####### 2 querySortBy.length() == 0');
                querySortBy = searchTypeSortBy;
                System.debug('\n ####### 2 querySortBy.length() == 0 querySortBy '+querySortBy);
            }
            else {
                System.debug('\n ####### 2 querySortBy.length() == 0 ELSE');
                querySortBy = searchTypeSortBy + ', ' + querySortBy;
                System.debug('\n ####### 2 querySortBy.length() == 0 ELSE querySortBy '+querySortBy);
            }
        }
        else if(this.OrderCriteria != null && this.OrderCriteria.length() > 0) {
            
            if(querySortBy.length() == 0) {
                System.debug('\n ####### 3 querySortBy.length() == 0');
                querySortBy = String.escapeSingleQuotes(this.OrderCriteria);
                System.debug('\n ####### 3 querySortBy.length() == 0 querySortBy');
            }
            else {
                System.debug('\n ####### 3 querySortBy.length() == 0 Else'); 
                querySortBy = String.escapeSingleQuotes(this.OrderCriteria) + ', ' + querySortBy;
                System.debug('\n ####### 3 querySortBy.length() == 0 Else querySortBy '+querySortBy);
            }
        }
        
        this.DefaultSortColumn = '';    
        this.SortIsAscending = true;
        
        //System.debug('\n @@@@@@@@@@  GenerateSOQLQuery WWWWWWWWWWW '); SFDCMarketId
        query += ' AND MRKT_ID__c =\'' + this.AvonMarketId+'\' ';
        
        if(querySortBy != null && querySortBy.length() > 0) {
            System.debug('\n ####### 4  querySortBy '+querySortBy);
            firstSortBy = MergeFields(querySortBy, previousCampaign, currentCampaign);
            
            position = firstSortBy.indexOf(',');
            
            if(position > -1) {
                
                firstSortBy = firstSortBy.substring(0, position);
            }
            else {
                firstSortBy = firstSortBy;
            }
            
            firstSortBy = firstSortBy.trim();
            adjustedFirstSortBy = firstSortBy.toLowerCase();
            
            if(adjustedFirstSortBy.endsWith('asc')) {
                this.SortIsAscending = true;
            }
            else if(adjustedFirstSortBy.endsWith('desc')) {
                this.SortIsAscending = false;
            }
            
            if(this.SearchType.ReverseNameSortColumnName != null && this.SearchType.ReverseNameSortColumnName.length() > 0) {
                    
                this.AdjustedSortField = this.SearchType.SortBy.replaceAll('(?i)ASC', '').replaceAll('(?i)DESC','');
                this.DefaultSortColumn = this.GetColumnNameByPartialSortField(this.AdjustedSortField.replace(' ',''), true);
            }
            else {
                
                adjustedFirstSortBy = firstSortBy.replaceAll('(?i)ASC', '').replaceAll('(?i)DESC','').replace(' ','');
                
                ruleType = MTRConfigUtility.GetExceptionRule(adjustedFirstSortBy);
                
                if(ruleType == 'Name') {
                    
                    this.DefaultSortColumn = this.GetColumnNameByPartialSortField(adjustedFirstSortBy, true);
                }
                else {
                    
                    if(adjustedFirstSortBy == 'Genealogy_Level__c') {
                        this.DefaultSortColumn = MTRConfigUtility.getJSFixedGenerationLabel();
                    }
                    else {
                        this.DefaultSortColumn = this.GetColumnNameByPartialSortField(adjustedFirstSortBy, false);
                    }
                }
            }
            
            this.SearchType.ReverseNameSortColumnName = '';
        
          /*if(this.ReportType != ALMConstants.REPORT_TYPE_MYTEAM_ORDER)
            query += ' AND LDRSHP_TITL_LVL_NR_NUMBER__c > -2';*/
            
          
          /*else if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER)
            query += ' AND LDRSHP_TITL_LVL_NR_NUMBER__c > -2';*/
            System.debug('\n ####### 5  querySortBy '+querySortBy);    
           query += ' ORDER BY ' + querySortBy;
        }
        else
        {
            query += 'ORDER BY Genealogy_Level__c ASC';
        }
        
        if(this.OVERALL_QUERYSET_LIMIT > -1) {
            
            query += ' LIMIT ' + this.OVERALL_QUERYSET_LIMIT;
            //query += ' LIMIT 10' ;
        }
        //System.debug('\n @@@@@@@@@@  GenerateSOQLQuery QQQQQQQQQQQQQ ');
        query = MergeFields(query, previousCampaign, currentCampaign);
        System.debug('\n ===================== MTRSOQLBuilder GenerateSOQLQuery QUERY \n');
        System.debug(query);
        System.debug('\n ===================== MTRSOQLBuilder GenerateSOQLQuery QUERY END \n');
        
        System.debug(Logginglevel.ERROR, 'XXXQuery: ' + query);
        System.debug(Logginglevel.ERROR, 'XXXDefaultSortColumn: ' + this.DefaultSortColumn + ' ' + this.OrderCriteria);
        System.debug('Milon query :'+query);
        
        
        return query;
    }
    
    //Gets Zero Generation records from database based on Report Config information
    public virtual List<SObject> GetZeroGenerationRecords() {
        
        if(this.SearchType == null || this.SearchType.AccountNumber == null || this.SearchType.AccountNumber.length() == 0) {
            throw new ArgumentException('MTRSOQLBuilder::GetZeroGenerationRecords Exception Error=Please specify Account Number in the Search Type.');
        }
    
        Set<String> accountIdSet = new Set<String>();
        Set<String> queryFieldSet = new Set<String>();
        String[] fieldNameSplit = null;
        GenealogySOQLBuilder genealogySOQLBuilder = null;
        String columns =  this.GetColumnsFromReportConfig();
        CampaignRetrievalDTO campaignRetrievalDTO = this.GetCampaignValues();

        fieldNameSplit = columns.split(',');
        
        for(String fieldName : fieldNameSplit) {
            
            queryFieldSet.add(fieldName.trim());
        }
        
        queryFieldSet.add('Name');
//        queryFieldSet.add('MRKT_ACCT_KEY__r.Name');
        queryFieldSet.add('LFT_ND_ID__c');
        queryFieldSet.add('RGT_ND_ID__c');
        queryFieldSet.add('ROOT_UPLN_ACCT_NR__c');
        
        genealogySOQLBuilder = new GenealogySOQLBuilder(this.AvonMarketId, this.SearchType.AccountNumber, queryFieldSet);

        //accountIdSet.add(this.SearchType.AccountNumber);
        //return genealogySOQLBuilder.queryZeroGeneration(campaignRetrievalDTO.CampaignValues.CurrentCampaign, accountIdSet);
        System.debug('campaignRetrievalDTO.CampaignValues.CurrentCampaign '+campaignRetrievalDTO.CampaignValues.CurrentCampaign);
        //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
        String whereClause = ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignRetrievalDTO.CampaignValues.CurrentCampaign)  + ' AND ACCT_NR__c = \'' + this.SearchType.AccountNumber + '\'' +
                                  ' AND MRKT_ID__c = \''+ this.AvonMarketId + '\'' ;
        
        Map<String,String> queryOptionsMap = new Map<String,String>();
        queryOptionsMap.put('WHERE', whereClause);
        queryOptionsMap.put('LIMIT', '1');
        
        List<SObject>  result = genealogySOQLBuilder.queryNew(queryOptionsMap); 
        
        // Verify leader details populated
        if(result != null && result.size() > 0){
            this.leaderInfo = new LeaderInfo(this.SearchType.AccountNumber, (String)result[0].get('ROOT_UPLN_ACCT_NR__c'), (Decimal)result[0].get('LFT_ND_ID__c'), (Decimal)result[0].get('RGT_ND_ID__c'), (Decimal)result[0].get('Genealogy_Level__c'));
        }
        
        return result;
    }
    
    public virtual List<SObject> GetRecords() {

        List<SObject> objList = null;
        String query = GenerateSOQLQuery();
        
        //Added By Chandeep 
        
        /*if(this.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT || this.ReportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT) {    
            query += ' AND LDRSHP_TITL_LVL_NR_NUMBER__c > =0';
         }*/
        
        System.debug('\n @@@@@@@@@ QUERY -- \n'+query);
        objList = Database.query(query);
        
       /* System.debug('\n @@@@@@@@@ QUERY RESULT objList size '+objList.size());
        for(SObject obj : objList){
            System.debug('\n @@@@@@@@@ LOOP  ');
            if (obj.getSObject('Personal_Performance_Key__r') != null) {
            System.debug('\n @@@@@@@@@ LOOP get Personal_Performance_Key__r '); 
                
            System.debug('\n @@@@@@@@@ LOOP get Personal_Performance_Key__r DATA LDRSHP_TITL_LVL_NR__c'+(String)obj.getSObject('Personal_Performance_Key__r').get('LDRSHP_TITL_LVL_NR__c'));    
            }
            if (obj.getSObject('Contact__r') != null) {
            System.debug('\n @@@@@@@@@ LOOP get Contact__r ');      
            System.debug('\n @@@@@@@@@ LOOP get Contact__r DATA Firstname'+(String)obj.getSObject('Contact__r').get('FirstName'));
            System.debug('\n @@@@@@@@@ LOOP get Contact__r DATA Lastname '+(String)obj.getSObject('Contact__r').get('LastName'));   
            }
            if (obj.getSObject('Leadership_Summary_Key__r') != null) {
            System.debug('\n @@@@@@@@@ LOOP get Leadership_Summary_Key__r ');       
            System.debug('\n @@@@@@@@@ LOOP get Leadership_Summary_Key__r DATA ALL_DOWNLN_CNT_WITH_REMV__c'+(String)obj.getSObject('Leadership_Summary_Key__r').get('ALL_DOWNLN_CNT_WITH_REMV__c'));
                
            }
        }*/
        //System.debug('\n @@@@@@@@@ QUERY END');
        return objList;
    }
    

}