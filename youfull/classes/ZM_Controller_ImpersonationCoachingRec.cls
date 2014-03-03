public class ZM_Controller_ImpersonationCoachingRec {
    
    public String repDetailAcctNbr {get; set;}     
    public String searchText {get;set;} 
    private Contact representative;
    private User currUser;
    private String almReIndicator;
  
    public ZM_Controller_ImpersonationCoachingRec() {
        String contactId = ApexPages.CurrentPage().getParameters().get('Id');
        representative = [SELECT Id, Name, ACCT_NR__c, SLS_ZONE_CD__c FROM Contact where Id = :contactId];
        currUser = [SELECT Id, Profile.Id, Profile.Name, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1]; 
        repDetailAcctNbr = representative.ACCT_NR__c;
        System.debug('===================== ZM_Controller_ImpersonationCoachingRec Controller. User: ' + currUser + ' User Division: ' + currUser.DFALT_DIV_NM__c + ' User MarketAcctKey: ' + currUser.MRKT_ID_ACCT_NR_KEY__c + ' currUser.MRKT_ID__c'+currUser.MRKT_ID__c);
        almReIndicator = [Select Id, ALM_Rep_Indicator__c from Market__c where Market_Id__c = :currUser.MRKT_ID__c LIMIT 1].ALM_Rep_Indicator__c;
        System.debug('===================== ZM_Controller_ImpersonationCoachingRec Controller. User: ' + currUser + ' User Division: ' + currUser.DFALT_DIV_NM__c + ' User MarketAcctKey: ' + currUser.MRKT_ID_ACCT_NR_KEY__c); 
    }
    
    // Code that is invoked on page load.
    public PageReference autoRun() {
        SObject almPerf;
        String newPageUrl;
        
        /* Changes for ZM Impersonation - Mail Plan Start */ 
        //Integer campaignNr = YOUUtil.getCurrentCampaignNumber(currUser.MRKT_ID__c);
        //String campaign = String.valueOf(campaignNr);
        
        ZM_UtilityClass objutilityclass= new ZM_UtilityClass(); 
        
        objutilityclass.SetVariable();
        String campaign = objutilityclass.strCurrentCmpgnNR; 
        //Apexpages.currentPage().getParameters().put('testCampaign', campaign);
        Apexpages.currentPage().getParameters().put('mpCampaign', campaign);
        /* Changes for ZM Impersonation - Mail Plan Start */
        
        System.debug('\n ######### campaign '+campaign+', currUser.ACCT_NR__c '+currUser.ACCT_NR__c+', representative.ACCT_NR__c '+representative.ACCT_NR__c+', contactId '+ApexPages.CurrentPage().getParameters().get('Id'));
        
        
        // String campaign = '201212';
        
        // Check if impersonation is valid      
        if ((representative != null) && (LandingPageUtils.isImpersonationValid(currUser.Profile.Name, currUser.MRKT_ID__c, currUser.DFALT_ZONE_CD__c, currUser.DFALT_DIV_NM__c, currUser.ACCT_NR__c, campaign, representative.ACCT_NR__c))) 
        {       
            System.debug('===================== ZM_Controller_ImpersonationCoachingRec Controller. Representative: ' + representative);         
            String repId = representative.Id;
            //List<SObject> almPerList = Database.query('SELECT LDRSHP_TITL_LVL_NR__c FROM '+almReIndicator+' WHERE MRKT_ACCT_KEY__c = :repId ORDER BY OPERTNL_CMPGN_NR__c DESC LIMIT 1');
            List<SObject> almPerList = Database.query('SELECT LDRSHP_TITL_LVL_NR__c FROM '+almReIndicator+' WHERE MRKT_ACCT_KEY__c = :repId ORDER BY FLD_SLS_CMPGN_NR__c DESC LIMIT 1');
                        
            if (almPerList.size() > 0) {
                almPerf = almPerList[0];
            }
            System.debug('===================== almPerf \n : ' + almPerf);
            if (almPerf == null) {
                System.debug('=====================1 almPerf \n : ' + almPerf);
                // Redirect to an error page
                newPageUrl = '/apex/errorpage';         
            } else {
                System.debug('=====================2 almPerf \n : ' + almPerf);
                String badgeTitle = String.valueOf(almPerf.get('LDRSHP_TITL_LVL_NR__c'));
                System.debug('=====================2 badgeTitle : ' + badgeTitle);
                System.debug('===== Representative: ' + representative + ' and Personal Performance: ' + almPerf + ' and Badge Title: ' + badgeTitle);
                if ('1234567'.contains(badgeTitle)) {
                    // Redirect to the impersonation page
                    newPageUrl = '/apex/YOUHome?acctkey=' + repDetailAcctNbr+'&mpCampaign=' + campaign; // Mail Plan Change - Selling Campaign added as parameter
                }
            }       
        } else {
            String errorId = ErrorHandler.handleError(Label.ZM_This_downline_cannot_be_accessed);
            System.debug('===================== ZM_Controller_ImpersonationCoachingRec Controller. Impersonation is not valid.  Error Id = ' + errorId);
            newPageUrl = '/apex/errorpage?msg=Err_Msg_Impersonation';
        }
        
        if (newPageUrl != null) {
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);
            return newPage;
        }
        return null;
     }
    
    //added by Snehashis
    public PageReference callRepDetails(){
        if (repDetailAcctNbr == null) {
            repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr'); 
        }
        return null; 
    } 
    

    // ADDED BY Vijay Mittal FOR SEARCH COMPONENT POPUP WINODOW
    public Pagereference saveSearchText() {
        searchText = Apexpages.currentPage().getParameters().get(ALMConstants.SEARCH_URL_PARAM);
        return null;
    }
    // CHNAGES BY Vijay Mittal ENDS HERE
    
    
    
    @isTest(SeeAllData=true)
    private static void testMTRPageController()
    {
    	TestDataHelper testData =   new TestDataHelper();
        
        String acctNbr = '123456';
        
        // Creates Market Data
        Market__c mkt = testData.createMarket();
        User zmUsr, dmUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            zmUsr = testData.createUser(acctNbr, 'XZ1', ' Zone Manager');
            
            mkt.OwnerId = zmUsr.Id;
            mkt.Mail_Plan_Enabled__c = true;
            update  mkt;
            
        }
        
        // Creates Account Data
        Account testAcct = new Account(Name='Test Acount');
        insert testAcct;
        
        // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mkt, zmUsr.DFALT_ZONE_CD__c);
        
        // Creates Contact data
        Contact con1    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=acctNbr, Email='test1@avon.com', 
                                        FirstName=acctNbr+'First1',LastName=acctNbr+'Last1',HomePhone='9999999999',
                                        LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',  MLPLN_CD__c=mlplnOrdOppty.MLPLN_CD__c,
                                        MRKT_ACCT_KEY__c=mkt.Market_Id__c+acctNbr, MRKT_ID__c=mkt.Market_Id__c, PATD_CERTFCTN_LVL_A_IND__c='Y',
                                        PATD_CERTFCTN_LVL_D_IND__c='Y', PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                        REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3', REP_ADDR_STR_4_TXT__c='Address 4',
                                        REP_APPT_DT__c=System.today(), REP_LANG_CD__c='en_US', SLS_ZONE_CD__c='XZ1', REP_MOBILE_PHON_NR__c = '1234546789',
                                        OwnerId=zmUsr.Id, REP_BRTH_DT__c =System.today()
                                      );
        insert con1;
        
        
        PageReference pageRef1 = Page.ZM_Impersonation_CoachingRecord;
        pageRef1.getParameters().put('id', con1.Id);
        pageRef1.getParameters().put('searchText', 'testSearch');
        Test.setCurrentPage(pageRef1);
        
        System.runAs(zmUsr){
        	ZM_Controller_ImpersonationCoachingRec ctrl1 = new ZM_Controller_ImpersonationCoachingRec();	
        	
        	ctrl1.callRepDetails();
        	ctrl1.saveSearchText();
        	ctrl1.autoRun();
        }
        
        // Creates Combined Object data
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c( Name = 'Test REP1', ACCT_NR__c = acctNbr, Genealogy_Level__c = 0,
                                                					  CurrencyISOCode='USD', MRKT_ID__c=mkt.Market_ID__c,
                                                					  MRKT_ACCT_KEY__c = con1.Id, FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                					  OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c, REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                					  LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1', ROOT_UPLN_ACCT_NR__c = acctNbr,
                                                					  LFT_ND_ID__c = 1, RGT_ND_ID__c = 8);
       insert rep1;
        
        PageReference pageRef2 = Page.ZM_Impersonation_CoachingRecord;
        pageRef2.getParameters().put('id', con1.Id);
        pageRef2.getParameters().put('searchText', 'testSearch');
        Test.setCurrentPage(pageRef2);
        
        System.runAs(zmUsr){
        	ZM_Controller_ImpersonationCoachingRec ctrl2 = new ZM_Controller_ImpersonationCoachingRec();	
        	
        	ctrl2.callRepDetails();
        	ctrl2.saveSearchText();
        	ctrl2.autoRun();
        }
        
        con1.ACCT_NR__c = acctNbr+'7';
        update con1;
        
        rep1.ACCT_NR__c = con1.ACCT_NR__c;
        update rep1;        
        
        PageReference pageRef3 = Page.ZM_Impersonation_CoachingRecord;
        pageRef3.getParameters().put('id', con1.Id);
        pageRef3.getParameters().put('searchText', 'testSearch');
        Test.setCurrentPage(pageRef3);
        
        System.runAs(zmUsr){
        	ZM_Controller_ImpersonationCoachingRec ctrl3 = new ZM_Controller_ImpersonationCoachingRec();	
        	
        	ctrl3.callRepDetails();
        	ctrl3.saveSearchText();
        	ctrl3.autoRun();
        }
        
        
        
    }
}