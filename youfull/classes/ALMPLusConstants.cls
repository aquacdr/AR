/**
  Holds constants which are reusable across various classes.
  
  Activity History:  
  Shah Kadirmohideen - 9/18 - Added constants for Notification Manager.
  Shah Kadirmohideen - 10/10 - Code Reviewed and no issues found.
  Fay Salwen - 5/16/2013 - Added values for AVON_ZM_BASE, AVON_DM_BASE, and AVON_TM_BASE, so that we can use in contains()
*/
public with sharing class ALMPLusConstants {
    
    public static String RUSSIA_MKT_ID = '67';  //SA: removed final - so that test code could alter the value
    public static final String MRKT_ID = 'mktcd';
    public static final String LANG_CD = 'langcd';
    public static final String PAGE_CD = 'pagecd';
    public static final String AVON_LEADER = 'Avon Leader';
    public static final String AVON_ZM = 'Avon Mkt 62 Zone Manager';
    public static final String AVON_DM = 'Avon Mkt 62 Division Manager';
    public static final String AVON_SL_BASE = 'Leader';
    public static final String AVON_ZM_BASE = 'Zone Manager';
    public static final String AVON_DM_BASE = 'Division Manager';
    public static final String AVON_TM_BASE = 'Training Manager';
    public static final String AVON_CS = 'Avon Customer Service';
    public static final String AVON_CS_AGNT = 'Avon Customer Service Agent';
    public static final String AVON_CS_SUPR = 'Avon Customer Service Supervisor';
    public static final String AVON_SYS_ADM = 'System Administrator';
    public static final String AVON_IT_ADM = 'Avon IT Administrator';
    
    public static final String LEAD_STS_NEW = 'New';
    public static final String LEAD_STS_INPRGRS = 'In Progress';
    public static final String LEAD_STS_CLOSED = 'Closed';
    public static final String LEAD_STS_REJ = 'Rejected';
    public static final String LEAD_SBTS_NEW = 'New Lead';
    public static final String LEAD_SBTS_APP = 'Appointed';
    public static final String LEAD_SBTS_RAR = 'Rep Account Received';
    public static final String LEAD_SBTS_CONV = 'Converted to Customer';
    public static final String LEAD_SBST_REDISTR = 'Redistributed';
    public static final String LEAD_SBST_ROLLED = 'Rolled Up';
    public static final String LEAD_SBST_REASGND = 'Lead Reassigned';
    public static final String LEAD_SBST_DELEGATED = 'Delegated';
    public static final String LEAD_SBST_WRNG_DATA = 'Wrong Data';
    public static final String LEAD_SBST_NOT_INTRST = 'Contacted - No Longer Interested';
    public static final String LEAD_SBST_EXISTS = 'Exists as Representative';
    public static final String LEAD_SBST_DUP = 'Duplicate Lead - Appointed by Another';
    public static final String LEAD_SBST_NO_RESP = 'Contacted - No Response/No Show';
    public static final String LEAD_SBST_UNDERAGE = 'Underage';
    public static final String LEAD_SBST_NOT_CONTACT = 'Not Contacted 14 Days';
    public static final String LEAD_SBST_CONTACTED = 'Contacted';
    public static final String LEAD_SBST_SCEDULED = 'Scheduled';
    public static final String LEAD_SBST_FOLLOWUP_PEND = 'Follow Up/Pending';
    
    public static final String LEAD_CUSTOMER = 'Customer';
    public static final String LEAD_REP = 'Rep';
    
    public static final String CDW_REMOVED = 'Removed';
    public static final String CDW_NOT_CONSENTED = 'Not Consented';
    
    public static final String COMMA = ',';
    public static final String COLON = ':';
    public static final String SEMICOLON = ';';
    public static final String SEPARATOR = '<,>';
    public static final String SEPARATOR1 = '<->';
    public static final String SEPARATOR2 = '<:>';
    public static final String CUST_SRV_QUEUE_NM_SUFFIX = 'Market Customer Care Queue';
    public static final String MKT_QUEUE_NM_SUFFIX = 'Market Queue';
    public static final String HYPHEN = '-';
    public static final String INVALID_MKT_ID = 'InvalidMarketId';
    public static final String USER_ACTIVE = 'Active';
    public static final String USER_LANGLOCKEY = 'LanguageLocaleKey';
    public static final String USER_LOCKSIDKEY = 'LocaleSidKey';
    public static final String USER_PROFILE = 'Profile';
    public static final String USER_FEDIDENTFIER = 'FederationIdentifier';
    public static final String USER_NAME = 'User Name';
    public static final String USER_POSTAL_CODE = 'Postal Code';
    public static final String USER_CDW_STS_CD = 'CDW STS CD';
    public static final String USER_DFALT_DIV_NM = 'DFALT DIV NM';
    public static final String USER_DFALT_ZONE_CD = 'DFALT ZONE CD';
    public static final String USER_GI3_EMAIL = 'GI3 Email';
    public static final String USER_CDW_INELG_CODES = 'CDW Ineligibility Codes';
    public static final String USER_SFDC_INELG_CODES = 'SFDC Ineligibility Codes';
    public static final String USER_SFDC_IS_ELEGIBLE = 'Is Eligible';
    public static final String USER_OPT_IN = 'Opt In';
    public static final String USER_OUT_OFF = 'Out of Office';
    public static final String USER_SYS_OVERRIDE = 'System Override';
    public static final String USER_ZM_OVERRIDE = 'ZM Override';
    public static final String USER_LEAD_OPT_IN_TERMS = 'Lead Opt in Terms';
    public static final String MARKET = 'Market';
    public static final String MARKET_Q = 'Market Queue';
    public static final String ISACT_API = 'IsActive';
    public static final String LANG_L_KEY_API = 'LanguageLocaleKey';
    public static final String LOC_SID_KEY_API = 'LocaleSidKey';
    public static final String PROFILE_API = 'Profile';
    public static final String FED_ID_API = 'FederationIdentifier';
    public static final String USRNAME_API = 'Username';
    public static final String CDW_STS_CD_API = 'CDW_STS_CD__c';
    public static final String DFALT_DIV_NM_API = 'DFALT_DIV_NM__c';
    public static final String DFALT_ZONE_CD_API = 'DFALT_ZONE_CD__c';
    public static final String OPT_IN_API = 'Opt_In__c';
    public static final String GI3_EMAIL_API = 'GI3_Email__c';
    public static final String CDW_INELEG_CODES_API = 'CDW_Ineligibility_Codes__c';
    public static final String SFDC_INELEG_CODES_API = 'SFDC_Ineligibility_Codes__c';
    public static final String OUT_OFF_API = 'Out_of_Office__c';
    public static final String IS_ELEG_API = 'Is_Eligible__c';
    public static final String SYS_OVER_API = 'System_Override__c';
    public static final String ZM_OVER_API = 'ZM_Override__c';
    public static final String MKTID_ACC_KEY_API = 'MRKT_ID_ACCT_NR_KEY__c';
    public static final String LEAD_OPT_IN_TERM_API = 'Lead_Opt_in_Terms__c';
    public static final String MKTID_ACC_KEY = 'MRKT ID ACCT NR KEY';
    public static final String DUPLICATE_LEAD = 'Duplicate lead found';
    //Pre-agreed ineligibility codes for flags stored in SFDC
    public static final String OOO_CODE = 'OOO';    //OUT OF OFFICE
    public static final String ZMO_CODE = 'ZMO';    //ZM OVERRIDE
    public static final String SO_CODE = 'SO';      //SYSTEM OVERRIDE
    public static final String OPT_IN_CODE = 'OI';  //OPT IN 
    public static final String SFDC_ACTIVE = 'SFA'; //SFDC ACTIVE
    //lead age
    public static final Integer DFLT_MIN_LEAD_AGE = 16;
    public static final Integer DFLT_MAX_LEAD_AGE = 100;
    
    public static final String TEST_COMPANY = 'Apex-UnitTest-Company';
    //Lead log page
    public static final String LSTAT_NEW = 'New';
    public static final String LSTAT_INPROG = 'In Progress';
    public static final String LSTAT_CLOSE = 'Closed';
    public static final String LSTAT_REJECTED = 'Rejected';
    public static final String LTYPE_AGL = 'AGL';
    public static final String LTYPE_FGL = 'FGL';
    public static final String LCONTR_SIGND = 'Contract Signed';
    //new lead page
    public static final String CALL_CENTER = 'Call Center';
    public static final String FIELD_GEN = 'Field Generated';
    
    public static final Integer RECORD_LIMIT =8000;
    public static final Integer LEAD_MAX_RECORDS_PER_PAGE =10;
    
    
    public static Boolean LEAD_UPDATE_FLAG = false;
    public static String ALM_GLOBAL_SETTINGS_RECORD_KEY = 'ALM Default';
    
    //Notification Manager related constants
    public static Integer NOTIFICATION_ERROR_REATTEMPTS_MAX = 5;
    public static String NOTIFICATION_QUEUE_RECTYPE_SMS = 'SMS';
    public static String NOTIFICATION_QUEUE_RECTYPE_EMAIL = 'Email';

    //added for Hot Lead link
    public static String HOTLEAD_PGID_VALUE = '40';
    
      //email template names. todo: have naming convention that doesn't require constants or add the values to custom settings
    public static final String SMS_LEAD_DISTR = 'SMS: Distribution Notify Lead';
    public static final String SMS_ZM_ESC = 'SMS: Escalation Notify ZM';
    public static final String SMS_DM_ESC = 'SMS: Escalation Notify DM';
    public static final String SMS_OWNER3_DISTR = 'SMS: Distribution Notify 3rd Lead Owner';
    public static final String SMS_OWNER2_DISTR = 'SMS: Distribution Notify 2nd Lead Owner';
    public static final String SMS_OWNER1_DISTR = 'SMS: Distribution Notify 1st Lead Owner';
    public static final String SMS_ZM_DISTR = 'SMS: Distribution No Zip Code Notify ZM Lead Owner';
    public static final String SMS_DELEGATE = 'SMS: Delegation Notify SL or ZM';
    
    public static final String EMAIL_LEAD_DISTR = 'Email: Distribution Notify Lead';
    public static final String EMAIL_ZM_ESC = 'Email: Escalation Notify ZM';
    public static final String EMAIL_DM_ESC = 'Email: Escalation Notify DM';
    public static final String EMAIL_OWNER3_DISTR = 'Email: Distribution Notify 3rd Lead Owner';
    public static final String EMAIL_OWNER2_DISTR = 'Email: Distribution Notify 2nd Lead Owner';
    public static final String EMAIL_OWNER1_DISTR = 'Email: Distribution Notify 1st Lead Owner';
    public static final String EMAIL_ZM_DISTR = 'Email: Distribution No Zip Code Notify ZM Lead Owner';
    public static final String EMAIL_DELEGATE = 'Email: Delegation Notify SL or ZM';
    
    public static final String AVON_LEADER_PROFILE_ALIAS = 'SL';
    public static final String AVON_ZONE_MANAGER_PROFILE_ALIAS = 'ZM';
    public static final String AVON_DIVISION_MANAGER_PROFILE_ALIAS = 'DM';
    public static final String AVON_CUSTOMER_SERVICE_PROFILE_ALIAS = 'CS';
    
  public static final String SMS_FROM_ALIAS = 'Avon'; //todo: move this to alm global settings
  public static final String REP_CONV_RATE = 'Rep Conversion Rate'; 
  public static final String CUST_CONV_RATE = 'Customer Conversion Rate'; 
  public static final String OVERALL_CONV_RATE = 'Overall Conversion Rate';
  public static final String AVG_TIME_TO_CONV = 'Avg Time to Conversion';
  public static final String CUST_AVG_TIME_TO_CONV = 'Customer Avg Time to Conversion';
  public static final String REP_AVG_TIME_TO_CONV = 'Rep Avg Time to Conversion';
  public static final String AVG_TIME_TO_CONT = 'Avg Time to Contact';
  public static final String CUST_AVG_TIME_TO_CONT = 'Customer Avg Time to Contact';
  public static final String REP_AVG_TIME_TO_CONT = 'Rep Avg Time to Contact';
  public static final String CONVERSION_METRICS_DEFAULT_CAMPAIGN = 'Current';
  public static final Integer SOQL_STMT_LIMIT = 10000;    //SOQL statement character limit  
  
    public static Map<String, String> profileAliasMap;
    public static Map<String, Schema.SObjectType> sobjectTypeMap;  //key->object prefix
   
   public static final String UNIT_LEADER_TITLE_NO = '1';
   public static final String ADV_UNIT_LEADER_TITLE_NO = '2';
   public static final String EUL_TITLE_NO ='3';
   public static set<String> EUL_ABOVE_TITLE_NO = new set<String>{'3','4'};   
    static {
        sobjectTypeMap = new Map<String, Schema.SObjectType>();
        sobjectTypeMap.put('00Q', Lead.getSObjectType());
        
        profileAliasMap = new Map<String, String>();
        profileAliasMap.put(AVON_LEADER, AVON_LEADER_PROFILE_ALIAS);
        profileAliasMap.put(AVON_ZM, AVON_ZONE_MANAGER_PROFILE_ALIAS);
        profileAliasMap.put(AVON_DM, AVON_DIVISION_MANAGER_PROFILE_ALIAS);
        profileAliasMap.put(AVON_CS_AGNT,AVON_CUSTOMER_SERVICE_PROFILE_ALIAS );
        profileAliasMap.put(AVON_CS_SUPR, AVON_CUSTOMER_SERVICE_PROFILE_ALIAS);
    }   
}