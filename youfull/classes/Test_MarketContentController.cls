/***************************************************************************
 Name         : Test_MarketContentController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for MarketContentController
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_MarketContentController {
   
    //---------------------------------------------------------------------------
    // Method Name  : testSaveMarketContent
    // Description  : Method for Test Coverage of method : saveContent()
    //---------------------------------------------------------------------------
    public static testmethod void testSaveMarketContent(){
        String mktIdKey = 'TEST123456';
        Market__c mkt = TestDataHelper.createMarket(mktIdKey, true);       
        Market_Content__c mktContent = TestDataHelper.createMarketContent(mkt.id, true);
        
        ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
        PageReference pageRef = stdCtlr.edit();
        pageRef.getParameters().put('id', mktContent.Id);        
        MarketContentController ctlr = new MarketContentController(stdCtlr);
        ctlr.saveContent();
        System.assertEquals(ApexPages.getMessages().size(),0);
        mktContent.ALM_Page_Id__c=null;
        pageRef = ctlr.saveContent();
        System.assertEquals(ApexPages.getMessages().size(),1);  
        mktContent.ALM_Page_Id__c='';
        pageRef = ctlr.saveContent();
        System.assertEquals(ApexPages.getMessages().size(),1);  
        ctlr = new MarketContentController(stdCtlr);
        pageRef = stdCtlr.edit();
    }

	//---------------------------------------------------------------------------
    // Method Name  : testViewMarketContent
    // Description  : Method for Test Coverage of method : viewContent()
    //---------------------------------------------------------------------------
    public static testmethod void testViewMarketContent(){
        String mktIdKey = 'test123';
        User ldrUser;
        Market__c mkt;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
        	ldrUser = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);
	        mkt = TestDataHelper.createMarket(mktIdKey, false);
	        mkt.Is_ALMPLUS_Enabled__c=true;
	        insert mkt;	        
        }
             
        Market_Content__c mktContent = TestDataHelper.createMarketContent(mkt.id, false);
        mktContent.Title_Levels__c = '1';       
        insert mktContent;
        
        //Added by Milon
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Help');
            pageRef.getParameters().put('pgId','1');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Content__c,'Test data');
            pageRef = ctlr.gotoHomeTab();
            //System.assert(pageRef.getUrl()=='/apex/almhome?pgId=1');
        }
        System.debug('Market__c=mkt.Id'+mkt.Id);
        System.debug('Market__c=mkt.Id'+mkt.Market_Id__c);
        mktContent = new Market_Content__c( Name='Test Link',Market__c=mkt.Id,
                        Type__c='Terms and Conditions',Title_Levels__c='All',
                        User_Type__c='All',
                        Content_Type__c='Link',Content__c='http://www.google.com');                                                         
        insert mktContent;
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().clear();
            pageRef.getParameters().put('type','Terms and Conditions');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Content__c,'http://www.google.com');
            System.assertEquals(ctlr.IsError,false);
            pageRef.getParameters().clear();
            pageRef.getParameters().put('type','Terms_and_Conditions');
            Test.setCurrentPageReference(pageRef);
            ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.IsError,true);
        }
        //Added by Milon
      /*  mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        zoneUsr.LDRSHP_TITL_LVL_NBR__c = '1';
        update zoneUsr;
        System.runAs(zoneUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            pageRef = ctlr.gotoHomeTab();
            //System.assert(pageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');
        }*/
    }

    //---------------------------------------------------------------------------
    // Method Name  : testSplashPage
    // Description  : Method for Test Coverage of method : getSplashPage()
    //---------------------------------------------------------------------------
    public static testmethod void testSplashPage(){
        String mktIdKey = 'test123';
        User ldrUser;
        Market__c mkt;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
        	ldrUser = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);
	        mkt = TestDataHelper.createMarket(mktIdKey, false);
	        mkt.Is_ALMPLUS_Enabled__c=true;
	        insert mkt;	        
        }
                     
        // Create ALMGlobalSetting, account and contact for user
	    ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
       	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact ldrContact = TestDataHelper.createContact(mktIdKey, account.Id, true);
        //Contact ct = testData.createContact('test123', ldrUser.Id);//Changed from Userinfo.getUserId to ldrUser.Id
       // User zoneUsr = testData.createZoneUser('123456');
      //  User divUsr = testData.createDivUser('D123456');
        User mktAdmin = TestDataHelper.createUser('MKTADMIN','XZ1','Avon Market Administrator', true);
        
        List<Market_Content__c> toInsrt = new List<Market_Content__c>();
        Market_Content__c mktContent = TestDataHelper.createMarketContent(mkt.id, false);
        mktContent.Name = 'All Users';
        mktContent.Type__c = 'Splash Page';      
        toInsrt.add(mktContent);
        mktContent = TestDataHelper.createMarketContent(mkt.id, false);
        mktContent.Name = 'All Leaders';
        mktContent.Type__c = 'Splash Page';
        mktContent.User_Type__c = 'Avon Leader';       
        toInsrt.add(mktContent);
		mktContent = TestDataHelper.createMarketContent(mkt.id, false);
        mktContent.Name = 'Title Level 1';
        mktContent.Type__c = 'Splash Page';
        mktContent.User_Type__c = 'Avon Leader';
        mktContent.Title_Levels__c = '1';      
        toInsrt.add(mktContent);
        insert toInsrt;
        
        //Added by Milon
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type', 'Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'Title Level 1');
            ctlr.getOmniturePageName();
        }
        
        //Added by Milon
       /* mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        System.runAs(zoneUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'Zone Manager');
        }
        
        //Added by Milon
        mkt.OwnerId = divUsr.Id;
        update  mkt;
        System.runAs(divUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'All Users');
        }*/
        //Added by Milon
       // mkt.OwnerId = mktAdmin.Id;
        //update  mkt;
        System.runAs(mktAdmin){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            PageReference retPageRef = ctlr.viewContent();
            System.assert(ctlr.mktContent==null);
            //System.assert(retPageRef.getUrl()=='/home/home.jsp');
        }
    }
    
	//---------------------------------------------------------------------------
    // Method Name  : testALMPlusSplashPage
    // Description  : Method for Test Coverage of method : getSplashPage()
    //---------------------------------------------------------------------------
    public static testmethod void testALMPlusSplashPage(){
        String mktIdKey = 'test123';
        User ldrUser;
        Market__c mkt;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
        	ldrUser = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);
	        mkt = TestDataHelper.createMarket(mktIdKey, false);
	        mkt.Is_ALMPLUS_Enabled__c=true;
	        insert mkt;	        
        }
        
        // Create ALMGlobalSetting, account and contact for user
	    ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
       	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact ldrContact = TestDataHelper.createContact(mktIdKey, account.Id, true);
      //  User zoneUsr = testData.createZoneUser('123456');
      //  User divUsr = testData.createDivUser('D123456');
        User mktAdmin = TestDataHelper.createUser('MKTADMIN','XZ1','Avon Market Administrator', true);
        
        
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        
        List<Market_Content__c> toInsrt = new List<Market_Content__c>();
        Market_Content__c mktContent = new Market_Content__c(   Name='All Users',Market__c=mkt.Id,Type__c='Splash Page',
                                                            Content_Type__c='HTML',Content__c='Test data',
                                                            User_Type__c='All');
        toInsrt.add(mktContent);
        mktContent = new Market_Content__c( Name='All Leaders',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Leader',Title_Levels__c='All');      
        toInsrt.add(mktContent);

        mktContent = new Market_Content__c( Name='Title Level 1',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Leader',Title_Levels__c=ldrUser.LDRSHP_TITL_LVL_NBR__c);      
        toInsrt.add(mktContent);

       /* mktContent = new Market_Content__c( Name='Zone Manager',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Zone Manager');      
        toInsrt.add(mktContent);*/
        insert toInsrt;
        //Creating User login param record to be created
        List<User_Login_Param__c> ulpLst = new List<User_Login_Param__c>();
        User_Login_Param__c testULP1 = new User_Login_Param__c(User_Id__c=ldrUser.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=ldrUser.Id); 
      //  User_Login_Param__c testULP2 = new User_Login_Param__c(User_Id__c=zoneUsr.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=zoneUsr.Id); 
        ulpLst.add(testULP1);
      //  ulpLst.add(testULP2);
        insert ulpLst;
         //Added by Milon
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            //System.assertEquals(ctlr.mktContent.Name,'Title Level 1');
            PageReference retPageRef = ctlr.gotoHomeTab();
            System.debug('&&&&&&&&&&&&&&&&&& '+retPageRef.getUrl());
            ctlr.getOmniturePageName();
            //System.assert(retPageRef.getUrl()=='/apex/MyLeads?pgId=40');    
        }
         //Added by Milon
       /* mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        System.runAs(zoneUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'Zone Manager');
            PageReference retPageRef = ctlr.gotoHomeTab();
            System.debug('&&&&&&&&&&&&&&&&&& '+retPageRef.getUrl());
            //System.assert(retPageRef.getUrl()=='/apex/MyLeads?pgId=40');
        }
        //Added by Milon
        mkt.OwnerId = divUsr.Id;
        update  mkt;
        System.runAs(divUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'All Users');
            PageReference retPageRef = ctlr.gotoHomeTab();
            System.debug('&&&&&&&&&&&&&&&&&& '+retPageRef.getUrl());
            //System.assert(retPageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');
        }*/
        
        System.runAs(mktAdmin){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            PageReference retPageRef = ctlr.viewContent();
            System.assert(ctlr.mktContent==null);
            //System.assert(retPageRef.getUrl()=='/home/home.jsp');
        }
    }
}