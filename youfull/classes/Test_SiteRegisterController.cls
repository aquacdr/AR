/***************************************************************************
 Name          : Test_SiteRegisterController 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for SiteRegisterController
 Created Date  : Nov 9, 2013                
****************************************************************************/
@IsTest 
private class Test_SiteRegisterController {
	
	//---------------------------------------------------------------------------
    // Method Name  : testRegistration
    // Description  : Method for Test Coverage for SiteRegisterController
    //---------------------------------------------------------------------------
    static testMethod void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }
}