/**
    Activity History:  
    Shah Kadirmohideen - 10/10 - Code Reviewed (look for CRF: to view code review feedback comments)
    Milon Dey - 04/20/2012 - Migrated from ITTest to DEV3
*/
public class DisplayWidgetsController {
    
    //Action Item properties
    public List<SObject> combobjRec {get; set;}
    public List<Decimal> cmpnNbr {get; private set;}
    public String actionItemCampaign {get; set;}
    public List<Market_Action_Items__c> mkt_action_item{get; private set;}
    public List<SObject> leadRecs { get; set; }
    public String repAcctNbr { get; private set; }
    public String repMktAcctNbr {get; private set;}
    public String mktId {get; private set;}
    public String userProfile {get; set;}
    public String userKey {get; set;}
    public String userLang {get; set;}
    public String aslfMktId {get; set;}
    public String acctNbr {get; set;}
    
    //activation properties
    private static String MRKT_ID = 'mktcd';  
    private static String ACCT_NR = 'acctnbr';
    private static String LANG_CD = 'langcd'; 
    private static String KEY = 'key';  
    private static String DEBUG = 'debug';
    //added for ALM+ by Snehashis
    private static String PGID = 'pgId';
    public User currUsr {get; set;} 
    public String stsMsg {get; private set;}
    private static String DATE_FORMAT = 'MM/dd/yyyy'; 
    public Market__c market {get; set;}
    public Boolean isFailure {get; set;}
    public ALM_Global_Settings__c globalConfig {
        get {
            return ALM_Global_Settings__c.getValues('ALM Default');
        }
        private set;
    }

