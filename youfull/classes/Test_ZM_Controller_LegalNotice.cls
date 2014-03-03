/***************************************************************************
 Name         : Test_ZM_Controller_LegalNotice
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Controller_LegalNotice
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_ZM_Controller_LegalNotice {
	
	//----------------------------------------------------------------------------
    // Method Name  : testLegalNoticeController
    // Description  : Method for Test Coverage of Class : ZM_Controller_LegalNotice
    //----------------------------------------------------------------------------
    static testMethod void testLegalNoticeController() {
    	User u = TestDataHelper.createUser(null, null, 'System Administrator', true);
    	
    	Test.startTest();
    	system.runAs(u){
	        ZM_Controller_LegalNotice ctl = new ZM_Controller_LegalNotice();
			PageReference pg = ctl.returnToHomePage();
			system.assertEquals(null, pg);
			
			ctl.setUserViewedMessage();
			pg = ctl.returnToHomePage();
			system.assertNotEquals(null, pg);
			ctl.getOmniturePageName();
    	}
		Test.stopTest();
    }
}