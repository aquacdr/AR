/*
** Apex Class/Controller Name           : LandingPageUtils
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Utility methods for TitleAchievementsController, IncentivesController, G1LeaderController, RisingStarsController classes
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** March 23, 2012.  Created
** 
*/

public class LandingPageUtils {
    
    //colors on reports
    public static String CHART_COLOR_GOOD = 'green';
    public static String CHART_COLOR_BAD = 'red';

    public IncentiveUtils iu;
    public MarketLeaderTitleUtils mltu;
    
    public MarketLeaderTitleUtils getLeaderTitleUtil() {
        mltu = new MarketLeaderTitleUtils();
        
        return mltu;
    }
    
    public IncentiveUtils getIncentivesUtil() {
        iu = new IncentiveUtils();
        return iu;
    }
    
    // returns a key used in soql queries for avon leader
    /*public static String getLeaderKey(String MarketId, String CampaignId, String AccountId) {
        return MarketId + CampaignId + AccountId;
    }*/
    
    // return "MarketAccount" key. Usually that's a concat of Market_Id and Account_Id
    public static String getMarketAccountKey(String marketId, String accountId) {
        if (marketId != null && accountId != null) {
            return marketId + accountId;
        }
        
        return null;
    }
    
    // returns a Leadership Summary key used in soql queries for avon leader
    public static String getLeadershipSummaryKey(String MarketId, String campaignId, String AccountId) {
        return MarketId + campaignId + AccountId; 
    }
    
    // returns a Personal Performance Summary key used in soql queries for avon leader
    public static String getPersonalPerformanceKey(String MarketId, String campaignId, String AccountId) {
        return MarketId + CampaignId + AccountId; 
    }
    
    //validates array of Strings
    //input length must be = to mustLength
    //input array and all input members should be non-null
    public static boolean isStringArrayValid(Integer mustLentgh, String [] input) {
        if (input == null || input.size() != mustLentgh) {
            return false;
        }
        
        /*if (input != null) {
            for(String str : input) {
                if (str == null) {
                    return false;
                }
            }
        } else {
            return false;
        }*/
        
        return true;
    }
    
    // helper to generate regular select without "WHERE" clause
    private static String generateSelect(String source, List<String> fields) {
        String query = null;
        Integer i = 0;
        
        if (fields != null && fields.size() > 0) {
            query = 'SELECT ';
            i = fields.size();
            while (i > 1) {
                query = query + fields.get(--i) + ', ';
            } 
            query = query + fields.get(0) + ' FROM ' + source;
        }
        
        return query;
    }
    
    //dynamically generate query to Custom_Message__c
    public static String generateQueryCMessages(List<String> fields, List<String> userTypes, List<String> titleTypes,String marketId,  String componentName) {
        String query = null;
        Integer i = 0;
        Integer j = 0;
        String whereClause = '';
        String andClause = '';
        List<String> listString = null; 
        if ((query = generateSelect('Custom_Message__c', fields)) != null) {
            
            //titleTypes and userTypes are multi-select picklist values
            if ((titleTypes != null && titleTypes.size() > 0) && (userTypes != null && userTypes.size() > 0)) {
                j = titleTypes.size();              
                i = userTypes.size();
                whereClause = ' WHERE Component_Name_Picklist__c = \'' + componentName +  '\'' + ' AND Market__c = \''  + marketId + '\'' +
                ' AND (User_Type__c includes (\'All\')'+
                ' OR User_Type__c includes (';
                andClause = ' AND (SL_Title__c includes (\'All\') OR SL_Title__c includes (';
                while (i > 1) {
                    whereClause = whereClause + ' \'' + userTypes.get(--i) + '\', ';
                }
                while (j > 1) {
                    andClause = andClause + ' \'' + titleTypes.get(--j) + '\', ';
                }
                whereClause = whereClause + ' \'' + userTypes.get(0) + '\') )';
                andClause = andClause + ' \'' + titleTypes.get(0) + '\') )';
                query = query + ' ' + whereClause + andClause;
            }
        } 
        System.debug('\n ###### generateQueryCMessages LandingPageUtils query  ##### \n'+query);
        return query;
    }
    
