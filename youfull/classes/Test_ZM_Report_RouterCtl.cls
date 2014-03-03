/***************************************************************************
 Name         : Test_ZM_Report_RouterCtl
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Report_RouterCtl
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest(SeeAllData=true)
private class Test_ZM_Report_RouterCtl {
	
	//----------------------------------------------------------------------------
    // Method Name  : testReportRouter
    // Description  : Method for Test Coverage of Class : ZM_Report_RouterCtl
    //----------------------------------------------------------------------------
	static testMethod void testReportRouter(){
		String marketId = 'XX';
		Report r = [Select Name, Id from Report limit 1];
	    ZM_Report_Translation__c z = TestDataHelper.createReportTranslation(r.Name, r.Id, marketId, 1, 
																			'en_US', 'Quick Links', 'Zone', true);
	    
		Profile profile = [Select Id, Name from Profile where Name Like '%System Administrator%' limit 1];
      	//create test user
      	User u = TestDataHelper.createUser('1', profile.Id, false);
      	u.MRKT_ID__c = marketId;
      	u.DFALT_DIV_NM__c = 'Metro Achievers';
      	u.DFALT_ZONE_CD__c ='XZ1';
		insert u;
    	
    	//create zone user
    	User runuser = TestDataHelper.createUser(marketId,'201','Avon Mkt 62 Zone Manager',true);
    	
    	//create division user
    	User runuserdiv = TestDataHelper.createUser('1234','202','Avon Mkt 62 Division Manager',false);
    	runuserdiv.MRKT_ID__c = marketId;
    	insert runuserdiv;
    	
		System.RunAs(u){	
			Market__c testmarket = TestDataHelper.createMarket('test market', marketId, false);
	    	testmarket.Mail_Plan_Enabled__c = true;
	    	testmarket.CMPGN_NR__c = '123';
	        insert testmarket;	
	        
	        Sales_Org_Summary__c salesRecord = TestDataHelper.createSalesOrgSummary(testmarket, u, true);
	        
			PageReference pr = Page.ZM_Report_Router;
			pr.getParameters().put('reportname', z.Report_Label__c);
			Test.setCurrentPage(pr);
			ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
			h.routReport();
			system.assertNotEquals(null,h.getDefaultZone());
			
			pr.getParameters().put('reportname', 'testxtest');
			Test.setCurrentPage(pr);
			ZM_Report_RouterCtl h2 = new ZM_Report_RouterCtl();
			h2.routReport();
		}
		
		PageReference pr = Page.ZM_Report_Router;
		pr.getParameters().put('reportname',z.Report_Label__c);
		Test.setCurrentPage(pr);
		
		System.RunAs(runuser){			
			ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
			h.routReport();
		}
				
		System.RunAs(runuserdiv){
			ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
			h.routReport();
			h.getOmniturePageName();	
		}
				
	}

}