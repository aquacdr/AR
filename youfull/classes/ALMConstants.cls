public with sharing class ALMConstants {
    public static final String REP = 'Representative__r.';
    public static final String ORDER = 'Personal_Sales__r.';
    public static final String GROUP_INFO = 'Group_Sales__r.';
    
    public static final String REP_DETL_REP = 'Contact';
    public static final String REP_DETL_ORDER = 'Personal Sales';
    public static final String REP_DETL_GROUP_INFO = 'Group Sales';

    public static final String TEXT_FLD='Text';
    public static final String NUMBER_FLD='Number';
    public static final String CURRENCY_FLD='Currency';
    public static final String YESNO_FLD='YesNo';
    public static final String DATE_FLD='Date';
    public static final String LEADER_TITLE='Badge Title';
    public static final String TOP_TITLE='Badge_Title';
    public static final String LDR_TITLE='LDRSHP_TITL_LVL_NR__c,SPPY_LDRSHP_TITL_LVL_NR__c';
    //subhamay 19102012 for paid title 
    public static final String PD_TITLE='PD_TITL_LVL_NR__c,SPPY_PD_TITL_LVL_NR__c';
    //eoc subhamay 19102012 
    //subhamay 12032013 to add section name used in coaching page
    public static final String CR_PSB = 'PSB';
    public static final String CR_LDR_UI = 'LDR_UI';
    public static final String CR_LDR_TUS = 'LDR_TUS';
    public static final String CR_EUP = 'EUP';
    public static final String DUPLICATE_KPI = 'Duplicate-';
    //UI info breaks into 3 list by Rajib to make the UI info block dynamic
    public static final String CR_LDR_UI_G1 = 'LDR_UI_G1';
    public static final String CR_LDR_UI_G2 = 'LDR_UI_G2';
    public static final String CR_LDR_UI_G3 = 'LDR_UI_G3';
    //EOC - Rajib
    //eoc subhamay 12032013 to add section name used in coaching page
        
    public static final String LEADER_PCS = 'Current President Club Status';
    public static final String LEADER_PCS_PREV = 'Sales_History:PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c';
    public static final String TOP_PCS = 'Paid Title';
    public static final String TOP_PCS_PREV = 'Sales_History:PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c';
    
    public static final String SELLER_STS='MRKT_TOP_SLR_LANG_KEY__c';
    public static final String DIV_NAME='SLS_DIV_NM__c';
    public static final String REGION_NAME='SLS_REGN_NM__c';
    public static final String ZONE_MGR_NAME='SLS_ZONE_MGR_FULL_NM__c';
    public static final String MIN_TO_EARN='Runtime.MIN_TO_EARN__c';
    public static final String CONTACT_INFO='Contact';
    public static final String PERSONAL_SALES='Personal Sales';
    public static final String GROUP_SALES='Group Sales';
    
    public static final String RUNTIME = 'Runtime';
    public static final String REP_MKT_TAG = 'REP_MKT_TAG_';
    public static final String ORD_MKT_TAG = 'ORD_MKT_TAG_';
    public static final String ALM_MKT_TAG = 'ALM_MKT_TAG_';
    public static final String GRP_MKT_TAG = 'GRP_MKT_TAG_';
    public static final String TITLE_TAG = 'Title_';
    
    public static final String CONTACT = 'Contact_Key__r';
    public static final String PP_CONTACT = 'MRKT_ACCT_KEY__r';
    public static final String MY_BUSINESS = 'Personal_Performance_Key__r';
    public static final String SPONSOR_NAME='Sponsor';
    public static final String CURRENT_PRESIDENT_STATUS='Current President Club Status';
    public static final String PRIOR_PRESIDENT_STATUS='Prior President Club Status';
    public static final String HOME_ADDRESS='Home Address';
    public static final String SECONDARY_PH='Secondary Phone Number';
    public static final String WORK_PH_FIELD='REP_WORK_PHONE_NR__c';
    public static final String DATE_DDMM='DDMM';
    public static final String DATE_MMDD='MMDD';
    public static final String DATE_DDMMYY='DDMMYY';
    public static final String DATE_DDMMYYYY='DDMMYYYY';
    
    // New Constants are added - Raktim on 25th Apr, 2012 - START
    public static final String LEADER_PROFL_NAME ='Avon Leader';
    public static final String DM_PROFL_NAME ='Avon Mkt 62 Division Manager';
    public static final String ZM_PROFL_NAME ='Avon Mkt 62 Zone Manager';
    public static final String CSA_PROFL_NAME ='Avon Customer Service Agent';
    // New Constants are added - Raktim on 25th Apr, 2012 - END
    public static final String AES_PRIVATE_KEY = 'O+ARdnIR9Dr+m99CNmeqSg==';
    
    //New Constants are added - Gaziz on 11th May, 2012 START
    public static final String IMPERSON_PARAM_NAME='acctkey';
    public static final String IMPERSON_RETURN_PAGE='origpage';
    //New Constants are added - Gaziz on 11th May, 2012 END 
    
    //New Constants are added - SA on 15th May, 2012 START
    public static final String REPORT_TYPE_MYTEAM_REPORT = 'MyTeamReport';
    public static final String REPORT_TYPE_MYTEAM_ORDER = 'MyTeamOrder';
    public static final String REPORT_TYPE_G1APPT = 'G1_Appointments';
    public static final String REPORT_TYPE_RISINGSTARS = 'Rising_Stars';
    public static final String REPORT_TYPE_G1SALESLEADERS = 'G1_Sales_Leaders';
    public static final String REPORT_TYPE_G1CANDIDATES = 'G1_Candidates';
    
    public static final String REPORT_TYPE_TLIST = 'T_List'; //added by swarnava for Team List
    public static final String REPORT_TYPE_TLISTORDER = 'T_ListOrder'; //added by swarnava for Team List
        
    public static final String REPORT_FILTER_TYPE_G1CANDIDATES = 'G1_Candidate';
    public static final String REPORT_FILTER_TYPE_G1SALESLEADERS = 'G1_Sales_Leader';
    
    public static final String REPORT_TYPE_TITLE_ADV_REPORT = 'TitleAdvancement';
    //New Constants are added - SA on 15th May, 2012 END    
    
    // Addition by Raktim - defect id : 2400 Start
    public static final String REPORT_TYPE_MYNEWREP_REPCONFIG = 'New_Rep';
    public static final String REPORT_TYPE_MYTEAM_REPCONFIG = 'My_Team';
    public static final String REPORT_TYPE_MYTEAMORDER_REPCONFIG = 'My_Team_Order';
    public static final String REPORT_TYPE_TITL_ADV_REPCONFIG = 'Title_Advancement';
    public static final String REPORT_TYPE_TITL_RPTCENTER = 'Report_Center';//added by swarnava for report center
    public static final String REPORT_TYPE_SL_GENEALOGY = 'My_Sales_Leaders_Genealogy';//added by Snehashis
    public static final String REPORT_TYPE_EXEC_SL_GENEALOGY = 'My_Executive_Leaders';//added by Raktim
    public static final String REPORT_TYPE_ERNG_ILLUSTRATR = 'Earning_Illustrator';//added by Raktim
    // Addition by Raktim - defect id : 2400 End
    
    //New Constants are added - Gaziz on 22th May, 2012 START     PLEASE add Level Names Here
    public static final String SEL ='SEL';
    public static final String UL ='UL';
    public static final String EL ='EL';
    public static final String YES ='Yes';
    public static final String NO ='No';
    public static final String RISING_STAR = 'Rising Star';
    public static final String EXEC_RISING_STAR = 'Executive Rising Star';
    public static final String AT_RISK = 'At Risk';
    public static final String PHILIPPINES_MARKET_CODE = '62';
    public static final String LIMIT_PARAM_NAME = 'lim';
    public static final String CAMPAIGN = 'campaign';
    public static final String PRIOR_CAMPAIGN = 'prior';
    public static final String CURRENT_CAMPAIGN = 'current';
    public static final String CURRENT_AND_NEXT_CAMPAIGN = 'current;next';
    public static final String SEARCH_URL_PARAM = 'searchText';
    //New Constants are added - Gaziz on 22th May, 2012 END 
    
    // Added by Raktim on 21Jun 2013 - Mail Plan
    public static final String NEXT_CAMPAIGN = 'next';
    
    //New Constants are added - Gaziz on 25th May, 2012 Begin 
    public static String PV_CMNEEDED_TO_REACH_POS_NAME = 'pv_needed_pos'; //title achievement custom messages names
    public static String PV_CMNEEDED_TO_REACH_NEG_NAME = 'pv_needed_neg';
    public static String PV_CMVIEW_MY_ORDERS_NAME = 'pv_view_my_orders';
    public static String G1_CMNEEDED_TO_REACH_POS_NAME = 'g1_needed_pos';
    public static String G1_CMNEEDED_TO_REACH_NEG_NAME = 'g1_needed_neg';
    public static String G1_TITLED_LEGS_NAME = 'g1_titled';
    public static String TS_CMMORE_TO_REACH_POS_NAME = 'ts_needed_pos';
    public static String TS_CMMORE_TO_REACH_NEG_NAME = 'ts_needed_neg';
    
    public static String RI_CM_EARNED_POS_NAME = 'ri_earned_pos'; //incentives custom messages names
    public static String RI_CM_EARNED_NEG_NAME = 'ri_earned_neg';
    public static String TS_CM_TO_REACH_POS_NAME = 'ts_toreach_pos';
    public static String TS_CM_TO_REACH_NEG_NAME = 'ts_toreach_neg';
    public static String LI_CMNEEDED_TO_EARN_POS_NAME = 'li_needed_pos';
    public static String LI_CMNEEDED_TO_EARN_NEG_NAME = 'li_needed_neg';
    
    public static String RR_MESSAGE_NAME = 'rising_star_message';
    public static String G1APP_MESSAGE_NAME = 'g1_app_message';
    public static String G1CAN_MESSAGE_NAME = 'g1_can_message';
    public static String G1SALES_LEADERS_MESSAGE_NAME = 'g1_sal_lead_message';
    public static String DEFAULT_NUMBER_OF_RECORDS = '15';
    public static Integer DEFAULT_HEIGHT_OF_ROWS = 100;
    //New Constants are added - Gaziz on 25th May, 2012 END
    public static String BRANCH_REPORT = 'Branch Report'; //used for CDW download path
    
    //New Constants are added - Gaziz on June 10, 2012 BEGIN
    public static String COACHING_FUNCTION_CALL = 'viewRepDetail';
    public static String LIMIT_OF_LANDING_PAGE_SEARCH = '80'; 
    
    // Mail Plan Change - by Raktim
    public static String DIVISION = 'Division'; 
    public static String ZONE = 'Zone';
    public static String Customer = 'Customer';  
    public static String OPEN_MAIL_PLAN_REPORT_KEY = 'Open_Mail_Plan'; 
    public static String DM_ZONEPERF_REPORT_NAME = 'My Zones Performance'; 
    public static String DM_ZONEPERF_REPORT_NAME_AT = 'Activity Report';
    public static String DM_ZONEPERF_REPORT_NAME_ACTVT_TRACKR  = 'Activity Tracker';    
    
    public static String DM_ELIG_REPORT_NAME = 'Leaders Eligibility Report All Zones'; 
    
    public static String UPDATE_DATE_FRMT = 'MM/dd/yyyy';
    
    //New Constants are added - Gaziz on June 25, 2012 BEGIN
    public static String LANDING_PAGE_URL = 'YouHome?pgId=1';
    //New Constants are added - Gaziz on June 25, 2012 END 
    
    //New Constants are added - Raktim on Feb 12, 2013 BEGIN
    public static String EMAIL = 'Email';
    public static String PHONE = 'Phone';
    public static String BIRTH_DATE = 'BIRTH_DATE';
    public static String ANNIV_DATE = 'Anniversary_Date';
    //New Constants are added - Raktim on Feb 12, 2013 END
    
    //New Constants are added - Parul Gupta on Nov 12, 2013 BEGIN
    public static final String KPI_MEASUREMENT_PERCENT_ATTAINMENT = 'Percent Attainment';
    public static final String KPI_MEASUREMENT_DIFFERENCE = 'Difference';
    //New Constants are added - Parul Gupta on Nov 12, 2013 END
    
    //New Constants are added - Parul Gupta on Nov 14, 2013 BEGIN
    public static final Integer GOALTOMAX_ACTUAL_UPPER_RANGE = 96;
    public static final Integer GOALTOMAX_ACTUAL_LOWER_RANGE = 90;
    public static final Integer NOT_GOALTOMAX_UPPER_RANGE = 106;
    public static final Integer NOT_GOALTOMAX_LOWER_RANGE = 100;
    public static final String BAR_COLOR_RED = 'red';
    public static final String BAR_COLOR_GREEN = 'green';
    public static final String BAR_COLOR_YELLOW = 'yellow';
    //New Constants are added - Parul Gupta on Nov 14, 2013 END
    
    //New Constants are added - Parul Gupta on Jan 8, 2014 BEGIN
    public static final String MARKET_ID = 'MRKT_ID__c';
    public static final String ROOT_UPLINE_ACCOUNT_NUMBER = 'ROOT_UPLN_ACCT_NR__c';
    public static final String LEFT_NODE_ID = 'LFT_ND_ID__c';
    public static final String RIGHT_NODE_ID = 'RGT_ND_ID__c';
    public static final String CAMPAIGN_NUMBER = 'FLD_SLS_CMPGN_NR__c';  
    public static final String ACCOUNT_NUMBER = 'ACCT_NR__c'; 
    public static final String LEVEL_TITLE_NUMBER = 'LDRSHP_TITL_LVL_NR_NUMBER__c';
    public static final String GENERATION = 'Relative_Gen_Index__c';  
    public static final String REMOVAL_CAMPAIGN = 'REP_REMOVL_CMPGN_NR__c';
    //New Constants are added - Parul Gupta on Jan 8, 2014 END
    
     //@T-214186 : Commented by Barkha Jain on Nov 21
   /* //New Constants are added - Gaziz on June 10, 2012 END 
    public static testmethod void testALMConstants()    
    {
    ALMConstants ctr;
    ctr=new ALMConstants();
    
    }*/
    
}