/***************************************************************************
 Name         : Test_HomePageController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for HomePageController
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_HomePageController {

    //---------------------------------------------------------------------------
    // Method Name  : testHomePage
    // Description  : Method for Test Coverage of Class : HomePageController
    //---------------------------------------------------------------------------
	public static testmethod void testHomePage(){
	    HomePageController ctlr = new HomePageController();
	    String mktIdKey = 'TEST123456';	
	    
	    // Create users    
	    List<User> usrLst = new List<User>();	    
	    User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);   
	    usrLst.add(testUsr);    
        User zoneUsr = TestDataHelper.createUser('Z'+mktIdKey, 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        usrLst.add(zoneUsr);
	    User divUsr = TestDataHelper.createUser('D'+mktIdKey, 'XZ1', 'Avon Mkt 62 Division Manager', false);
	    usrLst.add(divUsr);
	    insert usrLst;
        	    
        System.runAs(testUsr){
	        
	        // Create ALMGlobalSetting, account and contact for user
	        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    	Contact ldrContact = TestDataHelper.createContact(mktIdKey, account.Id, true);
			
			// Update Users  
		    testUsr.LDRSHP_TITL_LVL_NBR__c = '1';
		    zoneUsr.LDRSHP_TITL_LVL_NBR__c = '1';
		    divUsr.LDRSHP_TITL_LVL_NBR__c = '1';
		    update testUsr;
		    update zoneUsr;
		    update divUsr;
	    	
	    	// Create Market
		    Market__c market = TestDataHelper.createMarket(mktIdKey, false);
		    market.Splash_page_Enabled__c=true;
		    market.OwnerId = testUsr.Id;
		    insert market;
		    
		    // Assert when Splash_page_Enabled__c = true		    
	      	PageReference pageRef = ctlr.init();	      	   
	      	System.assert(pageRef.getUrl()=='/apex/showmarketdocument?type=Splash+Page'); 
	      	
	      	// Update Market	      	
	    	market.Site_Maintenance_Enabled__c=true;
	    	update market;
	    	
	    	// Assert when Site_Maintenance_Enabled__c = true		
	      	pageRef = ctlr.init();
	      	System.assert(pageRef.getUrl()=='/apex/showmarketdocument?type=Site+Maintenance');
		}
    }
  
	//---------------------------------------------------------------------------
    // Method Name  : testHomePage
    // Description  : Method for Test Coverage of Class : HomePageController
    //---------------------------------------------------------------------------
  	public static testmethod void testALMPlusHomePage(){
	    String mktIdKey = 'TEST123456';
	    List<User> usrLst = new List<User>();
	    
	    // Create users
	    User testLdrUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
        usrLst.add(testLdrUsr);
	    User zoneUsr = TestDataHelper.createUser('Z'+mktIdKey, 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        usrLst.add(zoneUsr);
	    User divUsr = TestDataHelper.createUser('D'+mktIdKey, 'XZ1', 'Avon Mkt 62 Division Manager', false);
	    usrLst.add(divUsr);
	    insert usrLst;
	    
	    //Creating User login param record to be created upon click GI_3 Link
	    List<User_Login_Param__c> ulpLst = new List<User_Login_Param__c>();
	    User_Login_Param__c testULP1 = new User_Login_Param__c(User_Id__c=testLdrUsr.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=testLdrUsr.Id); 
	    User_Login_Param__c testULP2 = new User_Login_Param__c(User_Id__c=zoneUsr.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=zoneUsr.Id); 
	    ulpLst.add(testULP1);
	    ulpLst.add(testULP2);
	    insert ulpLst;
        
	    //Added by milon
	    testLdrUsr.LDRSHP_TITL_LVL_NBR__c = '1';
	    divUsr.LDRSHP_TITL_LVL_NBR__c = '1';
	    update testLdrUsr;
	    update divUsr;
	    //Milon addition end
	    
	    // Test with Avon Leader
	    HomePageController ctlrAlmpLdr = new HomePageController();
	    System.runAs(testLdrUsr){
	    	
	    	// Create ALMGlobalSetting, account and contact for user
	    	ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    	Contact ldrContact = TestDataHelper.createContact(mktIdKey, account.Id, true);
	    	
	    	// Create Market
		    Market__c market = TestDataHelper.createMarket(mktIdKey, false);	   
		    market.Is_ALMPLUS_Enabled__c=true;
		    market.Splash_page_Enabled__c=false;
		    market.OwnerId = testLdrUsr.Id;		    
	    	insert market;
	   
	   		// Assert for page url
	   		PageReference pageRef = ctlrAlmpLdr.init();
	      	System.assert(pageRef.getUrl()=='/apex/MyLeads?pgId=40'); 
	    }
	    	    
	    //Testing for Widget login
	    HomePageController ctlrAlmpLdrWid = new HomePageController();
	    testULP1.Is_Widget__c=true; 
	    update testULP1;
	    
	    system.runAs(testLdrUsr){
	      PageReference pageRef = ctlrAlmpLdrWid.init();
	      System.debug('!!!!!!!!!!!!!!!!!!!! '+pageRef.getUrl());
	      System.assert(pageRef.getUrl()=='/apex/MyLeads?pgId=40');
	    }
	    
	    User_Login_Param__c testULPWid2 = new User_Login_Param__c(User_Id__c=testLdrUsr.Id, 
	    								Report_Id__c='XX20', 
	    								Page_Id__c='40', 
	    								Is_My_Lead__c=false, 
	    								ownerId=testLdrUsr.Id); 
	    insert testULPWid2;	    
	    system.runAs(testLdrUsr){
	      PageReference pageRef = ctlrAlmpLdrWid.init();
	      System.debug('!!!!!!!!!!!!!!!!!!!! '+pageRef.getUrl());
	      //System.assert(pageRef.getUrl()=='/apex/ALMReports?pgId=101&retPgId=1&rptId=XX20');
	    }
  	}
}