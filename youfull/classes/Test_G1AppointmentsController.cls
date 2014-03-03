/***************************************************************************
 Name          : Test_G1AppointmentsController
 Created By    : Barkha Jain (JDC)
 Description   : Test class for G1AppointmentsController
 Created Date  : Nov 7, 2013                
****************************************************************************/
@isTest
private class Test_G1AppointmentsController {
	
	static Market__c mkt;
    static String mrktId = '62';
    static User usr;
    static List<ALM_Rep_Performance_1__c> repLst;
    
	//----------------------------------------------------------------------------
    // Method Name  : testG1AppointmentsCtrl
    // Description  : Method for Test Coverage of Class : G1AppointmentsController
    //----------------------------------------------------------------------------
    static testMethod void testG1AppointmentsCtrl() {
        createTestData();
    	
        PageReference pg = new PageReference('/apex/G1Appointments');
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('mpCampaign', mkt.CMPGN_NR__c);
        
        Test.startTest();
        system.runAs(usr){  
        	G1AppointmentsController ctrl = new G1AppointmentsController();
        	//verify exception result
        	system.assertEquals(null, ctrl.g1Aptnmt_hasData);
        }
        
        //insert rep performance record with user's accountNr
        insert repLst[0];		
        
        system.runAs(usr){  
        	G1AppointmentsController ctrl = new G1AppointmentsController();
        	//verify zero result
        	system.assertEquals(false, ctrl.g1Aptnmt_hasData);
        }
        
        //insert candidate record
        insert repLst[1];
        
        system.runAs(usr){ 	
        	G1AppointmentsController ctrl = new G1AppointmentsController();
        	//verify result
        	system.assertEquals(true, ctrl.g1Aptnmt_hasData);
        }
        Test.stopTest();      
    }
    
    //----------------------------------------------------------------------------
    // Method to create test data
    //----------------------------------------------------------------------------
    private static void createTestData(){
        TestDataHelper.createALMGlobalSetting(true);
        //creating test user
        usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = mrktId;
        usr.MRKT_ID_ACCT_NR_KEY__c = mrktId + '1234';
        insert usr;
                        
        System.runAs(usr){
            mkt = TestDataHelper.createMarket(mrktId, false);
            mkt.Mail_Plan_Enabled__c = true;
            insert mkt;
        }
        
        Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
        Contact c = TestDataHelper.createContact('1234', acc.Id, false);
        c.MRKT_ACCT_KEY__c = mrktId + '1234';
        insert c;
        
        //creating calendar records
    	createCampaignCalendarRecords(mkt);
        										
        //creating test Genealogy records
        repLst = new List<ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', false);   
        rep.LFT_ND_ID__c = 0;
        rep.RGT_ND_ID__c = 5;
        rep.Genealogy_Level__c = 1;
        repLst.add(rep);
        
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(c.Id, mkt, '1235', false);  
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 2;
        rep1.UPLN_ACCT_NR__c = '1234';
        rep1.Genealogy_Level__c = 2;
        rep1.SLS_ZONE_CD__c = 'XZ1';
        rep1.BRNCH_SCTN_CD__c = 'XZ1';
        rep1.REP_APPT_CMPGN_NR__c = mkt.CMPGN_NR__c;
        repLst.add(rep1);        
    }
    
    // Method to create campaign calendar records
    private static void createCampaignCalendarRecords(Market__c mrkt){
        List<Calendar__c> campaignCalendarList = new List<Calendar__c>();
       
        Calendar__c cal = TestDataHelper.createCalendar(Decimal.valueOf(mrkt.CMPGN_NR__c), mrkt.Market_Id__c, null, mrkt.Id, false);
        cal.CURRNT_IND__c = 'Y';
        cal.PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c; 
        campaignCalendarList.add(cal);
        cal = TestDataHelper.createCalendar(Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c), mrkt.Market_Id__c, null, mrkt.Id, false);
        cal.PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c; 
        campaignCalendarList.add(cal);
        cal = TestDataHelper.createCalendar(Decimal.valueOf(mrkt.NEXT_1_CMPGN_NR__c), mrkt.Market_Id__c, null, mrkt.Id, false);
        cal.PRIOR_CMPGN_NR__c = mrkt.PREV_1_CMPGN_NR__c; 
        campaignCalendarList.add(cal);      
        insert campaignCalendarList;      
    }
}