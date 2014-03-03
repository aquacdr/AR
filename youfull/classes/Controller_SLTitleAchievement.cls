/***************************************************************************
 Name          : Controller_SLTitleAchievement 
 Description   : Demo version of Title Achievement dashboard
 Created By    : Fay Salwen 
 Created Date  : Dec 19, 2013                
****************************************************************************/

public with sharing class Controller_SLTitleAchievement {
    
    public User currentUser {get;set;}
    public Market__c market;
    public String selectedCampaign {get;set;}  
    
    private Map<String, ALM_Rep_Performance_1__c> repPerformanceMap = new Map<String, ALM_Rep_Performance_1__c>();
    private Map<String, Leader_Title__c> titleMap = new Map<String, Leader_Title__c>();
    private Map<String, List<SL_DTO_Metric>> metricListMap = new Map<String, List<SL_DTO_Metric>>();
        
    //===================================================================//
    //Constructor
    //===================================================================//
    public Controller_SLTitleAchievement () {    
        
        currentUser = [SELECT Id, Profile.Name, MRKT_ID__c, ACCT_NR__c from User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        market = [SELECT Id, Market_Id__c, Mail_Plan_Enabled__c, PREV_1_CMPGN_NR__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c
                        FROM Market__c 
                        WHERE Market_Id__c = :currentUser.MRKT_ID__c];  
        
        // setting Operational Campaign as selected by default                    
        selectedCampaign = market.CMPGN_NR__c;
        
        initialize();   
    }
    
    public void initialize(){
        initializeRepPerformance();
        initializeMetrics();
    }
    
    //===================================================================//
    //Initialize a map of RepPerformanceRecords, keyed by Campaign
    //===================================================================//    
    private void initializeRepPerformance() {

        String repQuery = 'Select ACCT_NR__c,  MRKT_KEY__c, FLD_SLS_CMPGN_NR__c, NXT_TITL_LVL_KEY__c, NXT_TITL_LVL_KEY__r.LDRSHP_TITL_TYPE_NR__c, NRT_INVC_SLS_AMT__c, GENRTN_1_UNIT_SLS_AMT__c, GRP_ACTV_REP_CNT__c, GENTRTN_1_ACTV_REP_CNT__c, MRKT_INVC_GRP_SLS_AMT__c      From ALM_Rep_Performance_1__c Where ACCT_NR__c = \''+currentUser.ACCT_NR__c+'\' AND FLD_SLS_CMPGN_NR__c in ('+market.PREV_1_CMPGN_NR__c+', '+market.CMPGN_NR__c+', '+market.NEXT_1_CMPGN_NR__c+') AND MRKT_KEY__c=\''+market.Id+'\'';
        System.debug('repQuery: ' + repQuery);
        List<ALM_Rep_Performance_1__c> repPerformanceList;
        try{
            repPerformanceList = Database.query(repQuery);
            System.debug('repPerformanceList: ' + repPerformanceList);
        }catch(Exception ex){
            ALMLogUtils.log(ex);
        }
        

        String titleString = '(';
        
        for (ALM_Rep_Performance_1__c repPerf : repPerformanceList) {
            repPerformanceMap.put(String.valueOf(repPerf.FLD_SLS_CMPGN_NR__c), repPerf);
            if (repPerf.NXT_TITL_LVL_KEY__c != null) {
                if (titleString.length() > 1)
                    titleString += ',  ';
                    
                titleString += '\'' +repPerf.NXT_TITL_LVL_KEY__c + '\'';
            }
        }
        titleString += ')';

        String titleQuery = 'Select Id, Market__c, EXEC_IND__c, GENRTN_1_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, GENRTN_2_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, GENRTN_3_ERNGS_PCT__c, GENRTN_3_MIN_ORD_AMT__c, GRAPHIC_ERNG_IMG__c, LANG_CD__c, LCL_LDRSHP_TITL_CD__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c, LDRSHP_TITL_LVL_NR_NUMBER__c, LDRSHP_TITL_LVL_NR__c, MIN_10_LVL_TITL_REQD_NR__c, MIN_11_LVL_TITL_REQD_NR__c, MIN_12_LVL_TITL_REQD_NR__c, MIN_13_LVL_TITL_REQD_NR__c, MIN_14_LVL_TITL_REQD_NR__c, MIN_15_LVL_TITL_REQD_NR__c, MIN_4_LVL_TITL_REQD_NR__c, MIN_5_LVL_TITL_REQD_NR__c, MIN_6_LVL_TITL_REQD_NR__c, MIN_7_LVL_TITL_REQD_NR__c, MIN_8_LVL_TITL_REQD_NR__c, MIN_9_LVL_TITL_REQD_NR__c, MIN_EST_ERNGs_AMT__c, MIN_FRST_LVL_TITL_REQD_NR__c, MIN_GRP_SLS_REQD_AMT__c, MIN_PRSNL_SLS_REQD_AMT__c, MIN_REP_RCRTMNTS_REQD_NR__c, MIN_SCN_LVL_TITL_REQD_NR__c, MIN_THRD_LVL_TITL_REQD_NR__c, MRKT_ID_LDRSHP_TITL_CD_LANG_CD__c, MRKT_ID__c, MRKT_TAG_QLFR_1_NR__c, MRKT_TAG_QLFR_2_NR__c, MRKT_TAG_QLFR_3_NR__c, REQD_GENRTN_1_LDR_CNT_TXT__c, MIN_GENRTN_1_LDR_CNT_TXT__c, MIN_BLCKD_SLS_REQD_AMT__c, LDRSHP_TITL_TYPE_DESC__c, LDRSHP_TITL_TYPE_NR__c From Leader_Title__c Where Id in '+titleString;
        System.debug('titleQuery: ' + titleQuery);
        List<Leader_Title__c> titleList;
        try{
            titleList = Database.query(titleQuery);
            System.debug('titleList: ' + titleList);
        }catch(Exception ex){
            ALMLogUtils.log(ex);
        }

        for (Leader_Title__c title : titleList) {
            titleMap.put(title.Id, title);
        }        
    }
    
    //===================================================================//
    //Set the color of the bar based on the value of the percent
    //===================================================================//    
    private void initializeMetrics() {
        ALM_Rep_Performance_1__c repPerf;
        Leader_Title__c title;
        Double planValue;
        Double actualValue;
        List<SL_KPIConfig__c> kpiConfigs;
        List<SL_DTO_Metric> metricList;
        //POC_DTO_Metric metric;
        for (String campaign : repPerformanceMap.keySet()) {
            repPerf = repPerformanceMap.get(campaign);
            title = titleMap.get(repPerf.NXT_TITL_LVL_KEY__c);
            kpiConfigs = Util_KPIConfig.getKPIConfigsForRepPerformanceAndContext(repPerf, 'Title Achievement');
            metricList = new List<SL_DTO_Metric>();
            for (SL_KPIConfig__c config : kpiConfigs) {
                planValue = (title == null) ? null : Double.valueOf(title.get(config.PlanField__c));
                actualValue = (repPerf == null) ? null : Double.valueOf(repPerf.get(config.ActualField__c));
                metricList.add(new SL_DTO_Metric(config.CustomLabel__c, planValue, actualValue, config.Goal_To_Maximize__c));
            }
            metricListMap.put(campaign,metricList);
        }
    }

    //===================================================================//
    //Get the list of SL_DTO_Metric values to use, based on the selected campaign
    //===================================================================//    
    public List<SL_DTO_Metric> getMetricList () {
        List<SL_DTO_Metric> metricList;
        if (metricListMap != null) {
            metricList = metricListMap.get(selectedCampaign);
        }
        if (metricList == null) {
            metricList = new List<SL_DTO_Metric>();
        }
        System.debug('metricList: ' + metricList);
        return metricList;
    }    
    
    
}