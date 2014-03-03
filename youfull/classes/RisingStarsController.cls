/*
** Apex Class/Controller Name           : RisingStarsController
** VF Pages associated [Names]          : RisingStartComponent
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for component RisingStars on Landing Page. Inherits from ComponentController.
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** March 13, 2012. Created
** 
*/

// TODO - Check why MAP LAder Title / Exec  - RITIKA

public class RisingStarsController extends ComponentController {
  
  public List<LPDownlineWrapper> listRisingStar {get; set;}
    public Boolean rsngStrs_hasData {get; set;}
    
    
    public String messageText {get; set;}  // Custom Message for rising star
    public String messageUrl {get; set;}  // Custom Message for rising star
    private Decimal leaderExecGen {get; set;}
  
  private String messageName = ALMConstants.RR_MESSAGE_NAME;
    
  //controller called when component loaded
  public RisingStarsController() {
    
    // use special util class to generate genealogy queries
         
        Set<String> queryFieldSet = new Set<String>();
        List<SObject> genealogyList = null;
        
        try {
            
            // First Get leader's Record, and use the Left and Right Identifiers to fetch the downline
            
            
            queryFieldSet.add('LFT_ND_ID__c');
            queryFieldSet.add('ROOT_UPLN_ACCT_NR__c');
            queryFieldSet.add('RGT_ND_ID__c');
            queryFieldSet.add('EXEC_GEN_INDX__c');
            GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet);
            //String whereClause =  ' OPERTNL_CMPGN_NR__c = \'' + campaignNumber  + '\' ' + 
            String whereClause =  ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + 
                                  ' AND MRKT_ID__c = \'' + currUser.MRKT_ID__c + '\' ' +
                                  ' AND ACCT_NR__c = ' + '\'' + currUser.ACCT_NR__c + '\'';
            
            
            Map<String,String> queryOptionsMap = new Map<String,String>();
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('LIMIT', '1');
            
            List<SObject> leaderGenList = gsb.queryNew(queryOptionsMap);
            
            String leaderRootAccNo = String.valueOf(leaderGenList[0].get('ROOT_UPLN_ACCT_NR__c'));
            leaderExecGen = (Decimal)leaderGenList[0].get('EXEC_GEN_INDX__c');
            Decimal lftId = (Decimal)leaderGenList[0].get('LFT_ND_ID__c');
            Decimal rightId = (Decimal)leaderGenList[0].get('RGT_ND_ID__c');
            
            queryFieldSet.clear();
            //get this fields from genealogy
            queryFieldSet.add('EXEC_GEN_INDX__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Name');
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Representative_Phone__c');
            queryFieldSet.add('GRP_UNIT_SLS_AMT__c');
            queryFieldSet.add('GRP_BLCKD_UNIT_SLS_AMT__c');
            queryFieldSet.add('GENTRTN_1_ACTV_REP_CNT__c');
            queryFieldSet.add('GRP_APPT_CNT__c');    
            queryFieldSet.add('TTL_LEG_CNT__c');     
            queryFieldSet.add('GENRTN_1_LDR_CNT_TXT__c');
            queryFieldSet.add('PRSNL_SLS_AMT__c'); 
            queryFieldSet.add('RSNG_STR_IND__c');
            queryFieldSet.add('PD_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TAR_IND__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR_NUMBER__c');
            queryFieldSet.add('ZONE_MGR_NAME__c');
            queryFieldSet.add('SLS_ZONE_CD__c');
            queryFieldSet.add('TITL_STUS__c');
            queryFieldSet.add('BRNCH_SCTN_CD__c');
            queryFieldSet.add('UPLN_ACCT_NR__c');
            queryFieldSet.add('DWNLN_ONLY_IND__c');
            queryFieldSet.add('ACCT_NR__c');
            
            //gsb.queryFieldSet = queryFieldSet;
            
            gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet);
            
            //get leader titles numbers where exec index = 1
            //and add them to the query
            
