/***************************************************************************
 Name          : Test_MyMessageController 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for MyMessageController
 Created Date   : Nov 1, 2013                
****************************************************************************/
@isTest
private class Test_MyMessageController {

	//---------------------------------------------------------------------------
    // Method Name  : testMyMessageController
    // Description  : Method for Test Coverage for MyMessageController
    //---------------------------------------------------------------------------
	static testMethod void testMyMessageController() {
   	
    	// Create leader user
        User ldrUsr = TestDataHelper.createUser('123456789z', 'XZ1', 'Avon Leader', true);
        
        // Create market
        Market__c mkt = TestDataHelper.createMarket('123456789z', false);
    	mkt.OwnerId = ldrUsr.Id;
    	insert mkt;
    	
    	// Create ecard History
    	TestDataHelper.createEcardHistory(ldrUsr.Id, 'Test eCard', true);
    	
        Test.setCurrentPage(Page.MyMessage);
	    System.runAs(ldrUsr){        
	    	MyMessageController controller = new MyMessageController();
	    	system.assert(controller.getECardHistories().size()==1);
	    	controller.callRepDetails();
	    	controller.getOmniturePageName();
	    }    
    }
    
}