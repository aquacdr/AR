/***************************************************************************
 Name         : Test_ChangePasswordController 
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for ChangePasswordController
 Created Date : Oct. 25, 2013                
****************************************************************************/

@IsTest
private class Test_ChangePasswordController {
	
	//----------------------------------------------------------------------------
    // Method Name  : TestChangePasswordController
    // Description  : Method for Test Coverage of Class : ChangePasswordController
    //----------------------------------------------------------------------------
	public static testmethod void TestChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(), null);                           
    }

}