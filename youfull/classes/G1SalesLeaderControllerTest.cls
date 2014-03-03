/*
** Apex Class/Controller Name           : G1SalesLeadersControllerTest
** VF Pages associated [Names]          : 
** 
** Is Extension                         : No
** Is Test Class                        : Test
**
** Purpose [short summary]              : Test class for G1SalesLeaderController
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** April 6, 2012. Created
** 
*/
@isTest
public class G1SalesLeaderControllerTest {
	
	
	
	private static PageReference G1SalesLeadersPage;
	
    private static Map<String, Leader_Title__c> mapLeaderTitle = new Map<String, Leader_Title__c>();
    private static MarketLeaderTitleUtils leaderUtils = null;
    private static Leader_Title__c leaderTitle = null;
    private static Map<String, Custom_Message__c> mapCMessages = null;
    private static Decimal leadLevel;
    private static String leaderType;
    private static LandingPageUtils lpu;
    private static User u;
    private static Leader_Downline_Summary__c leaderDownline;
    private static My_Business__c personalPerformance;
    private static Market__c market;
    private static List<Custom_Message__c> listMessage;
    private static Contact testContact;
    
    private static String accountNumber;
    private static String leaderLevel;
    private static String marketId;
    private static String language;
    private static String email;

	public static testmethod void init() {
	    accountNumber = 'LandingPageTestAccount';
	    leaderLevel = '1';
	    marketId = 'LMT';
	    email = 'sometestg1email@emailtestg1.com';
	    language='en_US';
		
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Avon Leader' LIMIT 1];
        if (testProfile == null) {
        	System.debug('=========== NO PROFILE FOR TEST! ======');
        	return ;
        }
        
        testContact = new Contact();
        testContact.FirstName = 'G1TestFirstName';
        testContact.LastName = 'G1TestLastName';
        testContact.ACCT_NR__c = accountNumber;
        testContact.Email = email;
        testContact.MobilePhone = '510 000 00 00';
        testContact.HomePhone = '510 000 00 01';
        testContact.REP_WORK_PHONE_NR__c = '510 000 00 01';
        //testContact.Representative_Phone__c = phoneNumber;
        
        insert testContact;
        
        //test user
        u = new User(FirstName='LandingPageTest', LastName = 'TestLandingPage', Alias='ltest', Email='testlanding@testttt.com', ProfileId=testProfile.Id, Username='landingpagetest@landingtest.com');
        u.LanguageLocaleKey = language;        
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = language;
        u.LDRSHP_TITL_LVL_NBR__c = leaderLevel;
        u.ACCT_NR__c = accountNumber;
        u.MRKT_ID__c = marketId;
        u.MRKT_ID_ACCT_NR_KEY__c=marketId+accountNumber;
        u.GI3_Email__c=accountNumber+'@avonpoc.com';
        u.EmailencodingKey = 'ISO-8859-1';
        insert u;
        testContact.OwnerId=u.Id;
        update testContact;
        
        //test market
        market = new Market__c();
        market.Market_Id__c = marketId;
        market.Name = 'TestLandingPageMarket';
        market.CurrencyIsoCode = 'USD';
        market.CURRNT_CYCLE_CMPGN_CNT__c = 1;
        market.CMPGN_NR__c = '101';
        market.Market_Currency_Symbol__c = '$';
        market.Available_Languages__c = language;
        market.ASLF_Timezone_Offset__c = 0;
        insert market;
        
        //test Leader_Title
        leaderTitle = new Leader_Title__c(); 
        leaderTitle.MIN_4_LVL_TITL_REQD_NR__c = 11;
        leaderTitle.MIN_5_LVL_TITL_REQD_NR__c = 45;
        leaderTitle.MIN_6_LVL_TITL_REQD_NR__c = 12;
        leaderTitle.MIN_7_LVL_TITL_REQD_NR__c = 13;
        leaderTitle.Market__c = market.Id;
        leaderTitle.MRKT_ID__c = marketId;
        leaderTitle.MIN_EST_ERNGs_AMT__c = 10000;
        leaderTitle.EXEC_IND__c = '';
        leaderTitle.LDRSHP_TITL_LVL_NR__c = '1';
        leaderTitle.LANG_CD__c = language;
        leaderTitle.LCL_LDRSHP_TITL_CD__c = 'UL';
        leaderTitle.MIN_PRSNL_SLS_REQD_AMT__c = 1000;
        leaderTitle.MIN_GRP_SLS_REQD_AMT__c = 4000;
        leaderTitle.MIN_REP_RCRTMNTS_REQD_NR__c = 10;
        leaderTitle.MIN_FRST_LVL_TITL_REQD_NR__c = 3;
        leaderTitle.MIN_SCN_LVL_TITL_REQD_NR__c = 1;
        leaderTitle.MIN_THRD_LVL_TITL_REQD_NR__c = 0;
        insert leaderTitle;
        
        //test Leader_Downline
        leaderDownline = new Leader_Downline_Summary__c();
        leaderDownline.Leadership_Summary_Key__c = marketId + accountNumber;
        leaderDownline.MRKT_ID__c = marketId; 
        leaderDownline.GRP_INVC_AWRD_SLS_AMT__c = 2000; 
        leaderDownline.GRP_INVC_RTURN_AWRD_SLS_AMT__c = 400;
        leaderDownline.GRP_SUBMTD_AWRD_SLS_AMT__c = 2000; 
        leaderDownline.GRP_SUBMTD_RTURN_AWRD_SLS_AMT__c = 300; 
        leaderDownline.TTL_LEG_CNT__c = 6;
        leaderDownline.GRP_FAP_CNT__c = 101;
        leaderDownline.GENTRTN_1_ACTV_REP_CNT__c = 11;
        leaderDownline.YTD_GRP_BLCKD_UNIT_SLS_AMT__c = 500;
        leaderDownline.MRKT_ACCT_KEY__c=testContact.Id;
        insert leaderDownline;
        
            List<String> fields = new String[] {'Contact__r.Name', 'Contact__r.Email', 'Contact__r.Representative_Phone__c', 'PRSNL_SLS_AMT__c', 
                                                    'TEAM_UNIT SALES_c', 'GENTRTN_1_ACTV_REP_CNT__c',
                                                    'GENRTN_1_GRP_APPT_CNT__c', 'GENRTN_2_GRP_APPT_CNT__c',
                                                    'GENRTN_3_GRP_APPT_CNT__c', 'GENRTN_1_LDR_CNT_TXT__c',
                                                    'RSNG_STR_IND__c', 'LDRSHP_TAR_IND__c', 
                                                    'LDRSHP_TITL_LVL_NR__c', 'ZONE_MGR_NAME__c',
                                                     'SLS_ZONE_CD__c', 'BRNCH_SCTN_DC__c'
                                                    };
        
        //my business
        personalPerformance = new My_Business__c();
        personalPerformance.Personal_Performance_Key__c = marketId + accountNumber;
        personalPerformance.MRKT_ID__c = marketId;
        personalPerformance.ACCT_NR__c = accountNumber;
        personalPerformance.INVC_AWRD_SLS_AMT__c = 600;
        personalPerformance.INVC_RTURN_AWRD_SLS_AMT__c = 200;
        personalPerformance.SUBMTD_AWRD_SLS_AMT__c = 650;
        personalPerformance.SUBMTD_RTURN_AWRD_SLS_AMT__c = 300;
        personalPerformance.LDRSHP_TITL_LVL_NR__c = '1';
        personalPerformance.LCL_TOP_SLR_LVL_KEY__c = 'somekey';
        personalPerformance.FAP_AWD_SLS_AMT__c = 18;
        personalPerformance.FAP_CNT__c = 22;
        personalPerformance.CTD_AWRD_SLS_AMT__c = 1400;
        personalPerformance.RSNG_STR_IND__c = 'Y';
        //personalPerformance.LDRSHP_TAR_IND__c = ;  // should be null for rising star
        personalPerformance.ZONE_MGR_NAME__c = 'Johny Doe';
        //personalPerformance.SLS_ZONE_CD__c;
        //personalPerformance.BRNCH_SCTN_DC__c'
       
	}
	
	
}