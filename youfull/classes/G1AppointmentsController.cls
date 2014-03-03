/*
** Apex Class/Controller Name           : G1AppointmentsController
** VF Pages associated [Names]          : G1AppointmentsComponent
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for component G1Appointments on Landing Page. Inherits from ComponentController.
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** April 18, 2012. Created
** 
*/

//TODO - Determine if Left and Right Ids are at all required in the query to fetch data on this page - RITIKA

public class G1AppointmentsController extends ComponentController {
    public List<LPDownlineWrapper> listAppointment {get; set;}
    public Boolean g1Aptnmt_hasData {get; set;}
    public Integer g1EachRowHeight {get; set;} //added by ag 25-Sept
    
    public String messageText {get; set;}  // Custom Message for G1 appointments
    public String messageUrl {get; set;}  // Custom Message for g1 appointments
    
    private String messageName = ALMConstants.G1APP_MESSAGE_NAME ;
    
    public Boolean isPHMarkt {get; set;}
        
    //controller called when component loaded
    public G1AppointmentsController() {
        
        isPHMarkt = false;
        initializeReport();
        
    }
    
    public void initializeReport(){
        
        DateTime marketCampaignStartDate;
        String marketCampaignStartDateString;
        Decimal marketSponsorAmount;
        g1EachRowHeight = this.eachRowHeight;
        String prevCampaign = ''; // variable added by Raktim for G1 Appt dashboard change on 26th Sept 2013
        
        try {
            
            if (currMarket != null) {
                marketCampaignStartDate = currMarket.CMPGN_STRT_DT__c;
                System.debug('\n ##### currencyCharacter @@@ '+currencyCharacter);
                if (marketCampaignStartDate != null) {
                    marketCampaignStartDateString = (marketCampaignStartDate + 1).format('yyyy-MM-dd');
                }
                marketSponsorAmount = currMarket.SPONSOR_QLFYING_ORD_AMT__c;
            }
            
            // use special util class to generate genealogy queries
            
            Set<String> queryFieldSet = new Set<String>();
            
            // First Get leader's Record, and use the Left and Right Identifiers to fetch the downline
            
            
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
            
            List<SObject> genealogyList = null;
            
            //get this fields from genealogy
            queryFieldSet.add('MRKT_ACCT_KEY__r.Name');
            queryFieldSet.add('MRKT_ACCT_KEY__r.FirstName');
            queryFieldSet.add('MRKT_ACCT_KEY__r.LastName');
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Representative_Phone__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.CONVRSN_DT__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.PATD_CERTFCTN_LVL_A_IND__c');
            
            // New field added , CR : 2413 on 08Mar, 2013 by Raktim
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_APPT_DT__c');
            // End of Addition
            
             // New field added , 23Sept, 2013 by Milon
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_APPT_CMPGN_NR__c');
            // End of Addition
            
            queryFieldSet.add('GRP_UNIT_SLS_AMT__c');
            queryFieldSet.add('GENTRTN_1_ACTV_REP_CNT__c');
            queryFieldSet.add('GRP_APPT_CNT__c');    
            
            queryFieldSet.add('REP_APPT_CMPGN_NR__c');
            queryFieldSet.add('REP_APPT_CMPGN_NR_NUMBER__c');
            queryFieldSet.add('REP_OMS_STUS_CD__c');
            queryFieldSet.add('FRST_ORDR_AMT__c');
            queryFieldSet.add('FRST_ORDER_DUE_DT__c');
            queryFieldSet.add('FRST_ORD_REQ_DT__c');
            queryFieldSet.add('FRST_ORDR_DT__c');
            queryFieldSet.add('FRST_ORDR_PD_DT__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR_NUMBER__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR__c');
            
            queryFieldSet.add('GENRTN_1_QPA_CNT__c');
            queryFieldSet.add('GENRTN_1_APPT_CNT__c');
            queryFieldSet.add('PRSNL_SLS_AMT__c'); 
            queryFieldSet.add('RSNG_STR_IND__c');
            queryFieldSet.add('PD_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TAR_IND__c');
            queryFieldSet.add('ZONE_MGR_NAME__c');
            queryFieldSet.add('SLS_ZONE_CD__c');
            queryFieldSet.add('TITL_STUS__c');
            queryFieldSet.add('BRNCH_SCTN_CD__c');
            queryFieldSet.add('UPLN_ACCT_NR__c');
            queryFieldSet.add('DWNLN_ONLY_IND__c');
            
            // New field added , CR : 2413 on 08Mar, 2013 by Raktim
            //queryFieldSet.add('QPA_Achievement__c');
            queryFieldSet.add('Qualified_Candidate_Value__c');
            // End of Addition
            
            queryFieldSet.add('ACCT_NR__c');
            queryFieldSet.add('Genealogy_Level__c');
            
            // Mail Plan Addition - by Raktim on 7th Aug 2013 Start
            if( isMailPln )
                queryFieldSet.add('MailPlan_Order_Oppty__r.MLPLN_CD__c');
            // Mail Plan Addition - by Raktim on 7th Aug 2013 END
            
            gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet); 
            //gsb.queryFieldSet = queryFieldSet;
            
            // filtering clauses for genealogy query 
            //using FLD_SLS_CMPGN_NR__c instead of OPERTNL_CMPGN_NR__c in the query
            
            /** Query modified as per mail from Business - by Raktim on 25th Sept 2013 START **/
            /** Query modified again as per mail from Business - by Raktim on 26th Sept 2013 **/
            /*
            whereClause = ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + ' AND UPLN_ACCT_NR__c = \'' + currUser.ACCT_NR__c + '\'' +
                                  ' AND MRKT_ID__c = \''+ currUser.MRKT_ID__c + '\' ' +
                                  ' AND Genealogy_Level__c = '+(genLevel+1)+' AND (REP_OMS_STUS_CD__c = \'-2\' ' +
                                  ' OR (REP_OMS_STUS_CD__c = \'1\' ' + 
                                        'AND ( REP_APPT_CMPGN_NR_NUMBER__c = ' + campaignNumber + 
                                            ' OR (REP_APPT_CMPGN_NR_NUMBER__c < ' + campaignNumber + 
                                                ' AND FRST_ORDR_AMT__c > ' + marketSponsorAmount  +
                                                ' AND FRST_ORDER_DUE_DT__c > ' + marketCampaignStartDateString +
                                                ')'+
                                             ')'+
                                        ')' +
                                  ')';
            */ 
            
            /*
            whereClause = ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + ' AND UPLN_ACCT_NR__c = \'' + currUser.ACCT_NR__c + '\'' +
                                  ' AND MRKT_ID__c = \''+ currUser.MRKT_ID__c + '\' ' +
                                  ' AND Genealogy_Level__c = '+(genLevel+1)+' AND (REP_OMS_STUS_CD__c = \'-2\' ' +
                                  ' OR (REP_OMS_STUS_CD__c = \'1\' ' + 
                                        'AND REP_APPT_CMPGN_NR_NUMBER__c < ' + campaignNumber + 
                                                ' AND FRST_ORDR_AMT__c > ' + marketSponsorAmount  +
                                                ' AND FRST_ORDER_DUE_DT__c > ' + marketCampaignStartDateString +
                                                ')'+
                                             ')';
           */
           
           whereClause = ' FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaignNumber)  + ' AND UPLN_ACCT_NR__c = \'' + currUser.ACCT_NR__c + '\'' +
                                  ' AND MRKT_ID__c = \''+ currUser.MRKT_ID__c + '\' ' +
                                  ' AND Genealogy_Level__c = '+(genLevel+1)+' AND ';
                      
           if(!isQPAEnabled){
	           	System.debug('===== G1Appointments. NOT isQPAEnabled BLOCK ');
	           	Calendar__c calndr	= [SELECT CMPGN_NR__c FROM Calendar__c WHERE CMPGN_NR__c < :Double.valueOf(campaignNumber) 
	           						   AND MRKT_ID__c = :currUser.MRKT_ID__c ORDER by CMPGN_NR__c desc LIMIT 1];
	            if(calndr != null){
	            	prevCampaign = String.valueOf(calndr.CMPGN_NR__c);
	            }else{
	            	System.debug('===== G1Appointments. Campaign Prior to Selected Campaign CALENDER RECORD NULL. Setting Default ..');
	            	prevCampaign = String.valueOf(Integer.valueOf(campaignNumber) - 1);
	            }
	            System.debug('===== G1Appointments. Campaign Prior to Selected Campaign = ' + calndr.CMPGN_NR__c); 
	            
	            whereClause+= '(REP_OMS_STUS_CD__c = \'-2\' ' +
        							'OR (REP_OMS_STUS_CD__c = \'1\'  '+
                						'AND  REP_APPT_CMPGN_NR_NUMBER__c >= '+ prevCampaign +
                				')) ';
	            
           }else{
           		System.debug('===== G1Appointments. isQPAEnabled BLOCK ');
           		whereClause+= '(REP_OMS_STUS_CD__c = \'-2\' ' +
                                  ' OR (REP_OMS_STUS_CD__c = \'1\' ' + 
                                        'AND ( REP_APPT_CMPGN_NR_NUMBER__c = ' + campaignNumber + 
                                            ' OR (REP_APPT_CMPGN_NR_NUMBER__c < ' + campaignNumber + 
                                                ' AND FRST_ORDR_AMT__c > ' + marketSponsorAmount  +
                                                ' AND FRST_ORDER_DUE_DT__c > ' + marketCampaignStartDateString +
                                                ')'+
                                             ')'+
                                        ')' +
                                  ') ';
           }
           
            /** Query modified as per mail from Business - by Raktim on 25th Sept 2013 END **/ 
            /** Query modified again as per mail from Business - by Raktim on 26th Sept 2013 END **/
                                 
            queryOptionsMap = new Map<String, String>();
            
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('ORDER BY','MRKT_ACCT_KEY__r.REP_APPT_DT__c DESC');
            queryOptionsMap.put('LIMIT', this.numberOfRowsToDisplay);
            
            //user utility class to generate and execute query
            System.debug('====================== G1Appointments. WhereClause = ' + whereClause);
            genealogyList = gsb.queryNew(queryOptionsMap);
            
            System.debug('============ G1Appointments. Genealogy List is : ' + genealogyList);
            LandingPageUtils.debugList(genealogyList, 'Genealogy');
            
            List<Custom_Message__c> messagePool = Database.query(LandingPageUtils.generateQueryCMessages(fieldsCustomMessage, userTypes, titleTypes, currMarket.Id,  'G1Appointments'));
            mapCMessages = LandingPageUtils.initializeMessageMap(messagePool);
            System.debug('====================== Custom Messages: ' );
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
                    
                    System.debug('================================ G1Appointments. Map of Gen1 Contacts : ' + mapContact);
                }
                
