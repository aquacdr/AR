/*
** Apex Class/Controller Name           : G1SalesLeadersController
** VF Pages associated [Names]          : G1SalesLeadersComponent
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for component G1SalesLeaders on Landing Page.  Inherits from ComponentController.
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** March 13, 2012. Created
** 
*/

//TODO - Determine if Left and Right Ids are at all required in the query to fetch data on this page - RITIKA

public class G1SalesLeadersController extends ComponentController {
  
    public List<LPDownlineWrapper>  listDownline {get; set;}
    public Boolean g1SlsLdr_hasData {get; set;}
    public Integer g1EachRowHeight {get; set;}
    
    
    public String messageText {get; set;}  // Custom Message for g1 sales leaders
    public String messageUrl {get; set;}  // Custom Message for  g1 sales leaders
    
    private List<String> strFields;
    private String messageName = ALMConstants.G1SALES_LEADERS_MESSAGE_NAME;
    
    
    public G1SalesLeadersController() {
        
        initializeReport();
      
    }
    
    
    public void initializeReport(){
        
        g1EachRowHeight = this.eachRowHeight;
        String query = null;
         
      try {
            
            Set<String> queryFieldSet = new Set<String>();
            
            
            
            queryFieldSet.add('LFT_ND_ID__c');
            queryFieldSet.add('ROOT_UPLN_ACCT_NR__c');
            queryFieldSet.add('Genealogy_Level__c');
            queryFieldSet.add('RGT_ND_ID__c');
            GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet);
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            //String whereClause =  ' FLD_SLS_CMPGN_NR__c = \'' + Double.valueOf(campaignNumber)  + '\' ' + 
            String whereClause =  ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  +
                                  ' AND MRKT_ID__c = \'' + currUser.MRKT_ID__c + '\' ' +
                                  ' AND ACCT_NR__c = ' + '\'' + currUser.ACCT_NR__c + '\'';
            
            Map<String,String> queryOptionsMap = new Map<String,String>();
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('LIMIT', '1');
            
            List<SObject> leaderGenList = gsb.queryNew(queryOptionsMap);
            
            String leaderRootAccNo = String.valueOf(leaderGenList[0].get('ROOT_UPLN_ACCT_NR__c'));
            Decimal lftId = (Decimal)leaderGenList[0].get('LFT_ND_ID__c');
            Decimal rightId = (Decimal)leaderGenList[0].get('RGT_ND_ID__c');
            Decimal genLevel = (Decimal)leaderGenList[0].get('Genealogy_Level__c');
            
            queryFieldSet.clear();
            
            List<SObject> genealogyList = null;
            
            //get this fields from genealogy
            queryFieldSet.add('MRKT_ACCT_KEY__r.Name');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Representative_Phone__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c');
            queryFieldSet.add('PRSNL_SLS_AMT__c');
            queryFieldSet.add('GRP_UNIT_SLS_AMT__c');
            queryFieldSet.add('GENTRTN_1_ACTV_REP_CNT__c');
            queryFieldSet.add('GRP_APPT_CNT__c');
            queryFieldSet.add('GENRTN_1_LDR_CNT_TXT__c');
            queryFieldSet.add('RSNG_STR_IND__c');
            queryFieldSet.add('LDRSHP_TAR_IND__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR_NUMBER__c');
            queryFieldSet.add('ZONE_MGR_NAME__c');
            queryFieldSet.add('SLS_ZONE_CD__c');
            queryFieldSet.add('BRNCH_SCTN_CD__c');
            queryFieldSet.add('UPLN_ACCT_NR__c');
            queryFieldSet.add('DWNLN_ONLY_IND__c');
            queryFieldSet.add('PD_TITL_LVL_NR__c');
            queryFieldSet.add('ACCT_NR__c');
            queryFieldSet.add('TITL_STUS__c'); // This field added for Title Value Change on 5th Sept, 2013 - Raktim
            queryFieldSet.add('MRKT_INVC_SLS_AMT__c');
            queryFieldSet.add('MRKT_INVC_GRP_SLS_AMT__c');
            
            gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet); 
            
            queryOptionsMap = new Map<String,String>();
            
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            //whereClause = ' FLD_SLS_CMPGN_NR__c = \'' + Double.valueOf(campaignNumber)  + '\' AND LDRSHP_TITL_LVL_NR_NUMBER__c > 0' +
            whereClause = ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + ' AND LDRSHP_TITL_LVL_NR_NUMBER__c > 0' +
                                  ' AND REP_OMS_STUS_CD__c = \'1\' ' +
                                  ' AND Genealogy_Level__c = ' + (genLevel+1) + 
                                  ' AND MRKT_ID__c = \''+ currUser.MRKT_ID__c + '\' ' +
                                  ' AND UPLN_ACCT_NR__c = ' + '\'' + currUser.ACCT_NR__c + '\'';
        
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('ORDER BY','PD_TITL_LVL_NR_NUMBER__c DESC');
            queryOptionsMap.put('LIMIT', this.numberOfRowsToDisplay);
            List<SObject> listSObject = gsb.queryNew(queryOptionsMap);
           
