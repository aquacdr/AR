/***************************************************************************
 Name         : Test_MyLandingPageUtils
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for MyLandingPageUtils
 Created Date : Oct. 31, 2013                
****************************************************************************/

@isTest
private class Test_LandingPageUtils {

	//----------------------------------------------------------------------------
    // Method Name  : testLandingPageUtils
    // Description  : Method for Test Coverage of Class : LandingPageUtils
    //----------------------------------------------------------------------------  
    public static testmethod void testLandingPageUtils() {
    	String mktIdKey = '55';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.Market_Currency_Symbol__c = 'US';
        insert marketOne;
        
        //Create User
        User testUsr = TestDataHelper.createUser('12345', 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID__c = mktIdKey;
        insert testUsr;
        
        //Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
        
        //Create Object: Contact
        Map <String, Contact> conMap = new Map <String, Contact>();
	    Contact con = TestDataHelper.createContact(mktIdKey, acct.Id, true);
	    conMap.put(String.valueOf(mktIdKey) + String.valueOf(acct.Id), con);
	    
	    Test.startTest();
	    LandingPageUtils landingPage = new LandingPageUtils();
	    MarketLeaderTitleUtils marketUtil = landingPage.getLeaderTitleUtil();
	    IncentiveUtils incentUtil = landingPage.getIncentivesUtil();
	    
	    //Calling Method: getMarketAccountKey
	    LandingPageUtils.getMarketAccountKey(String.valueOf(marketOne.Id), String.valueOf(acct.Id));
	    LandingPageUtils.getMarketAccountKey(null, null); 
	    
	    //Calling Method: getLeadershipSummaryKey
	    LandingPageUtils.getLeadershipSummaryKey(String.valueOf(marketOne.Id), '12345', String.valueOf(acct.Id));
	    
	    //Calling Method: getPersonalPerformanceKey
	    LandingPageUtils.getPersonalPerformanceKey(String.valueOf(marketOne.Id), '12345', String.valueOf(acct.Id));
	    
	    //Create Object: List of Custom_Message__c
	    List <Custom_Message__c> customMsgList = TestDataHelper.createCustomMessagesList(marketOne, String.valueOf(testUsr.Id), true);
	    
	    //Inititalize variables and constants
	    List <String> customFields = new List <String> {'SL_Title__c', 'Message_Text__c', 'User_Type__c', 'Message_URL__c', 'Message_Name__c', 'Component_Name_Picklist__c'};
	    String customComponent = 'Title Achievements';
	    List <String> userTypes = new List <String> {'Avon Leader', 'Avon Mkt 62 Zone Manager'};
	    List <String> titleTypes = new List <String> {'1;2;3;4;5', '1;2;3;4'};
	    String msgName = 'pv_needed_neg';
	    String[] textAndUrl = new String[] {'1', '2'};
	    decimal input = 1.00;
	    
	    //Calling Method: generateQueryCMessages
	    LandingPageUtils.generateQueryCMessages(customFields, userTypes, titleTypes, String.valueOf(marketOne.Id), customComponent);
	    
	    //Calling Method: generateQueryLPComponent
	    LandingPageUtils.generateQueryLPComponent(customFields, userTypes, titleTypes, String.valueOf(marketOne.Id));
	    
	    //Calling Method: initializeMessageMap
	    Map <String, Custom_Message__c> customMsgMap = LandingPageUtils.initializeMessageMap(customMsgList);
	    System.debug('*** customMsgMap : ' + customMsgMap);
	    
	    //Create Object: ALM_Rep_Performance_1__c
	    ALM_Rep_Performance_1__c almRepPerform = TestDataHelper.createRepPerformance(String.valueOf(con.Id), marketOne, mktIdKey, false);
	    almRepPerform.ACCT_NR__c = acct.Id;
	    almRepPerform.FLD_SLS_CMPGN_NR__c = 1.0;
	    insert almRepPerform;
	    
	    //Calling Method: populateCustomMessageAndUrl
	    LandingPageUtils.populateCustomMessageAndUrl(customMsgMap, '1', msgName, textAndUrl);
	    LandingPageUtils.populateCustomMessageAndUrl(customMsgMap, '1', msgName, 0, textAndUrl);
	    LandingPageUtils.populateCustomMessageAndUrl(customMsgMap, '1', msgName, marketOne.Market_Currency_Symbol__c, 0, textAndUrl);
	    
	    //Calling Method: returnDecToIntAbs
	    LandingPageUtils.returnDecToIntAbs(input);
	    LandingPageUtils.returnDecToIntAbs(null);
	    
	    //Calling Method: returnDecToInt
	    LandingPageUtils.returnDecToInt(input);
	    LandingPageUtils.returnDecToInt(null);
	    
	    //Calling Method: returnDecToString
	    LandingPageUtils.returnDecToString(input);
	    LandingPageUtils.returnDecToString(null);
	    
	    //Calling Method: returnDateToString
	    LandingPageUtils.returnDateToString(System.today());
	    LandingPageUtils.returnDateToString(null);
	    LandingPageUtils.returnDateToString(System.today(), 'en_us');
		LandingPageUtils.returnDateToString(System.today(), 'en_uk');
		LandingPageUtils.returnDateToString(null, 'en_uk');
	    
	    //Calling Method: returnDecToString
	    LandingPageUtils.returnDecToString(input, 'US');
	    LandingPageUtils.returnDecToString(input, null);
	    LandingPageUtils.returnDecToString(null, 'US');
	    LandingPageUtils.returnDecToString(-1.00, 'US');
	    
	    //Calling Method: setBattery
	    BatteryChartParams batteryChart = new BatteryChartParams();
	    LandingPageUtils.setBattery(batteryChart, 1, 2, 3);
	    LandingPageUtils.setBattery(batteryChart, 1, 2, 2);
	    LandingPageUtils.setBattery(null, 1, 2, 3);
	    
	    //Create Object: List of Leader_Title__c
	    List <Leader_Title__c> leaderTitlesList = TestDataHelper.createLeaderTitlesList(String.valueOf(marketOne.Id), marketOne.Market_Id__c, false);
	    leaderTitlesList[0].EXEC_IND__c = 'Y';
	    leaderTitlesList[1].EXEC_IND__c = '';
	    insert leaderTitlesList;
	    
	    Map <String, Leader_Title__c> leaderTitlesMap = new Map <String, Leader_Title__c>();
	    for (Leader_Title__c leaderTitle : leaderTitlesList) {
	    	leaderTitlesMap.put(leaderTitle.LDRSHP_TITL_LVL_NR__c, leaderTitle);
	    }
	    
	    //Calling Method: determineLeaderType
	    LandingPageUtils.determineLeaderType(leaderTitlesList, null);
	    LandingPageUtils.determineLeaderType(leaderTitlesList, 'Test');
	    
	    //Calling Method: returnOnlyLeaders
	    List <Leader_Title__c> obtaineLeaderTitlesList = LandingPageUtils.returnOnlyLeaders(leaderTitlesList);
	    
	    //Calling Method: returnOnlyLeadersNumbers
	    List <String> obtaineLeaderNumberList = LandingPageUtils.returnOnlyLeadersNumbers(leaderTitlesList);
	    
	    //Calling Method: debugList
	    LandingPageUtils.debugList(leaderTitlesList, 'Leader_Title__c');
	    
	    //Calling Method: debugMap
	    Map <Integer, Custom_Message__c> testCustomMsgMap = new Map <Integer, Custom_Message__c>();
	    LandingPageUtils.debugMap(customMsgMap, 'Custom_Message__c');
	    LandingPageUtils.debugMap(testCustomMsgMap, 'Custom_Message__c');
	    
	    //Calling Method: getSponsor
	    LandingPageUtils.getSponsor(conMap, String.valueOf(marketOne.Id), String.valueOf(acct.Id));
	    
	    //Calling Method: isNumber
	    LandingPageUtils.isNumber('1');
	    
	    //Calling Method: determineBadgeTitle
	    LandingPageUtils.determineBadgeTitle(leaderTitlesMap, '1');
	    
	    //Calling Method: makeUrl
	    Map <String, String> paramMap = new Map <String, String>();
	    paramMap.put('1', '1');
	    LandingPageUtils.makeUrl('www.test.com', paramMap);
	    
	    //Calling Method: makeUrl
	    LandingPageUtils.makeUrlParams(paramMap, '&');
	    
	    //Calling Method: makeCoachOrImperson
	    LandingPageUtils.makeCoachOrImperson('N', '1234', 'www.test.com', paramMap);
	    LandingPageUtils.makeCoachOrImperson('Y', '1234', 'www.test.com', paramMap);
	    
	    LPDownlineWrapper lpWrapper = new LPDownlineWrapper();
	    LandingPageUtils.makeCoachOrImperson('N', '1234', 'www.test.com', paramMap, lpWrapper);
	    
	    //Calling Method: removeUrlParamsAll
	    LandingPageUtils.removeUrlParamsAll('www.test.com');
	    
	    //Calling Method: excludeUrlParams
	    String [] excludeParam = new String[] {'&', '$'};
	    LandingPageUtils.excludeUrlParams(excludeParam, 'www.test.com');
	    
	    //Calling Method: isImpersonationValid
	    LandingPageUtils.isImpersonationValid('Avon Leader', mktIdKey, 'West', '1', String.valueOf(acct.Id), '1', String.valueOf(marketOne.Id));
	    LandingPageUtils.isImpersonationValid('Zone Manager', mktIdKey, 'West', '1', String.valueOf(acct.Id), '1', String.valueOf(acct.Id));
	    LandingPageUtils.isImpersonationValid('Division Manager', mktIdKey, 'West', '1', mktIdKey, '1', mktIdKey);
	    
	    //Calling Method: isEmailAllowedForProfile
	    boolean isValidFlag = LandingPageUtils.isEmailAllowedForProfile('Avon Leader', 'Avon Leader;Avon Mkt 62 Zone Manager');
	    System.assertEquals(isValidFlag, true);
	    boolean isValidFlagOne = LandingPageUtils.isEmailAllowedForProfile(null, 'Avon Leader;Avon Mkt 62 Zone Manager');
	    
	    //Calling Method: isValidMapString
	    LandingPageUtils.isValidMapStringParams(null);
	    
	    //Calling Method: isPreviousCampaign
	    LandingPageUtils.isPreviousCampaign('prior');
	    LandingPageUtils.isPreviousCampaign('current');
	    
	    //Calling Method: isNextCampaign
	    LandingPageUtils.isNextCampaign('prior');
	    LandingPageUtils.isNextCampaign('current');
	    
	    //Re-Initialize variable: textAndUrl
	    textAndUrl = new String[] {'1', '2', '3'};
	    
	    //Calling Method: populateCustomMessageAndUrl
	    LandingPageUtils.populateCustomMessageAndUrl(customMsgMap, titleTypes[0], msgName, textAndUrl);
	    LandingPageUtils.populateCustomMessageAndUrl(customMsgMap, titleTypes[0], msgName, 0, textAndUrl);
	    LandingPageUtils.populateCustomMessageAndUrl(customMsgMap, titleTypes[0], msgName, marketOne.Market_Currency_Symbol__c, 0, textAndUrl);
	    
	    Test.stopTest();
    }
}