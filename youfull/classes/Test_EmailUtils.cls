/***************************************************************************
 Name         : Test_EmailUtils
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for EmailUtils
 Created Date : Oct. 25, 2013                
****************************************************************************/
@isTest
private class Test_EmailUtils {
	
	//----------------------------------------------------------------------------
    // Method Name  : testEmailUtils
    // Description  : Method for Test Coverage of Class : EmailUtils
    //----------------------------------------------------------------------------  
    public static testmethod void testEmailUtils() {
    	Account acct;
    	Contact con;
    	
    	User testUsr = TestDataHelper.createUser('1234', 'EU1', 'Avon Leader', true);
    	
    	//Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
    	
    	EmailTemplate template;
    	System.runAs(testUsr) {
    			template = TestDataHelper.createEmailTemplate(UserInfo.getUserId(), true);
    	}
    	
    	if (template != null) {
		    almGlobal.Personal_Email_Template_Id__c = template.Id;
		    update almGlobal;
    	}
		
		System.runAs(testUsr) {
		    acct = TestDataHelper.createAccount('Test Account EMailUtil', 'USD', true);   
			con = TestDataHelper.createContact('1234', acct.Id, true);
		}	    	
		
		if (template != null) {
	    	List <String> contactString = new List <String>();
        	List <Id> contactIds = new List <Id>();
        
        	contactIds.add(con.Id);
        	contactString.add(con.MRKT_ACCT_KEY__c);
	        	
        	EmailUtils.sendFreeFormEmail(contactString, 'Test', 'Test Mail Details');
        	
        	con.Email = '';
        	update con;
        	
        	List <String> contactWithoutEmail = new List <String>();
        	contactWithoutEmail.add(con.MRKT_ACCT_KEY__c);
        	EmailUtils.sendFreeFormEmail(contactWithoutEmail, 'Test 1', 'Test Mail Details 1');
        	
        	List <Id> errIds = EmailUtils.sendEmail(contactIds, template.Id);
    		List <Id> errIds1 = EmailUtils.sendEmail(contactIds, template.Id, 'test@avon.com');
    	
    		EmailUtils.sendEmail(contactString, template.Id);
    		EmailUtils.sendEmail(contactWithoutEmail,template.Id);
    	
    		errIds = EmailUtils.sendEmail(new List <User> {testUsr}, template.Id, testUsr.GI3_Email__c, testUsr.Name);
        	System.assert(errIds.size() == 0);
        	errIds = EmailUtils.sendEmail(new List <User> {testUsr}, template.Id, null, null);
    	
    		String[] tos = new String[] {'avon@avon.com'};
    		Boolean b = EmailUtils.sendEmail('Avon@avon.com', true, tos, tos, tos, 'avon@avon.com', 'Hi','Hi', true, false, String.valueOf(template.Id), con.Id, con.Id, false);
    		}
	}
}