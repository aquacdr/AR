/***************************************************************************
 Name         : Test_ZM_ForecastATInputController
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_ForecastATInputController
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_ZM_ForecastATInputController {
	
	//----------------------------------------------------------------------------
    // Method Name  : testForecastATInputCtrl
    // Description  : Method for Test Coverage of Class : ZM_ForecastATInputController
    //----------------------------------------------------------------------------
    static testMethod void testForecastATInputCtrl() {
        String marktId = 'DE';
        
        // creating test 'Zone Manager' user
        User zmUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Mkt 62 Zone Manager', false);
        zmUsr.MRKT_ID__c = marktId;
		insert zmUsr;
		
        //Creating custom setting
        TestDataHelper.createZoneKPIConfig('ConfigX', 'test', null, true);
        
        // Creates Market Data
        Market__c mkt = TestDataHelper.createMarket('test market', marktId, false);
        mkt.CMPGN_NR__c = '201304';
        mkt.Mail_Plan_Enabled__c = true;
        
        System.runAs (zmUsr) {
        	insert mkt;
            
            // Creates ZM MarketZoneKPIConfig data
        	ZM_MarketZoneKPIConfig__c zmMrktZoneKPIConfg = TestDataHelper.createMarketZoneKPIConfig('ACTV_REP', 'ConfigX', mkt.ID, '1', 'Forecast Input', 'USD', false, 12, true);
        	
            // Creating Sales org Summary data
            Sales_Org_Summary__c sos = TestDataHelper.createSalesOrgSummary(mkt, zmUsr, true);
        }
        
        // Creates MailPlan data
	    MailPlan_Order_Oppty__c mlplnOrdOppty = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', System.today().addDays(1+10), null, null, null, false);
        mlplnOrdOppty.SLS_ZONE_CD__c = zmUsr.DFALT_ZONE_CD__c;
        insert mlplnOrdOppty;
        
        PageReference p = Page.ZM_ActivityForecastTrackerInput;
		Test.setCurrentPage(p);
		
		System.runAs(zmUsr){            
            ZM_ForecastATInputController ctl = new ZM_ForecastATInputController();            
            ctl.getMapFields();
			ctl.getOmniturePageName();
			ctl.changeZone();
			ctl.submit();            
        }
    }
}