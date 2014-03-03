/***************************************************************************
 Name         : Test_PersonalInfoConfig
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for MyPersonalInfoConfig
 Created Date : Nov. 07, 2013                
****************************************************************************/
@isTest
private class Test_PersonalInfoConfig {
	static String mrktId = '62';
	static List <Rep_Detail_Field__c> repDetailList;
	
	//----------------------------------------------------------------------------
    // Method Name  : testPersonalInfoConfig
    // Description  : Method for Test Coverage of Class : PersonalInfoConfig
    //----------------------------------------------------------------------------  
    public static testmethod void testPersonalInfoConfig() {
    	TestDataHelper.createALMGlobalSetting(true);
        //creating test user
        User usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = mrktId;
        usr.MRKT_ID_ACCT_NR_KEY__c = mrktId + '1234';
        insert usr;
        
        Market__c mkt = TestDataHelper.createMarket(mrktId, false);
        System.runAs(usr){
            mkt.Mail_Plan_Enabled__c = true;
            insert mkt;
        }
        
        Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
        Contact c = TestDataHelper.createContact('1234', acc.Id, false);
        c.MRKT_ACCT_KEY__c = mrktId + '1234';
        insert c;
        
    	ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', true);  
    	createRepDetailFields();
    	
    	Test.startTest();
        MarketLeaderTitleUtils ldrTitlUtils = new MarketLeaderTitleUtils();
        MarketSellerStsUtils sellStsUtils = new MarketSellerStsUtils();
        MarketTagUtils mktTags = new MarketTagUtils();
        
        //calling default constructor
        PersonalInfoConfig pic = new PersonalInfoConfig();
        
        //test cofig class for different Rep Detail Fields
        pic = new PersonalInfoConfig(rep, repDetailList[0], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[1], ldrTitlUtils, sellStsUtils, mktTags);
        
        repDetailList[1].Fields_To_Map__c = 'Upline:LDRSHP_TITL_LVL_NR__c,LDRSHP_LOA_NR__c';
        update repDetailList[1];
        pic = new PersonalInfoConfig(rep, repDetailList[1], ldrTitlUtils, sellStsUtils, mktTags);
        
        pic = new PersonalInfoConfig(rep, repDetailList[2], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[3], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[4], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[5], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[6], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[7], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[8], ldrTitlUtils, sellStsUtils, mktTags);
        pic = new PersonalInfoConfig(rep, repDetailList[9], ldrTitlUtils, sellStsUtils, mktTags);
        try{
        	pic = new PersonalInfoConfig(rep, repDetailList[10], ldrTitlUtils, sellStsUtils, mktTags);
        }catch(Exception e){}
        
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method to create Rep_Detail_Field__c records
    //----------------------------------------------------------------------------
    static void createRepDetailFields(){
    	//Create Object: Rep_Detail_Field__c
        repDetailList = new List <Rep_Detail_Field__c>();
        repDetailList.add(TestDataHelper.createRepDetailField('Badge Title', false));
        
        repDetailList.add(TestDataHelper.createRepDetailField('Current President Club Status', false));
        repDetailList[1].Fields_To_Map__c = 'Mail_Plan:test\\.CreatedDate';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Detail Field 3', false));
        repDetailList[2].Fields_To_Map__c = 'SalesOrg:CreatedDate';
       
        repDetailList.add(TestDataHelper.createRepDetailField('Badge_Title', false));
        repDetailList[3].Fields_To_Map__c = 'Upline:LDRSHP_TITL_LVL_NR__c,LDRSHP_LOA_NR__c';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Paid Title', false));
        repDetailList[4].Fields_To_Map__c = 'Upline:LDRSHP_TITL_LVL_NR__c,LDRSHP_LOA_NR__c';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Runtime REP_MKT_TAG_1', false));
        repDetailList.add(TestDataHelper.createRepDetailField('Runtime ALM_MKT_TAG_1', false));
        repDetailList.add(TestDataHelper.createRepDetailField('Runtime Title_1', false));
        
        repDetailList.add(TestDataHelper.createRepDetailField('Sponsor', false));
        repDetailList[8].Fields_To_Map__c = 'Upline:LDRSHP_TITL_LVL_NR__c,LDRSHP_LOA_NR__c';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Home Address', false));
        repDetailList[9].Fields_To_Map__c = 'Upline:LDRSHP_TITL_LVL_NR__c,LDRSHP_LOA_NR__c';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Secondary Phone Number', false));
        repDetailList[10].Fields_To_Map__c = 'Upline:test.//LDRSHP_LOA_NR__c';
        repDetailList[10].isRuntime__c = false;
        
        insert repDetailList;
    }
    
}