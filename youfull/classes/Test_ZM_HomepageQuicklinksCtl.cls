/***************************************************************************
 Name         : Test_ZM_HomepageQuicklinksCtl
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_HomepageQuicklinksCtl
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest(SeeAllData=true)
private class Test_ZM_HomepageQuicklinksCtl {
		static testMethod void testHomepageQuicklinks(){
			Date currDate = System.today().addDays(1);
		    String acctNbr = '123456';
		    
		    // Creates Market Data
		    Market__c mkt = TestDataHelper.createMarket('test market', '123456', false);
        	mkt.CMPGN_NR__c = '201304';
		    User zmUsr = TestDataHelper.createUser(acctNbr, 'XZ1', 'Avon Mkt 62 Zone Manager', true);
		    System.runAs ( zmUsr ) {
		        mkt.Mail_Plan_Enabled__c = true;
		        insert  mkt;
		    }
		    // Creates MailPlan data
		    MailPlan_Order_Oppty__c mlplnOrdOppty = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', currDate.addDays(1+10), null, null, null, false);
            mlplnOrdOppty.SLS_ZONE_CD__c = zmUsr.DFALT_ZONE_CD__c;
            mlplnOrdOppty.MRKT_ID__c = '123456';
            insert mlplnOrdOppty;
		    
		    // Creates ZM Report Market Translation data
		    Report r = [Select Name, Id from Report limit 1];
		    ZM_Report_Translation__c z = TestDataHelper.createReportTranslation(r.Name, r.Id, mkt.Market_Id__c, 1, 
	        									   zmUsr.LanguageLocaleKey, 'Quick Links', 'Zone', true);	
		    
		    System.runAs(zmUsr){
		        ZM_HomepageQuicklinksCtl ctlr = new ZM_HomepageQuicklinksCtl();
		        
		        ctlr.getDefaultCampaignId();
		        ctlr.getReportLinks();
		        ctlr.getDefaultZone(true);		        
		    }
		    
		    ZM_HomepageQuicklinksCtl.fixReportUrls('https://cs11.salesforce.com');
		    
		    System.runAs ( zmUsr ) {
		        mkt.Mail_Plan_Enabled__c = false;
		        update mkt;
		    }
		    
		    System.runAs(zmUsr){
		        ZM_HomepageQuicklinksCtl ctlr = new ZM_HomepageQuicklinksCtl();
		        ctlr.getDefaultCampaignId();
		    }
		}
}