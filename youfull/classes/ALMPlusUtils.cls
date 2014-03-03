/**
    Holds utility methods which are reusable across various classes.
    
    Activity History:  
    Shah Kadirmohideen - 9/18 - Added the following methods:
                                    getMarketDetails()
                                    httpGet()
                                    httpPost()
                                    httpCall()
                                    addParametersToURL()
                                    removePhoneFormatting()
                                    getRemainingSOQLLimit()
                                    getRemainingFutureLimit()
                                    getRemainingCalloutLimit()
                                    getRemainingEmailLimit()
                                    fetchALMGlobalSetting()
                                    loadFieldsMetaData()
                                    fetchAllUniqueMatches()
                                    concatenate()
                                    generateToken()
            
    Shah Kadirmohideen - 9/21 - Added generateOmniturePageName() method.
    Shah Kadirmohideen - 9/23 - Added prepareGeoMarketQueueName() method
    Shah Kadirmohideen - 9/28 - Added prepareJobsSchTime() & getUniqueJobName() methods.
    Shah Kadirmohideen - 10/10 - Code Reviewed (look for CRF: to view code review feedback comments)
    Shah Kadirmohideen - 11/9  - Added getRemainingDMLLimit() method.
*/
global class ALMPlusUtils {
    
    public class MktQueues{
        //market queue id
        public String mktQueueId;
        //market customer service queue id
        public String mktCsQueueId;
    }
    
    //@future
    public static void setUsersSystemOverride(Set<String> userIds){
        List<User> users = [select System_Override__c, isSync_Update__c from User where Id in :userIds];  //CRF: we can avoid this SOQL by preparing the user object (eg: User u = new User(Id=uid))
        for (user u:users){
            u.System_Override__c = true;
            u.isSync_Update__c = true;
        }
        update users;
    }   
    
    
    public static void assignToCsQueue(Lead l, String queueId){
        if(queueId != null)
            l.ownerid=queueId;
        else
            ALMLogUtils.log('assigntoScQueue', 'ERROR: cannot find customer service queue for lead: ' + l); 
        // Set Lead_Owner__c to null; Set SLS_DIV_NM__c to null; Set SLS_ZONE_CD__c to null
        l.Lead_Owner__c = null;
        l.SLS_DIV_NM__c = null;
        l.SLS_ZONE_CD__c = null;
    }
    
    public static String getCsQueueId(String marketCode){
        String queueId;
        String custServQueueName = marketCode + ' ' + ALMPlusConstants.CUST_SRV_QUEUE_NM_SUFFIX;
        System.debug('looking for queue named ' + custServQueueName);
        List<QueueSobject> custServQueue = [select id, queueid, queue.name from QueueSobject where queue.name=:custServQueueName limit 1];
        if(custServQueue.size() > 0)
            queueId = custServQueue[0].QueueId;
        return queueId;
    }

    public static Market__c getMarketDetails(String marketId) {
        List<Market__c> markets = Database.query(SOQLUtils.soqlForMarket(marketId));
        if (markets.size() == 1) {
            return markets.get(0); 
        }
        return null;
    } 
    
    public static HttpResponse httpGet(String url, Integer timeoutInSeconds, Integer errorReattempts, HttpResponse testResponse) {
        return httpCall('GET', url, timeoutInSeconds, errorReattempts, testResponse);
    }
    
    public static HttpResponse httpPost(String url, Integer timeoutInSeconds, Integer errorReattempts, HttpResponse testResponse) {
        return httpCall('POST', url, timeoutInSeconds, errorReattempts, testResponse);
    }
    
    private static HttpResponse httpCall(String method, String url, Integer timeoutInSeconds, Integer errorReattempts, HttpResponse testResponse) {
        for (Integer i=0; i<errorReattempts; i++) { 
            try {
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setTimeout(timeoutInSeconds*1000); 
                req.setEndpoint(url);
                // Change added by Vijay Mittal on Mar-12, 2012
                // Line added to set the request body with blank String
                // to prevent error "Length Required" in case of POST callout
                req.setBody('');
                req.setMethod(method);
                if (Test.isRunningTest()) {
                    return testResponse; 
                }
                else {
                    ALMPlusUtils.getRemainingCalloutLimit();  //displays the limit
                    return h.send(req);
                }
            }
            catch (Exception e) {
                System.debug('Error found, but may be reattempted. ' + e);
            }
        }
        return null;
    }
    
    //Adds the parameters into the URL using key=value template
    public static String addParametersToURL(String sUrl, Map<String, String> mapParams, Boolean bEncode) 
    {
        if (mapParams == null) return sUrl;
        if (sURL.contains('?') == false) sUrl += '?';
        
        Integer iCount = 0;
        for (String key : mapParams.keySet()) 
        {
            sUrl += key + '=';
            if (bEncode) {
                 sUrl += EncodingUtil.urlEncode(mapParams.get(key), 'UTF-8');
            }
            else {
                sUrl += mapParams.get(key);
            }
            
            iCount++;
            if (iCount < mapParams.size())
            {
                sUrl += '&';
            }
        }
        return sUrl;
    }   

    public static String removePhoneFormatting(String phone) {
        System.debug('input phone: ' + phone);
        if (phone == null) return phone;
        phone = phone.replaceAll(' ', '');
        phone = phone.replaceAll('\\-', '');
        phone = phone.replaceAll('\\(', '');
        phone = phone.replaceAll('\\)', '');
        phone = phone.replaceAll('\\+', '');
        phone = phone.replaceAll('\\.', '');
        phone = phone.replaceAll('/', '');
        
        phone = phone.toLowerCase();
        Integer i = phone.indexOf('ext');
        if (i != -1) {
            phone = phone.substring(0, i);
        }
        phone = phone.trim();
        System.debug('unformatted phone: ' + phone);
        return phone;
    }     

    public static Integer getRemainingSOQLLimit() {
        Integer rem = Limits.getLimitQueries() - Limits.getQueries();
        return rem; 
    }
  
    public static Integer getRemainingDMLLimit() {
        Integer rem = Limits.getLimitDMLRows() - Limits.getDMLRows();
        return rem; 
    }

    public static Integer getRemainingFutureLimit() {
        Integer rem = Limits.getLimitFutureCalls() - Limits.getFutureCalls();
        return rem; 
    }
    
    public static Integer getRemainingCalloutLimit() {
        Integer rem = Limits.getLimitCallouts() - Limits.getCallouts();
        return rem; 
    }

    public static Integer getRemainingEmailLimit() {
        Integer rem = Limits.getLimitEmailInvocations() - Limits.getEmailInvocations();
        return rem; 
    }
    
    public static ALM_Global_Settings__c fetchALMGlobalSetting() {
        Map<String, ALM_Global_Settings__c> mapValues = ALM_Global_Settings__c.getAll();
        if (mapValues.size() > 0) {
            return mapValues.get(ALMPlusConstants.ALM_GLOBAL_SETTINGS_RECORD_KEY);
        }
        return null;
    }
    
    //returns map (key->field name)
    public static Map<String, DescribeFieldResult> loadFieldsMetaData(SObject obj) {
        Map<String, DescribeFieldResult> fieldMetaDataMap = new Map<String, DescribeFieldResult>();
        
        SObjectType objToken = obj.getSObjectType();
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        
        for(SObjectField fieldToken : fields.values()) {
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            fieldMetaDataMap.put(selectedField.getName(), selectedField);
        }
        
        return fieldMetaDataMap;
    } 
    
    //searches for a regular expression (pat) in the given text (data)
    public static Set<String> fetchAllUniqueMatches(String data, Pattern pat) {
        System.debug('input text: ' + data);
        Set<String> result = new Set<String>();
        Matcher mer = pat.matcher(data);
        String email = null;
        while (mer.find()) {
            email = mer.group();
            System.debug('found: ' + email);
            result.add(email);
        }
        System.debug('result: ' + result);
        return result;
    }
    
    public static String concatenate(Set<Id> arr, String sep) {
        String result = '';
        if (arr == null) return result;
        Integer i=1;
        for (String ele : arr) {
            result += ele;
            if (i < arr.size()) result += sep;
            i++;
        }
        return result;
    }

    public static String concatenateString(Set<String> arr, String sep) {
        String result = '';
        if (arr == null) return result;
        Integer i=1;
        for (String ele : arr) {
            result += ele;
            if (i < arr.size()) result += sep;
            i++;
        }
        System.debug('concatenated string: ' + result);
        return result;
    }
    
    //genereates a random token using the specified length
    public static String generateToken(Integer length) {
        DateTime d = System.now();
        Long ll = d.getTime();
        String newS = '' + ll;
        String algorithmName = 'HMacSHA1';
        Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(newS),
        Blob.valueOf('clt'));
        String token = EncodingUtil.urlEncode(EncodingUtil.base64Encode(mac), 'UTF-8');
        token = token.replaceAll('%', 'p');
        if (length > 0 && token.length() > length) {
            return token.substring(0, length);  
        }
        else {
            return token;
        }
    }
    
    //pass either profileId or profileName variable. If profile name is available, pass that (instead of profileId) to improve performance.
    public static String generateOmniturePageName(String visualforcePageName, String profileId, String profileName) {
        if (profileName == null && profileId != null) {
            profileName = [Select Id, Name from Profile where Id=:profileId].Name;
        }
        String omniturePageName = '';
        Omniture_Page_Name_Mapping__c mappingSetting = Omniture_Page_Name_Mapping__c.getValues(visualforcePageName);
        if (mappingSetting != null) {
            omniturePageName = mappingSetting.Omniture_Page_Name__c;
            String profileAlias = ALMPlusConstants.profileAliasMap.get(profileName);
            if (profileAlias != null) {
                omniturePageName += '_' + profileAlias;
            }
        }
        System.debug('visualforcePageName: ' + visualforcePageName + ', omniturePageName: ' + omniturePageName);
        return omniturePageName;
    }
    
    //Prepares market queue name for a given market id. The generated queue name is used to assign the correct queue as the owner to the geo objects.
    public static String prepareGeoMarketQueueName(String marketId) {
        return marketId + ' Market Queue';
    }
    
    //used in batch apex
    public static String prepareJobsSchTime(DateTime startDate, Integer addMinutes) {
        Datetime scheduleTime = startDate.addMinutes(addMinutes);
        String hour = scheduleTime.format('k');
        if (hour == '24') hour = '0';
        String scheduleTimeStr = '0 ' + scheduleTime.format('m') + ' ' + hour +  scheduleTime.format(' d M') + ' ? ' + scheduleTime.format('yyyy');
        System.debug('scheduleTimeStr: ' + scheduleTimeStr);
        return scheduleTimeStr;
    }
    
    //used in batch apex
    public static String getUniqueJobName(String batchApexName) {
        System.debug('batchApexName: ' + batchApexName);
        String uniqueJobName = batchApexName + '_' + System.now().format('yyyy-MM-dd_k:m:s');
        System.debug('uniqueJobName: ' + uniqueJobName);
        return uniqueJobName;
    }
    
    public static RecordType getRecordType(String objectName, String developerName) {
        Map<String, RecordType> recTypeMap = getRecordTypeMap(objectName, new String[]{developerName});
        return recTypeMap.get(developerName);
    }
    
    public static Map<String, RecordType> getRecordTypeMap(String objectName, String[] developerNames) {
        Map<String, RecordType> recTypeMap = new Map<String, RecordType>();
        for (RecordType rec : [Select Id, Name, DeveloperName, SObjectType from RecordType where SObjectType=:objectName and DeveloperName in :developerNames]) {
            recTypeMap.put(rec.DeveloperName, rec);
        }       
        return recTypeMap;
    }

    
    /**
    * returns a map: market code -> market record
    * returns only a limited subset of market fields
    */
    public static Map<String,Market__c> getMarketsMap(String whereClause){
        Map<String, Market__c> marketsMap = new Map<String, Market__c>();
        String allMarketsSoql = 'Select Market_Id__c, CURRNT_CMPGN_RMN_DAY_CNT__c, CURRENT_QRTR__c,' +
                                ' Is_ALMPLUS_Enabled__c, ' +   
                                ' CURRENT_CAMPAIGN_NR__c, CMPGN_STRT_DT__c, CMPGN_NR__c From Market__c ';
        if(whereClause != null){
            allMarketsSoql += whereClause;
        }
        for(Market__c m: Database.query(allMarketsSoql)){
            marketsMap.put(m.Market_Id__c,m);
        }
        return marketsMap;
    }
    
    /**
    * returns a map of mkt_code -> MktQueues {mktQueueId, mktCsQueueId}
    * allows accessing mkt or mkt cs queue id based on the market code
    */  
    public static Map<String, MktQueues> getMarketQueueMap(List<Market__c> markets){
        Map<String, MktQueues> mktCodeToMktQueues = new Map<String, MktQueues>();
        Map<String,String> csQueueNameToMktCode = new Map<String,String>();
        Map<String,String> mktQueueNameToMktCode = new Map<String,String>();
        
        for(Market__c m: markets){
            //customer service queue
            csQueueNameToMktCode.put(m.Market_Id__c + ' ' + ALMPlusConstants.CUST_SRV_QUEUE_NM_SUFFIX, m.Market_Id__c);
            //market queue
            mktQueueNameToMktCode.put(m.Market_Id__c + ' ' + ALMPlusConstants.MKT_QUEUE_NM_SUFFIX, m.Market_Id__c);         
        }
        System.debug('csQueueNameToMktCode: ' + csQueueNameToMktCode);
        System.debug('mktQueueNameToMktCode: ' + mktQueueNameToMktCode);
        for (Group queue : [Select Id, Name from Group where Type='Queue' and Name in :csQueueNameToMktCode.keySet()]) {
            MktQueues mQueues = new MktQueues();
            mQueues.mktCsQueueId = queue.Id; 
            mktCodeToMktQueues.put(csQueueNameToMktCode.get(queue.Name), mQueues);
        }
        System.debug('mktCodeToMktQueues: ' + mktCodeToMktQueues);
        for (Group queue : [Select Id, Name from Group where Type='Queue' and Name in :mktQueueNameToMktCode.keySet()]) {
            if(mktCodeToMktQueues.get(mktQueueNameToMktCode.get(queue.Name)) != null)
                mktCodeToMktQueues.get(mktQueueNameToMktCode.get(queue.Name)).mktQueueId = queue.Id;
        }

        return mktCodeToMktQueues;
    }
    
    /*//Dynamic query creator
    public static String buildSelectStatementForSObject(Schema.SObjectType obj){
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select ';
        for(String fldName: fldMap.keySet()){
            tempSoql+=fldName+',';
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-1);
        tempSoql += ' from '+descResult.getLocalName();
        ALMLogUtils.log('buildSelectStatement','::'+tempSoql);
        return tempSoql;
    }
    */
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*@isTest
     public static  void testALMPlusUtils(){
        TestDataHelper testData =   new TestDataHelper();
        String s_MarketId='DE';
        String mktIdKey = 'XX';
        //Creating Market
        Market__c mrkt = testData.createMarket(s_MarketId);
        
          //Create Leader User
        User ldrUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            ldrUsr = testData.createLeaderUser(mktIdKey);
            ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
            ldrUsr.IsActive = true;
            update ldrUsr;
        }
        
         System.runAs(ldrUsr)
        {
            Lead tmpLead = testData.createlead(ldrUsr);
            assignToCsQueue(tmpLead,null);
            String csQueueId = getCsQueueId(mktIdKey);
            Market__c m = getMarketDetails(mktIdKey);
            HttpResponse h = httpGet(null,1,1,null);
            h = httpPost(null,1,1,null);
            String ph = removePhoneFormatting('+91-033-111-222');
            Integer l = getRemainingSOQLLimit();
            l = getRemainingDMLLimit();
            l = getRemainingFutureLimit();
            l = getRemainingCalloutLimit();
            l = getRemainingEmailLimit();
            String url = '';
            Map<String,String> params = new Map<String,String>{'a' => 'b'};
            url = addParametersToURL(url,params,false);
            ALM_Global_Settings__c settings = fetchALMGlobalSetting();
            Map<String, DescribeFieldResult> metaDat = loadFieldsMetaData(mrkt);
            Pattern pat = Pattern.compile('t*t');
            Set<String> matches = fetchAllUniqueMatches('test string',pat);
            Set<Id> setid = new Set<Id>{'00300000003T2test1','00300000003T2test2'};
            String concat = concatenate(setid,'#');
            concat = concatenateString(matches,'#');
            String token = generateToken(5);
            String omni = generateOmniturePageName('YouHome',null,'Avon Leader');
            String mktQ = prepareGeoMarketQueueName(mktIdKey);
            datetime myDate = datetime.newInstance(2013, 4, 1);
            String dt = prepareJobsSchTime(myDate,60);
            List<Market__c> lm = new List<Market__c>{mrkt};
            Map<String, MktQueues> mktmap = getMarketQueueMap(lm);
            Set<String> setUsr = new Set<String>{ldrUsr.Id};
            setUsersSystemOverride(setUsr );
        }
     }*/

}