            System.debug('====================== G1SalesLeaders. List of Genealogy : ' + listSObject);
            
            List<Custom_Message__c> messagePool = Database.query(LandingPageUtils.generateQueryCMessages(fieldsCustomMessage, userTypes, titleTypes, currMarket.Id,  'G1SalesLeaders'));
            mapCMessages = LandingPageUtils.initializeMessageMap(messagePool);
            System.debug('====================== Custom Messages: ' );
            LandingPageUtils.debugMap(mapCMessages, 'Custom Message');
          
          
          //populate mapContact to get sponsor name
          if (listSObject.size() > 0) {
            Set<String> setMarketAccountId = new Set<String>();
            for (sObject so : listSObject) {
                  setMarketAccountId.add((currUser.MRKT_ID__c + (String)so.get('UPLN_ACCT_NR__c'))); // can throw type exception
            }
            System.debug('====================== Set of MarketAccountId : ' + setMarketAccountId);
            List<Contact> listContact = [SELECT Name, Id, MRKT_ACCT_KEY__c
                                         FROM Contact
                                         WHERE MRKT_ACCT_KEY__c in :setMarketAccountId];
            LandingPageUtils.debugList(listContact, 'Sponsor');
            if (listContact.size() > 0) {
                mapContact = new Map<String, Contact>();
              for (Contact c : listContact) {
                if (c.MRKT_ACCT_KEY__c != null) {
                  mapContact.put(c.MRKT_ACCT_KEY__c, c);
                }
              }
                LandingPageUtils.debugMap(mapContact, 'Sponsor in map ');
            }
                g1SlsLdr_hasData = populateAttributes(listSObject, mapContact);
          } else {
            g1SlsLdr_hasData = false;
          }
          