    //dynamically generate query to Landing_Page_Component__c
    public static String generateQueryLPComponent(List<String> fields, List<String> userTypes, List<String> titleTypes, String marketId) {
        String query = null;
        Integer i = 0;
        Integer j = 0;
        String whereClause = '';
        String andClause = '';
        List<String> listString = null; 
        if ((query = generateSelect('Landing_Page_Component__c', fields)) != null) {
             //System.debug('\n ======= generateQueryLPComponent ========== ');
            //titleTypes and userTypes are multi-select picklist values
            if ((titleTypes != null && titleTypes.size() > 0) && (userTypes != null && userTypes.size() > 0)) {
                j = titleTypes.size();              
                i = userTypes.size();
                whereClause = ' WHERE Landing_Page_Config__r.Market__c = \''  + marketId + '\''  +
                ' AND (Landing_Page_Config__r.User_Type__c includes (\'All\')' +
                ' OR Landing_Page_Config__r.User_Type__c includes (';
                andClause = ' AND (Landing_Page_Config__r.Title_Level_Number__c includes(\'All\') ' +
                ' OR Landing_Page_Config__r.Title_Level_Number__c includes (';
                while (i > 1) {
                    whereClause = whereClause + ' \'' + userTypes.get(--i) + '\', ';
                }
                while (j > 1) {
                    andClause = andClause + ' \'' + titleTypes.get(--j) + '\', ';
                }
                whereClause = whereClause + ' \'' + userTypes.get(0) + '\') )';
                andClause = andClause + ' \'' + titleTypes.get(0) + '\') )';
                andClause = andClause + ' ORDER BY Display_Row__c, Horizontal_Position__c';
                query = query + ' ' + whereClause + andClause;
            }
        } 
        System.debug('\n ======= generateQueryLPComponent . query ========== \n'+query);
        return query;
    }
    
    //creates and populates custom messages map <Message_Name, Message>
    public static Map<String, Custom_Message__c> initializeMessageMap(List<Custom_Message__c> pool) {
        Map<String, Custom_Message__c> result = new Map<String, Custom_Message__c>();
        
        try {
            for (Custom_Message__c message : pool) {
                String[] opts = message.SL_Title__c.split(';');
                for (String value : opts) {
                    result.put(value.trim() + '__' + message.Message_Name__c.trim().toLowerCase(), message);
                }
            }
        } catch(NullPointerException e) {
            System.debug('Null Pointer Exception. Data missing in Custome_Message__c fields: Section__c, Scenario_Acronyms__c, SL_Title__c');
        }
        
        return result;
    }
    
    
    //takes String array with custom with message text and custom message url 
    //populates the text and the url
    //Custom_Message map pool required, title number, message name, scenario display number required
    public static void populateCustomMessageAndUrl(Map<String, Custom_Message__c> mapPool,
                                                          String titleType, String name, Integer scenarioNumber, String [] textAndUrl) {
        /*                                                      
        System.debug('======================AAAA LandingPageUtils. populateCustomMessageAndUrl. input valid ? = ' + isStringArrayValid(2, textAndUrl));
        System.debug('======================AAAA LandingPageUtils. populateCustomMessageAndUrl mapPool \n' +mapPool);
        System.debug('======================AAAA LandingPageUtils. populateCustomMessageAndUrl titleType \n' +titleType);
        System.debug('======================AAAA LandingPageUtils. populateCustomMessageAndUrl name \n' +name);
        System.debug('======================AAAA LandingPageUtils. populateCustomMessageAndUrl scenarioNumber \n' +scenarioNumber);
        System.debug('======================AAAA LandingPageUtils. populateCustomMessageAndUrl textAndUrl \n' +textAndUrl);*/
        if (isStringArrayValid(2, textAndUrl) ) {
            textAndUrl[0] = getCustomMessage(mapPool, titleType, name, scenarioNumber);
            textAndUrl[1]= getCustomUrl(mapPool, titleType, name);
        } else {
            textAndUrl[0] = null;
            textAndUrl[1]= null;
        }
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. RESULT text = ' + textAndUrl[0]);
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. RESULT url = ' + textAndUrl[1]);
    }
    
