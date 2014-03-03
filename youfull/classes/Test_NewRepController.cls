/***************************************************************************
 Name          : Test_NewRepController 
 Modified By   : Parul Gupta (JDC)
 Description   : Test class for NewRepController
 Modified Date : Nov 1, 2013                
****************************************************************************/
@isTest
private class Test_NewRepController 
{
    public static String mktIdKey = 'XX';
    
    //---------------------------------------------------------------------------
    // Method Name  : testNewRepBusiness
    // Description  : Method for Test Coverage for NewRepController
    //---------------------------------------------------------------------------
    public static testmethod void testNewRepBusiness(){
    	ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        
    	Market__c mrkt = TestDataHelper.createMarket('DE', true);
        mrkt.Market_Currency_Symbol__c = '₱';
        update  mrkt;
         
        User ldrUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
        ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
        insert ldrUsr;
        
        mrkt.OwnerId = ldrUsr.Id;
        update  mrkt;
       
        //Added by Rupayan
        Report_Print__c rp = TestDataHelper.createReportPrint(mrkt.Market_Id__c, 0, 0, 0, true);
                
        // Creating Leader Title Objects        
        TestDataHelper.createLeaderTitlesList(mrkt.id, mrkt.Market_Id__c, true); 
                
        // Create Report Config records
        List<Report_Config__c> lstRepCnfg = TestDataHelper.createReportConfig(mrkt.id, true);
        lstRepCnfg[5].Include_Recruits__c = true;
        lstRepCnfg[5].Include_Removed_Reps__c = false;
        update lstRepCnfg[5];
        
        List<Calendar__c> lstCalndr = new List<Calendar__c>();
        TestDataHelper.createCalendar(201203.00, mrkt.Market_Id__c, 2012, mrkt.Id, false);      
        lstCalndr.add(TestDataHelper.createCalendar(201203.00, mrkt.Market_Id__c, 2012, mrkt.Id, false));      
        lstCalndr.add(TestDataHelper.createCalendar(201202.00, mrkt.Market_Id__c, 2012, mrkt.Id, false));       
        lstCalndr.add(TestDataHelper.createCalendar(201201.00, mrkt.Market_Id__c, 2012, mrkt.Id, false));
        lstCalndr.add(TestDataHelper.createCalendar(201117.00, mrkt.Market_Id__c, 2011, mrkt.Id, false));
        lstCalndr.add(TestDataHelper.createCalendar(201116.00, mrkt.Market_Id__c, 2011, mrkt.Id, false));        
        insert lstCalndr;
        
        String loa = 'LOA (1-6)'; 
        
        
        /* -- Cut Portions START -- */
        Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);        
              
        List<Contact> lstContact = new List<Contact>();
        Contact con1;
        for(Integer index = 1;index <= 4;index++){
        	con1 = TestDataHelper.createContact(mktIdKey, testAcct.id, false);
        	con1.Email = 'test' + index + '@avon.com';
        	con1.FirstName = mktIdKey + 'First' + index;
        	con1.LastName = mktIdKey + 'Last' + index;
        	con1.OwnerId = ldrUsr.Id;
        	con1.MRKT_ACCT_KEY__c += '0' + index;
        	lstContact.add(con1);
        }
        
      
        insert lstContact;   
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        createALMRepPerformanceRecords(lstRepPerf, lstContact, mrkt);
               
        
        PageReference pageRef = Page.NewRepReport;
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('acctkey', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        PageRef.getParameters().put('CNO', mrkt.CMPGN_NR__c);
        PageRef.getParameters().put('LOA', loa);
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'last');
        PageRef.getParameters().put('pagename' , '1');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getHeaders().put('User-Agent', 'MSIE9');
        Test.setCurrentPage(pageRef);
        
