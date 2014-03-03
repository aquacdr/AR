/***************************************************************************
 Name         : Test_ActivateUserController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for ActivateUserController
 Created Date : Oct. 29, 2013                
****************************************************************************/

@isTest
private class Test_ActivateUserController { 
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserController (Profile: AVON Leader)
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserController() {        
        String mktIdKey = 'DE';
        String acctNr = '12345';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        marketOne.Is_ALMPLUS_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser(acctNr, 'XZ1', 'Avon Leader', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '1234567';
        testUsr.CDW_STS_CD__c = 'Active';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('1234567', 'XZ1', 'Avon Leader', false);
        usrList.add(testUsrOne);
        insert usrList;
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        pageRef.getParameters().put('debug', '1');
        pageRef.getParameters().put('pgId', '1234');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlrOne = new ActivateUserController();
        ctlrOne.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        //Update Test User : Set User as Inactive
        System.runAs(testUsrOne) {
        	testUsr.isActive = false;
        	update testUsr;
        }
        
        ActivateUserController ctlrTwo = new ActivateUserController();
        ctlrTwo.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 1);
        
        //Update Test User : Set User.CDW_STS_CD__c as blank
        System.runAs(testUsrOne) {
        	testUsr.CDW_STS_CD__c = '';
        	update testUsr;
        }
        
        ActivateUserController ctlrThree = new ActivateUserController();
        ctlrThree.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 3);
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserControllerOne
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserControllerOne() {     
        String mktIdKey = 'DE1';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('12345', 'XZ1', 'Avon Leader', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '123456';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('123456', 'XZ1', 'Avon Leader', false);
        usrList.add(testUsrOne);
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        pageRef.getParameters().put('debug', '1');
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        System.debug('*** hash : ' + hash);
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 2);
        System.assertEquals(msgs[1].getSummary(), System.Label.User_Activation_Failure);
        
        insert usrList;     
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserControllerTwo
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserControllerTwo() {        
        String mktIdKey = 'DE2';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('1234567', 'XZ1', 'Avon Leader', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '1234561';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('1234561', 'XZ1', 'Avon Leader', false);
        usrList.add(testUsrOne);
                
        User testUsrTwo = TestDataHelper.createUser('1234567', 'XZ2', 'Avon Leader', false);
        testUsrTwo.FederationIdentifier = marketOne.Market_Id__c + '1234567';
        testUsrTwo.Username = mktIdKey + '8' + '@avonpoc.com';
        testUsrTwo.MRKT_ID__c = mktIdKey;
        usrList.add(testUsrTwo);
        
        insert usrList;
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 1);
        
        
        pageRef.getParameters().put('debug', '1');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlrOne = new ActivateUserController();
        ctlrOne.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 2);
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserControllerThree
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserControllerThree() {        
        String mktIdKey = 'DE3';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        marketOne.Is_ALMPLUS_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '1234567';
        testUsr.CDW_STS_CD__c = 'Active';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('1234567', 'XZ1', 'Avon Leader', false);
        usrList.add(testUsrOne);
        
        insert usrList;
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        //pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 1);
        
        pageRef.getParameters().put('debug', '1');
        pageRef.getParameters().put('pgId', '1234');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlrOne = new ActivateUserController();
        ctlrOne.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 2);
        
        //Update Test User : Set User as Inactive
        System.runAs(testUsrOne) {
        	testUsr.isActive = false;
        	update testUsr;
        }
        
        ActivateUserController ctlrTwo = new ActivateUserController();
        ctlrTwo.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 2);
        
        //Update Test User : Set User.CDW_STS_CD__c as blank
        System.runAs(testUsrOne) {
        	testUsr.CDW_STS_CD__c = '';
        	update testUsr;
        }
        
