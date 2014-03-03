/***************************************************************************
 Name         : Test_MyProfilePageController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for MyProfilePageController
 Created Date : Oct. 28, 2013                
****************************************************************************/

@isTest 
private class Test_MyProfilePageController {

	//----------------------------------------------------------------------------
    // Method Name  : testMyProfilePageController
    // Description  : Method for Test Coverage of Class : MyProfilePageController
    //----------------------------------------------------------------------------  
    public static testmethod void testMyProfilePageController() {
    	String mktIdKey = 'TESTPPC';
    	TestDataHelper.createALMGlobalSetting(true);
    	Account account = TestDataHelper.createAccount('Test Account PPC', 'USD', true);
    	Contact con = TestDataHelper.createContact(mktIdKey, account.Id, true); 
    	User usr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);
    	
    	//Create User
        //User testUsr = TestDataHelper.createSitePortalUser(mktIdKey, 'XZ1', 'Avon Leader', con.Id, true);
        
    	List <User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType = 'CustomerSuccess'];

        if (existingPortalUsers.isEmpty()) {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
            
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(currentUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            controller.edit();
            controller.cancel();            
            System.assert(Page.ChangePassword.getUrl().equals(controller.changePassword().getUrl()));           
            MyProfilePageController controllerOne = new MyProfilePageController();
           	controllerOne.save();
            controllerOne.getIsEdit();
           
            
        } else {
            User existingPortalUser = existingPortalUsers[0];
            String randFax = Math.rint(Math.random() * 1000) + '5551234';
            
            System.runAs(existingPortalUser) {
                MyProfilePageController controller = new MyProfilePageController();
                System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
                controller.edit();               
                controller.cancel();               
                controller.getUser().Fax = randFax;
                controller.save();
            }
            
            // verify that the user and contact were updated
            existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
            System.assert(existingPortalUser.fax == randFax);
            System.assert(existingPortalUser.Contact.fax == randFax);
        }
    }
}