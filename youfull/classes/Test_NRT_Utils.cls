/***************************************************************************
 Name          : Test_NRT_Utils 
 Created By    : Barkha Jain (JDC)
 Description   : Test class for NRT_Utils 
 Created Date  : Nov 16, 2013                
****************************************************************************/
@isTest
private class Test_NRT_Utils {
	static String mktIdKey = 'XX';
	
	//---------------------------------------------------------------------------
    // Method Name  : testNRTUtil
    // Description  : Method for Test Coverage for NRT_Utils
    //---------------------------------------------------------------------------
    static testMethod void testNRTUtil() {
    	// Create Leader User 
        User usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
     	usr.MRKT_ID__c = mktIdKey;
     	insert usr;
     	
        // Creating market data
    	Market__c mkt = TestDataHelper.createMarket(mktIdKey, false);
        mkt.Batch_Load_In_Process__c = true;
    	mkt.Batch_Load_Strt_Dt__c = System.now().addMinutes(-50);
        insert mkt;   
        
        Test.startTest();
        system.runAs(usr){
        	NRT_Utils.isBatchLoadInProcess();
        	NRT_Utils.getBatchLoadStarted();
        	system.assert(!NRT_Utils.isNrtEnabled());
        	NRT_Utils.getLastUpdatedTimeStamp(mktIdKey);
        	system.assertEquals(mkt.CMPGN_NR__c, NRT_Utils.getCurrentCampaign(mkt, usr));
        	system.assertEquals(mkt.NEXT_1_CMPGN_NR__c, NRT_Utils.getNextCampaign(mkt, usr));
        }	
        
    	mkt.Mail_Plan_Enabled__c = true;
    	mkt.NRT_Enabled__c = true;
    	update mkt;
    	
    	List<MailPlan_Order_Oppty__c> mailPlans = new List<MailPlan_Order_Oppty__c>();
    	MailPlan_Order_Oppty__c mp = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', System.today().addDays(1+10), 
											'M1', 'XZ1', 'M', false);
		mp.CURRNT_NEXT_CMPGN_PRFX_CD__c = 'C';
		mp.MRKT_ID__c = mktIdKey;
		mailPlans.add(mp);
		MailPlan_Order_Oppty__c mp1 = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.NEXT_1_CMPGN_NR__c, 'N', System.today().addDays(1+10), 
											'M1', 'XZ1', 'M', false);
		mp1.CURRNT_NEXT_CMPGN_PRFX_CD__c = 'N';
		mp1.MRKT_ID__c = mktIdKey;
		mailPlans.add(mp1);
		insert mailPlans;
    	
    	system.runAs(usr){	
    		system.assert(NRT_Utils.isNrtEnabled());
    		NRT_Utils.getLastUpdatedTimeStamp(mktIdKey);
    		NRT_Utils.getLastUpdatedTimeStampBatch(mktIdKey);
 
    		system.assert(NRT_Utils.getCurrentCampaign(mkt, usr).contains(mailPlans[0].CMPGN_NR__c));
        	system.assert(NRT_Utils.getNextCampaign(mkt, usr).contains(mailPlans[1].CMPGN_NR__c));
        }
        Test.stopTest();        
    }
}