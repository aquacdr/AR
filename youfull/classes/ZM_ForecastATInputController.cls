/*
** Apex Class/Controller Name           : ZM_ForecastATInputController
** VF Pages associated [Names]          : ZM_ActivityForecastTrackerInput
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for report ZM_ActivityForecastTrackerInput
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** ~Format: Date | Author | Change description 
**  3/11 Created G
**  3/19 modified G
** 
*/

public class ZM_ForecastATInputController {
    public Sales_Org_Summary__c inputRecord {get; set;}
    public Sales_Org_Summary__c blankInputRecord {get; set;}
    public List<String> inputFieldsCollection;
    public Map<String, ZM_ZoneKPIConfig__c> mapFields;
    public String activeZone {get; set;}
    public SelectOption[] zoneOptions {get; set;}
    public String campaignNum{get;set;}
    public String s_User_Language{get{return UserInfo.getLanguage();}}
    
    private String userId;
    private List<Sales_Org_Summary__c> listRecords;
    private Map<String, ZM_MarketZoneKPIConfig__c> mapMarketConfig;
    private Map<String, ZM_ZoneKPIConfig__c> mapKpi;
    private ZM_Utility_KPIConfig configUtil;
    private String marketId;
    private String context;
    private Map<String, Sales_Org_Summary__c> mapZones;
    public list<String> sortedFieldList{get;set;}
    public list<string> configFields{get;set;}
    private set<Integer> sortOrderSet = new set<Integer>();
    private list<Integer> sortOrderList = new list<Integer>();
    private map<Integer, String> sortOrderMap = new map<Integer, String>();
    
    
    public String strProfileName;



    public ZM_ForecastATInputController(){
        BuildandRunQuery();
    }
    
    
    /*
    * changes values on page according to active selected zone
    */
    public PageReference changeZone() {
    	system.debug ('activeZone = ' + activeZone);
        inputRecord = mapZones.get(activeZone);
        //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'inputRecord: '+inputRecord) );
        
        //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'mapFields: '+mapFields));
        
        blankInputRecord = new Sales_Org_Summary__c();
        return null;
    }
    
    public Decimal getZoneTotal()
    {
        Decimal zoneTotal = 0;
        for(ZM_ZoneKPIConfig__c s : mapFields.values())
        {
            zoneTotal += (Decimal)inputRecord.get((String)s.ForecastField__c)==null?0:(Decimal)inputRecord.get((String)s.ForecastField__c) ;
        }
        
        return zoneTotal;
                
    }
    
    /*
    * returns map of iterable labels as keys to fields' names
    * the output and input page iterates this map and displays
    * corresponding fields and labels
    */
    public Map<String, ZM_ZoneKPIConfig__c> getMapFields() {
        
        if (mapFields == null) {
            mapFields = configUtil.createMapFields(this.mapMarketConfig.values(), this.mapKpi);
        }
        sortOrderMap = new map<Integer, String>();
        
        for(ZM_MarketZoneKPIConfig__c mk : mapMarketConfig.values())
        {
            sortOrderMap.put(Integer.ValueOf(mk.SortOrder__c), mk.ZM_ZoneKPIConfigName__c);
        }
        
        sortOrderList = new list<Integer>();
        sortOrderList.addAll(sortOrderMap.keySet());
        sortOrderList.sort();
                
        sortedFieldList = new list<String>();
        configFields.clear();
        for(Integer i : sortOrderList)
        {
           sortedFieldList.add(sortOrderMap.get(i));
        }
        
        // Added by Raktim on 22nd Oct, 2013 - Defect 3228 Fix START        
        for(String field : sortedFieldList){
        	
        	for(ZM_ZoneKPIConfig__c z : mapFields.values()){
        		
        		if( field == z.Name){
        			
        			configFields.add(z.CustomLabel__c);
        			
        		}
        	}
        }
        
        /*
        for(ZM_ZoneKPIConfig__c z : mapFields.values())
        {
            for(String s : sortedFieldList)
            {
                if(s == z.Name)
                  configFields.Add(z.CustomLabel__c);
            }
        }*/
        System.debug('\n ############ GOT IT configFields FINAL @@@ \n'+configFields); 
        // Added by Raktim on 22nd Oct, 2013 - Defect 3228 Fix END
        
        return mapFields;
    }
    