    public PageReference init() {
        isFailure=false;
        String ldrSoql='';
		String perfSoql='';
		String conSoql='';
		String obj_to_query='';
        String debugFlag = ApexPages.currentPage().getParameters().get(DEBUG);
        if(debugFlag ==null){
            debugFlag='0';
        }
        try{
            this.aslfMktId = ApexPages.currentPage().getParameters().get(MRKT_ID);
            this.acctNbr = ApexPages.currentPage().getParameters().get(ACCT_NR);
            this.userKey = ApexPages.currentPage().getParameters().get(KEY);
            this.userLang = ApexPages.currentPage().getParameters().get(LANG_CD);
            //added for changing the language
            if(this.userLang!=null){
                Gi3_Language_Mapping__c langConfig = Gi3_Language_Mapping__c.getValues(this.userLang);
                try{
                    this.userLang = (langConfig.Gi3_Lang_code__c!=null?langConfig.Gi3_Lang_code__c:'en_US');
                }catch(Exception ex){
                    this.userLang = 'en_US';  
                }
            }
            ALMLogUtils.log('DisplayWidgetsController','aslfMktId='+aslfMktId+' and acctNbr='+acctNbr);
            //Changes by snehashis for ALM+
            String pgidVal; 
            try{
                pgidVal=ApexPages.currentPage().getParameters().get(PGID);
            }catch(exception ex){}  //CRF: what is the need of exception handling here?
            ALMLogUtils.log('DisplayWidgetsController','pgId='+pgidVal);
            ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
            String SHARED_SECRET = globalConfig.Shared_Secret__c;
            this.market = [ select Market_Id__c,GI3_Keep_Alive_URL__c,ASLF_Timezone_Offset__c,Name, Mail_Plan_Enabled__c, OPERTNL_CMPGN_CMPLTN_PCT__c,CMPGN_NR_NUMBER__c,
                            Site_Maintenance_Enabled__c, Splash_Page_Enabled__c,Enabled_Action_Item__c,Omniture_Suite_Name__c,Is_ALMPLUS_Enabled__c,
                            CURRENT_CAMPAIGN_NR__c , CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_END_DT__c, ALM_Rep_Indicator__c 
                            from Market__c 
                            where ASLF_Market_ID__c=:aslfMktId];  //CRR: move the SOQL to utility class as it is used frequently in other classes.
            //adding Campaign number
            String dateStr = System.now().format(DATE_FORMAT);
            ALMLogUtils.log('DisplayWidgetsController','dateStr='+dateStr);
            String toHash = aslfMktId+acctNbr+dateStr+SHARED_SECRET;
            ALMLogUtils.log('DisplayWidgetsController','Before MD5 Hashing='+toHash);
            Blob blobValue = Blob.valueOf(toHash);
            Blob hash = Crypto.generateDigest('MD5', blobValue);
            String expectedMd5 = EncodingUtil.convertToHex(hash);
            dateStr = System.now().addDays(1).format(DATE_FORMAT);
            toHash = aslfMktId+acctNbr+dateStr+SHARED_SECRET;
            ALMLogUtils.log('DisplayWidgetsController','Before MD5 Hashing(+1 day)='+toHash);
            blobValue = Blob.valueOf(toHash);
            hash = Crypto.generateDigest('MD5', blobValue);
            String expectedMd5NextDay = EncodingUtil.convertToHex(hash);
            ALMLogUtils.log('DisplayWidgetsController','MD5 Param:'+userKey+',Expected Value:'+expectedMd5);
            ALMLogUtils.log('DisplayWidgetsController','MD5 Param:'+userKey+',Expected Value(+1 day):'+expectedMd5NextDay);
            if(expectedMd5.equalsIgnoreCase(userKey) || expectedMd5NextDay.equalsIgnoreCase(userKey)){
                acctNbr = acctNbr.replace(' ', '');
                Decimal acctNbrInt =-99998777;  //CRF: use constant
                try{
                    acctNbrInt = Decimal.valueOf(acctNbr);
                }catch(Exception ex){ 
                    acctNbrInt = null;
                }
                String mkrtActKey = market.Market_Id__c+acctNbr;
                //Try to find partial match <MRKT_ID><ACCTNBR> e.g. 6200000301
                List<User> matchingUsers;
                matchingUsers = [select     id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                            CDW_STS_CD__c,Profile.Name,FirstName,
                                            LastName,LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,MRKT_ID__c
                                from    User
                                where   MRKT_ID__c=:market.Market_Id__c
                                and     (MRKT_ID_ACCT_NR_KEY__c = :mkrtActKey or FederationIdentifier = :mkrtActKey)
                                ];
                //Try to find partial match <MRKT_ID>%<ACCTNBR> e.g. 62%00000301
                if(matchingUsers.isEmpty()){
                    ALMLogUtils.log('DisplayWidgetsController','Did not find an exact match for '+mkrtActKey+'. Trying a partial match now !!!');
                    mkrtActKey = market.Market_Id__c+'%'+acctNbr;
                    matchingUsers = [select     id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                                CDW_STS_CD__c,Profile.Name,FirstName,
                                                LastName,LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,MRKT_ID__c 
                                    from    User
                                    where   MRKT_ID__c=:market.Market_Id__c
                                    and     (MRKT_ID_ACCT_NR_KEY__c like :mkrtActKey or FederationIdentifier like :mkrtActKey)
                                    ];
                }
                //Attempt to strip off the leading 0s and try again.
                if(matchingUsers.isEmpty()){
                    //Try to find a partial match
                    ALMLogUtils.log('DisplayWidgetsController','Did not find matching users without stripping of leading 0s !!!!');
                    String mkrtActKeyInt = (acctNbrInt!=null?market.Market_Id__c+'%'+acctNbrInt+'%': market.Market_Id__c+'%'+acctNbr+'%');
                    ALMLogUtils.log('DisplayWidgetsController','mkrtActKey='+mkrtActKey);
                    ALMLogUtils.log('DisplayWidgetsController','mkrtActKeyInt='+mkrtActKeyInt);
                    matchingUsers = [       select  id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                                                CDW_STS_CD__c,Profile.Name,FirstName,
                                                                LastName,LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,MRKT_ID__c
                                                        from    User
                                                        where   MRKT_ID__c=:market.Market_Id__c
                                                        and     (MRKT_ID_ACCT_NR_KEY__c like :mkrtActKey or 
                                                                MRKT_ID_ACCT_NR_KEY__c like :mkrtActKeyInt or
                                                                FederationIdentifier like :mkrtActKeyInt)
                                                    ];
                }
                
                //If there are still no matching users, then display Widget Error message
                if(matchingUsers.isEmpty()){
                    if(debugFlag.equalsIgnoreCase('1')){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No matching users found for account#'+acctNbr +' in '+this.market.Name));
                    }
                    stsMsg=System.Label.Widget_error;
                    if(stsMsg==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Widget_error));
                    }
                    this.isFailure= true;
                }else if(matchingUsers.size()>1){
                    if(debugFlag.equalsIgnoreCase('1')){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Multiple users found for account#'+acctNbr +' in '+this.market.Name));
                    }
                    //If there are multiple matching users, then display activation failure message
                    stsMsg=System.Label.Widget_error;
                    if(stsMsg==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Widget_error));
                    }
                    this.isFailure= true;
                }else{
                    this.currUsr= matchingUsers[0];
                    if(this.currUsr.CDW_STS_CD__c=='Active' || this.currUsr.CDW_STS_CD__c=='Consented'){  //CRF: use constant
           //Added code for action items query
        if(!market.Mail_Plan_Enabled__c)
        	this.cmpnNbr = new Decimal[]{market.CMPGN_NR_NUMBER__c};
        else {
        		List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(market.ALM_Rep_Indicator__c, currUsr.ACCT_NR__c, currUsr.MRKT_ID__c);
        		system.debug('>>>> Action item Combined Object List'+lst_CombinedObj);
        		String currCmpgn, nxtCmpgn;
        		//Decide CC campaign and Next Campaign
        		for(Sobject obj :lst_CombinedObj){
        			system.debug('>>>> Action item Combined Cmapign List'+(String)obj.getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
        			//Assumption 1: Mailplan data only exist for current and future campaign
        			String tmpCmp=YOUUtil.getCampaignNumbrMailPlan((String)obj.getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
        			if(tmpCmp==market.CMPGN_NR__c){
        				system.debug('>>>> Action item 1');
        				currCmpgn=tmpCmp;
        			} else if(tmpCmp==market.NEXT_1_CMPGN_NR__c){
        				system.debug('>>>> Action item 2');
        				nxtCmpgn=tmpCmp;
        				currCmpgn=market.CMPGN_NR__c;
        			}else{
        				system.debug('>>>> Action item 3');
        				currCmpgn=currCmpgn!=null?currCmpgn:market.CURRENT_CAMPAIGN_NR__c;
        				nxtCmpgn=nxtCmpgn!=null?nxtCmpgn:market.NEXT_1_CMPGN_NR__c;
        			}
        		}
        		system.debug('>>>> Action item 1 currCmpgn '+currCmpgn);
        		system.debug('>>>> Action item 1 nxtCmpgn '+nxtCmpgn);
	      //  	String mailPlanCampaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lst_CombinedObj[0].getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
	        	List<Decimal> tmpCmpLst= new List<Decimal>();
	        	tmpCmpLst.add(Decimal.valueOf(currCmpgn));
                if(nxtCmpgn!=null)
                    tmpCmpLst.add(Decimal.valueOf(nxtCmpgn));
                else{
                    nxtCmpgn=currCmpgn;
                    tmpCmpLst.add(Decimal.valueOf(nxtCmpgn));
                }
	        		actionItemCampaign = 'Current';
	        		this.cmpnNbr=new Decimal[]{market.CMPGN_NR_NUMBER__c};
	        } 
        
		        System.debug('\n #### MyActionItemsController . initialized this.cmpnNbr --->> '+this.cmpnNbr); 
		        mkt_action_item= [Select	Action_Item__r.Zone_Or_Leader__c, Threshold__c, Filter_Param__c,
														Action_Item__r.Smry_Criteria_Fld__c, Report__r.Report_Id__c,Report__r.Report_Type__c, Report__r.Report_URL__c,
														Action_Item__r.Order_Criteria_Fld__c,Action_Item__r.Rep_Criteria_Fld__c,
														Action_Item__r.Genealogy_Criteria_Fld__c,Action_Item__r.Default__c,
														Priority__c, Market__c, Campaign_Stage__c,
														Action_Item__r.Action_Item_Type__c,Action_Item__r.Category__c,
														Action_Item__r.Subject_Area__c,Action_Item__r.Datatype__c,Campaign__c 
												From 	Market_Action_Items__c
												where	Market__c=:market.Id
												and		Action_Item__r.Zone_Or_Leader__c = 'Leader'
												order by Action_Item__r.Subject_Area__c,Priority__c asc];
                        
                        // End of Action Item Query
                        //For Argentina, only if they are "Consented" should the be allowed to go through
                        this.repMktAcctNbr=this.currUsr.MRKT_ID_ACCT_NR_KEY__c;
                        this.repAcctNbr=this.currUsr.ACCT_NR__c;
                        this.mktId=this.currUsr.MRKT_ID__c;
                        this.userProfile=this.currUsr.Profile.Name;
                        ALMLogUtils.log('DisplayWidgetsController','All Values='+repMktAcctNbr+'>>'+repAcctNbr+'>>'+mktId+'>>'+userProfile+'>> Campaign::'+cmpnNbr);
                        obj_to_query=this.market.ALM_Rep_Indicator__c.replace('__c','__r');
						String comb_obj=MyActionItemsController.aisoqlForcombobj(mkt_action_item,obj_to_query);
						conSoql ='Select Id, Name,('+comb_obj+') From Contact Where MRKT_ACCT_KEY__c=:repMktAcctNbr and MRKT_ID__c=:mktId';
						try{
		                    SObject conobj= Database.query(conSoql);
		                    this.combobjRec=conobj.getSObjects(obj_to_query);
                		}catch(exception ex){
                    		ALMLogUtils.log('DisplayWidgetsController','Message is -> '+ex.getStackTraceString());   
                		}
                       // List<String> stsLead = new List<String>{ALMPLusConstants.LEAD_STS_NEW,ALMPLusConstants.LEAD_STS_INPRGRS};
                        String usrID=this.currUsr.Id;
                      /*  this.leadRecs=Database.query(SOQLUtils.soqlForLead());
                        ALMLogUtils.log('DisplayWidgetController','Lead Record=['+leadRecs.size()+']');*/

                    }else{
                        if(debugFlag.equalsIgnoreCase('1')){  //CRF: use local constant so that we can provide more meaningful name to 1, 2 etc
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'CDW Status is '+currUSr.CDW_STS_CD__c+' for account#'+acctNbr +' in '+this.market.Name));
                        }
                        
                        stsMsg=System.Label.Widget_error;
                        if(stsMsg==null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Widget_error));
                        }
                        this.isFailure= true;
                    }   
                }
            }else{
                if(debugFlag.equalsIgnoreCase('1')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'MD5 key not matching !!!. Key before MD5 encryption:"'+(aslfMktId+acctNbr+System.now().format(DATE_FORMAT))+'[XXXXXXXXXX]" or "'+(aslfMktId+acctNbr+System.now().addDays(1).format(DATE_FORMAT))+'[XXXXXXXXXX]", Received:'+userKey));
                }
                stsMsg=System.Label.Widget_error;
                if(stsMsg==null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Widget_error));
                }
                this.isFailure= true;
            }
        }catch(Exception ex){
            this.isFailure= true;
            if(debugFlag.equalsIgnoreCase('1')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Unknown error occurred .Error Message='+ex.getMessage()));
            }
            ALMLogUtils.log('DisplayWidgetsController','Exception thrown: No Ldr_Smry record found :'+ex.getMessage());
            stsMsg=System.Label.Widget_error;
            if(stsMsg==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.Widget_error));
            }
        }
        ALMLogUtils.log('DisplayWidgetsController','stsMsg='+stsMsg);
        return null;
    }
    
    public PageReference storeUserInfo(){
        ALMLogUtils.log('DisplayWidgetsController','storeUserInfo called !!!!'+Apexpages.currentPage().getParameters().get('rptId')+'>>'+ApexPages.currentPage().getParameters().get('mktcd')+'>>'+ApexPages.currentPage().getParameters().get('acctnbr')+'>>'+Apexpages.currentPage().getParameters().get('key')+'>>'+Apexpages.currentPage().getParameters().get('usrId'));
        this.market = [ select Omniture_Suite_Name__c,ASLF_Market_ID__c,Id
                        from Market__c 
                        where ASLF_Market_ID__c=:ApexPages.currentPage().getParameters().get('mktcd')];
        ALMLogUtils.log('DisplayWidgetController','Testing Omniture Code'+market+'Testing Omniture Code:globalConfig'+this.globalConfig);
        this.currUsr = [    select  id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                    CDW_STS_CD__c,Profile.Name,FirstName,
                                    LastName,LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,MRKT_ID__c
                    from    User
                    where   Id=:Apexpages.currentPage().getParameters().get('usrId')];
        
        //added for Omniture
        if(this.globalConfig==null){
       		 this.globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        }
        User_Login_Param__c ulp;
        String pgIdVal;
        try{
                pgidVal=ApexPages.currentPage().getParameters().get('pgId');
            }catch(exception ex){}  //CRF: what is the need of exception handling here?
        if(pgIdVal!=null){
            ulp = new User_Login_Param__c(User_Id__c=Apexpages.currentPage().getParameters().get('usrId'), 
                                               Page_Id__c=pgidVal, Is_My_Lead__c=true,Is_Widget__c=true);
        }else{
             ulp = new User_Login_Param__c(User_Id__c=Apexpages.currentPage().getParameters().get('usrId'), 
                                              Report_Id__c=Apexpages.currentPage().getParameters().get('rptId'));
        }
        try{
            upsert ulp User_Id__c;
        }catch(Exception ex){
            System.debug('Not able to insert error record !!!!');  //CRF: don't ignore exception
        }
        System.debug('This is last before stmt return !!!!');
        return null;
    }
    
     @isTest(SeeAllData=true)  
    public static void testDisplayWidgets(){  //CRF: Test.startTest() & stopTest() are missing.
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name,ACCT_NR__c 
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=true;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
       // List<My_Business__c> perData=testData.createMyBusinessData(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryDataFrmAct(ldrUsr.ACCT_NR__c,ldrUsr.Id);
        testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
       // perData[0].MRKT_ACCT_KEY__c=testData.testContact.Id;
       // update perData;
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Report_Id__c=rptCfg[0].Report_Id__c);
        insert testUlp;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(LANG_CD,ldrUsr.LanguageLocaleKey);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;    
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        Test.stopTest();
        System.assert(ApexPages.getMessages().isEmpty());

        pageRef = ctlr.init();
        System.assert(ctlr.stsMsg==null);
        PageReference widPageRef = Page.WidgetRedirPage;
        widPageRef.getParameters().put(ACCT_NR,acctNbr);
        widPageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        widPageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        widPageRef.getParameters().put('usrId',ldrUsr.Id);
        widPageRef.getParameters().put('rptId',rptCfg[0].Report_Id__c);
        Test.setCurrentPageReference(widPageRef);
        PageReference resultPage = ctlr.storeUserInfo();  //CRF: assert statement is missing
        }
        
     
    //test DisplayWidget for ALMPlus
   /* @isTest(SeeAllData=true) 
    public static void testDisplayWidgetsALMPLus(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        market.Eligibility_Yes_Flags__c='Opt_In__c';
        market.Title_Exclusion__c='0;-2';
        market.Is_ALMPLUS_Enabled__c=true;
        market.LeadMandatoryFields__c = 'User_Type__c,FirstName,LastName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c, Geo_Level_4__c, MobilePhone,PostalCode';
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=true;
        update ldrUsr;
       // List<My_Business__c> perData=testData.createMyBusinessData(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryDataFrmAct(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
       // perData[0].MRKT_ACCT_KEY__c=testData.testContact.Id;
       // update perData;
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Page_Id__c=ALMPLusConstants.HOTLEAD_PGID_VALUE, Is_My_Lead__c=true,Is_Widget__c=true);
        insert testUlp;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(LANG_CD,ldrUsr.LanguageLocaleKey);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c; 
        //String SHARED_SECRET = 'WbzWP5FGe21';   
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        pageRef.getParameters().put(PGID,ALMPLusConstants.HOTLEAD_PGID_VALUE);
        Test.setCurrentPageReference(pageRef);
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        System.assert(ApexPages.getMessages().isEmpty());

        pageRef = ctlr.init();
        System.assert(ctlr.stsMsg==null);
        PageReference widPageRef = Page.WidgetRedirPage;
        widPageRef.getParameters().put(ACCT_NR,acctNbr);
        widPageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        widPageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        widPageRef.getParameters().put('usrId',ldrUsr.Id);
        widPageRef.getParameters().put('rptId','');
        widPageRef.getParameters().put(PGID,ALMPLusConstants.HOTLEAD_PGID_VALUE);
        Test.setCurrentPageReference(widPageRef);
        PageReference resultPage = ctlr.storeUserInfo();
      } */
    
    @isTest(SeeAllData=true) 
    public static void testDisplayWidgetsRemovedUser(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
       // List<My_Business__c> perData=testData.createMyBusinessData(ldrUsr.ACCT_NR__c,ldrUsr.Id);
      //  List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryDataFrmAct(ldrUsr.ACCT_NR__c,ldrUsr.Id);
      //  perData[0].MRKT_ACCT_KEY__c=testData.testContact.Id;
        //update perData;
        testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Report_Id__c=rptCfg[0].Report_Id__c);
        insert testUlp;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=true;
        ldrUsr.CDW_STS_CD__c='Removed';
        update ldrUsr;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(LANG_CD,ldrUsr.LanguageLocaleKey);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;    
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        Test.stopTest();
        System.assert(ApexPages.getMessages().isEmpty());
        pageRef = ctlr.init();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        ALMLogUtils.log('DisplayWidgetsController.testRemovedUser',''+msgs.size());
        System.assert(ctlr.stsMsg==System.Label.Widget_error);
    }
    
    public static testmethod void testDisplayWidgetsInvalidKey(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
       // List<My_Business__c> perData=testData.createMyBusinessData(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryDataFrmAct(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // perData[0].MRKT_ACCT_KEY__c=testData.testContact.Id;
        //update perData;
        testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Report_Id__c=rptCfg[0].Report_Id__c);
        insert testUlp;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(LANG_CD,ldrUsr.LanguageLocaleKey);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        Test.setCurrentPageReference(pageRef);
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        Test.stopTest();
        ctlr.init();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(ctlr.stsMsg==System.Label.Widget_error);
        
    }
	
	@isTest(SeeAllData=true) 
      public static void testDisplayWidgetsInvalidAcctNbr(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
       // List<My_Business__c> perData=testData.createMyBusinessData(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryDataFrmAct(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // perData[0].MRKT_ACCT_KEY__c=testData.testContact.Id;
       // update perData;
       testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Report_Id__c=rptCfg[0].Report_Id__c);
        insert testUlp;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR,'9'+acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(DEBUG,'1');
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+'9'+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        Test.stopTest();
        ctlr.init();
        System.assert(ctlr.stsMsg==System.Label.Widget_error);
    }
   
   @isTest(SeeAllData=true)  
    public static void testDisplayWidgetsException(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
       // List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryData(ldrUsr.MRKT_ID_ACCT_NR_KEY__c,ldrUsr.Id);
       testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Report_Id__c=rptCfg[0].Report_Id__c);
        insert testUlp;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(ACCT_NR,'9'+acctNbr);
        pageRef.getParameters().put(MRKT_ID,'YY');
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = 'YY'+'9'+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        Test.startTest();
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        Test.stopTest();
        ctlr.init();
        System.assert(ctlr.stsMsg==System.Label.Widget_error);
    } 
    
  //@S-144891 : Commented by Blaine Rothrock on Nov 23
  /*@isTest(SeeAllData=true) 
    public static void testDisplayWidgetsMultipleUserAcctNbr(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        ldrUsr.FederationIdentifier=testData.market.Market_Id__c+'1234567';
        update ldrUsr;
        User ldrUsr1 = testData.createLeaderUser('1234567');
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
       // List<My_Business__c> perData=testData.createMyBusinessData(ldrUsr.ACCT_NR__c,ldrUsr.Id);
       // List<Leader_Downline_Summary__c> ldrData = testData.createLdrSmryDataFrmAct(ldrUsr.ACCT_NR__c,ldrUsr.Id);
        //perData[0].MRKT_ACCT_KEY__c=testData.testContact.Id;
       // update perData;
       testData.createGenealogyData(ldrUsr.ACCT_NR__c,ldrUsr.Id,5);
        List<Report_Config__c> rptCfg = testData.createReportConfig();
        User_Login_Param__c testUlp = new User_Login_Param__c(User_Id__c=ldrUsr.Id, Report_Id__c=rptCfg[0].Report_Id__c);
        insert testUlp;
        PageReference pageRef = Page.DisplayWidgets;
        pageRef.getParameters().put(LANG_CD,'en_US');
        pageRef.getParameters().put(ACCT_NR,ldrUsr1.ACCT_NR__c);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(DEBUG,'1');
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+ldrUsr1.ACCT_NR__c+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        DisplayWidgetsController ctlr = new DisplayWidgetsController();
        ctlr.init();
        System.assert(ctlr.stsMsg==System.Label.Widget_error);
    }*/
}