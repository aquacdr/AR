public class Controller_SLContactBusinessPlan {
    //Plan detail sec vars
    public String shortTermGoals{get;set;}
    public String longTermGoals{get;set;}
    public String personalAcheivementPY{get;set;}
    public String unitAcheivementPY{get;set;}
    public String keyLearnings{get;set;}
    //Business plan table vars
    public String leftHeader{get;set;}
    public String rightHeader{get;set;}
    //Action Plan Recruiting sec vars
    public String recruiting_ActStr1{get;set;}
    public String recruiting_ActStr2{get;set;}
    public String recruiting_ActStr3{get;set;}
    //Action Plan Activity sec vars
    public String activity_ActStr1{get;set;}
    public String activity_ActStr2{get;set;}
    public String activity_ActStr3{get;set;}
    //Action Plan Top seller title advancement sec vars
    public String topSeller_ActStr1{get;set;}
    public String topSeller_ActStr2{get;set;}
    public String topSeller_ActStr3{get;set;}
    public String topSeller_Candidates{get;set;}
    //Action Plan Leadership title acheivement sec vars
    public String leadership_ActStr1{get;set;}
    public String leadership_ActStr2{get;set;}
    public String leadership_ActStr3{get;set;}
    public String leadership_Candidates{get;set;}
    //Personal Dev plan sec vars
    public String perDev_ActStr1{get;set;}
    public String perDev_ActStr2{get;set;}
    public String perDev_ActStr3{get;set;}
    public String perDev_ActStr4{get;set;}
    public String perDev_ActStr5{get;set;}
    public String perDev_ActStr6{get;set;}
    //Rising Star sec vars
    public Boolean isRisingStarSec{get;set;}
    public String rising_ActStr1{get;set;}
    public String rising_ActStr2{get;set;}
    public String rising_ActStr3{get;set;}
    public String rising_Candidates{get;set;}
    //Buttons and links
    public Boolean isCalculateBtn{get;set;}
    public Boolean isSaveBtn{set;get;}
    public Boolean isNewPlanBtn{get;set;}
    //Plan section
    public Boolean isCalculateProcess{get;set;}
    public Boolean isBlankPlan{get;set;}
    public Boolean isInProgPlan{get;set;}
    public List<BPlanWrap> bpsp {get;set;}
    public List<topHeader> headers{get;set;}//in page
    public List<Double> actualCamps{get;set;}
    public List<Double> futureCampns{get;set;}
    public Contact curUsrContact{get; set;}
    public List<Sales_Leader_History__c> actMyBusiness{get;set;}
    //public List<Sales_Leader_History__c> actLdrDwnSumm{get;set;}
    public Map<Double,Sales_Leader_History__c> cmpNoSLH_map{get;set;}
    //public Map<Double,Sales_Leader_History__c> cmpNoLdrDwnSumm_map{get;set;}
    public Map<String,X90DBP_settings__c> kpiCustSett_map{get;set;}
    public List<X90DBP_settings__c> custSett90DBP{get;set;}
    public Integer campaignCount{get;set;}
    public Integer actCampCount{get;set;}
    public Integer futCampCount{get;set;}
    public User currUser{get;set;}
    //public My_Business__c currMyBusiness{get;set;}
    public Sales_Leader_History__c currSalesLdrHist{get; set;}
    public SObject currALMRepPerf {get; set;}
    public Market__c currMarket{get;set;}
    public String BP_SOQL{get;set;}
    public Business_Plan__c BusinessPlan{get;set;}
    public String BPId{get;set;}
    public String OriginalBPId{get;set;}
    Map<String,String> BP_asMap{get;set;}
    Map<String,String> BP_Original{get;set;}
    public String lastUpdate{get;set;}
    public String currUserAccNo{get;set;}
    public Boolean isPageRO{get;set;}
    public String tableHeader{get;set;}
    public Boolean isBusinessplan{get;set;}
    public String followup30{get;set;}
    public String followup60{get;set;}
    public String followup90{get;set;}
    public Boolean isBPAvailable{get;set;}
    public ALM_Global_Settings__c globalConfig {get; set;}
    public String repDetailAcctNbr {get; set;}
    public String coachParam{get;set;}
    public String ALMRepPerfObj {get; set;}
    public Integer curUsrLeftNode {get; set;}
    public Integer curUsrRightNode {get; set;}
    public String curUsrRtUplnAcc {get; set;}
    public String curCampaign {get; set;}
    public Integer curUsrGenLvl {get; set;}
    public DateTime followupDate30{get;set;}
    public DateTime followupDate60{get;set;}
    public DateTime followupDate90{get;set;}
    public String s_userLocale{get;set;}
    public String dateFormat_BP_UI{get;set;}
    
   
    public Controller_SLContactBusinessPlan(ApexPages.StandardController controller){
	    this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
	    initialize();
    }
    public Controller_SLContactBusinessPlan(){
    	this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
	    initialize();
    }
    private void initialize(){
    	isBPAvailable = true;
        isBusinessplan = true;
        currUserAccNo = ApexPages.currentPage().getParameters().get('AccKey');
        String s_Impersonate = ApexPages.currentPage().getParameters().get('impersonate');
        String s_PageId = ApexPages.currentPage().getParameters().get('pgId');
        String strImpersonateAcct = ApexPages.currentPage().getParameters().get('acctkey');
        String strImpersonateAcc = ApexPages.currentPage().getParameters().get('AccKey');
        if(strImpersonateAcct != null && strImpersonateAcct != '') {
            currUserAccNo = strImpersonateAcct;     
        }
        else if(strImpersonateAcc != null && strImpersonateAcc != '') {
            currUserAccNo = strImpersonateAcc;      
        }
       
            User mainUser = [Select u.ProfileId, u.Username, u.Profile.Name, u.Name, u.MRKT_ID__c, u.LastName, u.LanguageLocaleKey,u.LocaleSidKey, u.Id, u.FirstName, 
                    u.ACCT_NR__c, u.MRKT_ID_ACCT_NR_KEY__c, u.LDRSHP_TITL_LVL_NBR__c, u.DFALT_ZONE_CD__c, u.DFALT_DIV_NM__c 
                     From User u where Id=: Userinfo.getUserId()];
            currUserAccNo = mainUser.MRKT_ID__c + currUserAccNo;
            //if(s_Impersonate != null && s_Impersonate.trim()!=''){
            if((s_Impersonate != null && s_Impersonate.trim()!='') || (strImpersonateAcct != null && strImpersonateAcct != '') || (strImpersonateAcc != null && strImpersonateAcc != '')){
                currUser =[Select u.ProfileId, u.Username, u.Profile.Name, u.Name, u.MRKT_ID__c, u.LastName, u.LanguageLocaleKey, u.Id, u.FirstName, 
                    u.ACCT_NR__c, u.MRKT_ID_ACCT_NR_KEY__c, u.LDRSHP_TITL_LVL_NBR__c, u.DFALT_ZONE_CD__c, u.DFALT_DIV_NM__c 
                     From User u where MRKT_ID_ACCT_NR_KEY__c =: currUserAccNo];
            }else{
                this.currUser = mainUser;
            }
            System.debug('Userinfo.getUserName()--'+Userinfo.getUserName()+'--curreUsrname--'+currUser.Username);
            // Added by Rajib on 02/09/2013
            //s_userLocale = mainUser.LanguageLocaleKey;
            s_userLocale = mainUser.LocaleSidKey;
            System.debug('mainUser.LanguageLocaleKey:'+mainUser.LocaleSidKey);
            
            dateFormat_BP_UI = YOUUtil.getDateFormat(s_userLocale);
            dateFormat_BP_UI = dateFormat_BP_UI.toLowerCase();
            if(dateFormat_BP_UI.contains('yyyy')){
            	dateFormat_BP_UI = dateFormat_BP_UI.replace('yyyy','yy');
            }
            System.debug('s_userLocale -- >'+s_userLocale);
            //System.debug('dateFormat_BP during page load : '+dateFormat_BP);
            System.debug('dateFormat_BP_UI during page load : '+dateFormat_BP_UI);
             // Ended by Rajib on 02/09/2013
            if(currUser.LDRSHP_TITL_LVL_NBR__c != ''){
                Set<String> allExTitles = MarketLeaderTitleUtils.findELeaders(currUser.MRKT_ID__c);
                if(allExTitles.contains(currUser.LDRSHP_TITL_LVL_NBR__c)){
                    isRisingStarSec = true;
                }else{
                    isRisingStarSec = false;
                }
            }
            System.debug('testing '+currUser.MRKT_ID__c);
            currMarket = [Select m.X90_Day_Camp_CNT__c, m.Name, m.Market_Id__c, m.Id, m.CURRENT_CAMPAIGN_NR__c, m.CMPGN_STRT_DT__c, 
                            m.CMPGN_NR__c, m.CMPGN_END_DT__c, m.PREV_1_CMPGN_NR__c, m.Business_Plan_KPIs__c, m.Omniture_RSID__c, m.Omniture_Suite_Name__c, m.ALM_Rep_Indicator__c //field added swarnava
                            From Market__c m where Market_Id__c =:currUser.MRKT_ID__c];
            //String currMyBusinessKey =  currMarket.Market_Id__c + currMarket.CMPGN_NR__c + currUser.ACCT_NR__c;
            String currMyBusinessKey =  currMarket.Market_Id__c + currUser.ACCT_NR__c;
            System.debug('currMyBusinessKey--->'+currMyBusinessKey); 
            curUsrContact = [SELECT Id
                             FROM Contact
                             WHERE MRKT_ACCT_KEY__c =: currMyBusinessKey];   
            
            ALMRepPerfObj = currMarket.ALM_Rep_Indicator__c;
            curCampaign = currMarket.CMPGN_NR__c;
            //String ALMRepPerfQuery = 'SELECT Id, LDRSHP_LOA_NR__c, LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c, ROOT_UPLN_ACCT_NR__c FROM '+ALMRepPerfObj+' WHERE MRKT_ACCT_KEY__c = \''+curUsrContact.Id+'\' AND OPERTNL_CMPGN_NR__c = \''+curCampaign+'\'';
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            String ALMRepPerfQuery = 'SELECT Id, LDRSHP_LOA_NR__c, LDRSHP_TITL_LVL_NR__c, LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c, ROOT_UPLN_ACCT_NR__c FROM '+ALMRepPerfObj+' WHERE MRKT_ACCT_KEY__c = \''+curUsrContact.Id+'\' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(curCampaign) ;
            System.debug('ALMRepPerfQuery --> '+ALMRepPerfQuery);
            
            currALMRepPerf = database.query(ALMRepPerfQuery);
            curUsrLeftNode = Integer.valueOf(currALMRepPerf.get('LFT_ND_ID__c'));
            curUsrRightNode = Integer.valueOf(currALMRepPerf.get('RGT_ND_ID__c'));
            curUsrRtUplnAcc = String.valueOf(currALMRepPerf.get('ROOT_UPLN_ACCT_NR__c'));
            curUsrGenLvl = Integer.valueOf(currALMRepPerf.get('Genealogy_Level__c'));
                                          
            List<Business_Plan__c> junkBP = [Select Id, IsDeleted__c, Name, Is_BP_Saved__c 
                                         from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                         and Market_Id__c =:currUser.MRKT_ID__c and (IsDeleted__c =true or Is_BP_Saved__c =false)];
            if(junkBP.size()>0){
                //delete junkBP;
            }                                        
            List<Business_Plan__c> BP = [Select Id, IsDeleted__c, Name, Is_BP_Saved__c 
                                         from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                         and Market_Id__c =:currUser.MRKT_ID__c and IsDeleted__c !=true and Is_BP_Saved__c !=false order by Name desc];
            
            System.debug('BP SIZE -->>  '+BP.size());
            isPageRO = false;
            isCalculateProcess = false;
            BP_asMap = new Map<String,String>();
            BP_Original = new Map<String,String>();
            //get the 90DBP custom settings for KPI to field mapping
            custSett90DBP = [Select Name, Id, KPI_Name__c, Object_Name__c, PC_Field_Name__c, isHeader__c, CC_Field_Name__c, Input_Count__c,
                                                        CC_1_Field_Name__c, CC_2_Field_Name__c, CC_3_Field_Name__c, CC_4_Field_Name__c, CC_5_Field_Name__c,
                                                        CC_6_Field_name__c, Variance_Field_Name__c, isFuture__c, isCurrency__c from X90DBP_settings__c];
            System.debug('custSett90DBP--'+custSett90DBP);
            //create a map with KPI name as key and Custom setting as value
            kpiCustSett_map = new Map<String,X90DBP_settings__c>();
            if(custSett90DBP.size()>0){
                for(X90DBP_settings__c cst: custSett90DBP){
                    kpiCustSett_map.put(cst.KPI_Name__c,cst);
                }
            }
            if(BP.size()>0){
                navigateMtd(BP[0],true);
                OriginalBPId = BP[0].Id;
                BP_Original = RecordBuilder.buildRecord(BP[0].Id);
            }else{
                Business_Plan__c blankBP = new Business_Plan__c();
                navigateMtd(blankBP,false);
            }
                             
        
    }
    //onload method
    public PageReference BPAction(){
        isBPAvailable = true;
        isBusinessplan = true;
        currUserAccNo = ApexPages.currentPage().getParameters().get('AccKey');
        String s_Impersonate = ApexPages.currentPage().getParameters().get('impersonate');
        String s_PageId = ApexPages.currentPage().getParameters().get('pgId');
        String strImpersonateAcct = ApexPages.currentPage().getParameters().get('acctkey');
        String strImpersonateAcc = ApexPages.currentPage().getParameters().get('AccKey');
        if(strImpersonateAcct != null && strImpersonateAcct != '') {
            currUserAccNo = strImpersonateAcct;     
        }
        else if(strImpersonateAcc != null && strImpersonateAcc != '') {
            currUserAccNo = strImpersonateAcc;      
        }
        try{
            User mainUser = [Select u.ProfileId, u.Username, u.Profile.Name, u.Name, u.MRKT_ID__c, u.LastName, u.LanguageLocaleKey,u.LocaleSidKey, u.Id, u.FirstName, 
                    u.ACCT_NR__c, u.MRKT_ID_ACCT_NR_KEY__c, u.LDRSHP_TITL_LVL_NBR__c, u.DFALT_ZONE_CD__c, u.DFALT_DIV_NM__c 
                     From User u where Id=: Userinfo.getUserId()];
            currUserAccNo = mainUser.MRKT_ID__c + currUserAccNo;
            //if(s_Impersonate != null && s_Impersonate.trim()!=''){
            if((s_Impersonate != null && s_Impersonate.trim()!='') || (strImpersonateAcct != null && strImpersonateAcct != '') || (strImpersonateAcc != null && strImpersonateAcc != '')){
                currUser =[Select u.ProfileId, u.Username, u.Profile.Name, u.Name, u.MRKT_ID__c, u.LastName, u.LanguageLocaleKey, u.Id, u.FirstName, 
                    u.ACCT_NR__c, u.MRKT_ID_ACCT_NR_KEY__c, u.LDRSHP_TITL_LVL_NBR__c, u.DFALT_ZONE_CD__c, u.DFALT_DIV_NM__c 
                     From User u where MRKT_ID_ACCT_NR_KEY__c =: currUserAccNo];
            }else{
                this.currUser = mainUser;
            }
            System.debug('Userinfo.getUserName()--'+Userinfo.getUserName()+'--curreUsrname--'+currUser.Username);
            // Added by Rajib on 02/09/2013
            //s_userLocale = mainUser.LanguageLocaleKey;
            s_userLocale = mainUser.LocaleSidKey;
            System.debug('mainUser.LanguageLocaleKey:'+mainUser.LocaleSidKey);
            
            dateFormat_BP_UI = YOUUtil.getDateFormat(s_userLocale);
            dateFormat_BP_UI = dateFormat_BP_UI.toLowerCase();
            if(dateFormat_BP_UI.contains('yyyy')){
            	dateFormat_BP_UI = dateFormat_BP_UI.replace('yyyy','yy');
            }
            System.debug('s_userLocale -- >'+s_userLocale);
            //System.debug('dateFormat_BP during page load : '+dateFormat_BP);
            System.debug('dateFormat_BP_UI during page load : '+dateFormat_BP_UI);
             // Ended by Rajib on 02/09/2013
            if(currUser.LDRSHP_TITL_LVL_NBR__c != ''){
                Set<String> allExTitles = MarketLeaderTitleUtils.findELeaders(currUser.MRKT_ID__c);
                if(allExTitles.contains(currUser.LDRSHP_TITL_LVL_NBR__c)){
                    isRisingStarSec = true;
                }else{
                    isRisingStarSec = false;
                }
            }
            System.debug('testing '+currUser.MRKT_ID__c);
            currMarket = [Select m.X90_Day_Camp_CNT__c, m.Name, m.Market_Id__c, m.Id, m.CURRENT_CAMPAIGN_NR__c, m.CMPGN_STRT_DT__c, 
                            m.CMPGN_NR__c, m.CMPGN_END_DT__c, m.PREV_1_CMPGN_NR__c, m.Business_Plan_KPIs__c, m.Omniture_RSID__c, m.Omniture_Suite_Name__c, m.ALM_Rep_Indicator__c //field added swarnava
                            From Market__c m where Market_Id__c =:currUser.MRKT_ID__c];
            //String currMyBusinessKey =  currMarket.Market_Id__c + currMarket.CMPGN_NR__c + currUser.ACCT_NR__c;
            String currMyBusinessKey =  currMarket.Market_Id__c + currUser.ACCT_NR__c;
            System.debug('currMyBusinessKey--->'+currMyBusinessKey); 
            curUsrContact = [SELECT Id
                             FROM Contact
                             WHERE MRKT_ACCT_KEY__c =: currMyBusinessKey];   
            
            ALMRepPerfObj = currMarket.ALM_Rep_Indicator__c;
            curCampaign = currMarket.CMPGN_NR__c;
            //String ALMRepPerfQuery = 'SELECT Id, LDRSHP_LOA_NR__c, LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c, ROOT_UPLN_ACCT_NR__c FROM '+ALMRepPerfObj+' WHERE MRKT_ACCT_KEY__c = \''+curUsrContact.Id+'\' AND OPERTNL_CMPGN_NR__c = \''+curCampaign+'\'';
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            String ALMRepPerfQuery = 'SELECT Id, LDRSHP_LOA_NR__c, LDRSHP_TITL_LVL_NR__c, LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c, ROOT_UPLN_ACCT_NR__c FROM '+ALMRepPerfObj+' WHERE MRKT_ACCT_KEY__c = \''+curUsrContact.Id+'\' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(curCampaign) ;
            System.debug('ALMRepPerfQuery --> '+ALMRepPerfQuery);
            
            currALMRepPerf = database.query(ALMRepPerfQuery);
            curUsrLeftNode = Integer.valueOf(currALMRepPerf.get('LFT_ND_ID__c'));
            curUsrRightNode = Integer.valueOf(currALMRepPerf.get('RGT_ND_ID__c'));
            curUsrRtUplnAcc = String.valueOf(currALMRepPerf.get('ROOT_UPLN_ACCT_NR__c'));
            curUsrGenLvl = Integer.valueOf(currALMRepPerf.get('Genealogy_Level__c'));
                                          
            List<Business_Plan__c> junkBP = [Select Id, IsDeleted__c, Name, Is_BP_Saved__c 
                                         from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                         and Market_Id__c =:currUser.MRKT_ID__c and (IsDeleted__c =true or Is_BP_Saved__c =false)];
            if(junkBP.size()>0){
                delete junkBP;
            }                                        
            List<Business_Plan__c> BP = [Select Id, IsDeleted__c, Name, Is_BP_Saved__c 
                                         from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                         and Market_Id__c =:currUser.MRKT_ID__c and IsDeleted__c !=true and Is_BP_Saved__c !=false order by Name desc];
            
            System.debug('BP SIZE -->>  '+BP.size());
            isPageRO = false;
            isCalculateProcess = false;
            BP_asMap = new Map<String,String>();
            BP_Original = new Map<String,String>();
            //get the 90DBP custom settings for KPI to field mapping
            custSett90DBP = [Select Name, Id, KPI_Name__c, Object_Name__c, PC_Field_Name__c, isHeader__c, CC_Field_Name__c, Input_Count__c,
                                                        CC_1_Field_Name__c, CC_2_Field_Name__c, CC_3_Field_Name__c, CC_4_Field_Name__c, CC_5_Field_Name__c,
                                                        CC_6_Field_name__c, Variance_Field_Name__c, isFuture__c, isCurrency__c from X90DBP_settings__c];
            System.debug('custSett90DBP--'+custSett90DBP);
            //create a map with KPI name as key and Custom setting as value
            kpiCustSett_map = new Map<String,X90DBP_settings__c>();
            if(custSett90DBP.size()>0){
                for(X90DBP_settings__c cst: custSett90DBP){
                    kpiCustSett_map.put(cst.KPI_Name__c,cst);
                }
            }
            if(BP.size()>0){
                navigateMtd(BP[0],true);
                OriginalBPId = BP[0].Id;
                BP_Original = RecordBuilder.buildRecord(BP[0].Id);
            }else{
                Business_Plan__c blankBP = new Business_Plan__c();
                navigateMtd(blankBP,false);
            }
                             
        }catch(exception e){
            System.debug('page load error--'+e);
            PageReference result = Page.ErrorPage;
            String errorId = ErrorHandler.handleError('Business Plan page cannot be displayed');
            result.getParameters().put('errId',errorId);
            return result;
        }
        return null;
    }
    private void navigateMtd(Business_Plan__c currBP, Boolean isBPavail){
        System.debug('\n ####### navigateMtd isBPavail --  '+isBPavail+' and currBP -- \n'+currBP);
        String currURL = String.valueOf(ApexPages.currentPage().getUrl()).toLowerCase();
        System.debug('currURL--'+currURL+'---'+ApexPages.currentPage().getUrl());
        System.debug('coachParam--'+coachParam);
        if(coachParam != null){
            //Business plan from Coaching page
            System.debug('inside coaching plan');
            if(isBPavail){
                System.debug('BP present');
                    //show inProgress plan
                    tableHeader = System.Label.Business_Plan;
                    BPId = currBP.Id;
                    isPageRO = true;
                    isBusinessplan = true;
                    BP_asMap =  RecordBuilder.buildRecord(currBP.Id);
                    intialValues();
                    inProgressPlan();
            }else{
                isBusinessplan = false;
            }
        }else if(currURL.contains('businessplan') || currURL.contains('slcoachingrecordhome')){
                System.debug('inside business plan page');
                tableHeader = System.Label.Create_My_Business_Plan;
                isBusinessplan = true;
                actCampCount = 0;
                futCampCount = 0;
                //Business plan from Business plan page
                if(isBPavail){
                    isPageRO = false;
                    isCalculateBtn = true;
                    isSaveBtn = true;
                    BPId = currBP.Id;
                    BP_asMap =  RecordBuilder.buildRecord(currBP.Id);
                    System.debug('currALMRepPerf.LDRSHP_LOA_NR__c--'+currALMRepPerf.get('LDRSHP_LOA_NR__c'));
                    System.debug('currUser.LDRSHP_TITL_LVL_NBR__c--'+currUser.LDRSHP_TITL_LVL_NBR__c);
                    if(Double.valueOf(currALMRepPerf.get('LDRSHP_LOA_NR__c')) >0 && Integer.valueOf(currALMRepPerf.get('LDRSHP_TITL_LVL_NR__c'))>0){
                        isBPAvailable = true;
                        intialValues();
                        inProgressPlan();
                    }else{
                            isBPAvailable = false;
                    }
                }else{
                    if(Double.valueOf(currALMRepPerf.get('LDRSHP_LOA_NR__c')) >0 && Integer.valueOf(currUser.LDRSHP_TITL_LVL_NBR__c)>0){
                        isBPAvailable = true;
                        blankPlan();
                        intialValues();
                    }else{
                            isBPAvailable = false;
                    }
                    
                }
        }
        
    }
    //Blank plan value
    private void blankPlan(){
        System.debug('inside blank plan');
        //create new Business plan 
        isCalculateBtn = true;
        isSaveBtn = true;
        isBlankPlan = true;
        isInProgPlan = false;
        isPageRO=false;
        actualCamps = new List<Double>();
        futureCampns = new List<Double>();
        Double currCamp = Double.valueOf(currMarket.CMPGN_NR__c.substring(0,currMarket.CMPGN_NR__c.length()-2));
        System.debug('currCamp--'+currCamp);
        List<Double> campYears = new List<Double>{currCamp,currCamp+1};
        System.debug('campYears--'+campYears);
        //get current and future campaigns
        List<Calendar__c> FwdCalendar = [Select c.YEAR_NR__c, c.SystemModstamp, c.Name, c.Market__c, c.MRKT_ID__c, c.IsDeleted, c.Id, c.CURRNT_IND__c, 
                                            c.CMPGN_STRT_DT__c, c.CMPGN_NR__c, c.CMPGN_END_DT__c 
                                            From Calendar__c c where YEAR_NR__c IN:campYears and Market__r.Market_Id__c =: currUser.MRKT_ID__c 
                                            and CMPGN_NR__c>=:Double.valueOf(currMarket.CMPGN_NR__c) order by CMPGN_NR__c asc];
        System.debug('FwdCalendar--'+FwdCalendar);
        if(FwdCalendar.size()>0){
            Integer fwdcount=1;
            for(Calendar__c cldr: FwdCalendar){
                if(fwdcount<=(Integer.valueOf(currMarket.X90_Day_Camp_CNT__c))){
                    futureCampns.add(cldr.CMPGN_NR__c);
                }else{
                    break;
                }
                fwdcount++;
            }
        }
        System.debug('futureCampns--'+futureCampns);
        //get Historical campaigns
        campYears.clear();
        campYears.add(currCamp-1);
        campYears.add(currCamp);
        
        System.debug('campYears -- '+campYears);
        System.debug('Double.valueOf(currMarket.CMPGN_NR__c) -- '+Double.valueOf(currMarket.CMPGN_NR__c));
        
        
        List<Calendar__c> HistCalendar = [Select c.YEAR_NR__c, c.SystemModstamp, c.Name, c.Market__c, c.MRKT_ID__c, c.IsDeleted, c.Id, c.CURRNT_IND__c, 
                                            c.CMPGN_STRT_DT__c, c.CMPGN_NR__c, c.CMPGN_END_DT__c 
                                            From Calendar__c c where YEAR_NR__c IN:campYears and Market__r.Market_Id__c =: currUser.MRKT_ID__c 
                                            and CMPGN_NR__c<:Double.valueOf(currMarket.CMPGN_NR__c) order by CMPGN_NR__c desc];
        System.debug('HistCalendar--'+HistCalendar);
        if(HistCalendar.size()>0){
            Integer hiscount = 1;
            for(Calendar__c cldr: HistCalendar){
                if(hiscount<=Integer.valueOf(currMarket.X90_Day_Camp_CNT__c)){
                    actualCamps.add(cldr.CMPGN_NR__c);
                }else{
                    break;
                }
                hiscount++;
            }
        }
        headers = new List<topHeader>();//This will hold the headers
        if(actualCamps.size()>0){
            actualCamps.sort();
            for(Double ac: actualCamps){
                topHeader tempHeader = new topHeader();
                System.debug('Campaign names--'+ac);
                tempHeader.isPrevCamp = true;
                tempHeader.campaignName = System.Label.Campaign_Ind + String.valueOf(ac).substring(4,6);
                tempHeader.campaignYear = String.valueOf(ac).substring(0,4);
                System.debug('tempHeader--'+tempHeader);
                headers.add(tempHeader);
            }
        }
        if(futureCampns.size()>0){
            futureCampns.sort();
            for(Double fc: futureCampns){
                topHeader tempHeader = new topHeader();
                System.debug('Fc Campaign names--'+fc);
                tempHeader.campaignName = System.Label.Campaign_Ind +String.valueOf(fc).substring(4,6);
                tempHeader.campaignYear = String.valueOf(fc).substring(0,4);
                System.debug('tempHeader--'+tempHeader);
                headers.add(tempHeader);
            }
        }
        System.debug('actualCamps--'+actualCamps);
        actCampCount = actualCamps.size();
        futCampCount = futureCampns.size();
        campaignCount = futureCampns.size();
        actualValues();
        if(((cmpNoSLH_map.size() == currMarket.X90_Day_Camp_CNT__c && cmpNoSLH_map.size() == currMarket.X90_Day_Camp_CNT__c) || 
            Double.valueOf(currALMRepPerf.get('LDRSHP_LOA_NR__c')) >0) && Integer.valueOf(currUser.LDRSHP_TITL_LVL_NBR__c) >0){
            isBPAvailable = true;
            if(!isCalculateProcess && actualCamps.size()>0 && futureCampns.size()>0){
                System.debug('New BP creation');
                createBPlan();
                populateWrapObj();          
            }
        }else{
            isBPAvailable = false;
        }
        
    }
    //Create Business Plan record
    private void createBPlan(){
        
        //under construction
        System.debug('inside create BP');
        List<Business_Plan_Parameter__c> AllBpPars = [Select b.Name, b.Market_Id__c, b.Id, b.AVG_ACTVTY_PCT__c From Business_Plan_Parameter__c b 
                                                      where Market_Id__c =:currMarket.Id order by CreatedDate desc limit 1];
        Business_Plan__c newBP = new Business_Plan__c();
        newBP.Market_Id__c = currMarket.Market_Id__c;
        //newBP.User__c = currUser.Id;
        String campaign_nos = '';
        for(Integer i=0;i<futureCampns.size();i++){
            campaign_nos = campaign_nos+String.valueOf(Integer.valueOf(futureCampns[i]))+';';
            if((i+1)<=6 && (i+1)<futureCampns.size()){
                String fldName = 'NEXT_'+(i+1)+'_CMPGN_NR__c';
                System.debug('fldName--'+fldName);
                newBP.put(fldName,String.valueOf(Integer.valueOf(futureCampns[i+1])));
            }
        }
        campaign_nos = campaign_nos.substring(0,campaign_nos.length()-1);
        newBP.Campaign_Numbers__c =campaign_nos;
        newBP.Current_campaign__c = currMarket.CMPGN_NR__c;
        newBP.CMPGN_NR__c = currMarket.CMPGN_NR__c;
        newBP.PREV_1_CMPGN_NR__c = String.valueOf(Integer.valueOf(actualCamps[actualCamps.size()-1]));
        newBP.Acct_Nr__c = currUser.ACCT_NR__c;
        newBP.Mrkt_Id_Acct_Nr_Key__c = currUser.MRKT_ID_ACCT_NR_KEY__c;
        newBP.Last_Updated__c = System.now();
        newBP.FLWUP_MTG_30__c = null;
        newBP.FLWUP_MTG_60__c = null;
        newBP.FLWUP_MTG_90__c = null;
        if(AllBpPars.size()>0){
            newBP.Business_Plan_Parameter__c= AllBpPars[0].Id;
            System.debug('BPPar--'+AllBpPars[0].Name);
            if(cmpNoSLH_map.get(actualCamps.get(actualCamps.size()-1)) != null){
                Sales_Leader_History__c tempSLH = cmpNoSLH_map.get(actualCamps.get(actualCamps.size()-1));
                newBP.AVG_GENRTN_1_QPA_CNT__c = tempSLH.AVG_GENRTN_1_QPA_CNT__c;
                newBP.AVG_GENRTN_1_RMVL_PCT__c = tempSLH.AVG_GENRTN_1_RMVL_PCT__c;
                if(tempSLH.AVG_GENRTN_1_ACT_PCT__c>0){
                    newBP.AVG_GENRTN_1_ACT_PCT__c = tempSLH.AVG_GENRTN_1_ACT_PCT__c;
                }else if(AllBpPars[0].AVG_ACTVTY_PCT__c>0){
                    newBP.AVG_GENRTN_1_ACT_PCT__c = AllBpPars[0].AVG_ACTVTY_PCT__c;
                }
                newBP.PREV_PRSNL_SLS_AMT__c = tempSLH.PRSNL_SLS_AMT__c;
                newBP.AVG_ORD_SIZE_AMT__c = tempSLH.AVG_ORD_SIZE_AMT__c;
                newBP.PREV_AVG_DISCNT_PCT__c = tempSLH.AVG_DISCNT_PCT__c;
                newBP.PREV_AVG_GENRTN_1_DISTR_SLS_PCT__c = tempSLH.AVG_GENRTN_1_DISTR_SLS_PCT__c;
                newBP.PREV_AVG_GENRTN_1_UNIT_COMM_PCT__c = tempSLH.AVG_GENRTN_1_UNIT_COMM_PCT__c;
                newBP.PREV_AVG_GENRTN_2_DISTR_SLS_PCT__c = tempSLH.AVG_GENRTN_2_DISTR_SLS_PCT__c;
                newBP.PREV_AVG_GENRTN_2_UNIT_COMM_PCT__c = tempSLH.AVG_GENRTN_2_UNIT_COMM_PCT__c;
                newBP.PREV_AVG_GENRTN_3_DISTR_SLS_PCT__c = tempSLH.AVG_GENRTN_3_DISTR_SLS_PCT__c;
                newBP.PREV_AVG_GENRTN_3_UNIT_COMM_PCT__c = tempSLH.AVG_GENRTN_3_UNIT_COMM_PCT__c;
                newBP.PREV_EXEC_ERNGS_AMT__c = tempSLH.EXEC_ERNGS_AMT__c;
                newBP.PREV_GENRTN_1_STF_CNT__c = tempSLH.GENRTN_1_STF_CNT__c;
                newBP.PREV_GRP_UNIT_SLS_AMT__c = tempSLH.GRP_UNIT_SLS_AMT__c;
                newBP.PREV_GENTRTN_1_ACTV_REP_CNT__c = tempSLH.GENTRTN_1_ACTV_REP_CNT__c;
                newBP.PREV_GENRTN_1_TITL_STF_CNT__c = tempSLH.GENRTN_1_TITL_STF_CNT__c;
            }
        }
        try{
            insert newBP;
            BPId = newBP.Id;
            BP_asMap = RecordBuilder.buildRecord(newBP.Id);
            System.debug('BP_asMap--'+BP_asMap);
            
        }catch(exception e){
            System.debug('error--'+e);
        }
        
    }
    //Inprogress plan
    private void inProgressPlan(){
        //under construction
        System.debug('inside inprogress plan');
        isBlankPlan = false;
        isInProgPlan = true;
        System.debug('current market--'+currMarket);
        List<String> BPCampns = new List<String>();//this list holds all the campaigns numbers when the BP was created
        actualCamps = new List<Double>();//this list holds campaign numbers of all closed campaigns mentioned in BP
        futureCampns = new List<Double>();//this list holds campaign numbers of all campaigns yet to be closed
        headers = new List<topHeader>();//This will hold the headers
        topHeader head1 = new topHeader();
        head1.isPrevCamp = true;
        head1.campaignName = System.Label.Variance;
        head1.campaignYear = System.Label.To +' '+System.Label.Date;
        headers.add(head1);
        BPCampns = BP_asMap.get('Campaign_Numbers__c').split(';');//get all campaigns from the business plan
        System.debug('BPCampns-->'+BPCampns);
        for(String bp: BPCampns){
            topHeader tempHeader = new topHeader();
            if(Integer.valueOf(bp)<Integer.valueOf(currMarket.CMPGN_NR__c)){//fix this line to get curr camp no from market
                actualCamps.add(double.valueOf(bp));
                tempHeader.isPrevCamp = true;
            }else{
                futureCampns.add(double.valueOf(bp));
            }
            System.debug('Campaign names--'+bp);
            tempHeader.campaignName = System.Label.Campaign_Ind +bp.substring(4,6);
            tempHeader.campaignYear = bp.substring(0,4);
            System.debug('tempHeader--'+tempHeader);
            headers.add(tempHeader);
        }
        system.debug('actualCamps--'+actualCamps+'---futureCampns--'+futureCampns);
        if(futureCampns.size()<=0){
            isCalculateBtn = false;
            isSaveBtn = false;
            isPageRO = true;
            //isPageRO=false;
        }
        actCampCount = actualCamps.size();
        futCampCount = futureCampns.size();
        campaignCount = futureCampns.size();
        System.debug('camp counts--'+actCampCount+'----'+actualCamps.size());
        System.debug('camp counts--'+futCampCount+'----'+futureCampns.size());
        if(actualCamps.size()>0){
            actualValues();
            updateCurrBP();
        }
        populateWrapObj();
    }
    //Update Current Business Plan for closed campaigns
    private void updateCurrBP(){
        //under construction
        List<String> KPIs = new List<String>();
        KPIs = currMarket.Business_Plan_KPIs__c.split(';');
        System.debug('KPIs--'+KPIs);
        Business_Plan__c inProgBP_update = new Business_Plan__c(id=BPId);
        for(String kp: KPIs){
            System.debug('curr KPI--'+kp);
            if(kpiCustSett_map.get(kp) != null){
                System.debug('kpiCustSett_map.get(kp)--'+kpiCustSett_map.get(kp));
                Double tempval = 0.0;
                //if(kpiCustSett_map.get(kp).Object_Name__c == 'My_Business__c'){
                    for(Integer ac=0;ac<actualCamps.size();ac++){
                        System.debug('actualCamps[ac]--'+actualCamps[ac]);
                        if(cmpNoSLH_map.get(actualCamps[ac]) != null){
                            System.debug('tempval bfr--'+tempval);
                            if(cmpNoSLH_map.get(actualCamps[ac]).get(kpiCustSett_map.get(kp).PC_Field_Name__c) != null && cmpNoSLH_map.get(actualCamps[ac]).get(kpiCustSett_map.get(kp).PC_Field_Name__c) !=''){
                                tempval = tempval + Double.valueOf(cmpNoSLH_map.get(actualCamps[ac]).get(kpiCustSett_map.get(kp).PC_Field_Name__c));
                            }
                            System.debug('tempval aftr--'+tempval);
                        }
                        String BpFieldName = ''; 
                        if(ac == 0){
                            BpFieldName = 'CC_Field_Name__c';
                        }else if(ac>0){
                            BpFieldName = 'CC_'+String.valueOf(ac)+'_Field_Name__c';
                        }
                        System.debug('BP_asMap--'+BP_asMap.get('PRSNL_SLS_AMT__c'));
                        System.debug('BP_asMap.get(BpFieldName)--'+String.valueOf(kpiCustSett_map.get(kp).get(BpFieldName)));
                        if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).get(BpFieldName))) != null && BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).get(BpFieldName))) !=''){
                            tempval = tempval - Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).get(BpFieldName)))); 
                        }
                    }
                inProgBP_update.put(kpiCustSett_map.get(kp).Variance_Field_Name__c,tempval);
            }
        }
        try{
            System.debug('inside variance update');
            update inProgBP_update;
            BP_asMap = RecordBuilder.buildRecord(inProgBP_update.Id);
            //BP_Original = RecordBuilder.buildRecord(inProgBP_update.Id);
        }catch(exception ex){
            System.debug('inprogress update error--'+ex);
        }
    }
    //Actual data
    private void actualValues(){
        //get all historical data from MyBusiness and LeaderDownLineSummary
        List<String> KeyLst = new List<String>();
        List<Decimal> lstCmpn = new List<Decimal>();
        for(Double ac:actualCamps){
            String tempKey = String.valueOf(currMarket.Market_Id__c)+String.valueOf(Integer.valueOf(ac))+String.valueOf(currUser.ACCT_NR__c);   
            KeyLst.add(tempKey);
            lstCmpn.add(Decimal.valueOf(Integer.valueOf(ac)));
        }
        System.debug('KeyLst--'+KeyLst);
        actMyBusiness = [Select  PRSNL_SLS_AMT__c, GENRTN_1_QPA_CNT__c, GENRTN_1_APPT_CNT__c, FLD_SLS_CMPGN_NR__c, ACCT_NR__c,
                                 AVG_GENRTN_1_QPA_CNT__c, AVG_GENRTN_1_RMVL_PCT__c, AVG_GENRTN_1_ACT_PCT__c, 
                                 AVG_ORD_SIZE_AMT__c, AVG_DISCNT_PCT__c, AVG_GENRTN_1_DISTR_SLS_PCT__c, AVG_GENRTN_1_UNIT_COMM_PCT__c,
                                 AVG_GENRTN_2_DISTR_SLS_PCT__c, AVG_GENRTN_2_UNIT_COMM_PCT__c, AVG_GENRTN_3_DISTR_SLS_PCT__c, 
                                 AVG_GENRTN_3_UNIT_COMM_PCT__c, EXEC_ERNGS_AMT__c, GENRTN_1_STF_CNT__c, GRP_UNIT_SLS_AMT__c,
                                 GENTRTN_1_ACTV_REP_CNT__c, GENRTN_1_TITL_STF_CNT__c, GENRTN_1_RMVL_CNT__c, GENRTN_1_ACT_PCT__c,
                                 GENRTN_1_TITL_1_NEW_STF_CNT__c, GENRTN_1_TITL_2_NEW_STF_CNT__c, GENRTN_1_TITL_3_NEW_STF_CNT__c,
                                 LDR_ERNGS_AMT__c,BONUS_ERNGS_AMT__c,PRSNL_DSCNT_AMT__c,TOTAL_ESTMTD_ERNGS__c
                                From Sales_Leader_History__c 
                                where Contact__c = : curUsrContact.Id
                                and FLD_SLS_CMPGN_NR__c IN:lstCmpn];                                          
        System.debug('act MyBusiness--'+actMyBusiness);
        //System.debug('act LdrDwnSumm--'+actLdrDwnSumm);
        cmpNoSLH_map = new Map<Double,Sales_Leader_History__c>();
        //cmpNoMyBuss_mapap = new Map<Double,Sales_Leader_History__c>();
        if(actMyBusiness.size()>0){
            for(Sales_Leader_History__c mb: actMyBusiness){
                cmpNoSLH_map.put(mb.FLD_SLS_CMPGN_NR__c, mb);
            }
        }
        System.debug('cmpNoSLH_map---'+cmpNoSLH_map);
        
    }
    //create wrapper obj list
    public Pagereference populateWrapObj(){
        My_Business_Row__c fieldData=new My_Business_Row__c();
        System.debug('inside populate Wrap');
        List<String> KPIs = new List<String>();
        KPIs = currMarket.Business_Plan_KPIs__c.split(';');//get all the KPI names which will be displayed in the BP
        System.debug('KPIs---->'+KPIs);
        
        bpsp = new List<BPlanWrap>();
        Boolean isOddLine =false;
        lastUpdate = BP_asMap.get('Last_Updated__c'); 
        for(String kp: KPIs){
            System.debug('current Kpi--'+kp);
            BPlanWrap tempBPWrp = new BPlanWrap();//New Wrapper object
            tempBPWrp.KPI_name = kp;
            if(isOddLine == true){
                isOddLine = false;
            }else{
                isOddLine = true;
            }
            tempBPWrp.isOdd = isOddLine;
            List<String> tempPCvalues = new List<String>();
            if(kpiCustSett_map.get(kp) !=null){
                //actual campn value population
                System.debug('actualCamps--'+actualCamps);
                if(kpiCustSett_map.get(kp).Input_Count__c != null){
                    tempBPWrp.inputCount = Integer.valueOf(kpiCustSett_map.get(kp).Input_Count__c); 
                }
                if(kpiCustSett_map.get(kp).isHeader__c == 'true'){
                    tempBPWrp.isHeaderKPI = true;
                }else{
                    tempBPWrp.isHeaderKPI = false;
                }
                    if(isInProgPlan){
                        if(BP_asMap.get(kpiCustSett_map.get(kp).Variance_Field_Name__c) != null){
                            tempPCvalues.add(Math.round(Double.valueOf(BP_asMap.get(kpiCustSett_map.get(kp).Variance_Field_Name__c))).format());
                        }else{
                            tempPCvalues.add(' ');
                        }
                    }
                    System.debug('tempPCvalues--'+tempPCvalues);
                if(actualCamps.size()>0){
                    for(Double ac: actualCamps){
                        if(kpiCustSett_map.get(kp).Object_Name__c == 'Sales_Leader_History__c'){
                            if(cmpNoSLH_map.get(ac) !=null){
                                System.debug('Sales_Leader_History__c --'+cmpNoSLH_map.get(ac)+'--for campaign--'+ac);
                                if(cmpNoSLH_map.get(ac).get(kpiCustSett_map.get(kp).PC_Field_Name__c) != null){
                                    tempPCvalues.add(Math.round(Double.valueOf(cmpNoSLH_map.get(ac).get(kpiCustSett_map.get(kp).PC_Field_Name__c))).format());
                                }else{
                                    tempPCvalues.add(' ');
                                }
                            }else{
                                tempPCvalues.add(' ');
                            }
                        }
                    }
                }
                //future value population
                if(futureCampns.size()>0){
                    for(Integer i=0;i<futureCampns.size();i++){
                        if(isInProgPlan){
                            System.debug('(i+actualCamps.size())--'+(i+actualCamps.size())+'--kp--'+kp);
                            if((i+actualCamps.size()) == 0){
                                System.debug('inside CC');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc = '0';
                                }
                                tempBPWrp.isCC = true;
                            }
                            else if((i+actualCamps.size()) == 1){
                                System.debug('inside CC+1');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_1_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_1 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_1_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_1 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_1_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_1 = '0';
                                }
                                tempBPWrp.isCC_1 = true;
                            }
                            else if((i+actualCamps.size()) == 2){
                                System.debug('inside CC+2');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_2_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_2 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_2_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_2 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_2_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_2 = '0';
                                }
                                tempBPWrp.isCC_2 = true;
                            }
                            else if((i+actualCamps.size()) == 3){
                                System.debug('inside CC+3');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_3_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_3 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_3_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_3 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_3_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_3 = '0';
                                }
                                tempBPWrp.isCC_3 = true;
                            }
                            else if((i+actualCamps.size()) == 4){
                                System.debug('inside CC+4');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_4_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_4 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_4_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_4 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_4_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_4 = '0';
                                }
                                tempBPWrp.isCC_4 = true;
                            }
                            else if((i+actualCamps.size()) == 5){
                                System.debug('inside CC+5');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_5_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_5 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_5_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_5 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_5_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_5 = '0';
                                }
                                tempBPWrp.isCC_5 = true;
                            }
                            else if((i+actualCamps.size()) == 6){
                                System.debug('inside CC+6');
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_6 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_6 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)))));
                                    }
                                    tempBPWrp.cc_6 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)))).format();
                                }else{
                                    tempBPWrp.cc_6 = '0';
                                }
                                tempBPWrp.isCC_6 = true;
                            }
                        }
                        else if(isBlankPlan){
                            if(i == 0){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_Field_Name__c)) != null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc = '0';
                                }
                                tempBPWrp.isCC = true;
                            }
                            else if(i == 1){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_1_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_1 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_1_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_1 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_1_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_1 = '0';
                                }
                                tempBPWrp.isCC_1 = true;
                            }
                            else if(i == 2){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_2_Field_Name__c)) != null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_2 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_2_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_2 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_2_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_2 = '0';
                                }
                                tempBPWrp.isCC_2 = true;
                            }
                            else if(i == 3){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_3_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_3 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_3_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_3 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_3_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_3 = '0';
                                }
                                tempBPWrp.isCC_3 = true;
                            }
                            else if(i == 4){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_4_Field_Name__c)) !=null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_4 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_4_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_4 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_4_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_4 = '0';
                                }
                                tempBPWrp.isCC_4 = true;
                            }
                            else if(i == 5){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_5_Field_Name__c)) != null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_5 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_5_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_5 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_5_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_5 = '0';
                                }
                                tempBPWrp.isCC_5 = true;
                            }
                            else if(i == 6){
                                if(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)) != null){
                                    if(kpiCustSett_map.get(kp).isFuture__c != 'true'){
                                        tempBPWrp.cc_6 = Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)))).format();
                                    }else{
                                        tempBPWrp.cc_6 = String.valueOf(Math.round(Double.valueOf(BP_asMap.get(String.valueOf(kpiCustSett_map.get(kp).CC_6_Field_Name__c)))));
                                    }
                                }else{
                                    tempBPWrp.cc_6 = '0';
                                }
                                tempBPWrp.isCC_6 = true;
                            }
                        }
                        if(String.valueOf(kpiCustSett_map.get(kp).isFuture__c) == 'true' && isPageRO ==false){
                            tempBPWrp.isFutureRW = true;
                        }else{
                            tempBPWrp.isFutureRW = false;
                        }
                        if(String.valueOf(kpiCustSett_map.get(kp).isCurrency__c) == 'true' && isPageRO ==false){
                            tempBPWrp.isCurrency = true;
                        }else{
                            tempBPWrp.isCurrency = false;
                        }
                    }
                }
            }else{
                tempPCvalues.add(' ');
            }
            System.debug('tempPCvalues-all--'+tempPCvalues);
            tempBPWrp.PC_Values = tempPCvalues;
            System.debug('tempBPWrp---'+tempBPWrp);
            bpsp.add(tempBPWrp);
            System.debug('swarnava'+bpsp.size());
        }
        return null;
    }
    public pageReference cancelChanges(){
        List<Business_Plan__c> myPrevBPs = [Select Id, IsDeleted__c, Name, LastModifiedDate 
                                     from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                     and Market_Id__c =:currUser.MRKT_ID__c and IsDeleted__c = true order by LastModifiedDate desc];
        Business_Plan__c originalPlan = new Business_Plan__c(Id=BPId);
        System.debug('isInProgPlan--'+isInProgPlan);
        if(isInProgPlan){
            System.debug('inside inprogress revert');
            List<String> AllFieldsfrUpdate = new List<String>{'PRSNL_SLS_AMT__c','NEXT1_PRSNL_SLS_AMT__c','NEXT2_PRSNL_SLS_AMT__c','NEXT3_PRSNL_SLS_AMT__c','NEXT4_PRSNL_SLS_AMT__c','NEXT5_PRSNL_SLS_AMT__c','NEXT6_PRSNL_SLS_AMT__c',
                                                              'GENRTN_1_APPT_CNT__c','NEXT1_GENRTN_1_APPT_CNT__c','NEXT2_GENRTN_1_APPT_CNT__c','NEXT3_GENRTN_1_APPT_CNT__c','NEXT4_GENRTN_1_APPT_CNT__c','NEXT5_GENRTN_1_APPT_CNT__c','NEXT1_GENRTN_1_APPT_CNT__c',
                                                              'GENRTN_1_TITL_1_STF_CNT__c','NEXT1_GENRTN_1_TITL_1_STF_CNT__c','NEXT2_GENRTN_1_TITL_1_STF_CNT__c','NEXT3_GENRTN_1_TITL_1_STF_CNT__c','NEXT4_GENRTN_1_TITL_1_STF_CNT__c','NEXT5_GENRTN_1_TITL_1_STF_CNT__c','NEXT6_GENRTN_1_TITL_1_STF_CNT__c',
                                                              'GENRTN_1_TITL_2_STF_CNT__c','NEXT1_GENRTN_1_TITL_2_STF_CNT__c','NEXT2_GENRTN_1_TITL_2_STF_CNT__c','NEXT3_GENRTN_1_TITL_2_STF_CNT__c','NEXT4_GENRTN_1_TITL_2_STF_CNT__c','NEXT5_GENRTN_1_TITL_2_STF_CNT__c','NEXT6_GENRTN_1_TITL_2_STF_CNT__c',
                                                              'GENRTN_1_TITL_3_STF_CNT__c','NEXT1_GENRTN_1_TITL_3_STF_CNT__c','NEXT2_GENRTN_1_TITL_3_STF_CNT__c','NEXT3_GENRTN_1_TITL_3_STF_CNT__c','NEXT4_GENRTN_1_TITL_3_STF_CNT__c','NEXT5_GENRTN_1_TITL_3_STF_CNT__c','NEXT6_GENRTN_1_TITL_3_STF_CNT__c'};
            System.debug('BP_Original--'+BP_Original);
            for(String fld: AllFieldsfrUpdate){
                if(BP_Original.get(fld) !=null){
                    originalPlan.put(fld,Double.valueOf(BP_Original.get(fld)));
                }
            }
            try{
                update originalPlan;
            }catch(exception e){
                System.debug('original reveret failed---'+e);
            }
        }else if(isBlankPlan){
            if(myPrevBPs.size()>0){
                myPrevBPs[0].IsDeleted__c = false;
                try{
                    update myPrevBPs[0];
                }catch(exception ex){
                    System.debug('revert failed');
                }
            }
            try{
                delete originalPlan;
            }catch(exception ex){
                System.debug('delete failed--'+ex);
            }
        }
        return null;
    }
    
    //Start New Plan
    public PageReference startNewPlan(){
        System.debug('start new plan');
        /*Business_Plan__c BPfrDelete = new Business_Plan__c(Id=BPId,IsDeleted__c=true);
        try{
            update BPfrDelete;
            BPAction();
        }catch(exception e){
            System.debug('delete error--'+e);
        }*/
        Business_Plan__c blankBP = new Business_Plan__c();
        shortTermGoals = '';
        longTermGoals = '';
        personalAcheivementPY = '';
        unitAcheivementPY = '';
        keyLearnings ='';
        followup30 = '';
        followup60 = '';
        followup90 = '';
        navigateMtd(blankBP,false);
        return null;
    }
    //Calculate method
    public Pagereference processPage(){
        System.debug('inside calculate now');
        System.debug('bpsp--'+bpsp);
        isCalculateBtn = true;
        isSaveBtn = true;
        Business_Plan__c BPfrUpdate = new Business_Plan__c(Id=BPId);
        for(BPlanWrap wp:bpsp){
            if(wp.isFutureRW){
                if(kpiCustSett_map.get(wp.KPI_name) !=null){
                    System.debug('Custom setting--'+kpiCustSett_map.get(wp.KPI_name));
                    if(wp.cc !='' && wp.cc != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_Field_Name__c,Integer.valueOf(wp.cc));
                    }if(wp.cc_1 !='' && wp.cc_1 != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_1_Field_Name__c,Integer.valueOf(wp.cc_1));
                    }if(wp.cc_2 !='' && wp.cc_2 != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_2_Field_Name__c,Integer.valueOf(wp.cc_2));
                    }if(wp.cc_3 !='' && wp.cc_3 != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_3_Field_Name__c,Integer.valueOf(wp.cc_3));
                    }if(wp.cc_4 !='' && wp.cc_4 != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_4_Field_Name__c,Integer.valueOf(wp.cc_4));
                    }if(wp.cc_5 !='' && wp.cc_5 != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_5_Field_Name__c,Integer.valueOf(wp.cc_5));
                    }if(wp.cc_6 !='' && wp.cc_6 != null){
                        BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_6_Field_Name__c,Integer.valueOf(wp.cc_6));
                    }
                    /*BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_1_Field_Name__c,Integer.valueOf(wp.cc_1));
                    BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_2_Field_Name__c,Integer.valueOf(wp.cc_2));
                    BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_3_Field_Name__c,Integer.valueOf(wp.cc_3));
                    BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_4_Field_Name__c,Integer.valueOf(wp.cc_4));
                    BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_5_Field_Name__c,Integer.valueOf(wp.cc_5));
                    BPfrUpdate.put(kpiCustSett_map.get(wp.KPI_name).CC_6_Field_Name__c,Integer.valueOf(wp.cc_6));*/
                }
            }
        }
        try{
            update BPfrUpdate;
            BP_asMap = RecordBuilder.buildRecord(BPfrUpdate.Id);
            System.debug('BP_asMap--'+BP_asMap);
        }catch(exception e){
            System.debug('Update error--'+e);
        }
        populateWrapObj();
        return null;
    }
    //Save method
    public Pagereference dummy()
    {
      return null; 
    }
    public Pagereference savePage(){
        System.debug('inside save method');
        List<Business_Plan__c> myPrevBPs = [Select Id, IsDeleted__c, Name 
                                     from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                     and Market_Id__c =:currUser.MRKT_ID__c and IsDeleted__c = true];
        if(myPrevBPs.size()>0){
            try{
                delete myPrevBPs;
            }catch(exception ex){
                System.debug('delete failed on save'+ex);
            }
        }
        if(isBlankPlan){
            if(OriginalBPId != null && OriginalBPId !=''){
                Business_Plan__c OrgBP = new Business_Plan__c(Id=OriginalBPId,IsDeleted__c=true);
                try{
                    update OrgBP;
                }catch(exception ex){
                    System.debug('Original BP update failed--'+ex);
                }
            }
        }                                    
        System.debug('bpsp in save--'+bpsp);
        Business_Plan__c BPfrSave = new Business_Plan__c(Id=BPId);
        BPfrSave.Short_Term_Goals__c = shortTermGoals;
        BPfrSave.Long_Term_Dreams__c = longTermGoals;
        BPfrSave.Personal_Achievement__c = personalAcheivementPY;
        BPfrSave.Unit_Achievement__c = unitAcheivementPY;
        BPfrSave.Key_Learnings__c = keyLearnings;
        BPfrSave.Last_Updated__c = System.now();
        BPfrSave.Is_BP_Saved__c = true;
        if(recruiting_ActStr1 != System.Label.Action){
            BPfrSave.RECR_ACTN1__c = recruiting_ActStr1;
        }else{
            BPfrSave.RECR_ACTN1__c= null;
        }
        if(recruiting_ActStr2 != System.Label.Action){
            BPfrSave.RECR_ACTN2__c = recruiting_ActStr2;
        }else{
            BPfrSave.RECR_ACTN2__c = null;
        }
        if(recruiting_ActStr3 != System.Label.Action){
            BPfrSave.RECR_ACTN3__c = recruiting_ActStr3;
        }else{
            BPfrSave.RECR_ACTN3__c = null;
        }
        if(activity_ActStr1 != System.Label.Action){
            BPfrSave.ACT_ACTN1__c = activity_ActStr1;
        }else{
            BPfrSave.ACT_ACTN1__c = null;
        }
        if(activity_ActStr2 != System.Label.Action){
            BPfrSave.ACT_ACTN2__c = activity_ActStr2;
        }else{
            BPfrSave.ACT_ACTN2__c = null;
        }
        if(activity_ActStr3 != System.Label.Action){
            BPfrSave.ACT_ACTN3__c = activity_ActStr3;
        }else{
            BPfrSave.ACT_ACTN3__c = null;
        }
        if(topSeller_ActStr1 != System.Label.Action){
            BPfrSave.TOP_SLR_ACTN1__c = topSeller_ActStr1;
        }else{
            BPfrSave.TOP_SLR_ACTN1__c = null;
        }
        if(topSeller_ActStr2 != System.Label.Action){
            BPfrSave.TOP_SLR_ACTN2__c = topSeller_ActStr2;
        }else{
            BPfrSave.TOP_SLR_ACTN2__c = null;
        }
        if(topSeller_ActStr3 != System.Label.Action){
            BPfrSave.TOP_SLR_ACTN3__c = topSeller_ActStr3;
        }else{
            BPfrSave.TOP_SLR_ACTN3__c = null;
        }
        if(topSeller_Candidates != System.Label.Candidates){
            BPfrSave.TOP_SLR_CND__c = topSeller_Candidates;
        }else{
            BPfrSave.TOP_SLR_CND__c = null;
        }
        if(leadership_ActStr1 != System.Label.Action){
            BPfrSave.LDRSHP_TITL_ACTN1__c = leadership_ActStr1;
        }else{
            BPfrSave.LDRSHP_TITL_ACTN1__c = null;
        }
        if(leadership_ActStr2 != System.Label.Action){
            BPfrSave.LDRSHP_TITL_ACTN2__c = leadership_ActStr2;
        }else{
            BPfrSave.LDRSHP_TITL_ACTN2__c = null;
        }
        if(leadership_ActStr3 != System.Label.Action){
            BPfrSave.LDRSHP_TITL_ACTN3__c = leadership_ActStr3;
        }else{
            BPfrSave.LDRSHP_TITL_ACTN3__c = null;
        }
        if(leadership_Candidates != System.Label.Candidates){
            BPfrSave.LDRSHP_TITL_CND__c = leadership_Candidates;
        }else{
            BPfrSave.LDRSHP_TITL_CND__c = null;
        }
        if(perDev_ActStr1 != System.Label.Action){
            BPfrSave.PRSNL_DEV_PLN_ACTN1__c = perDev_ActStr1;
        }else{
            BPfrSave.PRSNL_DEV_PLN_ACTN1__c = null;
        }
        if(perDev_ActStr2 != System.Label.Action){
            BPfrSave.PRSNL_DEV_PLN_ACTN2__c = perDev_ActStr2;
        }else{
            BPfrSave.PRSNL_DEV_PLN_ACTN2__c = null;
        }
        if(perDev_ActStr3 != System.Label.Action){
            BPfrSave.PRSNL_DEV_PLN_ACTN3__c = perDev_ActStr3;
        }else{
            BPfrSave.PRSNL_DEV_PLN_ACTN3__c = null;
        }
        if(perDev_ActStr4 != System.Label.Action){
            BPfrSave.PRSNL_DEV_PLN_PLN1__c = perDev_ActStr4;
        }else{
            BPfrSave.PRSNL_DEV_PLN_PLN1__c = null;
        }
        if(perDev_ActStr5 != System.Label.Action){
            BPfrSave.PRSNL_DEV_PLN_PLN2__c = perDev_ActStr5;
        }else{
            BPfrSave.PRSNL_DEV_PLN_PLN2__c = null;
        }
        if(perDev_ActStr6 != System.Label.Action){
            BPfrSave.PRSNL_DEV_PLN_PLN3__c = perDev_ActStr6;
        }else{
            BPfrSave.PRSNL_DEV_PLN_PLN3__c = null;
        }
        if(rising_ActStr1 != System.Label.Action){
            BPfrSave.RSNG_STR_DEV_ACTN1__c = rising_ActStr1;
        }else{
            BPfrSave.RSNG_STR_DEV_ACTN1__c = null;
        }
        if(rising_ActStr2 != System.Label.Action){
            BPfrSave.RSNG_STR_DEV_ACTN2__c = rising_ActStr2;
        }else{
            BPfrSave.RSNG_STR_DEV_ACTN2__c = null;
        }
        if(rising_ActStr3 != System.Label.Action){
            BPfrSave.RSNG_STR_DEV_ACTN3__c = rising_ActStr3;
        }else{
            BPfrSave.RSNG_STR_DEV_ACTN3__c = null;
        }
        if(rising_Candidates != System.Label.Candidates){
            BPfrSave.RSNG_STR_DEV_CND__c = rising_Candidates;
        }else{
            BPfrSave.RSNG_STR_DEV_CND__c = null;
        }
               
        System.debug('followup30--'+followup30+'--followup60--'+followup60+'--followup90--'+followup90);
        if(followup30 !=null && followup30 !=''){      
            BPfrSave.FLWUP_MTG_30__c = date.parse(followup30);   
        }
        if(followup60 !=null && followup60 !=''){
            BPfrSave.FLWUP_MTG_60__c = date.parse(followup60);
        }
        if(followup90 !=null && followup90 !=''){
            BPfrSave.FLWUP_MTG_90__c = date.parse(followup90);
        }
    if(bpsp != null){
        for(BPlanWrap wp:bpsp){
            if(wp.isFutureRW){
                if(kpiCustSett_map.get(wp.KPI_name) !=null){
                    System.debug('Custom setting--'+kpiCustSett_map.get(wp.KPI_name));
                    if(wp.cc !='' && wp.cc != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_Field_Name__c,Integer.valueOf(wp.cc));
                    }
                    if(wp.cc_1 !='' && wp.cc_1 != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_1_Field_Name__c,Integer.valueOf(wp.cc_1));
                    }
                    if(wp.cc_2 !='' && wp.cc_2 != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_2_Field_Name__c,Integer.valueOf(wp.cc_2));
                    }
                    if(wp.cc_3 !='' && wp.cc_3 != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_3_Field_Name__c,Integer.valueOf(wp.cc_3));
                    }
                    if(wp.cc_4 !='' && wp.cc_4 != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_4_Field_Name__c,Integer.valueOf(wp.cc_4));
                    }
                    if(wp.cc_5 !='' && wp.cc_5 != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_5_Field_Name__c,Integer.valueOf(wp.cc_5));
                    }
                    if(wp.cc_6 !='' && wp.cc_6 != null){
                        BPfrSave.put(kpiCustSett_map.get(wp.KPI_name).CC_6_Field_Name__c,Integer.valueOf(wp.cc_6));
                    }
                }
            }
        }
        }
        try{
            update BPfrSave;
            sendMessages(BPfrSave.Id);
        }catch(exception e){
            System.debug('save error--'+e);
        }
        return null;
    }
    //send messages to uplines
    private void sendMessages(String BPId){
        
        
        String GenealogySOQL = 'Select ACCT_NR__c, Genealogy_Level__c from '+ALMRepPerfObj;
        //GenealogySOQL += ' where LFT_ND_ID__c < '+curUsrLeftNode+' and RGT_ND_ID__c> '+curUsrRightNode+' and ROOT_UPLN_ACCT_NR__c = \''+curUsrRtUplnAcc+'\' AND OPERTNL_CMPGN_NR__c = \''+curCampaign+'\'';
        //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
        GenealogySOQL += ' where LFT_ND_ID__c < '+curUsrLeftNode+' and RGT_ND_ID__c> '+curUsrRightNode+' and ROOT_UPLN_ACCT_NR__c = \''+curUsrRtUplnAcc+'\' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(curCampaign) ;
        
        
        System.debug('GenealogySOQL--'+GenealogySOQL);
        List<String> AccNos = new List<String>();
        Map<Integer,String> upIndex_AccNoMap = new Map<Integer,String>();
        
        for(Sobject ge: Database.query(GenealogySOQL)){
            upIndex_AccNoMap.put(Integer.valueOf(ge.get('Genealogy_Level__c')),String.valueOf(ge.get('ACCT_NR__c')));
            AccNos.add(String.valueOf(ge.get('ACCT_NR__c')));
            System.debug('gen lvl --> '+String.valueOf(ge.get('Genealogy_Level__c'))+' -- '+curUsrGenLvl);
        }
        System.debug('upIndex_AccNoMap--'+upIndex_AccNoMap);
        System.debug('AccNos--'+AccNos);
        List<Integer> upIndexLst = new List<Integer>();
        if(AccNos.size()>0){ 
            upIndexLst.addAll(upIndex_AccNoMap.keySet());
            upIndexLst.sort();
        }
        String s_ZM_Profile='Avon Mkt '+currMarket.Market_Id__c+' Zone Manager';
        String s_DM_Profile='Avon Mkt '+currMarket.Market_Id__c+' Division Manager';
 
        List<User> uplines = [Select u.MRKT_ID__c, u.LastName, u.Id, u.FirstName, u.Email, u.DFALT_ZONE_CD__c, u.DFALT_DIV_NM__c, 
                              u.ACCT_NR__c, u.ProfileId, u.Profile.Name, u.LDRSHP_TITL_LVL_NBR__c, u.MRKT_ID_ACCT_NR_KEY__c
                              From User u where (ACCT_NR__c IN: AccNos or (DFALT_ZONE_CD__c =: currUser.DFALT_ZONE_CD__c and Profile.Name=:s_ZM_Profile)
                              or (DFALT_DIV_NM__c =: currUser.DFALT_DIV_NM__c and Profile.Name=:s_DM_Profile))
                              and MRKT_ID__c=: currUser.MRKT_ID__c];
        System.debug('uplines--'+uplines);
        System.debug('sl immediated upline --> '+(curUsrGenLvl-1)+' -- '+upIndex_AccNoMap.get(curUsrGenLvl-1));
        if(uplines.size()>0){
            List<String> uplineAccKeys = new List<String>();
            String zmAccKey = '';
            String dmAccKey = '';
            String upSLAccKey = '';
            String frstEULAccKey = '';
            String mailBody = String.valueOf(System.Label.BusinessPlam_Mail_body_SL);
            for(User us: uplines){
                if(zmAccKey =='' && us.Profile.Name.contains(ALMPLusConstants.AVON_ZM_BASE)){
                    zmAccKey = us.MRKT_ID_ACCT_NR_KEY__c; 
                }else if(dmAccKey == '' && us.Profile.Name.contains(ALMPLusConstants.AVON_DM_BASE)){
                    dmAccKey = us.MRKT_ID_ACCT_NR_KEY__c;
                }else if(upIndex_AccNoMap.get(curUsrGenLvl-1) != null){//get imediate upline
                    if(us.ACCT_NR__c == upIndex_AccNoMap.get(curUsrGenLvl-1)){
                        upSLAccKey = us.MRKT_ID_ACCT_NR_KEY__c;
                    }
                }else if(frstEULAccKey ==''){//get first EUL
                    if(upIndexLst.size()>0){
                        for(Integer uidx: upIndexLst){
                            if(upIndex_AccNoMap.get(uidx) != null){
                                if(us.ACCT_NR__c == upIndex_AccNoMap.get(uidx) && us.LDRSHP_TITL_LVL_NBR__c == ALMPLusConstants.EUL_TITLE_NO){
                                    frstEULAccKey = us.MRKT_ID_ACCT_NR_KEY__c;
                                    mailBody = String.valueOf(System.Label.BusinessPlan_Mail_body_EUL);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if(zmAccKey !=''){
                uplineAccKeys.add(zmAccKey);
            }
            if(dmAccKey !=''){
                uplineAccKeys.add(dmAccKey);
            }
            if(upSLAccKey !=''){
                uplineAccKeys.add(upSLAccKey);
            }
            if(frstEULAccKey !=''){
                uplineAccKeys.add(frstEULAccKey);
            }
            if(uplineAccKeys.size()>0){
                mailBody.replace('SLNAME', currUser.Name);
                EmailUtils.sendFreeFormEmail(uplineAccKeys,System.Label.New_Business_Plan,mailBody);
            }
        }                             
    }
    //intial values
    public Pagereference intialValues(){
        System.debug('\n ##### isPageRO -->> '+isPageRO);
        System.debug('\n ##### BP_asMap Keys -->> \n'+BP_asMap.keySet());
        for(String s : BP_asMap.keySet()){
            System.debug('\n ##### BP_asMap KEY ::  -->> \n'+s);
            System.debug('\n ##### BP_asMap VALUE ::  -->> \n'+BP_asMap.get(s));    
        }
        String currURL = String.valueOf(URL.getCurrentRequestUrl());
        if(BP_asMap.get('Short_Term_Goals__c') !=null){
            if(BP_asMap.get('Short_Term_Goals__c') !=''){
                shortTermGoals = BP_asMap.get('Short_Term_Goals__c');
            }
        }
        if(BP_asMap.get('Long_Term_Dreams__c') != null){
            if(BP_asMap.get('Long_Term_Dreams__c') !=''){
                longTermGoals = BP_asMap.get('Long_Term_Dreams__c');
            }
        }
        if(BP_asMap.get('Personal_Achievement__c') !=null){
            if(BP_asMap.get('Personal_Achievement__c') !=''){
                personalAcheivementPY = BP_asMap.get('Personal_Achievement__c');
            }
        }
        if(BP_asMap.get('Unit_Achievement__c') !=null){
            if(BP_asMap.get('Unit_Achievement__c') !=''){
                unitAcheivementPY = BP_asMap.get('Unit_Achievement__c');
            }
        }
        if(BP_asMap.get('Key_Learnings__c') !=null){
            if(BP_asMap.get('Key_Learnings__c') !=''){
                keyLearnings = BP_asMap.get('Key_Learnings__c');
            }
        }
        if(BP_asMap.get('RECR_ACTN1__c') !=null){
            if(BP_asMap.get('RECR_ACTN1__c') !=''){
                recruiting_ActStr1 = BP_asMap.get('RECR_ACTN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                recruiting_ActStr1= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            recruiting_ActStr1= System.Label.Action;
        }
        if(BP_asMap.get('RECR_ACTN2__c') !=null){
            if(BP_asMap.get('RECR_ACTN2__c') !=''){
                recruiting_ActStr2 = BP_asMap.get('RECR_ACTN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                recruiting_ActStr2= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            recruiting_ActStr2= System.Label.Action;
        }
        if(BP_asMap.get('RECR_ACTN3__c') !=null){
            if(BP_asMap.get('RECR_ACTN3__c') !=''){
                recruiting_ActStr3 = BP_asMap.get('RECR_ACTN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                recruiting_ActStr3= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            recruiting_ActStr3= System.Label.Action;
        }
        if(BP_asMap.get('ACT_ACTN1__c') !=null){
            if(BP_asMap.get('ACT_ACTN1__c') !=''){
                activity_ActStr1 = BP_asMap.get('ACT_ACTN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                activity_ActStr1= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            activity_ActStr1= System.Label.Action;
        }
        if(BP_asMap.get('ACT_ACTN2__c') !=null){
            if(BP_asMap.get('ACT_ACTN2__c') !=''){
                activity_ActStr2 = BP_asMap.get('ACT_ACTN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                activity_ActStr2= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            activity_ActStr2= System.Label.Action;
        }
        if(BP_asMap.get('ACT_ACTN3__c') !=null){
            if(BP_asMap.get('ACT_ACTN3__c') !=''){
                activity_ActStr3 = BP_asMap.get('ACT_ACTN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                activity_ActStr3= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            activity_ActStr3= System.Label.Action;
        }
        if(BP_asMap.get('TOP_SLR_ACTN1__c') !=null){
            if(BP_asMap.get('TOP_SLR_ACTN1__c') !=''){
                topSeller_ActStr1 = BP_asMap.get('TOP_SLR_ACTN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                topSeller_ActStr1= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            topSeller_ActStr1= System.Label.Action;
        }
        if(BP_asMap.get('TOP_SLR_ACTN2__c') !=null){
            if(BP_asMap.get('TOP_SLR_ACTN2__c') !=''){
                topSeller_ActStr2 = BP_asMap.get('TOP_SLR_ACTN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                topSeller_ActStr2= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            topSeller_ActStr2= System.Label.Action;
        }
        if(BP_asMap.get('TOP_SLR_ACTN3__c') !=null){
            if(BP_asMap.get('TOP_SLR_ACTN3__c') !=''){
                topSeller_ActStr3 = BP_asMap.get('TOP_SLR_ACTN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                topSeller_ActStr3= System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            topSeller_ActStr3= System.Label.Action;
        }
        if(BP_asMap.get('TOP_SLR_CND__c') !=null){
            if(BP_asMap.get('TOP_SLR_CND__c') !=''){
                topSeller_Candidates = BP_asMap.get('TOP_SLR_CND__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                topSeller_Candidates = System.Label.Candidates;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            topSeller_Candidates = System.Label.Candidates;
        }
        if(BP_asMap.get('LDRSHP_TITL_ACTN1__c') !=null){
            if(BP_asMap.get('LDRSHP_TITL_ACTN1__c') !=''){
                leadership_ActStr1 = BP_asMap.get('LDRSHP_TITL_ACTN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                leadership_ActStr1 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            leadership_ActStr1 = System.Label.Action;
        }
        if(BP_asMap.get('LDRSHP_TITL_ACTN2__c') !=null){
            if(BP_asMap.get('LDRSHP_TITL_ACTN2__c') !=''){
                leadership_ActStr2 = BP_asMap.get('LDRSHP_TITL_ACTN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                leadership_ActStr2 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            leadership_ActStr2 = System.Label.Action;
        }
        if(BP_asMap.get('LDRSHP_TITL_ACTN3__c') !=null){
            if(BP_asMap.get('LDRSHP_TITL_ACTN3__c') !=''){
                leadership_ActStr3 = BP_asMap.get('LDRSHP_TITL_ACTN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
                leadership_ActStr3 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome')) && !isPageRO){
            leadership_ActStr3 = System.Label.Action;
        }
        if(BP_asMap.get('LDRSHP_TITL_CND__c') !=null){
            if(BP_asMap.get('LDRSHP_TITL_CND__c') !=''){
                leadership_Candidates = BP_asMap.get('LDRSHP_TITL_CND__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                leadership_Candidates = System.Label.Candidates;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            leadership_Candidates = System.Label.Candidates;
        }
        if(BP_asMap.get('PRSNL_DEV_PLN_ACTN1__c') !=null){
            if(BP_asMap.get('PRSNL_DEV_PLN_ACTN1__c') !=''){
                perDev_ActStr1 = BP_asMap.get('PRSNL_DEV_PLN_ACTN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                perDev_ActStr1 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            perDev_ActStr1 = System.Label.Action;
        }
        if(BP_asMap.get('PRSNL_DEV_PLN_ACTN2__c') !=null){
            if(BP_asMap.get('PRSNL_DEV_PLN_ACTN2__c') !=''){
                perDev_ActStr2 = BP_asMap.get('PRSNL_DEV_PLN_ACTN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                perDev_ActStr2 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            perDev_ActStr2 = System.Label.Action;
        }
        if(BP_asMap.get('PRSNL_DEV_PLN_ACTN3__c') !=null){
            if(BP_asMap.get('PRSNL_DEV_PLN_ACTN3__c') !=''){
                perDev_ActStr3 = BP_asMap.get('PRSNL_DEV_PLN_ACTN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                perDev_ActStr3 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            perDev_ActStr3 = System.Label.Action;
        }
        if(BP_asMap.get('PRSNL_DEV_PLN_PLN1__c') !=null){
            if(BP_asMap.get('PRSNL_DEV_PLN_PLN1__c') !=''){
                perDev_ActStr4 = BP_asMap.get('PRSNL_DEV_PLN_PLN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                perDev_ActStr4 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            perDev_ActStr4 = System.Label.Action;
        }
        if(BP_asMap.get('PRSNL_DEV_PLN_PLN2__c') !=null){
            if(BP_asMap.get('PRSNL_DEV_PLN_PLN2__c') !=''){
                perDev_ActStr5 = BP_asMap.get('PRSNL_DEV_PLN_PLN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                perDev_ActStr5 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            perDev_ActStr5 = System.Label.Action;
        }
        if(BP_asMap.get('PRSNL_DEV_PLN_PLN3__c') !=null){
            if(BP_asMap.get('PRSNL_DEV_PLN_PLN3__c') !=''){
                perDev_ActStr6 = BP_asMap.get('PRSNL_DEV_PLN_PLN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                perDev_ActStr6 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            perDev_ActStr6 = System.Label.Action;
        }
        if(BP_asMap.get('RSNG_STR_DEV_ACTN1__c') !=null){
            if(BP_asMap.get('RSNG_STR_DEV_ACTN1__c') !=''){
                rising_ActStr1 = BP_asMap.get('RSNG_STR_DEV_ACTN1__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                rising_ActStr1 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            rising_ActStr1 = System.Label.Action;
        }
        if(BP_asMap.get('RSNG_STR_DEV_ACTN2__c') !=null){
            if(BP_asMap.get('RSNG_STR_DEV_ACTN2__c') !=''){
                rising_ActStr2 = BP_asMap.get('RSNG_STR_DEV_ACTN2__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                rising_ActStr2 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            rising_ActStr2 = System.Label.Action;
        }
        if(BP_asMap.get('RSNG_STR_DEV_ACTN3__c') !=null){
            if(BP_asMap.get('RSNG_STR_DEV_ACTN3__c') !=''){
                rising_ActStr3 = BP_asMap.get('RSNG_STR_DEV_ACTN3__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                rising_ActStr3 = System.Label.Action;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            rising_ActStr3 = System.Label.Action;
        }
        if(BP_asMap.get('RSNG_STR_DEV_CND__c') !=null){
            if(BP_asMap.get('RSNG_STR_DEV_CND__c') !=''){
                rising_Candidates = BP_asMap.get('RSNG_STR_DEV_CND__c');
            }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
                rising_Candidates = System.Label.Candidates;
            }
        }else if((currURL.contains('BusinessPlan') || currURL.contains('SLCoachingRecordHome'))&& !isPageRO){
            rising_Candidates = System.Label.Candidates;
        }
        
        //Modified By Rajib to display locale date format on 02/09/2013        
        if(BP_asMap.get('FLWUP_MTG_30__c') !=null){
            System.debug('followup date--'+BP_asMap.get('FLWUP_MTG_30__c'));
            //String year = BP_asMap.get('FLWUP_MTG_30__c').substring(0,4);
            //String month = BP_asMap.get('FLWUP_MTG_30__c').substring(5,7);
            //String day = BP_asMap.get('FLWUP_MTG_30__c').substring(8,10);
            //System.debug('date--'+year+'=='+month+'=='+day);            
            //followup30 = month+'/'+day+'/'+year;   
            followup30 = Date.valueOf(BP_asMap.get('FLWUP_MTG_30__c')).format();
            System.debug('followup date  followup30--'+followup30);    
        }
        if(BP_asMap.get('FLWUP_MTG_60__c') !=null){
            System.debug('followup date--'+BP_asMap.get('FLWUP_MTG_60__c'));            
            followup60 = Date.valueOf(BP_asMap.get('FLWUP_MTG_60__c')).format(); 
        }
        if(BP_asMap.get('FLWUP_MTG_90__c') !=null){
            System.debug('followup date--'+BP_asMap.get('FLWUP_MTG_90__c'));            
            followup90 = Date.valueOf(BP_asMap.get('FLWUP_MTG_90__c')).format();           
        } 
         //EOC
        return null;
    }
    //added by Snehashis
    public PageReference callRepDetails(){
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
    }
    //wrapper class
    public class topHeader{
        public Boolean isPrevCamp{get;set;}
        public String campaignName{get;set;}
        public String campaignYear{get;set;}
    }
    public class BPlanWrap{
        public String KPI_name{get;set;}
        public List<String> PC_Values{get;set;}
        public String cc{get;set;}
        public String cc_1{get;set;}
        public String cc_2{get;set;}
        public String cc_3{get;set;}
        public String cc_4{get;set;}
        public String cc_5{get;set;}
        public String cc_6{get;set;}
        public Integer inputCount{get;set;}
        public Boolean isCC{get;set;}
        public Boolean isCC_1{get;set;}
        public Boolean isCC_2{get;set;}
        public Boolean isCC_3{get;set;}
        public Boolean isCC_4{get;set;}
        public Boolean isCC_5{get;set;}
        public Boolean isCC_6{get;set;}
        public Boolean isFutureRW{get;set;}
        public Boolean isOdd{get;set;}
        public Boolean isHeaderKPI{get;set;}
        public Boolean isTopHeaderKPI{get;set;}  
        public Boolean isCurrency {get; set;}
       
    }
   public String getOmniturePageName() {
        return ALMPlusUtils.generateOmniturePageName('BusinessPlan', null, currUser.Profile.Name);
    }
    
}