    //takes String array with custom message text and custom message url as input
    //populates the text and the url
    //Custom_Message map pool required, title number, message name, currency character scenario display number required
    public static void populateCustomMessageAndUrl(Map<String, Custom_Message__c> mapPool, String titleType, 
                                                          String name, String currencyCharacter, Integer scenarioNumber, String [] textAndUrl) {
       /*                                                       
        System.debug('======================BBBB LandingPageUtils. populateCustomMessageAndUrl. input valid ? = ' + isStringArrayValid(2, textAndUrl));
        System.debug('======================BBBB LandingPageUtils. populateCustomMessageAndUrl mapPool \n' +mapPool);
        System.debug('======================BBBB LandingPageUtils. populateCustomMessageAndUrl titleType \n' +titleType);
        System.debug('======================BBBB LandingPageUtils. populateCustomMessageAndUrl name \n' +name);
        System.debug('======================BBBB LandingPageUtils. populateCustomMessageAndUrl scenarioNumber \n' +scenarioNumber);
        System.debug('======================BBBB LandingPageUtils. populateCustomMessageAndUrl textAndUrl \n' +textAndUrl);*/
        if (isStringArrayValid(2, textAndUrl) ) {
            textAndUrl[0] = getCustomMessage(mapPool, titleType, name, currencyCharacter, scenarioNumber);
            textAndUrl[1] = getCustomUrl(mapPool, titleType, name);
        } else {
            textAndUrl[0] = null;
            textAndUrl[1]= null;
        }
    }
    
    //takes String array with custom message text and custom message url as input
    //populates the text and the url
    //Custom_Message map pool required, title number, message name required
    public static void populateCustomMessageAndUrl(Map<String, Custom_Message__c> mapPool,
                                                          String titleType, String name, String [] textAndUrl) {
                                                              
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. input valid ? = ' + isStringArrayValid(2, textAndUrl));
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. titleType = ' + titleType);
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. name= ' + name);
        if (isStringArrayValid(2, textAndUrl) ) {
            textAndUrl[0] = getCustomMessage(mapPool, titleType, name);
            textAndUrl[1] = getCustomUrl(mapPool, titleType, name);
        } else {
            textAndUrl[0] = null;
            textAndUrl[1]= null;
        }
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. RESULT text = ' + textAndUrl[0]);
        System.debug('====================== LandingPageUtils. populateCustomMessageAndUrl. RESULT url = ' + textAndUrl[1]);
    }
    
    //get message with number concatenated from Custom_Message__c map using params. 
    public static String getCustomMessage(Map<String, Custom_Message__c> mapPool,
                                                          String titleType, String name, Integer scenarioNumber) {
        
        String result = null;
        Custom_Message__c message = null;
        if (mapPool != null && (message = mapPool.get(titleType.trim() + '__' + name.trim().toLowerCase())) != null && 
                                                               scenarioNumber != null && titleType != null && name != null) {
                                                              
            result = (message.Message_Text__c != null ? String.valueOf(scenarioNumber) + ' ' + message.Message_Text__c : null);
            //result = (message.Message_Text__c != null ? String.valueOf(scenarioNumber): null);
            
        } else {
            return null;
        }
                                       
        System.debug('====================== LandingPageUtils. getCustomMessage with number result: ' + result);                                      
        return result;
    }
    
    //get message with money amount concatenated from Custom_Message__c map using params. 
    //returns null if message doesn't exist
    public static String getCustomMessage(Map<String, Custom_Message__c> mapPool,
                                                          String titleType, String name, String currencyCharacter, Integer scenarioNumber) {
        
        String result = null;
        Custom_Message__c message = null;
        if (mapPool != null && (message = mapPool.get(titleType.trim() + '__' + name.trim().toLowerCase())) != null && 
                                                               scenarioNumber != null && titleType != null && name != null) {
           //Rupayan - changed String.valueOf(scenarioNumber) to scenarioNumber.format()                                                      
           //result = (message.Message_Text__c != null ? currencyCharacter + scenarioNumber.format() + ' ' + message.Message_Text__c : null);
           result = (message.Message_Text__c != null ? currencyCharacter + scenarioNumber.format()  : null);
        } else {
            return null;
        }
                                       
        return result;
    }
    
    //get text message without any number concatenated from Custom_Message__c map using params
    //returns null if text message doesn't exist
    public static String getCustomMessage(Map<String, Custom_Message__c> mapPool,
                                                          String titleType, String name) {
        
        String result = null;
        Custom_Message__c message = null;
        if (mapPool != null && (message = mapPool.get(titleType.trim() + '__' + name.trim().toLowerCase())) != null && 
                                                                                        titleType != null && name != null) {
                                                                
            //result = (message.Message_Text__c != null ? message.Message_Text__c : null);
            result = (message.Message_Text__c != null ? ' ' : null);
        } else {
            return null;
        }
        System.debug('\n ####### result ####### '+result);                              
        return result;
    }
    
