/***************************************************************************
 Name         : Test_ErrorHandler
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for ErrorHandler
 Created Date : Oct. 25, 2013                
****************************************************************************/

@isTest
private class Test_ErrorHandler {
	
	//----------------------------------------------------------------------------
    // Method Name  : testErrorHandler
    // Description  : Method for Test Coverage of Class : ErrorHandler
    //----------------------------------------------------------------------------  
    public static testmethod void testErrorHandler() {
    	String mktIdKey = '123456';	
    	User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);
        Test.setCurrentPageReference(new Pagereference('/apex/MyBusiness'));
        System.runAs(testUsr) {
	        PageReference pageRef = ErrorHandler.handleError(new TestException('Test Error'));
	        PageReference pageRefMsg = ErrorHandler.handleError('/apex/LeaderPageTemplate', new TestException());
	        List <Error_Message__c> msg = [select Id, Error_Message__c, Page_Occurred__c from Error_message__c];
	        for (Error_Message__c err : msg) {
	        	if (err.Page_Occurred__c == '/apex/MyBusiness') {
	        		System.assert(err.Error_Message__c == 'Test Error');
	        		System.assert(pageRef.getUrl() == '/apex/ErrorPage?errId=UNKNOWN-ERROR');
	        		System.assert(pageRefMsg.getUrl() == '/apex/ErrorPage?errId=UNKNOWN-ERROR');
	        	}
	        }
	        String errChk = ErrorHandler.handleError('null');
	        System.assert(errChk == 'UNKNOWN-ERROR');
	        msg.clear();
	        String errChk2 =ErrorHandler.handleError('User Not Found');
	        if (msg.size() > 1) {
	        	System.debug('Code Not Working');
	        } else if (msg.size() == 1) {
	        	System.assert(msg[0].Error_Message__c == 'User Not Found');
	        }
        }    	
    }
    
    public class TestException extends Exception { 
    
    }

}