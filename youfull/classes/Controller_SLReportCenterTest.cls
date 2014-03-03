/***************************************************************************
 Name         : Controller_SLReportCenterTest
 Created By   : Parul Gupta 
 Description  : Test class for Controller_SLReportCenter
 Created Date : Jan 13, 2013                 
****************************************************************************/

@isTest
private class Controller_SLReportCenterTest{  
    
    private static User testUsr;
    private static Market__c marketOne;
    private static Report_Center__c reportCenterOne;
    
    //----------------------------------------------------------------------------
    // Method Name  : testReportCenterController
    // Description  : Method for Test Coverage of Class : ReportCenterController
    //----------------------------------------------------------------------------  
    public static testmethod void testReportCenterController() {
        // Create test data
        createTestData();
        
        Test.startTest();
        List <Attachment> attachments = [select id, name from Attachment where parent.id =: reportCenterOne.id];
        System.assertEquals(attachments.size(), attachments.size());
        ApexPages.currentPage().getParameters().put('rptpar1', '0');
        ApexPages.currentPage().getParameters().put('rptpar2', '0');
        
        System.runAs(testUsr) {
            Controller_SLReportCenter objRC = new Controller_SLReportCenter();
            objRC.getReportLinks();
            objRC.fetchReports(testUsr.ACCT_NR__c, testUsr.LanguageLocaleKey, 'Avon Leader', '3', marketOne.Id, Integer.valueOf(marketOne.CMPGN_NR__c), 
                                Integer.valueOf(marketOne.PREV_1_CMPGN_NR__c), Integer.valueOf(marketOne.NEXT_1_CMPGN_NR__c));
            system.assert(objRC.lst_AddReports.size() > 0);
            objRC.Refreshcampaign();
            objRC.getOmniturePageName();
            objRC.callRepDetails();
        }
        
        Omniture_Page_Name_Mapping__c omniturePage = TestDataHelper.createOmniturePageNameMapping(true);
        
        System.runAs(testUsr) {
            ApexPages.currentPage().getParameters().put('acctkey', testUsr.ACCT_NR__c);
            Controller_SLReportCenter objRC = new Controller_SLReportCenter ();
            objRC.fetchReports(testUsr.ACCT_NR__c, testUsr.LanguageLocaleKey, 'Avon Leader', '3', marketOne.Id, Integer.valueOf(marketOne.CMPGN_NR__c), 
                                Integer.valueOf(marketOne.PREV_1_CMPGN_NR__c), Integer.valueOf(marketOne.NEXT_1_CMPGN_NR__c));
            system.assert(objRC.lst_AddReports.size() > 0);
            objRC.Refreshcampaign();
            objRC.callRepDetails();
        }
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : createTestData
    // Description  : Method to create dummy data for testing
    //----------------------------------------------------------------------------
    static void createTestData(){
        String mktIdKey = 'TESTRC';
        
        //Create Market__c
        marketOne = TestDataHelper.createMarket(mktIdKey, true);
        
        //Create Report_Config__c
        List <Report_Config__c> reportConfig = TestDataHelper.createReportConfig(marketOne.Id, true);
        
        //Create User
        testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);        
        testUsr.LDRSHP_TITL_LVL_NBR__c = '1';
        insert testUsr;
        
        List <Report_Center__c> reportCenterList = new List <Report_Center__c>();
        
        reportCenterOne = TestDataHelper.createReportCenter(String.valueOf(marketOne.Id), false);
        reportCenterList.add(reportCenterOne);
        
        Report_Center__c reportCenterTwo = TestDataHelper.createReportCenter(String.valueOf(marketOne.Id), false);
        reportCenterTwo.Can_Impersonate__c = false;
        reportCenterList.add(reportCenterTwo);
        
        insert reportCenterList;        
        
        Attachment[] oAttach  = new Attachment[]{};
        
        for(Integer z = 0; z < 3; z++) {            
            String dt_Format = '';
            if ( z == 0) {
                dt_Format = (System.now().addMonths(z)).format('yyyyMM');
            } else {
                dt_Format = (System.now().addMonths(-z)).format('yyyyMM');
            }
            
            Attachment attach_EOM = new Attachment();     
            attach_EOM.Name = 'R-' + testUsr.ACCT_NR__c + '-SOS-' + String.valueOf(dt_Format) + '-' + testUsr.LanguageLocaleKey + '.pdf';
            Blob bodyBlob_EOM = Blob.valueOf('Unit Test Attachment Body');
            attach_EOM.body = bodyBlob_EOM;
            attach_EOM.parentId = reportCenterTwo.id;
            
            oAttach.add(attach_EOM);
        }
        
        if(oAttach.size()>0){
            insert oAttach;
        }
        
        Attachment attach = new Attachment();     
        attach.Name = 'R-' + testUsr.ACCT_NR__c + '-SOS-' + marketOne.CMPGN_NR__c + '-' + testUsr.LanguageLocaleKey + '.pdf';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = reportCenterOne.id;
        insert attach;        
        
    }
}