    // url from custom message
    // returns null if url doesn't exist
    public static String getCustomUrl(Map<String, Custom_Message__c> mapPool, String titleType, String name) {
        
        String result = null;
        Custom_Message__c message = null;
        
        if (mapPool != null && (message = mapPool.get(titleType.trim() + '__' + name.trim().toLowerCase())) != null && 
                                                                                       titleType != null && name != null) {
       
            result = (message.Message_URL__c!= null ? message.Message_URL__c : null);
        }
        
        return result;
    }
    
    
    //return absolute Integer value of Decimal removing fractional part
    //if input is null, return null
    public static Integer returnDecToIntAbs(Decimal input) {
        if (input == null ) {
            return null;
        }
        
        return input.abs().intValue();
    }
    
    //return Integer value of Decimal removing fractional part
    //if input is null, return null
    public static Integer returnDecToInt(Decimal input) {
        if (input == null ) {
            return null;
        }
        
        return input.intValue();
    }
    
    //return String value of Decimal removing fractional part and keeping the negative (or positive) sign
    //if input is null, return null
    public static String returnDecToString(Decimal input) {
        String temp;
        if (input == null ) {
            return null;
        }else{
        	temp = String.valueOf(input);
        	if(temp.indexOf('.') > -1){
        		Integer pos = temp.indexOf('.');
        		Integer len = temp.length();
        		
        		if((len - 1) - pos >=  3){
					temp = temp.substring(0, len -1);
				}
        	}
        }
        
        //return String.valueOf(input.round(System.RoundingMode.DOWN));
        //return String.valueOf(input);
        
        return temp;
    }
    
    //return String value of Date  
    //if input is null, return null
    public static String returnDateToString(Date input) {
        if (input == null ) {
            return null;
        }
        
        return String.valueOf(input);
    }
    
    //return String value of Date with some logic to user's locale. dd/mm/yyyy or mm/dd/yyyy
    //if input is null, return null
    public static String returnDateToString(Date input, String locale) {
        if (input == null ) {
            return null;
        }
        String result ; 
        if (!locale.equalsIgnoreCase('en_us')) { //only for US do nothing
            result = input.day() + '/' + input.month() + '/' + input.year();
        } else {
            result = input.month() + '/' + input.day() + '/' + input.year();
        }
        
        return result;
    }
    
    //return String value of Decimal removing fractional part and keeping the negative (or positive) sign
    //if input is null, return null
    public static String returnDecToString(Decimal input, String currencyCharacter) {
        String polarity = '';
        //Added by Rupayan
        Integer amt = 0;
        String result = '';
        
        if (input < 0) {
            polarity = '-';
        }
        if (input == null ) {
            return null;
        }
        //If else added by Rupayan
        if(currencyCharacter != null) {
        	amt = input.abs().round(System.RoundingMode.DOWN).intValue();
        	if(input == 0.00 )
        		result = String.valueOf(input);
        	else	
            	result = input.format(); // amt
        }
        else {
            // result = String.valueOf(input.abs().round(System.RoundingMode.DOWN));
            result = String.valueOf(input.format());
        }
        
        if (currencyCharacter != null) {
            //result = polarity + currencyCharacter + result;
            result = currencyCharacter + result;
        }
        
        return result;
    }
    
