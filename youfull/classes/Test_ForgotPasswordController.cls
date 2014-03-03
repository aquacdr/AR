/***************************************************************************
 Name         : Test_ForgotPasswordController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for ForgotPasswordController
 Created Date : Oct. 25, 2013                
****************************************************************************/

@isTest
private class Test_ForgotPasswordController {
	
	//----------------------------------------------------------------------------
    // Method Name  : testForgotPasswordController
    // Description  : Method for Test Coverage of Class : ForgotPasswordController
    //----------------------------------------------------------------------------  
    public static testmethod void testForgotPasswordController() {
    	Test.startTest();
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = 'test@salesforce.com';     	
    
    	System.assertEquals(controller.forgotPassword(), null);
    	Test.stopTest();
    }

}