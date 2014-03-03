/*
** Apex Class/Controller Name           : G1CandidatesController
** VF Pages associated [Names]          : G1CandidatesComponent
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for component G1Candidates on Landing Page. Inherits from ComponentController.
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** April 18, 2012. Created
** 
*/

//TODO - Determine if Left and Right Ids are at all required in the query to fetch data on this page - RITIKA

public class G1CandidatesController extends ComponentController {

  public List<LPDownlineWrapper> listCandidate {get; set;}
    public Boolean g1Cndt_hasData {get; set;}
    
    public String messageText {get; set;}  // Custom Message for rising star
    public String messageUrl {get; set;}  // Custom Message for rising star
    public Integer g1CandidtEachRowHeight {get; set;} // variable added - Scroll height change by Raktim on 25th Sept 2013
  
  private String messageName = ALMConstants.G1CAN_MESSAGE_NAME ;
  
  //controller called when component loaded
  public G1CandidatesController() {
    // use special util class to generate genealogy queries
    initializeReport();    
  }
  
  public void initializeReport(){
        g1CandidtEachRowHeight = this.eachRowHeight;  // Scroll height change by Raktim on 25th Sept 2013
        Set<String> queryFieldSet = new Set<String>();
        List<SObject> genealogyList = null;
        try {
            
            System.debug('\n ======== isMailPln '+isMailPln);
            queryFieldSet.add('LFT_ND_ID__c');
            queryFieldSet.add('ROOT_UPLN_ACCT_NR__c');
            queryFieldSet.add('Genealogy_Level__c');
            queryFieldSet.add('RGT_ND_ID__c');
            GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet);
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
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
            
            //get this fields from genealogy
            queryFieldSet.add('MRKT_ACCT_KEY__r.Name');
            queryFieldSet.add('MRKT_ACCT_KEY__r.FirstName');
            queryFieldSet.add('MRKT_ACCT_KEY__r.LastName');
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Representative_Phone__c');
            queryFieldSet.add('GRP_UNIT_SLS_AMT__c');
            queryFieldSet.add('GENRTN_1_QPA_CNT__c');
            queryFieldSet.add('GENTRTN_1_ACTV_REP_CNT__c');
            queryFieldSet.add('GRP_APPT_CNT__c');    
            queryFieldSet.add('GENRTN_1_APPT_CNT__c');
            queryFieldSet.add('PRSNL_SLS_AMT__c'); 
            queryFieldSet.add('RSNG_STR_IND__c');
            queryFieldSet.add('LDRSHP_TAR_IND__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR_NUMBER__c');
            queryFieldSet.add('ZONE_MGR_NAME__c');
            queryFieldSet.add('SLS_ZONE_CD__c');
            queryFieldSet.add('TITL_STUS__c');
            queryFieldSet.add('BRNCH_SCTN_CD__c');
            queryFieldSet.add('UPLN_ACCT_NR__c');
            queryFieldSet.add('PD_TITL_LVL_NR__c');
            queryFieldSet.add('DWNLN_ONLY_IND__c');
            queryFieldSet.add('ACCT_NR__c');
            queryFieldSet.add('MRKT_INVC_SLS_AMT__c');
            queryFieldSet.add('MRKT_INVC_GRP_SLS_AMT__c');
            
            // Mail Plan Addition - by Raktim on 7th Aug 2013 Start
            if( isMailPln )
                queryFieldSet.add('MailPlan_Order_Oppty__r.MLPLN_CD__c');
            // Mail Plan Addition - by Raktim on 7th Aug 2013 END
            
            gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet); 
            //gsb.queryFieldSet = queryFieldSet;
            
