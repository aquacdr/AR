/*
** Apex Class/Controller Name           : IncentivesController
** VF Pages associated [Names]          : IncentivesComponent
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for component Incentives on Landing Page. Inherits from ComponentController.
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** March 13, 2012. Created
** 
*/

public class IncentivesController extends ComponentController {
	
	//sections and batteries
    public BatteryChartParams ldrshipInctvs_battery {get; set;}
    public String ldrshipInctvs_productName {get; set;}
    public String ldrshipInctvs_goal {get; set;}
    public String ldrshipInctvs_sold {get; set;}
    public String ldrshipInctvs_CMneededToEarn {get; set;}
    public String ldrshipInctvs_CMneededToEarnUrl {get; set;}
    
    public BatteryChartParams rprsntvInctvs_battery {get; set;}
    public String rprsntvInctvs_productName {get; set;}
    public String rprsntvInctvs_goal {get; set;}
    public String rprsntvInctvs_sold {get; set;}
    public String rprsntvInctvs_CMearned {get; set;}
    public String rprsntvInctvs_CMearnedUrl {get; set;}
    
    public BatteryChartParams topSlr_battery {get; set;}
    public String topSlr_goal {get; set;}
    public String topSlr_actual {get; set;}
    public String topSlr_CMtoReach {get; set;}
    public String topSlr_CMtoReachUrl {get; set;}
    
    // indicate whether section has data or not
    public Boolean ldrshipInctvs_hasData {get; set;}
    public Boolean rprsntvInctvs_hasData {get; set;}
    public Boolean topSlr_hasData {get; set;}
    
    //local variables
    private Seller_Status__c currTopSeller;
    private Map<String, Incentive__c> mapTypeIncentives;
    private IncentiveUtils iu;
    
	//custom messages
	private String ri_CMearnedPosName = ALMConstants.RI_CM_EARNED_POS_NAME;
	private String ri_CMearnedNegName = ALMConstants.RI_CM_EARNED_NEG_NAME; 
	private String ts_CMtoReachPosName = ALMConstants.TS_CM_TO_REACH_POS_NAME; 
	private String ts_CMtoReachNegName = ALMConstants.TS_CM_TO_REACH_NEG_NAME; 
	private String li_CMneededToEarnPosName = ALMConstants.LI_CMNEEDED_TO_EARN_POS_NAME; 
	private String li_CMneededToEarnNegName = ALMConstants.LI_CMNEEDED_TO_EARN_NEG_NAME; 
    
    public IncentivesController() {
        
    	List<Seller_Status__c> lSeller ;
        try {
            //util class for incentives
            iu = lpu.getIncentivesUtil();
        
        
        	//incentives
            mapTypeIncentives = iu.retMapTypeTitleIncentive(currUser, currMarket);
                	
        	//top seller
            if (almRepPerformance.get('LCL_TOP_SLR_LVL_KEY__c') != null) {
                lSeller = [SELECT CURRNT_CTD_TRGT_AMT__c 
                                                  FROM Seller_Status__c
                                                  WHERE MRKT_ID__c = :currUser.MRKT_ID__c
                                                  AND LCL_TOP_SLR_LVL_KEY__c = : String.valueOf(almRepPerformance.get('LCL_TOP_SLR_LVL_KEY__c'))     
                                                  AND LANG_CD__c = :userLang LIMIT 1];
                                                          
                                                          
                if (lSeller.size() > 0) {
                    currTopSeller = lSeller[0];
                    System.debug('====================== IncentivesController. all top sellers : ' + lSeller);
                    System.debug('======================. Incentives. Current Top Seller : ' + currTopSeller);
                } else {
                	topSlr_hasData = false; // MODIFY ask avon
                }
            } else {
            	topSlr_hasData = false;
            }
                                                      
            if (mapTypeIncentives != null && mapTypeIncentives.size() > 0) {
                System.debug('====================== IncentivesController. All Incentives :');
                for (String str : mapTypeIncentives.keySet()) {
                    System.debug('====================== IncentivesController. another incentives : ' + str + ' -> ' + mapTypeIncentives.get(str));
                }
            }
                	
            //get custom messages for incentives
            List<Custom_Message__c> messagePool = Database.query(LandingPageUtils.generateQueryCMessages(fieldsCustomMessage, userTypes, titleTypes, currMarket.Id, 'incentives'));
            mapCMessages = LandingPageUtils.initializeMessageMap(messagePool);
                    
        	populateAttributes(almRepPerformance);
        	populateMessages();
        
        } catch(Exception e) {
            ldrshipInctvs_hasData = false;
            rprsntvInctvs_hasData = false;
            topSlr_hasData = false;
            isValid = false;
            System.debug('==================== ERRROR1 : ' + ldrshipInctvs_hasData);
            System.debug('==================== ERRROR2: ' + rprsntvInctvs_hasData);
            System.debug('==================== ERRROR3 : ' + topSlr_hasData);
            exceptionText = e.getMessage();
        }
                
        
    }
    
