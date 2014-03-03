//
//  Name            : ZM_KPIPerformanceController
//  Description     : Controller 
//  Author          : V. Mittal
//  Created Date    : Feb, 2013
//  


public with sharing class ZM_KPIPerformanceController {
    
    public list<Sales_Org_Summary__c> lstCampaigns=new list<Sales_Org_Summary__c>();
  
    public list<Sales_Org_Summary__c> lstLastCampaign {get;set;}
    //public list<Sales_Org_Summary__c> getlstLastCampaign(){return this.lstLastCampaign;}  
    
    public list<Sales_Org_Summary__c> lstCurrentCampaign  {get;set;}
    //public list<Sales_Org_Summary__c> getlstCurrentCampaign(){return this.lstCurrentCampaign;}  
    
    public list<Sales_Org_Summary__c> lstNextCampaign  {get;set;}
    //public list<Sales_Org_Summary__c> getlstNextCampaign(){return this.lstNextCampaign;} 
    
    public list<WrapperZoneKPIDetail> lstWrapperZoneKPIDetail{get;set;}
    public list<WrapperSalesLeadership> lstWrapperSalesLeadership{get;set;}
    public list<WrapperSalesLeadership> lstWrapperSalesLeadership_TL{get;set;}
    public list<WrapperSalesLeadership> lstWrapperSalesLeadership_PM{get;set;}
    public list<WrapperSalesLeadership> lstWrapperSalesLeadership_ALL{get;set;}
    public boolean showKPISummary2{get;set;}
    public boolean showKPISummary3{get;set;}
    public boolean boolHasData{get;set;}
    public boolean isDivisionManager{get;set;}
    public Market__c currMarket{get;set;}
    public User currUser{get;set;}
    
    // variables to store operational campaign numbers
    public string strLastCampNumber{get;set;}
    public string strCurrCampNumber{get;set;}
    public string strNextCampNumber{get;set;}
    
    public String strProfileName;
    
    //public String selectedZone {get; set;}
    public List<SelectOption> zoneList {get;set;}
    
    public Boolean showPageHelp{get;set;}
    
    // to show/hide the zone selection drop down on the KPI page
    public Boolean showZoneDropDown {get;set;}
    
    public boolean hideNextCampaign {get;set;}
    
    public boolean isTL {get;set;}
    
    public string strCombObjNm {get;set;}
    
    public string strAcctNbr {get;set;}
    
    public Integer zoneKPIConfigTLSize {get;set;}
    
    // create an instance of the utility class
    public ZM_UtilityClass objutilityclass {get;set;} 
    
    public Boolean isALMPlusEnabled {get; set;}  
           
    // Constructor
    public ZM_KPIPerformanceController(ApexPages.StandardController controller){
    	objutilityclass = new ZM_UtilityClass();
    	
        lstLastCampaign=new list<Sales_Org_Summary__c>();
        lstCurrentCampaign=new list<Sales_Org_Summary__c>();
        lstNextCampaign=new list<Sales_Org_Summary__c>();
        
        showPageHelp=false;
        showZoneDropDown = true;
        isTL = false;
        zoneKPIConfigTLSize = 0;
        
        showKPISummary2=false;
        showKPISummary3=false;
        
       // isTL = false;
       currUser = [Select Id,MRKT_ID__c,ACCT_NR__c from User where Id = :UserInfo.getUserId() ];
       //query below modified by Prakash on 10/22 to include the hide saved and hide held fields
       currMarket = [SELECT CMPGN_NR__c, Market_Currency_Symbol__c, Id, SPONSOR_QLFYING_ORD_AMT__c,Number_of_Exec_Leader_Title__c,NRT_Enabled__c,
                                     CMPGN_END_DT__c, CMPGN_STRT_DT__c, Market_Id__c, PREV_1_CMPGN_NR__c, Allow_Freeform_Email__c, Is_Branch__c, 
                                     ALM_Rep_Indicator__c, NEXT_1_CMPGN_NR__c, Mail_Plan_Enabled__c,MailPlan_LndingPg_Deflt__c, CURRNT_CMPGN_RMN_DAY_CNT__c, NRT_Hide_Held_Column__c , NRT_Hide_Saved_Column__c,
                                    KPI_Measurement_Field__c
                                    FROM Market__c 
                                    WHERE Market_Id__c = :currUser.MRKT_ID__c LIMIT 1];
        
       initializeData(); 
        
    }
    
    /* Method to change the data displayed on the page based on the selected zone number by the user*/ 
    public PageReference changeData() {
        initializeData();
        return null;
    }
    
    
    
    /* method to re-calculate the KPI information for Summary1,2,3 tables */
    public void initializeData(){
        lstWrapperZoneKPIDetail =new list<WrapperZoneKPIDetail>();
        lstWrapperSalesLeadership =new list<WrapperSalesLeadership>();
        lstWrapperSalesLeadership_TL =new list<WrapperSalesLeadership>();
        lstWrapperSalesLeadership_PM =new list<WrapperSalesLeadership>();
        lstWrapperSalesLeadership_ALL =new list<WrapperSalesLeadership>();
        
        Id IdUserProfile = UserInfo.getProfileId();
        objutilityclass= new ZM_UtilityClass();
        objutilityclass.SetVariable();
        
        hideNextCampaign = objutilityclass.hideNextCampaign;
        
        strProfileName = objutilityclass.strProfileName;
        isDivisionManager = false;
        
        strCombObjNm = objutilityclass.strCombObjName;
        strAcctNbr	= objutilityclass.strAcctNbr;
        
        isALMPlusEnabled = objutilityclass.isLeadEnabled;
        

        //if(strProfileName.contains('Zone Manager')|| strProfileName.contains('Division Manager')){
            string strZone='';

        
            if(strProfileName.contains('Zone Manager')){
                isDivisionManager = false;
                //selectedZone = objutilityclass.strDefaltZoneCD; //userDetails.DFALT_ZONE_CD__c;
                zoneList = getZoneListData();
                //zoneList = new Selectoption[]{new SelectOption('301', '301')};
                
                if(zoneList.size() <=1) {
                    showZoneDropDown = false;
                }
                
                if(strZoneName==null && zoneList.size()>0 )
                    strZoneName = zoneList[0].getValue();
            } 
            else {
            	isDivisionManager = true;
            	zoneList = new SelectOption[]{};
            	
            	if (strProfileName.contains('Division Manager')) {
                	zoneList.add(new SelectOption('All',System.Label.ZM_All));
            	}
                
                if(strZoneName!=null && strZoneName!=''){
                    strZone = strZoneName;
                }
                
                zoneList.addAll(getZoneListData());
                
                if(strZoneName==null && zoneList.size()>0 )
                    strZoneName = zoneList[0].getValue();
            }   
            
        
            id userid = Userinfo.getUserId();
            string strCurrentCmpgnNR = objutilityclass.strCurrentCmpgnNR;
            string strPriorCmpgnNR = objutilityclass.strPriorCmpgnNR;
            string strNextCmpgnNR = objutilityclass.strNextCmpgnNR;
            lstCampaigns=new list<Sales_Org_Summary__c>();
            
            System.debug('objutilityclass.strDefaltDivNM-------->'+objutilityclass.strDefaltDivNM);
            System.debug('strZoneName-------->'+strZoneName);
            System.debug('strCurrentCmpgnNR------->'+strCurrentCmpgnNR +', strNextCmpgnNR : '+strNextCmpgnNR+', strPriorCmpgnNR :'+strPriorCmpgnNR);
            
            isTL = objutilityclass.hasTLDonwlines(zoneList, strAcctNbr, Double.valueOf(strCurrentCmpgnNR), strCombObjNm);
            //isTL = true;//to be deleted
            System.debug(' isTL------->'+isTL);
            //System.debug('isDivisionManager-------->'+isDivisionManager+', strZoneName --> '+strZoneName);
            try{
                if(isDivisionManager){
                	System.debug('isDivisionManager######## ');
                	if(strZoneName == 'All') {
                		                	System.debug('isDivisionManager######## 1 ');
                    	String userDefaultDivision = objutilityclass.strDefaltDivNM;
                       // lstCampaigns = Database.query(BASE_SOQL + ' where SLS_ORG_DESC_TXT__c = :userDefaultDivision and (OPERTNL_CMPGN_NR__c =: strCurrentCmpgnNR or OPERTNL_CMPGN_NR__c =: strPriorCmpgnNR or OPERTNL_CMPGN_NR__c =: strNextCmpgnNR) order by OPERTNL_CMPGN_NR__c desc');
                        lstCampaigns = Database.query(BASE_SOQL + ' where SLS_ORG_DESC_TXT__c = :userDefaultDivision and (FLD_SLS_CMPGN_NR__c =: strCurrentCmpgnNR or FLD_SLS_CMPGN_NR__c =: strPriorCmpgnNR or FLD_SLS_CMPGN_NR__c =: strNextCmpgnNR) order by FLD_SLS_CMPGN_NR__c desc');
                    }
                    else {
                    	System.debug('isDivisionManager######## 2 ');
                        //lstCampaigns = Database.query(BASE_SOQL + ' where SLS_ORG_DESC_TXT__c = :strZoneName and (OPERTNL_CMPGN_NR__c =: strCurrentCmpgnNR or OPERTNL_CMPGN_NR__c =: strPriorCmpgnNR or OPERTNL_CMPGN_NR__c =: strNextCmpgnNR) order by OPERTNL_CMPGN_NR__c desc');
                        lstCampaigns = Database.query(BASE_SOQL + ' where SLS_ORG_DESC_TXT__c = :strZoneName and (FLD_SLS_CMPGN_NR__c =: strCurrentCmpgnNR or FLD_SLS_CMPGN_NR__c =: strPriorCmpgnNR or FLD_SLS_CMPGN_NR__c =: strNextCmpgnNR) order by FLD_SLS_CMPGN_NR__c desc');
                    }
                }
                else{
                   // lstCampaigns = Database.query(BASE_SOQL + ' where ZONE_MGR__c=:userid and SLS_ORG_DESC_TXT__c = :strZoneName and (OPERTNL_CMPGN_NR__c =: strCurrentCmpgnNR or OPERTNL_CMPGN_NR__c =: strPriorCmpgnNR or OPERTNL_CMPGN_NR__c =: strNextCmpgnNR) order by OPERTNL_CMPGN_NR__c desc');
                    lstCampaigns = Database.query(BASE_SOQL + ' where ZONE_MGR__c=:userid and SLS_ORG_DESC_TXT__c = :strZoneName and (FLD_SLS_CMPGN_NR__c =: strCurrentCmpgnNR or FLD_SLS_CMPGN_NR__c =: strPriorCmpgnNR or FLD_SLS_CMPGN_NR__c =: strNextCmpgnNR) order by FLD_SLS_CMPGN_NR__c desc');
                }
            }
            catch(Exception e)
            {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));    
            }
    
            system.debug('\n #### lstCampaigns.size() --> '+lstCampaigns.size());
            
            system.debug('\n #### lstCampaigns --> \n'+lstCampaigns);
            
            if(lstCampaigns.size()>0 || Test.isRunningTest()){
                boolHasData = true;
                
                strLastCampNumber = ''; strCurrCampNumber = ''; strNextCampNumber = '';
                
                lstLastCampaign=new list<Sales_Org_Summary__c>();
                lstCurrentCampaign=new list<Sales_Org_Summary__c>();
                lstNextCampaign=new list<Sales_Org_Summary__c>();
                
                for(Sales_Org_Summary__c salOrg: lstCampaigns){
                	system.debug('\n #### LOOP FLD_SLS_CMPGN_NR__c --> \n'+salOrg.FLD_SLS_CMPGN_NR__c);
                    // last campaign
                    //if(salOrg.OPERTNL_CMPGN_NR__c == objutilityclass.strPriorCmpgnNR){ 
                    if(salOrg.FLD_SLS_CMPGN_NR__c == objutilityclass.strPriorCmpgnNR){
                    	
                    	system.debug('\n #### LOOP FLD_SLS_CMPGN_NR__c --> PRIOR');
                    	
                        lstLastCampaign.add(salOrg);
                       // strLastCampNumber = salOrg.OPERTNL_CMPGN_NR__c;
                        strLastCampNumber = salOrg.FLD_SLS_CMPGN_NR__c;
                    }
                    
                    // current campaign
                    //if(salOrg.OPERTNL_CMPGN_NR__c == objutilityclass.strCurrentCmpgnNR){ 
                    if(salOrg.FLD_SLS_CMPGN_NR__c == objutilityclass.strCurrentCmpgnNR){
                    	system.debug('\n #### LOOP FLD_SLS_CMPGN_NR__c --> CURRENT ');
                        lstCurrentCampaign.add(salOrg);
                        //strCurrCampNumber = salOrg.OPERTNL_CMPGN_NR__c;
                        strCurrCampNumber = salOrg.FLD_SLS_CMPGN_NR__c;
                        populateWrapperSalesLeadershipData(lstCurrentCampaign[0]);
                    }
                    
                    // next campaign                    
                    //if(salOrg.OPERTNL_CMPGN_NR__c == objutilityclass.strNextCmpgnNR){
                    if(salOrg.FLD_SLS_CMPGN_NR__c == objutilityclass.strNextCmpgnNR){
                    	system.debug('\n #### LOOP FLD_SLS_CMPGN_NR__c --> NEXT ');
                        lstNextCampaign.add(salOrg);
                        //strNextCampNumber = salOrg.OPERTNL_CMPGN_NR__c;
                        strNextCampNumber = salOrg.FLD_SLS_CMPGN_NR__c;
                    }
                }
                
                Sales_Org_Summary__c salesOrgSummaryLast = !lstLastCampaign.isEmpty()? lstLastCampaign[0]: New Sales_Org_Summary__c();
                Sales_Org_Summary__c salesOrgSummaryCurrent = !lstCurrentCampaign.isEmpty()? lstCurrentCampaign[0]: New Sales_Org_Summary__c();
                Sales_Org_Summary__c salesOrgSummaryNext= !lstNextCampaign.isEmpty()? lstNextCampaign[0]: New Sales_Org_Summary__c();
                
                List<Sales_Org_Summary__c> lstTempSaleOrgSummary= new List<Sales_Org_Summary__c>();
                
                lstTempSaleOrgSummary.add(salesOrgSummaryLast);
                lstTempSaleOrgSummary.add(salesOrgSummaryCurrent);
                
                if(!hideNextCampaign) {
                    lstTempSaleOrgSummary.add(salesOrgSummaryNext);
                }
                populateWrapperZoneKPIDetailData(lstTempSaleOrgSummary);
            } 
            // else if there no SalesOrgSummary data related to the logged in user and campaign, throw an error to user
            else {
                boolHasData = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));                
            }
        //} 
        // if user is neither zone Manager OR Division Manager then throw user an error.
        //else {
        //    boolHasData = false;
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.ZM_Sales_Org_Summary_Insufficient_privileges));
        //}            
    }

    public string strZoneName{get;set;}
    
    /* method will return the list of zones for a zone manager or division manager */
    public List<SelectOption> getZoneListData() {       
        /*
        if(isDivisionManager)
            return getZoneListDivisionManager();
        else
            return getZoneListZoneManager();
        */
                
        List<SelectOption> zoneList = objutilityclass.getZoneList();
        return zoneList;
    }
    
    /* method returns the list of zones for a division manager */
    /*
    public List<SelectOption> getZoneListDivisionManager() {
        List<SelectOption> zoneList = objutilityclass.getZoneList();
        return zoneList;
    }
    */
    
    /* method returns the list of zones for a zone manager */
    /*
    public List<SelectOption> getZoneListZoneManager() { 
        List<SelectOption> zoneList = objutilityclass.getZoneListZonalManager();
        return zoneList;
    }
    */
    
    // New Method - Omniture Addition
    public String getOmniturePageName()      
    {  
        return ALMPlusUtils.generateOmniturePageName('ZM_KPIPerformanceOverview', null, strProfileName);         
    } //this is for getting page name mapping for omniture
    
    // creating the Wrapper list of Sale Org Summary object using the KPI config object and Zone KPI custom object
    public void populateWrapperZoneKPIDetailData(List<Sales_Org_Summary__c> lstSalesOrgSummary){
        string strWCustomLabel;
        string strWCSSClass;
        ZM_UtilityClass objTemputilityclass= new ZM_UtilityClass();
        objTemputilityclass.SetVariable();
        
        ZM_Utility_KPIConfig objZMKPIConfigUtil = new ZM_Utility_KPIConfig();
        
        //Calling the ZM utility KPI Config Class , Passing the Market object record Id and the Class type passing 
        // the utility function  getZoneKPIConfig  return  list Custom setting which contains KPI fields
        List<ZM_ZoneKPIConfig__c> lstZoneKPISUmmary1Config= objZMKPIConfigUtil.getZoneKPIConfig(objTemputilityclass.strMarketRecordId,'KPI Summary 1');
        List<ZM_ZoneKPIConfig__c> lstZoneKPISummary2Config= objZMKPIConfigUtil.getZoneKPIConfig(objTemputilityclass.strMarketRecordId,'KPI Summary 2');
        List<ZM_ZoneKPIConfig__c> lstZoneKPISummary3Config= objZMKPIConfigUtil.getZoneKPIConfig(objTemputilityclass.strMarketRecordId,'KPI Summary 3');
        
        
        // check if there is any corresponding KPI for "KPI Summary 2" in custom setting 
        if(!lstZoneKPISummary2Config.IsEmpty()){
            showKPISummary2=true;
        }
        
        // check if there is any corresponding KPI for "KPI Summary 3" in custom setting
        if(!lstZoneKPISummary3Config.IsEmpty()){
            showKPISummary3=true;
        }               
        
        Map<String,String> mapKPIName= new Map<String, String>();
        Map<String,string> mapChlidZoneKPIConfig= new Map<String, string>();
        
        //For loop to create Map with Name of KPI, Used to check for the Child KPIS
        for(ZM_ZoneKPIConfig__c objTempZMZoneKPIConfig: lstZoneKPISUmmary1Config){
            mapKPIName.put(objTempZMZoneKPIConfig.Name,objTempZMZoneKPIConfig.Name);
        }
        
        //For loop to create  List of Wrapper used in the Repeat tag
        for(ZM_ZoneKPIConfig__c objZMZoneKPIConfig: lstZoneKPISUmmary1Config){
            
            //Check for the KPI is Child KPI         
            if(mapChlidZoneKPIConfig.get(objZMZoneKPIConfig.Name)==null){
                strWCustomLabel = objZMZoneKPIConfig.CustomLabel__c;
                strWCSSClass='txtAlgnLt';
                List<WrapperZoneKPIElement> lstWZoneKPIElement= new List<WrapperZoneKPIElement>();
                
                //Loop for getting the values for the Sales org summary object by passing the Field API name which were in the Custom Setting 
                for(Sales_Org_Summary__c objSalesOrgSummary: lstSalesOrgSummary){
                    Double dbWPlanField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.PlanField__c));
                    Double dbWActualField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.ActualField__c));
                    Double dbWSPPYField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.SPPYField__c));
                    Double dbWVarianceField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.VarianceField__c));
                    
                    // T-211281 : Added by Parul Gupta - To use new field on market (and the KPIConfig) BEGIN
                 
                    if(currMarket.KPI_Measurement_Field__c != null 
                    && currMarket.KPI_Measurement_Field__c == ALMConstants.KPI_MEASUREMENT_DIFFERENCE
                    && objZMZoneKPIConfig.DifferenceField__c != null){
                    	  
                     system.debug('===objSalesOrgSummary.get(objZMZoneKPIConfig.DifferenceField__c='+objSalesOrgSummary.get(objZMZoneKPIConfig.DifferenceField__c));
                    	dbWVarianceField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.DifferenceField__c));
                    }
                    // T-211281 : Added by Parul Gupta - To use new field on market (and the KPIConfig) END
                    
                    WrapperZoneKPIElement objWZoneKPIElement= new WrapperZoneKPIElement(dbWPlanField,dbWActualField,dbWSPPYField,dbWVarianceField);
                    lstWZoneKPIElement.add(objWZoneKPIElement);
                }
                
                WrapperZoneKPIDetail objWZoneKPIConfig = new WrapperZoneKPIDetail(strWCustomLabel,lstWZoneKPIElement,strWCSSClass);
                lstWrapperZoneKPIDetail.add(objWZoneKPIConfig);
                
                //Getting the list Child KIPS 
                List<ZM_ZoneKPIConfig__c> lstChlidZoneKPIConfig=[Select CustomLabel__c,VarianceField__c, DifferenceField__c, SPPYField__c,RankField__c,ActualField__c,PlanSPPYField__c, PlanField__c, Parent__c,Name From ZM_ZoneKPIConfig__c where Parent__c =:objZMZoneKPIConfig.Name];
                
                for(ZM_ZoneKPIConfig__c objTempZMZoneKPIConfig: lstChlidZoneKPIConfig){
                    
                    //Checking the Child KIPs were exist in the Main list
                    if(mapKPIName.get(objTempZMZoneKPIConfig.Name)!=null){
                        mapChlidZoneKPIConfig.put(objTempZMZoneKPIConfig.Name,objTempZMZoneKPIConfig.Name);
                        strWCustomLabel = objTempZMZoneKPIConfig.CustomLabel__c;
                        strWCSSClass='txtIndnt txtAlgnLt';
                        List<WrapperZoneKPIElement> lstChlidWZoneKPIElement= new List<WrapperZoneKPIElement>();
                        
                        //Loop for getting the values for the Sales org summary object by passing the Field API name which were in the Custom Setting
                        for(Sales_Org_Summary__c objSalesOrgSummary: lstSalesOrgSummary){
                            Double dbWPlanField = Double.valueOf(objSalesOrgSummary.get(objTempZMZoneKPIConfig.PlanField__c));
                            Double dbWActualField = Double.valueOf(objSalesOrgSummary.get(objTempZMZoneKPIConfig.ActualField__c));
                            Double dbWSPPYField = Double.valueOf(objSalesOrgSummary.get(objTempZMZoneKPIConfig.SPPYField__c));
                            Double dbWVarianceField = Double.valueOf(objSalesOrgSummary.get(objTempZMZoneKPIConfig.VarianceField__c));
                          
                            // T-211281 : Added by Parul Gupta - To use new field on market (and the KPIConfig) BEGIN
                            if(currMarket.KPI_Measurement_Field__c != null
                            && currMarket.KPI_Measurement_Field__c == ALMConstants.KPI_MEASUREMENT_DIFFERENCE){
                            	dbWVarianceField = Double.valueOf(objSalesOrgSummary.get(objTempZMZoneKPIConfig.DifferenceField__c));
                            }
                            // T-211281 : Added by Parul Gupta - To use new field on market (and the KPIConfig) END
                            
                            WrapperZoneKPIElement objWZoneKPIElement= new WrapperZoneKPIElement(dbWPlanField,dbWActualField,dbWSPPYField,dbWVarianceField);
                            lstChlidWZoneKPIElement.add(objWZoneKPIElement);
                        }
                        
                        WrapperZoneKPIDetail objChildWZoneKPIDetail = new WrapperZoneKPIDetail(strWCustomLabel,lstChlidWZoneKPIElement,strWCSSClass);
                        lstWrapperZoneKPIDetail.add(objChildWZoneKPIDetail);    
                    }
                }
            }
        }
    }
    
    public void populateWrapperSalesLeadershipData(Sales_Org_Summary__c objSalesOrgSummary){
    	
    	try
    	{
        string strWCustomLabel;
        string strWCSSClass;
        ZM_UtilityClass objTemputilityclass= new ZM_UtilityClass();
        objTemputilityclass.SetVariable();
        
        Double dbCountBaseAtRisk;
        Double dbCountBaseAtRisk2;
        
        ZM_Utility_KPIConfig objZMKPIConfigUtil= new ZM_Utility_KPIConfig();
        //Calling the ZM utility KPI Config Class  , Passing the Market object record Id and the Class type passing 
        // the utility function  getZoneKPIConfig  return  list Custom setting which contains KPI fields
        List<ZM_ZoneKPIConfig__c> lstZoneKPISummary2Config= objZMKPIConfigUtil.getZoneKPIConfig(objTemputilityclass.strMarketRecordId,'KPI Summary 2');
        List<ZM_ZoneKPIConfig__c> lstZoneKPISummary2Config_TL= objZMKPIConfigUtil.getZoneKPIConfig(objTemputilityclass.strMarketRecordId,'TL');
        
        System.debug('\n lstZoneKPISummary2Config SIZE ------->'+lstZoneKPISummary2Config.size());
        
        
        //For loop to create List of Wrapper used in the Repeat tag - For Aggregation
        for(ZM_ZoneKPIConfig__c objZMZoneKPIConfig: lstZoneKPISummary2Config){
                     
            dbCountBaseAtRisk = null; 
            dbCountBaseAtRisk2 = null;
            
            strWCustomLabel = objZMZoneKPIConfig.CustomLabel__c;
            strWCSSClass='txtAlgnLt';
            Double dbWCount = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.Count__c)).round();
            Double dbWCountAtRiskField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.CountAtRiskField__c)).round();
            Double dbWCountOfRisingStarsField = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.CountOfRisingStarsField__c)).round();
            Double dbWCountAtRisk2 = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.CountAtRisk2__c)).round();
            
            if(objZMZoneKPIConfig.BaseAtRisk__c != null && !objZMZoneKPIConfig.BaseAtRisk__c.equals('') && (objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk__c) != null))
            	dbCountBaseAtRisk = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk__c)).round();
            
            if(objZMZoneKPIConfig.BaseAtRisk2__c != null && !objZMZoneKPIConfig.BaseAtRisk2__c.equals('') && (objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk2__c) != null))
            	dbCountBaseAtRisk2 = Double.valueOf(objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk2__c)).round();            
            
            WrapperSalesLeadership objWSalesLeadership = new WrapperSalesLeadership(strWCustomLabel,dbWCount,dbWCountAtRiskField,dbWCountOfRisingStarsField,dbWCountAtRisk2,strWCSSClass,dbCountBaseAtRisk,dbCountBaseAtRisk2);
            lstWrapperSalesLeadership.add(objWSalesLeadership);
        }
        
        //For loop to create List of Wrapper used in the Repeat tag - For TL
        zoneKPIConfigTLSize = lstZoneKPISummary2Config_TL.size();
        System.debug('\n zoneKPIConfigTLSize ------->'+zoneKPIConfigTLSize);
        for(ZM_ZoneKPIConfig__c objZMZoneKPIConfig: lstZoneKPISummary2Config_TL){
        	dbCountBaseAtRisk = null; 
            dbCountBaseAtRisk2 = null;
        	//strWCustomLabel = objZMZoneKPIConfig.CustomLabel__c;
        	strWCustomLabel = System.Label.TL;
            strWCSSClass='txtAlgnLt';
            Double dbWCount = getdouble(objSalesOrgSummary.get(objZMZoneKPIConfig.Count__c)).round();
            Double dbWCountAtRiskField = getdouble(objSalesOrgSummary.get(objZMZoneKPIConfig.CountAtRiskField__c)).round();
            Double dbWCountOfRisingStarsField = getdouble(objSalesOrgSummary.get(objZMZoneKPIConfig.CountOfRisingStarsField__c)).round();
            Double dbWCountAtRisk2 = getdouble(objSalesOrgSummary.get(objZMZoneKPIConfig.CountAtRisk2__c)).round();            

			if(objZMZoneKPIConfig.BaseAtRisk__c != null && !objZMZoneKPIConfig.BaseAtRisk__c.equals('') && (objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk__c) != null))
            	dbCountBaseAtRisk = getdouble(objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk__c)).round();
            
            if(objZMZoneKPIConfig.BaseAtRisk2__c != null && !objZMZoneKPIConfig.BaseAtRisk2__c.equals('') && (objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk2__c) != null))
            	dbCountBaseAtRisk2 = getdouble(objSalesOrgSummary.get(objZMZoneKPIConfig.BaseAtRisk2__c)).round();            
            
            WrapperSalesLeadership objWSalesLeadership = new WrapperSalesLeadership(strWCustomLabel,dbWCount,dbWCountAtRiskField,dbWCountOfRisingStarsField,dbWCountAtRisk2,strWCSSClass,dbCountBaseAtRisk,dbCountBaseAtRisk2);        	
        	lstWrapperSalesLeadership_TL.add(objWSalesLeadership);
        }
        
        
        //For loop to create List of Wrapper used in the Repeat tag - For PM
        Integer count = 0;
        for(count = 0; count<zoneKPIConfigTLSize; count++){
        	dbCountBaseAtRisk = null; 
            dbCountBaseAtRisk2 = null;
        	//strWCustomLabel = objZMZoneKPIConfig.CustomLabel__c;
        	strWCustomLabel = System.Label.PM;
            strWCSSClass='txtAlgnLt';
            /* Commented by Milon 8/29
            Double dbWCount = getdouble(lstWrapperSalesLeadership.get(count).dbCount) - getdouble(lstWrapperSalesLeadership_TL.get(count).dbCount);
            Double dbWCountAtRiskField = getdouble(lstWrapperSalesLeadership.get(count).dbCountAtRiskField) - getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountAtRiskField);
            Double dbWCountOfRisingStarsField = getdouble(lstWrapperSalesLeadership.get(count).dbCountOfRisingStarsField) - getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountOfRisingStarsField);
            Double dbWCountAtRisk2 = getdouble(lstWrapperSalesLeadership.get(count).dbCountAtRisk2) - getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountAtRisk2);
            if(lstWrapperSalesLeadership.get(count).dbCountBaseAtRiskField != null && lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRiskField != null)
            	dbCountBaseAtRisk = getdouble(lstWrapperSalesLeadership.get(count).dbCountBaseAtRiskField) - getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRiskField);
            
            if(lstWrapperSalesLeadership.get(count).dbCountBaseAtRisk2 != null && lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRisk2 != null)
            	dbCountBaseAtRisk2 = getdouble(lstWrapperSalesLeadership.get(count).dbCountBaseAtRisk2) - getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRisk2);
            */
            //As CDW team populated lstWrapperSalesLeadership as PM so now we have to calcuate TOTAL = PM + TL
            //We are writing the below login based on above impression
            WrapperSalesLeadership templstWrapperSalesLeadership = lstWrapperSalesLeadership.get(count);
            Double dbWCount = getdouble(templstWrapperSalesLeadership.dbCount).round();
            templstWrapperSalesLeadership.dbCount = String.valueOf((dbWCount + getdouble(lstWrapperSalesLeadership_TL.get(count).dbCount)).round());
            
            Double dbWCountAtRiskField = getdouble(templstWrapperSalesLeadership.dbCountAtRiskField).round(); 
            templstWrapperSalesLeadership.dbCountAtRiskField = String.valueOf((dbWCountAtRiskField +  getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountAtRiskField)).round());
            Double dbWCountOfRisingStarsField = getdouble(templstWrapperSalesLeadership.dbCountOfRisingStarsField).round();
            templstWrapperSalesLeadership.dbCountOfRisingStarsField = String.valueOf((dbWCountOfRisingStarsField + getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountOfRisingStarsField)).round());
            Double dbWCountAtRisk2 = getdouble(templstWrapperSalesLeadership.dbCountAtRisk2).round();
            templstWrapperSalesLeadership.dbCountAtRisk2 = String.valueOf((dbWCountAtRisk2 + getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountAtRisk2)).round());
            if(templstWrapperSalesLeadership.dbCountBaseAtRiskField != null && lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRiskField != null){
            	dbCountBaseAtRisk = Double.valueOf(templstWrapperSalesLeadership.dbCountBaseAtRiskField).round();
            	templstWrapperSalesLeadership.dbCountBaseAtRiskField = String.valueOf((dbCountBaseAtRisk +  getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRiskField)).round());
            	System.debug('templstWrapperSalesLeadership.dbCountBaseAtRiskField :'+lstWrapperSalesLeadership.get(count).dbCountBaseAtRiskField);
            	System.debug('templstWrapperSalesLeadership.dbCountBaseAtRiskField :'+templstWrapperSalesLeadership.dbCountBaseAtRiskField);
            }
            
            if(templstWrapperSalesLeadership.dbCountBaseAtRisk2 != null && lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRisk2 != null){
            	dbCountBaseAtRisk2 = getdouble(templstWrapperSalesLeadership.dbCountBaseAtRisk2).round();
            	templstWrapperSalesLeadership.dbCountBaseAtRisk2 = String.valueOf((dbCountBaseAtRisk2 + getdouble(lstWrapperSalesLeadership_TL.get(count).dbCountBaseAtRisk2)).round());
            }
            lstWrapperSalesLeadership.set(count,templstWrapperSalesLeadership);
            
           	WrapperSalesLeadership objWSalesLeadership = new WrapperSalesLeadership(strWCustomLabel,dbWCount,dbWCountAtRiskField,dbWCountOfRisingStarsField,dbWCountAtRisk2,strWCSSClass,dbCountBaseAtRisk,dbCountBaseAtRisk2);        	
        	lstWrapperSalesLeadership_PM.add(objWSalesLeadership);    
        }
        
        }
        catch(Exception e){
        	System.debug('Exception At--->'+e.getLineNumber());
        }
        
    }
    
    	//getting double value after null check:swarnava
    	Double getdouble(Object st)
    	{
    	if(st==null)
    		return 0;
    	else 
    		return Double.valueOf((String.valueOf(st)).replace(',', ''));	
    		
    	}
   
    /********** WRAPPER CLASSES TO HOLD THE DATA FOR "KPI SUMMARY 1" TABLE ************/
    // Wrapper used in the repeat tag
    public Class WrapperZoneKPIDetail {
        public string strCustomLabel{get;set;}
        public string strCSSClass{get;set;}
        public List<WrapperZoneKPIElement> lstWZoneKPIElement{get;set;}
        
        public WrapperZoneKPIDetail (string strTempCustomLabel,List<WrapperZoneKPIElement> lstTempWZoneKPIConfigField, string strTempCSSClass){
            strCustomLabel = strTempCustomLabel;
            lstWZoneKPIElement = lstTempWZoneKPIConfigField;
            strCSSClass = strTempCSSClass;
        }
    }
    
    // Wrapper Class used in the  Inner repeat tag
    // Inner class to store data for one KPI for one campaign (current/last/next) of "KPI Summary 1"
    public Class WrapperZoneKPIElement {
        public String dbPlanField{get;set;}
        public String dbActualField{get;set;}
        public String dbSPPYField{get;set;}
        public String dbVarianceField{get;set;}
        
        public WrapperZoneKPIElement(Double dbTempPlanField, Double dbTempActualField, Double dbTempSPPYField, Double dbTempVarianceField){
            dbPlanField = dbTempPlanField ==null?'': dbTempPlanField.round().format();
            dbPlanField = dbPlanField.indexOf('.') > -1 ? dbPlanField.substring(0, dbPlanField.indexOf('.')) : dbPlanField;
            
            dbActualField = dbTempActualField ==null?'': dbTempActualField.round().format();
            dbActualField = dbActualField.indexOf('.') > -1 ? dbActualField.substring(0, dbActualField.indexOf('.')) : dbActualField;
            
            dbSPPYField =  dbTempSPPYField ==null?'': dbTempSPPYField.round().format();
            dbSPPYField = dbSPPYField.indexOf('.') > -1 ? dbSPPYField.substring(0, dbSPPYField.indexOf('.')) : dbSPPYField;
            
            dbVarianceField = dbTempVarianceField  ==null?'': dbTempVarianceField.round().format();
            dbVarianceField = dbVarianceField.indexOf('.') > -1 ? dbVarianceField.substring(0, dbVarianceField.indexOf('.')) : dbVarianceField;
            
        }
    }
    /********************************************************************************/
    
    /********** WRAPPER CLASSES TO HOLD THE DATA FOR "KPI SUMMARY 2" (Sales Leadership) TABLE ************/
    // Wrapper used in the Repeat tag
    public Class WrapperSalesLeadership {
        public string strCustomLabel{get;set;}
        public string strCSSClass{get;set;}
        public string dbCount{get;set;}
        public string dbCountAtRiskField{get;set;}
        public string dbCountOfRisingStarsField{get;set;}
        public string dbCountAtRisk2{get;set;}
        public string dbCountBaseAtRiskField {get;set;}
	    public string dbCountBaseAtRisk2 {get;set;}
       // public WrapperSalesLeadership (string strTempCustomLabel,Double dbTempCount, Double dbTempCountAtRiskField, Double dbTempCountOfRisingStarsField, Double dbTempCountAtRisk2, string strTempCSSClass){
       public WrapperSalesLeadership (string strTempCustomLabel,Double dbTempCount, Double dbTempCountAtRiskField, Double dbTempCountOfRisingStarsField, Double dbTempCountAtRisk2, string strTempCSSClass, Double dbBaseAtRisk, Double dbBaseAtRisk2){	       	
            strCustomLabel = strTempCustomLabel;
            //dbCount = dbTempCount ==null?'': dbTempCount.format();
            dbCount = dbTempCount ==null?'0': dbTempCount.round().format();
            
            //dbCountAtRiskField = dbTempCountAtRiskField==null?'': dbTempCountAtRiskField.format();
            dbCountAtRiskField = dbTempCountAtRiskField==null?'0': dbTempCountAtRiskField.round().format();
            
            //dbCountOfRisingStarsField = dbTempCountOfRisingStarsField==null?'': dbTempCountOfRisingStarsField.format();
            dbCountOfRisingStarsField = dbTempCountOfRisingStarsField==null?'0': dbTempCountOfRisingStarsField.round().format();
            
            //dbCountAtRisk2 = dbTempCountAtRisk2==null?'':dbTempCountAtRisk2.format();
            dbCountAtRisk2 = dbTempCountAtRisk2==null?'0':dbTempCountAtRisk2.round().format();
            
            dbCountBaseAtRiskField = dbBaseAtRisk==null?'0':dbBaseAtRisk.round().format();
            
        	dbCountBaseAtRisk2 = dbBaseAtRisk2==null?'0':dbBaseAtRisk2.round().format();
        	
            strCSSClass=strTempCSSClass;
        }
    }
    /********************************************************************************/
    
    /********** BASE QUERY WITH ALL THE FIELDS TO BE FETCHED FROM  "SalesOrgSummary" TABLE************/
    String BASE_SOQL = 'select '+ ZM_UtilityClass.getSalesOrgSummaryFields() + ' from Sales_Org_Summary__c ';
                                
                                
    
   /**************************************************************************
                           Test Method
    **************************************************************************/
     // Commented out by Parul Gupta Begin
     /*@isTest(SeeAllData=true)
    static void Test_ZM_KPIPerformanceController() {
        // TO DO: implement unit test
        
        
        //Market__c objMarket = new Market__c(Market_Id__c='1', name = 'Philippines', Hide_Next_Campaign__c = true);
       // insert objMarket;
        
        Market__c mark=new Market__c(Market_Id__c='DE', CMPGN_NR__c='201302', PREV_1_CMPGN_NR__c='201301', NEXT_1_CMPGN_NR__c='201303');
        insert mark;
        
        ZM_MarketZoneKPIConfig__c objZM_MarketZoneKPIConfig = new ZM_MarketZoneKPIConfig__c(ZM_ZoneKPIConfigName__c = 'APPT', SortOrder__c = '1', Name = 'Config 1', Market__c = mark.id, MarketUsesDefault__c = false, MarketDefaultPlan__c = 123, Context__c =  'Compass; KPI Summary 1');
        ZM_MarketZoneKPIConfig__c objZM_MarketZoneKPIConfig1 = new ZM_MarketZoneKPIConfig__c(ZM_ZoneKPIConfigName__c = 'APPT1', SortOrder__c = '2', Name = 'Config 2', Market__c = mark.id, MarketUsesDefault__c = false, MarketDefaultPlan__c = 123, Context__c =  'Compass; KPI Summary 1');
        ZM_MarketZoneKPIConfig__c objZM_MarketZoneKPIConfig2 = new ZM_MarketZoneKPIConfig__c(ZM_ZoneKPIConfigName__c = 'APPT2', SortOrder__c = '1', Name = 'Config 3', Market__c = mark.id, MarketUsesDefault__c = false, MarketDefaultPlan__c = 123, Context__c =  'Compass; KPI Summary 2');
        ZM_MarketZoneKPIConfig__c objZM_MarketZoneKPIConfig3 = new ZM_MarketZoneKPIConfig__c(ZM_ZoneKPIConfigName__c = 'APPT3', SortOrder__c = '2', Name = 'Config 4', Market__c = mark.id, MarketUsesDefault__c = false, MarketDefaultPlan__c = 123, Context__c =  'Compass; KPI Summary 2');
        insert objZM_MarketZoneKPIConfig;
        insert objZM_MarketZoneKPIConfig1;
        insert objZM_MarketZoneKPIConfig2;
        insert objZM_MarketZoneKPIConfig3;
        
        Profile zoneManagerProfile = [select id from profile where name ='Avon Mkt 62 Zone Manager'];
        Profile divisionManagerProfile = [select id from profile where name ='Avon Mkt 62 Division Manager'];
        
        //User zoneUser = [select id from user where profileId=:p.id and MRKT_ID__c='62' limit 1];
        //User divisionUser = [select id from user where profileId=:p.id and MRKT_ID__c='62' and active = true limit 1];
       
        UserRole u = new UserRole();
        u.Name = 'Market DE (Demo)';
        insert u;
        UserRole u1 = new UserRole();
        u1.Name = 'TestDivision';
        u1.ParentRoleId = u.Id;
        insert u1;
        UserRole u2 = new UserRole();
        u2.Name = 'Zone DEZ01 Manager';
        u2.ParentRoleId = u1.id;
        insert u2;
        UserRole u3 = new UserRole();
        u3.Name = 'Zone DEZ01 Owner';
        u3.ParentRoleId = u2.id;
        insert u3;
        User donotUser= new User(alias = 'dtest1',email = 'dtestuser@test.com',GI3_Email__c = 'dtestuser@test.com', emailencodingkey='UTF-8',lastname = 'User',languagelocalekey='en_US',localesidkey='en_US',UserRoleId=u3.id,profileid = zoneManagerProfile.id,timezonesidkey='America/Chicago',username='dtestuser@testmagic.com1',MRKT_ID__c='DE',DFALT_ZONE_CD__c='DEZ01',DFALT_DIV_NM__c ='TestDivision',ACCT_NR__c ='01');
        insert donotUser;
        User zoneUser= new User(alias = 'test1',email = 'testuser@test.com',GI3_Email__c = 'testuser@test.com', emailencodingkey='UTF-8',lastname = 'User',languagelocalekey='en_US',localesidkey='en_US',UserRoleId=u2.id,profileid = zoneManagerProfile.id,timezonesidkey='America/Chicago',username='testuser@testmagic.com1',MRKT_ID__c='DE',DFALT_ZONE_CD__c='DEZ01',DFALT_DIV_NM__c ='TestDivision',ACCT_NR__c ='02');
        insert zoneUser;
        User divisionUser= new User(alias = 'test2',email = 'testuser@test.com',GI3_Email__c = 'testuser@test.com', emailencodingkey='UTF-8',lastname = 'User',languagelocalekey='en_US',localesidkey='en_US',UserRoleId=u1.id,profileid = divisionManagerProfile.id,timezonesidkey='America/Chicago',username='testuser@testmagic.com2',MRKT_ID__c='DE',DFALT_ZONE_CD__c='DEZ01',DFALT_DIV_NM__c ='TestDivision',ACCT_NR__c ='03');
        insert divisionUser;
        //insert new List<User>{zoneUser,divisionUser};
        
      
        
        
        System.debug('-- At Test strMarketRecordId --'+mark.Id);		
		System.debug('--At Test  Userinfo.getUserId()  --'+zoneUser.Id);
        Sales_Org_Summary__c objSalesOrg = New Sales_Org_Summary__c ( ZONE_MGR__c=zoneUser.Id,MRKT_KEY__c=mark.Id, SLS_ORG_SUMRY_KEY__c='DE201303ZDEZ01',OPERTNL_CMPGN_NR__c ='201303',SLS_ORG_LVL_DESC_TXT__c='Z',ACTV_REP_CNT__c=300, UPR_CNT__c=8, SLS_ORG_DESC_TXT__c='DEZ01',  TITLD_STF_CNT__c=8,  RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, TITL_0_STF_CNT__c=8,  UPR_DIV_RNK_CNT__c=100, RNSTMT_DIV_RNK__c=100, UPR_PLAN_SPPY_CNT__c=9, RMOVL_PLAN_CNT__c=6, LOA_1_6_NET_SLS_DIV_RNK__c=100, RTURN_NET_SLS_AMT__c=1500.00, RMOVL_SPPY_CNT__c=8, LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00, RMOVL_PLAN_SPPY_CNT__c=8,    NET_SLS_SPPY_AMT__c=1555000.00, LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, RNSTMT_PLAN_CNT__c=5, RMOVL_CNT__c=9, TITLD_STF_DIV_RNK__c=100,   RNSTMT_CNT__c=2,   ACTV_REP_PLAN_SPPY_CNT__c=1500, NET_SLS_DIV_RNK__c=100, TITL_0_STF_PLAN_SPPY_CNT__c=9,  APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, TITL_0_STF_DIV_RNK__c=100, LOA_1_6_NET_SLS_AMT__c=30000.00,   UPR_PLAN_CNT__c=9, FLD_SLS_CMPGN_NR__c='201303', ACTV_REP_DIV_RNK__c=100, RNSTMT_SPPY_CNT__c=7, LOA1_NET_SLS_DIV_RNK__c=100, ACTV_REP_SPPY_CNT__c=1600, LOA1_NET_SLS_AMT__c=1000.00,  RMOVL_DIV_RNK__c=100, LOA1_NET_SLS_SPPY_AMT__c=1000.00, NET_SLS_PLAN_SPPY_AMT__c=1555000.00, LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, TITLD_STF_SPPY_CNT__c=9, TITL_0_STF_SPPY_CNT__c=9,  APPT_DIV_RNK__c=100, UPR_SPPY_CNT__c=9, APPT_PLAN_CNT__c=12, LOA_1_6_NET_SLS_PLAN_AMT__c=322000.00, RTURN_NET_SLS_DIV_RNK__c=100, Analysis_Done__c=false, RTURN_NET_SLS_SPPY_AMT__c=1550.00, APPT_PLAN_SPPY_CNT__c=15, NET_SLS_PLAN_AMT__c=500000.00,  RNSTMT_PLAN_SPPY_CNT__c=7, APPT_SPPY_CNT__c=15, ACTV_REP_PLAN_CNT__c=200, LOA1_NET_SLS_PLAN_AMT__c=100000.00, TITLD_STF_PLAN_SPPY_CNT__c=9, RTURN_NET_SLS_PLAN_AMT__c=1500.00, TITLD_STF_PLAN_CNT__c=9, TITL_0_TL_STF_CNT__c =1,TITL_0_STF_TAR_LAST_CMPGN_CNT__c=10 ); 
        //insert objSalesOrg;
        Sales_Org_Summary__c objSalesOrg1 = New Sales_Org_Summary__c (ZONE_MGR__c=zoneUser.Id,MRKT_KEY__c=mark.Id,SLS_ORG_SUMRY_KEY__c='DE201302ZDEZ01',OPERTNL_CMPGN_NR__c ='201302',SLS_ORG_LVL_DESC_TXT__c='Z',ACTV_REP_CNT__c=1500, UPR_CNT__c=8,SLS_ORG_DESC_TXT__c='DEZ01', TITLD_STF_CNT__c=8, RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, TITL_0_STF_CNT__c=8,  UPR_DIV_RNK_CNT__c=100, RNSTMT_DIV_RNK__c=100, UPR_PLAN_SPPY_CNT__c=9, RMOVL_PLAN_CNT__c=6, LOA_1_6_NET_SLS_DIV_RNK__c=100, RTURN_NET_SLS_AMT__c=1500.00, RMOVL_SPPY_CNT__c=8, LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00,RMOVL_PLAN_SPPY_CNT__c=8,  NET_SLS_SPPY_AMT__c=1555000.00, LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, RNSTMT_PLAN_CNT__c=5, RMOVL_CNT__c=9, TITLD_STF_DIV_RNK__c=100, RNSTMT_CNT__c=2,  ACTV_REP_PLAN_SPPY_CNT__c=1500, NET_SLS_DIV_RNK__c=100, TITL_0_STF_PLAN_SPPY_CNT__c=9,APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, TITL_0_STF_DIV_RNK__c=100, LOA_1_6_NET_SLS_AMT__c=30000.00,  UPR_PLAN_CNT__c=9, FLD_SLS_CMPGN_NR__c='201302', ACTV_REP_DIV_RNK__c=100, RNSTMT_SPPY_CNT__c=7, LOA1_NET_SLS_DIV_RNK__c=100, ACTV_REP_SPPY_CNT__c=1600, LOA1_NET_SLS_AMT__c=1000.00, RMOVL_DIV_RNK__c=100, LOA1_NET_SLS_SPPY_AMT__c=1000.00, LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, TITLD_STF_SPPY_CNT__c=9, TITL_0_STF_SPPY_CNT__c=9, NET_SLS_PLAN_SPPY_AMT__c=1555000.00, APPT_DIV_RNK__c=100, UPR_SPPY_CNT__c=9, APPT_PLAN_CNT__c=12, LOA_1_6_NET_SLS_PLAN_AMT__c=322000.00, RTURN_NET_SLS_DIV_RNK__c=100, Analysis_Done__c=false, RTURN_NET_SLS_SPPY_AMT__c=1550.00, APPT_PLAN_SPPY_CNT__c=15, NET_SLS_PLAN_AMT__c=1322000.00,  RNSTMT_PLAN_SPPY_CNT__c=7, APPT_SPPY_CNT__c=15, ACTV_REP_PLAN_CNT__c=1546, LOA1_NET_SLS_PLAN_AMT__c=100000.00, TITLD_STF_PLAN_SPPY_CNT__c=9, RTURN_NET_SLS_PLAN_AMT__c=1500.00, TITLD_STF_PLAN_CNT__c=9, TITL_0_TL_STF_CNT__c = 1,TITL_0_STF_TAR_LAST_CMPGN_CNT__c=10); 
        //insert objSalesOrg1;
        Sales_Org_Summary__c objSalesOrg2 = New Sales_Org_Summary__c (ZONE_MGR__c=zoneUser.Id,MRKT_KEY__c=mark.Id,SLS_ORG_SUMRY_KEY__c='DE201301ZDEZ01',OPERTNL_CMPGN_NR__c ='201301',SLS_ORG_LVL_DESC_TXT__c='Z',ACTV_REP_CNT__c=1500, UPR_CNT__c=8, SLS_ORG_DESC_TXT__c='DEZ01',  TITLD_STF_CNT__c=8, RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, TITL_0_STF_CNT__c=8,  UPR_DIV_RNK_CNT__c=100, RNSTMT_DIV_RNK__c=100, UPR_PLAN_SPPY_CNT__c=9, RMOVL_PLAN_CNT__c=6, LOA_1_6_NET_SLS_DIV_RNK__c=100, RTURN_NET_SLS_AMT__c=1500.00, RMOVL_SPPY_CNT__c=8, LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00, RMOVL_PLAN_SPPY_CNT__c=8,  NET_SLS_SPPY_AMT__c=1555000.00,  LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, RNSTMT_PLAN_CNT__c=5, RMOVL_CNT__c=9, TITLD_STF_DIV_RNK__c=100, RNSTMT_CNT__c=2,  ACTV_REP_PLAN_SPPY_CNT__c=1500, NET_SLS_DIV_RNK__c=100, TITL_0_STF_PLAN_SPPY_CNT__c=9,APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, TITL_0_STF_DIV_RNK__c=100, LOA_1_6_NET_SLS_AMT__c=30000.00,  UPR_PLAN_CNT__c=9, FLD_SLS_CMPGN_NR__c='201301', ACTV_REP_DIV_RNK__c=100, RNSTMT_SPPY_CNT__c=7, LOA1_NET_SLS_DIV_RNK__c=100, ACTV_REP_SPPY_CNT__c=1600, LOA1_NET_SLS_AMT__c=1000.00, RMOVL_DIV_RNK__c=100, LOA1_NET_SLS_SPPY_AMT__c=1000.00, LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, TITLD_STF_SPPY_CNT__c=9, TITL_0_STF_SPPY_CNT__c=9, NET_SLS_PLAN_SPPY_AMT__c=1555000.00, APPT_DIV_RNK__c=100, UPR_SPPY_CNT__c=9, APPT_PLAN_CNT__c=12, LOA_1_6_NET_SLS_PLAN_AMT__c=322003.00, RTURN_NET_SLS_DIV_RNK__c=100, Analysis_Done__c=false, RTURN_NET_SLS_SPPY_AMT__c=1550.00, APPT_PLAN_SPPY_CNT__c=15, NET_SLS_PLAN_AMT__c=1322001.00,  RNSTMT_PLAN_SPPY_CNT__c=7, APPT_SPPY_CNT__c=15, ACTV_REP_PLAN_CNT__c=1541, LOA1_NET_SLS_PLAN_AMT__c=100000.00, TITLD_STF_PLAN_SPPY_CNT__c=9, RTURN_NET_SLS_PLAN_AMT__c=1503.00, TITLD_STF_PLAN_CNT__c=9, TITL_0_TL_STF_CNT__c = 1,TITL_0_STF_TAR_LAST_CMPGN_CNT__c=10); 
        //insert objSalesOrg2;
        List<Sales_Org_Summary__c> lstSalesOrgSummary = new List<Sales_Org_Summary__c>{objSalesOrg,objSalesOrg1,objSalesOrg2};
        insert lstSalesOrgSummary;
        
        System.debug('lstSalesOrgSummary --'+lstSalesOrgSummary);
        
        ZM_MarketZoneKPIConfig__c ZMMarketConfig= new ZM_MarketZoneKPIConfig__c(Name='Config 1', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT0', SortOrder__c='1', Context__c='KPI Summary 1;Compass');
        insert ZMMarketConfig;
        ZM_MarketZoneKPIConfig__c ZMMarketConfig1= new ZM_MarketZoneKPIConfig__c(Name='Config 2', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT1', SortOrder__c='2', Context__c='KPI Summary 1;Compass;');
        insert ZMMarketConfig1;
        ZM_MarketZoneKPIConfig__c ZMMarketConfig2= new ZM_MarketZoneKPIConfig__c(Name='Config 3', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT2', SortOrder__c='3', Context__c='KPI Summary 1;Compass;TL;');
        insert ZMMarketConfig2;
        
        ZM_MarketZoneKPIConfig__c ZMMarketConfig3= new ZM_MarketZoneKPIConfig__c(Name='Config 4', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT3', SortOrder__c='1', Context__c='KPI Summary 2;Compass');
        insert ZMMarketConfig3;
        ZM_MarketZoneKPIConfig__c ZMMarketConfig4= new ZM_MarketZoneKPIConfig__c(Name='Config 5', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT4', SortOrder__c='2', Context__c='KPI Summary 2;Compass;');
        insert ZMMarketConfig4;
        ZM_MarketZoneKPIConfig__c ZMMarketConfig5= new ZM_MarketZoneKPIConfig__c(Name='Config 6', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT5', SortOrder__c='3', Context__c='KPI Summary 2;Compass;TL;');
        insert ZMMarketConfig5;
        
        ZM_ZoneKPIConfig__c ZMZoneKPIConfig= new ZM_ZoneKPIConfig__c(Count__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT0', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c'); 
        insert ZMZoneKPIConfig;
         ZM_ZoneKPIConfig__c ZMZoneKPIConfig1= new ZM_ZoneKPIConfig__c(Count__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT1', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c', Parent__c='APPT0'); 
        insert ZMZoneKPIConfig1;
         ZM_ZoneKPIConfig__c ZMZoneKPIConfig2= new ZM_ZoneKPIConfig__c(BaseAtRisk2__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',BaseAtRisk__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Count__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT2', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c', Parent__c='APPT1',CountAtRisk2__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',ForecastGoalField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',ForecastInput__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Suggested_Activities__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c'); 
        insert ZMZoneKPIConfig2;
        
        
        ZM_ZoneKPIConfig__c ZMZoneKPIConfig3= new ZM_ZoneKPIConfig__c(Count__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT3', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c'); 
        insert ZMZoneKPIConfig3;
         ZM_ZoneKPIConfig__c ZMZoneKPIConfig4= new ZM_ZoneKPIConfig__c(Count__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT4', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c', Parent__c='APPT3'); 
        insert ZMZoneKPIConfig4;
         ZM_ZoneKPIConfig__c ZMZoneKPIConfig5= new ZM_ZoneKPIConfig__c(BaseAtRisk2__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',BaseAtRisk__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Count__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT5', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c', Parent__c='APPT4',CountAtRisk2__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',ForecastGoalField__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',ForecastInput__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c',Suggested_Activities__c='TITL_0_STF_TAR_LAST_CMPGN_CNT__c'); 
        insert ZMZoneKPIConfig5;
        Test.StartTest();
        
        System.runAs(zoneUser) {
            ApexPages.StandardController objController = new ApexPages.StandardController(objSalesOrg);
            ZM_KPIPerformanceController con = new ZM_KPIPerformanceController(objController);
            con.changeData();
           
        }
        System.runAs(divisionUser) {
            ApexPages.StandardController objController = new ApexPages.StandardController(objSalesOrg);
            ZM_KPIPerformanceController con = new ZM_KPIPerformanceController(objController);
            con.changeData();
           
        }
        Test.StopTest();
        
    }    */ // Commented out by Parul Gupta END      
}