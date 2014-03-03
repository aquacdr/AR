/***************************************************************************
 Name         : Test_DisplayWidgetsController 
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for DisplayWidgetsController
 Created Date : Oct. 25, 2013                
****************************************************************************/
@isTest
private class Test_DisplayWidgetsController {  
    private static String MRKT_ID = 'mktcd';  
    private static String ACCT_NR = 'acctnbr';
    private static String LANG_CD = 'langcd'; 
    private static String KEY = 'key';  
    private static String DEBUG = 'debug';
    private static String PGID = 'pgId';
    private static String DATE_FORMAT = 'MM/dd/yyyy'; 
    
    //----------------------------------------------------------------------------
    // Method Name  : testDisplayWidgetsController
    // Description  : Method for Test Coverage of Class : DisplayWidgetsController
    //----------------------------------------------------------------------------  
    public static testmethod void testDisplayWidgetsController() {
        Profile pfile = [Select Id, Name From Profile Limit 1];
        ALM_Global_Settings__c globalConfig = TestDataHelper.createALMGlobalSetting(true);       
        String mrktKey = 'TESTDW';
        
        //Create and Insert Object: User
        User usr = TestDataHelper.createUser('DW2', String.valueOf(pfile.Id), false);
        usr.FederationIdentifier = mrktKey + '1234567';
        usr.ACCT_NR__c = '1234567';
        usr.MRKT_ID__c = mrktKey + '2';
        usr.CDW_STS_CD__c = 'Active';
        insert usr;        
         
        //Create and Insert Object: Market__c
        Market__c mrkt = TestDataHelper.createMarket(mrktKey + '2', false);
        mrkt.Name = 'Test Market DW 2';
        mrkt.ASLF_Market_Id__c = mrkt.Market_Id__c;
        insert mrkt;
        
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR, usr.ACCT_NR__c);
        pageRef.getParameters().put(MRKT_ID, mrkt.Market_Id__c);
        pageRef.getParameters().put(LANG_CD, 'en_US');
        pageRef.getParameters().put(DEBUG, '1');
        pageRef.getParameters().put('usrId', usr.Id);
        
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        ctlr.init();
        //verify result
        system.assert(ctlr.stsMsg == System.Label.Widget_error); 
        
        String dateStr = System.now().format('MM/dd/yyyy');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = mrkt.Market_Id__c + usr.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);     
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        
        ctlr = new DisplayWidgetsController();
        ctlr.init();
        //verify result
        system.assert(ctlr.stsMsg == System.Label.Widget_error);   
        Test.stopTest();   
              
        ctlr.storeUserInfo();      
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testDisplayWidgetsMultipleUserAcctNbr
    // Description  : Method for Test Coverage of Class : testDisplayWidgetsMultipleUserAcctNbr
    //---------------------------------------------------------------------------- 
    public static testmethod void testDisplayWidgetsMultipleUserAcctNbr(){
        String acctNbr = '123456';
        ALM_Global_Settings__c globalConfig = TestDataHelper.createALMGlobalSetting(true);
        
        // Create Market 
        Market__c market = TestDataHelper.createMarket(acctNbr, false);
        market.ASLF_Market_Id__c = market.Market_Id__c;
        insert market;  
        
        // Create Multiple user with different AcctNbr    
        User ldrUsr = TestDataHelper.createUser(acctNbr, 'XZ1', 'Avon Leader', false);
        ldrUsr.MRKT_ID__c = market.Market_Id__c;
        ldrUsr.MRKT_ID_ACCT_NR_KEY__c = market.Market_Id__c + acctNbr;
        insert ldrUsr;
        User ldrUsr1 = TestDataHelper.createUser('123455', 'XZ1', 'Avon Leader', false);
        ldrUsr1.MRKT_ID__c = market.Market_Id__c;   
        ldrUsr1.MRKT_ID_ACCT_NR_KEY__c = market.Market_Id__c + acctNbr;  
        insert ldrUsr1;
        
        // Set page parameters
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR, acctNbr);
        pageRef.getParameters().put(MRKT_ID, market.Market_Id__c);
        pageRef.getParameters().put(LANG_CD, ldrUsr.LanguageLocaleKey);
        pageRef.getParameters().put(DEBUG, '1');
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        
        String SHARED_SECRET = globalConfig.Shared_Secret__c;    
        String toHash = market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY, EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        system.assert(ApexPages.getMessages().isEmpty());
        
        pageRef = ctlr.init();
        //verify result
        system.assert(ctlr.stsMsg == System.Label.Widget_error);
        Test.stopTest();
        
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testDisplayWidgetsMultipleUserAcctNbr
    // Description  : Method for Test Coverage of Class : testDisplayWidgetsMultipleUserAcctNbr
    //---------------------------------------------------------------------------- 
    public static testmethod void testDisplayWidgetsSingleUserAcctNbr() {
        Profile pfile = [Select Id, Name From Profile Limit 1];
        ALM_Global_Settings__c globalConfig = TestDataHelper.createALMGlobalSetting(true);       
        String mrktKey = 'TESTDW';
        
        //Create and Insert Object: User
        User usr = TestDataHelper.createUser('DW2', String.valueOf(pfile.Id), false);
        usr.FederationIdentifier = mrktKey + '2' + '1234567';
        usr.ACCT_NR__c = '1234567';
        usr.MRKT_ID__c = mrktKey + '2';
        usr.CDW_STS_CD__c = 'Active';
        insert usr;        
         
        //Create and Insert Object: Market__c
        Market__c mrkt = TestDataHelper.createMarket(mrktKey + '2', false);
        mrkt.Name = 'Test Market DW 2';
        mrkt.ASLF_Market_Id__c = mrkt.Market_Id__c;
        insert mrkt;
        
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR, usr.ACCT_NR__c);
        pageRef.getParameters().put(MRKT_ID, mrkt.Market_Id__c);
        pageRef.getParameters().put(LANG_CD, 'en_US');
        pageRef.getParameters().put(DEBUG, '1');
        pageRef.getParameters().put('usrId', usr.Id);
        
        String dateStr = System.now().format('MM/dd/yyyy');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = mrkt.Market_Id__c + usr.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);     
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        ctlr.init();
        
        //update market to mail plan enabled
        mrkt.mail_plan_enabled__c = true;
        update mrkt;
        
        ctlr = new DisplayWidgetsController();
        ctlr.init();
        system.assert(ctlr.stsMsg == System.Label.Widget_error);            
        ctlr.storeUserInfo(); 
        Test.stopTest();   
    }
}