        ActivateUserController ctlrThree = new ActivateUserController();
        ctlrThree.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 2);
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserControllerFour
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserControllerFour() {        
        String mktIdKey = 'DE4';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(false);
        almGlobal.Real_Time_Activation_Enabled__c = true;
        insert almGlobal;
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        marketOne.Is_ALMPLUS_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Leader', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '1234567';
        testUsr.CDW_STS_CD__c = 'Active';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('1234567', 'XZ1', 'Avon Leader', false);
        usrList.add(testUsrOne);
        
        insert usrList;
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        pageRef.getParameters().put('debug', '1');
        pageRef.getParameters().put('pgId', '1234');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlrOne = new ActivateUserController();
        ctlrOne.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        //Update Test User : Set User as Inactive
        System.runAs(testUsrOne) {
        	testUsr.isActive = false;
        	update testUsr;
        }
        
        ActivateUserController ctlrTwo = new ActivateUserController();
        ctlrTwo.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 2);
        
        //Update Test User : Set User.CDW_STS_CD__c as blank
        System.runAs(testUsrOne) {
        	testUsr.CDW_STS_CD__c = '';
        	update testUsr;
        }
        
        ActivateUserController ctlrThree = new ActivateUserController();
        ctlrThree.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 3);
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserControllerFive (Profile: Zone)
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserControllerFive() {        
        String mktIdKey = 'DE5';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        marketOne.Is_ALMPLUS_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '1234567';
        testUsr.CDW_STS_CD__c = 'Active';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('1234567', 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        usrList.add(testUsrOne);
        
        insert usrList;
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        pageRef.getParameters().put('debug', '1');
        pageRef.getParameters().put('pgId', '1234');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlrOne = new ActivateUserController();
        ctlrOne.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        //Update Test User : Set User as Inactive
        System.runAs(testUsrOne) {
        	testUsr.isActive = false;
        	update testUsr;
        }
        
        ActivateUserController ctlrTwo = new ActivateUserController();
        ctlrTwo.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 1);
        
        //Update Test User : Set User.CDW_STS_CD__c as blank
        System.runAs(testUsrOne) {
        	testUsr.CDW_STS_CD__c = '';
        	update testUsr;
        }
        
        ActivateUserController ctlrThree = new ActivateUserController();
        ctlrThree.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 3);
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testActivateUserControllerSix (Profile: Division)
    // Description  : Method for Test Coverage of Class : ActivateUserController
    //----------------------------------------------------------------------------  
    public static testmethod void testActivateUserControllerSix() {        
        String mktIdKey = 'DE5';
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create market
        Market__c marketOne = TestDataHelper.createMarket(mktIdKey, false);
        marketOne.ASLF_Market_Id__c = marketOne.Market_Id__c;
        marketOne.Is_ALMPLUS_Enabled__c = true;
        insert marketOne;
        
        //Create User
        List <User> usrList = new List <User>();
        User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Mkt 62 Division Manager', false);
        testUsr.FederationIdentifier = marketOne.Market_Id__c + '1234567';
        testUsr.CDW_STS_CD__c = 'Active';
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        User testUsrOne = TestDataHelper.createUser('1234567', 'XZ1', 'Avon Mkt 62 Division Manager', false);
        usrList.add(testUsrOne);
        
        insert usrList;
        
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put('langcd', 'en_US');
        pageRef.getParameters().put('acctnbr', testUsrOne.ACCT_NR__c);
        pageRef.getParameters().put('mktcd', marketOne.Market_Id__c);
        String dateStr = System.now().format('MM/dd/yyyy');
        
        String SHARED_SECRET = almGlobal.Shared_Secret__c;           
        String toHash = marketOne.Market_Id__c + testUsrOne.ACCT_NR__c + dateStr + SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put('key', EncodingUtil.convertToHex(hash));
        
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List <ApexPages.Message> msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        pageRef.getParameters().put('debug', '1');
        pageRef.getParameters().put('pgId', '1234');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlrOne = new ActivateUserController();
        ctlrOne.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 0);
        
        //Update Test User : Set User as Inactive
        System.runAs(testUsrOne) {
        	testUsr.isActive = false;
        	update testUsr;
        }
        
        ActivateUserController ctlrTwo = new ActivateUserController();
        ctlrTwo.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 1);
        
        //Update Test User : Set User.CDW_STS_CD__c as blank
        System.runAs(testUsrOne) {
        	testUsr.CDW_STS_CD__c = '';
        	update testUsr;
        }
        
        ActivateUserController ctlrThree = new ActivateUserController();
        ctlrThree.activateALMAccess();
        msgs = ApexPages.getMessages();
        System.assertEquals(msgs.size(), 3);
    }
}