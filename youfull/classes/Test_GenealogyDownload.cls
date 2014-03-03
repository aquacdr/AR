/***************************************************************************
 Name          : Test_GenealogyDownload
 Created By    : Barkha Jain (JDC)
 Description   : Test class for GenealogyDownload
 Created Date  : Nov 6, 2013                
****************************************************************************/
@isTest
private class Test_GenealogyDownload {
	static Market__c mkt;
	static String mrktId = 'DE';
	static User usr;
	static ALM_Rep_Performance_1__c rep;
	    
	//----------------------------------------------------------------------------
    // Method Name  : testGenealogyDownLoad
    // Description  : Method for Test Coverage of Class : GenealogyDownload
    //----------------------------------------------------------------------------
    static testMethod void testGenealogyDownLoad() {
    	createTestData();
    	
    	String cmpgnId = MTRSOQLBuilder.MakeCampaignKey(Integer.valueOf(mkt.PREV_1_CMPGN_NR__c), Integer.valueOf(mkt.CMPGN_NR__c));
    	MTRSOQLBuilder msb = new MTRSOQLBuilder(mkt.Id, 'TitleAdvancement', 'Avon Leader', '1', 'en_US');
    	
        Test.startTest();
        GenealogyDownload gd = new GenealogyDownload(cmpgnId, '1234', msb);
        System.runAs(usr){
	        try{
	        	gd.download();
	        }catch(Exception e){
	        	//verify exception  
            	system.assert(e.getMessage().contains('Could not load zero-generation.'));
	        }
        }
        insert rep;
        System.runAs(usr){
	        List<Sobject> lst = gd.download();
	        //verify result
	        system.assert(lst.size() > 0);
        }
	    Test.stopTest();
        
    }
    
    // Method to create test data
    private static void createTestData(){
    	TestDataHelper.createALMGlobalSetting(true);
    	
    	usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = mrktId;
        usr.MRKT_ID_ACCT_NR_KEY__c = mrktId + '1234';
        insert usr;
        				
        System.runAs(usr){
	    	mkt = TestDataHelper.createMarket(mrktId, true);
        }
        	
    	// Create report config
    	Report_Config__c rc  = TestDataHelper.createReportConfig('Team Report', mkt.Id, 
								'Title_Advancement', 'Avon Leader',
								null, null, null, null, '1', null, 500, true);
		// Create report columns
		createReportColumns(rc.Id);
		// Create campaign calendars
    	createCampaignCalendarRecords(mkt); 
    	
    	Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
    	Contact c = TestDataHelper.createContact('1234', acc.Id, false);
    	c.MRKT_ACCT_KEY__c = mrktId + '1234';
    	insert c;
    	
    	MailPlan_Order_Oppty__c mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', System.today().addDays(1+10), 
    											'M1', 'XZ1', 'M', false);
    
    	rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', false);	
    	rep.MailPlan_Order_Oppty__c = mplan.Id;
    	rep.LFT_ND_ID__c = 0;
	    rep.RGT_ND_ID__c = 5;
	    
    }
    
    // Method to create report columns
    private static void createReportColumns(String reportConfigId){
        
        List<Report_Column_New__c> rcList = new List<Report_Column_New__c>();
        rcList.add(TestDataHelper.createReportColumn(reportConfigId, 'Name',
						     1, 'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', 
						     'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', 'Frozen',
						     'Text', 'Always Displayed', false));
		rcList.add(TestDataHelper.createReportColumn(reportConfigId, 'LLOA / LOA',
						     2, 'LDRSHP_LOA_NR__c, LOA_NR__c', 
						     null, 'Scrollable',
						     'Text', 'Default Shown', false));						    					     
		rcList.add(TestDataHelper.createReportColumn(reportConfigId, 'Badge Title',
						     3, 'LDRSHP_TITL_LVL_NR__c', 
						     null, 'Scrollable',
						     'Text', 'Default Shown', false));
        insert rcList;      
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