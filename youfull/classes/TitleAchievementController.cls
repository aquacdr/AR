/*
** Apex Class/Controller Name           : TitleAchievmentController
** VF Pages associated [Names]          : TitleAchievement Component
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for TitleAchievement component. Inherits from ComponentController
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** March 8 : Created
** 
*/

public class TitleAchievementController extends ComponentController {
    //custom messages
    public String prsnlVlm_CMneededToReach {get; set;} //Personal Volumes
    public String prsnlVlm_CMneededToReachUrl {get; set;} //Personal Volumes
    
    public String prsnlVlm_CMviewMyOrdersText  {get; set;} 
    public String prsnlVlm_CMviewMyOrdersUrl {get; set;}
    
    public String g1Actvs_titledLegs  {get; set;}     //titles legs
    public String g1Actvs_titledLegsUrl  {get; set;}     //titles legs
    
    public String g1Actvs_CMneededToAchieve {get; set;}  //G1 Actives
    public String g1Actvs_CMneededToAchieveUrl {get; set;}  //G1 Actives
    
    public String teamSales_CMmoreToReach {get; set;} //Team Sales
    public String teamSales_CMmoreToReachUrl {get; set;} //Team Sales
    
    
    public String prsnlVlm_titleGoal {get; set;}
    public String prsnlVlm_invoiced {get; set;}
    public String prsnlVlm_submitted {get; set;}
    
    public String teamSales_goal {get; set;}
    public String teamSales_teamSales {get; set;}
    public String teamSales_invoiced {get; set;}
    public String teamSales_submitted {get; set;}
    public String teamSales_blockName {get; set;}
    
    public String g1Actvs_goal {get; set;}
    public String g1Actvs_actives {get; set;}
    public Integer g1Actvs_titledLegsNumber {get; set;}
    
    public BatteryChartParams prsnlVlm_battery {get; set;}
    public BatteryChartParams g1Actvs_battery {get; set;}
    public BatteryChartParams teamSales_battery {get; set;}
    
    public Boolean prsnlVlm_hasData {get; set;}
    public Boolean g1Actvs_hasData {get; set;}
    public Boolean teamSales_hasData {get; set;}
    public boolean isTL {get; set;}
    public Integer lowlineIndG1Active {get; set;}
    
    
    //custom messages' names from constants
    private String pv_CMneededToReachPosName = ALMConstants.PV_CMNEEDED_TO_REACH_POS_NAME;
    private String pv_CMneededToReachNegName = ALMConstants.PV_CMNEEDED_TO_REACH_NEG_NAME;
    private String pv_CMviewMyOrdersName = ALMConstants.PV_CMVIEW_MY_ORDERS_NAME;
    private String g1_CMneededToReachPosName = ALMConstants.G1_CMNEEDED_TO_REACH_POS_NAME;
    private String g1_CMneededToReachNegName = ALMConstants.G1_CMNEEDED_TO_REACH_NEG_NAME;
    private String g1_titledLegsName = ALMConstants.G1_TITLED_LEGS_NAME;
    private String ts_CMmoreToReachPosName = ALMConstants.TS_CMMORE_TO_REACH_POS_NAME;
    private String ts_CMmoreToReachNegName = ALMConstants.TS_CMMORE_TO_REACH_NEG_NAME;
    