    //populate 'battery' chart values
    public static void setBattery(BatteryChartParams battery, Integer number1, Integer number2, Integer number3) {
        // check input
        System.debug(LoggingLevel.Error, '============= battery input params : ' + number1 + ', ' + number2 + ', ' + number3 + '');
        if (battery == null || number3 == null) {//|| number1 == null || number3 == null || number3 == null) {
            return;
        }
        Integer n1 = ((number1 <= 0 || number1 == null) ? 0 : number1); //rule for invoiced
        Integer n2 = (number2 == null ? 0 : number2); // avoid null pointer exceptions in battery logic
        Integer n3 = number3;
        
        System.debug(LoggingLevel.Error,'============= battery filtered params : ' + n1 + ', ' + n2 + ', ' + n3 + '');
        
        //get char rounding coef
        battery.setRoundingCoef(n1, n2, n3);
        System.debug(LoggingLevel.Error,'============= battery rounding coef: ' + battery.getRoundingCoef());
        battery.actualPerformance = n1 + n2;
        battery.halfTarget = n3 / 2;
        if (battery.actualPerformance <= n3) {
            battery.rightBorder = battery.round(n3 + battery.halfTarget);
            battery.color = CHART_COLOR_BAD;
        } else {
            battery.rightBorder = battery.round(battery.actualPerformance + battery.actualPerformance/10);
            battery.color = CHART_COLOR_GOOD;
        }
        
         System.debug(LoggingLevel.Error,'============= battery.goal: ' + n3);
          System.debug(LoggingLevel.Error,'============= battery.halfTarget: ' + battery.halfTarget);
          System.debug(LoggingLevel.Error,'============= battery.actualPerformance: ' + battery.actualPerformance);
         System.debug(LoggingLevel.Error,'============= battery.invoiced: ' + n1);
         System.debug(LoggingLevel.Error,'============= battery.submitted: ' + n2);
       
        
        battery.differenceTargetActual = Integer.valueOf(n3 - battery.actualPerformance);
        battery.goal = n3 ;
        battery.invoiced = n1 ;
        battery.submitted = n2  ;
        battery.halfTarget = battery.round(battery.halfTarget);
        
    }
    
    
    // determine if Leader is UL, EL or SEL
    // depends on Users' badge title and eixisting leader titles' information (list of titles)
    //List "titles" Must be sorted by title number
    public static String determineLeaderType(List<Leader_Title__c> titles, String userBadgeTitle) {
        // assume the list already sorted by title numbers
        Leader_Title__c l;
        Integer i = 0;
        if (titles == null || userBadgeTitle == null) {
            return null;
        } else {
            //check for whether titles_list sorted
            Boolean flag = false;
            for (Leader_Title__c lt : titles) {
                if (flag && (lt.EXEC_IND__c == null || lt.EXEC_IND__c == '')) { //unordered list
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Check Leader Title. Wrong input data.');
                    ApexPages.addMessage(myMsg);
                    return null;
                } else if (lt.EXEC_IND__c != null && lt.EXEC_IND__c == 'Y'){
                    flag = true;
                }
            }
        }
        
        System.debug('====================== determineLeaderType. userBadgeTitle : ' + userBadgeTitle);
        /*System.debug('====================== determineLeaderType. title 3: ' + titles[3].EXEC_IND__c);
        System.debug('====================== determineLeaderType. title 4: ' + titles[4].EXEC_IND__c);
        System.debug('====================== determineLeaderType. title 5: ' + titles[5].EXEC_IND__c);*/
        LandingPageUtils.debugList(titles, 'Leader title');
        // logic to determin if Leader is UL, EL or SEL
        while (i < titles.size()) {
            l = titles.get(i);
                System.debug('====================== LandingPageUtils. Determine Leader Type. ' + userBadgeTitle + '   vs  ' + l.LDRSHP_TITL_LVL_NR__c);
            if (userBadgeTitle == l.LDRSHP_TITL_LVL_NR__c ) {
                System.debug('====================== LandingPageUtils. Determine Leader Type. GOT here');
                if (l.EXEC_IND__c == null || l.EXEC_IND__c == '') {
                    System.debug('====================== LandingPageUtils. Determine Leader Type. Return :  UL');
                    return 'UL';
                } else if (l.EXEC_IND__c == 'Y' && i != 0 && titles.get(i-1).EXEC_IND__c != 'Y') {
                    System.debug('====================== LandingPageUtils. Determine Leader Type. Return : EL');
                    return 'EL';
                } else {
                    System.debug('====================== LandingPageUtils. Determine Leader Type. Return : SEL');
                    return 'SEL';
                }
            }
            i++;
        }
        
        return null;
    }
    
    //filters list of Leader_Title returnig only Leader Titles where EXEC_IND__c = 'Y'
    public static List<Leader_Title__c> returnOnlyLeaders(List<Leader_Title__c> titles) {
        List<Leader_Title__c> result = new List<Leader_Title__c>();
        for (Leader_Title__c title : titles) {
            if (title.EXEC_IND__c == 'Y') {
                result.add(title);
            }
        }
        
        return result;
    }
    
    //filters list of Leader_Title returnig only titles numbers where EXEC_IND__c = 'Y'
    public static List<String> returnOnlyLeadersNumbers(List<Leader_Title__c> titles) {
        List<String > result = new List<String>();
        for (Leader_Title__c title : returnOnlyLeaders(titles)) {
            result.add(title.LDRSHP_TITL_LVL_NR__c);
        }
        
        return result;
    }
    
    //utility method to output list content
    public static void debugList(List<sObject> listSObject, String objectName) {
        System.debug('====================== List of ' + objectName + ' size : ' + listSObject.size());
        for (sObject o : listSObject) {
            System.debug('====================== another ' + objectName + ': ' + o);
        }
    }
    
    //utility method to output map<String, sObject> content
    public static void debugMap(Map<String, sObject> mapSObject, String sObjectName) {
        System.debug('====================== Map of ' + sObjectName + ' size : ' + mapSObject.size());
        for (String k : mapSObject.keySet()) {
            System.debug('====================== another map : ' + k + ' -> ' + mapSObject.get(k));
        }
    }
    
