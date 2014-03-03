public class CoachRecordController {
    public User currentUser {get; set;}
    public Contact contactUser {get; set;}
    public Market__c market {get; set;}
    public Calendar__c calendar {get; set;}
    public PersonalInfoHandeller personalInfo{get; private set;}
    public PersonalInfoHandeller personalInfoPriorCmpn {get; private set;}
    public PersonalSalesBusinessHandller psbInfo{get; private set;}
    public MarketTagUtils mktTags {get;  set;}
    public MarketLeaderTitleUtils ldrTitlUtils {get;  private set;}
    public MarketSellerStsUtils sellStsUtils {get; private set;}
    public String critAcctNbrs {get; set;}
    public String strImpersonate{get; private set;}
    public List<String> listCmpgn {get; private set;}
    public Boolean boolNonLdr{get; private set;}
    public Boolean boolExeLdr{get; private set;}
    public String strGI3Link{get; private set;}
    public Boolean boolDisplay{get; private set;}
    public Boolean isDispBlock{get; private set;}
    
    public String repacctnbr {get; set;}
    public Boolean boolMyBussTab{get;set;}
    private List<String> listExternalKey;   
    private Map<String, List<String>> zoneToDivMap;
    private List<Rep_Detail_Field__c> listRepFld;
    private List<Rep_Detail_Field__c> listPSBFld;
    private List<Rep_Detail_Field__c> listLDRFld;
    //private List<Rep_Detail_Field__c> listLDRUIFld;//subhamay 12032013 as per new requirment
    //UI info breaks into 3 list by Rajib to make the UI info block dynamic
    private List<Rep_Detail_Field__c> listLDRUIFldG1;
    private List<Rep_Detail_Field__c> listLDRUIFldG2;
    private List<Rep_Detail_Field__c> listLDRUIFldG3;
    //EOC - Rajib
    private List<Rep_Detail_Field__c> listEUPFld;
    private Map<String, List<Rep_Detail_Field__c>> mapFld;
    private List<Integer> listALLCmpgn;
    public Business_Plan__c BusinessPlan1{get;set;}
    private Map<String,String> monthMap; //Milon CRQ#2650
    
    //subhamay 21032013_G1 appointment having sameing coampign number as market
    public Boolean isG1RepCC{get; private set;}
    //eoc subhamay 21032013
    
    public Integer nCampgnCnt {get; private set;}
    
    public boolean displayPSB {
        get {
            if(displayPSB == null) {
                displayPSB = false;
            }
            return displayPSB;
        }
        set;
    }
    /**
    * control PSB section in Coaching page
    * return PageReference
    */
    public PageReference togglePSB(){
        if(displayPSB == false) {
            displayPSB = true;
            displayLeadership = false;
            displayEUP = false;
        } else {
            displayPSB = false;
        }
        //psbInfo = new PersonalSalesBusinessHandller(this.contactUser, this.market, this.critAcctNbrs, this.mapFld, this.listALLCmpgn, this.ldrTitlUtils);
        return null;
    }    
    public boolean displayLeadership {
        get {
            if(displayLeadership == null) {
                displayLeadership = false;
            }
            return displayLeadership;
        }
        set;
    }
    /**
    * control leadership section in Coaching page
    * return PageReference
    */
    public PageReference toggleLeadership(){
        if(displayLeadership == false) {
            displayLeadership = true;
            displayPSB = false;
            displayEUP = false;
        } else {
            displayLeadership = false;
        }
        //psbInfo = new PersonalSalesBusinessHandller(this.contactUser, this.market, this.critAcctNbrs, this.mapFld, this.listALLCmpgn, this.ldrTitlUtils);
        return null;
    }    
    public boolean displayEUP {
        get {
            if(displayEUP == null) {
                displayEUP = false;
            }
            return displayEUP;
        }
        set;
    }
    /**
    * control EUP section in Coaching page
    * return PageReference
    */
    public PageReference toggleEUP(){
        if(displayEUP == false) {
            displayEUP = true;
            displayPSB = false;
            displayLeadership = false;
        } else {
            displayEUP = false;
        }
        //psbInfo = new PersonalSalesBusinessHandller(this.contactUser, this.market, this.critAcctNbrs, this.mapFld, this.listALLCmpgn, this.ldrTitlUtils);
        return null;
    }    
    
    /**
    * this method call default constructor from component
    * return void
    */
    public void getInitialized(){
        System.debug('getInitialized Start: '+repacctnbr);
        //subhamay 21032013
        isG1RepCC = false;
        //eoc subhamay 21032013
        boolDisplay = false;
        boolNonLdr = false;
        boolExeLdr = false;
        displayPSB = false;
        displayLeadership = false;
        displayEUP = false;
        if(repacctnbr==null) {
            repacctnbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        }
        try {
            // get current account number
            if(ApexPages.currentPage().getParameters().get('AccKey')!=null){
                critAcctNbrs = ApexPages.currentPage().getParameters().get('AccKey');
                System.debug('from AccKey:'+critAcctNbrs);
            } else {
                critAcctNbrs = repacctnbr;
                System.debug('Default:'+critAcctNbrs);
            }
            // fetch all realted object data
            initializeSupportData();
            // get Representative details
            personalInfo = new PersonalInfoHandeller(this.currentUser, this.contactUser, this.market, critAcctNbrs, this.mapFld, this.listALLCmpgn, ldrTitlUtils, sellStsUtils, mktTags);
            //get last campaign details
            //personalInfoPriorCmpn = new PersonalInfoHandeller(this.currentUser, this.contactUser, this.market, critAcctNbrs, listRepFld, ldrTitlUtils, sellStsUtils, this.market.PREV_1_CMPGN_NR__c);
            //Integer nLdtTitle = (this.currentUser.LDRSHP_TITL_LVL_NBR__c != null && this.currentUser.LDRSHP_TITL_LVL_NBR__c !='')? Integer.valueOf(this.currentUser.LDRSHP_TITL_LVL_NBR__c) : 0;
            Integer nLdtTitle = Integer.valueOf(personalInfo.strLdrTitle);
            System.debug('User Title (strLdrTitle): '+nLdtTitle);   
            // market specific Executive nbr
            Integer nMktExeTitleNr = YOUUtil.getExecutiveLdrNbr(this.currentUser.MRKT_ID__c);
            Boolean boolYOUASLF = this.market.is_YOU_ASLF_Enabled__c;
            System.debug('YOU ASLF Enabled: '+boolYOUASLF+', nMktExeTitleNr: '+nMktExeTitleNr);
            if(!isG1RepCC) {
                // subhamay 15102012
                psbInfo = new PersonalSalesBusinessHandller(personalInfo.sobjRep, this.contactUser, this.market, this.critAcctNbrs, this.mapFld, this.listALLCmpgn, this.ldrTitlUtils, mktTags);
                // eoc subhamay 15102012
                
                if(nLdtTitle < 0) {
                    //check for non leader
                    boolNonLdr = true;
                } else if(boolYOUASLF == true && nMktExeTitleNr!=0 && nLdtTitle >= nMktExeTitleNr) {
                    //check for executive leader
                    boolExeLdr = true;
                }
                //check for My business tab visibility
                //boolMyBussTab = checkMyBussTabVisibility(this.currentUser.LDRSHP_TITL_LVL_NBR__c, String.valueOf(listAllCmpgn.get(0)), this.contactUser);
                boolMyBussTab = checkMyBussTabVisibility(nLdtTitle, String.valueOf(listAllCmpgn.get(0)), this.contactUser);
            }
            //Personal sales Biusiness section details
            //System.debug('psbInfo...Error Found:'+psbInfo);
        } catch(Exception exe) {
            System.debug('Coaching Record...Error Found:'+exe);
        }
    }
    /**
    * default constructor call at page loading time
    */
    public CoachRecordController(){ }
   
    /**
    * this method will fetched all supported data.
    * return void
    */
    private void initializeSupportData() {
        this.zoneToDivMap = new Map<String,List<String>>();
        
        String strMktAcctKey = '';
        String strAcctKey = '';
        String strMktId = '';        
        if(this.currentUser == null) {
            this.currentUser = [Select Name, MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, USER_CNTRY_CD__c, LastName, LanguageLocaleKey, 
                FirstName, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, ACCT_NR__c, Profile.Name, LDRSHP_TITL_LVL_NBR__c 
                From User where Id = :UserInfo.getUserId()];            
        }
        strAcctKey = this.currentUser.ACCT_NR__c;
        strMktId = this.currentUser.MRKT_ID__c;
        //System.debug('strAcctKey: '+strAcctKey+' critAcctNbrs: '+critAcctNbrs);
        if(strAcctKey != null && (strAcctKey == critAcctNbrs)) {
            boolDisplay = true;
        }
        //System.debug('boolDisplay: '+boolDisplay);
        if(critAcctNbrs !='' && critAcctNbrs != null) {
            strMktAcctKey = strMktId + critAcctNbrs;
        } else {
            critAcctNbrs = this.currentUser.ACCT_NR__c;
            strMktAcctKey = this.currentUser.MRKT_ID_ACCT_NR_KEY__c;
        }
        //System.debug('Search Contact user: -- :Market_Account_Key: '+strMktAcctKey);
        //added LDR_TYP__c field to the query - by Rajib
        this.contactUser = [Select Name, MRKT_ID__c,LDR_TYP__c, MLPLN_CD__c, MRKT_ACCT_KEY__c, SLS_ZONE_CD__c, ACCT_NR__c, REP_APPT_CMPGN_NR__c From Contact where MRKT_ACCT_KEY__c =:strMktAcctKey];
        //EOC - by Rajib
        //System.debug('contactUser: '+contactUser);
        if(this.market == null) {
            this.market = [Select ALM_Rep_Indicator__c,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, Name, Market_Id__c, Mail_Plan_Enabled__c, CURRNT_CMPGN_RMN_DAY_CNT__c, 
                           CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_END_DT__c, LAST_UPDT_DT__c,Id, Rep_Detail_Columns__c, Is_ALMPLUS_Enabled__c, isDisplayBlock__c, 
                           Omniture_Suite_Name__c, Market_Currency_Symbol__c, Section_EUP__c, Section_Ldrship__c, Section_PSB__c, Prior_Campaign_Count__c,
                           is_YOU_ASLF_Enabled__c , GI3_Keep_Alive_URL__c, X90_Day_Camp_CNT__c 
                           From Market__c where Market_Id__c =: strMktId]; 
        
        }
        isDispBlock = this.market.isDisplayBlock__c;
        
        // create gi3 link to update personal information.
        //System.debug('Personal Info GI3 Link: '+this.market.GI3_Keep_Alive_URL__c);
        if(this.market.GI3_Keep_Alive_URL__c != null && this.market.GI3_Keep_Alive_URL__c != '') {
            strGI3Link = this.market.GI3_Keep_Alive_URL__c + '/SLSuite/profilePersonal.page';
        } else {
            strGI3Link = '#';
        }
        //System.debug('Personal Info GI3 Link: '+strGI3Link);


        //subhamay 21032013_for G1 appointment having appint. camp no with market current camp no.          
        String strRepAppintCampNbr = this.contactUser.REP_APPT_CMPGN_NR__c;
        String strMktCCNbr = this.market.CMPGN_NR__c;
        //System.debug('Contact leader appt campaing number: '+strRepAppintCampNbr);
        //System.debug('Market campaign number: '+strMktCCNbr);
        
        if((strRepAppintCampNbr != null && strMktCCNbr != null) && strRepAppintCampNbr.equalsIgnoreCase(strMktCCNbr)) {
            isG1RepCC = true;
            //return;
        }
        
        //eoc subhamay 21032013
        //System.debug('CMPGN_NR__c: '+market.CMPGN_NR__c);
        nCampgnCnt = (this.market.X90_Day_Camp_CNT__c == null)? 0 : Integer.valueOf(this.market.X90_Day_Camp_CNT__c);
        if(nCampgnCnt > 6) {
            nCampgnCnt = 6;
        }
        
        this.listALLCmpgn = new List<Integer>();
        // subhamay 01092013_to remove current campaign details from list
        //listALLCmpgn.add(Integer.valueOf(this.market.CMPGN_NR__c));
        // eoc subhamay 01092013
        List<Integer> listTemp = YOUUtil.getXPriorCampaignList(this.contactUser.MRKT_ID__c, nCampgnCnt);
        for(Integer i : listTemp) {
            listALLCmpgn.add(i);
        }
        //System.debug('this.listALLCmpgn: '+this.listALLCmpgn);
        
        /*monthMap = new Map<String,String>();
        monthMap.put('01','January'); 
        monthMap.put('02','February'); 
        monthMap.put('03','March'); 
        monthMap.put('04','April'); 
        monthMap.put('05','May'); 
        monthMap.put('06','June'); 
        monthMap.put('07','July'); 
        monthMap.put('08','August'); 
        monthMap.put('09','September'); 
        monthMap.put('10','October'); 
        monthMap.put('11','November'); 
        monthMap.put('12','December ');  */
        
        //create campaign format CXX YYYY 
        listCmpgn = new List<String>();
        listCmpgn.add(System.Label.Variance);
        Integer cnt = 0;
        for(Integer nCamp : listALLCmpgn) {
            String strCamp = String.valueOf(nCamp);
            String strYear = strCamp.substring(0, 4);
            String strCC = strCamp.substring(4);
            String strCampNumber = System.Label.CampaignCC +' '+ strCC +' '+ strYear; //subhamay 14082013
            
            //System.debug('Milon '+strCC+' '+monthMap+' '+monthMap.get(strCC));
            //System.debug('Milon '+strCampNumber);
            //String strCampNumber = monthMap.get(strCC) +' '+ strYear; 
            //String strCampNumber = strYear+strCC;//subhamay 14082013
            if(cnt == 0) {
                listCmpgn.add(strCampNumber);
                strCampNumber = System.Label.CampaignCC +' '+ strCC +' '+ (Integer.valueOf(strYear) - 1);//subhamay 14082013
                //strCampNumber = monthMap.get(strCC) +' '+ (Integer.valueOf(strYear) - 1);
                //strCampNumber = (Integer.valueOf(strYear) - 1)+strCC;//subhamay 14082013
                listCmpgn.add(strCampNumber);
            } else {
                listCmpgn.add(strCampNumber);   
            }
            cnt++;
        }
        //System.debug('All Campaign details: '+listCmpgn);
        
        // create external key for My Business and Ldr Dwn Summry object
        listExternalKey = new List<String>();
        for(Integer camp : this.listAllCmpgn) {
            String val = String.valueOf(this.contactUser.MRKT_ID__c) + String.valueOf(camp) + String.valueOf(this.contactUser.ACCT_NR__c);
            listExternalKey.add(val);
        }
        //System.debug('External Key: '+listExternalKey);
        mapFld = new Map<String, List<Rep_Detail_Field__c>>();
        
        //subhamay 15102012
        String strLvl = getCurrentTitleLvl(this.critAcctNbrs);
        //System.debug('strLvl: '+strLvl);
        //eoc subhamay 15102012
        
        listRepFld = new List<Rep_Detail_Field__c>();
        listPSBFld = new List<Rep_Detail_Field__c>();
        listLDRFld = new List<Rep_Detail_Field__c>();
        // listLDRUIFld = new List<Rep_Detail_Field__c>(); //subhamay 12032013 as per new requirment
        //UI info breaks into 3 list by Rajib to make the UI info block dynamic
       listLDRUIFldG1 = new List<Rep_Detail_Field__c>();
       listLDRUIFldG2 = new List<Rep_Detail_Field__c>();
       listLDRUIFldG3 = new List<Rep_Detail_Field__c>();
       //EOC - Rajib
        listEUPFld = new List<Rep_Detail_Field__c>();
        //Added one field isTransitionLdr__c to query  - by Rajib
        for(Rep_Detail_Field__c repfld : [select Name, Type__c, Fields_To_Map__c, Group__c, isRuntime__c, Column__c, isNonLdr__c,isZeroRow__c,isTransitionLdr__c from Rep_Detail_Field__c  order by Column__c, Order__c]) {
            if(repfld.Group__c == 'Contact') {
                if(this.market.Rep_Detail_Columns__c != null && this.market.Rep_Detail_Columns__c.indexOf(repfld.Name)>-1) {
                    //Modified by Rajib for Mail Plan and TL 
                    //System.debug('this.contactUser.LDR_TYP__c -->'+this.contactUser.LDR_TYP__c);
                    if(repfld.isTransitionLdr__c && ('TL').equals(this.contactUser.LDR_TYP__c) && repfld.Fields_To_Map__c.contains('G1_ACTV_BASE_CNT__c')){
                        //System.debug('Inside TL -->');
                        listRepFld.add(repfld);
                    }else if(repfld.isTransitionLdr__c && !('TL').equals(this.contactUser.LDR_TYP__c) && repfld.Fields_To_Map__c.contains('G1_ACTV_BASE_CNT__c')){
                    //  System.debug('Inside other than TL -->');
                        continue;
                    }else if(repfld.Fields_To_Map__c.contains('Mail_Plan') && this.market.Mail_Plan_Enabled__c == true){
                        listRepFld.add(repfld);
                    }else if(repfld.Fields_To_Map__c.contains('Mail_Plan') && this.market.Mail_Plan_Enabled__c != true){
                        continue;
                    }else{
                        listRepFld.add(repfld);
                    }
                    //Modified by Rajib for Mail Plan and TL 
                }
            } else if(!isG1RepCC && repfld.Group__c == ALMConstants.CR_PSB) {
                if(this.market.Section_PSB__c != null &&this.market.Section_PSB__c.indexOf(repfld.Name)>-1) {
                    //subhamay 15102012
                    //System.debug('isNonLdr__c: '+repfld.isNonLdr__c+', Name: '+repfld.Name+', strLvl: '+strLvl);
                    if(strLvl == '-2' && repfld.isNonLdr__c){
                        continue;
                    } else if(strLvl != '-2' && repfld.isNonLdr__c) {
                        listPSBFld.add(repfld);
                    } else {
                        listPSBFld.add(repfld);
                    }
                    //eoc subhamay 15102012
                }
            } else if(!isG1RepCC && repfld.Group__c == ALMConstants.CR_LDR_TUS) {
                if(this.market.Section_Ldrship__c != null && this.market.Section_Ldrship__c.indexOf(repfld.Name)>-1) {
                    listLDRFld.add(repfld);
                }
            }//Modified By Rajib to make the UI dynamic
            else if(!isG1RepCC && repfld.Group__c == ALMConstants.CR_LDR_UI_G1) { //subhamay 12032013 as per new requirment
                System.debug('repfld.Name-->'+repfld.Name+'indexOf(repfld.Name) --> :'+this.market.Section_Ldrship__c.indexOf(repfld.Name));
                if(this.market.Section_Ldrship__c != null && this.market.Section_Ldrship__c.indexOf(repfld.Name)>-1) {                  
                    //Modified by Rajib
                    //listLDRUIFld.add(repfld);                 
                    if(repfld.isTransitionLdr__c && ('TL').equals(this.contactUser.LDR_TYP__c)){                        
                        listLDRUIFldG1.add(repfld);
                    }else if(repfld.isTransitionLdr__c && !('TL').equals(this.contactUser.LDR_TYP__c)){                     
                        continue;
                    }else{
                        listLDRUIFldG1.add(repfld);
                    }
                    
                    //EOC
                }//subhamay 12032013 as per new requirment
            } else if(!isG1RepCC && repfld.Group__c == ALMConstants.CR_LDR_UI_G2) {
                if(this.market.Section_Ldrship__c != null && this.market.Section_Ldrship__c.indexOf(repfld.Name)>-1) {
                    listLDRUIFldG2.add(repfld);
                }
              }else if(!isG1RepCC && repfld.Group__c == ALMConstants.CR_LDR_UI_G3) {
                if(this.market.Section_Ldrship__c != null && this.market.Section_Ldrship__c.indexOf(repfld.Name)>-1) {
                    listLDRUIFldG3.add(repfld);
              } 
            } //EOC - Modified By Rajib to make the UI dynamic           
            else if(!isG1RepCC && repfld.Group__c == ALMConstants.CR_EUP) {
                if(this.market.Section_EUP__c != null && this.market.Section_EUP__c.indexOf(repfld.Name)>-1) {
                    listEUPFld.add(repfld);
                }
            }
        }
        mapFld.put('CONTACT', listRepFld);
        mapFld.put('PSB', listPSBFld);
        mapFld.put('LDR_TUS', listLDRFld);
        //Modified by Rajib
        //mapFld.put('LDR_UI', listLDRUIFld);
        mapFld.put('LDR_UI_G1', listLDRUIFldG1);
        mapFld.put('LDR_UI_G2', listLDRUIFldG2);
        mapFld.put('LDR_UI_G3', listLDRUIFldG3);
        //EOC - Rajib
        mapFld.put('EUP', listEUPFld);
        
        //System.debug('listRepFld: '+listRepFld);
        //System.debug('All fields: '+mapFld);
        if(mktTags==null){
	        List<String> mktTagSubjAreas = new List<String>();
	        mktTagSubjAreas.add('Representative Detail');
	        mktTagSubjAreas.add('ALMRepPerf Detail');
	        //mktTagSubjAreas.add('Ldr-My Business');
	        //mktTagSubjAreas.add('Ldr-Downline Performance');
	        mktTags = new MarketTagUtils();
	        mktTags.initialize(mktTagSubjAreas, currentUser.MRKT_ID__c, currentUser.LanguageLocaleKey);
		}    
        if(ldrTitlUtils==null){
            ldrTitlUtils = new MarketLeaderTitleUtils();
            ldrTitlUtils.initialize(currentUser);
        }
        if(sellStsUtils==null){
            sellStsUtils = new MarketSellerStsUtils();
            sellStsUtils.initialize(currentUser);
        }
               
    }
    
    /**
    * Check whether my business plan is visible or not
    * @paranm strLdrTitle String
    * @paranm strCurrCamp String
    * @paranm contUser Contact
    * return Boolean
    */
    private Boolean checkMyBussTabVisibility(Integer nTitle, String strCurrCamp, Contact contUser) {
        Boolean boolMBT = false;
        String strMkdId = contactUser.MRKT_ID__c;
        String strAcctKey = contactUser.ACCT_NR__c;
        if(critAcctNbrs.trim() !='' && critAcctNbrs!=null){
            strAcctKey = critAcctNbrs;
        }
        String strMktAcctKay = strMkdId + strAcctKey;
        System.debug('strMktAcctKay: '+strMktAcctKay);
        
        //Integer nTitle = ((strLdrTitle != null && strLdrTitle!= '-')?Integer.valueOf(strLdrTitle):-1);
        //System.debug('strMkdId: '+strMkdId+', strAcctKey: '+strAcctKey+', nTitle: '+nTitle+', strLdrTitle: '+strLdrTitle+', strCurrCamp: '+strCurrCamp+', ALL Campaign: '+listAllCmpgn);
        List<Business_Plan__c> listBussPlan = [Select Name, Mrkt_Id_Acct_Nr_Key__c, IsDeleted__c  
               From Business_Plan__c WHERE Mrkt_Id_Acct_Nr_Key__c=:strMktAcctKay AND IsDeleted__c !=true and Is_BP_Saved__c = true];
        //System.debug('listBussPlan: '+listBussPlan);       
        
        if(listBussPlan.size() > 0 && nTitle > 0) {
            boolMBT = true;
        }
        System.debug('My Business Tab visibility: '+boolMBT);
        return boolMBT;
    }
    /**
    * to implement print functionality
    */
    public void getPrintFunction(){
        getInitialized();
        psbInfo = new PersonalSalesBusinessHandller(personalInfo.sobjRep, this.contactUser, this.market, this.critAcctNbrs, this.mapFld, this.listALLCmpgn, this.ldrTitlUtils, mktTags);
    
    }
    /**
    * method for omniture log for coaching page
    * return String
    */
    public String getOmniturePageName4Coach() {
        if(this.currentUser == null) {
            this.currentUser = [Select Name, MRKT_ID__c, USER_CNTRY_CD__c, LastName, LanguageLocaleKey, 
            FirstName, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, ACCT_NR__c, Profile.Name, LDRSHP_TITL_LVL_NBR__c 
            From User where Id = :UserInfo.getUserId()];            
        }
        return ALMPlusUtils.generateOmniturePageName('CoachingPage', null, this.currentUser.Profile.Name);    
    }
    // subhamay 15102012
    private String getCurrentTitleLvl(String strAcctNbr) {
        String strTitLvl = '';
        
        String StrRepPerfObj = this.market.ALM_Rep_Indicator__c;
        if(StrRepPerfObj != null){
            StrRepPerfObj = StrRepPerfObj.replace('__c', '__r');
        }
        System.debug('Rep Performance Object :::'+StrRepPerfObj);
        
        String strMktAcctKey = this.contactUser.MRKT_ID__c + this.contactUser.ACCT_NR__c;
        
        if(!isG1RepCC) {
            //String strSQLMuBuss = 'SELECT LDRSHP_TITL_LVL_NR__c FROM My_Business__c WHERE MRKT_ID__c=\''+this.contactUser.MRKT_ID__c+'\' AND  ACCT_NR__c=\''+this.contactUser.ACCT_NR__c+'\' AND Personal_Performance_Key__c =\''+listExternalKey.get(0)+'\' AND FLD_SLS_CMPGN_NR__c='+listAllCmpgn.get(0);
            String strSQLContTitle = 'Select (Select LDRSHP_TITL_LVL_NR__c from '+StrRepPerfObj+
            ' where FLD_SLS_CMPGN_NR__c='+listAllCmpgn.get(0)+') from Contact where MRKT_ACCT_KEY__c=\''+strMktAcctKey+'\'';
            System.debug('Current Title Lvl SQL: \n'+strSQLContTitle);
            try {
                //My_Business__c myBuss = Database.query(strSQLMuBuss);
                Contact contactObj = (Contact)Database.query(strSQLContTitle);
                if(contactObj!= null && contactObj.getSObjects(StrRepPerfObj) != null && contactObj.getSObjects(StrRepPerfObj).size()>0) {
                    if(contactObj.getSObjects(StrRepPerfObj).get(0) != null) {
                        SObject personalPerformObj = contactObj.getSObjects(StrRepPerfObj).get(0);
                        strTitLvl = (String)personalPerformObj.get('LDRSHP_TITL_LVL_NR__c');
                    }
                }
                System.debug('Current Title Lvl : \n'+strTitLvl);
            } catch(Exception exe) {
                System.debug('Exception to find Current Ldr Title: '+exe);
                strTitLvl = '0';
                //System.debug('DEFAULT::: Current Title Lvl : \n'+strTitLvl);
            }
        }
        return strTitLvl;
    }
    // eoc subhamay 15102012
}