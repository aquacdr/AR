/***************************************************************************
 Name         : Test_MyTeamReportPageController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for MyTeamReportPageController
 Created Date : Oct. 28, 2013                
****************************************************************************/

@isTest
private class Test_MyTeamReportPageController {
	
	//----------------------------------------------------------------------------
    // Method Name  : testMyTeamReportPageController
    // Description  : Method for Test Coverage of Class : MyTeamReportPageController
    //----------------------------------------------------------------------------  
    public static testmethod void testMyTeamReportPageController() {
    	
    	PageReference mtrPage = Page.MyTeamReport;
        Test.setCurrentPageReference(mtrPage);
        ApexPages.currentPage().getParameters().put('repDetailAcctNbr', 'value');
        
        Test.startTest();
        MyTeamReportPageController mtrpc = new MyTeamReportPageController();
        mtrpc.saveSearchText();
        System.assertEquals(mtrpc.callRepDetails(), null);      
        System.assertEquals(mtrpc.repDetailAcctNbr, 'value');
        Test.stopTest();
    	
    }
}