        // Formulating query       
       String query = 'SELECT ACCT_NR__c,'+
                            'Genealogy_Level__c,'+
                            'MRKT_ACCT_KEY__r.LastName,'+
                            'MRKT_ACCT_KEY__r.FirstName,'+
                            'MRKT_ACCT_KEY__r.ACCT_NR__c,'+
                            'MRKT_ACCT_KEY__r.Email,'+
                            'SLS_ZONE_CD__c,'+
                            'LOA_NR__c,'+
                            'BRNCH_SCTN_CD__c,'+
                            'PRSNL_SLS_AMT__c,'+
                            'BOOK1_GRP_UNIT_SLS_AMT__c,'+
                            'PC1_INVC_AWRD_SLS_AMT__c,'+
                            'MRKT_ACCT_KEY__r.Representative_Phone__c,'+
                            'UPLN_ACCT_NR__c,'+
                            'MRKT_ACCT_KEY__r.REP_BRTH_DT__c,'+
                            'MRKT_ACCT_KEY__r.REP_APPT_DT__c,'+
                            'LDRSHP_TITL_LVL_NR__c,'+
                            'BRCHR_CNT__c,'+
                            'CUST_CNT__c FROM ALM_Rep_Performance_1__c'+
                            ' WHERE OPERTNL_CMPGN_NR__c=\''+mrkt.CMPGN_NR__c+'\' AND ROOT_UPLN_ACCT_NR__c=\''+ldrUsr.ACCT_NR__c+'\' AND '+
                            ' Genealogy_Level__c in (1, 2, 3) '+
                            ' ORDER BY LOA_NR__c asc, PRSNL_SLS_AMT__c desc';
                         
                         system.debug(query);   
       
        System.runAs(ldrUsr)
        {
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);
            NewRepController controller = new NewRepController(sc);
            controller.initialized();
                        
            controller.populateCon();
 			controller.getOmniturePageName();
            controller.sortOther();
            controller.download_click();
            controller.downloadAll();
            controller.downloadPage();
            controller.filterReport();     

            controller.callRepDetails();
            controller.printRedirect();
            controller.refreshPage();
            controller.previous();
            controller.next(); 
            controller.gotopage();
            controller.setNewRepReportURL('My_New_Representative_62_');
 		    controller.getNewRepReportURL();
            
            Boolean statusPrev = controller.hasPrevious;
            integer pageNumbr = controller.pageNumber;
            Boolean statusNext = controller.hasNext;
            
