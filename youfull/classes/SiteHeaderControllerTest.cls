@isTest
public with sharing class SiteHeaderControllerTest 
{
	public static String acctNbr = '123456';
	
	public static testmethod void testSiteHeaderController()
    {
        TestDataHelper testData =   new TestDataHelper();
        
        // Creates Market Data
        Market__c mkt = testData.createMarket();
        User ldrUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            ldrUsr = testData.createLeaderUser(acctNbr);
            
            mkt.OwnerId = ldrUsr.Id;
            update  mkt;
        }
        
        // Creates Sales Org Data
        testData.createSalesOrgs();
        
        // Creates Contact Data
        Contact ct = testData.createContact(acctNbr,ldrUsr.Id);
        
        // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mkt, ldrUsr.DFALT_ZONE_CD__c);
        
        //Creating ALM REP PERF Data
        List<ALM_Rep_Performance_1__c> lstCombObj = new List<ALM_Rep_Performance_1__c>();
        
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = ct.ACCT_NR__c,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = ct.Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c = mkt.CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = ct.ACCT_NR__c,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8, MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
                                            );
        lstCombObj.add(rep1);
                                            
        ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP2', ACCT_NR__c = ct.ACCT_NR__c,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = ct.Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.NEXT_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c = mkt.NEXT_1_CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = ct.ACCT_NR__c,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8, MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
                                            );
        lstCombObj.add(rep2);
        //insert rep1;
        
        ALM_Rep_Performance_1__c rep3 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP3', ACCT_NR__c = ct.ACCT_NR__c,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = ct.Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c = mkt.PREV_1_CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = ct.ACCT_NR__c,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8, MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
                                            );
        lstCombObj.add(rep3);
        insert lstCombObj;
        
        // Create Report Config Data
        testData.createReportConfig();
        
        PageReference pageRef = Page.YOUHome;
        pageRef.getParameters().put('prior', 'prior');
        pageRef.getParameters().put('acctKey', 'XX');
        Test.setCurrentPage(pageRef);  
        
        System.runAs(ldrUsr){
            SiteHeaderController ctlr = new SiteHeaderController();
            
            ctlr.init();
            
            ctlr.getReportLinks();
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
            ctlr.getMailPlanCampaign(lst_CombinedObj);
        }
        
        
           
    }
}