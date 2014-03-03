/***************************************************************************
 Name         : Test_PersonalMessageController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for PersonalMessageController
 Created Date : Oct. 28, 2013                
****************************************************************************/

@isTest
private class Test_PersonalMessageController { 

    //----------------------------------------------------------------------------
    // Method Name  : testPersonalMessageController
    // Description  : Method for Test Coverage of Class : PersonalMessageController
    //----------------------------------------------------------------------------  
    public static testmethod void testPersonalMessageController() {
        String mktIdKey = 'TESTRC';
        
        //Create User
        User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);
        
        //Create Market__c
        Market__c marketOne;
        
        System.runAs(testUsr) {
            marketOne = TestDataHelper.createMarket(mktIdKey, false);
            marketOne.OwnerId = testUsr.Id;
            insert marketOne; 
        }
        
        PersonalMessageController ctlr = new PersonalMessageController();
        
        Test.startTest();
        System.runAs(testUsr) {
            ctlr.recpntId = 'alm@avon.com,myemail@avon.com';
            ctlr.persMsgSubj = 'Test Subject';
            ctlr.persMsgDetl = 'Test Details';
            ctlr.emailSelectedPersonalMsg();
            ctlr.getOmniturePageName();
            System.assertEquals(ctlr.sendSuccess, false);
        }
        Test.stopTest();
    }
}