            List<String> execLeaderTitleList = LandingPageUtils.returnOnlyLeadersNumbers(mapLeaderTitle.values());
            system.debug('=============== ' +  execLeaderTitleList);
            String whereBadgeTitle = ' ';
            for (String str : execLeaderTitleList) {
                  whereBadgeTitle = whereBadgeTitle + 'LDRSHP_TITL_LVL_NR__c = \'' + str + '\' OR ';
            }
            System.debug('====================== Rising Stars. WhereBadgeTitle clause = ' + whereBadgeTitle);
            if(whereBadgeTitle.length() > 3){
                whereBadgeTitle = whereBadgeTitle.substring(0, whereBadgeTitle.length() - 3);
            }
            
            
            // filtering clauses for genealogy query
            //whereClause = 'OPERTNL_CMPGN_NR__c = \'' + campaignNumber  + '\' AND ( ' + whereBadgeTitle +
            //whereClause = 'OPERTNL_CMPGN_NR__c = \'' + campaignNumber  + '\' AND ( ' + whereBadgeTitle + ' OR (RSNG_STR_IND__c = \'Y\' OR EXEC_RSNG_STR_IND__c = \'Y\') ) ' +
            whereClause = 'FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + ' AND ( ' + whereBadgeTitle + ' OR (RSNG_STR_IND__c = \'Y\' OR EXEC_RSNG_STR_IND__c = \'Y\') ) ' +
                                  ' AND ROOT_UPLN_ACCT_NR__c = ' + '\'' + leaderRootAccNo + '\'' + 
                                  ' AND LFT_ND_ID__c > ' + lftId  + 
                                  ' AND RGT_ND_ID__c < ' + rightId +
                                  ' AND MRKT_ID__c = \''+currUser.MRKT_ID__c+'\'' ;
            
            queryOptionsMap = new Map<String,String>();
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('ORDER BY','EXEC_GEN_INDX__c, LDRSHP_TITL_LVL_NR__c DESC');
            queryOptionsMap.put('LIMIT', this.numberOfRowsToDisplay);
            
            System.debug('====queryOptionsMap====' + queryOptionsMap);
            
            genealogyList = gsb.queryNew(queryOptionsMap);
            System.debug('====================== Rising Stars. WhereBadgeTitle clause = ' + whereBadgeTitle);
            
            System.debug('============ RisingStars. Genealogy List is : ' + genealogyList);
            LandingPageUtils.debugList(genealogyList, 'Genealogy');
            
            List<Custom_Message__c> messagePool = Database.query(LandingPageUtils.generateQueryCMessages(fieldsCustomMessage, userTypes, titleTypes, currMarket.Id,  'RisingStars'));
            mapCMessages = LandingPageUtils.initializeMessageMap(messagePool);
            LandingPageUtils.debugMap(mapCMessages, 'Custom Message');
            
          //populate mapContact to get sponsor name
          if (genealogyList.size() > 0) {
            Set<String> setMarketAccountId = new Set<String>();
            for (sObject so : genealogyList) {
              //if (so.getSObject('Personal_Performance_Key__r') != null) {
                  setMarketAccountId.add((currUser.MRKT_ID__c + (String)so.get('UPLN_ACCT_NR__c'))); 
              //}
            }
            List<Contact> listContact = [SELECT Name, Id, MRKT_ACCT_KEY__c
                                         FROM Contact
                                         WHERE MRKT_ACCT_KEY__c in :setMarketAccountId];
            if (listContact.size() > 0) {
                mapContact = new Map<String, Contact>();
              for (Contact c : listContact) {
                if (c.MRKT_ACCT_KEY__c != null) {
                  mapContact.put(c.MRKT_ACCT_KEY__c, c);
                }
              }
              
              System.debug('================================ RisingStars. Map of Gen1 Contacts : ' + mapContact);
            }
                rsngStrs_hasData = populateAttributes(genealogyList, mapContact);
                
                System.debug('====================== RisingStars. List of Rising Stars: ' + listRisingStar);
          } else {
            rsngStrs_hasData = false;
          }
        } catch (Exception e) {
            isValid = false;
            exceptionText = e.getMessage();
        }
  }
  
