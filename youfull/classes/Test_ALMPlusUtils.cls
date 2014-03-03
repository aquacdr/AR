/***************************************************************************
 Name         : Test_ALMPlusUtils
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ALMPlusUtils
 Created Date : Nov 13, 2013                
****************************************************************************/
@isTest
private class Test_ALMPlusUtils {
    
    //----------------------------------------------------------------------------
    // Method Name  : testALMPlusUtils
    // Description  : Method for Test Coverage of Class : ALMPlusUtils
    //----------------------------------------------------------------------------
    static testMethod void testALMPlusUtils() {
        TestDataHelper testData =   new TestDataHelper();
        String s_MarketId = 'DE';
        String acctNr = 'XX';
        //Creating Market
        Market__c mrkt = TestDataHelper.createMarket(s_MarketId, true);
        
        //Create Leader User
        User ldrUsr = TestDataHelper.createUser(acctNr, 'XZ1', 'Avon Leader', false);
        ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
        ldrUsr.IsActive = true;
        insert ldrUsr;
        
        system.runAs(ldrUsr){
            Lead tmpLead = TestDataHelper.createLead(ldrUsr, true);
            ALMPlusUtils.assignToCsQueue(tmpLead, null);
            String csQueueId = ALMPlusUtils.getCsQueueId(acctNr);
            
            Market__c m = ALMPlusUtils.getMarketDetails(acctNr);
            HttpResponse h = ALMPlusUtils.httpGet(null,1,1,null);
            h = ALMPlusUtils.httpPost(null,1,1,null);
            String ph = ALMPlusUtils.removePhoneFormatting('+91-033-111-222');
            Integer l = ALMPlusUtils.getRemainingSOQLLimit();
            l = ALMPlusUtils.getRemainingDMLLimit();
            l = ALMPlusUtils.getRemainingFutureLimit();
            l = ALMPlusUtils.getRemainingCalloutLimit();
            l = ALMPlusUtils.getRemainingEmailLimit();
            
            String url = '';
            Map<String,String> params = new Map<String,String>{'a' => 'b'};
            url = ALMPlusUtils.addParametersToURL(url,params,false);
            ALM_Global_Settings__c settings = ALMPlusUtils.fetchALMGlobalSetting();
            Map<String, DescribeFieldResult> metaDat = ALMPlusUtils.loadFieldsMetaData(mrkt);
            Pattern pat = Pattern.compile('t*t');
            Set<String> matches = ALMPlusUtils.fetchAllUniqueMatches('test string',pat);
            Set<Id> setid = new Set<Id>{'00300000003T2test1', '00300000003T2test2'};
            String concat = ALMPlusUtils.concatenate(setid, '#');
            concat = ALMPlusUtils.concatenateString(matches, '#');
            String token = ALMPlusUtils.generateToken(5);
            String omni = ALMPlusUtils.generateOmniturePageName('YouHome', null, 'Avon Leader');
            String mktQ = ALMPlusUtils.prepareGeoMarketQueueName(acctNr);
            datetime myDate = datetime.newInstance(2013, 4, 1);
            String dt = ALMPlusUtils.prepareJobsSchTime(myDate, 60);
            
            List<Market__c> lm = new List<Market__c>{mrkt};
            Map<String, ALMPlusUtils.MktQueues> mktmap = ALMPlusUtils.getMarketQueueMap(lm);
            Set<String> setUsr = new Set<String>{ldrUsr.Id};
            ALMPlusUtils.setUsersSystemOverride(setUsr);
            ALMPlusUtils.getMarketsMap('Where Id != null');
            ALMPlusUtils.getUniqueJobName('');
            ALMPlusUtils.getRecordType('Notification_Queue__c', 'Email');
            ALMPlusUtils.getRecordTypeMap('Notification_Queue__c', new List<String>{'Email'});
        }
    }
}