          System.debug('====================== G1SalesLeaders. flag hasData = ' + g1SlsLdr_hasData);
          System.debug('====================== G1SalesLeaders. listDownline = ' + listDownline);
                                                                                  
      } catch (Exception e) {
        System.debug('============ EXCEPTION during parameters preparation. Query for Genealogy : ' + query);
        System.debug('========== Probably something happened to genealogy query. Probably attributes population is wrong.');
        System.debug(e.getStackTraceString());
        g1SlsLdr_hasData = false;
            isValid = false;
            exceptionText = e.getMessage();
      }
        
    }
    
    // used in controller. helper method to initialize attributes
    public Boolean populateAttributes(List<SObject> listSObject, Map<String, Contact> mapContact) {
      listDownline = new List<LPDownlineWrapper>();
      LPDownlineWrapper record;
      String risingStartIndicator = '';
      String atRisk = '';
      String tempString = null;
      Decimal tempDecimal = null;
      Leader_Title__c tempLeaderTitle = null;
      Integer tempInt = null;
        String lvlNumberFieldName = null;
      
      //dynamically retrieve values, because exact object is picked dynamically
      if (listSObject != null && listSObject.size() > 0 ) {
        sObject contactObject;
        //sObject personalPerformanceObject;
        //sObject leaderSummaryObject;
          for (SObject sObjectRecord : listSObject) {
            record = new LPDownlineWrapper();
            contactObject = sObjectRecord.getSObject('MRKT_ACCT_KEY__r');
            //personalPerformanceObject = sObjectRecord.getSObject('Personal_Performance_Key__r');
            //leaderSummaryObject = sObjectRecord.getSObject('Leadership_Summary_Key__r');
                
                
                record.accountNumber = (String)sObjectRecord.get('ACCT_NR__c');
            
            //contact information
            if (contactObject != null) {
                record.Name = (String)contactObject.get('Name');
                record.preferredEmail = (String)contactObject.get('REP_EMAIL_ADDR_TXT__c');
                record.preferredPhone = (String)contactObject.get('Representative_Phone__c');
                
            }
            
            //my business information
            
            record.salesVolume = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('MRKT_INVC_SLS_AMT__c'), currencyCharacter);
            atRisk = String.valueOf(sObjectRecord.get('LDRSHP_TAR_IND__c'));
            risingStartIndicator = String.valueOf(sObjectRecord.get('RSNG_STR_IND__c'));
                
            //impersonation or coaching for "View"
            tempString = (String)sObjectRecord.get('DWNLN_ONLY_IND__c');
            record.nameLink = LandingPageUtils.makeCoachOrImperson(tempString, record.accountNumber, originalUrl, pageAllParams);
            System.debug('=========== G1SalesLeaders Controller. Populate Attributes. another NameLink : ' + record.nameLink);
                
            tempLeaderTitle = null;
            lvlNumberFieldName = 'LDRSHP_TITL_LVL_NR__c';
                
            Decimal levelNumber = (Decimal)sObjectRecord.get('LDRSHP_TITL_LVL_NR_NUMBER__c');
            if (levelNumber != null /*&& levelNumber != -2*/) {
                    if (isPrior) {
                        lvlNumberFieldName = 'PD_TITL_LVL_NR__c'; // for prior campaign display title based on paid level number
                    } 
              record.badgeTitle = LandingPageUtils.determineBadgeTitle(mapLeaderTitle, (String)(sObjectRecord.get(lvlNumberFieldName)));
            }
            
            record.branchName = (String)sObjectRecord.get('BRNCH_SCTN_CD__c');
            
            tempString = null;
            if ((tempString = (String)sObjectRecord.get('ZONE_MGR_NAME__c')) != null) {
                record.zoneManager = 'Zone ' + tempString;
            }
            tempString = null;
            if ((tempString = (String)sObjectRecord.get('SLS_ZONE_CD__c')) != null) {
                record.zoneManager = record.zoneManager + '-' + tempString;
            }
            
            if (currUser.MRKT_ID__c == ALMConstants.PHILIPPINES_MARKET_CODE ) {
              record.zoneManager = record.branchName;
              if (record.zoneManager != null) {
                record.zoneManager = 'Branch ' + record.zoneManager;
              }
            }
            
            /** TitleValue change by Raktim on 5th Sept 2013 START **/
            System.debug('\n ======== G1SalesLeader  TITL_STUS__c :: '+(String)sObjectRecord.get('TITL_STUS__c'));
            
            if(sObjectRecord.get('TITL_STUS__c') == null)
            	record.titleValue = '';
            else if(((String)sObjectRecord.get('TITL_STUS__c')).equals(''))
            	record.titleValue = '';
            else
            	record.titleValue = (String)sObjectRecord.get('TITL_STUS__c');
            	
            /** This section is blocked - 5th Sept 2013 START **/
            /*    
            if (risingStartIndicator == 'Y') {
              record.color = LandingPageUtils.CHART_COLOR_GOOD;
              record.badgeTitle = record.badgeTitle ;
              record.titleValue = ALMConstants.RISING_STAR;
            } else if (atRisk == 'Y') {
              record.color = LandingPageUtils.CHART_COLOR_BAD;
              record.badgeTitle = record.badgeTitle; 
              record.titleValue = ALMConstants.AT_RISK;
            } // else no color and no title value
            */
            /** This section is blocked - 5th Sept 2013 END **/ 
            /** TitleValue change by Raktim on 5th Sept 2013 START **/   
                
            // sponsor from account number throgh contact
            record.sponsor = LandingPageUtils.getSponsor(mapContact, currUser.MRKT_ID__c, (String)sObjectRecord.get('UPLN_ACCT_NR__c'));
            
            // leader summary info
           
            record.teamSales = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
            record.g1Actives = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('GENTRTN_1_ACTV_REP_CNT__c'));
            record.teamAppts = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('GRP_APPT_CNT__c'));
            record.g1Leaders = (String)(sObjectRecord.get('GENRTN_1_LDR_CNT_TXT__c'));
           
            record.accountNumber = (String)sObjectRecord.get('ACCT_NR__c');
            
            /**** Changes for MT & MTO icon link from dashboard, by Raktim on 29thJul 2013 - START ****/
            if(myTeamOrdersReportLink.indexOf('acctKey') > -1){
                //record.myTeamOrdersURL = myTeamOrdersReportLink  + '&textSearch=' + record.accountNumber;
                record.myTeamOrdersURL = myTeamOrdersReportLink;//  + record.accountNumber;
                record.myTeamOrdersURL = record.myTeamOrdersURL.replace('acctKey='+currUser.ACCT_NR__c , 'acctKey='+record.accountNumber);
                
            }else
                record.myTeamOrdersURL = myTeamOrdersReportLink  + '&acctKey=' + record.accountNumber; 
            
            if(myTeamReportLink.indexOf('acctKey') > -1){   
                //record.myTeamReportURL = myTeamReportLink + '&textSearch=' + record.accountNumber;
                record.myTeamReportURL = myTeamReportLink;// +  record.accountNumber;
                record.myTeamReportURL = record.myTeamReportURL.replace('acctKey='+currUser.ACCT_NR__c ,'acctKey='+record.accountNumber);
            }else
                record.myTeamReportURL = myTeamReportLink + '&acctKey=' + record.accountNumber;
            /**** Changes for MT & MTO icon link from dashboard, by Raktim on 29thJul 2013 - END ****/
            
            System.debug('\n ======== myTeamOrdersURL G1SalesLeader :: '+record.myTeamOrdersURL);
            System.debug('\n ======== myTeamReportURL G1SalesLeader :: '+record.myTeamReportURL);              
            
                
            listDownline.add(record);
          }
      } else {
        return false;
      }
        
        //populate custom message
        String [] textUrl  = new String[2];
        LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, messageName, textUrl) ;
        messageText = textUrl[0];
        messageUrl = textUrl[1];
      
      return true;
    }
    
}