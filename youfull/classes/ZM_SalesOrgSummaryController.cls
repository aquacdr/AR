//  Name            : ZM_SalesOrgSummaryController
//  Description     : Controller 
//  Author          : V. Mittal
//  Created Date    : Feb, 2013
//

public class ZM_SalesOrgSummaryController {
    // List of SalesOrgSummary related to currentCampaignNumber
    public list<Sales_Org_Summary__c> lstSalesOrgSummary{get;set;}
    // List of SalesOrgSummary related to prior CampaignNumber
    public list<Sales_Org_Summary__c> lstSalesOrgSummaryPrior= new list<Sales_Org_Summary__c>();
    
    // Wrapper list of KPI's to be displayed on the visualforce pages
    public list<WrapperZoneKPIConfig> lstWrapperZoneKPIConfig{get;set;}
    
    // list of zones
    public List<SelectOption> zoneList{get;set;}
    // variable to store the zone selected by the user
    public string strZoneNrSOS{get;set;}
    public Boolean isDropDown{get;set;}
    public String priorCampaignNmbr {get;set;}
    public String currentCampaignNmbr {get;set;}
    public String strProfileName;
    public boolean buttonReadOnly{get;set;}
    public List<string>lstStarColored{get;set;}
    public List<string>lstStarGrey{get;set;}
    public Boolean IsVeiwStar{get;set;}
    public Boolean Show{get;set;} 
    public boolean hideSuggestedActivities {get;set;}
    public boolean hideLastCampAnalysis {get;set;}
    public Sales_Org_Summary__c objSalesOrgSummary {get;set;}
    ZM_UtilityClass objutilityclass= new ZM_UtilityClass();
    Map<String,ZM_MarketZoneKPIContent__c> mapMarketZoneKPIContent;
    
    // default constructor for the extension
    public ZM_SalesOrgSummaryController(ApexPages.StandardController controller){
        // set the indicator to show the help on page (using ZM_Help component)
        Show=false;
        // set the variable to display zone selection dropdown
        isDropDown=false;
        
        // initialization
        lstSalesOrgSummary=new list<Sales_Org_Summary__c>();
        lstWrapperZoneKPIConfig =new list<WrapperZoneKPIConfig>(); 
        Id IdUserProfile = UserInfo.getProfileId();
        
        objutilityclass.SetVariable();
        if(!objutilityclass.hideNextCampaign)//changed by swarnava:Start
        {
          objutilityclass.strCurrentCmpgnNR=objutilityclass.lstmarket[0].NEXT_1_CMPGN_NR__c;
          objutilityclass.strPriorCmpgnNR=objutilityclass.lstmarket[0].CMPGN_NR__c;
        }//changed by swarnava:End
        priorCampaignNmbr = objutilityclass.strPriorCmpgnNR;
        currentCampaignNmbr = objutilityclass.strCurrentCmpgnNR;
        strProfileName = objutilityclass.strProfileName;
        hideLastCampAnalysis = objutilityclass.hideLastCampaignAnalysis;
        hideSuggestedActivities = objutilityclass.hideSuggestedActivities;
        
        mapMarketZoneKPIContent =  ZM_Utility_KPIConfig.getMarketZoneKPIContentMap();
        
        // if the logged-in user is a zone manager then set the KPIs
        if(strProfileName.contains('Zone Manager')){
            initializeForZoneManager();  
        }
        
        // set the buttonReadOnly flag to enable/disble button "Save and Share"
        // button is disabled when user save the record and generated the PDF to share
        if(lstSalesOrgSummary.size() > 0){
            if(lstSalesOrgSummary[0].Analysis_Done__c){
                buttonReadOnly=true;
            }else{
                buttonReadOnly=false;
             }
         }
         
         setZoneKPIConfig();
         changeData();
    }
    
    // prepare the intial content (KPIs data) to be displayed on the page
    public void setZoneKPIConfig(){
        map<string, string> params = ApexPages.currentPage().getParameters();
        
        if(params.get('SLSORGDESCTXT')!=null){
            if(strProfileName.contains('Zone Manager')){
                String strZoneNbrTxt = params.get('SLSORGDESCTXT');
                lstSalesOrgSummary = getSalesOrgSummaryData(Userinfo.getUserId(), objutilityclass.strCurrentCmpgnNR, strZoneNbrTxt);
                lstSalesOrgSummaryPrior = getSalesOrgSummaryData(Userinfo.getUserId(), objutilityclass.strPriorCmpgnNR, strZoneNbrTxt);
            }
            
            if(lstSalesOrgSummaryPrior.isEmpty()){
                System.debug('\n ####### ERROR: No prior compaign data (position #1, line #92)');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));
                return;
            }
            