                g1Aptnmt_hasData = populateAttributes(genealogyList, mapContact);
                
                System.debug('====================== G1Appointments. List of G1Appointments: ' + listAppointment);
            } else {
                g1Aptnmt_hasData = false;
            }
        
        } catch(Exception e) {
            isValid = false;
            exceptionText = e.getMessage();
        }
        
        
    }
    
    // populate sections with numbers and strings
    public Boolean populateAttributes(List<SObject> listSObject, Map<String, Contact> mapContact) {
        listAppointment = new List<LPDownlineWrapper>();
        LPDownlineWrapper record;
        String red = LandingPageUtils.CHART_COLOR_BAD;
        String green = LandingPageUtils.CHART_COLOR_GOOD; 
        String oms_stus = null;
        String tempString = null;
        String repCampaignNumber = null;
        Decimal tempDecimal = null;
        Leader_Title__c tempLeaderTitle = null;
        Integer tempInt = null;
        Decimal levelNumber = null;
        String lvlNumberFieldName = null;
        
        //dynamically retrieve values, because exact object is picked dynamically
        if (listSObject != null && listSObject.size() > 0 ) {
            sObject contactObject;
            //sObject personalPerformanceObject;
            
            // loop creating list of apponintments 
            for (SObject sObjectRecord : listSObject) {
                record = new LPDownlineWrapper();
                contactObject = sObjectRecord.getSObject('MRKT_ACCT_KEY__r');
                //personalPerformanceObject = sObjectRecord.getSObject('Personal_Performance_Key__r');
                
                System.debug('contactObject --> '+contactObject);
                
                record.accountNumber = (String)sObjectRecord.get('ACCT_NR__c');
                record.generation = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('Genealogy_Level__c'));
                
                // contact information
                if (contactObject != null) {
                    record.Name = (String)contactObject.get('Name');
                    record.preferredEmail = (String)contactObject.get('REP_EMAIL_ADDR_TXT__c');
                    record.preferredPhone = (String)contactObject.get('Representative_Phone__c');
                    
                    tempString = (String)contactObject.get('PATD_CERTFCTN_LVL_A_IND__c');
                    if (tempString == 'Y') {
                        record.training = ALMConstants.YES;
                    } else {
                        record.training = ALMConstants.No;
                    }
                    
                    record.conversionDate = LandingPageUtils.returnDateToString((Date)contactObject.get('CONVRSN_DT__c'), this.userLocale);
                    
                    // 'Appointment Date' retrieved , CR : 2413 on 08Mar, 2013 by Raktim
                    record.appntmntDate = LandingPageUtils.returnDateToString((Date)contactObject.get('REP_APPT_DT__c'), this.userLocale);
                    record.appntmntCampaign = (String)contactObject.get('REP_APPT_CMPGN_NR__c');
                    // EoC
                }
                
                // My_Business information 
                //if (personalPerformanceObject != null) {
                    Integer firstAmount;
                    Date firstDue;
                    Date firstPaid;
                    lvlNumberFieldName = 'LDRSHP_TITL_LVL_NR__c';
                    
                    //impersonation or coaching for "View"
                    tempString = (String)sObjectRecord.get('DWNLN_ONLY_IND__c');
                    record.nameLink = LandingPageUtils.makeCoachOrImperson(tempString, record.accountNumber, originalUrl, pageAllParams);
                    System.debug('=========== G1Appointments Controller. Populate Attributes. another NameLink : ' + record.nameLink);
                    
                    //various sections
                    record.orderByDate = LandingPageUtils.returnDateToString((Date)sObjectRecord.get('FRST_ORD_REQ_DT__c'), this.userLocale);
                    record.actualOrderDate = LandingPageUtils.returnDateToString((Date)sObjectRecord.get('FRST_ORDR_DT__c'), this.userLocale);
                    record.qualifiedOrder = LandingPageUtils.returnDecToString((Decimal)sObjectRecord.get('FRST_ORDR_AMT__c'));
                    System.debug('===================== G1Appointments Controller. Qualified Order is : ' + record.qualifiedOrder);
                    record.payByDate = LandingPageUtils.returnDateToString((Date)sObjectRecord.get('FRST_ORDER_DUE_DT__c'), this.userLocale);
                    
                    //some helper numbers and strings
                    oms_stus = (String)sObjectRecord.get('REP_OMS_STUS_CD__c');
                    repCampaignNumber = (String)sObjectRecord.get('REP_APPT_CMPGN_NR__c');
                    firstAmount = LandingPageUtils.returnDecToInt((Decimal)sObjectRecord.get('FRST_ORDR_AMT__c'));
                    firstDue = (Date)sObjectRecord.get('FRST_ORDER_DUE_DT__c');
                    firstPaid = (Date)sObjectRecord.get('FRST_ORDR_PD_DT__c');
                    
                    //define status
                    if (oms_stus == '-2') {
                        record.status = red;
                    } else if (oms_stus == '1' )  {
                        
                        if (repCampaignNumber == currMarket.CMPGN_NR__c) {
                            if (firstAmount != null && firstAmount < currMarket.SPONSOR_QLFYING_ORD_AMT__c) {
                                record.status = red;
                            } else {
                                if (firstDue != null && firstDue > currMarket.CMPGN_END_DT__c) {
                                    record.status = green;
                                } else {
                                    record.status = red;
                                }
                            }
                        } else if (repCampaignNumber != null && repCampaignNumber < currMarket.CMPGN_NR__c) {
                            if (firstAmount != null && firstAmount >= currMarket.SPONSOR_QLFYING_ORD_AMT__c) {
                                if (currUser.MRKT_ID__c == '67') {
                                    record.status = green;
                                } else if (firstPaid != null && firstDue != null) {
                                    if (firstPaid <= firstDue) {
                                        record.status = green;
                                    } else {
                                        record.status = red;
                                    }
                                } else {
                                    record.status = red;
                                }
                            }
                        }
                    }
                    
                    // 'QPA' retrieved , CR : 2413 on 08Mar, 2013 by Raktim
                    //record.qpaStatus = ((String)personalPerformanceObject.get('QPA_Achievement__c') != null) ? (String)personalPerformanceObject.get('QPA_Achievement__c') : '';
                    record.qpaStatus = ((String)sObjectRecord.get('Qualified_Candidate_Value__c') != null) ? (String)sObjectRecord.get('Qualified_Candidate_Value__c') : '';
                    // EoC       
                    
                    // badge Title
                    levelNumber = (Decimal)sObjectRecord.get('LDRSHP_TITL_LVL_NR_NUMBER__c');
                    if (levelNumber != null /*&& levelNumber != -2*/) {
                        if (isPrior) {
                            lvlNumberFieldName = 'PD_TITL_LVL_NR__c'; // for prior campaign display title based on paid level number
                        } 
                        record.badgeTitle = LandingPageUtils.determineBadgeTitle(mapLeaderTitle, (String)(sObjectRecord.get(lvlNumberFieldName)));
                    }
                    
                    //Branch or Zone - ZoneManager
                    record.branchName = (String)sObjectRecord.get('BRNCH_SCTN_CD__c');
                    
                    tempString = null;
                    if ((tempString = (String)sObjectRecord.get('ZONE_MGR_NAME__c')) != null) {
                         //record.zoneManager = 'Zone ' + tempString;
                        
                        // Mail Plan Change - by Raktim on 7th Aug 2013 START
                        if(isBranch)
                          //  record.zoneManager = System.label.Branch_Name + ' '+tempString;
                            record.zoneManager = System.label.Branch_Name;  //change by Dipak on 23102013 to remove Zone Manager Name(QC#3186)
                        else
                           // record.zoneManager = 'Zone ' + tempString;
                           // record.zoneManager = System.label.Zone + ' ' + tempString; //change by Dipak on 16102013 to add label Zone
                            record.zoneManager = System.label.Zone; //change by Dipak on 23102013 to remove Zone Manager Name(QC#3186)
                        // Mail Plan Change - by Raktim on 7th Aug 2013 END
                    }
                    tempString = null;
                    if ((tempString = (String)sObjectRecord.get('SLS_ZONE_CD__c')) != null) {
                       // record.zoneManager = record.zoneManager + '-' + tempString;
                        record.zoneManager = System.label.Zone + ' ' + tempString;  //change by Dipak on 24102013 to add label Zone
                    }
                    
                    /**  This code is commented for Mail Plan Change - by Raktim on 7th Aug 2013 START**/
                    /*
                    if (currUser.MRKT_ID__c == ALMConstants.PHILIPPINES_MARKET_CODE) {
                        record.zoneManager = record.branchName;
                        isPHMarkt = true;
                    }*/
                    /**  This code is commented for Mail Plan Change - by Raktim on 7th Aug 2013 END**/
                    
                    
                    //sponsor
                    String upline = (String)sObjectRecord.get('UPLN_ACCT_NR__c');
                    if(upline != null) {
                    	System.debug('\n ##### SPONSOR NAME :::: '+LandingPageUtils.getSponsor(mapContact, currUser.MRKT_ID__c, (String)sObjectRecord.get('UPLN_ACCT_NR__c')));
                    	record.sponsor = LandingPageUtils.getSponsor(mapContact, currUser.MRKT_ID__c, (String)sObjectRecord.get('UPLN_ACCT_NR__c'));
                    }
                
                // sponsor from account number throgh contact
                
                record.myTeamOrdersURL = myTeamOrdersReportLink  + '&textSearch=' + record.accountNumber;
                record.myTeamReportURL = myTeamReportLink + '&textSearch=' + record.accountNumber;
                
               // Mail Plan Addition - by Raktim on 7th Aug 2013 Start 
                try{
                    record.mailPlanCode = (String)sObjectRecord.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c');
                    //System.debug('\n ======== GOT mailPlanCode '+mailPlanCode);
                }catch(Exception e){
                    System.debug('\n ======== GOT EXCEPTION '+e);
                    record.mailPlanCode = '';
                }
                // Mail Plan Addition - by Raktim on 7th Aug 2013 END
                
                listAppointment.add(record);
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