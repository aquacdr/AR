/***************************************************************************
 Name          : POC_Controller_BusinessPlan 
 Created By    : Barkha Jain
 Description   : Controller for POC_BusinessPlan 
 Created Date  : Jan 16, 2014                
****************************************************************************/
public with sharing class Controller_SLBusinessPlan {
    public Business_Plan__c BP {get; set;}
    public Boolean isInProgPlan{get;set;}
    
    private Business_Plan__c existingBP;
    private User currUser;
    private Market__c currMarket;
    private Business_Plan_Parameter__c bPlanParam;
    private List<Double> actualCamps;
    private List<Double> futureCampns;
    private Map<Double, Sales_Leader_History__c> cmpNoSLH_map ;
    private Id curUsrContactId;
    private String ALMRepPerfObj;
    private String curCampaign;
    private Integer curUsrLeftNode ;
    private Integer curUsrRightNode ;
    private String curUsrRtUplnAcc ;
    private Integer curUsrGenLvl;
    
    //------------------------------------------------------------------------------------------  
    //Constructor
    //------------------------------------------------------------------------------------------
    public Controller_SLBusinessPlan(){
        isInProgPlan = false;
        initialize();
    }
    
    //------------------------------------------------------------------------------------------
    //Method to initialize current user's data
    //------------------------------------------------------------------------------------------
    private void initialize(){
        currUser = [Select Id, Name, ACCT_NR__c, MRKT_ID__c, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c, DFALT_DIV_NM__c
                    From User where Id = :Userinfo.getUserId()];
        
        currMarket = [Select Market_Id__c, Id, CURRENT_CAMPAIGN_NR__c, CMPGN_STRT_DT__c, X90_Day_Camp_CNT__c,
                        CMPGN_NR__c, CMPGN_END_DT__c, PREV_1_CMPGN_NR__c, ALM_Rep_Indicator__c 
                        From Market__c m where Market_Id__c =:currUser.MRKT_ID__c];
        
        String currMyBusinessKey =  currMarket.Market_Id__c + currUser.ACCT_NR__c;
        for(Contact con : [SELECT Id FROM Contact WHERE MRKT_ACCT_KEY__c = :currMyBusinessKey]){
            curUsrContactId = con.Id;
        }
        
        ALMRepPerfObj = currMarket.ALM_Rep_Indicator__c;
        curCampaign = currMarket.CMPGN_NR__c;
        String ALMRepPerfQuery = 'SELECT Id, LDRSHP_LOA_NR__c, LDRSHP_TITL_LVL_NR__c, LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c, ROOT_UPLN_ACCT_NR__c FROM '
                                 +ALMRepPerfObj+' WHERE MRKT_ACCT_KEY__c = \''+curUsrContactId+'\' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(curCampaign);
        
        List<Sobject> currALMRepPerf = database.query(ALMRepPerfQuery);
        curUsrLeftNode = Integer.valueOf(currALMRepPerf[0].get('LFT_ND_ID__c'));
        curUsrRightNode = Integer.valueOf(currALMRepPerf[0].get('RGT_ND_ID__c'));
        curUsrRtUplnAcc = String.valueOf(currALMRepPerf[0].get('ROOT_UPLN_ACCT_NR__c'));
        curUsrGenLvl = Integer.valueOf(currALMRepPerf[0].get('Genealogy_Level__c'));            
                                           
        List<Business_Plan__c> existingBP = [Select Id, IsDeleted__c, Name, Is_BP_Saved__c, Last_Updated__c, 
                                                Short_Term_Goals__c, Long_Term_Dreams__c, Personal_Achievement__c,
                                                Unit_Achievement__c, Key_Learnings__c, RECR_ACTN1__c, RECR_ACTN2__c,
                                                RECR_ACTN3__c, ACT_ACTN1__c, ACT_ACTN2__c, ACT_ACTN3__c,
                                                TOP_SLR_ACTN1__c, TOP_SLR_ACTN2__c, TOP_SLR_ACTN3__c, TOP_SLR_CND__c,
                                                LDRSHP_TITL_ACTN1__c, LDRSHP_TITL_ACTN2__c, LDRSHP_TITL_ACTN3__c, LDRSHP_TITL_CND__c,
                                                PRSNL_DEV_PLN_ACTN1__c, PRSNL_DEV_PLN_ACTN2__c, PRSNL_DEV_PLN_ACTN3__c,
                                                PRSNL_DEV_PLN_PLN1__c, PRSNL_DEV_PLN_PLN2__c, PRSNL_DEV_PLN_PLN3__c,
                                                RSNG_STR_DEV_ACTN1__c, RSNG_STR_DEV_ACTN2__c, RSNG_STR_DEV_ACTN3__c, RSNG_STR_DEV_CND__c,
                                                FLWUP_MTG_30__c, FLWUP_MTG_60__c, FLWUP_MTG_90__c                                                                                                                                           
                                             from Business_Plan__c 
                                             where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                             and Market_Id__c =:currUser.MRKT_ID__c and IsDeleted__c != true 
                                             and Is_BP_Saved__c != false order by Name desc];
        
        if(existingBP.size() > 0){
            BP = existingBP[0];
            isInProgPlan = true;
        }else{
            startNewPlan();
        }          
    }
    
    //------------------------------------------------------------------------------------------
    // Method to save Business Plan
    //------------------------------------------------------------------------------------------
    public Pagereference saveBP(){  
        List<Business_Plan__c> myPrevBPs = [Select Id, IsDeleted__c, Name 
                                     from Business_Plan__c where Mrkt_Id_Acct_Nr_Key__c =:currUser.MRKT_ID_ACCT_NR_KEY__c 
                                     and Market_Id__c =:currUser.MRKT_ID__c and IsDeleted__c = true];
        
        //Deleting all previous Business plan
        if(myPrevBPs.size()>0){
            try{
                delete myPrevBPs;
            }catch(exception ex){
                ALMLogUtils.log('Previous BP delete failed on business Plan page :'+ex);
            }
        }
        
        //update the old existing plan for isDeleted = true   
        if(existingBP != null){
            existingBP.IsDeleted__c = true;         
            try{
                update existingBP;
            }catch(exception ex){
                ALMLogUtils.log('Existing BP update failed on business Plan page :'+ex);
            }
        }
        
        BP.Last_Updated__c = system.now();
        BP.Is_BP_Saved__c = true;
        
        //save new BP   
        try{
            upsert BP;
            isInProgPlan = true;            
        }catch(exception ex){
            ALMLogUtils.log('Save failed on business Plan page :'+ex);
        }
        
        try{
            sendMessages(BP.Id);
        }
        catch(exception ex){
            ALMLogUtils.log('Message sending failed after saving business paln :'+ex);
        }
        return null;
    }
    
    //------------------------------------------------------------------------------------------
    //send messages to uplines
    //------------------------------------------------------------------------------------------
    private void sendMessages(String BPId){       
        
        String GenealogySOQL = 'Select ACCT_NR__c, Genealogy_Level__c from '+ALMRepPerfObj;
        GenealogySOQL += ' where LFT_ND_ID__c < '+curUsrLeftNode+' and RGT_ND_ID__c> '+curUsrRightNode+' and ROOT_UPLN_ACCT_NR__c = \''+curUsrRtUplnAcc+'\' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(curCampaign) ;
        
        List<String> AccNos = new List<String>();
        Map<Integer,String> upIndex_AccNoMap = new Map<Integer,String>();
        
        for(Sobject ge : Database.query(GenealogySOQL)){
            upIndex_AccNoMap.put(Integer.valueOf(ge.get('Genealogy_Level__c')),String.valueOf(ge.get('ACCT_NR__c')));
            AccNos.add(String.valueOf(ge.get('ACCT_NR__c')));
        }
        
        List<Integer> upIndexLst = new List<Integer>();
        if(AccNos.size() > 0){ 
            upIndexLst.addAll(upIndex_AccNoMap.keySet());
            upIndexLst.sort();
        }
        String s_ZM_Profile = 'Avon Mkt '+currMarket.Market_Id__c+' Zone Manager';
        String s_DM_Profile = 'Avon Mkt '+currMarket.Market_Id__c+' Division Manager';
 
        List<User> uplines = [Select MRKT_ID__c, LastName, Id, FirstName, Email, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, 
                              ACCT_NR__c, ProfileId, Profile.Name, LDRSHP_TITL_LVL_NBR__c, MRKT_ID_ACCT_NR_KEY__c
                              From User
                              where (ACCT_NR__c IN : AccNos or (DFALT_ZONE_CD__c =: currUser.DFALT_ZONE_CD__c and Profile.Name=:s_ZM_Profile)
                              or (DFALT_DIV_NM__c =: currUser.DFALT_DIV_NM__c and Profile.Name=:s_DM_Profile))
                              and MRKT_ID__c = :currUser.MRKT_ID__c];
                              
        if(uplines.size() > 0){
            List<String> uplineAccKeys = new List<String>();
            String zmAccKey = '';
            String dmAccKey = '';
            String upSLAccKey = '';
            String frstEULAccKey = '';
            String mailBody = String.valueOf(System.Label.BusinessPlam_Mail_body_SL);
            for(User us : uplines){
                if(zmAccKey == '' && us.Profile.Name.contains(ALMPLusConstants.AVON_ZM_BASE)){
                    zmAccKey = us.MRKT_ID_ACCT_NR_KEY__c; 
                }else if(dmAccKey == '' && us.Profile.Name.contains(ALMPLusConstants.AVON_DM_BASE)){
                    dmAccKey = us.MRKT_ID_ACCT_NR_KEY__c;
                }else if(upIndex_AccNoMap.get(curUsrGenLvl-1) != null){//get imediate upline
                    if(us.ACCT_NR__c == upIndex_AccNoMap.get(curUsrGenLvl-1)){
                        upSLAccKey = us.MRKT_ID_ACCT_NR_KEY__c;
                    }
                }else if(frstEULAccKey == ''){//get first EUL
                    for(Integer uidx : upIndexLst){
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
            if(zmAccKey != ''){
                uplineAccKeys.add(zmAccKey);
            }
            if(dmAccKey != ''){
                uplineAccKeys.add(dmAccKey);
            }
            if(upSLAccKey != ''){
                uplineAccKeys.add(upSLAccKey);
            }
            if(frstEULAccKey != ''){
                uplineAccKeys.add(frstEULAccKey);
            }
            if(uplineAccKeys.size() > 0){
                mailBody.replace('SLNAME', currUser.Name);
                EmailUtils.sendFreeFormEmail(uplineAccKeys, System.Label.New_Business_Plan, mailBody);
            }
        }                             
    }
    
    //------------------------------------------------------------------------------------------
    //Method to start a new plan
    //------------------------------------------------------------------------------------------
    public pagereference startNewPlan(){
        if(isInProgPlan){
            existingBP = BP;
            isInProgPlan = false;
        }       
        
        BP = new Business_Plan__c();
        populateBPFields();
        return null;
    }
    
    //------------------------------------------------------------------------------------------
    //Method to populate fields of new Business Plan 
    //------------------------------------------------------------------------------------------
    private void populateBPFields(){
        //retrieve business_plan_parameter
        if(bPlanParam == null){
            for(Business_Plan_Parameter__c bpParam : [Select Name, Market_Id__c, Id, AVG_ACTVTY_PCT__c From Business_Plan_Parameter__c 
                          where Market_Id__c =:currMarket.Id order by CreatedDate desc limit 1]){
                bPlanParam = bpParam;   
            }
        }
        
        if(actualCamps == null){
            getPreviosAndFutureCampns();
            populateSalesLeaderHistoryMap();
        }
        
        BP.Business_Plan_Parameter__c = bPlanParam != null ? bPlanParam.Id : null;
        BP.Current_campaign__c = currMarket.CMPGN_NR__c;
        BP.CMPGN_NR__c = currMarket.CMPGN_NR__c;
        BP.Acct_Nr__c = currUser.ACCT_NR__c;
        BP.Market_Id__c = currUser.MRKT_ID__c;
        BP.Mrkt_Id_Acct_Nr_Key__c = currUser.MRKT_ID_ACCT_NR_KEY__c;        
        
        String campaign_nos = '';
        for(Integer i = 0; i < futureCampns.size(); i++){
            campaign_nos = campaign_nos + String.valueOf(Integer.valueOf(futureCampns[i])) + ';';
            if((i+1) <= 6 && (i+1) < futureCampns.size()){
                String fldName = 'NEXT_' + (i+1) + '_CMPGN_NR__c';
                BP.put(fldName, String.valueOf(Integer.valueOf(futureCampns[i+1])));
            }
        }
        campaign_nos = campaign_nos.substring(0, campaign_nos.length() - 1);
        BP.Campaign_Numbers__c = campaign_nos;
        BP.PREV_1_CMPGN_NR__c = String.valueOf(Integer.valueOf(actualCamps[0]));
        
        if(cmpNoSLH_map.containsKey(actualCamps[0])){
            Sales_Leader_History__c tempSLH = cmpNoSLH_map.get(actualCamps[0]);
            BP.AVG_GENRTN_1_QPA_CNT__c = tempSLH.AVG_GENRTN_1_QPA_CNT__c;
            BP.AVG_GENRTN_1_RMVL_PCT__c = tempSLH.AVG_GENRTN_1_RMVL_PCT__c;
            if(tempSLH.AVG_GENRTN_1_ACT_PCT__c > 0){
                BP.AVG_GENRTN_1_ACT_PCT__c = tempSLH.AVG_GENRTN_1_ACT_PCT__c;
            }else if(bPlanParam.AVG_ACTVTY_PCT__c > 0){
                BP.AVG_GENRTN_1_ACT_PCT__c = bPlanParam.AVG_ACTVTY_PCT__c;
            }
            BP.PREV_PRSNL_SLS_AMT__c = tempSLH.PRSNL_SLS_AMT__c;
            BP.AVG_ORD_SIZE_AMT__c = tempSLH.AVG_ORD_SIZE_AMT__c;
            BP.PREV_AVG_DISCNT_PCT__c = tempSLH.AVG_DISCNT_PCT__c;
            BP.PREV_AVG_GENRTN_1_DISTR_SLS_PCT__c = tempSLH.AVG_GENRTN_1_DISTR_SLS_PCT__c;
            BP.PREV_AVG_GENRTN_1_UNIT_COMM_PCT__c = tempSLH.AVG_GENRTN_1_UNIT_COMM_PCT__c;
            BP.PREV_AVG_GENRTN_2_DISTR_SLS_PCT__c = tempSLH.AVG_GENRTN_2_DISTR_SLS_PCT__c;
            BP.PREV_AVG_GENRTN_2_UNIT_COMM_PCT__c = tempSLH.AVG_GENRTN_2_UNIT_COMM_PCT__c;
            BP.PREV_AVG_GENRTN_3_DISTR_SLS_PCT__c = tempSLH.AVG_GENRTN_3_DISTR_SLS_PCT__c;
            BP.PREV_AVG_GENRTN_3_UNIT_COMM_PCT__c = tempSLH.AVG_GENRTN_3_UNIT_COMM_PCT__c;
            BP.PREV_EXEC_ERNGS_AMT__c = tempSLH.EXEC_ERNGS_AMT__c;
            BP.PREV_GENRTN_1_STF_CNT__c = tempSLH.GENRTN_1_STF_CNT__c;
            BP.PREV_GRP_UNIT_SLS_AMT__c = tempSLH.GRP_UNIT_SLS_AMT__c;
            BP.PREV_GENTRTN_1_ACTV_REP_CNT__c = tempSLH.GENTRTN_1_ACTV_REP_CNT__c;
            BP.PREV_GENRTN_1_TITL_STF_CNT__c = tempSLH.GENRTN_1_TITL_STF_CNT__c;
        }
    }
    
    //------------------------------------------------------------------------------------------
    // Retrieving all history and future campaigns
    //------------------------------------------------------------------------------------------
    private void getPreviosAndFutureCampns(){
        actualCamps = new List<Double>();
        futureCampns = new List<Double>();
        Double currCamp = Double.valueOf(currMarket.CMPGN_NR__c.substring(0, currMarket.CMPGN_NR__c.length()-2));
        List<Double> campYears = new List<Double>{currCamp, currCamp + 1};
        Integer rowcount = (Integer.valueOf(currMarket.X90_Day_Camp_CNT__c));
        
        //get current and future campaigns          
        for(Calendar__c cldr : [Select YEAR_NR__c, SystemModstamp, Name, Market__c, MRKT_ID__c, IsDeleted, Id, CURRNT_IND__c, 
                                            CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_END_DT__c From Calendar__c 
                                            where YEAR_NR__c IN :campYears 
                                            and Market__r.Market_Id__c =:currUser.MRKT_ID__c 
                                            and CMPGN_NR__c >= :Double.valueOf(currMarket.CMPGN_NR__c)
                                            order by CMPGN_NR__c asc
                                            limit :rowcount]){          
            futureCampns.add(cldr.CMPGN_NR__c);            
        }
        
        campYears.clear();
        campYears.add(currCamp - 1);
        campYears.add(currCamp);
        
        //get historical campaigns          
        for(Calendar__c cldr : [Select YEAR_NR__c, SystemModstamp, Name, Market__c, MRKT_ID__c, IsDeleted, Id, CURRNT_IND__c, 
                                            CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_END_DT__c From Calendar__c 
                                            where YEAR_NR__c IN :campYears 
                                            and Market__r.Market_Id__c =:currUser.MRKT_ID__c 
                                            and CMPGN_NR__c < :Double.valueOf(currMarket.CMPGN_NR__c)
                                            order by CMPGN_NR__c desc
                                            limit :rowcount]){
            actualCamps.add(cldr.CMPGN_NR__c);                          
        }                                         
        
    }
    
    //------------------------------------------------------------------------------------------
    //preparing a map of Sales Leader History with campaign number
    //------------------------------------------------------------------------------------------
    private void populateSalesLeaderHistoryMap(){
        cmpNoSLH_map = new Map<Double,Sales_Leader_History__c>();
        
        List<Decimal> lstCmpn = new List<Decimal>();
        for(Double ac:actualCamps){
            lstCmpn.add(Decimal.valueOf(Integer.valueOf(ac)));
        }
        
        for(Sales_Leader_History__c mb : [Select PRSNL_SLS_AMT__c, GENRTN_1_QPA_CNT__c, GENRTN_1_APPT_CNT__c, FLD_SLS_CMPGN_NR__c, ACCT_NR__c,
                                             AVG_GENRTN_1_QPA_CNT__c, AVG_GENRTN_1_RMVL_PCT__c, AVG_GENRTN_1_ACT_PCT__c, 
                                             AVG_ORD_SIZE_AMT__c, AVG_DISCNT_PCT__c, AVG_GENRTN_1_DISTR_SLS_PCT__c, AVG_GENRTN_1_UNIT_COMM_PCT__c,
                                             AVG_GENRTN_2_DISTR_SLS_PCT__c, AVG_GENRTN_2_UNIT_COMM_PCT__c, AVG_GENRTN_3_DISTR_SLS_PCT__c, 
                                             AVG_GENRTN_3_UNIT_COMM_PCT__c, EXEC_ERNGS_AMT__c, GENRTN_1_STF_CNT__c, GRP_UNIT_SLS_AMT__c,
                                             GENTRTN_1_ACTV_REP_CNT__c, GENRTN_1_TITL_STF_CNT__c, GENRTN_1_RMVL_CNT__c, GENRTN_1_ACT_PCT__c,
                                             GENRTN_1_TITL_1_NEW_STF_CNT__c, GENRTN_1_TITL_2_NEW_STF_CNT__c, GENRTN_1_TITL_3_NEW_STF_CNT__c,
                                             LDR_ERNGS_AMT__c,BONUS_ERNGS_AMT__c,PRSNL_DSCNT_AMT__c,TOTAL_ESTMTD_ERNGS__c
                                          From Sales_Leader_History__c 
                                          where Contact__c = :curUsrContactId
                                          and FLD_SLS_CMPGN_NR__c IN : lstCmpn]){
            cmpNoSLH_map.put(mb.FLD_SLS_CMPGN_NR__c, mb);
        }        
    }
    
}