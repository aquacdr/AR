/***************************************************************************
 Name          : Test_ALMUtils 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for ALMUtils
 Created Date  : Oct 30, 2013                
****************************************************************************/
@isTest
private class Test_ALMUtils {

	//---------------------------------------------------------------------------
    // Method Name  : testALMUtils
    // Description  : Method for Test Coverage for ALMUtils.getFieldValue()
    //---------------------------------------------------------------------------
    public static testmethod void testALMUtils(){
           
        String demoMktCode = 'DE';
        String currentCmpgn = '201204';
        String uplineAcctNr = 'upln1';
       
        // Create test data
        User testUsr = TestDataHelper.createUser(uplineAcctNr, 'XZ1', 'Avon Leader', true);     
        Market__c mkt = TestDataHelper.createMarket(demoMktCode, true);
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true); 
        Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact con1 = TestDataHelper.createContact(uplineAcctNr, testAcct.Id, true);       
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(con1.Id, mkt, uplineAcctNr, true);
       
        String flds1 = '(AVG_GENRTN_3_UNIT_COMM_PCT__c - AVG_GENRTN_3_DISTR_SLS_PCT__c)';
        String flds2 = '(AVG_GENRTN_3_UNIT_COMM_PCT__c % AVG_GENRTN_3_DISTR_SLS_PCT__c)';    
        String flds3 = '(AVG_GENRTN_3_UNIT_COMM_PCT__c / AVG_GENRTN_3_DISTR_SLS_PCT__c,AVG_GENRTN_2_UNIT_COMM_PCT__c)';  
        List<ALM_Rep_Performance_1__c> ppList = [SELECT Id, AVG_GENRTN_3_UNIT_COMM_PCT__c, 
        						AVG_GENRTN_3_DISTR_SLS_PCT__c, AVG_GENRTN_2_UNIT_COMM_PCT__c 
        										FROM ALM_Rep_Performance_1__c
                                                WHERE ACCT_NR__c IN (:uplineAcctNr)];
        System.runAs(testUsr){
            Decimal d = ALMUtils.getFieldValue(flds1,ppList[0],ppList[0]);
            d = ALMUtils.getFieldValue(flds2,ppList[0],ppList[0]);
            d = ALMUtils.getFieldValue(flds3,ppList[0],ppList[0]);
            system.assert(d != null);
        }    
     }
}