    //utility method to output map<Integer, sObject> content
    public static void debugMap(Map<Integer, sObject> mapSObject, String sObjectName) {
        System.debug('====================== Map of ' + sObjectName + ' size : ' + mapSObject.size());
        for (Integer k : mapSObject.keySet()) {
            System.debug('====================== another map : ' + k + ' -> ' + mapSObject.get(k));
        }
    }
    
    public static String getSponsor(Map<String, Contact> mapContact,String marketId, String accountId) {
        Contact tempContact;
        System.debug('marketId --> '+marketId+' accountId - '+accountId+' mapContact - '+mapContact);
        if (marketId != null && accountId != null && mapContact != null && mapContact.size() > 0) {
            tempContact = mapContact.get(marketId + accountId);
            if (tempContact != null) {
                return tempContact.Name;
            }
        }
        
        return null;
    }
    
    // checks if string contains only numbers
    public static Boolean isNumber(String input) {
        
        String regex = '[0-9]+'; //regular expression to match only numbers
        Pattern myPattern = Pattern.compile(regex);
        Matcher myMatcher = myPattern.matcher(input);
        
        return myMatcher.matches();
    }
    
    
    // determine badge Title
    public static String determineBadgeTitle(Map<String, Leader_Title__c> mapLeaderTitle, String levelNumber) {
        Leader_Title__c tempLeaderTitle = null;
        String result = null;
        if (levelNumber != null ) {
                        
            if (mapLeaderTitle != null && mapLeaderTitle.size() > 0 && 
                        (tempLeaderTitle = mapLeaderTitle.get(levelNumber)) != null) {
                            
                result = tempLeaderTitle.LCL_LDRSHP_TITL_CD__c;
                System.debug('============ result retreived from mapLeaderTitle is : ' + tempLeaderTitle);
            } else {
                System.debug('====================== LandingPageUtils. Map of Leader_Title__c NOT FOUND!');
            }
                        
        } else {
            System.debug('====================== LandingPageUtils. Level Number NOT FOUND!');
        }
        
        return result;
    }
    
    //assembles string representation of url using input parameters
    //result is "?param=value&param2=value2......"
    public static String makeUrl(String address, Map<String, String> parameters) {
        System.debug('=========== LandingPageUtils. MakeURL. Address : ' + address);
        System.debug('=========== LandingPageUtils. MakeURL. Params : ' + parameters);
        
        if (address != null && isValidMapStringParams(parameters)) {
            return address + makeUrlParams(parameters, (address.contains('?')? '&' : '?'));
        } else {
            return null;
        }
        
    }
    
    //assembles string representation of parameters' part of a url
    public static String makeUrlParams(Map<String, String> parameters, String querySeparator) {
        if (!isValidMapStringParams(parameters)) {
            return null;
        }
        String result = querySeparator;
        
        //for the string
        for (String key : parameters.keySet()) {
            if (result.length() > 1) { //avoid & for the first param
                result = result + '&';
            }
            result = result + key + '=' + parameters.get(key);
        }
        
        return result;
    }
    
    //make coaching record or url according to input params
    //user is responsible for making correct parameters
    public static String makeCoachOrImperson(String flagString, String accountNumber, String originalUrl, Map<String, String> parameters) {
        String result;
        String [] exclude = new String [] {ALMConstants.IMPERSON_PARAM_NAME, ALMConstants.SEARCH_URL_PARAM};
        
        System.debug('=========== LandingPageUtils. MakeCoachOrImperson. flagString: ' + flagString);
        System.debug('=========== LandingPageUtils. MakeCoachOrImperson. accountNumber: ' + accountNumber);
        System.debug('=========== LandingPageUtils. MakeCoachOrImperson. Parameters: ' + parameters);
        System.debug('=========== LandingPageUtils. MakeCoachOrImperson. originalUrl: ' + originalUrl);
        if (!isValidMapStringParams(parameters)) {
            return null;
        }
        
        parameters.remove(ALMConstants.IMPERSON_PARAM_NAME); //remove dangling impersonation parameter
        
        if ( flagString != null && flagString == 'N') {  //link will direct to Landing Page with impersonation
            parameters.put(ALMConstants.IMPERSON_PARAM_NAME, accountNumber);
            //result = makeUrl(removeUrlParamsAll(originalUrl), parameters);
            result = makeUrl(excludeUrlParams(exclude, originalUrl), parameters);
        } else if (flagString == null || flagString == 'Y') { // viewLink directs to coaching
            result = 'javascript:' + ALMConstants.COACHING_FUNCTION_CALL + '(\'' + accountNumber +  '\')'; //showCoachingPage
        }
        System.debug('=========== LandingPageUtils. MakeCoachOrImperson. result: ' + result);
        return result;
    }
    