            // filtering clauses for genealogy query
          /*  String whereClause = 'CMPGN_NR__c = \'' + campaignNumber  + '\' AND LDRSHP_TITL_LVL_NR__c = \'0\'' +
                                  //(isPrior ? 'PD_TITL_LVL_NR__c' : 'LDRSHP_TITL_LVL_NR__c') + ' = \'0\'' +  CONSIDER UNCOMMENT
                                  'AND UPLN_GEN_INDX__c = 1 ' + //AND MRKT_ID__c = \''+ currUser.MRKT_ID__c + '\' ' +
                                  'AND UPLN_ACCT_NR__c = ' + '\'' + currUser.ACCT_NR__c + '\''; */
                                  
            //modified by Snehashis for testing
            whereClause = ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + ' AND LDRSHP_TITL_LVL_NR__c = \'0\'' +
                                  ' AND Genealogy_Level__c = ' + (genLevel+1) + 
                                  ' AND MRKT_ID__c = \''+ currUser.MRKT_ID__c + '\' ' +
                                  ' AND UPLN_ACCT_NR__c = ' + '\'' + currUser.ACCT_NR__c + '\'';
        
            queryOptionsMap = new Map<String,String>();
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('ORDER BY','CTD_AWRD_SLS_AMT__c DESC');
            queryOptionsMap.put('LIMIT', this.numberOfRowsToDisplay );
            
            genealogyList = gsb.queryNew(queryOptionsMap);
            
            System.debug('============ G1Candidates. Genealogy List is : ' + genealogyList);
            LandingPageUtils.debugList(genealogyList, 'Genealogy');
            
            List<Custom_Message__c> messagePool = Database.query(LandingPageUtils.generateQueryCMessages(fieldsCustomMessage, userTypes, titleTypes, currMarket.Id,  'G1Candidates'));
            mapCMessages = LandingPageUtils.initializeMessageMap(messagePool);
            LandingPageUtils.debugMap(mapCMessages, 'Custom Message');
            
