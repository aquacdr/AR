/***************************************************************************
 Name         : Test_ASLFReportsController 
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ASLFReportsController
 Created Date : Oct. 24, 2013                
****************************************************************************/
@isTest
private class Test_ASLFReportsController {
	
	//----------------------------------------------------------------------------
    // Method Name  : testASLFReports
    // Description  : Method for Test Coverage of Class : ASLFReportsController
    //----------------------------------------------------------------------------
	 public static testmethod void testASLFReports(){
      	Profile profile = [Select Id, Name from Profile where Name Like '%System Administrator%' limit 1];
      	//create test user
      	User user = TestDataHelper.createUser('1', profile.Id, false);
      	user.MRKT_ID__c = '1234';
      	insert user;
      	
      	//creting test market
        Market__c mrkt = TestDataHelper.createMarket('test market', '1234', false);
        Gi3_Language_Mapping__c g1LangMap1 = new Gi3_Language_Mapping__c(Name = 'en_PH', Gi3_Lang_code__c = 'en_US');
        insert g1LangMap1;
        
        System.runAs(user){
        	insert mrkt;        
	        
	        Test.startTest();
        	ASLFReportsController ctlr = new ASLFReportsController();
        	ctlr.getInitialize();
            Datetime currDt = System.now();
            Test.stopTest();
            
            //verify results
            system.assert(ctlr.dateStr == currDt.format('MM/dd/yyyy'));   
            system.assert(ctlr.usrLangCd == 'en_PH');            
        }   
    }

}