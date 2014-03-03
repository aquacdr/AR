/***************************************************************************
 Name         : Test_ZM_CampaignFocusController
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_CampaignFocusController
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_ZM_CampaignFocusController {
	
	//----------------------------------------------------------------------------
    // Method Name  : testCampaignFocusController
    // Description  : Method for Test Coverage of Class : ZM_CampaignFocusController
    //----------------------------------------------------------------------------
    static testMethod void testCampaignFocusController() {
    	//create test ContentVersion
    	TestDataHelper.createContentVersion(true);
    	
        PageReference ref = Page.ZM_CampaignFocus;
        ref.getParameters().Put('source', '');
        ref.getParameters().Put('campaign', '62');
        Test.setCurrentPage(ref);
        
        Test.startTest();
        //test controller
        ZM_CampaignFocusController ctl = new ZM_CampaignFocusController();
        String pageName = ctl.getOmniturePageName();
        system.assertEquals('', pageName);
        
        ZM_CampaignFocusController.WrapperImageInfo x = new ZM_CampaignFocusController.WrapperImageInfo('x','y');
        /*
          XCEPTION_THROWN|[81]|System.DmlException: Insert failed. First exception on row 0; first error: FIELD_INTEGRITY_EXCEPTION, You cannot set custom fields or tags on a document published into a personal library. Fields set: Position,Url,Page: []
          22:25:09.320 (4320468000)|FATAL_ERROR|System.DmlException: Insert failed. First exception on row 0; first error: FIELD_INTEGRITY_EXCEPTION, You cannot set custom fields or tags on a document published into a personal library. Fields set: Position,Url,Page: []
        */
        Test.stopTest();
        
    }
}