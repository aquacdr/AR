/***************************************************************************
 Name         : Test_SiteMapController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for SiteMapController
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_SiteMapController {

	//---------------------------------------------------------------------------
    // Method Name  : testSiteMapController
    // Description  : Method for Test Coverage of Class : SiteMapController
    //---------------------------------------------------------------------------
    public static testmethod void testSiteMapController(){
    	String mktIdKey = 'test123'; 
    	 
    	List<User> usrLst = new List<User>();	    
	    User ldrUser = TestDataHelper.createUser('1234501', 'XZ1', 'Avon Leader', false); 
	    ldrUser.MRKT_ID__c = mktIdKey;  
	    usrLst.add(ldrUser);    
        User zoneUsr = TestDataHelper.createUser('1234502', 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        zoneUsr.MRKT_ID__c = '123456';
        usrLst.add(zoneUsr);
	    User divUsr = TestDataHelper.createUser('1234503', 'XZ1', 'Avon Mkt 62 Division Manager', false);
	    divUsr.MRKT_ID__c = 'D123456';
	    usrLst.add(divUsr);
	    insert usrLst;   
	      
        Market__c mkt = TestDataHelper.createMarket(mktIdKey, true);
       
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);       
       	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact ct = TestDataHelper.createContact(mktIdKey, account.Id, true);
	    
        createMarketMenuData(mkt);                                             
                                
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        System.runAs(ldrUser){
            String subMenu = '<div class="border_adj"><ul class="submenu">'+
            '<li><a href="\\AUS1">My Coaching Record</a></li><li>'+
            '<a href="\\AUS2">My Business Plan</a></li><li>'+
            '<a href="\\AUS3">My Earnings Statement</a><ul class="nav">'+
            '<li><a href="\\AUSS1">My New Representatives</a>'+
            '</li></ul></li></ul></div>';
            PageReference pageRef = new PageReference('\\AU');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.Name,'MY DASHBOARD');
            System.assertEquals(ctlr.col2.Name,'MY BUSINESS');
            System.assertEquals(ctlr.col3.Name,'MY DOWNLINE');
            System.assertEquals(ctlr.col4.Name,'eTOOLS');
            if (ctlr.col1Sub != null){
                System.assertNotEquals(ctlr.getcol1SubString().value, null);
            }
            System.assertEquals(ctlr.getcol2SubString().value,null);
            System.assertNotEquals(ctlr.getcol3SubString().value,null);
            System.assertNotEquals(ctlr.getcol4SubString().value,null);
            //ctlr.getInitialize();
        }
        
        mkt.OwnerId = zoneUsr.Id;
        mkt.Market_Id__c = '123456';
        update  mkt;
        System.runAs(zoneUsr){
            PageReference pageRef = new PageReference('\\AU3');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.Name,'MY DASHBOARD');
            System.assertEquals(ctlr.col2.Name,'MY BUSINESS');
            System.assertEquals(ctlr.col3.Name,'MY DOWNLINE');
            System.assertEquals(ctlr.col4.Name,'eTOOLS');
        }
        
        mkt.OwnerId = divUsr.Id;
        mkt.Market_Id__c = 'D123456';
        update  mkt;
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\AU4');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.Name,'MY DASHBOARD');
            System.assertEquals(ctlr.col2.Name,'MY BUSINESS');
            System.assertEquals(ctlr.col3.Name,'MY DOWNLINE');
            System.assertEquals(ctlr.col4.Name,'eTOOLS');
        }
        
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\ADM');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col2.isSelected,true);
        }
        
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\AUS1');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.isSelected,true);
        }
        
        //Testing impersonate
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\AUS1');
            pageRef.getParameters().put('impersonate','1');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.currentUserId,divUsr.ACCT_NR__c);
        }
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : testImpersonate
    // Description  : Method for Test Coverage of Class : SiteMapController
    //---------------------------------------------------------------------------
    public static testmethod void testImpersonate(){
        User ldrUser = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);   
	    ldrUser.MRKT_ID__c = 'test123'; 
	    insert ldrUser;
	    
	    Market__c mkt = TestDataHelper.createMarket('test123', true);
               
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);       
       	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact ct = TestDataHelper.createContact('1234', account.Id, true);  
                
        ApexPages.currentPage().getParameters().put('impersonate','1');
        System.runAs(ldrUser){
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.currentUserId,ldrUser.ACCT_NR__c);
        }
    
    } // End of test impersonate
    
    
    // Method creates Market Menu test data
    private static void createMarketMenuData(Market__c mkt){
    	List<Market_Menu__c> toInsrt = new List<Market_Menu__c>();
    	        
        toInsrt.add(TestDataHelper.createMarketMenu('MY DASHBOARD', '\\AU',
                        mkt.Id, '1', '1', 'All', 'All', null, false));        
        toInsrt.add(TestDataHelper.createMarketMenu('MY BUSINESS', '\\AL',
                        mkt.Id, '1', '2', 'All', 'Avon Leader', null, false));
        toInsrt.add(TestDataHelper.createMarketMenu('MY BUSINESS', '\\AZM',
                        mkt.Id, '1', '2', 'All', 'Avon Mkt 62 Zone Manager', null, false));
        toInsrt.add(TestDataHelper.createMarketMenu('MY BUSINESS', '\\ADM',
                        mkt.Id, '1', '2', 'All', 'Avon Mkt 62 Division Manager', null, false));
        toInsrt.add(TestDataHelper.createMarketMenu('MY DOWNLINE', '\\AU3',
                        mkt.Id, '1', '3', 'All', 'All', null, false));
        toInsrt.add(TestDataHelper.createMarketMenu('eTOOLS', '\\AU4',
                        mkt.Id, '1', '4', 'All', 'All', null, false));
        
        insert toInsrt;
        
        //Creating the Sub Menu
        List<Market_Menu__c> toInsrtSub = new List<Market_Menu__c>();
        List<Market_Menu__c> parentMenu = [select ID from Market_Menu__c where 
                        Name='MY DASHBOARD' and Market__c = :mkt.Id];
                        
        
        toInsrtSub.add(TestDataHelper.createMarketMenu('My Coaching Record', '\\AUS1',
                        mkt.Id, '1', '1', 'All', 'All', parentMenu[0].ID, false));      
        toInsrtSub.add(TestDataHelper.createMarketMenu('My Business Plan', '\\AUS2',
                        mkt.Id, '1', '2', 'All', 'All', parentMenu[0].ID, false));
        toInsrtSub.add(TestDataHelper.createMarketMenu('My Earnings Statement', '\\AUS3',
                        mkt.Id, '1', '3', 'All', 'All', parentMenu[0].ID, false));
        insert toInsrtSub;  
        
         //Creating the Sub-Sub Menu    
        List<Market_Menu__c> parentSubMenu = [select ID from Market_Menu__c where 
                        Name='My Earnings Statement' and Market__c = :mkt.Id];
                        
        List<Market_Menu__c> toInsrtSubSub = new List<Market_Menu__c>();
        toInsrtSubSub.add(TestDataHelper.createMarketMenu('My New Representatives', '\\AUSS1',
                        mkt.Id, '1', '1', 'All', 'All', parentSubMenu[0].ID, false));
        insert toInsrtSubSub;     
        
         //Creating the Sub-Menu for eTool   
        List<Market_Menu__c> etSubMenu = [select ID from Market_Menu__c where 
                        Name='eTOOLS' and Market__c = :mkt.Id];
                        
        List<Market_Menu__c> etSubSub = new List<Market_Menu__c>();
        etSubSub.add(TestDataHelper.createMarketMenu('Earning Illustrator', '\\EL1',
                        mkt.Id, '1', '1', 'All', 'All', etSubMenu[0].ID, false));
        insert etSubSub;   
        
         //Creating the Sub-Menu for MY DOWNLINE   
        List<Market_Menu__c> mdSubMenu = [select ID from Market_Menu__c where 
                        Name='MY DOWNLINE' and Market__c = :mkt.Id];
                        
        List<Market_Menu__c> mdSubSub = new List<Market_Menu__c>();
        mdSubSub.add(TestDataHelper.createMarketMenu('My Reports', '\\MR1',
                        mkt.Id, '1', '1', 'All', 'All', mdSubMenu[0].ID, false));
        insert mdSubSub;                  
    }
}