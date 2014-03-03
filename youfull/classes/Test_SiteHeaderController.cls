/***************************************************************************
 Name          : Test_SiteHeaderController
 Modified By   : Parul Gupta (JDC)
 Description   : Test class for SiteHeaderController
 Modified Date : Nov 9, 2013                
****************************************************************************/
@isTest
private class Test_SiteHeaderController{

    public static String acctNbr = '123456';
    
    //---------------------------------------------------------------------------
    // Method Name  : testSiteHeaderController
    // Description  : Method for Test Coverage for SiteHeaderController
    //---------------------------------------------------------------------------
    public static testmethod void testSiteHeaderController(){
        
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
        
        // Create Market Data
        Market__c mkt = TestDataHelper.createMarket('XX', true);
        
        // Current user
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        // Create leader usr
        User ldrUsr = TestDataHelper.createUser(acctNbr, 'XZ1', 'Avon Leader', false);
        ldrUsr.MRKT_ID__c = mkt.Market_Id__c;
         
        // Creates Sales Org Data
        TestDataHelper.createSalesOrgsList(mkt.Id, mkt.Market_Id__c, true); 
        
        // Creating Account and contact data
        Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);              
        Contact ct = TestDataHelper.createContact(acctNbr, testAcct.id, true);
   
        // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = TestDataHelper.creatMailPlans(mkt, ldrUsr.DFALT_ZONE_CD__c, true);
        
        //Creating ALM REP PERF Data
        List<ALM_Rep_Performance_1__c> lstCombObj = new List<ALM_Rep_Performance_1__c>();    
        lstCombObj.add(TestDataHelper.createALMRepPerformance(acctNbr, null, acctNbr,
                                            0, ct.Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.CMPGN_NR__c),
                                            mkt.CMPGN_NR__c,  
                                            1, 8, false));
                                                 
        lstCombObj.add(TestDataHelper.createALMRepPerformance(acctNbr, null, acctNbr,
                                            0, ct.Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.NEXT_1_CMPGN_NR__c),
                                            mkt.NEXT_1_CMPGN_NR__c,  
                                            1, 8, false));
      
        lstCombObj.add(TestDataHelper.createALMRepPerformance(acctNbr, null, acctNbr,
                                            0, ct.Id,  
                                            mkt.Market_ID__c,
                                            Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c),
                                            mkt.PREV_1_CMPGN_NR__c,  
                                            1, 8, false));
        for(ALM_Rep_Performance_1__c almRep : lstCombObj){
            almRep.MailPlan_Order_Oppty__c = mlplnOrdOppty.Id;
        }
        insert lstCombObj;
        
        // Create Report Config Data
        TestDataHelper.createReportConfig(mkt.id, true);
        
        PageReference pageRef = Page.YOUHome;
        pageRef.getParameters().put('prior', 'prior');
        pageRef.getParameters().put('acctKey', 'XX');
        Test.setCurrentPage(pageRef);  
        
        System.runAs(ldrUsr){
            SiteHeaderController ctlr = new SiteHeaderController();            
            ctlr.init();           
            System.assert(ctlr.getReportLinks().size() > 0);
            ctlr.getReportLinks(mkt.Market_Id__c, ldrUsr.Profile.Name, ldrUsr.LDRSHP_TITL_LVL_NBR__c, true);
        }
        
        System.runAs ( thisUser ) {
            ldrUsr.TRNDSTTR_IND__c = null;
            update ldrUsr;
            mkt.Mail_Plan_Enabled__c = false;
            mkt.Site_Maintenance_Enabled__c = true;
            update  mkt;
        }
        
        System.runAs(ldrUsr){
            SiteHeaderController ctlr = new SiteHeaderController();           
            ctlr.init();
            ctlr.showEarningOpportunity();
            ctlr.getControllerRef();
        }
        
        //For Testing Mail Plan Unable market
        mkt.Mail_Plan_Enabled__c = true;
        update mkt;
        System.runAs(ldrUsr){
            SiteHeaderController ctlr = new SiteHeaderController();            
            ctlr.init();
            ctlr.showEarningOpportunity();
            ctlr.getControllerRef();
            List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, acctNbr, mkt.Market_Id__c);
            System.assert(ctlr.getMailPlanCampaign(lst_CombinedObj) != null);
        }          
    }
}