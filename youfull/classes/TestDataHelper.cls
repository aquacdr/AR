public without sharing class TestDataHelper {
    
    public Market__c market { get; set; }
    public User leaderUser { get; set; }
    public User tempUser { get; set; }
    public List <Leader_Title__c> titles { get; set; }
    public Contact testContact { get; set; }
    public List <Contact> testContactLst { get; set; }
    public List <Seller_Status__c> sellerStatus { get; set; }
    public List <MailPlan_Order_Oppty__c> mplans{ get; set; }
    public Account testAcct { get; set; }
    public List <Leader_Downline_Summary__c> ldrData { get; set; }
    public List <Market_Tag_Label__c> mktTags { get; set; }
    public List <Sales_Organization__c> slsOrgs {get; set; }
    public List <Geo_Level_1__c> geoLvl1 { get; set; }
    public List <Geo_Level_2__c> geoLvl2 { get; set; }
    public List <Geo_Level_3__c> geoLvl3 { get; set; }
    public List <Geo_Level_4__c> geoLvl4 { get; set; }    
    public User zoneUser { get; set; } 
    public User divUser { get; set; }    
    public List <SObject> repPerfData { get; set; }
  	public List <Market_Action_Items__c> mkActItems { get; set; }
    public List <Action_Items__c> actItems { get; set; }
    
    public Market__c createMarket() {
        return createMarket('XX');
    } 
    
    public Market__c createMarket(String mktId) {
        System.debug('\n ## market found: ' + this.market);
        if (this.market == null) {
            System.debug('creating new test market');
      
            this.market = new Market__c(Name='Test Market',
                                        Market_Id__c=mktId,
                                        Market_Administrator__c=UserInfo.getUserId(),
                                        Available_Languages__c='en_US',
                                        CurrencyISOCode='USD',
                                        Mail_Plan_Enabled__c=false,
                                        ASLF_Timezone_Offset__c=0.0,
                                        ASLF_Report_URL__c='http://aslf.report.avon.com',
                                        CURRNT_CMPGN_RMN_DAY_CNT__c=10,
                                        CMPGN_NR__c='201304',
                                        OPERTNL_CMPGN_CMPLTN_PCT__c=25,
                                        NEXT_1_CMPGN_NR__c='201305',
                                        CURRENT_QRTR__c='2013-Q3',
                                        Enabled_Action_Item__c='Orders; Sales; Current Business',
                                        PREV_1_CMPGN_NR__c='201303',
                                        SPONSOR_QLFYING_ORD_AMT__c=1,
                                        CMPGN_STRT_DT__c=System.today(),
                                        CMPGN_END_DT__c=System.today(),
                                        Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c',
                                        Eligibility_Yes_Flags__c='Opt_In__c',
                                        LeadMandatoryFields__c='User_Type__c,FirstName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c,Geo_Level_4__c,Mobile__c',
                                        SPPY_CMPGN_NR__c='201001',
                                        X90_Day_Camp_CNT__c=6,
                                        Business_Plan_KPIs__c ='Unit_Earnings_dollar;Total_Unit_Sales_dollor;G1_Sales_Leaders_UL;G1_Activity_Rate;Bonus_Earnings;Earnings_from_Personal_Sales;Executive_Earnings;New_G1_UL;New_G1_EUL;New_G1_AUL;Total_and_Est_Earnings_dollar;Personal_Appointments;Qualified_Personal_Appointments;Personal_Volume_dollar;G1_Removals;G1_Active_Representatives',
                                        Max_Ldr_Titl_LVL__c = 9,
                                        ALM_Rep_Indicator__c='ALM_Rep_Performance_1__c',
                                        Allow_Freeform_Email__c='Avon Leader;Avon Division Manager',
                                        Allow_Free_Emails_For__c ='G1', LAST_UPDT_DT__c = System.today());
                                
            insert this.market;
            System.Debug('\n Market ID TestDataHelper >>>>  '+market.Market_Id__c);
        }

        System.debug('returning market id  : ' + this.market.Market_Id__c);
        return this.market;

    }
            
    //create market for mail plan
	public Market__c createMailPlanMarket(String mktId) {
        System.debug('\n ## market found: ' + this.market);
        if (this.market == null) {
            System.debug('creating new test market');
      
            this.market = new Market__c(Name='Test Market',
                                        Market_Id__c=mktId,
                                        Market_Administrator__c=UserInfo.getUserId(),
                                        Available_Languages__c='en_US',
                                        CurrencyISOCode='USD',
                                        Mail_Plan_Enabled__c=true,
                                        ASLF_Timezone_Offset__c=0.0,
                                        ASLF_Report_URL__c='http://aslf.report.avon.com',
                                        CURRNT_CMPGN_RMN_DAY_CNT__c=10,
                                        CMPGN_NR__c='201204',
                                        OPERTNL_CMPGN_CMPLTN_PCT__c=25,
                                        NEXT_1_CMPGN_NR__c='201205',
                                        CURRENT_QRTR__c='2012-Q3',
                                        Enabled_Action_Item__c='Orders; Sales; Current Business',
                                        PREV_1_CMPGN_NR__c='201203',
                                        SPONSOR_QLFYING_ORD_AMT__c=1,
                                        CMPGN_STRT_DT__c=System.today(),
                                        CMPGN_END_DT__c=System.today(),
                                        Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c',
                                        Eligibility_Yes_Flags__c='Opt_In__c',
                                        LeadMandatoryFields__c='User_Type__c,FirstName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c,Geo_Level_4__c,Mobile__c',
                                        SPPY_CMPGN_NR__c='201001',
                                        X90_Day_Camp_CNT__c=6,
                                        Business_Plan_KPIs__c ='Unit_Earnings_dollar;Total_Unit_Sales_dollor;G1_Sales_Leaders_UL;G1_Activity_Rate;Bonus_Earnings;Earnings_from_Personal_Sales;Executive_Earnings;New_G1_UL;New_G1_EUL;New_G1_AUL;Total_and_Est_Earnings_dollar;Personal_Appointments;Qualified_Personal_Appointments;Personal_Volume_dollar;G1_Removals;G1_Active_Representatives',
                                        Max_Ldr_Titl_LVL__c = 9,
                                        ALM_Rep_Indicator__c='ALM_Rep_Performance_1__c',
                                        Allow_Freeform_Email__c='Avon Leader;Avon Division Manager',
                                        Allow_Free_Emails_For__c ='G1', LAST_UPDT_DT__c = System.today());
                                
            insert this.market;
            System.Debug('\n Market ID TestDataHelper >>>>  '+market.Market_Id__c);
        }

        System.debug('returning market id  : ' + this.market.Market_Id__c);
		return this.market;
    }       
    
  	private void createAccount() {
        if (this.testAcct == null) {
            this.testAcct = new Account(Name='Test Acount');
            insert this.testAcct;
        }
    }  
    
    public User createLeaderUser(String acctNbr) {
        //createMarket();
        this.leaderUser = createUser(acctNbr,'XZ1','Avon Leader');
        return leaderUser;      
    }
    
    public User createUser(String acctNbr,String zoneNbr,String prfName) {
        createMarket();
        //Profile sysAdm = [select Id,Name from Profile where Name=:prfName];
        String profNameLike = '%'+prfName;
        
        Profile sysAdm = [select Id,Name from Profile where Name like :profNameLike LIMIT 1];
        this.tempUser = new User(
                                 Username=acctNbr+'@avonpoc.com',
                                 Title=prfName,
                                 TimeZoneSidKey='America/New_York',
                                 ProfileId=sysAdm.Id,
                                 LocaleSidKey='en_US',
                                 LastName=prfName,
                                 FirstName='Avon Test',
                                 Email=acctNbr+'@avonpoc.com',
                                 Alias='test',
                                 EmailEncodingKey='ISO-8859-1',
                                 LanguageLocaleKey='en_US',
                                // IsActive=true, 
                                 ACCT_NR__c=acctNbr,
                                 DFALT_DIV_NM__c='D1',
                                 DFALT_ZONE_CD__c=(prfName=='Avon Division Manager'?null:zoneNbr),
                                 MAX_EMAIL_LIMIT__c=10,
                                 MLPLN_CD__c='1',
                                 MRKT_ID__c=this.market.Market_Id__c,
                                 MRKT_ID_ACCT_NR_KEY__c=this.market.Market_Id__c+acctNbr,
                                 MRKT_TAG_1_HDR_TXT__c='Some data',
                                 USER_CNTRY_CD__c='US',
                                 Welcome_Message__c=true,
                                 SFDC_Ineligibility_Codes__c='',
                                 GI3_Email__c=acctNbr+'@avonpoc.com',
                                 LDRSHP_TITL_LVL_NBR__c = '1', TRNDSTTR_IND__c = 'Y'
                                );
        insert tempUser;
        tempUser.IsActive = true;
        update tempUser;

        System.Debug('\n Market ID TestDataHelper.createUser MRKT_ID__c >>>>  '+tempUser.MRKT_ID__c);
        Group grp = [select Id,Name from Group where Name='System Admin Group'];
        GroupMember mbr = new GroupMember(GroupId=grp.Id,UserOrGroupId=tempUser.Id);
        insert mbr;
        return tempUser;
    }
    
    public List<User_Sales_Org_Hierarchy__c> createUsrSlsOrgHrchy(User usr) {
    	createMarket();
        List <User_Sales_Org_Hierarchy__c> orgHierList = new List <User_Sales_Org_Hierarchy__c>();
        User_Sales_Org_Hierarchy__c orgHrarchy = new User_Sales_Org_Hierarchy__c(ACCT_NR__c=usr.ACCT_NR__c,Market__c=this.market.Id,MRKT_ID__c=this.market.Market_Id__c,
                                                            SLS_ORG_CD__c='XZ1',SLS_ORG_LVL_CD__c='Z');
        orgHierList.add(orgHrarchy);
        insert orgHierList;

        return orgHierList;
    }

    public List <User_Sales_Org_Hierarchy__c> createUsrSlsOrgHrchy(User usr,String orgCd,String orgLvl) {
    	createMarket();
        List <User_Sales_Org_Hierarchy__c> orgHierList = new List <User_Sales_Org_Hierarchy__c>();
        User_Sales_Org_Hierarchy__c orgHrarchy = new User_Sales_Org_Hierarchy__c(ACCT_NR__c=usr.ACCT_NR__c,Market__c=this.market.Id,MRKT_ID__c=this.market.Market_Id__c,
                                                            SLS_ORG_CD__c=orgCd,SLS_ORG_LVL_CD__c=orgLvl);
        orgHierList.add(orgHrarchy);
        insert orgHierList;

        return orgHierList;
    }
    
    public EmailTemplate createEmailTemplate() {
        Folder fld = [select Id,Name from Folder where Name='Dummy_Folder_DO_NOT_DELETE'];
        EmailTemplate template = new EmailTemplate( FolderId=fld.Id,Name='test',body='test',description='test',
                                                    DeveloperName='test',htmlvalue='<html></html>',
                                                    IsActive=true,
                                                    Subject='Test',TemplateType='Custom');
        insert template;
        return template;
    }    
             
	public Lead createLead(User owner) {
	    createMarket();
	    Lead tempLead = new Lead(
	         FirstName='Avon Lead Fname',
	         LastName=owner.ACCT_NR__c+'LName',
	         Company='Avon Test',
	         Email='alm.noreply@avon.com',
	         MobilePhone='7827373',
	         Confirm_Email__c='alm.noreply@avon.com',
	         Type__c='FGL',
	         Lead_Owner__c=owner.Id,
	         MRKT_ID__c=this.market.Market_Id__c,
	         SLS_DIV_NM__c= owner.DFALT_DIV_NM__c,
	         SLS_ZONE_CD__c= owner.DFALT_ZONE_CD__c,
	         Status=ALMPLusConstants.LEAD_STS_NEW
	    );
	    insert tempLead;
	    return tempLead;     
	}    
    
    public List<Action_Items__c> createActionItems() {
        this.actItems = new List<Action_Items__c>();
        Action_Items__c actItem;
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Rising Stars',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='GRP_RISNG_STAR_CNT__c',Subject_Area__c='Coaching Others',Datatype__c='Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Title at Risk',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='GRP_TAR_CNT__c',Subject_Area__c='Coaching Others',Datatype__c='Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='New and In Progress Leads',Default__c=false,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='GRP_TITL_DMTD_CNT__c',Subject_Area__c='Managing Numbers',Datatype__c='Number');
        actItems.add(actItem);      

        actItem = new Action_Items__c(  Action_Item_Type__c='Summary',Category__c='Orders Not submitted',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='GRP_NO_ORD_CNT__c',Subject_Area__c='Managing Numbers',Datatype__c='Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Team sales below minimum',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='GRP_TUS_BLW_QLFR_CNT__c',Subject_Area__c='Managing Numbers',Datatype__c='Number');
        actItems.add(actItem);

        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Downline PSQ not achieved',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='PRSNL_SLS_BLW_QLFR_REP_CNT__c',Subject_Area__c='Managing Personal Reps',Datatype__c='Number');
        actItems.add(actItem);

        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Inactive',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c='INACTV_1_3_CMPGN_CNT__c',Subject_Area__c='Managing Personal Reps',Datatype__c='Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='G1 Candidates',Default__c=false,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c='GENRTN_1_APPT_CNT__c',
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                        Smry_Criteria_Fld__c=null,
                                        Subject_Area__c='Managing Personal Reps',Datatype__c='Currency');
        actItems.add(actItem);

        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Orders / Sales under minimum',Default__c=false,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c='ActionItem_ORD_UND_MIN__c',
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,Subject_Area__c='Orders',Datatype__c='Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Minimum Orders Received',Default__c=true,
                                        Genealogy_Criteria_Fld__c='ActionItem_ORD_NOT_SUBMITTED__c',Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,Subject_Area__c='Orders',Datatype__c='Currency');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Minimum Orders Received',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c='ANNIV_WITHIN_10_DAYS__c',Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,Subject_Area__c='Orders',Datatype__c='Number');
        actItems.add(actItem);      

        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Return Orders',Default__c=false,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c='ActionItem_ORD_UND_MIN__c',
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,Subject_Area__c='Sales',Datatype__c='Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(  Action_Item_Type__c='Downline',Category__c='Net Sales',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c='ActionItem_ORD_UND_MIN__c',
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,Subject_Area__c='Sales',Datatype__c='Number');
        actItems.add(actItem);
        
        
        actItem = new Action_Items__c(  Action_Item_Type__c='Summary',Category__c='New and In Progress Leads',Default__c=false,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,Subject_Area__c='Managing Numbers',Datatype__c='Number');
        actItems.add(actItem);
        
        actItem = new Action_Items__c(  Action_Item_Type__c='Summary',Category__c='New and In Progress Leads',Default__c=true,
                                        Genealogy_Criteria_Fld__c=null,Order_Criteria_Fld__c=null,
                                        Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Zone',
                                        Smry_Criteria_Fld__c=null,
                                        Subject_Area__c='Current Business',Datatype__c='Number');
        actItems.add(actItem);
        
        insert actItems;
        return actItems;
    }
    
    
    public List <Leader_Title__c> createLeaderTitles() {
        createMarket();
        String[] titlLvls = new String[]{'1','2','3','4','5','6','7','8'};
        Leader_Title__c title;
        String strEXEC_IND = '';
        // double minPrsnlSlsAmnt = 100.00;
        //double minGrpSlsAmnt = 100.0;
        if (titles==null) {
            titles = new List<Leader_Title__c>();
            for (String lvl: titlLvls) {
                if(lvl == '2') {
                    strEXEC_IND = 'Y';
                }
                if(lvl == '7') {
                    strEXEC_IND = 'N';
                }
                
                title = new Leader_Title__c(
                                            GENRTN_1_ERNGS_PCT__c=10.0, GENRTN_1_MIN_ORD_AMT__c=100.00,
                                            GENRTN_2_ERNGS_PCT__c=10.0, GENRTN_2_MIN_ORD_AMT__c=200.00,
                                            GENRTN_3_ERNGS_PCT__c=40.0, GENRTN_3_MIN_ORD_AMT__c=500.00,
                                            LANG_CD__c='en_US', LCL_LDRSHP_TITL_LANG_DESC_TXT__c='Title '+lvl,
                                            LDRSHP_TITL_LVL_NR__c=lvl, Market__c=this.market.Id,
                                          //  MIN_01_LVL_TITL_REQD_NR__c=100.00, MIN_GRP_SLS_REQD_AMT__c=100.0,
                                            MIN_PRSNL_SLS_REQD_AMT__c=100.00, MIN_REP_RCRTMNTS_REQD_NR__c=10,
                                          //  MIN_02_LVL_TITL_REQD_NR__c=10, MIN_03_LVL_TITL_REQD_NR__c=10,
                                            MIN_EST_ERNGs_AMT__c = 15000.00, MRKT_TAG_QLFR_1_NR__c=10, 
                                            MRKT_TAG_QLFR_2_NR__c=10,MRKT_TAG_QLFR_3_NR__c=10,EXEC_IND__c = strEXEC_IND,
                                            GRAPHIC_ERNG_IMG__c='http://media.gadgetsin.com/uploads//2009/10/ropid_small_size_robot_1.JPG',
                                            MIN_GRP_SLS_REQD_AMT__c = 100.0, MRKT_ID__c = this.market.Market_Id__c,
                                            LCL_LDRSHP_TITL_CD__c = 'TL '+lvl);
                titles.add(title);
            }
            system.debug('leader Title: '+titles);
            insert titles;
        }
    	return titles;
    }
    
    public List <Seller_Status__c> createSellerStatus() {
        createMarket();
        if (sellerStatus==null) {
            sellerStatus = new List<Seller_Status__c>();
            Seller_Status__c sts;
            sts = new Seller_Status__c( LANG_CD__c='en_US',LCL_TOP_SLR_LVL_KEY__c='SELLSTS1', MRKT_TOP_SLR_LANG_KEY__c='Top Seller 1',
                                        LCL_TOP_SLR_LVL_LANG_DESC_TXT__c='Seller Status 1',Market__c=this.market.Id);
            sellerStatus.add(sts);                                  
            sts = new Seller_Status__c( LANG_CD__c='en_US',LCL_TOP_SLR_LVL_KEY__c='SELLSTS2',MRKT_TOP_SLR_LANG_KEY__c='Top Seller 2',
                                        LCL_TOP_SLR_LVL_LANG_DESC_TXT__c='Seller Status 2',Market__c=this.market.Id);
            sellerStatus.add(sts);                                  
            sts = new Seller_Status__c( LANG_CD__c='en_US',LCL_TOP_SLR_LVL_KEY__c='SELLSTS3',MRKT_TOP_SLR_LANG_KEY__c='Top Seller 3',
                                        LCL_TOP_SLR_LVL_LANG_DESC_TXT__c='Seller Status 3',Market__c=this.market.Id);
            sellerStatus.add(sts);          
            insert sellerStatus;
        }
        return sellerStatus;                        
    }
    
    public List <Market_Action_Items__c> createMarketActionItems() {
        createMarket();
        createActionItems();
        mkActItems = new List<Market_Action_Items__c>();
        Market_Action_Items__c actItem ;
        integer cnt=0;
        for (Action_Items__c ai: actItems) {
            
            ALMLogUtils.log('TestDataHelper.createMarketActionItems','actItems='+ai);
            actItem = new Market_Action_Items__c(Action_Item__c=ai.Id,Campaign_Stage__c=10,Default__c=false,
                                                 Market__c=this.market.Id,Priority__c=''+cnt,Report__c=null,Threshold__c=5,Campaign__c='Current;Next');
             mkActItems.add(actItem);
            cnt++;
        }
        ALMLogUtils.log('TestDataHelper.createMarketActionItems','mkActItems='+mkActItems);
        insert mkActItems;  
        for (Market_Action_Items__c mai: mkActItems) {
            for (Action_Items__c ai: actItems) {
                ALMLogUtils.log('TestDataHelper.createMarketActionItems','actItems='+ai);
                ALMLogUtils.log('TestDataHelper.createMarketActionItems','actItems='+mai.id);
                if (mai.Action_Item__r.id==ai.id) {
                    mai.Action_Item__r.Action_Item_Type__c=ai.Action_Item_Type__c;
                    mai.Action_Item__r.Category__c=ai.Category__c;
                    mai.Action_Item__r.Default__c=ai.Default__c;
                    mai.Action_Item__r.Genealogy_Criteria_Fld__c=ai.Genealogy_Criteria_Fld__c;
                    mai.Action_Item__r.Order_Criteria_Fld__c=ai.Order_Criteria_Fld__c;
                    mai.Action_Item__r.Zone_Or_Leader__c=ai.Zone_Or_Leader__c;
                    mai.Action_Item__r.Subject_Area__c=ai.Subject_Area__c;
                    mai.Action_Item__r.Datatype__c=ai.Datatype__c;
                }
        	} 
        }   
        update  mkActItems;
        return mkActItems;
    }
    
    public Contact createContact(String acctNbr,String ownerId) {
        createMarket();
        createLeaderTitles();
        createSellerStatus();
        createAccount();
        if (this.testContact == null) {
            system.debug('this.testAcct: ' + this.testAcct);
            system.debug('acctNbr: ' + acctNbr);            
            this.testContact= new Contact(  AccountId=this.testAcct.Id,ACCT_NR__c=acctNbr,
                                            Email='test@avon.com',FirstName=acctNbr+'First',LastName=acctNbr+'Last',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                          //  LOA_NR__c=15,
                                            MRKT_ACCT_KEY__c=this.market.Market_Id__c+acctNbr,MRKT_ID__c=this.market.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789'
                                            ,OwnerId=ownerId//uncommented
                                          );
            insert this.testContact;
        }
        return this.testContact;
    }
    
    
    public List<SObject> createRepPerformance(String acctnbr,String ownerId) {
        
        Market__c currentMarket=createMarket();
        if (this.repPerfData == null) {
            this.repPerfData = new List<Sobject>();
        }
        //createContact( String.valueOf(acctnbr),'DUMMY'); 
        createContact( String.valueOf(acctnbr),this.tempUser.Id);
        
        SObject repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
        repPerformanceInstance.put('Personal_Performance_Key__c',this.market.Market_Id__c+this.market.CMPGN_NR__c+String.valueOf(acctnbr));
        repPerformanceInstance.put('AVON_LOA_1_6_IND__c','Y');
        repPerformanceInstance.put('SUBMTD_AWRD_SLS_AMT__c',100.00);
        repPerformanceInstance.put('SPPY_AWRD_SLS_AMT__c',100.00);
        repPerformanceInstance.put('PRSNL_MRKT_TAG_3_TXT__c','Test');
        repPerformanceInstance.put('CUST_CNT__c',100.00);
        repPerformanceInstance.put('CurrencyISOCode','USD');
        repPerformanceInstance.put('MRKT_ACCT_KEY__c',this.testContact.Id);
        repPerformanceInstance.put('MRKT_ID__c',this.market.Market_Id__c);
        repPerformanceInstance.put('ACCT_NR__c',String.valueOf(acctnbr));
        repPerformanceInstance.put('OPERTNL_CMPGN_NR__c', this.market.CMPGN_NR__c);
        repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(this.market.CMPGN_NR__c));
        repPerformanceInstance.put('REP_OMS_STUS_CD__c','1');
        repPerformanceInstance.put('LDRSHP_LOA_NR__c',1);
        repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1'); // added by ag
     
        repPerfData.add(repPerformanceInstance);
        insert repPerfData;
        return repPerfData;                                               
    }
            
	public Contact createNonMailPlanContact(String acctNbr,String ownerId) {
	    createMarket();
	    createLeaderTitles();
	    createSellerStatus();
	    createAccount();
	    if (this.testContact == null) {
	        this.testContact= new Contact(  AccountId=this.testAcct.Id,ACCT_NR__c=acctNbr,
	                                        Email='test@avon.com',FirstName=acctNbr+'First',LastName=acctNbr+'Last',HomePhone='9999999999',INACTV_CMPGN_CNT__c=5,
	                                        MLPLN_CD__c='DFLT',
	                                        MRKT_ACCT_KEY__c=this.market.Market_Id__c+acctNbr,MRKT_ID__c=this.market.Market_Id__c,MRKT_SLS_ORG_KEY__c=null,
	                                        REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
	                                        REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
	                                        REP_LANG_CD__c='en_US',REP_OMS_STUS_CD__c='R',
	                                        SLS_ZONE_CD__c='XZ1',OwnerId=ownerId
	                                      );
	        insert this.testContact;
	    }
	    return this.testContact;
	}   
            
            
    public List<MailPlan_Order_Oppty__c> createMailPlans() {
        if (market!=null) {
            createMarket();
        }
        MailPlan_Order_Oppty__c mplan;
        this.mplans= new List<MailPlan_Order_Oppty__c>();
        Date currDate = System.today();
        currDate = currDate.addDays(1);
        Date nextCDate= currDate.addDays(10);
        ALMLogUtils.log('TestDataHelper.createMailPlans','this.market.Market_ID__c='+this.market.Market_ID__c);
        for (Integer i=0;i<5;i++) {
            mplan = new MailPlan_Order_Oppty__c(CMPGN_NR__c='4',CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c=(i+1),CURRNT_CMPGN_ONLN_RMN_DAY_CNT__c=(i+1),
                                                CURRNT_NEXT_CMPGN_PRFX_CD__c='C',MLPLN_CD__c='M'+i,MLPLN_CLOSD_IND__c='N',
                                                MLPLN_END_DT__c=currDate.addDays(1+10),Market__c=this.market.Id,
                                                NEXT_MLPLN_TO_CLOS_CD__c='M'+(i+1),SLS_ZONE_CD__c='XZ1');
            mplans.add(mplan);  
            mplan = new MailPlan_Order_Oppty__c(CMPGN_NR__c='5',CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c=(i+10),CURRNT_CMPGN_ONLN_RMN_DAY_CNT__c=(i+10),
                                                CURRNT_NEXT_CMPGN_PRFX_CD__c='N',MLPLN_CD__c='M'+i,MLPLN_CLOSD_IND__c='N',
                                                MLPLN_END_DT__c=nextCDate.addDays(i+10),Market__c=this.market.Id,
                                                NEXT_MLPLN_TO_CLOS_CD__c='M'+(i+1),SLS_ZONE_CD__c='XZ1');   
            mplans.add(mplan);  
        }
        insert mplans;
        return mplans;
    }   
    
    public List <Sales_Organization__c> createSalesOrgs() {
    	createMarket();
        slsOrgs = new List<Sales_Organization__c>();
        Sales_Organization__c org;
        org = new Sales_Organization__c(Market__c=this.market.Id,MRKT_ID__c=this.market.Market_Id__c,
                                        SLS_DIV_MGR_EMAIL_TXT__c='divmgr@avon.com',SLS_DIV_MGR_FULL_NM__c='Division Manager',
                                        SLS_DIV_MGR_PHON_NR__c='1234567',SLS_DIV_NM__c='D1', MRKT_SLS_ORG_KEY__c='Key 1',MRKT_ID_LVL_SLS_ORG_CD_KEY__c='Division Manager 1',
                                        SLS_REGN_MGR_EMAIL_TXT__c='regmgr@email.com',SLS_REGN_MGR_FULL_NM__c='Region Manager',
                                        SLS_REGN_NM__c='R1',SLS_ZONE_CD__c='XZ1',SLS_ZONE_MGR_EMAIL_TXT__c='zmgr@avon.com',
                                        SLS_ZONE_MGR_FULL_NM__c='Zone Manager',SLS_ZONE_MGR_PHON_NR__c='123456788', SLS_DIV_CD__c='D1', SLS_ORG_LVL_CD__c='D');
        slsOrgs.add(org);

        org = new Sales_Organization__c(Market__c=this.market.Id,MRKT_ID__c=this.market.Market_Id__c,
                                        SLS_DIV_MGR_EMAIL_TXT__c='divmgr@avon.com',SLS_DIV_MGR_FULL_NM__c='Division Manager',
                                        SLS_DIV_MGR_PHON_NR__c='1234567',SLS_DIV_NM__c='D1', MRKT_SLS_ORG_KEY__c='Key 2',MRKT_ID_LVL_SLS_ORG_CD_KEY__c='Division Manager 2',
                                        SLS_REGN_MGR_EMAIL_TXT__c='regmgr@email.com',SLS_REGN_MGR_FULL_NM__c='Region Manager',
                                        SLS_REGN_NM__c='R1',SLS_ZONE_CD__c='',SLS_ZONE_MGR_EMAIL_TXT__c='zmgr@avon.com',
                                        SLS_ZONE_MGR_FULL_NM__c='',SLS_ZONE_MGR_PHON_NR__c='123456788');
        slsOrgs.add(org);
        System.debug('>>>>>>>> TestDataHelper: SALES ORG DATA:'+slsOrgs);
        insert slsOrgs;
        return slsOrgs;
    }
    
       
     public void createMarketTags(List<String> subjAreas) {
        createMarket();
        mktTags = new List<Market_Tag_Label__c>();
        for (String area: subjAreas) {
            mktTags.add(new Market_Tag_Label__c(Language__c='en_US',Market__c=this.market.Id,Field_API_Name__c='MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TAG_1_AMT__c',
                                             Subject_Area__c=area, Tag_Label__c='Market Tag 1',
                                             Tag_Name__c='Market Tag 1'));
                                             
            mktTags.add(new Market_Tag_Label__c(Language__c='en_US',Market__c=this.market.Id,Field_API_Name__c='MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TAG_4_TXT__c',
                                             Subject_Area__c=area, Tag_Label__c='Market Tag 2',
                                             Tag_Name__c='Market Tag 2'));
        }
        insert mktTags;
        
        for (Market_Tag_Label__c m : mktTags) {
            System.debug('\n @@@@ Market_Tag_Label__c m \n'+m);
            System.debug('\n @@@@1 Market_Tag_Label__c Mrkt Id '+m.Market__r.Market_Id__c);
            
            
        }
    }
     
    public List <Geo_Level_1__c> createGeoLevel1() {
         createMarket();
         if (geoLvl1==null) {
            geoLvl1 = new List<Geo_Level_1__c>();
            Geo_Level_1__c gl1 = new Geo_Level_1__c(Geo_Level_1_Key__c='GEOLVL11',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL11');
            Geo_Level_1__c gl2 = new Geo_Level_1__c(Geo_Level_1_Key__c='GEOLVL12',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL12');
            geoLvl1.add(gl1);
            geoLvl1.add(gl2);
            insert geoLvl1;
         }
        return geoLvl1;
    }
      
    public List <Geo_Level_2__c> createGeoLevel2() {
    	List <Geo_Level_1__c> gLvl1 = createGeoLevel1();
        if (geoLvl2==null) {
            geoLvl2 = new List<Geo_Level_2__c>();
            Geo_Level_2__c gl1 = new Geo_Level_2__c(Geo_Level_2_Key__c='GEOLVL21',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL21',Geo_Level_1__c=gLvl1[0].Id);
            Geo_Level_2__c gl2 = new Geo_Level_2__c(Geo_Level_2_Key__c='GEOLVL22',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL22',Geo_Level_1__c=gLvl1[1].Id);
            geoLvl2.add(gl1);
            geoLvl2.add(gl2);
            insert geoLvl2;
        }
        return geoLvl2;
     }
      
	public List <Geo_Level_3__c> createGeoLevel3(){
		List <Geo_Level_2__c> gLvl2 =createGeoLevel2();
	    if (geoLvl3==null) {
	        geoLvl3 = new List<Geo_Level_3__c>();
	        Geo_Level_3__c gl1 = new Geo_Level_3__c(Geo_Level_3_Key__c='GEOLVL31',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL31',Geo_Level_2__c=gLvl2[0].Id);
	        Geo_Level_3__c gl2 = new Geo_Level_3__c(Geo_Level_3_Key__c='GEOLVL32',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL32',Geo_Level_2__c=gLvl2[1].Id);
	        geoLvl3.add(gl1);
	        geoLvl3.add(gl2);
	        insert geoLvl3;
	    }
	    return geoLvl3;
	 }
     
    public List <Geo_Level_4__c> createGeoLevel4() {
    	List <Geo_Level_3__c> gLvl3 =createGeoLevel3();
        if (geoLvl4==null) {
            geoLvl4 = new List<Geo_Level_4__c>();
            Geo_Level_4__c gl1 = new Geo_Level_4__c(Geo_Level_4_Key__c='GEOLVL41',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL41',Geo_Level_3__c=gLvl3[0].Id);
            Geo_Level_4__c gl2 = new Geo_Level_4__c(Geo_Level_4_Key__c='GEOLVL42',MRKT_ID__c=this.market.Market_Id__c, Name='GEOLVL42',Geo_Level_3__c=gLvl3[1].Id);
            geoLvl4.add(gl1);
            geoLvl4.add(gl2);
            insert geoLvl4;
        }
        return geoLvl4;
     }
     
    public User createZoneUser(String acctNbr){
        createMarket();
        this.zoneUser = createUser(acctNbr,'XZ1','Avon Mkt 62 Zone Manager'); //Modified by Rupayan
        return zoneUser;        
    }
      
	public User createDivUser(String acctNbr){
	    createMarket();
	    this.divUser = createUser(acctNbr,'XZ1','Avon Mkt 62 Division Manager'); //Modified by Rupayan
	    return divUser;     
	}    
           
    // Method Modified. New field 'Report_Sequence__c' is added for Report Config creation - by Raktim
    public List <Report_Config__c> createReportConfig() {
        createMarket();
        List <Report_Config__c> rptCfg = new List <Report_Config__c>();
        Report_Config__c cfg;
        cfg = new Report_Config__c( Name='Test Report',Market__c=this.market.id,
                                    Report_Type__c='Test1',Order_Criteria__c='Personal_Sales__r.AWRD_SLS_AMT__c>0',
                                    Report_Id__c='R01',Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='Representative__r.LOA_NR__c'+'\n'+'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c ='1;2;3',Report_Sequence__c = 1);
        rptCfg.add(cfg);
        cfg = new Report_Config__c( Name='Test Report',Market__c=this.market.id,
                                    Report_Type__c='Test2',Rep_Criteria__c='Representative__r.LOA_NR__c !=null',
                                    Report_Id__c='R02',Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='Representative__r.LOA_NR__c'+'\n'+'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c ='1;2;3',Report_Sequence__c = 2);
        rptCfg.add(cfg);
        cfg = new Report_Config__c( Name='Test Report',Market__c=this.market.id,
                                    Report_Type__c='Test3',Ldr_Smry_Criteria__c='Group_Sales__r.TOTAL_TAR_CNT__c',
                                    Report_Id__c='R03',Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='Representative__r.LOA_NR__c'+'\n'+'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c ='1;2;3',Report_Sequence__c = 3);
        rptCfg.add(cfg);
        cfg = new Report_Config__c( Name='Test Report',Market__c=this.market.id,
                                    Report_Type__c='Orders_below_Minimum',Ldr_Smry_Criteria__c='',
                                    Report_Id__c='R04',Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='Representative__r.LOA_NR__c'+'\n'+'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c ='1;2;3',Report_Sequence__c = 4);
        rptCfg.add(cfg);

        cfg = new Report_Config__c( Name='Test Report',Market__c=this.market.id,
                                    Report_Type__c='Orders_at_Minimum',Ldr_Smry_Criteria__c='',
                                    Report_Id__c='R05',Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='Representative__r.LOA_NR__c'+'\n'+'Personal_Sales__r.BAL_DUE_AMT__c',
                                    Default_Sort__c='Representative__r.LOA_NR__c', TITL_LVL_NBR__c ='1;2;3',Report_Sequence__c = 5);

        rptCfg.add(cfg);
                            
        cfg = new Report_Config__c( Name='Test Report', Market__c=this.market.id,
                                    Report_Type__c='New_Rep', Ldr_Smry_Criteria__c='',
                                    Report_Id__c='R06', Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='', Default_Sort__c='', Include_Recruits__c=false,
                                    Include_Removed_Reps__c=true, Order_Criteria__c='LOA_NR__c asc, PRSNL_SLS_AMT__c desc',
                                    TITL_LVL_NBR__c ='1', Page_Size__c = 1, Dowload_Limit__c = 100, Number_of_Historical_Cmpgns_for_Filter__c = 2,
                                    Report_URL__c='https://www.testRep.com',Report_Sequence__c = 6);
         rptCfg.add(cfg);
                            
         cfg=new  Report_Config__c( Name='Top Seller', Market__c=this.market.id,
                                    Report_Type__c='Top_Seller', Ldr_Smry_Criteria__c='',
                                    Report_Id__c='R07', Applicable_To__c='Avon Leader',
                                    Columns_To_Display__c='', Default_Sort__c='', Include_Recruits__c=false,
                                    Include_Removed_Reps__c=true, Order_Criteria__c='PRSNL_SLS_AMT__c Desc',
                                    TITL_LVL_NBR__c ='0;1;2;3;4;5', Page_Size__c = 1, Dowload_Limit__c = 100,Report_Sequence__c = 7); 
        rptCfg.add(cfg);
        insert rptCfg;
            
        List <Report_Column_New__c> rptColumns = new List <Report_Column_New__c>();
        Report_Column_New__c column;
        column = new Report_Column_New__c( Name='Account number', Fully_Qualified_Name__c='MRKT_ACCT_KEY__r.ACCT_NR__c',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.ACCT_NR__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 3, is_hidden__c = false, CurrencyIsoCode = 'USD', Column_Group_Name__c = 'Personal Information');

        rptColumns.add(column);

        column = new Report_Column_New__c( Name='Anniversary', Fully_Qualified_Name__c='MRKT_ACCT_KEY__r.REP_APPT_DT__c',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.REP_APPT_DT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 11, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);

        column = new Report_Column_New__c( Name='Badge Title', Fully_Qualified_Name__c='LDRSHP_TITL_LVL_NR__c',
                                          Fully_Qualified_Name2__c = 'LDRSHP_TITL_LVL_NR__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 12, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);   

        column = new Report_Column_New__c( Name='Birthday', Fully_Qualified_Name__c='MRKT_ACCT_KEY__r.REP_BRTH_DT__c',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.REP_BRTH_DT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 10, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);  

        column = new Report_Column_New__c( Name='Branch Name', Fully_Qualified_Name__c='BRNCH_SCTN_CD__c',
                                          Fully_Qualified_Name2__c = 'BRNCH_SCTN_CD__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 7, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column); 

        column = new Report_Column_New__c( Name='LDRSHP_TITL_LVL_NR__c', Fully_Qualified_Name__c='LDRSHP_TITL_LVL_NR__c',
                                          Fully_Qualified_Name2__c = 'LDRSHP_TITL_LVL_NR__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 14, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column); 

        column = new Report_Column_New__c( Name='Current Campaign Brochure', Fully_Qualified_Name__c='GRP_BRCHR_CNT__c',
                                          Fully_Qualified_Name2__c = 'BRCHR_CNT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 20, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);

        column = new Report_Column_New__c( Name='Customer Served', Fully_Qualified_Name__c='LOA_1_6_CUST_CNT__c',
                                          Fully_Qualified_Name2__c = 'CUST_CNT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 21, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column); 

        column = new Report_Column_New__c( Name='First, Last Name', Fully_Qualified_Name__c='MRKT_ACCT_KEY__r.LastName,MRKT_ACCT_KEY__r.FirstName',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.LastName,MRKT_ACCT_KEY__r.FirstName', Width__c=50, 
                                          Visibility__c = 'Always Displayed', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 2, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);   

        column = new Report_Column_New__c( Name='Generation', Fully_Qualified_Name__c='ACCT_NR__c',
                                          Fully_Qualified_Name2__c = 'Genealogy_Level__c', Width__c=50, 
                                          Visibility__c = 'Always Displayed', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 1, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);   

        column = new Report_Column_New__c( Name='LOA', Fully_Qualified_Name__c='LDRSHP_LOA_NR__c',
                                          Fully_Qualified_Name2__c = 'LOA_NR__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 6, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column); 
       
        column = new Report_Column_New__c( Name='PC1_INVC_AWRD_SLS_AMT__c', Fully_Qualified_Name__c='PC1_INVC_AWRD_SLS_AMT__c',
                                          Fully_Qualified_Name2__c = 'PC1_INVC_AWRD_SLS_AMT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 13, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);  
        
        
        column = new Report_Column_New__c( Name='BOOK1_GRP_UNIT_SLS_AMT__c', Fully_Qualified_Name__c='BOOK1_GRP_UNIT_SLS_AMT__c',
                                          Fully_Qualified_Name2__c = 'BOOK1_GRP_UNIT_SLS_AMT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 13, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column); 
        column = new Report_Column_New__c( Name='PRSNL_SLS_AMT__c', Fully_Qualified_Name__c='PRSNL_SLS_AMT__c',
                                          Fully_Qualified_Name2__c = 'PRSNL_SLS_AMT__c', Width__c=50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 13, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);         
                              
        
        insert rptColumns;   

        List <Report_Filter__c> rptFiltrs = new List <Report_Filter__c>();
        Report_Filter__c repFilter;

        repFilter = new Report_Filter__c(Name = 'LOA (1-6)', CurrencyIsoCode = 'USD',
                                         Filter_Criteria__c = 'LDRSHP_LOA_NR__c <=6 AND AVON_LOA_1_6_IND__c = \'Y\'',
                                         Filter_Key__c = 'LOA (1-6)', Report_Config__c = rptCfg[5].Id);

        rptFiltrs.add(repFilter);
        
        repFilter = new Report_Filter__c(Name = 'LOA (1-6)', CurrencyIsoCode = 'USD',
                                         Filter_Criteria__c = 'LDRSHP_LOA_NR__c <=6 AND AVON_LOA_1_6_IND__c = \'Y\'',
                                         Filter_Key__c = 'LOA_0_6', Report_Config__c = rptCfg[5].Id);

        rptFiltrs.add(repFilter);
                        

        repFilter = new Report_Filter__c(Name = 'LOA 1', CurrencyIsoCode = 'USD',
                                         Filter_Criteria__c = 'LDRSHP_LOA_NR__c =1 AND AVON_LOA_1_6_IND__c = \'Y\'',
                                         Filter_Key__c = 'LOA 1', Report_Config__c = rptCfg[5].Id);

        rptFiltrs.add(repFilter);
        insert rptFiltrs;

        return rptCfg;
    }    
    
    public User createMarketAdminUser(String acctNbr){
	    createMarket();
	    User usr = createUser(acctNbr,'XZ1','Avon Market Administrator');
	    return usr;     
	}
           
    public void createGenealogyData(String acctNbr, String ownrId){
        createGenealogyData(acctNbr, ownrId,4);
    }
    
    // Method to create Genealogy records
    public void createGenealogyData(String acctNbr, String ownrId, Integer noOfLevels) {
         
        //variable declarations for tree traversal 
        //we start with first level with zeroth level being the root.
        Integer level=1;
        Integer noOfNodes=0;
        Integer leftValue=2;
        Integer rightValue;
        Integer increment;
        
        //Create 2^noOfLevels account numbers
        List <String> accntNumbers=new List <String>();
        for (Integer accntNrIndex=0;accntNrIndex <(Math.pow(2,noOfLevels)-1);accntNrIndex++) {
           accntNumbers.add(acctNbr + '_' + accntNrIndex);
        }
         
          // Matt changed from using 'xx' to using a generic market
        Market__c currentMarket=createMarket('999');
         
        Contact leaderContact=createContact(acctNbr, ownrId);
        //create the list of contacts other than the leader
        List <Contact> lstContact = createListContact(accntNumbers, ownrId);
         
        SObject repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
        repPerformanceInstance.put('Name','Test Rep1');
        repPerformanceInstance.put('ACCT_NR__c',acctNbr);
        repPerformanceInstance.put('Genealogy_Level__c',0);
        repPerformanceInstance.put('CurrencyISOCode','USD');
        repPerformanceInstance.put('MRKT_ID__c',this.market.Market_Id__c);
        repPerformanceInstance.put('MRKT_ACCT_KEY__c',leaderContact.Id);
        //repPerformanceInstance.put('CurrencyISOCode','ISO');
        repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(this.market.CMPGN_NR__c));
        repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',this.market.CMPGN_NR__c);
        repPerformanceInstance.put('Personal_Performance_Key__c',this.market.Market_Id__c + this.market.CMPGN_NR__c + acctNbr);
        repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1');
        repPerformanceInstance.put('AVON_LOA_1_6_IND__c','Y');
        repPerformanceInstance.put('LDRSHP_LOA_NR__c',1);
        repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1');
        repPerformanceInstance.put('ALL_DWNLN_CNT__c',5);
        repPerformanceInstance.put('LFT_ND_ID__c',1);
        repPerformanceInstance.put('RGT_ND_ID__c',(Math.pow(2,(noOfLevels+1))-2));
          
        insert repPerformanceInstance;
        
        //initialize the list to store the list of rep performance records to be inserted for entities other than leader
        repPerfData=new List<SObject>();
        
        //compute the increment for all levels
        Map <Integer,List <Integer>> incForAllLevels=computeIncforLevels(noOfLevels);
        
        
        //create the rep performance records for every node in the tree
        for (Integer accntNrIndex=0;accntNrIndex<Math.pow(2,noOfLevels)-2;accntNrIndex++) {
        	//the level is finished, increment level and reset noOfNodes
            
            Integer lftRgtDifference=computerPowerSum((noOfLevels+1)-level);
            rightValue=leftValue+lftRgtDifference;
            
            String downloadOnlyInd = Math.mod(accntNrIndex, 2) ==0?'Y':'N';
            
            repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
            repPerformanceInstance.put('Name','Test Rep1');
            repPerformanceInstance.put('ACCT_NR__c',acctNbr+'_'+accntNrIndex);
            repPerformanceInstance.put('Genealogy_Level__c',0);
            repPerformanceInstance.put('CurrencyISOCode','USD');
            repPerformanceInstance.put('MRKT_ID__c',this.market.Market_Id__c);
            repPerformanceInstance.put('MRKT_ACCT_KEY__c',lstContact[accntNrIndex].Id);
            //repPerformanceInstance.put('CurrencyISOCode','ISO');
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(this.market.CMPGN_NR__c));
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',this.market.CMPGN_NR__c);
            repPerformanceInstance.put('Personal_Performance_Key__c',this.market.Market_Id__c + this.market.CMPGN_NR__c + acctNbr+'_'+accntNrIndex);
            repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1');
            repPerformanceInstance.put('DWNLN_ONLY_IND__c', downloadOnlyInd);
            repPerformanceInstance.put('AVON_LOA_1_6_IND__c','Y');
            repPerformanceInstance.put('LDRSHP_LOA_NR__c',1);
            repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1');
            repPerformanceInstance.put('LFT_ND_ID__c',leftValue);
            repPerformanceInstance.put('RGT_ND_ID__c',rightValue);
                
            repPerfData.add(repPerformanceInstance);                            
	        //compute the next left value based on the increment map
	        System.debug('===level====' + level + '====noOfNodes===' +noOfNodes);
	        System.debug('===accntNrIndex====' + accntNrIndex);
             
            if (noOfNodes==(math.pow(2,level))-1) {
                    level++;
                    noOfNodes=0;
                    leftValue=level+1;
            } else {
                increment=incForAllLevels.get(level).get(noOfNodes);
                leftValue=rightValue + increment;
                noOfNodes++;
            }
        }
        //Insert list of all rep performance data                                   
        insert repPerfData;                         
    } // End of method
    
    //Added by Snehashis
  	public List <Contact> createListContact(List<String> acctNbrLst, String ownerId) {
	    createMarket();
	    createLeaderTitles();
	    createSellerStatus();
	    createAccount();
	    this.testContactLst=new List<Contact>();
	    system.debug('this.testAcct: ' + this.testContactLst);
        if (this.testContactLst == null || this.testContactLst.size()<=0) {
            system.debug('this.testAcct: ' + this.testAcct);
            //system.debug('acctNbr: ' + acctNbr);  
            for (String acct: acctNbrLst) {
                 Contact cont = new Contact(  AccountId=this.testAcct.Id,
                                             ACCT_NR__c=acct,
                                            Email='test@avon.com',FirstName=acct+'First',LastName=acct+'Last',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                          //  LOA_NR__c=15,
                                            MRKT_ACCT_KEY__c=this.market.Market_Id__c+acct,MRKT_ID__c=this.market.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789'
                                            ,OwnerId=ownerId
                                          );
                  this.testContactLst.add(cont);
            }          
            insert this.testContactLst;
        }
        return this.testContactLst;
    }      
            
    public void createRepPerformance(List <String> ppKeys, String mktId, String ownerId) {
                
        Market__c currentMarket=createMarket();
        List <SObject> repPerformance = new List <SObject>();
        if (testContactLst.size()==ppKeys.size()) {
            for (Contact ct : testContactLst) {
            	for (String k: ppKeys) {
                    //My Business
                	SObject repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
                   
                    repPerformanceInstance.put('Name','Test MyBusiness') ;
                    repPerformanceInstance.put('Personal_Performance_Key__c',ct.id) ;
                    repPerformanceInstance.put('PRSNL_DSCNT_AMT__c',1) ;
                    repPerformanceInstance.put('MRKT_ID__c',mktId) ;
                    repPerformanceInstance.put('GENRTN_1_QPA_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_APPT_CNT__c',1) ;
                    repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(k.substring(2,8))) ;
                    repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',k.substring(2,8)) ;
                    repPerformanceInstance.put('FRST_ORDR_AMT__c',1) ;
                    repPerformanceInstance.put('EXEC_ERNGS_AMT__c',1) ;
                    repPerformanceInstance.put('BONUS_ERNGS_AMT__c',1) ;
                    repPerformanceInstance.put('AVG_ORD_SIZE_AMT__c',1) ;
                    repPerformanceInstance.put('AVG_GENRTN_3_UNIT_COMM_PCT__c',1) ;
                    repPerformanceInstance.put('AVG_GENRTN_3_DISTR_SLS_PCT__c',1) ;
                    repPerformanceInstance.put('AVG_GENRTN_2_UNIT_COMM_PCT__c',1) ;
                    repPerformanceInstance.put('AVG_GENRTN_2_UNIT_COMM_PCT__c',1) ;
                    repPerformanceInstance.put('REP_OMS_STUS_CD__c','1') ;
                    
                    repPerformanceInstance.put('GENTRTN_1_ACTV_REP_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TOTAL_NEW_EXEC_TITL_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_9_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_9_NEW_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_8_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_8_NEW_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_7_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_7_NEW_STF_CNT__c',1) ;
                     repPerformanceInstance.put('GENRTN_1_TITL_6_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_6_NEW_STF_CNT__c',1) ; 
                    repPerformanceInstance.put('GENRTN_1_TITL_5_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_5_NEW_STF_CNT__c',1) ; 
                    repPerformanceInstance.put('GENRTN_1_TITL_4_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_4_NEW_STF_CNT__c',1) ; 
                    repPerformanceInstance.put('GENRTN_1_TITL_3_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_3_NEW_STF_CNT__c',1) ; 
                    repPerformanceInstance.put('GENRTN_1_TITL_2_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_2_NEW_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_1_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_TITL_1_NEW_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_STF_CNT__c',1) ;
                    repPerformanceInstance.put('GENRTN_1_STF_CNT__c',1) ;
                    repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1') ;// added by ag
                    repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(k.substring(2,8))) ;
                    repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',k.substring(2,8)) ;
                    repPerformanceInstance.put('ACCT_NR__c',k.substring(8,k.length()));
                    repPerformanceInstance.put('GENRTN_1_ACT_PCT__c',1) ;
                    repPerformanceInstance.put('MRKT_ACCT_KEY__c',ct.id) ;
                    repPerformanceInstance.put('LDRSHP_LOA_NR__c',1) ;
                    
                    repPerformance.add(repPerformanceInstance);
                } 
            }
        }
        insert repPerformance;
    }
            
    //This method is used to create self(testContact) ALMRepPerf Records.
     public void createMulRepPerformance(List <String> ppKeys, String mktId, String ownerId) {
        Market__c currentMarket=createMarket();
        List <SObject> repPerformance = new List <SObject>();
         for (String k: ppKeys) {
            //My Business
         	SObject repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
            repPerformanceInstance.put('Name','Test MyBusiness'+k) ;
            repPerformanceInstance.put('Personal_Performance_Key__c',k) ;
            repPerformanceInstance.put('PRSNL_DSCNT_AMT__c',1) ;
            repPerformanceInstance.put('MRKT_ID__c',mktId) ;
            repPerformanceInstance.put('GENRTN_1_QPA_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_APPT_CNT__c',1) ;
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(k.substring(2,8))) ;
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',k.substring(2,8)) ;
            repPerformanceInstance.put('FRST_ORDR_AMT__c',1) ;
            repPerformanceInstance.put('EXEC_ERNGS_AMT__c',1) ;
            repPerformanceInstance.put('BONUS_ERNGS_AMT__c',1) ;
            repPerformanceInstance.put('AVG_ORD_SIZE_AMT__c',1) ;
            repPerformanceInstance.put('AVG_GENRTN_3_UNIT_COMM_PCT__c',1) ;
            repPerformanceInstance.put('AVG_GENRTN_3_DISTR_SLS_PCT__c',1) ;
            repPerformanceInstance.put('AVG_GENRTN_2_UNIT_COMM_PCT__c',1) ;
            repPerformanceInstance.put('AVG_GENRTN_2_UNIT_COMM_PCT__c',1) ;
            repPerformanceInstance.put('REP_OMS_STUS_CD__c','1') ;
            
            repPerformanceInstance.put('GENTRTN_1_ACTV_REP_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TOTAL_NEW_EXEC_TITL_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_9_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_9_NEW_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_8_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_8_NEW_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_7_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_7_NEW_STF_CNT__c',1) ;
             repPerformanceInstance.put('GENRTN_1_TITL_6_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_6_NEW_STF_CNT__c',1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_5_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_5_NEW_STF_CNT__c',1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_4_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_4_NEW_STF_CNT__c',1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_3_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_3_NEW_STF_CNT__c',1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_2_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_2_NEW_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_1_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_1_NEW_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_STF_CNT__c',1) ;
            repPerformanceInstance.put('GENRTN_1_STF_CNT__c',1) ;
            repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1') ;// added by ag
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(k.substring(2,8))) ;
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',k.substring(2,8)) ;
            repPerformanceInstance.put('ACCT_NR__c',k.substring(8,k.length()));
            repPerformanceInstance.put('GENRTN_1_ACT_PCT__c',1) ;
            repPerformanceInstance.put('MRKT_ACCT_KEY__c',testContact.id) ;
            repPerformanceInstance.put('LDRSHP_LOA_NR__c',1) ;
            repPerformance.add(repPerformanceInstance);
		} 
        insert repPerformance;
    }
            
    public void createRepPerformance(List<String> ppKeys, String mktId) {
        createRepPerformance(ppKeys, mktId, null);
    }
    
    private Integer computerPowerSum(Integer endPower) {
        return Integer.valueOf((Math.pow(2,endPower))-3);
    }
            
    private Map <Integer,List <Integer>> computeIncforLevels(Integer noOfLevels) {
        Map <Integer,List <Integer>> incForAllLevels=new Map <Integer,List <Integer>>();
        List <Integer> prevLevelIncs=new List <Integer>();
        List <Integer> currentLevelIncs=new List <Integer>();
        Integer currentLevelValue;
        // 0 - Root, 1 - it is always 1, we compute from level 2 onwards
        for (Integer i=1;i<noOfLevels;i++) {
            //initialize current every time
            currentLevelIncs=new List<Integer>();
            currentLevelValue=(2*(i-1))+1;
            currentLevelIncs.addAll(prevLevelIncs);
            currentLevelIncs.add(currentLevelValue);
            currentLevelIncs.addAll(prevLevelIncs);
            //populate the map for the current level
            incForAllLevels.put(i,currentLevelIncs);
            prevLevelIncs=currentLevelIncs;
        }
        return incForAllLevels;
    }
    
    public static Group createMarketQueue(String queueName) {                
        Group queue = new Group();
        queue.Name = queueName;     
        queue.Type = 'Queue';
        insert queue;
        List <QueueSobject> qsoList = new List <QueueSobject>();
        qsoList.add(new QueueSobject(SobjectType = 'Geo_Level_1__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'Geo_Level_2__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'Geo_Level_3__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'Geo_Level_4__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'User_History__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'User_History__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'Geo_to_Zone_Mapping__c', QueueId = queue.Id));
        qsoList.add(new QueueSobject(SobjectType = 'Lead', QueueId = queue.Id));
        insert qsoList;
        
        return queue;
    }
    
    public MailPlan_Order_Oppty__c creatMailPlans(Market__c mrkt, String zone) {
        createMarket();
        
        //mplans
        MailPlan_Order_Oppty__c mpOrdOppty1 = new MailPlan_Order_Oppty__c(MRKT_ID__c = mrkt.Market_Id__c, CMPGN_NR__c = mrkt.CMPGN_NR__c.substring(mrkt.CMPGN_NR__c.length() -2),
                                                                          SLS_ZONE_CD__c = zone, CurrencyISOCode='USD', MLPLN_CLOSD_IND__c = 'N',
                                                                          MLPLN_END_DT__c = System.today(), Market__c = mrkt.Id, NEXT_MLPLN_TO_CLOS_CD__c = 'A, B');
                                                                          
        insert  mpOrdOppty1; 
        
        return mpOrdOppty1;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createGenealogy
    // Description  : Create and Insert Object : 
    //---------------------------------------------------------------------------
    public void createGenealogy(String accountNumber, String ownerId, String accountId, Integer noOfLevels) {
         
        //variable declarations for tree traversal. We start with first level with zeroth level being the root.
        Integer level = 1;
        Integer noOfNodes = 0;
        Integer leftValue = 2;
        Integer rightValue;
        Integer increment;
        
        //Create 2^noOfLevels account numbers
        List <String> accntNumbers = new List <String>();
        for (Integer accntNrIndex = 0; accntNrIndex < (Math.pow(2, noOfLevels) - 1); accntNrIndex++) {
           accntNumbers.add(accountNumber + '_' + accntNrIndex);
        }
         
        Market__c currentMarket = TestDataHelper.createMarket('Test Market DW 3', 'DW', false);
        currentMarket.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        insert currentMarket;
        
         
        Contact leaderContact = TestDataHelper.createContact(accountId, 'Test DW', 'USD', false);//createContact(accountNumber, ownerId);
        //create the list of contacts other than the leader
        List <Contact> lstContact = createListContact(accntNumbers, ownerId);
         
        SObject repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
        repPerformanceInstance.put('Name','Test Rep1');
        repPerformanceInstance.put('ACCT_NR__c',accountNumber);
        repPerformanceInstance.put('Genealogy_Level__c',0);
        repPerformanceInstance.put('CurrencyISOCode','USD');
        repPerformanceInstance.put('MRKT_ID__c',this.market.Market_Id__c);
        repPerformanceInstance.put('MRKT_ACCT_KEY__c',leaderContact.Id);
        //repPerformanceInstance.put('CurrencyISOCode','ISO');
        repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(this.market.CMPGN_NR__c));
        repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',this.market.CMPGN_NR__c);
        repPerformanceInstance.put('Personal_Performance_Key__c',this.market.Market_Id__c + this.market.CMPGN_NR__c + accountNumber);
        repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1');
        repPerformanceInstance.put('AVON_LOA_1_6_IND__c','Y');
        repPerformanceInstance.put('LDRSHP_LOA_NR__c',1);
        repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1');
        repPerformanceInstance.put('ALL_DWNLN_CNT__c',5);
        repPerformanceInstance.put('LFT_ND_ID__c',1);
        repPerformanceInstance.put('RGT_ND_ID__c',(Math.pow(2,(noOfLevels+1))-2));
          
        insert repPerformanceInstance;
        
        //initialize the list to store the list of rep performance records to be inserted for entities other than leader
        repPerfData=new List<SObject>();
        
        //compute the increment for all levels
        Map <Integer,List <Integer>> incForAllLevels=computeIncforLevels(noOfLevels);
        
        
        //create the rep performance records for every node in the tree
        for (Integer accntNrIndex=0;accntNrIndex<Math.pow(2,noOfLevels)-2;accntNrIndex++) {
        	//the level is finished, increment level and reset noOfNodes
            
            Integer lftRgtDifference=computerPowerSum((noOfLevels+1)-level);
            rightValue=leftValue+lftRgtDifference;
            
            String downloadOnlyInd = Math.mod(accntNrIndex, 2) ==0?'Y':'N';
            
            repPerformanceInstance=Schema.getGlobalDescribe().get(currentMarket.ALM_Rep_Indicator__c).newSObject() ;
            repPerformanceInstance.put('Name','Test Rep1');
            repPerformanceInstance.put('ACCT_NR__c',accountNumber+'_'+accntNrIndex);
            repPerformanceInstance.put('Genealogy_Level__c',0);
            repPerformanceInstance.put('CurrencyISOCode','USD');
            repPerformanceInstance.put('MRKT_ID__c',this.market.Market_Id__c);
            repPerformanceInstance.put('MRKT_ACCT_KEY__c',lstContact[accntNrIndex].Id);
            //repPerformanceInstance.put('CurrencyISOCode','ISO');
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(this.market.CMPGN_NR__c));
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',this.market.CMPGN_NR__c);
            repPerformanceInstance.put('Personal_Performance_Key__c',this.market.Market_Id__c + this.market.CMPGN_NR__c + accountNumber+'_'+accntNrIndex);
            repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1');
            repPerformanceInstance.put('DWNLN_ONLY_IND__c', downloadOnlyInd);
            repPerformanceInstance.put('AVON_LOA_1_6_IND__c','Y');
            repPerformanceInstance.put('LDRSHP_LOA_NR__c',1);
            repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1');
            repPerformanceInstance.put('LFT_ND_ID__c',leftValue);
            repPerformanceInstance.put('RGT_ND_ID__c',rightValue);
                
            repPerfData.add(repPerformanceInstance);                            
	        //compute the next left value based on the increment map
	        System.debug('===level====' + level + '====noOfNodes===' +noOfNodes);
	        System.debug('===accntNrIndex====' + accntNrIndex);
             
            if (noOfNodes==(math.pow(2,level))-1) {
                    level++;
                    noOfNodes=0;
                    leftValue=level+1;
            } else {
                increment=incForAllLevels.get(level).get(noOfNodes);
                leftValue=rightValue + increment;
                noOfNodes++;
            }
        }
        //Insert list of all rep performance data                                   
        insert repPerfData;                         
    }    
    
    //Changes for Task T-189162 Starts
    //---------------------------------------------------------------------------
    // Method Name  : createAccount
    // Description  : Create and Insert Object : Account
    //---------------------------------------------------------------------------    
    public static Account createAccount(String accountName, String currencyCode, boolean isInsert) {
        Account acc = new Account();
        acc.Name = accountName;
        acc.currencyIsoCode = currencyCode;
        
        if (isInsert) {
            insert acc;         
        }
        return acc;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createContact
    // Description  : Create and Insert Object : Contact
    //---------------------------------------------------------------------------    
    public static Contact createContact(String accountId, String lastName, String contactCurrency, boolean isInsert) {
        Contact con = new Contact();
        con.AccountId = accountId;
        con.lastName = lastName;
        con.currencyIsoCode = contactCurrency;
        if (isInsert) {
            insert con;         
        }
        return con;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createALMRepPerformance
    // Description  : Create and Insert Object : ALM_Rep_Performance_1__c
    //---------------------------------------------------------------------------
    public static ALM_Rep_Performance_1__c createALMRepPerformance(String performanceName, String contactId, String personalPerformanceKey, boolean isInsert) {
    	ALM_Rep_Performance_1__c almRepPerformance = new ALM_Rep_Performance_1__c();
    	almRepPerformance.Name = performanceName;
    	almRepPerformance.MRKT_ACCT_KEY__c = contactId;
    	almRepPerformance.Personal_Performance_Key__c = personalPerformanceKey;
    	if (isInsert) {
            insert almRepPerformance;         
        }
        return almRepPerformance;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createUser
    // Description  : Create and Insert Object : User
    //---------------------------------------------------------------------------
    public static User createUser(String userNo, String profileId, Boolean isInsert) {
    	User user = new User();
        user.FirstName = 'test';
        user.LastName = 'user' + userNo;
        user.Email = 'test' + userNo + '@testdomain.com';
        user.Username = 'test' + userNo + '@testdomain.comtestuser';
        user.ProfileId = profileId;
        user.Alias = 'test' + userNo;
        user.CommunityNickname = 'testusr' + userNo;
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US'; 
        user.Phone = '+9009899900';
        user.isActive = true;
        user.GI3_EMAIL__c = user.Email;
        if(isInsert) {
          insert user;
        }
        return user;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarket
    // Description  : Create and Insert Object : Market__c
    //---------------------------------------------------------------------------
    public static Market__c createMarket(String marketName, String marketId, boolean isInsert) {
    	Market__c mark = new Market__c();
    	mark.Name = marketName;
    	mark.Market_Id__c = marketId;
    	if (isInsert) {
    		insert mark;
    	}    	
    	return mark;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSalesOrSummaries
    // Description  : Create and Insert Object : Sales_Org_Summary__c
    //---------------------------------------------------------------------------
    public static Sales_Org_Summary__c createSalesOrSummaries(String salesName, String zoneManagerId, String marketID, 
    									String salesOrgSmryKey, String oprCampaignNumber, boolean isInsert) {
    	Sales_Org_Summary__c salesOrgSummary = new Sales_Org_Summary__c(Name = salesName,
    																	ZONE_MGR__c = zoneManagerId,
    																	MRKT_KEY__c = marketID,
    																	OPERTNL_CMPGN_NR__c = oprCampaignNumber,
    																	FLD_SLS_CMPGN_NR__c = oprCampaignNumber,
    																	SLS_ORG_SUMRY_KEY__c = salesOrgSmryKey,
    																	CurrencyIsoCode = 'USD',
    																	ACTV_REP_CNT__c = 300, 
    																	UPR_CNT__c = 8,    																	
    																	SLS_ORG_LVL_DESC_TXT__c = 'Z',  
    																	SLS_ORG_DESC_TXT__c = '201', 
        									   							TITLD_STF_CNT__c = 8,
        									   							RTURN_NET_SLS_PLAN_SPPY_AMT__c = 1550.00,
        									   							TITL_0_STF_CNT__c = 8,
						        									    UPR_DIV_RNK_CNT__c = 100,
						        									    RNSTMT_DIV_RNK__c = 100,
						        									    UPR_PLAN_SPPY_CNT__c = 9,
						        									    RMOVL_PLAN_CNT__c = 6, 
						        									   	LOA_1_6_NET_SLS_DIV_RNK__c = 100,
						        									   	RTURN_NET_SLS_AMT__c = 1500.00,
						        									   	RMOVL_SPPY_CNT__c = 8, 
						        									    LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c = 1000.00,
						        									    RMOVL_PLAN_SPPY_CNT__c = 8,
						        									    NET_SLS_SPPY_AMT__c = 1555000.00,
						        									    LOA_1_6_NET_SLS_SPPY_AMT__c = 1000.00, 
						        									    RNSTMT_PLAN_CNT__c = 5,
						        									    RMOVL_CNT__c = 9,
						        									    TITLD_STF_DIV_RNK__c = 100,
						        									    RNSTMT_CNT__c = 2,   
						        									    ACTV_REP_PLAN_SPPY_CNT__c = 1500,
						        									    NET_SLS_DIV_RNK__c = 100,
						        									    TITL_0_STF_PLAN_SPPY_CNT__c = 9,  
						        									    APPT_CNT__c = 9,
						        									    TITL_0_STF_PLAN_CNT__c = 9,
						        									    TITL_0_STF_DIV_RNK__c = 100,
						        									    LOA_1_6_NET_SLS_AMT__c = 30000.00, 
						        									    UPR_PLAN_CNT__c = 9,						        									    
						        									    ACTV_REP_DIV_RNK__c = 100, 
						        									    RNSTMT_SPPY_CNT__c = 7,
						        									    LOA1_NET_SLS_DIV_RNK__c = 100,
						        									    ACTV_REP_SPPY_CNT__c = 1600, 
						        									    LOA1_NET_SLS_AMT__c = 1000.00,
						        									    RMOVL_DIV_RNK__c = 100,
						        									    LOA1_NET_SLS_SPPY_AMT__c = 1000.00, 
						        									    NET_SLS_PLAN_SPPY_AMT__c = 1555000.00,
						        									    LOA1_NET_SLS_PLAN_SPPY_AMT__c = 1000.00, 
						        									    TITLD_STF_SPPY_CNT__c = 9,
						        									    TITL_0_STF_SPPY_CNT__c = 9,
						        									    APPT_DIV_RNK__c = 100,
						        									    UPR_SPPY_CNT__c = 9, 
						        									    APPT_PLAN_CNT__c = 12,
						        									    LOA_1_6_NET_SLS_PLAN_AMT__c = 322000.00,
						        									    RTURN_NET_SLS_DIV_RNK__c = 100, 
						        									    Analysis_Done__c = false,
						        									    RTURN_NET_SLS_SPPY_AMT__c = 1550.00,
						        									    APPT_PLAN_SPPY_CNT__c = 15, 
						        									    NET_SLS_PLAN_AMT__c = 500000.00,
						        									    RNSTMT_PLAN_SPPY_CNT__c = 7,
						        									    APPT_SPPY_CNT__c = 15, 
						        									    ACTV_REP_PLAN_CNT__c = 200,
						        									    LOA1_NET_SLS_PLAN_AMT__c = 100000.00,
						        									    TITLD_STF_PLAN_SPPY_CNT__c = 9, 
						        									    RTURN_NET_SLS_PLAN_AMT__c = 1500.00,
						        									    TITLD_STF_PLAN_CNT__c = 9,
						        									    TITL_0_STF_TAR_LAST_CMPGN_CNT__c = 15,
																		APPT_FRCST_CNT__c = 9, 
																		APPT_LCA_CNT__c = '10',
																		APPT_My_Actions_CNT__c = '15');
    	if (isInsert) {
    		insert salesOrgSummary;
    	}
    	
    	return salesOrgSummary;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createCustomMessages
    // Description  : Obtain List of Objects : Custom_Message__c
    //---------------------------------------------------------------------------
    public static void createCustomMessages(Market__c mrkt, String ownerId) {
        List <Custom_Message__c> listMessages = new List <Custom_Message__c>();
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_view_my_orders', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_titled', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ri_earned_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ri_earned_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_toreach_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_toreach_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'li_needed_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'li_needed_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        
        insert listMessages;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createCustomMessage
    // Description  : Create and Insert Object : Custom_Message__c
    //---------------------------------------------------------------------------
    public static Custom_Message__c createCustomMessage(String ownerId, String messageName, String componentName, String langCD, String marketId, String messageText, 
    													 String slTitle, String userType, boolean isInsert) {
    	Custom_Message__c customMessage = new Custom_Message__c();
    	customMessage.OwnerId = ownerId;
    	customMessage.Message_Name__c = messageName;
    	customMessage.Component_Name_Picklist__c = componentName;
    	customMessage.LANG_CD__c = langCD;
    	customMessage.Market__c = marketId;
    	customMessage.Message_Text__c = messageText;
    	customMessage.SL_Title__c = slTitle;
    	customMessage.User_Type__c = userType;
    	
    	if (isInsert) {
    		insert customMessage;
    	}
    	return customMessage;    	
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createTopSellet
    // Description  : Create List of Objects : Seller_Status__c
    //---------------------------------------------------------------------------    
    public static void createTopSellet(Market__c mrkt, String ownerId) {
        List <Seller_Status__c> listTopSeller = new List <Seller_Status__c>();
        listTopSeller.add(new Seller_Status__c(CYCLE_NR_OF_CMPGNS__c = 100, CTD_MIN_REQ_AWRD_SLS_AMT__c = 20, LANG_CD__c = 'en_US', Market__c = mrkt.Id, MRKT_ID__c = mrkt.Market_Id__c, MRKT_TOP_SLR_LANG_KEY__c = 'TTTTT1' ));
        insert listTopSeller;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSellerStatus
    // Description  : Create and Insert Object : Seller_Status__c
    //---------------------------------------------------------------------------
    public static Seller_Status__c createSellerStatus(Decimal cycleNRCampaign, Decimal ctdMinAwardSalesAmt, String langCD, String marketId, 
    												  String markMarketId, String marketTopSellerKey, boolean isInsert) {
    	Seller_Status__c sellerStatus = new Seller_Status__c();
    	sellerStatus.CYCLE_NR_OF_CMPGNS__c = cycleNRCampaign;
    	sellerStatus.CTD_MIN_REQ_AWRD_SLS_AMT__c = ctdMinAwardSalesAmt;
    	sellerStatus.LANG_CD__c = langCD;
    	sellerStatus.Market__c = marketId;
    	sellerStatus.MRKT_ID__c = markMarketId;
    	sellerStatus.MRKT_TOP_SLR_LANG_KEY__c = marketTopSellerKey;
    	
    	if (isInsert) {
    		insert sellerStatus;
    	}
    	
    	return sellerStatus;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLandingPageConfig
    // Description  : Create List of Objects : Landing_Page_Config__c
    //---------------------------------------------------------------------------
    public static void createLandingPageConfig(Market__c mrkt) {
    	Landing_Page_Config__c lPgConfig = new Landing_Page_Config__c(Market__c = mrkt.Id, Title_Level_Number__c = 'All', User_Type__c = 'All');
    	insert lPgConfig;
    	
    	List <Landing_Page_Component__c> lstLPgComp = new List <Landing_Page_Component__c> ();
    	
    	Landing_Page_Component__c g1SalesLeader = new Landing_Page_Component__c(Landing_Page_Config__c = lPgConfig.Id,VF_Page_Name__c = 'G1SalesLeaders');
    	lstLPgComp.add(g1SalesLeader);
    	
    	Landing_Page_Component__c g1Candidate = new Landing_Page_Component__c(Landing_Page_Config__c = lPgConfig.Id,VF_Page_Name__c = 'G1Candidates');
    	lstLPgComp.add(g1Candidate);
    	
    	Landing_Page_Component__c risingStar = new Landing_Page_Component__c(Landing_Page_Config__c = lPgConfig.Id,VF_Page_Name__c = 'ELRisingStars');
    	lstLPgComp.add(risingStar);
    	
    	if(lstLPgComp.size() > 0) {
    		insert lstLPgComp;
    	}
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLandingPageConfig
    // Description  : Create and Insert Object : Landing_Page_Config__c
    //---------------------------------------------------------------------------
    public static Landing_Page_Config__c createLandingPageConfig(String marketId, String titleLevelNumber, String userType, boolean isInsert) {
    	Landing_Page_Config__c lPgConfig = new Landing_Page_Config__c();
    	lPgConfig.Market__c = marketId; 
    	lPgConfig.Title_Level_Number__c = titleLevelNumber; 
    	lPgConfig.User_Type__c = userType;
    	
    	if (isInsert) {
    		insert lPgConfig;
    	}
    	
    	return lPgConfig;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLadingPageComponent
    // Description  : Create and Insert Object : Landing_Page_Component__c
    //---------------------------------------------------------------------------
    public static Landing_Page_Component__c createLadingPageComponent(String configId, String pageName, boolean isInsert){
    	Landing_Page_Component__c component = new Landing_Page_Component__c();
    	component.Landing_Page_Config__c = configId;  
    	component.VF_Page_Name__c = pageName;
    	if (isInsert) {
    		insert component;
    	}
    	
    	return component;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMPOrderOpp
    // Description  : Create and Insert Object : MailPlan_Order_Oppty__c
    //---------------------------------------------------------------------------
    public static void createMPOrderOpp(Market__c mrkt) {
    	DateTime d = System.now();
    	d = d.addDays(15);
    	Date mpDate = date.newinstance(d.year(), d.month(), d.day());
    	MailPlan_Order_Oppty__c mpOpp = new MailPlan_Order_Oppty__c(Market__c = mrkt.Id, 
    														CMPGN_NR__c = mrkt.CMPGN_NR__c, 
    														MLPLN_CLOSD_IND__c = 'N', 
    														MLPLN_END_DT__c = mpDate);
    	insert mpOpp;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMPOrderOpp
    // Description  : Create and Insert Object : MailPlan_Order_Oppty__c
    //---------------------------------------------------------------------------
    public static MailPlan_Order_Oppty__c createMPOrderOpp(String marketId, 
    														String markCampaignNumber, 
														    String mlPlanCloseInd, 
														    Date mpDate,
														    boolean isInsert) {
    	MailPlan_Order_Oppty__c mpOpp = new MailPlan_Order_Oppty__c();
    	mpOpp.Market__c = marketId; 
    	mpOpp.CMPGN_NR__c = markCampaignNumber; 
    	mpOpp.MLPLN_CLOSD_IND__c = mlPlanCloseInd; 
    	mpOpp.MLPLN_END_DT__c = mpDate;
    	
    	if (isInsert) {
    		insert mpOpp;
    	}
    	
    	return mpOpp;
    }
    
     //---------------------------------------------------------------------------
    // Method Name  : createMPOrderOpp
    // Description  : Create and Insert Object : MailPlan_Order_Oppty__c
    //---------------------------------------------------------------------------
    public static MailPlan_Order_Oppty__c createMPOrderOpp(String marketId, String markCampaignNumber, String mlPlanCloseInd, 
														   Date mpDate, String nextMlplnCloseCD, String slsZone, String mlplnCD, boolean isInsert) {
    	MailPlan_Order_Oppty__c mpOpp = new MailPlan_Order_Oppty__c();
    	mpOpp.Market__c = marketId; 
    	mpOpp.CMPGN_NR__c = markCampaignNumber; 
    	mpOpp.MLPLN_CLOSD_IND__c = mlPlanCloseInd; 
    	mpOpp.MLPLN_END_DT__c = mpDate;
    	mpOpp.NEXT_MLPLN_TO_CLOS_CD__c = nextMlplnCloseCD;
       	mpOpp.SLS_ZONE_CD__c = slsZone;
        mpOpp.MLPLN_CD__c = mlplnCD;
    	
    	if (isInsert) {
    		insert mpOpp;
    	}
    	
    	return mpOpp;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createOrder
    // Description  : Create and Insert Object : Order_1__c
    //---------------------------------------------------------------------------
    public static Order_1__c createOrder(String orderName, String genealogyKey, String salesOrgSummaryKey, String acctNr, String fieldSalesCampaign, 
    									 String oprCampaign, String orderKey, String orderNumber, Date submittedDate, boolean isInsert) {
    	Order_1__c ord = new Order_1__c();
    	ord.Name = orderName;
    	ord.Genealogy_Key_1__c = genealogyKey;
    	ord.SLS_ORG_SUMRY_KEY__c = salesOrgSummaryKey;
    	ord.ACCT_NR__c = acctNr;
    	ord.FLD_SLS_CMPGN_NR__c = fieldSalesCampaign;
    	ord.OPERTNL_CMPGN_NR__c = oprCampaign;
    	ord.ORD_KEY__c = orderKey;
    	ord.ORD_NR__c = orderNumber;
    	ord.SUBMTD_DT__c = submittedDate;
    	
    	if (isInsert) {
    			insert ord;
    	}
    	
    	return ord;
    }
    
     //---------------------------------------------------------------------------
    // Method Name  : createOrder
    // Description  : Create and Insert Object : Order_1__c
    //---------------------------------------------------------------------------
    public static Order_1__c createOrder(String mktIdKey, Market__c mrkt,
    									String genealogyKey, String sosKey,
    									boolean isInsert) {
    	Order_1__c  ord = new Order_1__c(ACCT_NR__c	= mktIdKey
									,AWRD_SLS_AMT__c	=	100
									,FLD_SLS_CMPGN_NR__c=	mrkt.CMPGN_NR__c
									,HOLD_REASON_CD__c	=	'N'
									,INVC_NR__c			=	'111'
									,MLPLN_CD__c		=	'YY'
									,MRKT_ID__c			=	mrkt.Market_ID__c
									,OPERTNL_CMPGN_NR__c=	mrkt.CMPGN_NR__c
									,SLS_AMT__c			=	100
									,ORD_KEY__c			=	'1111'
									,ORD_NR__c			=	'1111'
									,OPPTY_NR__c		=	'11'
									,STUS_CD__c			=	'2'
									,SUBMTD_DT__c		=	System.Today()
									,ORD_TYP__c			=	'1'
									,SRC_SYS__c			=	'TEST'
									,TRNSCTN_SRC__c		=	'!!!'
									,TRNSCTN_TIME__c    =   DateTime.now()
								    ,Genealogy_Key_1__c = genealogyKey
								    ,SLS_ORG_SUMRY_KEY__c = sosKey);
		
    	if (isInsert) {
    			insert ord;
    	}
    	
    	return ord;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarketShare
    // Description  : Create and Insert Object : Market__Share
    //---------------------------------------------------------------------------
    public static Market__Share createMarketShare(String userId, String rowCause, String parentId, String accessLevel, boolean isInsert) {
    	Market__Share marketShare = new Market__Share();
    	marketShare.UserOrGroupId = userId;
    	marketShare.RowCause = rowCause;
    	marketShare.ParentId = parentId;
    	marketShare.AccessLevel = accessLevel;
    	
    	if (isInsert) {
    		insert marketShare;
    	}
    	
    	return 	marketShare;					 	
    }
    //Changes for Task T-189162 Ends   
    
    //---------------------------------------------------------------------------
    // Method Name  : createActionItem
    // Description  : Create and Insert Object : Action_Items__c
    //---------------------------------------------------------------------------
    public static Action_Items__c createActionItem(String name, String itemType, String ZoneOrLeader, String itemCategory, String subject, 
    											   String smryField, String datatype, Boolean isInsert) {
        Action_Items__c actItem = new Action_Items__c();
        actItem.Name = name;
        actItem.Action_Item_Type__c = itemType;
        actItem.Default__c = true;
        actItem.Category__c = itemCategory;
        actItem.Zone_Or_Leader__c = ZoneOrLeader;
        actItem.Smry_Criteria_Fld__c = smryField;
        actItem.Subject_Area__c = subject;
        actItem.Datatype__c = datatype;
        
        if (isInsert) {
        	insert actItem;
        }
        return actItem;
    } 
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarket
    // Description  : Create and Insert Object : Market__c
    //---------------------------------------------------------------------------
    public static Market__c createMarket(String mktId, boolean isInsert) {
    	Market__c market = new Market__c(Name='Test Market',
                                        Market_Id__c = mktId,
                                        Market_Administrator__c = UserInfo.getUserId(),
                                        Available_Languages__c = 'en_US',
                                        CurrencyISOCode = 'USD',
                                        Mail_Plan_Enabled__c = false,
                                        ASLF_Timezone_Offset__c = 0.0,
                                        ASLF_Report_URL__c = 'http://aslf.report.avon.com',
                                        CURRNT_CMPGN_RMN_DAY_CNT__c = 10,
                                        CMPGN_NR__c = '201304',
                                        OPERTNL_CMPGN_CMPLTN_PCT__c = 25,
                                        NEXT_1_CMPGN_NR__c = '201305',
                                        CURRENT_QRTR__c = '2013-Q3',
                                        Enabled_Action_Item__c = 'Orders; Sales; Current Business',
                                        PREV_1_CMPGN_NR__c = '201303',
                                        SPONSOR_QLFYING_ORD_AMT__c = 1,
                                        Eligibility_No_Flags__c = 'ZM_Override__c;Out_of_Office__c',
                                        Eligibility_Yes_Flags__c = 'Opt_In__c',
                                        LeadMandatoryFields__c = 'User_Type__c,FirstName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c,Geo_Level_4__c,Mobile__c',
                                        SPPY_CMPGN_NR__c = '201001',
                                        X90_Day_Camp_CNT__c = 6,
                                        Business_Plan_KPIs__c = 'Unit_Earnings_dollar;Total_Unit_Sales_dollor;G1_Sales_Leaders_UL;G1_Activity_Rate;Bonus_Earnings;Earnings_from_Personal_Sales;Executive_Earnings;New_G1_UL;New_G1_EUL;New_G1_AUL;Total_and_Est_Earnings_dollar;Personal_Appointments;Qualified_Personal_Appointments;Personal_Volume_dollar;G1_Removals;G1_Active_Representatives',
                                        Max_Ldr_Titl_LVL__c = 9,
                                        ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c',
                                        Allow_Freeform_Email__c = 'Avon Leader;Avon Division Manager',
                                        Allow_Free_Emails_For__c = 'G1', 
                                        LAST_UPDT_DT__c = System.today(),
                                        CMPGN_STRT_DT__c = date.valueOf('2013-04-02'),
                                        CMPGN_END_DT__c = date.valueOf('2013-04-30')
                                        );
        
		if(isInsert){                   
        	insert market;
       	}
    	return market;

    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createUser
    // Description  : Create and Insert Object : User
    //---------------------------------------------------------------------------
    public static User createUser(String acctNbr, String zoneNbr, String prfName,
    							 boolean isInsert){
        String profNameLike = '%'+prfName;        
        Profile sysAdm = [select Id,Name from Profile where Name like :profNameLike LIMIT 1];
        User user = new User(
                                 Username=acctNbr+'@avonpoc.com',
                                 Title=prfName,
                                 TimeZoneSidKey='America/New_York',
                                 ProfileId=sysAdm.Id,
                                 LocaleSidKey='en_US',
                                 LastName=prfName,
                                 FirstName='Avon Test',
                                 Email=acctNbr+'@avonpoc.com',
                                 Alias='test',
                                 EmailEncodingKey='ISO-8859-1',
                                 LanguageLocaleKey='en_US',
                                // IsActive=true, 
                                 ACCT_NR__c=acctNbr,
                                 DFALT_DIV_NM__c='D1',
                                 DFALT_ZONE_CD__c=(prfName=='Avon Division Manager'?null:zoneNbr),
                                 MAX_EMAIL_LIMIT__c=10,
                                 MLPLN_CD__c='1',
                                 MRKT_ID__c=acctNbr,
                                 MRKT_ID_ACCT_NR_KEY__c=acctNbr,
                                 MRKT_TAG_1_HDR_TXT__c='Some data',
                                 USER_CNTRY_CD__c='US',
                                 Welcome_Message__c=true,
                                 SFDC_Ineligibility_Codes__c='',
                                 GI3_Email__c=acctNbr+'@avonpoc.com',
                                 LDRSHP_TITL_LVL_NBR__c = '1', TRNDSTTR_IND__c = 'Y'
                                );
        if(isInsert){
	        insert user;
	        user.IsActive = true;
	        update user;
        }        
        return user;           
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createContact
    // Description  : Create and Insert Object : Contact
    //---------------------------------------------------------------------------
    public static Contact createContact(String acctNbr, String accountId, boolean isInsert) {                         
        Contact con = new Contact(AccountId = accountId, ACCT_NR__c = acctNbr,
                                  Email = 'test@avon.com', 
                                  FirstName = acctNbr+'First',
                                  LastName = acctNbr+'Last',
                                  HomePhone = '9999999999',
                                  LDRSHP_PRGRM_IND__c = 'Y', 
                                  LDRSHP_RPT_SLS_ZONE_CD__c = 'XZ1',
                                  MRKT_ACCT_KEY__c = acctNbr,
                                  MRKT_ID__c = acctNbr,
                                  PATD_CERTFCTN_LVL_A_IND__c = 'Y', PATD_CERTFCTN_LVL_D_IND__c = 'Y',
                                  PATD_CERTFCTN_LVL_P_IND__c = 'Y', PATD_CERTFCTN_LVL_T_IND__c = 'Y',
                                  REP_ADDR_STR_2_TXT__c = 'Address 2', REP_ADDR_STR_3_TXT__c = 'Address 3',
                                  REP_ADDR_STR_4_TXT__c = 'Address 4', REP_APPT_DT__c = System.today(),
                                  REP_LANG_CD__c = 'en_US', SLS_ZONE_CD__c = 'XZ1', REP_MOBILE_PHON_NR__c = '1234546789'
                                  //OwnerId=ownerId//uncommented
                                 );
        if(isInsert){
        	insert con;
        }      
        return con;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createALMGlobalSetting
    // Description  : Create and Insert custom setting : ALM_Global_Settings__c
    //---------------------------------------------------------------------------
    public static ALM_Global_Settings__c createALMGlobalSetting(boolean isInsert){
    	 ALM_Global_Settings__c setting = new ALM_Global_Settings__c(Name = 'ALM Default');
		 setting.Site_Url__c = 'test@test.com';
		 setting.Widget_Lifetime__c = 3.0;
		 if(isInsert){
		 	insert setting;
		 }
		 return setting;	
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createRepPerformance
    // Description  : Create and Insert custom setting : ALM_Rep_Performance_1__c
    //---------------------------------------------------------------------------
    public static ALM_Rep_Performance_1__c createRepPerformance(String contactId, Market__c market, String accNR, Boolean isInsert){
    	ALM_Rep_Performance_1__c repPerformance = new ALM_Rep_Performance_1__c();
    	repPerformance.Personal_Performance_Key__c = market.Market_Id__c + market.CMPGN_NR__c + accNR;
        repPerformance.AVON_LOA_1_6_IND__c = 'Y';
        repPerformance.SUBMTD_AWRD_SLS_AMT__c = 100.00;
        repPerformance.SPPY_AWRD_SLS_AMT__c = 100.00;
        repPerformance.PRSNL_MRKT_TAG_3_TXT__c = 'Test';
        repPerformance.CUST_CNT__c = 100.00;
        repPerformance.CurrencyISOCode = 'USD';
        repPerformance.MRKT_ACCT_KEY__c = contactId;
        repPerformance.MRKT_ID__c = market.Market_Id__c;
        repPerformance.ACCT_NR__c = accNR;
        repPerformance.UPLN_ACCT_NR__c = accNR + '01';
        repPerformance.ROOT_UPLN_ACCT_NR__c = accNR;
        repPerformance.OPERTNL_CMPGN_NR__c = market.CMPGN_NR__c;
        repPerformance.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(market.CMPGN_NR__c);
        repPerformance.REP_OMS_STUS_CD__c = '1';
        repPerformance.LDRSHP_LOA_NR__c = 1;
        repPerformance.LDRSHP_TITL_LVL_NR__c = '1';
        repPerformance.LOA_NR__c = 1.0;
        
        if(isInsert){
		 	insert repPerformance;
		}
		return repPerformance;	
    } 
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarketContent
    // Description  : Create and Insert object : Market_Content__c
    //---------------------------------------------------------------------------
    public static Market_Content__c createMarketContent(String marketId, boolean isInsert){
    	 Market_Content__c mktContent = new Market_Content__c(   Name='Test',
                                        Market__c=marketId, Type__c='Help',
                                        Title_Levels__c='All', User_Type__c='All',
                                        Content_Type__c='HTML', Content__c='Test data', 
                                        ALM_Page_Id__c='1');
        if(isInsert){
        	insert mktContent; 
        }
        return mktContent;	
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createEmailTemplate
    // Description  : Create and Insert object : EmailTemplate
    //---------------------------------------------------------------------------
    public static EmailTemplate createEmailTemplate(String folderId, boolean isInsert) {
        EmailTemplate template = new EmailTemplate( FolderId = folderId, 
        											Name = 'test',
        											body = 'test', 
        											description = 'test',
                                                    DeveloperName = 'test', 
                                                    htmlvalue = '<html></html>',
                                                    IsActive = true,
                                                    Subject = 'Test',
                                                    TemplateType = 'Custom');
        if(isInsert) {
        	insert template; 
        }
        
        return template;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createContentVersion
    // Description  : Create and Insert object : ContentVersion
    //---------------------------------------------------------------------------
    public static ContentVersion createContentVersion(boolean isInsert){
    	ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL = 'http://www.google.com';
        contentVersionObj.title = 'Google';
        if(isInsert) {
        	insert contentVersionObj; 
        }
        return contentVersionObj;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSalesOrgSummary
    // Description  : Create and Insert object : Sales_Org_Summary__c
    //---------------------------------------------------------------------------
    public static Sales_Org_Summary__c createSalesOrgSummary(Market__c mkt, User user, boolean isInsert){
    	Sales_Org_Summary__c sos = new Sales_Org_Summary__c(ZONE_MGR__c = user.Id, 
    														OPERTNL_CMPGN_NR__c = mkt.CMPGN_NR__c,
                                                            SLS_ORG_LVL_DESC_TXT__c = 'Z', 
                                                            SLS_ORG_DESC_TXT__c = user.DFALT_ZONE_CD__c,
                                                            MRKT_KEY__c = mkt.Id,  
                                                            FLD_SLS_CMPGN_NR__c = mkt.CMPGN_NR__c,
                                                            CurrencyISOCode = 'USD',
                                                            ACTV_REP_FRCST_CNT__c = 10.0);
        if(isInsert){
        	insert sos;
        } 
        return sos;                                        
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLeaderTitle
    // Description  : Create and Insert object : Leader_Title__c
    //---------------------------------------------------------------------------
    public static Leader_Title__c createLeaderTitle(String marketId, String markMarketId, boolean isInsert){
    	Leader_Title__c leaderTitle = new Leader_Title__c ( GENRTN_1_ERNGS_PCT__c = 10.0, GENRTN_1_MIN_ORD_AMT__c = 100.00,
                    									    GENRTN_2_ERNGS_PCT__c = 10.0, GENRTN_2_MIN_ORD_AMT__c = 200.00,
						                    				GENRTN_3_ERNGS_PCT__c = 40.0, GENRTN_3_MIN_ORD_AMT__c = 500.00,
						                    				LANG_CD__c = 'en_US', LCL_LDRSHP_TITL_LANG_DESC_TXT__c = 'Title 01',
						                    				LDRSHP_TITL_LVL_NR__c = '1', Market__c = marketId, 
						                    				MIN_PRSNL_SLS_REQD_AMT__c = 100.00, MIN_REP_RCRTMNTS_REQD_NR__c = 10,
						                    				MIN_EST_ERNGs_AMT__c = 15000.00, MRKT_TAG_QLFR_1_NR__c = 10, 
						                    				MRKT_TAG_QLFR_2_NR__c = 10, MRKT_TAG_QLFR_3_NR__c = 10,
						                    				GRAPHIC_ERNG_IMG__c = 'http://media.gadgetsin.com/uploads//2009/10/ropid_small_size_robot_1.JPG',
						                    				MIN_GRP_SLS_REQD_AMT__c = 100.0, MRKT_ID__c = markMarketId,
						                    				LCL_LDRSHP_TITL_CD__c = 'TL 01', EXEC_IND__c = 'Y');
        if(isInsert){
        	insert leaderTitle;
        } 
        return leaderTitle;                                               
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLeaderTitles
    // Description  : Create and Insert object : Leader_Title__c
    //---------------------------------------------------------------------------
    public static List <Leader_Title__c> createLeaderTitlesList(String marketId, String markMarketId, boolean isInsert) {
        String[] titleLevels = new String[]{'1','2','3','4','5','6','7','8'};
        Leader_Title__c title;
        List <Leader_Title__c> titleList = new List <Leader_Title__c>();
        String strEXEC_IND = '';
        titleList = new List <Leader_Title__c>();
        for (String level : titleLevels) {
            if (level == '2') {
                strEXEC_IND = 'Y';
            }
            if (level == '7') {
                strEXEC_IND = 'N';
            }
            title = new Leader_Title__c(GENRTN_1_ERNGS_PCT__c = 10.0, GENRTN_1_MIN_ORD_AMT__c = 100.00,
                                        GENRTN_2_ERNGS_PCT__c = 10.0, GENRTN_2_MIN_ORD_AMT__c = 200.00,
                                        GENRTN_3_ERNGS_PCT__c = 40.0, GENRTN_3_MIN_ORD_AMT__c = 500.00,
                                        LANG_CD__c = 'en_US', LCL_LDRSHP_TITL_LANG_DESC_TXT__c = 'Title ' + level,
                                        LDRSHP_TITL_LVL_NR__c = level, Market__c = marketId,
                                        MIN_PRSNL_SLS_REQD_AMT__c = 100.00, MIN_REP_RCRTMNTS_REQD_NR__c = 10,
                                        MIN_EST_ERNGs_AMT__c = 15000.00, MRKT_TAG_QLFR_1_NR__c = 10, 
                                        MRKT_TAG_QLFR_2_NR__c = 10, MRKT_TAG_QLFR_3_NR__c = 10, EXEC_IND__c = strEXEC_IND,
                                        GRAPHIC_ERNG_IMG__c = 'http://media.gadgetsin.com/uploads//2009/10/ropid_small_size_robot_1.JPG',
                                        MIN_GRP_SLS_REQD_AMT__c = 100.0, MRKT_ID__c = markMarketId,
                                        LCL_LDRSHP_TITL_CD__c = '' + level);
            titleList.add(title);
        }
        if (isInsert) {
        	insert titleList;
        }
        
    	return titleList;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSellerStatusList
    // Description  : Create and Insert object : List of Seller_Status__c
    //---------------------------------------------------------------------------
    public static List <Seller_Status__c> createSellerStatusList(String marketId, boolean isInsert) {
        
        List <Seller_Status__c> sellerStatusList = new List <Seller_Status__c>();
        Seller_Status__c sts;
        sts = new Seller_Status__c(LANG_CD__c = 'en_US', LCL_TOP_SLR_LVL_KEY__c = 'SELLSTS1', MRKT_TOP_SLR_LANG_KEY__c = 'Top Seller 1',
                                   LCL_TOP_SLR_LVL_LANG_DESC_TXT__c = 'Seller Status 1', Market__c = marketId);
        sellerStatusList.add(sts);
                                          
        sts = new Seller_Status__c(LANG_CD__c = 'en_US', LCL_TOP_SLR_LVL_KEY__c = 'SELLSTS2', MRKT_TOP_SLR_LANG_KEY__c = 'Top Seller 2',
                                   LCL_TOP_SLR_LVL_LANG_DESC_TXT__c = 'Seller Status 2', Market__c = marketId);
        sellerStatusList.add(sts);                                  
        sts = new Seller_Status__c(LANG_CD__c = 'en_US', LCL_TOP_SLR_LVL_KEY__c = 'SELLSTS3', MRKT_TOP_SLR_LANG_KEY__c = 'Top Seller 3',
                                   LCL_TOP_SLR_LVL_LANG_DESC_TXT__c = 'Seller Status 3', Market__c = marketId);
        sellerStatusList.add(sts);
        
        if (isInsert) {          
        	insert sellerStatusList;
        }
        
        return sellerStatusList;                        
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSalesOrgsList
    // Description  : Create and Insert object : List of Sales_Organization__c
    //---------------------------------------------------------------------------
    public static List <Sales_Organization__c> createSalesOrgsList(String marketId, String markMarketId, boolean isInsert) {
        List <Sales_Organization__c> slsOrgsList = new List <Sales_Organization__c>();
        Sales_Organization__c org;
        org = new Sales_Organization__c(Market__c = marketId, MRKT_ID__c = markMarketId,
                                        SLS_DIV_MGR_EMAIL_TXT__c = 'divmgr@avon.com', SLS_DIV_MGR_FULL_NM__c = 'Division Manager',
                                        SLS_DIV_MGR_PHON_NR__c = '1234567', SLS_DIV_NM__c = 'D1', MRKT_SLS_ORG_KEY__c = 'Key 1', 
                                        MRKT_ID_LVL_SLS_ORG_CD_KEY__c = 'Division Manager 1', SLS_REGN_MGR_EMAIL_TXT__c = 'regmgr@email.com', 
                                        SLS_REGN_MGR_FULL_NM__c = 'Region Manager', SLS_REGN_NM__c = 'R1', SLS_ZONE_CD__c = 'XZ1', SLS_ZONE_MGR_EMAIL_TXT__c = 'zmgr@avon.com',
                                        SLS_ZONE_MGR_FULL_NM__c = 'Zone Manager', SLS_ZONE_MGR_PHON_NR__c = '123456788', SLS_DIV_CD__c = 'D1', SLS_ORG_LVL_CD__c = 'D');
        slsOrgsList.add(org);

        org = new Sales_Organization__c(Market__c = marketId, MRKT_ID__c = markMarketId,
                                        SLS_DIV_MGR_EMAIL_TXT__c = 'divmgr1@avon.com', SLS_DIV_MGR_FULL_NM__c = 'Division Manager',
                                        SLS_DIV_MGR_PHON_NR__c = '1234567', SLS_DIV_NM__c = 'D1', MRKT_SLS_ORG_KEY__c = 'Key 2', 
                                        MRKT_ID_LVL_SLS_ORG_CD_KEY__c = 'Division Manager 2', SLS_REGN_MGR_EMAIL_TXT__c = 'regmgr1@email.com', 
                                        SLS_REGN_MGR_FULL_NM__c = 'Region Manager', SLS_REGN_NM__c = 'R1', SLS_ZONE_CD__c = '', SLS_ZONE_MGR_EMAIL_TXT__c = 'zmgr@avon.com',
                                        SLS_ZONE_MGR_FULL_NM__c = '', SLS_ZONE_MGR_PHON_NR__c = '123456788');
        slsOrgsList.add(org);
                                        
		org = new Sales_Organization__c(Market__c = marketId, MRKT_ID__c = markMarketId,
                                        SLS_DIV_MGR_EMAIL_TXT__c = 'divmgr2@avon.com', SLS_DIV_MGR_FULL_NM__c = 'Division Manager',
                                        SLS_DIV_MGR_PHON_NR__c = '1234567', SLS_DIV_NM__c = 'D1', MRKT_SLS_ORG_KEY__c = 'Key 3', 
                                        MRKT_ID_LVL_SLS_ORG_CD_KEY__c = 'null', SLS_REGN_MGR_EMAIL_TXT__c = 'regmgr2@email.com', 
                                        SLS_REGN_MGR_FULL_NM__c = 'Region Manager', SLS_REGN_NM__c = 'R1', SLS_ZONE_CD__c = '', SLS_ZONE_MGR_EMAIL_TXT__c = 'zmgr@avon.com',
                                        SLS_ZONE_MGR_FULL_NM__c = '', SLS_ZONE_MGR_PHON_NR__c = '123456788');
        slsOrgsList.add(org);
        
        if (isInsert) {
        	insert slsOrgsList;
        }
        
        return slsOrgsList;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createEToolsWidget
    // Description  : Create and Insert object : eTools_Widget__c
    //---------------------------------------------------------------------------
    public static eTools_Widget__c createEToolsWidget(String marketId, String marketType, boolean isInsert) {
    	eTools_Widget__c eTools = new eTools_Widget__c();
    	eTools.Market__c = marketId;
    	eTools.Type__c = marketType;
    	eTools.Module_Type__c = ALMConstants.REPORT_TYPE_ERNG_ILLUSTRATR;
    	
    	if (isInsert) {
    		insert eTools;
    	}
    	return eTools;
    	
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarketTags
    // Description  : Create and Insert object : Market_Tag_Label__c
    //---------------------------------------------------------------------------
    public static List<Market_Tag_Label__c> createMarketTags(String marketId, List<String> subjAreas,
    														boolean isInsert) {
        List<Market_Tag_Label__c> mktTags = new List<Market_Tag_Label__c>();
        for (String area: subjAreas) {
            mktTags.add(new Market_Tag_Label__c(Language__c='en_US',Market__c=marketId,Field_API_Name__c='MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TAG_1_AMT__c',
                                             Subject_Area__c=area, Tag_Label__c='Market Tag 1',
                                             Tag_Name__c='Market Tag 1'));
                                             
            mktTags.add(new Market_Tag_Label__c(Language__c='en_US',Market__c=marketId,Field_API_Name__c='MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TAG_4_TXT__c',
                                             Subject_Area__c=area, Tag_Label__c='Market Tag 2',
                                             Tag_Name__c='Market Tag 2'));
        }
        if(isInsert){
        	insert mktTags;
        }
        return mktTags;       
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createZoneKPIConfig
    // Description  : Create and Insert object : ZM_ZoneKPIConfig__c
    //---------------------------------------------------------------------------
    public static ZM_ZoneKPIConfig__c createZoneKPIConfig(String name, String customLabel, String parent, boolean isInsert){
    	ZM_ZoneKPIConfig__c setting = new ZM_ZoneKPIConfig__c();
    	setting.Name = name;
    	setting.CustomLabel__c = customLabel;  
    	setting.Parent__c = parent;
    	setting.Count__c = 'APPT_SPPY_CNT__c';
        setting.Results_Field__c = 'APPT_CNT__c'; 
        setting.RankField__c = 'APPT_DIV_RNK__c'; 
        setting.CountAtRiskField__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c'; 
        setting.SPPYField__c = 'APPT_SPPY_CNT__c'; 
        setting.ForecastField__c = 'APPT_FRCST_CNT__c'; 
        setting.PlanSPPYField__c = 'APPT_PLAN_SPPY_CNT__c';
        setting.CountOfRisingStarsField__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c'; 
        setting.VarianceField__c = 'APPT_VAR_CNT__c'; 
        setting.Last_Campaign_Analysis__c = 'APPT_LCA_CNT__c';
        setting.CounAtRiskLastCampaignField__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c'; 
        setting.My_Actions__c = 'APPT_My_Actions_CNT__c';
        setting.ActualField__c = 'APPT_CNT__c'; 
        setting.PlanField__c = 'APPT_PLAN_CNT__c';
        setting.Suggested_Activities__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c';
        setting.CountAtRisk2__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c';
        setting.ForecastGoalField__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c';
        setting.ForecastInput__c = 'TITL_0_STF_TAR_LAST_CMPGN_CNT__c';
    	if(isInsert){
    		insert setting;
    	}
    	return setting;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarketZoneKPIConfig
    // Description  : Create and Insert object : ZM_MarketZoneKPIConfig__c
    //---------------------------------------------------------------------------
    public static ZM_MarketZoneKPIConfig__c createMarketZoneKPIConfig(String name, String configName, String marketId,
    																  String sortOrder, String context, String currencyCode,
    																  boolean marketUses, Decimal marketPlan, boolean isInsert){
    	ZM_MarketZoneKPIConfig__c config = new ZM_MarketZoneKPIConfig__c(Name = name,
    																	 ZM_ZoneKPIConfigName__c = configName, 
    																	 Market__c = marketId, 
    																	 SortOrder__c = sortOrder,
        	                                                             Context__c = context,
        	                                                             CurrencyISOCode = currencyCode,
        	                                                             MarketUsesDefault__c = marketUses,
        	                                                             MarketDefaultPlan__c = marketPlan);
    	if(isInsert){
    		insert config;
    	}
    	return config;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createReportTranslation
    // Description  : Create and Insert object : ZM_Report_Translation__c
    //---------------------------------------------------------------------------
    public static ZM_Report_Translation__c createReportTranslation(String reportName, String reportId, String marketId,
    															   Integer sortOrder, String languageCode, String appContext,
    															   String reportRole, boolean isInsert){
    	ZM_Report_Translation__c z = new ZM_Report_Translation__c();
        z.Sort_Order__c = sortOrder;
        z.Report_URL__c = 'x';
        z.Report_Label__c = reportName;
        z.Report_Id__c = reportId;
        z.Market_Id__c = marketId;
        z.Language_Code__c = languageCode;
        z.Application_Context__c = appContext;
        z.Report_Role__c = reportRole;
        z.Name = reportName;
        z.NumberOfColumnstoFreeze__c = 1;
        if(isInsert){
        	insert z; 
        }
        return z;   	
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createReportConfig
    // Description  : Create and Insert object : Report_Config__c
    //---------------------------------------------------------------------------
    public static List <Report_Config__c> createReportConfig(String marketId, boolean isInsert) {
        List <Report_Config__c> rptCfg = new List <Report_Config__c>();
        Report_Config__c cfg;
        cfg = new Report_Config__c( Name = 'Test Report', Market__c = marketId,
                                    Report_Type__c = 'Test1', Order_Criteria__c = 'Personal_Sales__r.AWRD_SLS_AMT__c>0',
                                    Report_Id__c = 'R01', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = 'Representative__r.LOA_NR__c' + '\n' + 'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c = '1;2;3', Report_Sequence__c = 1);
        rptCfg.add(cfg);
        cfg = new Report_Config__c( Name = 'Test Report', Market__c = marketId,
                                    Report_Type__c = 'Test2', Rep_Criteria__c = 'Representative__r.LOA_NR__c !=null',
                                    Report_Id__c = 'R02', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = 'Representative__r.LOA_NR__c' + '\n' + 'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c = '1;2;3', Report_Sequence__c = 2);
        rptCfg.add(cfg);
        cfg = new Report_Config__c( Name = 'Test Report', Market__c = marketId,
                                    Report_Type__c = 'Test3', Ldr_Smry_Criteria__c = 'Group_Sales__r.TOTAL_TAR_CNT__c',
                                    Report_Id__c = 'R03', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = 'Representative__r.LOA_NR__c' + '\n' + 'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c = '1;2;3',Report_Sequence__c = 3);
        rptCfg.add(cfg);
        cfg = new Report_Config__c( Name = 'Test Report', Market__c = marketId,
                                    Report_Type__c = 'Orders_below_Minimum', Ldr_Smry_Criteria__c = '',
                                    Report_Id__c = 'R04', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = 'Representative__r.LOA_NR__c' + '\n' + 'Personal_Sales__r.BAL_DUE_AMT__c',
                                    TITL_LVL_NBR__c = '1;2;3', Report_Sequence__c = 4);
        rptCfg.add(cfg);

        cfg = new Report_Config__c( Name='Test Report', Market__c = marketId,
                                    Report_Type__c = 'Orders_at_Minimum', Ldr_Smry_Criteria__c = '',
                                    Report_Id__c = 'R05', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = 'Representative__r.LOA_NR__c' + '\n' + 'Personal_Sales__r.BAL_DUE_AMT__c',
                                    Default_Sort__c = 'Representative__r.LOA_NR__c', TITL_LVL_NBR__c = '1;2;3', Report_Sequence__c = 5);

        rptCfg.add(cfg);
                            
        cfg = new Report_Config__c( Name='Test Report', Market__c = marketId,
                                    Report_Type__c = 'New_Rep', Ldr_Smry_Criteria__c = '',
                                    Report_Id__c = 'R06', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = '', Default_Sort__c = '', Include_Recruits__c = false,
                                    Include_Removed_Reps__c = true, Order_Criteria__c = 'LOA_NR__c asc, PRSNL_SLS_AMT__c desc',
                                    TITL_LVL_NBR__c = '1', Page_Size__c = 1, Dowload_Limit__c = 100, Number_of_Historical_Cmpgns_for_Filter__c = 2,
                                    Report_URL__c = 'https://www.testRep.com', Report_Sequence__c = 6);
         rptCfg.add(cfg);
                            
         cfg=new  Report_Config__c( Name='Top Seller', Market__c = marketId,
                                    Report_Type__c = 'Top_Seller', Ldr_Smry_Criteria__c = '',
                                    Report_Id__c = 'R07', Applicable_To__c = 'Avon Leader',
                                    Columns_To_Display__c = '', Default_Sort__c = '', Include_Recruits__c = false,
                                    Include_Removed_Reps__c = true, Order_Criteria__c = 'PRSNL_SLS_AMT__c Desc',
                                    TITL_LVL_NBR__c = '0;1;2;3;4;5', Page_Size__c = 1, Dowload_Limit__c = 100, Report_Sequence__c = 7); 
        rptCfg.add(cfg);
        
        if (isInsert) { 
        	insert rptCfg;
        }
        
        List <Report_Column_New__c> rptColumns = new List <Report_Column_New__c>();
        Report_Column_New__c column;
        column = new Report_Column_New__c( Name = 'Account number', Fully_Qualified_Name__c = 'MRKT_ACCT_KEY__r.ACCT_NR__c',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.ACCT_NR__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 3, is_hidden__c = false, CurrencyIsoCode = 'USD', Column_Group_Name__c = 'Personal Information');

        rptColumns.add(column);

        column = new Report_Column_New__c( Name = 'Anniversary', Fully_Qualified_Name__c = 'MRKT_ACCT_KEY__r.REP_APPT_DT__c',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.REP_APPT_DT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 11, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);

        column = new Report_Column_New__c( Name = 'Badge Title', Fully_Qualified_Name__c = 'LDRSHP_TITL_LVL_NR__c',
                                          Fully_Qualified_Name2__c = 'LDRSHP_TITL_LVL_NR__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 12, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);   

        column = new Report_Column_New__c( Name = 'Birthday', Fully_Qualified_Name__c = 'MRKT_ACCT_KEY__r.REP_BRTH_DT__c',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.REP_BRTH_DT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 10, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);  

        column = new Report_Column_New__c( Name = 'Branch Name', Fully_Qualified_Name__c = 'BRNCH_SCTN_CD__c',
                                          Fully_Qualified_Name2__c = 'BRNCH_SCTN_CD__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 7, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column); 

        column = new Report_Column_New__c( Name = 'LDRSHP_TITL_LVL_NR__c', Fully_Qualified_Name__c = 'LDRSHP_TITL_LVL_NR__c',
                                          Fully_Qualified_Name2__c = 'LDRSHP_TITL_LVL_NR__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 14, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column); 

        column = new Report_Column_New__c( Name = 'Current Campaign Brochure', Fully_Qualified_Name__c = 'GRP_BRCHR_CNT__c',
                                          Fully_Qualified_Name2__c = 'BRCHR_CNT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 20, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);

        column = new Report_Column_New__c( Name = 'Customer Served', Fully_Qualified_Name__c = 'LOA_1_6_CUST_CNT__c',
                                          Fully_Qualified_Name2__c = 'CUST_CNT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 21, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column); 

        column = new Report_Column_New__c( Name = 'First, Last Name', Fully_Qualified_Name__c = 'MRKT_ACCT_KEY__r.LastName,MRKT_ACCT_KEY__r.FirstName',
                                          Fully_Qualified_Name2__c = 'MRKT_ACCT_KEY__r.LastName,MRKT_ACCT_KEY__r.FirstName', Width__c = 50, 
                                          Visibility__c = 'Always Displayed', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 2, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);   

        column = new Report_Column_New__c( Name = 'Generation', Fully_Qualified_Name__c = 'ACCT_NR__c',
                                          Fully_Qualified_Name2__c = 'Genealogy_Level__c', Width__c = 50, 
                                          Visibility__c = 'Always Displayed', Type__c = 'Text', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 1, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);   

        column = new Report_Column_New__c( Name = 'LOA', Fully_Qualified_Name__c = 'LDRSHP_LOA_NR__c',
                                          Fully_Qualified_Name2__c = 'LOA_NR__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 6, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = 'Personal Information');
        rptColumns.add(column);
        
        column = new Report_Column_New__c( Name = 'PC1_INVC_AWRD_SLS_AMT__c', Fully_Qualified_Name__c = 'PC1_INVC_AWRD_SLS_AMT__c',
                                          Fully_Qualified_Name2__c = 'PC1_INVC_AWRD_SLS_AMT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 13, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);  
                
        column = new Report_Column_New__c( Name = 'BOOK1_GRP_UNIT_SLS_AMT__c', Fully_Qualified_Name__c = 'BOOK1_GRP_UNIT_SLS_AMT__c',
                                          Fully_Qualified_Name2__c = 'BOOK1_GRP_UNIT_SLS_AMT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 13, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column); 
        column = new Report_Column_New__c( Name = 'PRSNL_SLS_AMT__c', Fully_Qualified_Name__c = 'PRSNL_SLS_AMT__c',
                                          Fully_Qualified_Name2__c = 'PRSNL_SLS_AMT__c', Width__c = 50, 
                                          Visibility__c = 'Default Shown', Type__c = 'Number', Report_Config__c = rptCfg[5].Id,
                                          Display_Order__c = 13, is_hidden__c = false, CurrencyIsoCode = 'USD', 
                                          Column_Group_Name__c = '');
        rptColumns.add(column);         
                              
        if (isInsert) {
        	insert rptColumns;
        }   

        List <Report_Filter__c> rptFiltrs = new List <Report_Filter__c>();
        Report_Filter__c repFilter;

        repFilter = new Report_Filter__c(Name = 'LOA (1-6)', CurrencyIsoCode = 'USD',
                                         Filter_Criteria__c = 'LDRSHP_LOA_NR__c <=6 AND AVON_LOA_1_6_IND__c = \'Y\'',
                                         Filter_Key__c = 'LOA (1-6)', Report_Config__c = rptCfg[5].Id);

        rptFiltrs.add(repFilter);
        
        repFilter = new Report_Filter__c(Name = 'LOA (1-6)', CurrencyIsoCode = 'USD',
                                         Filter_Criteria__c = 'LDRSHP_LOA_NR__c <=6 AND AVON_LOA_1_6_IND__c = \'Y\'',
                                         Filter_Key__c = 'LOA_0_6', Report_Config__c = rptCfg[5].Id);

        rptFiltrs.add(repFilter);
                        

        repFilter = new Report_Filter__c(Name = 'LOA 1', CurrencyIsoCode = 'USD',
                                         Filter_Criteria__c = 'LDRSHP_LOA_NR__c =1 AND AVON_LOA_1_6_IND__c = \'Y\'',
                                         Filter_Key__c = 'LOA 1', Report_Config__c = rptCfg[5].Id);

        rptFiltrs.add(repFilter);
        
        if (isInsert) {
        	insert rptFiltrs;
        }
        
        return rptCfg;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createReportCenter
    // Description  : Create and Insert object : Report_Center__c
    //---------------------------------------------------------------------------
    public static Report_Center__c createReportCenter(String marketId, boolean isInsert) {
    	Report_Center__c reportCenter = new Report_Center__c();
    	reportCenter.Avon_Profile__c = 'Avon Leader';
        reportCenter.File_Extension__c = '.pdf';
        reportCenter.Frequency__c = 'EOC';
        reportCenter.Market__c = marketId;
        reportCenter.Campaign__c = 'CC;PC;NC';
        reportCenter.Report_Type__c = 'SOS';
        reportCenter.SL_File_Mask__c = 'R-ACCTNR-RPTCODE-CMPGNNR-LANGCD';
        reportCenter.Target__c = '_blank';
        reportCenter.Title_Level__c = '0;1;2;3;4;5;6;7';
        reportCenter.Can_Impersonate__c = true;
        
        if (isInsert) {
        	insert reportCenter;
        }
    	
    	return reportCenter;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createOmniturePageNameMapping
    // Description  : Create and Insert object : Omniture_Page_Name_Mapping__c
    //---------------------------------------------------------------------------
    public static Omniture_Page_Name_Mapping__c createOmniturePageNameMapping(boolean isInsert) {
    	Omniture_Page_Name_Mapping__c omniturePage = new Omniture_Page_Name_Mapping__c();
    	omniturePage.Name = 'ReportCenter';
    	omniturePage.Omniture_Page_Name__c = 'ReportCenter';
        
        if (isInsert) {
        	insert omniturePage;
        }
    	
    	return omniturePage;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSummaryOverlayRowConfig
    // Description  : Create and Insert object : SummaryOverlay_Row_Config__c
    //---------------------------------------------------------------------------
    public static SummaryOverlay_Row_Config__c createSummaryOverlayRowConfig(Id marketId, boolean isInsert){
    	 SummaryOverlay_Row_Config__c smrc = new SummaryOverlay_Row_Config__c(EG0__c='GRP_ACTV_REP_CNT__c',
									        EG1__c='EXGENRTN_1_GRP_ACTV_REP_CNT__c',EG2__c='EXGENRTN_2_GRP_ACTV_REP_CNT__c',
									        EG3__c='EXGENRTN_3_GRP_ACTV_REP_CNT__c',
									        EG4PLUS__c='EXGENRTN_4PLUS_GRP_ACTV_REP_CNT__c',
									        G0__c='PRSNL_SLS_AMT__c',G1__c='GENTRTN_1_ACTV_REP_CNT__c',
									        G2__c='GENTRTN_2_ACTV_REP_CNT__c',G3__c='GENTRTN_3_ACTV_REP_CNT__c',
									        Market__c=marketId,
									        Row_Label__c='Actives',
									        Executive_Row_Label__c='Actives',
									        Data_Type__c='Number',
									        Executive_Data_Type__c='Number');
        if(isInsert){
        	insert smrc;
        }
        return smrc;    	
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createUserRole
    // Description  : Create and Insert object : UserRole
    //---------------------------------------------------------------------------
    public static UserRole createUserRole(String role, Id parentId, Boolean isInsert){
    	UserRole u1 = new UserRole();
        u1.Name = role;
        u1.ParentRoleId = parentId;
        if(isInsert){
        	insert u1;
        }
        return u1;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSitePortalUser
    // Description  : Create and Insert object : Portal User
    //---------------------------------------------------------------------------
    public static User createSitePortalUser(String acctNbr, String zoneNbr, String prfName, String personContactId, Boolean isInsert) {
      String profName = 'System Administrator';        
      Profile sysAdm = [select Id,Name from Profile where Name like :profName LIMIT 1];
      UserRole ur = [SELECT ID FROM UserRole WHERE Name = 'Mexico Market Sales'];
      User usr = new User(alias = 'standtU',  
	                     ContactId = personContactId, 
	                     Username=acctNbr+'@avonpoc.com',
	                     Title=prfName,
                         TimeZoneSidKey='America/New_York',
                         ProfileId=sysAdm.Id,
                         LocaleSidKey='en_US',
                         LastName=prfName,
                         FirstName='Avon Test',
                         Email=acctNbr+'@avonpoc.com',
                         EmailEncodingKey='ISO-8859-1',
                         LanguageLocaleKey='en_US',
                         ACCT_NR__c=acctNbr,
                         DFALT_DIV_NM__c='D1',
                         DFALT_ZONE_CD__c=(prfName=='Avon Division Manager'?null:zoneNbr),
                         MAX_EMAIL_LIMIT__c=10,
                         MLPLN_CD__c='1',
                         MRKT_ID__c=acctNbr,
                         MRKT_ID_ACCT_NR_KEY__c=acctNbr,
                         MRKT_TAG_1_HDR_TXT__c='Some data',
                         USER_CNTRY_CD__c='US',
                         Welcome_Message__c=true,
                         SFDC_Ineligibility_Codes__c='',
                         GI3_Email__c=acctNbr+'@avonpoc.com',
                         LDRSHP_TITL_LVL_NBR__c = '1', TRNDSTTR_IND__c = 'Y'
                     );
      if (isInsert) {
           usr.UserRoleId = ur.Id;
           usr.IsActive = true;
           insert usr;
      }     
      return usr;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createActionItems
    // Description  : Create and Insert object : Action_Items__c
    //---------------------------------------------------------------------------
    public static List <Action_Items__c> createActionItems(boolean isInsert) {
        List <Action_Items__c> actItems = new List <Action_Items__c>();
        Action_Items__c actItem;
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Rising Stars', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = 'GRP_RISNG_STAR_CNT__c', Subject_Area__c = 'Coaching Others', Datatype__c = 'Number');
        actItems.add(actItem);
        
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Title at Risk', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = 'GRP_TAR_CNT__c', Subject_Area__c = 'Coaching Others', Datatype__c = 'Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'New and In Progress Leads', Default__c = false,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c=null,Zone_Or_Leader__c='Leader',
                                      Smry_Criteria_Fld__c = 'GRP_TITL_DMTD_CNT__c', Subject_Area__c = 'Managing Numbers', Datatype__c = 'Number');
        actItems.add(actItem);      

        actItem = new Action_Items__c(Action_Item_Type__c = 'Summary', Category__c = 'Orders Not submitted', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = 'GRP_NO_ORD_CNT__c', Subject_Area__c = 'Managing Numbers', Datatype__c = 'Number');
        actItems.add(actItem);
        
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Team sales below minimum', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = 'GRP_TUS_BLW_QLFR_CNT__c', Subject_Area__c = 'Managing Numbers', Datatype__c = 'Number');
        actItems.add(actItem);

        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Downline PSQ not achieved', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = 'PRSNL_SLS_BLW_QLFR_REP_CNT__c', Subject_Area__c = 'Managing Personal Reps', Datatype__c = 'Number');
        actItems.add(actItem);

        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Inactive', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = 'INACTV_1_3_CMPGN_CNT__c', Subject_Area__c = 'Managing Personal Reps', Datatype__c = 'Number');
        actItems.add(actItem);
        
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline',Category__c = 'G1 Candidates', Default__c = false,
                                      Genealogy_Criteria_Fld__c = null,Order_Criteria_Fld__c = 'GENRTN_1_APPT_CNT__c',
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Leader',
                                      Smry_Criteria_Fld__c = null,
                                      Subject_Area__c = 'Managing Personal Reps', Datatype__c = 'Currency');
        actItems.add(actItem);

        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Orders / Sales under minimum', Default__c = false,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = 'ActionItem_ORD_UND_MIN__c',
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null, Subject_Area__c = 'Orders', Datatype__c = 'Number');
        actItems.add(actItem);
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Minimum Orders Received', Default__c = true,
                                      Genealogy_Criteria_Fld__c = 'ActionItem_ORD_NOT_SUBMITTED__c', Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null, Subject_Area__c = 'Orders', Datatype__c = 'Currency');
        actItems.add(actItem);
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Minimum Orders Received', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = 'ANNIV_WITHIN_10_DAYS__c', Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null, Subject_Area__c = 'Orders', Datatype__c = 'Number');
        actItems.add(actItem);      

        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Return Orders', Default__c = false,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = 'ActionItem_ORD_UND_MIN__c',
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null, Subject_Area__c = 'Sales', Datatype__c = 'Number');
        actItems.add(actItem);
        
        actItem = new Action_Items__c(Action_Item_Type__c = 'Downline', Category__c = 'Net Sales', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = 'ActionItem_ORD_UND_MIN__c',
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null, Subject_Area__c = 'Sales', Datatype__c = 'Number');
        actItems.add(actItem);
                
        actItem = new Action_Items__c(Action_Item_Type__c = 'Summary', Category__c = 'New and In Progress Leads', Default__c = false,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null, Subject_Area__c = 'Managing Numbers', Datatype__c = 'Number');
        actItems.add(actItem);
        
        actItem = new Action_Items__c(Action_Item_Type__c = 'Summary', Category__c = 'New and In Progress Leads', Default__c = true,
                                      Genealogy_Criteria_Fld__c = null, Order_Criteria_Fld__c = null,
                                      Rep_Criteria_Fld__c = null, Zone_Or_Leader__c = 'Zone',
                                      Smry_Criteria_Fld__c = null,
                                      Subject_Area__c = 'Current Business', Datatype__c = 'Number');
        actItems.add(actItem);
        
        if (isInsert) { 
        	insert actItems;
        }
        
        return actItems;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarketActionItems
    // Description  : Create and Insert object : Market_Action_Items__c
    //---------------------------------------------------------------------------
    public static List <Market_Action_Items__c> createMarketActionItems(String marketId, List <Action_Items__c> actItems, boolean isInsert) {
        List <Market_Action_Items__c> mkActItems = new List <Market_Action_Items__c>();
        Market_Action_Items__c actItem ;
        integer cnt = 0;
        for (Action_Items__c ai: actItems) {
            actItem = new Market_Action_Items__c(Action_Item__c = ai.Id, Campaign_Stage__c = 10, Default__c = false,
                                                 Market__c = marketId, Priority__c = '' + cnt, Report__c = null, 
                                                 Threshold__c = 5, Campaign__c = 'Current;Next');
            mkActItems.add(actItem);
            cnt++;
        }
        
        if (isInsert) {       
        	insert mkActItems;  
        }
        for (Market_Action_Items__c mai : mkActItems) {
            for (Action_Items__c ai: actItems) {
                if (mai.Action_Item__r.id == ai.id) {
                    mai.Action_Item__r.Action_Item_Type__c = ai.Action_Item_Type__c;
                    mai.Action_Item__r.Category__c = ai.Category__c;
                    mai.Action_Item__r.Default__c = ai.Default__c;
                    mai.Action_Item__r.Genealogy_Criteria_Fld__c = ai.Genealogy_Criteria_Fld__c;
                    mai.Action_Item__r.Order_Criteria_Fld__c = ai.Order_Criteria_Fld__c;
                    mai.Action_Item__r.Zone_Or_Leader__c = ai.Zone_Or_Leader__c;
                    mai.Action_Item__r.Subject_Area__c = ai.Subject_Area__c;
                    mai.Action_Item__r.Datatype__c = ai.Datatype__c;
                }
        	} 
        }
        
        if (isInsert) {   
        	update  mkActItems;
        }
        return mkActItems;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMulRepPerformance
    // Description  : Create and Insert object : List of sObject
    //---------------------------------------------------------------------------
    public static List <sObject> createMulRepPerformance(List <String> ppKeys, String marketId, String ownerId, 
    							Market__c markt, String contactId, boolean isInsert) {
    	List <SObject> repPerformance = new List <SObject>();
        for (String k: ppKeys) {
        	//My Business
         	SObject repPerformanceInstance = Schema.getGlobalDescribe().get(markt.ALM_Rep_Indicator__c).newSObject() ;
            repPerformanceInstance.put('Name','Test MyBusiness' + k) ;
            repPerformanceInstance.put('Personal_Performance_Key__c', k) ;
            repPerformanceInstance.put('PRSNL_DSCNT_AMT__c', 1) ;
            repPerformanceInstance.put('MRKT_ID__c', marketId) ;
            repPerformanceInstance.put('GENRTN_1_QPA_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_APPT_CNT__c', 1) ;
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c', Decimal.valueOf(k.substring(2, 8))) ;
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c', k.substring(2, 8)) ;
            repPerformanceInstance.put('FRST_ORDR_AMT__c', 1) ;
            repPerformanceInstance.put('EXEC_ERNGS_AMT__c', 1) ;
            repPerformanceInstance.put('BONUS_ERNGS_AMT__c', 1) ;
            repPerformanceInstance.put('AVG_ORD_SIZE_AMT__c', 1) ;
            repPerformanceInstance.put('AVG_GENRTN_3_UNIT_COMM_PCT__c', 1) ;
            repPerformanceInstance.put('AVG_GENRTN_3_DISTR_SLS_PCT__c', 1) ;
            repPerformanceInstance.put('AVG_GENRTN_2_UNIT_COMM_PCT__c', 1) ;
            repPerformanceInstance.put('AVG_GENRTN_2_UNIT_COMM_PCT__c', 1) ;
            repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1') ;
            
            repPerformanceInstance.put('GENTRTN_1_ACTV_REP_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TOTAL_NEW_EXEC_TITL_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_9_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_9_NEW_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_8_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_8_NEW_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_7_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_7_NEW_STF_CNT__c', 1) ;
             repPerformanceInstance.put('GENRTN_1_TITL_6_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_6_NEW_STF_CNT__c', 1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_5_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_5_NEW_STF_CNT__c', 1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_4_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_4_NEW_STF_CNT__c', 1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_3_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_3_NEW_STF_CNT__c', 1) ; 
            repPerformanceInstance.put('GENRTN_1_TITL_2_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_2_NEW_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_1_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_TITL_1_NEW_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_STF_CNT__c', 1) ;
            repPerformanceInstance.put('GENRTN_1_STF_CNT__c', 1) ;
            repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c', '1') ;
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c', Decimal.valueOf(k.substring(2, 8))) ;
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c', k.substring(2, 8)) ;
            repPerformanceInstance.put('ACCT_NR__c', k.substring(8, k.length()));
            repPerformanceInstance.put('GENRTN_1_ACT_PCT__c', 1) ;
            repPerformanceInstance.put('MRKT_ACCT_KEY__c', contactId) ;
            repPerformanceInstance.put('LDRSHP_LOA_NR__c', 1) ;
            repPerformance.add(repPerformanceInstance);
		}
		
		if (isInsert) { 
        	insert repPerformance;
        }
        return repPerformance;        
    }  
    
    //---------------------------------------------------------------------------
    // Method Name  : createMarketMenu
    // Description  : Create and Insert object : Market_Menu__c
    //---------------------------------------------------------------------------
    public static Market_Menu__c createMarketMenu(String name, String link, String marketId, String typeVal, String seqNumber, String titleLevels,
    											  String userType, String parentMenuId, boolean isInsert){
    	
    	Market_Menu__c marketMenu = new Market_Menu__c(Name = name, Link__c = link,
                        							   Market__c = marketId, Type__c = typeVal, Sequence_Number__c = seqNumber,
							                           Title_Levels__c = titleLevels, User_Type__c = userType,
							                           Parent_Menu__c = parentMenuId);
       if (isInsert) {
       		insert marketMenu;
       }
       return marketMenu;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createDocument
    // Description  : Create and Insert object : Document
    //---------------------------------------------------------------------------
    public static Document createDocument(boolean isInsert) {    	
		Document doc = new Document();
		doc.ContentType = 'image/png';
		doc.Name = 'testdoc1.png';
		doc.IsPublic = true;
		doc.Url = 'testURL';
		doc.FolderId = System.Userinfo.getUserId();	
		if(isInsert){
			insert doc;
		}
		return doc;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createCalendar
    // Description  : Create and Insert object : Calendar__c
    //---------------------------------------------------------------------------
    public static Calendar__c createCalendar(Decimal campaignNum, String marMarketId, Integer year, String marketId, boolean isInsert) {    	
		Calendar__c cal = new Calendar__c();
		cal.CMPGN_NR__c = campaignNum; 
		cal.MRKT_ID__c = marMarketId; 
		cal.YEAR_NR__c = year;
		cal.Market__c = marketId;
		if (isInsert) {
			insert cal;
		}
		return cal;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createSalesLeaderHistory
    // Description  : Create and Insert object : Sales_Leader_History__c
    //---------------------------------------------------------------------------
    public static Sales_Leader_History__c createSalesLeaderHistory(String contactId, boolean isInsert) {    	
		Sales_Leader_History__c salesLeaderHistory = new Sales_Leader_History__c();
		salesLeaderHistory.PD_TITL_LVL_NR__c = '2';
		salesLeaderHistory.SPPY_PD_TITL_LVL_NR__c = '1';
		salesLeaderHistory.FLD_SLS_CMPGN_NR__c = 201305.0;
		salesLeaderHistory.GENRTN_1_TITL_10_STF_CNT__c = 100;
		salesLeaderHistory.SPPY_GENRTN_1_TITL_10_STF_CNT__c = 99;
		salesLeaderHistory.EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c = 200;
		salesLeaderHistory.SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c = 100;
		salesLeaderHistory.GENRTN_1_TITL_5_STF_CNT__c = 150;
		salesLeaderHistory.SPPY_GENRTN_1_TITL_5_STF_CNT__c = 120;
		salesLeaderHistory.GENRTN_1_TITL_4_STF_CNT__c  = 100;
		salesLeaderHistory.SPPY_GENRTN_1_TITL_4_STF_CNT__c = 171;
		salesLeaderHistory.GENRTN_1_TITL_3_STF_CNT__c = 191;
		salesLeaderHistory.SPPY_GENRTN_1_TITL_3_STF_CNT__c = 170;
		salesLeaderHistory.EXEC_UNIT_SLS__c = 100;
		salesLeaderHistory.SPPY_EXEC_UNIT_SLS__c = 100;
		salesLeaderHistory.EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c = 100;
		salesLeaderHistory.SPPY_EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c = 100;
		salesLeaderHistory.EXGENRTN_3_TOTAL_EXEC_TITL_STF_CNT__c = 100;
		salesLeaderHistory.SPPY_EXGENRTN_TH_TOTAL_EXEC_TITL_STF_CNT__C = 100;
		salesLeaderHistory.TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c = 22;
		salesLeaderHistory.SPPY_TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c = 55;
		salesLeaderHistory.CUST_CNT__c = 55;
		salesLeaderHistory.SPPY_CUST_CNT__c = 55;
		salesLeaderHistory.SPPY_PRSNL_SLS_AMT__c = 988.00;
		salesLeaderHistory.GENRTN_1_APPT_CNT__c = 55;
		salesLeaderHistory.SPPY_GENRTN_1_APPT_CNT__c = 33;
		salesLeaderHistory.GENRTN_1_QPA_CNT__c = 100;
		salesLeaderHistory.SPPY_GENRTN_1_QPA_CNT__c = 100;
		salesLeaderHistory.RTURNS_PCT__c = 100;
		salesLeaderHistory.Contact__c = contactId;
		
		if (isInsert) {
			insert salesLeaderHistory;
		}
		return salesLeaderHistory;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createGenealogyData
    // Description  : Create and Insert object : Genealogy Records
    //---------------------------------------------------------------------------
    public static void createGenealogyData(String acctNbr, Market__c market,     										
    										Integer noOfLevels, 
    										Contact leaderContact,
    										List<Contact> lstContact,
    										boolean isInsert) {
        
        Integer level = 1;
        Integer noOfNodes = 0;
        Integer leftValue = 2;
        Integer rightValue;
        Integer increment;
      
               
        //initialize the list to store the list of rep performance records to be inserted for entities other than leader
        List <SObject> repPerfData = new List <SObject>();
        SObject repPerformanceInstance=Schema.getGlobalDescribe().get(market.ALM_Rep_Indicator__c).newSObject() ;
        repPerformanceInstance.put('Name','Test Rep1');
        repPerformanceInstance.put('ACCT_NR__c',acctNbr);
        repPerformanceInstance.put('Genealogy_Level__c',0);
        repPerformanceInstance.put('CurrencyISOCode','USD');
        repPerformanceInstance.put('MRKT_ID__c',market.Market_Id__c);
        repPerformanceInstance.put('MRKT_ACCT_KEY__c',leaderContact.Id);
        //repPerformanceInstance.put('CurrencyISOCode','ISO');
        repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(market.CMPGN_NR__c));
        repPerformanceInstance.put('OPERTNL_CMPGN_NR__c',market.CMPGN_NR__c);
        repPerformanceInstance.put('Personal_Performance_Key__c',market.Market_Id__c + market.CMPGN_NR__c + acctNbr);
        repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1');
        repPerformanceInstance.put('AVON_LOA_1_6_IND__c','Y');
        repPerformanceInstance.put('LDRSHP_LOA_NR__c',1);
        repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c','1');
        repPerformanceInstance.put('ALL_DWNLN_CNT__c',5);
        repPerformanceInstance.put('LFT_ND_ID__c',1);
        repPerformanceInstance.put('RGT_ND_ID__c',(Math.pow(2,(noOfLevels+1))-2));
          
        insert repPerformanceInstance;
        
        //compute the increment for all levels
        Map <Integer,List <Integer>> incForAllLevels = TestDataHelper.computeIncforLevelsStatic(noOfLevels);
        
        //create the rep performance records for every node in the tree
        for (Integer accntNrIndex = 0; accntNrIndex < Math.pow(2, noOfLevels) - 2; accntNrIndex++) {
        	//the level is finished, increment level and reset noOfNodes
            Integer lftRgtDifference = computerPowerSumStatic((noOfLevels + 1) - level);
            rightValue = leftValue + lftRgtDifference;
            
            String downloadOnlyInd = Math.mod(accntNrIndex, 2) == 0 ? 'Y' : 'N';
            
            repPerformanceInstance=Schema.getGlobalDescribe().get(market.ALM_Rep_Indicator__c).newSObject() ;
            repPerformanceInstance.put('Name', 'Test Rep1');
            repPerformanceInstance.put('ACCT_NR__c', acctNbr + '_' + accntNrIndex);
            repPerformanceInstance.put('Genealogy_Level__c', 0);
            repPerformanceInstance.put('CurrencyISOCode', 'USD');
            repPerformanceInstance.put('MRKT_ID__c', market.Market_Id__c);
            repPerformanceInstance.put('MRKT_ACCT_KEY__c', lstContact[accntNrIndex].Id);
            repPerformanceInstance.put('FLD_SLS_CMPGN_NR__c', Decimal.valueOf(market.CMPGN_NR__c));
            repPerformanceInstance.put('OPERTNL_CMPGN_NR__c', market.CMPGN_NR__c);
            repPerformanceInstance.put('Personal_Performance_Key__c', market.Market_Id__c + market.CMPGN_NR__c + acctNbr + '_' + accntNrIndex);
            repPerformanceInstance.put('REP_OMS_STUS_CD__c', '1');
            repPerformanceInstance.put('DWNLN_ONLY_IND__c', downloadOnlyInd);
            repPerformanceInstance.put('AVON_LOA_1_6_IND__c', 'Y');
            repPerformanceInstance.put('LDRSHP_LOA_NR__c', 1);
            repPerformanceInstance.put('LDRSHP_TITL_LVL_NR__c', '1');
            repPerformanceInstance.put('LFT_ND_ID__c', leftValue);
            repPerformanceInstance.put('RGT_ND_ID__c', rightValue);
                
            repPerfData.add(repPerformanceInstance);
             
            if (noOfNodes == (math.pow(2, level)) - 1) {
                level++;
                noOfNodes = 0;
                leftValue = level + 1;
            } else {
                increment = incForAllLevels.get(level).get(noOfNodes);
                leftValue = rightValue + increment;
                noOfNodes++;
            }
        }
        
        //Insert list of all rep performance data  
        if (isInsert) {                                 
        	insert repPerfData;   
        }                      
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : computeIncforLevelsStatic
    // Description  : Create and Insert object : Inc For Level Static
    //---------------------------------------------------------------------------
    public static Map <Integer, List <Integer>> computeIncforLevelsStatic(Integer noOfLevels) {
        Map <Integer, List <Integer>> incForAllLevels=new Map <Integer, List <Integer>>();
        List <Integer> prevLevelIncs=new List <Integer>();
        List <Integer> currentLevelIncs=new List <Integer>();
        Integer currentLevelValue;
        // 0 - Root, 1 - it is always 1, we compute from level 2 onwards
        for (Integer i = 1; i < noOfLevels; i++) {
            //initialize current every time
            currentLevelIncs=new List <Integer>();
            currentLevelValue=(2*(i-1)) + 1;
            currentLevelIncs.addAll(prevLevelIncs);
            currentLevelIncs.add(currentLevelValue);
            currentLevelIncs.addAll(prevLevelIncs);
            //populate the map for the current level
            incForAllLevels.put(i,currentLevelIncs);
            prevLevelIncs=currentLevelIncs;
        }
        
        return incForAllLevels;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : computerPowerSumStatic
    // Description  : Create and Insert object : Power Sum Static
    //---------------------------------------------------------------------------
    private static Integer computerPowerSumStatic(Integer endPower) {
        return Integer.valueOf((Math.pow(2, endPower)) - 3);
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createRepDetailField
    // Description  : Create and Insert object : Rep_Detail_Field__c
    //---------------------------------------------------------------------------
    public static Rep_Detail_Field__c createRepDetailField(String name, boolean isInsert) {    	
		Rep_Detail_Field__c repDetail = new Rep_Detail_Field__c();
		repDetail.Name = name;
		repDetail.isZeroRow__c = true;
		repDetail.isTransitionLdr__c = true;
		repDetail.isRuntime__c = true;
		repDetail.isNonLdr__c = true;
		repDetail.Type__c = 'Number';
		repDetail.Order__c = 2.0;
		repDetail.Group__c = 'Contact';
		repDetail.Column__c = '';
		repDetail.Fields_To_Map__c = 'ALM_Rep_Performance_1:LDRSHP_TITL_LVL_NR__c:LDRSHP_LOA_NR__c';
		if (isInsert) {
			insert repDetail;
		}
		return repDetail;
    }
    
    
    //---------------------------------------------------------------------------
    // Method Name  : createReportConfig
    // Description  : Create and Insert object : Report_Config__c
    //---------------------------------------------------------------------------
    public static Report_Config__c createReportConfig(String name, String mktId, 
    								String reportType, String applicableTo,
    								String reportId, String repCriteria,
    								String orderCriteria, 
    								String colToDisplay, String titleLvlNbr,
    								Integer reportSeq, Integer maxPageLimit,
    								boolean isInsert){
        
        Report_Config__c rc = new Report_Config__c();       
        rc.Name = name;
        rc.Report_Type__c = reportType; 
        rc.Market__c = mktId;
        rc.Applicable_To__c = applicableTo;
        rc.Report_Id__c = reportId;
        rc.Rep_Criteria__c = repCriteria;
        rc.Order_Criteria__c = orderCriteria;
        rc.TITL_LVL_NBR__c = titleLvlNbr;
        rc.T_List_Page_Size__c = 500;
        rc.Page_Size__c = 200;
        rc.Max_Page_Limit__c = maxPageLimit;
        rc.Columns_To_Display__c = colToDisplay;
        rc.Report_Sequence__c = reportSeq;
        rc.Number_of_Historical_Cmpgns_for_Filter__c = 1;
        if(isInsert){
        	insert rc;
        }
        return rc;
    }
    
     //---------------------------------------------------------------------------
    // Method Name  : createReportColumn
    // Description  : Create and Insert object : Report_Column_New__c
    //---------------------------------------------------------------------------
    public static Report_Column_New__c createReportColumn(String reportConfigId, String name,
						     Integer displayOrder, String fullyQualifiedName, 
						     String fullyQualifiedName2, String colDisplayType,
						     String colType, String visibility, boolean isInsert){
        
        Report_Column_New__c reportColumn = new Report_Column_New__c(Name = name, 
        								Report_Config__c = reportConfigId, 
        								Width__c=109, Display_Order__c = displayOrder, 
        								Fully_Qualified_Name__c = fullyQualifiedName,  
                                        Fully_Qualified_Name2__c = fullyQualifiedName2, 
                                        Column_Display_Type__c = colDisplayType, 
                                        Type__c = colType, 
                                        Visibility__c = visibility);
        if(isInsert){
        	insert reportColumn; 
        } 
        return reportColumn;    
    } 
    
      //---------------------------------------------------------------------------
    // Method Name  : createReportFilter
    // Description  : Create and Insert object : Report_Filter__c
    //---------------------------------------------------------------------------
    public static Report_Filter__c createReportFilter(String reportConfigId, String name, 
									    String filterCritera, String generationDepth, 
									    String filterType, String filterKey, 
									    String sortOrder, boolean isInsert){
               
        Report_Filter__c reportFilter = new Report_Filter__c(Name = name, 
        								Report_Config__c = reportConfigId, 
								        Filter_Criteria__c = filterCritera,  
								        Generations_Depth__c = generationDepth, 
								        Is_Rep_List_Restricted__c = true,
                                        Filter_Type__c = filterType, 
                                        Is_Drillable__c = true, 
                                        Is_Sortable__c = true, 
                                        Filter_Key__c = filterKey, 
                                        Sort_Order__c = sortOrder);       
        if(isInsert){
        	insert reportFilter; 
        } 
        return reportFilter;    
    } 
    
    //---------------------------------------------------------------------------
    // Method Name  : createReportPrint
    // Description  : Create and Insert object : Report_Print__c
    //---------------------------------------------------------------------------
    public static Report_Print__c createReportPrint(String mktId, Integer columns, Integer height, 
    												 Integer width, boolean isInsert){
        Report_Print__c rp = new Report_Print__c();
        rp.Name = mktId;
        rp.Fixed_columns__c = columns;
        rp.Height__c = height;
        rp.Width__c = width;
        
        if(isInsert){
        	insert rp;
        }
        return rp;
    } 
    
    //---------------------------------------------------------------------------
    // Method Name  : createGenealogyFieldDetail
    // Description  : Create and Insert object : Genealogy_Field_Detail__c
    //---------------------------------------------------------------------------
    public static Genealogy_Field_Detail__c createGenealogyFieldDetail(String name, String fType, 
    													Integer fOrder, String fGroup, String fieldsToMap,
    													String column, boolean isInsert){
    	Genealogy_Field_Detail__c gFieldDetail = new Genealogy_Field_Detail__c();
	    gFieldDetail.Type__c = fType; 
	    gFieldDetail.Order__c = fOrder; 
	    gFieldDetail.Name = name; 
	    gFieldDetail.Group__c = fGroup; 
	    gFieldDetail.Fields_To_Map__c = fieldsToMap;
	    gFieldDetail.Column__c = column;
	    if(isInsert){
	    	insert gFieldDetail;
	    }
	    return gFieldDetail;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createCustomMessagesList
    // Description  : Obtain List of Objects : List of Custom_Message__c
    //---------------------------------------------------------------------------
    public static List <Custom_Message__c> createCustomMessagesList(Market__c mrkt, String ownerId, boolean isInsert) {
        List <Custom_Message__c> listMessages = new List <Custom_Message__c>();
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_view_my_orders', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_titled', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ri_earned_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ri_earned_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_toreach_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_toreach_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'li_needed_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'li_needed_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        
        if (isInsert) {
        	insert listMessages;
        }
        
        return listMessages;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createEcardHistory
    // Description  : Create and Insert object : ECard_History__c
    //---------------------------------------------------------------------------
    public static ECard_History__c createEcardHistory(String ownerId, String name,
    													boolean isInsert){
    	Ecard_History__c ecardHist = new ECard_History__c(OwnerId=ownerId, 
    									Name=name);
    	if(isInsert){
    		insert ecardHist;
    	}
    	return ecardHist;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createIncentive
    // Description  : Create and Insert object : Incentive__c
    //---------------------------------------------------------------------------
    public static Incentive__c createIncentive(String mrktId, String campaignNumber, boolean isInsert) {
    	Incentive__c incent = new Incentive__c();
    	incent.INCNTV_REQ_CNT__c = 2.0;
    	incent.Type__c = 'team';
    	incent.TITL_LVL_NR__c = '1';
    	incent.INCNTV_PRODCT_NM__c = '1'; 
    	incent.CMPGN_NR__c = campaignNumber;
    	incent.LANG_CD__c = 'en_US';
    	incent.Market__c = mrktId;
    	
    	if (isInsert) {
    		insert incent;
    	}
    	
    	return incent;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createALMRepPerformance
    // Description  : Create and Insert object : ALM_Rep_Performance_1__c
    // Insert ALM Rep Performance records for each contact for each campaign
    //---------------------------------------------------------------------------
    public static ALM_Rep_Performance_1__c createALMRepPerformance(String accNr,
    										String uplnAccNr,
    										String rootUplnAccNr,    										
    										Integer genealogyLevel,
    										Id conId,  
    										String marketId,
    										Decimal fldSLSCmpgnNR,
    										String operationalCamaignNo,  
    										Integer lft, Integer rgt, boolean isInsert){
    	ALM_Rep_Performance_1__c rep = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', 
                                                ACCT_NR__c = accNr,
                                                UPLN_ACCT_NR__c = uplnAccNr,
                                                Genealogy_Level__c = genealogyLevel,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c = marketId,
                                                MRKT_ACCT_KEY__c = conId,
                                                FLD_SLS_CMPGN_NR__c=fldSLSCmpgnNR,
                                                OPERTNL_CMPGN_NR__c = operationalCamaignNo,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = rootUplnAccNr,
                                                LFT_ND_ID__c = lft, RGT_ND_ID__c = rgt
                                            );
    	if(isInsert){
    		insert rep;
    	}
    	return rep;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createALMRepPerformance
    // Description  : Create and Insert object : ALM_Rep_Performance_1__c
    // Insert ALM Rep Performance records for each contact for each campaign
    //---------------------------------------------------------------------------
    public static ALM_Rep_Performance_1__c createALMRepPerformance(String accNr,
    										String uplnAccNr,
    										String rootUplnAccNr,    										
    										Integer genealogyLevel,
    										Id conId,  
    										String marketId,
    										Decimal fldSLSCmpgnNR,
    										String operationalCamaignNo,  
    										Integer lft, Integer rgt, 
    										Integer grpInvcAwrdAmt,
    										Integer grpSubmtdAwrdAmt,
    										Integer grpInvcdBlckdAwrdAmt,
    										Integer invcAwrdAmt,
    										Integer submitAwrdAmt, 
    										String ledrshpTitleLvl,   										
    										boolean isInsert){
    	ALM_Rep_Performance_1__c rep = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', 
                                                ACCT_NR__c = accNr,
                                                UPLN_ACCT_NR__c = uplnAccNr,
                                                Genealogy_Level__c = genealogyLevel,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c = marketId,
                                                MRKT_ACCT_KEY__c = conId,
                                                FLD_SLS_CMPGN_NR__c=fldSLSCmpgnNR,
                                                OPERTNL_CMPGN_NR__c = operationalCamaignNo,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = ledrshpTitleLvl,
                                                ROOT_UPLN_ACCT_NR__c = rootUplnAccNr,
                                                LFT_ND_ID__c = lft, RGT_ND_ID__c = rgt,
                                                GRP_INVC_AWRD_SLS_AMT__c = grpInvcAwrdAmt,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = grpSubmtdAwrdAmt,
                                                GRP_INVCD_BLCKD_SLS_AMT__c = grpInvcdBlckdAwrdAmt,
                                                INVC_AWRD_SLS_AMT__c = invcAwrdAmt,
                                                SUBMTD_AWRD_SLS_AMT__c = submitAwrdAmt
                                            );
    	if(isInsert){
    		insert rep;
    	}
    	return rep;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createDownloadAllGenIndex
    // Description  : Create and Insert object : DownloadAll_GenIndex__c
    //---------------------------------------------------------------------------
    public static DownloadAll_GenIndex__c createDownloadAllGenIndex(String marketId, String marketCampaign, boolean isInsert) {
    	DownloadAll_GenIndex__c downloadGen = new DownloadAll_GenIndex__c();
    	downloadGen.Name = 'Test Download 1';
    	downloadGen.Data_Object_Name__c = 'ALM_Rep_Performance_1__c';
    	downloadGen.Market_Id__c = marketId;
    	downloadGen.Gen_Index__c = 1.0;
    	downloadGen.Accnt_Nr__c = marketId;
    	downloadGen.SelectedCampaign__c = marketCampaign;
    	
    	if (isInsert) {
    		insert downloadGen;
    	}
    	return downloadGen;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createBusinessPlanParameter
    // Description  : Create and Insert object : Business_Plan_Parameter__c
    //---------------------------------------------------------------------------
    public static Business_Plan_Parameter__c createBusinessPlanParameter(String marketId, boolean isInsert) {
    	Business_Plan_Parameter__c businessPlanParam = new Business_Plan_Parameter__c();
    	businessPlanParam.Name = 'testBppar';
    	businessPlanParam.Market_Id__c = marketId; 
        businessPlanParam.AVG_LVL_1_G1_UNIT_COMMSN_PCT__c = 3.0;
        businessPlanParam.AVG_LVL_1_G1_DSTRBTN_PCT__c = 3.0;
        businessPlanParam.AVG_LVL_1_G2_UNIT_COMMSN_PCT__c = 3.0;
        businessPlanParam.AVG_LVL_1_G2_DSTRBTN_PCT__c = 3.0; 
        businessPlanParam.AVG_LVL_1_G3_UNIT_COMMSN_PCT__c = 3.0; 
        businessPlanParam.AVG_LVL_1_G3_DSTRBTN_PCT__c = 3.0;
        
        if (isInsert) {
        	insert businessPlanParam;
        }
        
        return businessPlanParam;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createBusinessPlan
    // Description  : Create and Insert object : Business_Plan__c
    //---------------------------------------------------------------------------
    public static Business_Plan__c createBusinessPlan(String markMarketId, User testUsr, String bPParamId, boolean isInsert) {
    	Business_Plan__c businessPlan = new Business_Plan__c();
    	businessPlan.Mrkt_Id_Acct_Nr_Key__c = testUsr.MRKT_ID_ACCT_NR_KEY__c;
    	businessPlan.Market_Id__c = markMarketId;
    	businessPlan.IsDeleted__c = false;
    	businessPlan.Is_BP_Saved__c = true; 
        businessPlan.PRSNL_DEV_PLN_ACTN3__c = 'TEST_PLN3'; 
        businessPlan.TOP_SLR_ACTN3__c = 'TEST_TOP_SLR_3';
        businessPlan.Long_Term_Dreams__c = 'TEST_LONTRMDRM';
        businessPlan.RSNG_STR_DEV_ACTN2__c = 'TEST_RSNGSTAR_ACT';
        businessPlan.FLWUP_MTG_60__c = System.today(); 
        businessPlan.Personal_Achievement__c = 'TEST_PRSN_ACHV';
        businessPlan.LDRSHP_TITL_ACTN2__c = 'TEST_LDR_TITLE';
        businessPlan.Short_Term_Goals__c = 'TEST_SHRT_GL';
        businessPlan.Unit_Achievement__c = 'TEST_UNT_ACHV'; 
        businessPlan.Key_Learnings__c = 'TEST_KEY_LRNG';
        businessPlan.RECR_ACTN1__c = 'TEST_RECR_ACT_1'; 
        businessPlan.Campaign_Numbers__c = '191202.0;191203.0;191204.0;191205.0;191206.0;191207.0;191208.0;191209.0;191210.0;191211.0;191212.0';
        businessPlan.CMPGN_NR__c = '191203.0'; 
        businessPlan.Current_campaign__c = '191203.0'; 
        businessPlan.NEXT_1_CMPGN_NR__c = '191204.0';
        businessPlan.NEXT_2_CMPGN_NR__c = '191204.0'; 
        businessPlan.NEXT_3_CMPGN_NR__c = '191205.0';
        businessPlan.NEXT_4_CMPGN_NR__c = '191206.0'; 
        businessPlan.NEXT_5_CMPGN_NR__c = '191207.0';
        businessPlan.NEXT_6_CMPGN_NR__c = '191208.0';
        businessPlan.Business_Plan_Parameter__c = bPParamId;
        businessPlan.OwnerId = testUsr.Id;
    	
    	if (isInsert) {
    		insert businessPlan;
    	}
    	
    	return businessPlan;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createX90DBPSetting
    // Description  : Create and Insert object : X90DBP_settings__c
    //---------------------------------------------------------------------------
    public static X90DBP_settings__c createX90DBPSetting(String name, String kPIName, boolean isInsert) {
    	X90DBP_settings__c x90DBP = new X90DBP_settings__c();
    	x90DBP.Name = name;
    	x90DBP.KPI_Name__c = kPIName;
    	x90DBP.isFuture__c = 'true';
    	x90DBP.PC_Field_Name__c = 'GENRTN_1_QPA_CNT__c';
    	x90DBP.Variance_Field_Name__c = 'VAR_GENRTN_1_TITL_1_STF_CNT__c';
    	x90DBP.CC_Field_Name__c = 'GENRTN_1_TITL_2_STF_CNT__c';
		x90DBP.CC_1_Field_Name__c = 'GENRTN_1_TITL_1_STF_CNT__c';
		x90DBP.CC_2_Field_Name__c = 'ActiveRepCountCC_3__c';
		x90DBP.CC_3_Field_Name__c = 'ActiveRepCountCC_4__c';
		x90DBP.CC_4_Field_Name__c = 'ActiveRepCountCC_5__c';
		x90DBP.CC_5_Field_Name__c = 'ActiveRepCountCC_6__c';
		x90DBP.CC_6_Field_Name__c = 'GENRTN_1_TITL_3_STF_CNT__c';
    	if (isInsert) {
    		insert x90DBP;
    	}
    	
    	return x90DBP;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLocaleDateFormat
    // Description  : Create and Insert object : Locale_Date_Format__c
    //---------------------------------------------------------------------------
    public static Locale_Date_Format__c createLocaleDateFormat(boolean isInsert) {
    	Locale_Date_Format__c locale = new Locale_Date_Format__c();
    	locale.Name = 'en_US';
    	locale.DateFormat__c = 'MM/dd/yyyy';
    	
    	if (isInsert) {
    		insert locale;
    	}
    	
    	return locale;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : creatMailPlans
    // Description  : Create and Insert object : MailPlan_Order_Oppty__c
    //---------------------------------------------------------------------------
    public static MailPlan_Order_Oppty__c creatMailPlans(Market__c mrkt, String zone, boolean isInsert) {
        MailPlan_Order_Oppty__c mpOrdOppty = new MailPlan_Order_Oppty__c();
        mpOrdOppty.MRKT_ID__c = mrkt.Market_Id__c;
        mpOrdOppty.CMPGN_NR__c = mrkt.CMPGN_NR__c.substring(mrkt.CMPGN_NR__c.length() -2);
        mpOrdOppty.SLS_ZONE_CD__c = zone;
        mpOrdOppty.CurrencyISOCode = 'USD'; 
        mpOrdOppty.MLPLN_CLOSD_IND__c = 'N';
        mpOrdOppty.MLPLN_END_DT__c = System.today();
        mpOrdOppty.Market__c = mrkt.Id;
        mpOrdOppty.NEXT_MLPLN_TO_CLOS_CD__c = 'A, B';
        
        if (isInsert) {                                                                  
        	insert  mpOrdOppty; 
        }
        
        return mpOrdOppty;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLeaderDownlineSummary
    // Description  : Create and Insert object : Leader_Downline_Summary__c
    //---------------------------------------------------------------------------
    public static Leader_Downline_Summary__c createLeaderDownlineSummary(Contact con, Market__c mrkt, boolean isInsert) {
    	Leader_Downline_Summary__c leaderDownLine = new Leader_Downline_Summary__c();
    	leaderDownLine.Leadership_Summary_Key__c = con.ACCT_NR__c;
        leaderDownLine.CurrencyISOCode = 'USD';
        leaderDownLine.MRKT_ID__c = mrkt.Market_ID__c;
        leaderDownLine.MRKT_ACCT_KEY__c = con.Id;
        leaderDownLine.GRP_SUBMTD_AWRD_SLS_AMT__c = 200;
        leaderDownLine.GENTRTN_1_ACTV_REP_CNT__c = 2;
        leaderDownLine.TTL_LEG_CNT__c = 2;
        leaderDownLine.GENRTN_1_TITL_1_STF_CNT__c = 1;
        leaderDownLine.GENRTN_1_TITL_2_STF_CNT__c = 2;
        leaderDownLine.GENRTN_1_TITL_3_STF_CNT__c = 3;
        leaderDownLine.GENRTN_1_TITL_4_STF_CNT__c = 4;
        leaderDownLine.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
        leaderDownLine.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
        leaderDownLine.ACCT_NR__c = String.valueOf(con.ACCT_NR__c);
        
        if (isInsert) {
        	insert leaderDownLine;
        }
    	
    	return leaderDownLine;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createMyBusiness
    // Description  : Create and Insert object : My_Business__c
    //---------------------------------------------------------------------------
    public static My_Business__c createMyBusiness(Contact con, Market__c mrkt, boolean isInsert) {
    	My_Business__c myBus = new My_Business__c();
    	myBus.MRKT_ACCT_KEY__c = con.Id;
	    myBus.Name = 'First1 Last1';
	    myBus.MRKT_ID__c = mrkt.Market_Id__c;
	    myBus.ACCT_NR__c = String.valueOf(con.ACCT_NR__c);
	    myBus.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
	    myBus.LDRSHP_TITL_LVL_NR__c = '1';
	    myBus.SUBMTD_AWRD_SLS_AMT__c = 200;
	    myBus.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
	    myBus.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + String.valueOf(con.ACCT_NR__c);
	    myBus.CurrencyIsoCode = 'USD';
	    myBus.REP_OMS_STUS_CD__c = '1';
		myBus.AVON_LOA_1_6_IND__c = 'Y';
	    myBus.LDRSHP_LOA_NR__c = 1;
    	
    	if (isInsert) {
    		insert myBus;
    	}
    	
    	return myBus;
    }
    
    //---------------------------------------------------------------------------
    // Method Name  : createLead
    // Description  : Create and Insert object : Lead
    //---------------------------------------------------------------------------
    public static Lead createLead(User owner, Boolean isInsert) {
	    Lead tempLead = new Lead(FirstName = 'Avon Lead Fname',
						         LastName = owner.ACCT_NR__c+'LName',
						         Company = 'Avon Test',
						         Email = 'alm.noreply@avon.com',
						         MobilePhone = '7827373',
						         Confirm_Email__c = 'alm.noreply@avon.com',
						         Type__c = 'FGL',
						         Lead_Owner__c = owner.Id,
						         MRKT_ID__c = owner.MRKT_ID__c,
						         SLS_DIV_NM__c = owner.DFALT_DIV_NM__c,
						         SLS_ZONE_CD__c = owner.DFALT_ZONE_CD__c,
						         Status = ALMPLusConstants.LEAD_STS_NEW
	    );
	    
	    if (isInsert) {
    		insert tempLead;
    	}    	
    	return tempLead;    
	}
	
	//---------------------------------------------------------------------------
    // Method Name  : createApexLogSetting
    // Description  : Create and Insert object : ApexLogSettings__c
    //---------------------------------------------------------------------------
	public static ApexLogSettings__c createApexLogSetting(Boolean isInsert){
		ApexLogSettings__c logSetting = new ApexLogSettings__c();
		logSetting.Name = 'Default';
		logSetting.Active__c = true;
		logSetting.MaxDays__c = 5;
		logSetting.MaxRecords__c = 5;
		
		if(isInsert)
			insert logSetting;
		
		return logSetting;
	}
	
	//---------------------------------------------------------------------------
    // Method Name  : createErrorMessage
    // Description  : Create and Insert object : Error_Message__c
    //---------------------------------------------------------------------------
	public static Error_Message__c createErrorMessage(String pgName, String message, Boolean isInsert){
		Error_Message__c errMsg = new Error_Message__c();
		errMsg.Page_Occurred__c = pgName;
		errMsg.Error_Message__c = message;
		
		if(isInsert)
			insert errMsg;
		
		return errMsg;		
	}
    
}