    // also populates some fields of LPDownlineWrapper
    public static void makeCoachOrImperson(String flagString, String accountNumber, String originalUrl,
                                                     Map<String, String> parameters, LPDownlineWrapper record) { 
    
        String result = null;
        if (record != null) {
            record.viewLink = makeCoachOrImperson(flagString, accountNumber, originalUrl, parameters);
            if(record.viewLink != null && record.viewLink.contains('javascript')){
                record.showCoachingLink = true;
            } else {
                record.showCoachingLink = false;
            }
            
        } else {
            System.debug('=========== LandingPageUtils. makeCoachOrImperson. LPDownlineWrapper record is null');
        }
    }
    
    // removes all query params from input url
    // input "something.com?param1=value1" returns "something.com"
    public static String removeUrlParamsAll(String address) {
        String result ;
        System.debug('====================== LandingPageUtils. removeUrlParams. address: ' + address);
        if (address != null && address.length() > 0) {
            
            result = address.replaceAll('\\?.*$', '');
        }
        System.debug('====================== LandingPageUtils. removeUrlParams. result : ' + result);
        
        return result;
    }
    
    //remove only certain parameters containted in "exclude" array from url
    public static String excludeUrlParams(String [] exclude, String address) {
        String result;
        System.debug('====================== LandingPageUtils. excludeUrlParams. address: ' + address);
        System.debug('====================== LandingPageUtils. excludeUrlParams. exclude: ' + exclude);
        if (address != null && address.length() > 0) {
            
            for (String str : exclude) {
                result = address.replaceFirst('&?'+ str +'=\\w+', '');
            }
            result = result.replaceFirst('\\?&', '?');
        }
        System.debug('====================== LandingPageUtils. excludeUrlParams. result : ' + result);
        
        return result;
    }
    
    // check if impersonation allowed for profile
    // input String must have format 'profile1;profile2;profile3' with allowed spaces
    public static boolean isEmailAllowedForProfile(String profileToCheck, String profilesString) {
        String [] profiles = profilesString.split(';', 0);
        if (profileToCheck == null || profiles == null) {
            return false;
        }
        for (String pn : profiles) {
            if (profileToCheck.equalsIgnoreCase(pn)) {
                return true;
            }
        }
        
        return false;
    }
    
    
    //check if parameters ok for processing
    public static Boolean isValidMapStringParams(Map<String, String> parameters) {
        if (parameters == null /*|| parameters.size() == 0*/) { // it is possible that NO parameters 
            return false;
        }
        
        return true;
    }
    