  public Boolean populateAttributes(List<SObject> listSObject, Map<String, Contact> mapContact) {
      listRisingStar = new List<LPDownlineWrapper>();
      LPDownlineWrapper record;
      String risingStartIndicator = '';
      String atRisk = '';
      String tempString = null;
      Decimal tempDecimal = null;
      Leader_Title__c tempLeaderTitle = null;
      Integer tempInt = null;
      Decimal levelNumber = null;
      String lvlNumberFieldName = null;
      
      //dynamically retrieve values, because exact object is picked dynamically
      if (listSObject != null && listSObject.size() > 0 ) {//&& fields != null && fields.size() > 0) {
          sObject contactObject;
        //sObject personalPerformanceObject;
        //sObject leaderSummaryObject;
          for (SObject sObjectRecord : listSObject) {
                record = new LPDownlineWrapper();
                contactObject = sObjectRecord.getSObject('MRKT_ACCT_KEY__r');
                //personalPerformanceObject = sObjectRecord.getSObject('Personal_Performance_Key__r');
                //leaderSummaryObject = sObjectRecord.getSObject('');
                
                if (contactObject != null) {
                    record.Name = (String)contactObject.get('Name');
                    record.preferredEmail = (String)contactObject.get('REP_EMAIL_ADDR_TXT__c');
                    record.preferredPhone = (String)contactObject.get('Representative_Phone__c');
                    record.accountNumber = (String)sObjectRecord.get('ACCT_NR__c');
                    
                }
                
                if(sObjectRecord.get('EXEC_GEN_INDX__c') != null && leaderExecGen != null){
                    system.debug(sObjectRecord.get('EXEC_GEN_INDX__c'));
                    system.debug(leaderExecGen);
                    
                    record.executiveGen = LandingPageUtils.returnDecToString( (Decimal)sObjectRecord.get('EXEC_GEN_INDX__c') - leaderExecGen);
                }
                lvlNumberFieldName = 'LDRSHP_TITL_LVL_NR__c';
                
                //impersonation or coaching for "View"
                tempString = (String)sObjectRecord.get('DWNLN_ONLY_IND__c');
                record.nameLink = LandingPageUtils.makeCoachOrImperson(tempString, record.accountNumber, originalUrl, pageAllParams);
                record.salesVolume = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('MRKT_INVC_SLS_AMT__c'), currencyCharacter);
                levelNumber = (Decimal)sObjectRecord.get('LDRSHP_TITL_LVL_NR_NUMBER__c');
                      
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
                record.titleValue = (String)sObjectRecord.get('TITL_STUS__c'); 
                System.debug('\n ######### Rising Star Controller record.titleValue --> '+record.titleValue); 
                
                if(sObjectRecord.get('TITL_STUS__c') == null)
                	record.titleValue = '';
                else if(((String)sObjectRecord.get('TITL_STUS__c')).equals(''))
            		record.titleValue = '';
            	else
            		record.titleValue = (String)sObjectRecord.get('TITL_STUS__c');
                
                /** This section is blocked - 5th Sept 2013 START **/
            	/* 
                if (record.titleValue != null) {
                    if (record.titleValue == ALMConstants.AT_RISK || record.titleValue == ALMConstants.EXEC_RISING_STAR) {
                          record.color = LandingPageUtils.CHART_COLOR_GOOD;
                    } else if (record.titleValue == ALMConstants.RISING_STAR) {
                          record.color = LandingPageUtils.CHART_COLOR_BAD;
                    }
                }
                */
                /** This section is blocked - 5th Sept 2013 END **/
                
                /** TitleValue change by Raktim on 5th Sept 2013 END **/
                
            
                //sponsor
                record.sponsor = LandingPageUtils.getSponsor(mapContact, currUser.MRKT_ID__c, (String)sObjectRecord.get('UPLN_ACCT_NR__c'));
                record.unitSales = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
                record.blockedUnitSales = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('GRP_BLCKD_UNIT_SLS_AMT__c'), currencyCharacter);
                record.g1Actives = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('GENTRTN_1_ACTV_REP_CNT__c'));
                record.g1Leaders = (String)(sObjectRecord.get('GENRTN_1_LDR_CNT_TXT__c'));
                record.titledLegs = LandingPageUtils.returnDecToString((Decimal)(sObjectRecord.get('TTL_LEG_CNT__c')));
                // sponsor from account number throgh contact
                
                /**** Changes for MT & MTO icon link from dashboard, by Raktim on 29thJul 2013 - START ****/
                if(myTeamOrdersReportLink.indexOf('acctKey') > -1){
                    //record.myTeamOrdersURL = myTeamOrdersReportLink  + '&textSearch=' + record.accountNumber;
                    record.myTeamOrdersURL = myTeamOrdersReportLink  +  record.accountNumber;
                    record.myTeamOrdersURL = record.myTeamOrdersURL.replace('acctKey='+currUser.ACCT_NR__c , 'acctKey='+record.accountNumber);              
                }else
                    record.myTeamOrdersURL = myTeamOrdersReportLink  + '&acctKey=' + record.accountNumber;
                
                if(myTeamReportLink.indexOf('acctKey') > -1){   
                    //record.myTeamReportURL = myTeamReportLink + '&textSearch=' + record.accountNumber;
                    record.myTeamReportURL = myTeamReportLink + record.accountNumber;
                    record.myTeamReportURL = record.myTeamReportURL.replace('acctKey='+currUser.ACCT_NR__c , 'acctKey='+record.accountNumber);
                }else
                    record.myTeamReportURL = myTeamReportLink + '&acctKey=' + record.accountNumber;
                /**** Changes for MT & MTO icon link from dashboard, by Raktim on 29thJul 2013 - END ****/
                
                System.debug('\n ======== myTeamOrdersURL RisingStar :: '+record.myTeamOrdersURL);
                System.debug('\n ======== myTeamReportURL RisingStar :: '+record.myTeamReportURL);
            
                listRisingStar.add(record);
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
    
    public class InvalidDataException extends Exception {
    }
}