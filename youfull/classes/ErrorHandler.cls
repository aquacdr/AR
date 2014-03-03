public class ErrorHandler {
	
    //subhamay 112011
    public static String handleError(String errorMessage){
    	String errPg = ApexPages.currentPage().getUrl();
        Error_Message__c err = new Error_Message__c(Page_Occurred__c = errPg, Error_Message__c = errorMessage);       
        String errorId = insertError(err);
		return errorId;
    }
    //subhamay 112011
    
    public static PageReference handleError(Exception ex){
        Error_Message__c err = new Error_Message__c();
        err.Page_Occurred__c = ApexPages.currentPage().getUrl();
        err.Error_Message__c = ex.getMessage();
        
        String errorId = insertError(err);
        PageReference errPage = Page.ErrorPage;
        errPage.getParameters().put('errId', errorId);
        return errPage;
    }
    
    public static PageReference handleError(String srcPage,Exception ex){
        Error_Message__c err = new Error_Message__c(Page_Occurred__c = srcPage,
                                                    Error_Message__c = ex.getMessage());
        String errorId = insertError(err);
        PageReference errPage = Page.ErrorPage;
        errPage.getParameters().put('errId', errorId);
        return errPage;
    }
    
    private static String insertError(Error_Message__c errMsg){
        try{
        	insert errMsg;
            return errMsg.Id; 
        }catch(Exception ex){
            System.debug('\n Not able to insert error record !!!!');
            return 'UNKNOWN-ERROR';
        }   
    }
    
    //@T-214186 : Commented by Barkha Jain on Nov 21
    /*public static testmethod void testErrHandler(){
        TestDataHelper testData = new TestDataHelper();
        User testUsr = testData.createLeaderUser('123456');
        Test.setCurrentPageReference(new Pagereference('/apex/MyBusiness'));
        System.runAs(testUsr){
        PageReference pageRef = ErrorHandler.handleError(new TestException('Test Error'));
        PageReference pageRefMsg = ErrorHandler.handleError('/apex/LeaderPageTemplate', new TestException());
        List<Error_Message__c> msg = [select Id, Error_Message__c,Page_Occurred__c from Error_message__c]; // where createdbyId=:testUsr.Id];
        for(Error_Message__c err : msg){
        	if(err.Page_Occurred__c=='/apex/MyBusiness'){
        		System.assert(err.Error_Message__c=='Test Error');
        		System.assert(pageRef.getUrl()=='/apex/ErrorPage?errId=UNKNOWN-ERROR');
        		System.assert(pageRefMsg.getUrl()=='/apex/ErrorPage?errId=UNKNOWN-ERROR');
        	}
        }
        String errChk = ErrorHandler.insertError(null);
        System.assert(errChk=='UNKNOWN-ERROR');
        msg.clear();
        String errChk2 =ErrorHandler.handleError('User Not Found');
        if(msg.size()>1){
        	System.debug('Code Not Working');
        }else if(msg.size()==1){
        	System.assert(msg[0].Error_Message__c=='User Not Found');
        }
        }       
    } */
    
    public class TestException extends Exception{ }
}