            System.assert(controller.emailForIndc == 'G1');
            System.assert(statusPrev == false);
            System.assert(statusNext == false);
            System.assert(pageNumbr == 1);            
            
        }
        
        
        lstRepCnfg[5].Include_Recruits__c = false;
        lstRepCnfg[5].Include_Removed_Reps__c = false;
        update lstRepCnfg[5];
        
        mrkt.Allow_Freeform_Email__c = 'Avon Mtk DE Zone Manager';
        update  mrkt;        
        
        pageRef = Page.NewRepReport;
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'first');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('prtinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getHeaders().put('User-Agent', 'MSIE9');
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);
            NewRepController controller = new NewRepController(sc);
            controller.initialized();
                        
            controller.populateCon();
            controller.setPrintVar();
            controller.download_click();
            controller.downloadPage();
            controller.callRepDetails();
            controller.pagination();
            controller.printRedirect();
                        
            Boolean statusPrev = controller.hasPrevious;
            integer pageNumbr = controller.pageNumber;
            Boolean statusNext = controller.hasNext;
            
            System.assert(controller.emailForIndc == '');
            System.assert(statusPrev == false);
            System.assert(statusNext == false);
            System.assert(pageNumbr == 1);           
            
        }
        
        
        mrkt.Allow_Free_Emails_For__c = 'All';
        mrkt.Allow_Freeform_Email__c = 'Avon Leader;Avon Mkt DE Zone Manager';
        update  mrkt;
        
        lstRepCnfg[5].Include_Recruits__c = true;
        lstRepCnfg[5].Include_Removed_Reps__c = false;
        update lstRepCnfg[5];
        
        
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('acctkey', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        //PageRef.getParameters().put('CNO', mrkt.SPPY_CMPGN_NR__c);
        PageRef.getParameters().put('CNO', mrkt.PREV_1_CMPGN_NR__c);
        PageRef.getParameters().put('LOA', loa);
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'next');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('prtinvisibleStr' , 'SHPI~SH8~SH5');
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);
            NewRepController controller = new NewRepController(sc);
            controller.initialized();
                        
            controller.populateCon();
            controller.getOmniturePageName();
            controller.sortOther();
            controller.download_click();
            controller.setPrintVar();
            controller.downloadAll();
            controller.downloadPage();
            controller.filterReport();        
            controller.callRepDetails();
            controller.pagination();
            controller.next();  
            controller.printRedirect(); 
            
            Boolean statusPrev = controller.hasPrevious;
            integer pageNumbr = controller.pageNumber;
            Boolean statusNext = controller.hasNext;   
            
            controller.downloadMyReport();
            
            controller.downloadAll();
            controller.downloadThisReport();
            
            System.assert(controller.emailForIndc == 'All');
            System.assert(statusPrev == false);
            System.assert(statusNext == false);
            System.assert(pageNumbr == 1);
            
        }
        
        
        pageRef.getParameters().put('reportId', 'R06');  
        pageRef.getParameters().put('acctkey', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        PageRef.getParameters().put('CNO', mrkt.SPPY_CMPGN_NR__c);
        PageRef.getParameters().put('LOA', loa);
        PageRef.getParameters().put('stype', 'Text');
        PageRef.getParameters().put('sid', '1');
        PageRef.getParameters().put('pgtype' , 'previous');
        PageRef.getParameters().put('allinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('invisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getParameters().put('prtinvisibleStr' , 'SHPI~SH8~SH5');
        PageRef.getHeaders().put('User-Agent', '');
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
            /*ApexPages.StandardSetController sc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            sc.setSelected(lstRepPerf);*/
            NewRepController controller1 = new NewRepController();
            controller1.initialized();
            
        } 
    }
    
    // Method inserts ALM Rep Performance records for each contact for each campaign
    private static void createALMRepPerformanceRecords(List<ALM_Rep_Performance_1__c> lstRepPerf, 
    													List<Contact> lstContact,
    																Market__c mrkt){
    	lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey, null, mktIdKey,
    										0, lstContact[0].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.CMPGN_NR__c),
    										mrkt.CMPGN_NR__c,  
    										1, 8, false));
        
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey, null, mktIdKey,
    										0, lstContact[0].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
    										mrkt.PREV_1_CMPGN_NR__c,  
    										1, 8, false));
                                        
       
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey+'01', mktIdKey, mktIdKey,
    										1, lstContact[1].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.CMPGN_NR__c),
    										mrkt.CMPGN_NR__c,  
    										2, 7, false));
       
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey+'01', mktIdKey, mktIdKey,
    										1, lstContact[1].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
    										mrkt.PREV_1_CMPGN_NR__c,  
    										2, 7, false));
                                            
       
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey+'02', mktIdKey+'01', mktIdKey,
    										2, lstContact[2].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.CMPGN_NR__c),
    										mrkt.CMPGN_NR__c,  
    										3, 6, false));
       
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey+'02', mktIdKey+'01', mktIdKey,
    										2, lstContact[2].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
    										mrkt.PREV_1_CMPGN_NR__c,  
    										3, 6, false));
                                            
       
        lstRepPerf.add(TestDataHelper.createALMRepPerformance(mktIdKey+'03', mktIdKey+'02', mktIdKey,
    										3, lstContact[3].Id,  
    										mrkt.Market_ID__c,
    										Decimal.valueOf(mrkt.CMPGN_NR__c),
    										mrkt.CMPGN_NR__c,  
    										4, 5, false));
        insert lstRepPerf;
    }
}