    public TitleAchievementController() {
        //leaders require specific information
        try {
            prsnlVlm_battery = new BatteryChartParams();
            g1Actvs_battery = new BatteryChartParams();
            teamSales_battery = new BatteryChartParams();
                    
          //Query contact to get User TL or TM
          Contact c=[select Id,LDR_TYP__c from Contact where MRKT_ACCT_KEY__c=:currUser.MRKT_ID_ACCT_NR_KEY__c limit 1];
          isTL=(c.LDR_TYP__c=='TL'?true:false);  
          System.debug('isTL-->'+isTL);      
          List<Leader_Title__c> listLeaderTitle = leaderUtils.initializeAndRestListSortedByTitleNumber(currMarket.Id, currUser.LanguageLocaleKey);
            leaderType = LandingPageUtils.determineLeaderType(listLeaderTitle, leaderLevel) ;
            System.debug(LoggingLevel.Error,'====================== TitleAchievementController. Current Leader Type : ' + leaderType);
            
            LandingPageUtils.debugList(listLeaderTitle, 'Leader Title Record');
                    
                                            
            List<Custom_Message__c> messagePool = Database.query(LandingPageUtils.generateQueryCMessages(fieldsCustomMessage, userTypes, titleTypes, currMarket.Id,  'Title Achievements'));
            mapCMessages = LandingPageUtils.initializeMessageMap(messagePool);
            LandingPageUtils.debugMap(mapCMessages, 'Custom Message');
                
            //populate attributes for local use
            populateAttributes(almRepPerformance);
                    
            System.debug('====================== TitleAchievement. Constructor: lpu = ' + lpu);
            populateMessages();
                    
            prsnlVlm_hasData = true;
            g1Actvs_hasData = true;
            teamSales_hasData = true;
        } catch(TypeException te) {
            System.debug('prsnlVlm_invoiced or prsnlVlm_submitted or prsnlVlm_titleGoal are not casted properly');
            isValid = false;
            exceptionText = te.getMessage();
        } catch(Exception e) {
            isValid = false;
            exceptionText = e.getMessage();
            System.debug(e.getMessage());
        }
            
    }
    
    //populate numbers from soql query result
    private void populateAttributes(SObject almRepPerformance) {
        
        Integer pv_invoiced;
        Integer pv_submitted;
        Integer pv_goal;
        Integer ts_goal;
        Integer ts_teamSales;
        Integer ts_submitted;
        Integer ts_invoiced;
        Integer g1_goal;
        Integer g1_actives;
        Integer g1_tlNumber;
        
        //numeric values used for batteries
        if (currLeader != null) {
            pv_goal = LandingPageUtils.returnDecToInt(currLeader.MIN_PRSNL_SLS_REQD_AMT__c);
            ts_goal = LandingPageUtils.returnDecToInt(currLeader.MIN_GRP_SLS_REQD_AMT__c);
            this.prsnlVlm_titleGoal = LandingPageUtils.returnDecToString(currLeader.MIN_PRSNL_SLS_REQD_AMT__c, currencyCharacter);
            this.g1Actvs_goal = LandingPageUtils.returnDecToString(currLeader.MIN_REP_RCRTMNTS_REQD_NR__c);
            g1_goal = LandingPageUtils.returnDecToInt(currLeader.MIN_REP_RCRTMNTS_REQD_NR__c);
            
            this.teamSales_goal = LandingPageUtils.returnDecToString(currLeader.MIN_GRP_SLS_REQD_AMT__c, currencyCharacter);
        } 
        
        this.teamSales_teamSales = null;
        this.teamSales_blockName = System.Label.Team_Sales;
        
        if (almRepPerformance != null) {
            
            //String leaderTitle = String.valueOf(almRepPerformance.get('LDRSHP_TITL_LVL_NR__c'));
            
            ts_teamSales = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('YTD_GRP_BLCKD_UNIT_SLS_AMT__c'));
            if (leaderType == ALMConstants.EL) { // different numbers for differenct badge titles
                ts_submitted = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GRP_SUBMTD_SLS_AMT__c'));
                ts_invoiced = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GRP_INVCD_SLS_AMT__c'));
                
                if (almRepPerformance.get('GRP_INVCD_BLCKD_SLS_AMT__c') != null) {
                    this.teamSales_teamSales = System.Label.Blkd_Team_Sales + ': ' + LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_BLCKD_UNIT_SLS_AMT__c'), currencyCharacter);
                }
                /*if (almRepPerformance.get('GRP_INVC_AWRD_SLS_AMT__c') != null) {
                    this.teamSales_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_INVCD_SLS_AMT__c'), currencyCharacter);
                }*/
                if (almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c') != null) {
                    this.teamSales_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
                }
                if (almRepPerformance.get('GRP_SUBMTD_AWRD_SLS_AMT__c') != null) {
                    this.teamSales_submitted = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_SUBMTD_SLS_AMT__c'), currencyCharacter);
                }
                this.teamSales_blockName = System.Label.Team_Sales;
            } else if (leaderType == ALMConstants.SEL) {
                ts_submitted = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GRP_SUBMTD_BLCKD_SLS_AMT__c'));
                ts_invoiced = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GRP_INVCD_BLCKD_SLS_AMT__c'));
                
                if (almRepPerformance.get('GRP_INVC_AWRD_SLS_AMT__c')!= null || almRepPerformance.get('GRP_INVC_RTURN_AWRD_SLS_AMT__c') != null) {
                    this.teamSales_teamSales =  System.Label.Team_Sales + ': ' + LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
                }
                //this.teamSales_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_INVCD_BLCKD_SLS_AMT__c'), currencyCharacter);
                if (almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c') != null) {
                    this.teamSales_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
                }
                this.teamSales_submitted = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_SUBMTD_BLCKD_SLS_AMT__c'), currencyCharacter);
                this.teamSales_blockName = System.Label.Blkd_Team_Sales;
            } else if (leaderType == ALMConstants.UL) {
                ts_submitted = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GRP_SUBMTD_SLS_AMT__c'));
                ts_invoiced = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GRP_INVCD_SLS_AMT__c'));
                
                /*if (almRepPerformance.get('GRP_INVC_AWRD_SLS_AMT__c') != null) {
                    this.teamSales_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_INVCD_SLS_AMT__c'), currencyCharacter);
                }*/
                if (almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c') != null) {
                    this.teamSales_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
                }
                if (almRepPerformance.get('GRP_SUBMTD_AWRD_SLS_AMT__c') != null) {
                    this.teamSales_submitted = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GRP_SUBMTD_SLS_AMT__c'), currencyCharacter);
                }
                
            }
                
            g1_actives = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('GENTRTN_1_ACTV_REP_CNT__c'));
            System.debug(LoggingLevel.Error,'=====this.teamSales_teamSales in titleachievement=======' + this.teamSales_teamSales);
            