    // is person being impersonated is downline
    /*public static Boolean isImpersonationValid(String marketId, String accountId, String campaignNumber, String imperson) {
        try {
            String selectString = 'SELECT Id FROM X' + marketId + '_Genealogy__c WHERE UPLN_ACCT_NR__c = \'' + accountId + '\' AND ACCT_NR__c = \'' + imperson + '\' AND CMPGN_NR__c = \'' + campaignNumber + '\' LIMIT 1'; 
            List<SObject> tempList = Database.query(selectString);
            if (tempList.size() > 0) {
                return true;
            } else {
                return false;
            }
        } catch(Exception e) {
            // if any exception return FALSE
            return false;
        }
        
        return false;
    }
    */
    public static Boolean isImpersonationValid(String profileName, String marketId, String zone, String division, String accountId, String campaignNumber, String imperson) {
	  System.debug('====================== LandingPageUtils.isImpersonationValid. profileName: ' + profileName + ', marketId: ' + marketId + ', zone: ' + zone + ', division: ' + division + ', accountId: ' + accountId + ', campaignNumber: ' + campaignNumber + ', imperson: ' + imperson);
      Boolean isValid = imperson.equals(accountId);
      Boolean isSLImpersonate=false;
      
      Market__c currentMarket=[select Id,ALM_Rep_Indicator__c from Market__c where Market_Id__c=:marketId limit 1];
	 
      
	  if (!isValid) 
	  {
        String selectString;
        if ( profileName.contains(ALMPLusConstants.AVON_ZM_BASE) 
        		|| profileName.contains(ALMPLusConstants.AVON_DM_BASE)
        		|| profileName.contains(ALMPLusConstants.AVON_TM_BASE) ) 
        {
			ZM_UtilityClass helper = new ZM_UtilityClass();
        	helper.SetVariable();
        	selectString = 'SELECT Id FROM Contact WHERE SLS_ZONE_CD__c IN (' + helper.getVisibleZonesAsDelimitedString() + ') AND MRKT_ACCT_KEY__c = \'' + marketId + imperson + '\' LIMIT 1';	
       
        } else {
        	isSLImpersonate=true;
        	////using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
        	 selectString = 'SELECT Id, MRKT_ID__c, Genealogy_Level__c, ROOT_UPLN_ACCT_NR__c, ACCT_NR__c, lft_nd_id__c, rgt_nd_Id__c FROM ' + currentMarket.ALM_Rep_Indicator__c  + ' where ACCT_NR__c in (\''+ imperson + '\', \'' + accountId + '\')  and MRKT_ID__c=\'' + marketId + '\' AND FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber) ;
       //	selectString = 'SELECT Id FROM X' + marketId + '_Genealogy__c WHERE UPLN_ACCT_NR__c = \'' + accountId + '\' AND ACCT_NR__c = \'' + imperson + '\' AND CMPGN_NR__c = \'' + campaignNumber + '\' LIMIT 1'; 
        }
        System.debug('=======Search string ========== ' + selectString);
          try {
              List<SObject> tempList = Database.query(selectString);
              if (tempList.size() > 0 && isSLImpersonate!=null && !isSLImpersonate) {
                  isValid = true;
              }
              
              //SL impersonation
              else if(isSLImpersonate!=null && isSLImpersonate && tempList.size() > 0){
              	
              	Decimal previouslftValue=null;
              	Decimal previousrgtValue=null;
               	String previousRootUpline=null;
              	
              	for(SObject sObjInstance:tempList){
              		String accntNumber=(String)sObjInstance.get('ACCT_NR__c');
              		String rootUpline=(String)sObjInstance.get('ROOT_UPLN_ACCT_NR__c');
              		Decimal lftValue=(Decimal)sObjInstance.get('lft_nd_id__c');
              		Decimal rgtValue=(Decimal)sObjInstance.get('rgt_nd_Id__c');
              		
              		if(previouslftValue!=null && previousRootUpline.equals(rootUpline)){
              			if(accntNumber==accountId){
              				//previousleftvalue is the left of the child. That should be in between the left and right of the parent.
              	 			return (lftValue<previouslftValue && rgtValue>previouslftValue);
              			}
              			//reading impersonate account
              			else{
              		 		//lftValue is the left of the child. That should be in between the left and right of the parent (previous identifiers).
              				return (previouslftValue<lftValue && previousrgtValue>lftValue);
              			}
              			
              		}
              		//the nodes belong to different trees.
              		else if(previouslftValue!=null && !(previousRootUpline.equals(rootUpline))){
              			return false;
              		}
              		//previous value is not populated. populate them
              		else{
               			previouslftValue=lftValue;
              		   previousrgtValue=rgtValue;
              		   previousRootUpline=rootUpline;
              		 
              		}
              	}
              	
              }
              else{
              	isValid = false;
              }
              
          } catch(Exception e) {
            System.debug('Exception e-->'+e.getMessage());
          }
      }   
      System.debug('IsImpersonationValid = ' + isValid);
        return isValid;
    }
    
    // logic for determining campaign from query parameter
    public static Boolean isPreviousCampaign(String paramValue) {
        if (paramValue != null) {
            if (paramValue.equalsIgnoreCase(ALMConstants.PRIOR_CAMPAIGN)) {
                return true;
            } else if (paramValue.equalsIgnoreCase(ALMConstants.CURRENT_CAMPAIGN)) {
                return false;
            }
        }
        
        return false;
    }
    
    // Added by Raktim on 21Jun 2013 - Mail Plan
    // logic for determining campaign from query parameter
    public static Boolean isNextCampaign(String paramValue) {
        if (paramValue != null) {
            if (paramValue.equalsIgnoreCase(ALMConstants.NEXT_CAMPAIGN)) {
                return true;
            } else if (paramValue.equalsIgnoreCase(ALMConstants.CURRENT_CAMPAIGN)) {
                return false;
            }
        }
        
        return false;
    }//End of Method
    
    //custom exceptions
    class InconsistentDataException extends Exception {
    }
    
    class InvalidInputParamsException extends Exception {
    }
}