          //populate mapContact to get sponsor name
          if (genealogyList.size() > 0) {
            Set<String> setMarketAccountId = new Set<String>();
            for (sObject so : genealogyList) {
                  setMarketAccountId.add((currUser.MRKT_ID__c + (String)so.get('UPLN_ACCT_NR__c'))); 
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
              
              System.debug('================================ G1Candidates. Map of Gen1 Contacts : ' + mapContact);
            }
                g1Cndt_hasData = populateAttributes(genealogyList, mapContact);
                
                System.debug('====================== G1Candidates. List of G1Candidates: ' + listCandidate);
          } else {
            g1Cndt_hasData = false;
          }
        } catch(Exception e) {
            isValid = false;
            exceptionText = e.getMessage();
        }
  }
    
    public Boolean populateAttributes(List<SObject> listSObject, Map<String, Contact> mapContact) {
      listCandidate = new List<LPDownlineWrapper>();
      LPDownlineWrapper record;
      String risingStartIndicator = '';
      String atRisk = '';
      String tempString = null;
      Decimal tempDecimal = null;
      Leader_Title__c tempLeaderTitle = null;
      Integer tempInt = null;
      Decimal levelNumber = null;
        String localLeaderLevel = null;
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
                //leaderSummaryObject = sObjectRecord.getSObject('Leadership_Summary_Key__r');
                
                if (contactObject != null) {
                    record.Name = (String)contactObject.get('Name');
                    record.preferredEmail = (String)contactObject.get('REP_EMAIL_ADDR_TXT__c');
                    record.preferredPhone = (String)contactObject.get('Representative_Phone__c');
                    record.accountNumber = (String)sObjectRecord.get('ACCT_NR__c');
                    
                }
                
                lvlNumberFieldName = 'LDRSHP_TITL_LVL_NR__c';
                //impersonation or coaching for "View"
                tempString = (String)sObjectRecord.get('DWNLN_ONLY_IND__c');
                record.nameLink = LandingPageUtils.makeCoachOrImperson(tempString, record.accountNumber, originalUrl, pageAllParams);
                System.debug('=========== G1Appointments Controller. Populate Attributes. another NameLink : ' + record.nameLink);
                        
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
                    //record.zoneManager = 'Zone ' + tempString;
                    
                    // Mail Plan Change - by Raktim on 7th Aug 2013 START
                    if(isBranch)
                        record.zoneManager = System.label.Branch_Name + ' '+tempString;
                    else
                        record.zoneManager = System.label.Zone + ' ' + tempString;
                    // Mail Plan Change - by Raktim on 7th Aug 2013 END
                }
                tempString = null;
                if ((tempString = (String)sObjectRecord.get('SLS_ZONE_CD__c')) != null) {
                    //record.zoneManager = record.zoneManager + '-' + tempString;
                   // record.zoneManager =  tempString;
                    record.zoneManager = System.label.Zone + ' ' + tempString;  //change by Dipak on 23102013 to add label Zone(QC#3186)
                }
                
                /**  This code is commented for Mail Plan Change - by Raktim on 7th Aug 2013 START**/
                /*
                if (currUser.MRKT_ID__c == ALMConstants.PHILIPPINES_MARKET_CODE ) {
                  record.zoneManager = record.branchName;
                  if (record.zoneManager != null) {
                    record.zoneManager = 'Branch ' + record.zoneManager;
                  }
                }
                */
                /**  This code is commented for Mail Plan Change - by Raktim on 7th Aug 2013 END **/
                
                
                  
                  /** TitleValue change by Raktim on 5th Sept 2013 START **/  
                  System.debug('\n ======== G1 Candidate Title Status  '+(String)sObjectRecord.get('TITL_STUS__c'));   
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
                  
                  
                    
                    // sponsor from account number throgh contact
                    record.sponsor = LandingPageUtils.getSponsor(mapContact, currUser.MRKT_ID__c, (String)sObjectRecord.get('UPLN_ACCT_NR__c'));
                    record.qualifiedPersAppts = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('GENRTN_1_QPA_CNT__c'));
                    record.personalAppts = LandingPageUtils.returnDecToString((Decimal)(sObjectRecord.get('GENRTN_1_APPT_CNT__c') ));
                    record.unitSales = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('MRKT_INVC_GRP_SLS_AMT__c'), currencyCharacter);
                    record.g1Actives = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('GENTRTN_1_ACTV_REP_CNT__c'));
                    
                    /**** Changes for MT & MTO icon link from dashboard, by Raktim on 29thJul 2013 - START ****/
                    if(myTeamOrdersReportLink.indexOf('acctKey') > -1){
                        //record.myTeamOrdersURL = myTeamOrdersReportLink  + '&textSearch=' + record.accountNumber;
                        record.myTeamOrdersURL = myTeamOrdersReportLink  + record.accountNumber;
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
                    
                    System.debug('\n ======== myTeamOrdersURL G1Candidates :: '+record.myTeamOrdersURL);
                    System.debug('\n ======== myTeamReportURL G1Candidates :: '+record.myTeamReportURL);
                    
                    // Mail Plan Addition - by Raktim on 7th Aug 2013 Start 
                    try{
                        record.mailPlanCode = (String)sObjectRecord.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c');
                        //System.debug('\n ======== GOT mailPlanCode '+mailPlanCode);
                    }catch(Exception e){
                        System.debug('\n ======== GOT EXCEPTION '+e);
                        record.mailPlanCode = '';
                    }
                    // Mail Plan Addition - by Raktim on 7th Aug 2013 END
                   System.debug('\n ======== GOT zoneManager '+record.zoneManager);
                listCandidate.add(record);
          }
          
      } else {
        return false;
      }
      
      
        //populate custom message
        String [] textUrl  = new String[2];
        LandingPageUtils.populateCustomMessageAndUrl(mapCMessages, leaderLevel, messageName, textUrl) ;
        //System.debug('====================== G1Candidates. MessageText : ' + messageText);
        //System.debug('====================== G1Candidates. isMessagePrsnt FIRST : ' + isMessagePrsnt);
        messageText = textUrl[0];
        messageUrl = textUrl[1];
        
      return true;
    }
    
}