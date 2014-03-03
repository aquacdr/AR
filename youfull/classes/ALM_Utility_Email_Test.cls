/***************************************************************************
 Name         : ALM_Utility_Email_Test
 Created By   : Barkha Jain
 Description  : Test class for ALM_Utility_Email
 Created Date : Feb 13, 2014                
****************************************************************************/
@isTest
private class ALM_Utility_Email_Test {
    
    //----------------------------------------------------------------------------
    // Method Name  : testEmailUtils
    // Description  : Method for Test Coverage of Class : ALM_Utility_Email
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
            
            //test sendFreeFormEmail method
            ALM_Utility_Email.sendFreeFormEmail(contactString, 'Test', 'Test Mail Details');
            
            con.Email = '';
            update con;
            
            List <String> contactWithoutEmail = new List <String>();
            contactWithoutEmail.add(con.MRKT_ACCT_KEY__c);
            ALM_Utility_Email.sendFreeFormEmail(contactWithoutEmail, 'Test 1', 'Test Mail Details 1');
            
            List<Id> errIds = ALM_Utility_Email.sendEmail(contactIds, template.Id);
            List<Id> errIds1 = ALM_Utility_Email.sendEmail(contactIds, template.Id, 'test@avon.com');
        
            ALM_Utility_Email.sendEmail(contactString, template.Id);
            ALM_Utility_Email.sendEmail(contactWithoutEmail, template.Id);
        
            errIds = ALM_Utility_Email.sendEmail(new List <User> {testUsr}, template.Id, testUsr.GI3_Email__c, testUsr.Name);
            //verify result
            system.assert(errIds.size() == 0);
            
            errIds = ALM_Utility_Email.sendEmail(new List <User> {testUsr}, template.Id, null, null);
        
            String[] tos = new String[] {'avon@avon.com'};
            Boolean b = ALM_Utility_Email.sendEmail('Avon@avon.com', true, tos, tos, tos, 'avon@avon.com', 'Hi','Hi', true, false, String.valueOf(template.Id), con.Id, con.Id, false);
            //verify result
            system.assert(b);
        }
    }

}