            SetWrapperZoneKPIConfigData(lstSalesOrgSummaryPrior, lstSalesOrgSummary[0]);
        }   
    }
    
    // method is invoked when user clicks on Go button after changing the zone number from drop-down list
    public PageReference changeData() {
        lstWrapperZoneKPIConfig = new list<WrapperZoneKPIConfig>();
        
        // calculate all the KPIs fof the logged-in zone manager.
        if(strProfileName.contains('Zone Manager')){ 
            ZoneSalesOrg();  
        }
        
        if(lstSalesOrgSummary.size() > 0){
            if(lstSalesOrgSummary[0].Analysis_Done__c){
                buttonReadOnly=true;
            }else{
                buttonReadOnly=false;
             }
         }
        return null;
    }
    
    // method to get the SalesOrgSummary based on zoneManager's UserId, campaignNumber and zoneNumber parameters
    public Sales_Org_Summary__c[] getSalesOrgSummaryData(String strZoneMgr, String strCampaignNbr, String strZoneNbr) {
        String QUERY_BASE = 'select '+ ZM_UtilityClass.getSalesOrgSummaryFields() + ' from Sales_Org_Summary__c ';
        String QUERY_SALES_ORG_SUMMARY = '';
        if(strCampaignNbr == objutilityclass.strPriorCmpgnNR)
          // QUERY_SALES_ORG_SUMMARY = QUERY_BASE+' where OPERTNL_CMPGN_NR__c = \'' +strCampaignNbr +'\'';  FLD_SLS_CMPGN_NR__c
          //QUERY_SALES_ORG_SUMMARY = QUERY_BASE+' where FLD_SLS_CMPGN_NR__c = \'' +strCampaignNbr +'\'';  
          QUERY_SALES_ORG_SUMMARY = QUERY_BASE+' where ZONE_MGR__c ='+'\''+ strZoneMgr +'\' and FLD_SLS_CMPGN_NR__c = \'' +strCampaignNbr +'\'';
        else
           //QUERY_SALES_ORG_SUMMARY = QUERY_BASE+' where ZONE_MGR__c ='+'\''+ strZoneMgr +'\' and OPERTNL_CMPGN_NR__c = \'' +strCampaignNbr +'\''; 
           QUERY_SALES_ORG_SUMMARY = QUERY_BASE+' where ZONE_MGR__c ='+'\''+ strZoneMgr +'\' and FLD_SLS_CMPGN_NR__c = \'' +strCampaignNbr +'\'';
        
        QUERY_SALES_ORG_SUMMARY += strZoneNbr != null ? (' and SLS_ORG_DESC_TXT__c= \''+strZoneNbr+'\'') : '';
        
        // return the list of relevant SalesOrgSummary records
        list<Sales_Org_Summary__c> retList =  new list<Sales_Org_Summary__c>();
        
        try{
            retList = Database.query(QUERY_SALES_ORG_SUMMARY);   
        }
        catch(Exception e)
        {
        	System.debug('\n ####### ERROR: No Data (position #2, line #142).  Exception: ' + e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));
            
        }
        return retList;
    }
    
    // method to set the KPI configuration with current and prior campaign data in SalesOrgSummart records
    public void initializeForZoneManager(){
        IsVeiwStar=false;
        
        // Get the list of all the sales org summary where logged-in user is zone manager
        List<Sales_Org_Summary__c> lstZoneNrSOS = new List<Sales_Org_Summary__c>();
        try{
            lstZoneNrSOS=[Select SLS_ORG_DESC_TXT__c from Sales_Org_Summary__c  where SLS_ORG_DESC_TXT__c!=null and  ZONE_MGR__c=:Userinfo.getUserId()  order by SLS_ORG_DESC_TXT__c asc ];
        
            // prepate the zone number dropdown values
            if(lstZoneNrSOS.size()>0){
                /*zoneList= new List<SelectOption>();
                
                // populate the dropdown for zone selection with the zone numbers in lstZoneNrSOS list
                set<string> setSLSORGDESCTXT = new set<string>();z
                for(Sales_Org_Summary__c objTempZoneNrSOS : lstZoneNrSOS) {
                    setSLSORGDESCTXT.add(objTempZoneNrSOS.SLS_ORG_DESC_TXT__c);
                }
                // set the option label values
                for(string strSet : setSLSORGDESCTXT) {
                    zoneList.add(new SelectOption(strSet, strSet));
                }
                */
                zoneList = objutilityclass.getZoneList();
                // sort the zone numbers
                zoneList.sort();
                
            }
            
            if(zoneList.size()>1) {
                isDropDown=true;
            }
            else {
                // for the selected zone number, get the SalesOrgSummary with current and prior campaign 
                String strZoneNbrTxt =  lstZoneNrSOS.IsEmpty() ? null : lstZoneNrSOS[0].SLS_ORG_DESC_TXT__c;
                try{
                    lstSalesOrgSummary = getSalesOrgSummaryData(Userinfo.getUserId(), objutilityclass.strCurrentCmpgnNR, strZoneNbrTxt);
                    lstSalesOrgSummaryPrior = getSalesOrgSummaryData(Userinfo.getUserId(), objutilityclass.strPriorCmpgnNR, strZoneNbrTxt);
                    
                }
                catch(Exception e){
                // check if prior campaign salesOrgSummary does not exist, throw the error to user
                    System.debug('\n ####### ERROR: No Data (position #3, line #191).  Exception: ' + e);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));
                    return;
                }
                
                // else set the data for various KPI values based on the SalesOrgSummary for currnet and prior campaign
                SetWrapperZoneKPIConfigData(lstSalesOrgSummaryPrior, lstSalesOrgSummary[0]);
                
                // to show the campaign stars for prior campaign
                if ( !Test.isRunningTest() && (lstSalesOrgSummaryPrior.size()>0) ) { 
                    if(lstSalesOrgSummaryPrior[0].Num_Campaign_Stars__c!=null){
                        IsVeiwStar=true;
                        starCount(Integer.valueOf(lstSalesOrgSummaryPrior[0].Num_Campaign_Stars__c));
                    }
                }
            }
         }
        catch(Exception e)
        {
        	System.debug('\n ####### ERROR: No Data (position #4, line #210).  Exception: ' + e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));
            return;
        }
        
        
    }
    
    // method to re-calculate the KPIs data when user changes the zone number
    public void ZoneSalesOrg(){
        // for the selected zone number, get the SalesOrgSummary with current and prior campaign
        IsVeiwStar=false;
        lstSalesOrgSummary = getSalesOrgSummaryData(Userinfo.getUserId(), objutilityclass.strCurrentCmpgnNR, strZoneNrSOS);        
        lstSalesOrgSummaryPrior = getSalesOrgSummaryData(Userinfo.getUserId(), objutilityclass.strPriorCmpgnNR, strZoneNrSOS);
        
        // check if prior campaign salesOrgSummary does not exist, throw the error to user
        if(lstSalesOrgSummaryPrior.isEmpty()){
        	System.debug('\n ####### ERROR: No prior compaign data (position #5, line #227).');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ZM_KPI_Sales_Org_Summary_No_Data_Found));
            return;
        }
        
        // to show the campaign stars for prior campaign
        if(lstSalesOrgSummaryPrior[0].Num_Campaign_Stars__c!=null){
            starCount(Integer.valueOf(lstSalesOrgSummaryPrior[0].Num_Campaign_Stars__c));
            IsVeiwStar=true;
        }
        
        // to set the KPI data in wrapper class
        SetWrapperZoneKPIConfigData(lstSalesOrgSummaryPrior, lstSalesOrgSummary[0]);   
    }
    
    // method to create a list of string with 10 elements each of them indicating the color of the star (Colored or Grayed out)
    public void starCount(Integer intCountStar ){
        lstStarColored = new List<String>();
        lstStarGrey = new List<String>();
        for(Integer i=0; i<intCountStar; i++){
            lstStarColored.add('StarColored');
        }
        for(Integer i=10; i>intCountStar; i--){
            lstStarGrey.add('StarGrey');
        } 
    }
    
    
    // method to save the Compass business plan for the previos campaign
    public void saveAsPDF() {
        Database.SaveResult result;
        PageReference savePDF = new PageReference('/apex/ZM_BusinessPlan_PDF');
        savePDF.getParameters().put('SLSORGDESCTXT', lstSalesOrgSummary[0].SLS_ORG_DESC_TXT__c);
        Attachment attachment = new Attachment();
        attachment.Body =  !Test.isRunningTest() ? savePDF.getContent() : Blob.ValueOf('dummy text');//savePDF.getContent();
        attachment.Name = 'Z'+ (strZoneNrSOS==null ? objutilityclass.strDefaltZoneCD : strZoneNrSOS) 
                              +'_COMP_' + objutilityclass.strCurrentCmpgnNR + '_'
                              + objutilityclass.strLanguage+'.pdf';//'Z_101_COMP_201301.pdf';
        
        // get the market report and add the attachment (Compass Business Plan PDF)
        List<CDW_Market_Report__c> lstcdw= [select Id, Report_Code__c, User_Type_Index__c, Market__r.Market_Id__c 
                                              from CDW_Market_Report__c 
                                             where Market__c = :objutilityclass.strMarketRecordId//'62'
                                               AND User_Type_Index__c='Z'
                                               AND Report_Code__c = 'COMP' Limit 1];
        
        if(!lstcdw.IsEmpty()){
            attachment.ParentId = lstcdw[0].id;
            result = Database.insert(attachment);
        }
        
        Sales_Org_Summary__c[] listSalesOrgSummaryToUpdate = new Sales_Org_Summary__c[]{};
        
        // Also mark the campaign record with "Ananlysis Done"
        if(!lstSalesOrgSummary.isEmpty()){
            lstSalesOrgSummary[0].Analysis_Done__c = true;
            lstSalesOrgSummary[0] = SetSalesOrgSummary(lstSalesOrgSummary[0]);
            listSalesOrgSummaryToUpdate.add(lstSalesOrgSummary[0]);
        }

        if(listSalesOrgSummaryToUpdate.size()>0) {
            update listSalesOrgSummaryToUpdate;
        }
        
        //saveMarketZoneKPIContent();
            
               
        // Here this is the folderId(you can access it at run time)
        //insert d;
    }
    
    /*
    public void saveMarketZoneKPIContent() {
        marketZoneKPIContent__c[] marketZoneKPIContentsToUpdate = new marketZoneKPIContent__c[]{};
        for(marketZoneKPIContent__c mzkc : mapMarketZoneKPIContent.values()) {
            if(mzkc != null) {
                marketZoneKPIContentsToUpdate.add(mzkc);
            }
        }
        
        if(marketZoneKPIContentsToUpdate.size() > 0) {
            update marketZoneKPIContentsToUpdate;
        }
    }
    */
    
     public void saveAsDraft() {
        Database.SaveResult result;
        
        Sales_Org_Summary__c[] listSalesOrgSummaryToUpdate = new Sales_Org_Summary__c[]{};
        
        // Also mark the campaign record with "Analysis Done"
        if(!lstSalesOrgSummary.isEmpty()){
            lstSalesOrgSummary[0] = SetSalesOrgSummary(lstSalesOrgSummary[0]);
            listSalesOrgSummaryToUpdate.add(lstSalesOrgSummary[0]);
        }
        if(!lstSalesOrgSummaryPrior.isEmpty()){
            lstSalesOrgSummaryPrior[0].Analysis_Done__c = false;
            listSalesOrgSummaryToUpdate.add(lstSalesOrgSummaryPrior[0]);
            buttonReadOnly=false; 
        }
        
        if(listSalesOrgSummaryToUpdate.size()>0) {
            update listSalesOrgSummaryToUpdate;
        }
        
    }
    
    // Wrapper Class the used in the repeat tag to display various KPIs
    public Class WrapperZoneKPIConfig{
        public string strCustomLabel{get;set;}
        
        public string dbPlanField{get;set;}
        public string dbActualField{get;set;}
        public string dbVarianceField{get;set;}
        public string dbRankField{get;set;}
        public string dbResultsField{get;set;}
        public string dbCurrentCampaignPlan{get;set;}
        
        public string strMyAction{get;set;}
        public String strLastCampaignAnalysis{get;set;} 
        public String strSuggestedActivities{get;set;}
        public string IdTRslidingData{get; set;}
        public Boolean isAnalysisDone {get;set;}
        
        public Boolean isGoalToMaximize {get;set;}
        public String barColor {get;set;}
        
        // constructor to set all the attributes related to a KPI
        public WrapperZoneKPIConfig (string strTempCustomLabel,Double dbTempPlanField, Double dbTempActualField, Double dbTempVarianceField, Double dbTempRankField, Double dbTempResultsField ,Double dbTempCurrentCampaignPlan,string strTempMyAction,String strTempLastCampaignAnalysis, String strTempSuggestedActivities, string IdTRTempslidingData, Boolean isTempAnalysisDone, Boolean isTempGoalToMaximize, String barTempColor ){
            strCustomLabel = strTempCustomLabel;
            dbPlanField = dbTempPlanField==null?'':dbTempPlanField.format();
            dbActualField = dbTempActualField==null?'':dbTempActualField.format();
            dbVarianceField = dbTempVarianceField==null?'':dbTempVarianceField.format();
            dbRankField = dbTempRankField==null?'':dbTempRankField.format();
            dbResultsField= dbTempResultsField==null?'':dbTempResultsField.format();
            dbCurrentCampaignPlan= dbTempCurrentCampaignPlan==null?'':dbTempCurrentCampaignPlan.format();
            strMyAction=strTempMyAction;
            strLastCampaignAnalysis=strTempLastCampaignAnalysis; 
            strSuggestedActivities = strTempSuggestedActivities ;
            IdTRslidingData=IdTRTempslidingData;                    
            isAnalysisDone=isTempAnalysisDone; 
            isGoalToMaximize=isTempGoalToMaximize;
            barColor = barTempColor;
        }
    }
    
    // Method used for transforming the wrapper class value into Sales Org Summary object.  User for PDF function
    public Sales_Org_Summary__c SetSalesOrgSummary(Sales_Org_Summary__c objSalesOrgSummary){
        Integer intCount=0;
        ZM_Utility_KPIConfig objZMUtilityKPIConfig= new ZM_Utility_KPIConfig(); 
        List<ZM_ZoneKPIConfig__c> lstZoneKPIConfig= objZMUtilityKPIConfig.getZoneKPIConfig(objutilityclass.strMarketRecordId,'Compass');     
        
        for(ZM_ZoneKPIConfig__c objZMZoneKPIConfig: lstZoneKPIConfig){
            
            objSalesOrgSummary.put(objZMZoneKPIConfig.My_Actions__c,lstWrapperZoneKPIConfig[intCount].strMyAction);
            objSalesOrgSummary.put(objZMZoneKPIConfig.Last_Campaign_Analysis__c,lstWrapperZoneKPIConfig[intCount].strLastCampaignAnalysis);
            
            //objSalesOrgSummary.put(objZMZoneKPIConfig.Suggested_Activities__c,lstWrapperZoneKPIConfig[intCount].strSuggestedActivities);
            ZM_MarketZoneKPIContent__c mzkContent = mapMarketZoneKPIContent.get(objZMZoneKPIConfig.Name);
            if(mzkContent != null) {
                mzkContent.SuggestedActivities__c = lstWrapperZoneKPIConfig[intCount].strSuggestedActivities;
            }
            intCount=intCount+1;
        }
        return objSalesOrgSummary;
    }
    
    // New method - for Omniture Integration
    public String getOmniturePageName()      
    {  
        String pageNameBP       = 'ZM_BusinessPlan';
        String pageNameBP_PDF   = 'ZM_BusinessPlan_PDF';
        
        String pageName;
        
        String url = Apexpages.currentPage().getUrl();
        
        if(url.indexOf(pageNameBP) > -1)
            pageName = pageNameBP;
        else if(url.indexOf(pageNameBP_PDF) > -1)
            pageName = pageNameBP_PDF;        
        
        return ALMPlusUtils.generateOmniturePageName(pageName, null, strProfileName);
                 
    } //this is for getting page name mapping for omniture
    
    
    //Function to create a wrapper Class for the repet tag
    public void SetWrapperZoneKPIConfigData(Sales_Org_Summary__c[] objSalesOrgSummaryPrior, Sales_Org_Summary__c objSalesOrgSummaryCurrent){
        string strWCustomLabel;
        Double dbWPlanField;
        Double dbWActualField;
        Double dbWVarianceField;
        Double dbWRankField;
        Double dbWResultsField;
        Double dbWCurrentCampaignPlan;
        string strWMyAction;
        string strWLastCampaignAnalysis;
        string strWSuggestedActivities;
        Boolean isGoalToMaximize;
        string barColor;
        string strTRId ;
        Integer intCount=1;
        ZM_Utility_KPIConfig objZMUtilityKPIConfig= new ZM_Utility_KPIConfig();
        
        // Get ZM_MarketZoneKPIConfig__c records
        Map<String, ZM_MarketZoneKPIConfig__c> mapMarketConfig = objZMUtilityKPIConfig.getKPIConfigForMarketAndContext(objutilityclass.strMarketRecordId, 'Compass');
        
        //Calling the ZM utility KPI Config Class , Passing the Market object record Id and the Class type passing 
        // the utiltiy function  getZoneKPIConfig  return  list Custom setting which contains KPI fields        
     
        List<ZM_ZoneKPIConfig__c> lstZoneKPIConfig= objZMUtilityKPIConfig.getZoneKPIConfig(objutilityclass.strMarketRecordId,'Compass');
        // Loop to create the wrapper class  and putting the value by the Sales Org Summary object's field vlaue
        for(ZM_ZoneKPIConfig__c objZMZoneKPIConfig: lstZoneKPIConfig){
       isGoalToMaximize = false;
            strTRId='slidingData'+string.valueOf(intCount);
            intCount=intCount+1;
            strWCustomLabel = objZMZoneKPIConfig.CustomLabel__c;
                       
            // Set all the prior campaign atributes for a given KPI (i.e. Plan, Actual, Rank etc.)
            if(objSalesOrgSummaryPrior != null && objSalesOrgSummaryPrior.size() > 0) {
                System.debug('objZMZoneKPIConfig--------->'+objZMZoneKPIConfig);
                dbWPlanField = Double.valueOf(objSalesOrgSummaryPrior[0].get(objZMZoneKPIConfig.PlanField__c));
                dbWActualField = Double.valueOf(objSalesOrgSummaryPrior[0].get(objZMZoneKPIConfig.ActualField__c));
                dbWVarianceField = Double.valueOf(objSalesOrgSummaryPrior[0].get(objZMZoneKPIConfig.VarianceField__c));
                dbWRankField = Double.valueOf(objSalesOrgSummaryPrior[0].get(objZMZoneKPIConfig.RankField__c));
                dbWResultsField = Double.valueOf(objSalesOrgSummaryPrior[0].get(objZMZoneKPIConfig.Results_Field__c));
                
                // T-211794 : Added by Parul Gupta  - New field to determine how to process the kpi BEGIN
              if(objZMZoneKPIConfig.Goal_To_maximize__c 
              || (mapMarketConfig.get(objZMZoneKPIConfig.Name) != null 
                && mapMarketConfig.get(objZMZoneKPIConfig.Name).Goal_To_Maximize_Override__c)){
                isGoalToMaximize = true;                                
              }
              barColor =  getBarColor(strWCustomLabel, dbWResultsField, isGoalToMaximize);
              // T-211794 : Added by Parul Gupta - New field to determine how to process the kpi END
                             
            }
                       
            // Set all the current campaign atributes for a given KPI (i.e. Next Campaign Plan)
            if(objSalesOrgSummaryCurrent != null){
                dbWCurrentCampaignPlan = Double.valueOf(objSalesOrgSummaryCurrent.get(objZMZoneKPIConfig.PlanField__c));
                
                strWMyAction = String.valueOf(objSalesOrgSummaryCurrent.get(objZMZoneKPIConfig.My_Actions__c));
                strWLastCampaignAnalysis = String.valueOf(objSalesOrgSummaryCurrent.get(objZMZoneKPIConfig.Last_Campaign_Analysis__c));
                //strWSuggestedActivities = String.valueOf(objSalesOrgSummaryCurrent.get(objZMZoneKPIConfig.Suggested_Activities__c));
                ZM_MarketZoneKPIContent__c mzkContent = mapMarketZoneKPIContent.get(objZMZoneKPIConfig.Name);
                strWSuggestedActivities = mzkContent != null ? mzkContent.SuggestedActivities__c : null;
            }
            
            // create an instance of wrapper class (WrapperZoneKPIConfig) and set all its attributes
            WrapperZoneKPIConfig objWZoneKPIConfig = new WrapperZoneKPIConfig(strWCustomLabel, dbWPlanField, dbWActualField, dbWVarianceField, dbWRankField, dbWResultsField,dbWCurrentCampaignPlan,strWMyAction,strWLastCampaignAnalysis,strWSuggestedActivities,strTRId,objSalesOrgSummaryPrior[0].Analysis_Done__c, isGoalToMaximize, barColor);
            
            lstWrapperZoneKPIConfig.add(objWZoneKPIConfig); 
        }
        
    }
    
    // T-211794 : Method to return the bar color (green/red/yellow)
    private String getBarColor(String strWCustomLabel, Double dbWResultsField, 
                            boolean isGoalToMaximize){
      String barColor = '';
      if (isGoalToMaximize){
        if(dbWResultsField >= ALMConstants.GOALTOMAX_ACTUAL_UPPER_RANGE){
            barColor = ALMConstants.BAR_COLOR_GREEN;
          }else if(dbWResultsField < ALMConstants.GOALTOMAX_ACTUAL_UPPER_RANGE 
          && dbWResultsField >= ALMConstants.GOALTOMAX_ACTUAL_LOWER_RANGE){
               barColor = ALMConstants.BAR_COLOR_YELLOW;
          }else if(dbWResultsField < ALMConstants.GOALTOMAX_ACTUAL_LOWER_RANGE){
              barColor = ALMConstants.BAR_COLOR_RED;
          }
      }else{
        if(dbWResultsField >= ALMConstants.NOT_GOALTOMAX_UPPER_RANGE){
            barColor = ALMConstants.BAR_COLOR_RED;
          }else if(dbWResultsField < ALMConstants.NOT_GOALTOMAX_UPPER_RANGE 
          && dbWResultsField >= ALMConstants.NOT_GOALTOMAX_LOWER_RANGE){
              barColor = ALMConstants.BAR_COLOR_YELLOW;
          }else if(dbWResultsField < ALMConstants.NOT_GOALTOMAX_LOWER_RANGE){
              barColor = ALMConstants.BAR_COLOR_GREEN;
          }
    } 
    return barColor;
    }
   /**************************************************************************
                           Test Method
    **************************************************************************/

    /* static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       // Sales_Org_Summary__c objSalesOrg = New Sales_Org_Summary__c ( Name = '201211 Sales Org Summary',Num_Campaign_Stars__c=5,Analysis_Done__c=true,ZONE_MGR__c= ); 
        
        Profile p = [select id from profile where name ='Avon Mkt 62 Zone Manager'];
        Profile p1 = [select id from profile where name ='Avon Mkt 62 Division Manager'];
        
        
        User u2 = [select id from user where profileId=:p1.id and MRKT_ID__c='62' limit 1];
        
        User u1= new User(alias = 'testuser',email = 'testuser@test.com',GI3_Email__c = 'testuser@test.com', emailencodingkey='UTF-8',lastname = 'User',languagelocalekey='en_US',localesidkey='en_US',profileid = p.id,timezonesidkey='America/Chicago',username='testuser@testmagic.com',MRKT_ID__c='62',DFALT_ZONE_CD__c='601');
        insert u1;
        
        Market__c mark=new Market__c(Market_Id__c='62', CMPGN_NR__c='201302', PREV_1_CMPGN_NR__c='201301', NEXT_1_CMPGN_NR__c='201303', Hide_Next_Campaign__c=true);
        insert mark;
        
        ZM_MarketZoneKPIConfig__c ZMMarketConfig= new ZM_MarketZoneKPIConfig__c(Name='Config 1', Market__c=mark.Id,ZM_ZoneKPIConfigName__c='APPT', SortOrder__c='1', Context__c='KPI Summary 1;Compass');
        insert ZMMarketConfig;

        ZM_ZoneKPIConfig__c ZMZoneKPIConfig= new ZM_ZoneKPIConfig__c(Results_Field__c='APPT_RES_CNT__c', RankField__c='APPT_DIV_RNK__c', CountAtRiskField__c='APPT_TAR_CNT__c', SPPYField__c='APPT_SPPY_CNT__c', CustomLabel__c='Appointments',  ForecastField__c='APPT_FRCST_CNT__c', PlanSPPYField__c='APPT_PLAN_SPPY_CNT__c', CountOfRisingStarsField__c='APPT_RSNG_STR_CNT__c', VarianceField__c='APPT_VAR_CNT__c', Name='APPT', Last_Campaign_Analysis__c='APPT_LCA_CNT__c', CounAtRiskLastCampaignField__c='APPT_TAR_LAST_CMPGN_CNT__c', My_Actions__c='APPT_My_Actions_CNT__c',ActualField__c='APPT_CNT__c', PlanField__c='APPT_PLAN_CNT__c'); 
        insert ZMZoneKPIConfig;
        
        Sales_Org_Summary__c objSalesOrg = New Sales_Org_Summary__c (OwnerId = u1.Id, ZONE_MGR__c=u1.Id, ACTV_REP_CNT__c=300, UPR_CNT__c=8, SLS_ORG_DESC_TXT__c='601',  TITLD_STF_CNT__c=8,  RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, TITL_0_STF_CNT__c=8,  UPR_DIV_RNK_CNT__c=100, RNSTMT_DIV_RNK__c=100, UPR_PLAN_SPPY_CNT__c=9, RMOVL_PLAN_CNT__c=6, LOA_1_6_NET_SLS_DIV_RNK__c=100, RTURN_NET_SLS_AMT__c=1500.00, RMOVL_SPPY_CNT__c=8, LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00, RMOVL_PLAN_SPPY_CNT__c=8,    NET_SLS_SPPY_AMT__c=1555000.00, LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, RNSTMT_PLAN_CNT__c=5, RMOVL_CNT__c=9, TITLD_STF_DIV_RNK__c=100,   RNSTMT_CNT__c=2,   ACTV_REP_PLAN_SPPY_CNT__c=1500, NET_SLS_DIV_RNK__c=100, TITL_0_STF_PLAN_SPPY_CNT__c=9,  APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, TITL_0_STF_DIV_RNK__c=100, LOA_1_6_NET_SLS_AMT__c=30000.00,   UPR_PLAN_CNT__c=9, OPERTNL_CMPGN_NR__c='201303',FLD_SLS_CMPGN_NR__c = '201303', ACTV_REP_DIV_RNK__c=100, RNSTMT_SPPY_CNT__c=7, LOA1_NET_SLS_DIV_RNK__c=100, ACTV_REP_SPPY_CNT__c=1600, LOA1_NET_SLS_AMT__c=1000.00,  RMOVL_DIV_RNK__c=100, LOA1_NET_SLS_SPPY_AMT__c=1000.00, NET_SLS_PLAN_SPPY_AMT__c=1555000.00, LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, TITLD_STF_SPPY_CNT__c=9, TITL_0_STF_SPPY_CNT__c=9,  APPT_DIV_RNK__c=100, UPR_SPPY_CNT__c=9, APPT_PLAN_CNT__c=12, LOA_1_6_NET_SLS_PLAN_AMT__c=322000.00, RTURN_NET_SLS_DIV_RNK__c=100, Analysis_Done__c=false, RTURN_NET_SLS_SPPY_AMT__c=1550.00, APPT_PLAN_SPPY_CNT__c=15, NET_SLS_PLAN_AMT__c=500000.00,  RNSTMT_PLAN_SPPY_CNT__c=7, APPT_SPPY_CNT__c=15, ACTV_REP_PLAN_CNT__c=200, LOA1_NET_SLS_PLAN_AMT__c=100000.00, TITLD_STF_PLAN_SPPY_CNT__c=9, RTURN_NET_SLS_PLAN_AMT__c=1500.00, TITLD_STF_PLAN_CNT__c=9); 
        insert objSalesOrg;
        Sales_Org_Summary__c objSalesOrg1 = New Sales_Org_Summary__c (OwnerId = u1.Id, ZONE_MGR__c=u1.Id, ACTV_REP_CNT__c=1500, UPR_CNT__c=8, SLS_ORG_DESC_TXT__c='601',TITLD_STF_CNT__c=8, RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, TITL_0_STF_CNT__c=8,  UPR_DIV_RNK_CNT__c=100, RNSTMT_DIV_RNK__c=100, UPR_PLAN_SPPY_CNT__c=9, RMOVL_PLAN_CNT__c=6, LOA_1_6_NET_SLS_DIV_RNK__c=100, RTURN_NET_SLS_AMT__c=1500.00, RMOVL_SPPY_CNT__c=8, LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00,RMOVL_PLAN_SPPY_CNT__c=8,  NET_SLS_SPPY_AMT__c=1555000.00, LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, RNSTMT_PLAN_CNT__c=5, RMOVL_CNT__c=9, TITLD_STF_DIV_RNK__c=100, RNSTMT_CNT__c=2,  ACTV_REP_PLAN_SPPY_CNT__c=1500, NET_SLS_DIV_RNK__c=100, TITL_0_STF_PLAN_SPPY_CNT__c=9,APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, TITL_0_STF_DIV_RNK__c=100, LOA_1_6_NET_SLS_AMT__c=30000.00,  UPR_PLAN_CNT__c=9, OPERTNL_CMPGN_NR__c='201302',FLD_SLS_CMPGN_NR__c = '201302', ACTV_REP_DIV_RNK__c=100, RNSTMT_SPPY_CNT__c=7, LOA1_NET_SLS_DIV_RNK__c=100, ACTV_REP_SPPY_CNT__c=1600, LOA1_NET_SLS_AMT__c=1000.00, RMOVL_DIV_RNK__c=100, LOA1_NET_SLS_SPPY_AMT__c=1000.00, LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, TITLD_STF_SPPY_CNT__c=9, TITL_0_STF_SPPY_CNT__c=9, NET_SLS_PLAN_SPPY_AMT__c=1555000.00, APPT_DIV_RNK__c=100, UPR_SPPY_CNT__c=9, APPT_PLAN_CNT__c=12, LOA_1_6_NET_SLS_PLAN_AMT__c=322000.00, RTURN_NET_SLS_DIV_RNK__c=100, Analysis_Done__c=false, RTURN_NET_SLS_SPPY_AMT__c=1550.00, APPT_PLAN_SPPY_CNT__c=15, NET_SLS_PLAN_AMT__c=1322000.00,  RNSTMT_PLAN_SPPY_CNT__c=7, APPT_SPPY_CNT__c=15, ACTV_REP_PLAN_CNT__c=1546, LOA1_NET_SLS_PLAN_AMT__c=100000.00, TITLD_STF_PLAN_SPPY_CNT__c=9, RTURN_NET_SLS_PLAN_AMT__c=1500.00, TITLD_STF_PLAN_CNT__c=9); 
        insert objSalesOrg1;
        Sales_Org_Summary__c objSalesOrg2 = New Sales_Org_Summary__c (OwnerId = u1.Id, ZONE_MGR__c=u1.Id, ACTV_REP_CNT__c=1500, UPR_CNT__c=8, SLS_ORG_DESC_TXT__c='601',  TITLD_STF_CNT__c=8, RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00, TITL_0_STF_CNT__c=8,  UPR_DIV_RNK_CNT__c=100, RNSTMT_DIV_RNK__c=100, UPR_PLAN_SPPY_CNT__c=9, RMOVL_PLAN_CNT__c=6, LOA_1_6_NET_SLS_DIV_RNK__c=100, RTURN_NET_SLS_AMT__c=1500.00, RMOVL_SPPY_CNT__c=8, LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00, RMOVL_PLAN_SPPY_CNT__c=8,  NET_SLS_SPPY_AMT__c=1555000.00,  LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00, RNSTMT_PLAN_CNT__c=5, RMOVL_CNT__c=9, TITLD_STF_DIV_RNK__c=100, RNSTMT_CNT__c=2,  ACTV_REP_PLAN_SPPY_CNT__c=1500, NET_SLS_DIV_RNK__c=100, TITL_0_STF_PLAN_SPPY_CNT__c=9,APPT_CNT__c=9, TITL_0_STF_PLAN_CNT__c=9, TITL_0_STF_DIV_RNK__c=100, LOA_1_6_NET_SLS_AMT__c=30000.00,  UPR_PLAN_CNT__c=9, OPERTNL_CMPGN_NR__c='201301',FLD_SLS_CMPGN_NR__c = '201301', ACTV_REP_DIV_RNK__c=100, RNSTMT_SPPY_CNT__c=7, LOA1_NET_SLS_DIV_RNK__c=100, ACTV_REP_SPPY_CNT__c=1600, LOA1_NET_SLS_AMT__c=1000.00, RMOVL_DIV_RNK__c=100, LOA1_NET_SLS_SPPY_AMT__c=1000.00, LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00, TITLD_STF_SPPY_CNT__c=9, TITL_0_STF_SPPY_CNT__c=9, NET_SLS_PLAN_SPPY_AMT__c=1555000.00, APPT_DIV_RNK__c=100, UPR_SPPY_CNT__c=9, APPT_PLAN_CNT__c=12, LOA_1_6_NET_SLS_PLAN_AMT__c=322003.00, RTURN_NET_SLS_DIV_RNK__c=100, Analysis_Done__c=false, RTURN_NET_SLS_SPPY_AMT__c=1550.00, APPT_PLAN_SPPY_CNT__c=15, NET_SLS_PLAN_AMT__c=1322001.00,  RNSTMT_PLAN_SPPY_CNT__c=7, APPT_SPPY_CNT__c=15, ACTV_REP_PLAN_CNT__c=1541, LOA1_NET_SLS_PLAN_AMT__c=100000.00, TITLD_STF_PLAN_SPPY_CNT__c=9, RTURN_NET_SLS_PLAN_AMT__c=1503.00, TITLD_STF_PLAN_CNT__c=9); 
        insert objSalesOrg2;
        
        Test.StartTest();

        
        System.runAs(u1) {
                ApexPages.StandardController objController = new ApexPages.StandardController(objSalesOrg);
                ZM_SalesOrgSummaryController con = new ZM_SalesOrgSummaryController(objController);
                con.changeData();
                con.strZoneNrSOS='601';
                con.ZoneSalesOrg();
                //con.DivisionManager();
                //con.DivisionSalesOrg();
                con.starCount(5);
                con.saveAsPDF();
                con.saveAsDraft();
        }
        
        Test.StopTest();
        
    }*/
}