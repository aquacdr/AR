/***************************************************************************
 Name          : Test_JQGridComponentController
 Created By    : Barkha Jain
 Description   : Test class for JQGridComponentController
 Created Date  : Jan 13, 2014                
****************************************************************************/
@isTest(SeeAllData=true)
private class Test_JQGridComponentController {
	
	//----------------------------------------------------------------------------
    // Method Name  : testJQGridComponent
    // Description  : Method for Test Coverage of Class : JQGridComponentController
    //----------------------------------------------------------------------------
    static testMethod void testJQGridComponent() {    	
    	
        // This causes a fake response to be generated
        Test.setMock(HttpCalloutMock.class, new HTTPCalloutMockImpl());
        Report r = [Select Name, Id from Report limit 1];
        
        Test.startTest();
        JQGridComponentController ctrl = new JQGridComponentController();
        //verify result (empty data string)
        system.assertEquals('', ctrl.jsonData);
        system.assertEquals(0, ctrl.columnsToFreeze);
        
        //setting report id
        ctrl.reportId = r.Id;
        ctrl.columnsToFreeze = 1;
        
        //verify result
        system.assertEquals(r.Name, ctrl.reportName);
        system.assertEquals(1, ctrl.columnsToFreeze);        
        system.assertNotEquals('', ctrl.jsonData); 
        
        //create dummy report filter
        ReportFilter filter = new ReportFilter();
    	filter.column = 'Name';
    	filter.operator = 'contains';
    	filter.value = 'test';
    	
    	ctrl.filterLogic = '1';
    	ctrl.filters = new List<ReportFilter>{filter};
    	//test when filters available
    	ctrl.loadReportData();
    	
        Test.stopTest();
    }
}