    /*
        saves numbers for forecast input form
    */
    public PageReference submit() {
        if (listRecords.size() == 0 && !Test.isRunningTest()) { // !!! quick and dirty check
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'No Sales Org Summary Records ') );
            return null;
    }
        
        try {
            
            //set the values in the inputRecord from blankInputRecord 
            Decimal sum=0;
            for(ZM_ZoneKPIConfig__c s : mapFields.values())
            {
                Decimal x = (Decimal)inputRecord.get((String)s.ForecastField__c)==null?0:(Decimal)inputRecord.get((String)s.ForecastField__c) ;
                Decimal y = (Decimal)blankInputRecord.get((String)s.ForecastField__c)==null?0:(Decimal)blankInputRecord.get((String)s.ForecastField__c);
                Decimal z = x+y;
                sum += y;
                Decimal d = (Decimal)inputRecord.get((String)s.PlanField__c);
                if(mapMarketConfig.containsKey(s.Name) && mapMarketConfig.get(s.Name).MarketUsesDefault__c)
                   d = mapMarketConfig.get(s.Name).MarketDefaultPlan__c;
                
                  
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, s.ForecastField__c +'['+ x +'], ['+ y +'], ['+ z +'], ['+ d +']') );
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, '['+ s.PlanField__c +'], ['+ s.ForecastGoalField__c +']') );
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, '['+ inputRecord.Id +']') );
                try{
                    
                  if(s.ForecastField__c != null)
                    inputRecord.put((String)s.ForecastField__c, z );
                  
                  if(s.ForecastInput__c != null)
                    inputRecord.put((String)s.ForecastInput__c, d );
                  
                  if(d != null && d > 0 && s.ForecastGoalField__c != null) inputRecord.put( (String)s.ForecastGoalField__c, (z/d)*100 );
                                  
                  inputRecord.LST_DT_RSPD__c  = System.today();            
                  //apexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, ':::::> ' + (Decimal)inputRecord.get((String)s.ForecastField__c) )) ;
                } 
                catch(Exception e) {
                    
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.ZM_Forecast_Update_Error+'['+e.getMessage()+']') );
                }
                
                
            }
            if(sum == 0)
            {
                  Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.ZM_No_forecast_data_entered) );
                  return null;
            }
            update inputRecord;
            blankInputRecord = new Sales_Org_Summary__c();
            
        } catch(Exception e) {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.ZM_Forecast_Update_Error+'[>'+e.getMessage()+'<]') );
        }
        return null;
    }
    
   /* public String buildSOQLWhereStatement(QueryBuilder builder ) {
    	 query += ' FROM Sales_Org_Summary__c  WHERE SLS_ORG_DESC_TXT__c = :zoneList and SLS_ORG_LVL_DESC_TXT__c = \'Z\' and  FLD_SLS_CMPGN_NR__c = :strCurrentCmpgnNR and MRKT_KEY__c = :marketId';//
       
    	return query;
    } */
    // New method - for Omniture Integration
    public String getOmniturePageName()      
    {  
        String pageNameOutput = 'ZM_ActivityForecastTrackerOutput';
        String pageNameInput = 'ZM_ActivityForecastTrackerInput';
        
        String pageName;
        
        String url = Apexpages.currentPage().getUrl();
        
        if(url.indexOf(pageNameInput) > -1)
            pageName = pageNameInput;
        else if(url.indexOf(pageNameOutput) > -1)
            pageName = pageNameOutput;        
        
        return ALMPlusUtils.generateOmniturePageName(pageName, null, strProfileName);
                 
    } //this is for getting page name mapping for omniture
    
    // utility exceptions
    class InvalidPermissionException extends Exception {
    }
    
    class NoRecordFoundException extends Exception {
    }
    
    class AmbiguityException extends Exception {
    }
 
 /*   
    @isTest(SeeAllData=true)
    static void testThisClass()
    {
        TestDataHelper testData =   new TestDataHelper();
        
        String acctNbr = '123456';
        
        // Creates Market Data
        Market__c mkt = testData.createMarket();
        User zmUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            zmUsr = testData.createUser(acctNbr, 'XZ1', 'Avon Mkt 62 Zone Manager');
            
            mkt.OwnerId = zmUsr.Id;
            mkt.Mail_Plan_Enabled__c = true;
            update  mkt;
            
            // Creates ZM MarketZoneKPIConfig data
            ZM_MarketZoneKPIConfig__c zmMrktZoneKPIConfg = new ZM_MarketZoneKPIConfig__c(ZM_ZoneKPIConfigName__c = 'ACTV_REP', SortOrder__c = '1',
                                                                                         Market__c = mkt.ID, Name = 'ConfigX', Context__c = 'Forecast Input',
                                                                                         OwnerId = zmUsr.Id, CurrencyISOCode='USD');
            insert zmMrktZoneKPIConfg;  
            
            // Creates Sales Org Summary data
            Sales_Org_Summary__c slsOrgSummry = new Sales_Org_Summary__c(Name = 'test', OPERTNL_CMPGN_NR__c = mkt.CMPGN_NR__c, ACTV_REP_FRCST_CNT__c = 10.0,
                                                                         ZONE_MGR__c = Userinfo.getUserId(), OwnerId = zmUsr.Id, FLD_SLS_CMPGN_NR__c = mkt.CMPGN_NR__c,
                                                                         CurrencyISOCode='USD', SLS_ORG_LVL_DESC_TXT__c = 'Z', MRKT_KEY__c = mkt.Id,
                                                                         SLS_ORG_DESC_TXT__c = 'XZ1'); 
            insert slsOrgSummry;                                                                                                                                             
            
        }
        
        // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mkt, zmUsr.DFALT_ZONE_CD__c);
        
        PageReference p = Page.ZM_ActivityForecastTrackerInput;
        Test.setCurrentPage(p);
        
        System.runAs(zmUsr){
            
            ZM_ForecastATInputController ctl = new ZM_ForecastATInputController();
            
            ctl.getMapFields();
            ctl.getOmniturePageName();
            ctl.changeZone();
            ctl.submit();
            
        }
        
        
        
    }
    */
   
    
    private void BuildandRunQuery() {
   		  configFields = new list<string>();
        //get sales org summary records for this user
        //authentication part STARTS HERE
        blankInputRecord = new Sales_Org_Summary__c();
        Id IdUserProfile = UserInfo.getProfileId();
        ZM_UtilityClass objutilityclass= new ZM_UtilityClass();
        configUtil = new ZM_Utility_KPIConfig();
        objutilityclass.SetVariable();
        strProfileName = objutilityclass.strProfileName;
        campaignNum = objutilityclass.strCurrentCmpgnNR;
        
        //get market information
        //!!! hardcoded for test
        //marketId = 'a00F0000008AKlm';
        marketId = objutilityclass.strMarketRecordId;
        System.debug('====================== market id : ' + marketId);
        
        //get user Id
        userId = UserInfo.getUserId();//'005Z0000000ln3z';//
        //userId = 
        
        // !!! use constants
        if (!strProfileName.contains('Zone Manager') &&  
            !strProfileName.contains('Division Manager') && 
            !strProfileName.equals('Avon System Administrator') &&
            !Test.isRunningTest()) {
            
            throw new InvalidPermissionException();
        }
        //authentication part ENDS HERE
        
        //context depends on whether page is input or output
        String currentPage = ApexPages.currentPage().getUrl(); //check what current page is
        currentPage = currentPage.split('apex/')[1];
        if (!currentPage.contains('Forecast') && !Test.isRunningTest()) { // error
            throw new InvalidPermissionException();
        } else if (currentPage.contains('Input') && currentPage.contains('Output')) {
            throw new AmbiguityException();
        }
        
        if (currentPage.containsIgnoreCase('Input')) {// !!! constant
            context = 'Forecast Input';
        } else if (currentPage.containsIgnoreCase('Output')) {
            context = 'Forecast Output';
        }
        mapMarketConfig = configUtil.getKPIConfigForMarketAndContext(marketId, context); 
        
        
        
        mapKpi = ZM_ZoneKPIConfig__c.getAll();
        if (mapKpi.size() == 0) {
            throw new NoRecordFoundException();
        }
        
        //get field API names
        //use metadata to get all possible field names for ZM_ZoneKPIConfig__c
        Schema.DescribeSObjectResult r = ZM_ZoneKPIConfig__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> mapZoneKpiFields = r.fields.getMap();
        Set<String> setKpiFieldNames = new Set<String>();
        String str = '';
        for (Schema.SObjectField sf: mapZoneKpiFields.values()) {
            str = sf.getDescribe().getName();
            if (str.contains('Field')) {
                setKpiFieldNames.add(str);
            }
        }
        
        
        getMapFields();
        String fieldsToGet = '';
        
        //knowing possible fields in zoneKpi and having all data from zoneKpi
        //only get data we need if field is not empty
        String val = '';
        
        string query = 'Select Id ';
        
        //get all sObjects
        map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        
        //get the listof fields for the Sales_Org_Summary__c object
        Schema.SObjectType s = m.get('Sales_Org_Summary__c') ;
        Schema.DescribeSObjectResult sr = s.getDescribe() ;  
         
        // Get all the Sales_Org_Summary__c fields  
        Map<String, Schema.SObjectField> fields = sr.fields.getMap() ; 
         
        //iterate through the Sales_Org_Summary__c fields loading the field list with custon, non-required fields
        for(Schema.SObjectField f : fields.values())
        {
            //retrieve the field name
            string field = f.getDescribe().getName();
            if(!field.equalsIgnoreCase('Id'))
              query += ','+field;
            
        }
        list<String> zoneList = new list<String>();
        zoneOptions = objutilityclass.getZoneList();
        system.debug('zoneOptions = ' + zoneOptions);
       
        
        for(SelectOption o : zoneOptions)
           zoneList.add(o.getValue());
         
        string strCurrentCmpgnNR = objutilityclass.strCurrentCmpgnNR;
        
         system.debug ('MF ---- strCurrentCmpgnNR = ' + strCurrentCmpgnNR);
         system.debug ('MF---zoneList = ' + zoneList);
         system.debug('MF --- marketId = ' + marketId);
        
        //complete the query
        //query += ' FROM Sales_Org_Summary__c  WHERE SLS_ORG_DESC_TXT__c = :zoneList and SLS_ORG_LVL_DESC_TXT__c = \'Z\' and  OPERTNL_CMPGN_NR__c = :strCurrentCmpgnNR and MRKT_KEY__c = :marketId';//
        query += ' FROM Sales_Org_Summary__c  WHERE SLS_ORG_DESC_TXT__c = :zoneList and SLS_ORG_LVL_DESC_TXT__c = \'Z\' and  FLD_SLS_CMPGN_NR__c = :strCurrentCmpgnNR and MRKT_KEY__c = :marketId';//
        system.debug('MF---- query = ' + query);
        listRecords = Database.query(query);
        
        if (listRecords.size() < 0) { 
            throw new NoRecordFoundException();
        } 
        
        mapZones = new Map<String, Sales_Org_Summary__c>();
        
        
        
        //List<Sales_Org_Summary__c> lstZoneNrSOS= Database.query(query);
        //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'zoneOptions.size()::::> '+zoneOptions.size() ));
        if(listRecords.size()>1 || Test.isRunningTest()){
            //zoneOptions= new List<SelectOption>();
            set<string> setSLSORGDESCTXT = new set<string>();
            for(Sales_Org_Summary__c listRecs : listRecords) {
                setSLSORGDESCTXT.add(listRecs.SLS_ORG_DESC_TXT__c);
                mapZones.put(listRecs.SLS_ORG_DESC_TXT__c, listRecs);
            }
            /*
            for(string strSet : setSLSORGDESCTXT) {
                zoneOptions.add(new SelectOption(strSet, strSet));
            }
            zoneOptions.sort();
            */
        
       }
       if(listRecords.size() > 0)
       {
        // the first record is default
        inputRecord = listRecords[0];
        activeZone = listRecords[0].SLS_ORG_DESC_TXT__c;
       }
        		  
   
    }
}