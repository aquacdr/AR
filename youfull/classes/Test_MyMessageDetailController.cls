/***************************************************************************
 Name          : Test_MyMessageDetailController 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for MyMessageDetailController
 Create Date   : Nov 1, 2013                
****************************************************************************/
@isTest
private class Test_MyMessageDetailController {

    //---------------------------------------------------------------------------
    // Method Name  : testMyMessageDetailController
    // Description  : Method for Test Coverage for MyMessageDetailController
    //---------------------------------------------------------------------------
	static testMethod void testMyMessageDetailController() {
   	
    	// Create leader user
        User ldrUsr = TestDataHelper.createUser('123456789z', 'XZ1', 'Avon Leader', true);
        
        // Create market
        Market__c mkt = TestDataHelper.createMarket('123456789z', false);
    	mkt.OwnerId = ldrUsr.Id;
    	insert mkt;
    	
    	// Create ecard History
    	List<ECard_History__c> eCardHistList = new List<ECard_History__c>();
    	ECard_History__c eCardHist = TestDataHelper.createEcardHistory(ldrUsr.Id, 'Test eCard', false);
    	eCardHist.Success__c = 'Name:Test1,Name:Test2';
    	eCardHistList.add(eCardHist);
        eCardHist = TestDataHelper.createEcardHistory(ldrUsr.Id, 'Test eCard', false);
        eCardHist.Failed__c = 'Phone:787878,Phone:787878';
    	eCardHistList.add(eCardHist);
        eCardHist = TestDataHelper.createEcardHistory(ldrUsr.Id, 'Test eCard', false);
        eCardHist.No_Email__c = 'eMail:Test@Test.com,Opted Out:Y';
    	eCardHistList.add(eCardHist);
    	insert eCardHistList;
    	
        Test.setCurrentPage(Page.MyMessage);
	    System.runAs(ldrUsr){
	    	
	    	// Assert for Success records  
	    	Apexpages.currentPage().getParameters().put('id', eCardHistList[0].id);
	    	ApexPages.StandardController con = new ApexPages.StandardController((sObject)eCardHistList[0]);      
	    	MyMessageDetailController controller = new MyMessageDetailController(con);
	    	controller.getOmniturePageName();
	    	System.assert(controller.l_get_SuccessResults.size() > 0);
	    	
	    	// Assert for Failure Records
	    	Apexpages.currentPage().getParameters().put('id', eCardHistList[1].id);
	    	con = new ApexPages.StandardController((sObject)eCardHistList[1]);      
	    	controller = new MyMessageDetailController(con);
	    	System.assert(controller.l_get_FailureResults.size() > 0);
	    	
	    	// Assert for No Email Records
	    	Apexpages.currentPage().getParameters().put('id', eCardHistList[2].id);
	    	con = new ApexPages.StandardController((sObject)eCardHistList[2]);      
	    	controller = new MyMessageDetailController(con);
	    	System.assert(controller.l_get_NoEmailResults.size() > 0);
	    	
	    }    
    }
}