    // populate various figures and words. Like 'Product Name' or 'Sold :'
    private void populateAttributes(SObject almRepPerformanceObj) {
    	
    	//numeric values for batteries
    	Integer lr_goal = null;
    	Integer lr_sold = null;
    	Integer ri_goal = null;
    	Integer ri_sold= null;
    	Integer ts_goal = null;
    	Integer ts_actual = null;
    	
    	Decimal tempDec;
    	String tempStr;
    	Incentive__c tempIncentive;
    	
    	
    	// if Leader Downline Summary record found
    	if (almRepPerformanceObj != null) {
    		ldrshipInctvs_sold = LandingPageUtils.returnDecToString((Decimal)almRepPerformanceObj.get('GRP_FAP_CNT__c'));
    		
    		lr_sold = LandingPageUtils.returnDecToIntAbs((Decimal)almRepPerformanceObj.get('GRP_FAP_CNT__c'));
            ldrshipInctvs_sold =  LandingPageUtils.returnDecToString((Decimal)almRepPerformanceObj.get('GRP_FAP_CNT__c'));
            
            ri_sold = LandingPageUtils.returnDecToIntAbs((Decimal)almRepPerformanceObj.get('FAP_CNT__c'));
    		rprsntvInctvs_sold = LandingPageUtils.returnDecToString((Decimal)almRepPerformanceObj.get('FAP_CNT__c'));
    		
    		ts_actual = LandingPageUtils.returnDecToIntAbs((Decimal)almRepPerformanceObj.get('CTD_AWRD_SLS_AMT__c'));
            topSlr_actual = LandingPageUtils.returnDecToString((Decimal)almRepPerformanceObj.get('CTD_AWRD_SLS_AMT__c'), currencyCharacter);
    	
            
    	} else {
            ldrshipInctvs_sold = null;  
            rprsntvInctvs_sold = null;
    		topSlr_actual  = null; 		
    	}
    
    	//team incentive info
    	if ((tempIncentive = mapTypeIncentives.get('team_+_' + leaderLevel)) != null) {
    		ldrshipInctvs_goal = LandingPageUtils.returnDecToString(tempIncentive.INCNTV_REQ_CNT__c);
    		lr_goal = LandingPageUtils.returnDecToInt(tempIncentive.INCNTV_REQ_CNT__c);
    		
        	ldrshipInctvs_battery = new BatteryChartParams();
        	LandingPageUtils.setBattery(ldrshipInctvs_battery, lr_sold, 0, lr_goal);
            ldrshipInctvs_productName = tempIncentive.INCNTV_PRODCT_NM__c;
            ldrshipInctvs_hasData = true;
    	} else {
    		ldrshipInctvs_goal = null;
    		ldrshipInctvs_sold = null;
    	}
    	
    	// personal incentive info
    	if ((tempIncentive = mapTypeIncentives.get('personal_+_' + leaderLevel)) != null) {
    		rprsntvInctvs_goal = LandingPageUtils.returnDecToString(tempIncentive.INCNTV_REQ_CNT__c);
    		ri_goal = LandingPageUtils.returnDecToInt(tempIncentive.INCNTV_REQ_CNT__c);
    		
            rprsntvInctvs_battery = new BatteryChartParams();
            LandingPageUtils.setBattery(rprsntvInctvs_battery, ri_sold, 0, ri_goal);
            rprsntvInctvs_productName = tempIncentive.INCNTV_PRODCT_NM__c;
            rprsntvInctvs_hasData = true;
    	} else {
    		rprsntvInctvs_goal = null;
    		rprsntvInctvs_sold = null;
    	}
    	
    	// top seller info
    	if (currTopSeller != null) {
    		topSlr_goal = LandingPageUtils.returnDecToString(currTopSeller.CURRNT_CTD_TRGT_AMT__c, currencyCharacter);
    		ts_goal = LandingPageUtils.returnDecToInt(currTopSeller.CURRNT_CTD_TRGT_AMT__c);
    		
            topSlr_battery = new BatteryChartParams();
            LandingPageUtils.setBattery(topSlr_battery, ts_actual, 0, ts_goal);
            topSlr_hasData = true;
    	} else {
    		topSlr_hasData = false;
    		topSlr_actual = null;
    		topSlr_goal = null;
    	}
        
    }
    
    // populate custom messages
    private void populateMessages() {
    	//leadership incentives custom messages
        String [] textUrl = new String[2];
        
    	if (ldrshipInctvs_battery != null) {
    		if (ldrshipInctvs_battery.actualPerformance >= ldrshipInctvs_battery.goal) {
            	LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, li_CMneededToEarnPosName, currencyCharacter, ldrshipInctvs_battery.actualPerformance, textUrl );
    		} else {
    			
            	LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, li_CMneededToEarnNegName, currencyCharacter, ldrshipInctvs_battery.differenceTargetActual, textUrl );
    		}
            ldrshipInctvs_CMneededToEarn = textUrl[0];
            ldrshipInctvs_CMneededToEarnUrl = textUrl[1] ;
    	}
        textUrl = new String[2];
    	
    	//representative incentives custom messages
    	if (rprsntvInctvs_battery != null) {
    		if (rprsntvInctvs_battery.differenceTargetActual <= 0) {
    			
            	LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, ri_CMearnedPosName, rprsntvInctvs_battery.actualPerformance, textUrl);
    		} else {
    			
            	LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, ri_CMearnedNegName, rprsntvInctvs_battery.differenceTargetActual, textUrl);
    		}
            rprsntvInctvs_CMearned = textUrl[0] ;
            rprsntvInctvs_CMearnedUrl = textUrl[1] ;
    	}
        textUrl = new String[2];
    	
    	//top seller custom messages
    	if (topSlr_battery != null) {
            
    		if (topSlr_battery.differenceTargetActual <= 0) {
    			
            	LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, ts_CMtoReachPosName, topSlr_battery.actualPerformance, textUrl);
    		} else {
    			
            	LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, ts_CMtoReachNegName, topSlr_battery.differenceTargetActual, textUrl);
    		}
            topSlr_CMtoReach = textUrl[0];
            topSlr_CMtoReachUrl = textUrl[1];
    	}
    }
}