            System.debug(LoggingLevel.Error,'=====g1_actives in titleachievement=======' + g1_actives);
            
            this.g1Actvs_actives = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('GENTRTN_1_ACTV_REP_CNT__c'));
            
            System.debug(LoggingLevel.Error,'=====this.g1Actvs_actives in titleachievement=======' + this.g1Actvs_actives);
            
            this.g1Actvs_titledLegsNumber = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('TTL_LEG_CNT__c'));
            
        
            if (almRepPerformance.get('INVC_AWRD_SLS_AMT__c') != null) {
                this.prsnlVlm_invoiced = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('MRKT_INVC_SLS_AMT__c'), currencyCharacter);
            }
            if (almRepPerformance.get('SUBMTD_AWRD_SLS_AMT__c') != null) {// additional check for group submitted sales amount if null
                this.prsnlVlm_submitted = LandingPageUtils.returnDecToString((Decimal)almRepPerformance.get('SUBMTD_SLS_AMT__c'));
            }
            
            pv_invoiced = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('MRKT_INVC_SLS_AMT__c'));
            pv_submitted = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('SUBMTD_SLS_AMT__c'));
            
            ts_invoiced = LandingPageUtils.returnDecToInt((Decimal)almRepPerformance.get('MRKT_INVC_GRP_SLS_AMT__c'));
            
            
        } else {
            teamSales_hasData = false;
            g1Actvs_hasData = false;
            prsnlVlm_hasData = false;
        }
            
        //battery charts' numbers
      System.debug('============== prsnlVlm_battery BEFORE is : ' + prsnlVlm_battery);
        LandingPageUtils.setBattery(prsnlVlm_battery, pv_invoiced, pv_submitted, pv_goal);
                        System.debug('============== prsnlVlm_battery AFTER is : ' + prsnlVlm_battery);
        if(isTL){                //changed for Transition Leader by Swarnava:Start
        if(G1ActiveBaseCnt<g1_goal)                
        {LandingPageUtils.setBattery(g1Actvs_battery, g1_actives, 0, g1_goal);
        lowlineIndG1Active=G1ActiveBaseCnt;
        }
        else if(G1ActiveBaseCnt>g1_goal){
        LandingPageUtils.setBattery(g1Actvs_battery, g1_actives, 0, G1ActiveBaseCnt);
        lowlineIndG1Active=g1_goal;
        }
        else
        LandingPageUtils.setBattery(g1Actvs_battery, g1_actives, 0, g1_goal);//values are equal
        }
        else{
        LandingPageUtils.setBattery(g1Actvs_battery, g1_actives, 0, g1_goal);
        }   //changed for Transition Leader by Swarnava:End
        LandingPageUtils.setBattery(teamSales_battery, ts_invoiced, ts_submitted, ts_goal);
        System.debug('============== teamSales_battery is : ' + teamSales_battery);
    }
    
    
    //populates custom messages
    private void populateMessages() {
        
        String [] textAndUrl = new String [2];
        System.debug('====================== TitleAchievement. populateMessages: mapCMessages is null = ' + (mapCMessages == null));
        System.debug('====================== TitleAchievement. populateMessages: Leader Title Level = ' + leaderLevel);
        System.debug('====================== TitleAchievement. populateMessages: actualPerformance = ' + prsnlVlm_battery.actualPerformance);
        System.debug('====================== TitleAchievement. populateMessages: differenceTargetActual = ' + prsnlVlm_battery.differenceTargetActual);
        System.debug('====================== TitleAchievement. populateMessages: lpu = ' + lpu);
        //personal volume battery
        
        if (prsnlVlm_battery != null) {
            if (prsnlVlm_battery.actualPerformance >= prsnlVlm_battery.goal) {
                LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, pv_CMneededToReachPosName, currencyCharacter, prsnlVlm_battery.actualPerformance, textAndUrl);
            } else {
                LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, pv_CMneededToReachNegName, currencyCharacter, prsnlVlm_battery.differenceTargetActual, textAndUrl);
            }
            prsnlVlm_CMneededToReach = textAndUrl[0] ;
            prsnlVlm_CMneededToReachUrl = textAndUrl[1] ;
            textAndUrl = new String [2];
        } 
        
        System.debug('====================== TitleAchievement. needed to reach message : = ' + prsnlVlm_CMneededToReach);
        prsnlVlm_CMviewMyOrdersText  = LandingPageUtils.getCustomMessage(mapCMessages, leaderLevel, pv_CMviewMyOrdersName) ;
        prsnlVlm_CMviewMyOrdersUrl = LandingPageUtils.getCustomUrl(mapCMessages, leaderLevel, pv_CMviewMyOrdersName) ;
        
        //g1 actives battery
        g1Actvs_titledLegs  = LandingPageUtils.getCustomMessage(mapCMessages, leaderLevel, g1_titledLegsName, g1Actvs_titledLegsNumber); 
        if (g1Actvs_battery != null) {
            //g1Actives custom message and possible url
            if (g1Actvs_battery.actualPerformance >= g1Actvs_battery.goal) {
                LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, g1_CMneededToReachPosName, g1Actvs_battery.actualPerformance, textAndUrl);
            } else {
                LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel,  g1_CMneededToReachNegName, g1Actvs_battery.differenceTargetActual, textAndUrl);
            }
            g1Actvs_CMneededToAchieve = textAndUrl[0] ;
            g1Actvs_CMneededToAchieveUrl = textAndUrl[1] ;
            textAndUrl = new String [2];
        }
        
        // team sales custom message and possible url
        if (teamSales_battery != null) {
            if (teamSales_battery.actualPerformance >= teamSales_battery.goal) {
                LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, ts_CMmoreToReachPosName ,currencyCharacter, teamSales_battery.actualPerformance, textAndUrl);
            } else {
                LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, ts_CMmoreToReachNegName ,currencyCharacter, teamSales_battery.differenceTargetActual, textAndUrl);
            }
            teamSales_CMmoreToReach = textAndUrl[0] ;
            teamSales_CMmoreToReachUrl = textAndUrl[1] ;
            textAndUrl = new String [2];
        }
    }
    
}