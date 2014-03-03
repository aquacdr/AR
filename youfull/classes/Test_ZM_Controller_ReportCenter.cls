/***************************************************************************
 Name         : Test_ZM_Controller_ReportCenter
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Controller_ReportCenter
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest(SeeAllData=true)
private class Test_ZM_Controller_ReportCenter {
	
	//----------------------------------------------------------------------------
    // Method Name  : testReportCenterController
    // Description  : Method for Test Coverage of Class : ZM_Controller_ReportCenter
    //----------------------------------------------------------------------------
    static testMethod void testReportCenterController() {
        String acctNbr = '123456';
        Date currDate = System.today().addDays(1);
        
        // Creates ZM Report Market Translation data
	    Report r = [Select Name, Id from Report limit 1];
        
        User zmUsr = TestDataHelper.createUser(acctNbr, 'XZ1', ' Zone Manager', true);
        
        // Creates Market Data
        Market__c mkt = TestDataHelper.createMarket('test market', '123456', false);
        mkt.CMPGN_NR__c = '201304';
        mkt.NEXT_1_CMPGN_NR__c = '201304';
        mkt.PREV_1_CMPGN_NR__c = '201304';
        mkt.Mail_Plan_Enabled__c = true;        
        
        System.runAs (zmUsr) {
            insert mkt;
            
            // Creating Sales org Summary data
            Sales_Org_Summary__c sos = TestDataHelper.createSalesOrgSummary(mkt, zmUsr, true);
            
            // Creates MailPlan data
	        MailPlan_Order_Oppty__c mlplnOrdOppty = TestDataHelper.createMPOrderOpp(mkt.Id, mkt.CMPGN_NR__c, 'N', currDate.addDays(1+10), null, null, null, false);
            mlplnOrdOppty.SLS_ZONE_CD__c = zmUsr.DFALT_ZONE_CD__c;
            mlplnOrdOppty.MRKT_ID__c = '123456';
            insert mlplnOrdOppty;
            
	        ZM_Report_Translation__c z = TestDataHelper.createReportTranslation(r.Name, r.Id, mkt.Market_Id__c, 1, 
	        											zmUsr.LanguageLocaleKey, 'Report Center;Lead', 'Zone', true);	        
        }
                
        PageReference pageRef = Page.ZM_ReportCenter;
        pageRef.getParameters().put('report', 'test');
        Test.setCurrentPage(pageRef);
        
        System.runAs(zmUsr){
            ZM_Controller_ReportCenter ctlr = new ZM_Controller_ReportCenter();
            
            ctlr.selectedStandardReport = r.Id;
            ctlr.selectedOfflineReport= ctlr.selectedStandardReport+':testfile';
            ctlr.getOfflineReportList();
            ctlr.getOfflineReportList();
            ctlr.getPersonalReportList();
            ctlr.getReportURL();
            ctlr.getShowPersonalReport();
            ctlr.getStandardReportList();
            ctlr.getZones(mkt.Id);
            ctlr.openOfflineReport();
            ctlr.redirectToStandardReport();
            ctlr.getZoneList();
            ctlr.getOmniturePageName();
            ctlr.getCampaignList();
            ctlr.selectedPersonalReport();
                        
        }
        
        mkt = TestDataHelper.createMarket('test market1', '12345602', false);
        mkt.CMPGN_NR__c = '201304';
        mkt.NEXT_1_CMPGN_NR__c = '201304';
        mkt.PREV_1_CMPGN_NR__c = '201304';
        mkt.Mail_Plan_Enabled__c = true; 
         
        User dmUsr = TestDataHelper.createUser(acctNbr+'02', 'XZ2', ' Division Manager', true);
        System.runAs (dmUsr) {
            insert  mkt;
            
            // Creating Sales org Summary data
            Sales_Org_Summary__c sos = TestDataHelper.createSalesOrgSummary(mkt, dmUsr, true);
            
            // Creating CDW Market Report data
	        CDW_Market_Report__c cdwMrkReprt = new CDW_Market_Report__c(Name = 'TestCDWReport', CurrencyISOCode='USD',
	        															User_Type_Index__c = 'Z', Market__c = mkt.Id);
	        insert cdwMrkReprt;  
        
        
            PageReference pageRef1 = Page.ZM_ReportCenter;
            Test.setCurrentPage(pageRef1);
        
            ZM_Controller_ReportCenter ctlr1 = new ZM_Controller_ReportCenter();
            ctlr1.getAttachmentId(cdwMrkReprt, mkt.CMPGN_NR__c);
        }        
    }
}