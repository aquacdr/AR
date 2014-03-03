/**
	this class will fetched all Personal details information.
	Data will retrieved from Contact, Sales Organization, Genealogy,
*/
public class PersonalInfoHandeller {
	// personal sales business
	public String strCurrentYTD{get; private set;}
	public String strPriorYTD{get; private set;}
	public String strDiffCurrentPrior{get; private set;}
	public String strPerslVolNCamps{get; private set;}
	public String strSPPYPerslVolNCamps{get; private set;}
	public String strDiffCurrentSPPYN{get; private set;}
	public String strCurrentBaln{get; private set;}
	public String strAmtDue{get; private set;}
	public String strUpdatedDate{get; private set;}
	public String strUpdatedTime{get; private set;}
	private List<Integer> listAllCmpgn;
	//leadership
	public List<PersonalInfoConfig> col1{get; private set;}
	public List<PersonalInfoConfig> col2{get; private set;}
	public String strCurrentYTDLdr{get; private set;}
	public String strPriorYTDLdr{get; private set;}
	public String strDiffCurrentPriorLdr{get; private set;}
	public String strPerslVolNCampsLdr{get; private set;}
	public String strSPPYPerslVolNCampsLdr{get; private set;}
	public String strDiffCurrentSPPYNLdr{get; private set;}
	public String strDueDate{get; private set;}
	public String strLdrTitle{get; private set;}
	public Contact sobjRep{get; private set;}
	private static Map<Integer, String> mapMonth = new Map<Integer, String>();
    private static Map<Integer, String> mapPresidentClubStatus = new Map<Integer, String>();    
	private List<Rep_Detail_Field__c> listRepFld;
	private List<Rep_Detail_Field__c> listRepAllFlds;
	private MarketLeaderTitleUtils ldrTitlUtils;
	private MarketSellerStsUtils sellStsUtils;
	public MarketTagUtils mktTags;
	private User currentUser;
	private Contact contactUser;
	private Market__c market;
	private Map<String,Sales_Organization__c> salesOrgMap;
    private Map<String,List<String>> zoneToDivMap;
    private Map<String, List<Rep_Detail_Field__c>> mapFlds;
	public String strAccountNbr{get; private set;}
	public String strUplineAccNr{get; private set;}
	
	private String strContactField='';
	private String strUplineField='';
	private String strSalesOrgField='';
	private String strSalesHistoryField='';
	private String strRepPerformanceField='';
	private String strMktCurrencySymbol;
	
	private SObject sobjLdr;
	private String strLdr;
	private String strPrslPerfExtKey;
	private List<String> critAcctNbrList;
	private String strContactKey;
	/**
	* default constructor
	*/
	public PersonalInfoHandeller() {
	}
	/**
	* overloaded constructor PersonalInfoHandeller
	* @param currentUser User
	* @param contactUser Contact
	* @param market Market__c
	* @param strAccountNbr String
	* @param listRepFld List<Rep_Detail_Field__c>
	* @param ldrTitlUtils MarketLeaderTitleUtils
	* @param sellStsUtils MarketSellerStsUtils
	*/
	public PersonalInfoHandeller(User currentUser, Contact contactUser, Market__c market, String strAccountNbr, Map<String, List<Rep_Detail_Field__c>> mapFlds, List<Integer> listAllCmpgn, MarketLeaderTitleUtils ldrTitlUtils, MarketSellerStsUtils sellStsUtils, MarketTagUtils mktTags) {
		this.mapFlds = mapFlds;
		this.ldrTitlUtils = ldrTitlUtils;
		this.sellStsUtils = sellStsUtils;
		this.mktTags = mktTags;
		this.currentUser = currentUser;
		this.contactUser = contactUser;
		this.market = market;
		this.strAccountNbr = strAccountNbr;
		
		this.listAllCmpgn = listAllCmpgn;
		
		listRepAllFlds = new List<Rep_Detail_Field__c>();
		if(mapFlds.get('CONTACT') != null){
			listRepAllFlds.addAll(mapFlds.get('CONTACT'));
		}
		if(mapFlds.get('PSB') != null){
			listRepAllFlds.addAll(mapFlds.get('PSB'));
		}
		if(mapFlds.get('EUP') != null){
			listRepAllFlds.addAll(mapFlds.get('EUP'));
		}
    // Code changes by Rajib - Mail Plan
		/*if(mapFlds.get('PSB') != null){
			listRepAllFlds.addAll(mapFlds.get('LDR_UI'));
		} */
    if(mapFlds.get('LDR_UI_G1') != null){
			listRepAllFlds.addAll(mapFlds.get('LDR_UI_G1'));
		}
		if(mapFlds.get('LDR_UI_G2') != null){
			listRepAllFlds.addAll(mapFlds.get('LDR_UI_G2'));
		}
		if(mapFlds.get('LDR_UI_G3') != null){
			listRepAllFlds.addAll(mapFlds.get('LDR_UI_G3'));
		}
    // EOC - Code chages by Rajib
		if(mapFlds.get('LDR_TUS') != null){
			listRepAllFlds.addAll(mapFlds.get('LDR_TUS'));
		}
		
		if(market.Market_Currency_Symbol__c != null) {
			strMktCurrencySymbol = market.Market_Currency_Symbol__c;	
		} else {
			strMktCurrencySymbol = '';
		}
		
		//populate static custom setting value
		populateCustomValues();
			
		for(Rep_Detail_Field__c fld : listRepAllFlds) {
			if(fld.Fields_To_Map__c != null) {
				String temp = fld.Fields_To_Map__c;
				if(!temp.contains(ALMConstants.DUPLICATE_KPI)) {
					if(fld.Group__c.equals('Contact')) {
						if(temp.contains(':')){
							String[] strFieldFrom = temp.split(':');							
							if(strFieldFrom[0] == 'SalesOrg') {
								strSalesOrgField += strFieldFrom[1] + ',';
							}else if(strFieldFrom[0] == 'ALM_Rep_Performance_1'){
								strRepPerformanceField += strFieldFrom[1] + ',';
							}else if(strFieldFrom[0] == 'Upline'){
								strUplineField += strFieldFrom[1]+ ',';
							}							
						}else {
							strContactField += temp + ',';
						}				
						
					}else if((fld.Group__c.equals('EUP') || fld.Group__c.equals('PSB') || fld.Group__c.equals('LDR_TUS') || fld.Group__c.equals('LDR_UI_G1') || fld.Group__c.equals('LDR_UI_G2')|| fld.Group__c.equals('LDR_UI_G3')) && temp.contains(':')){
						String[] strFieldFrom = temp.split(':');
						if(strFieldFrom[0] == 'Sales_History') {
							strSalesHistoryField += strFieldFrom[1] + ',';
						}
					} else {
						strContactField += temp + ',';
					}
				}
			}
		}
		strContactField = strContactField !='' ? strContactField.substring(0, strContactField.length()-1):strContactField;
		System.debug('strContactField: '+strContactField);
		
		strUplineField = strUplineField != ''? strUplineField.substring(0, strUplineField.length()-1):strUplineField;
		System.debug('strUplineField: '+strUplineField);
				
		strSalesOrgField = strSalesOrgField != ''? strSalesOrgField.substring(0, strSalesOrgField.length()-1):strSalesOrgField;
		System.debug('strSalesOrgField: '+strSalesOrgField);

		strSalesHistoryField = strSalesHistoryField != ''? strSalesHistoryField.substring(0, strSalesHistoryField.length()-1):strSalesHistoryField;
		System.debug('strSalesHistoryField: '+strSalesHistoryField);
		
		strRepPerformanceField = strRepPerformanceField != ''? strRepPerformanceField.substring(0, strRepPerformanceField.length()-1):strRepPerformanceField;
		System.debug('strRepPerformanceField: '+strRepPerformanceField);
		
		this.critAcctNbrList = strAccountNbr.split(',');
        //this.strPrslPerfExtKey = market.Market_Id__c + campaignId + strAccountNbr;
        this.strContactKey = market.Market_Id__c + strAccountNbr;
        populatePersonalInfo();
	}
	 
	/**
	* populate all personal details sections.
	*/
	private void populatePersonalInfo() {
		col1 = new List<PersonalInfoConfig>();
		col2 = new List<PersonalInfoConfig>();

        String mktId = this.market.Market_Id__c;
		String currntCampNr = this.market.CMPGN_NR__c;
		Integer prevCampg = listAllCmpgn.get(0);
		List<Integer> listCCPC = new List<Integer>();
		listCCPC.add(Integer.valueOf(currntCampNr));
		listCCPC.add(prevCampg);
		System.debug('listCCPC ###### --'+listCCPC);
		// get representative detials
        String tempSOQL = createPersonalInfoSOQL(strContactField);        
   
        PersonalInfoConfig personalInfoConfig;

        // data for representative details
        sobjRep = (Contact)Database.query(tempSOQL);
                
        Datetime dateLastUdt;
        try {
        	/*dateLastUdt = this.market.LAST_UPDT_DT__c;
	        String strMon = dateLastUdt.month() > 10 ? String.valueOf(dateLastUdt.month()) : '0'+dateLastUdt.month(); 
	        String strDay = dateLastUdt.day() > 10 ? String.valueOf(dateLastUdt.day()) : '0'+dateLastUdt.day(); 
	        strUpdatedDate = strMon +'/'+ strDay +'/'+ dateLastUdt.year();
	        strUpdatedTime = dateLastUdt.format('HH:mm');*/
        	dateLastUdt = this.market.LAST_UPDT_DT__c;
	        //String strMon = dateLastUdt.month() > 10 ? String.valueOf(dateLastUdt.month()) : '0'+dateLastUdt.month(); 
	        //String strDay = dateLastUdt.day() > 10 ? String.valueOf(dateLastUdt.day()) : '0'+dateLastUdt.day(); 
	        strUpdatedDate = dateLastUdt.date().format();
	        strUpdatedTime = dateLastUdt.format('HH:mm');
        } catch(Exception exe) {
        	strUpdatedDate = '';
        	strUpdatedTime = '';
        }
        System.debug('Last updated date/time: '+dateLastUdt+', Date: '+strUpdatedDate+', Time: '+strUpdatedTime);
        
        
        // populate headers information.
        SObject personalPerformObj;
        String StrRepPerfObj = this.market.ALM_Rep_Indicator__c;
        //System.debug('StrRepPerfObj: '+StrRepPerfObj);
		if(StrRepPerfObj != null){
			StrRepPerfObj = StrRepPerfObj.replace('__c', '__r');
		  }
      
      //Added by Rajib - Mail Plan
		String strSOmailPlanOrdOpt = 'MailPlan_Order_Oppty__r';
		SObject mailPlanOrdOpptObj;
		//Ended by Rajib - Mail Plan
    
        if(sobjRep!= null && sobjRep.getSObjects(StrRepPerfObj) != null && sobjRep.getSObjects(StrRepPerfObj).size()>0) {
        	//to populate  information(personal indormation)
        	if(sobjRep.getSObjects(StrRepPerfObj).get(0) != null) {
        		personalPerformObj = sobjRep.getSObjects(StrRepPerfObj).get(0);
            //Added by Rajib - Mail Plan
        		if(personalPerformObj != null && personalPerformObj.getSObject(strSOmailPlanOrdOpt) != null){
        			mailPlanOrdOpptObj = personalPerformObj.getSObject(strSOmailPlanOrdOpt);
        		}
        		//Ended by Rajib - Mail Plan
        		
        	}
        	//to populate block information(personal Sales)
        	if(sobjRep.getSObjects(StrRepPerfObj) != null && sobjRep.getSObjects(StrRepPerfObj).size() > 1) {
        		//subhamay 23102013_qc#3252
        		//populateBlockInfo(sobjRep.getSObjects(StrRepPerfObj).get(1));
        		populateBlockInfo(sobjRep.getSObjects(StrRepPerfObj).get(1), sobjRep.getSObjects(StrRepPerfObj).get(0));
        		//eoc subhamay 23102013_qc#3252
        	}
        }
        //data for sales org details
        Sales_Organization__c salsOrg;
        String strMrktOrgKey = (String)sobjRep.MRKT_SLS_ORG_KEY__c;
        String strSlsOrgSOQL = createSalesOrgSOQL(strMrktOrgKey, strSalesOrgField);
        try{ 
        	salsOrg = (Sales_Organization__c)Database.query(strSlsOrgSOQL);
        }catch(exception ex){}
        // data for upline details       
        SObject sobjUpline;
        strUplineAccNr = this.currentUser.ACCT_NR__c;
        if(personalPerformObj != null){
        	strUplineAccNr = String.valueOf(personalPerformObj.get('UPLN_ACCT_NR__c'));
        }
        String strUpSOQL = createUplineSOQL(strUplineAccNr, strUplineField);
        try {
        	sobjUpline = Database.query(strUpSOQL);
        } catch(Exception exe) {
        	System.debug('Upline record not found.'+exe);
        }       
        Integer counter = 0;
        for(Rep_Detail_Field__c fld : this.mapFlds.get('CONTACT'))  {
        	String temp = fld.Fields_To_Map__c;
			String[] strFieldFrom = temp.split(':');
        	if(fld.Group__c.equals('Contact') && strFieldFrom[0] == 'Upline') {
				personalInfoConfig = new PersonalInfoConfig(sobjUpline, fld, ldrTitlUtils, sellStsUtils, mktTags);
			} else 
			if(fld.Group__c.equals('Contact') && strFieldFrom[0] == 'SalesOrg') {
				personalInfoConfig = new PersonalInfoConfig(salsOrg, fld, ldrTitlUtils, sellStsUtils, mktTags);
			} else if(fld.Group__c.equals('Contact') && (strFieldFrom[0] == 'ALM_Rep_Performance_1')) {
				personalInfoConfig = new PersonalInfoConfig(personalPerformObj, fld, ldrTitlUtils, sellStsUtils, mktTags);
				if(strFieldFrom[1] == 'LDRSHP_TITL_LVL_NR__c') {
					strLdrTitle = personalInfoConfig.strLdrTitle!= null?personalInfoConfig.strLdrTitle:'0';
				}
			}else if(fld.Group__c.equals('Contact') && (strFieldFrom[0] == 'Mail_Plan')) {
				//Logic added by Rajib
				personalInfoConfig = new PersonalInfoConfig(mailPlanOrdOpptObj, fld, ldrTitlUtils, sellStsUtils, mktTags);
			}else {
				personalInfoConfig = new PersonalInfoConfig(sobjRep, fld, ldrTitlUtils, sellStsUtils, mktTags);
			}	
      /* else {
				personalInfoConfig = new PersonalInfoConfig(sobjRep, fld, ldrTitlUtils, sellStsUtils);
			} */
			counter++;
			if(personalInfoConfig.fldValue != null) {
				if(fld.Column__c == '1') {
					col1.add(personalInfoConfig);
				} else {
					col2.add(personalInfoConfig);
				}				
			}
        }
	}

	/**
	* create soql to retreive representative details
	* @param strContactField String
	* return String
	*/
	public String createPersonalInfoSOQL(String strContactField) {
		String strSOQL = '';		
		String StrRepPerfObj = this.market.ALM_Rep_Indicator__c;
		if(StrRepPerfObj != null){
			StrRepPerfObj = StrRepPerfObj.replace('__c', '__r');
		}
		if(strContactField != null && strContactField != '') {
			if(strSalesHistoryField != null && strSalesHistoryField != '') {
				strSOQL = 'Select '+strContactField + ', MRKT_SLS_ORG_KEY__c, REP_WORK_PHONE_NR__c, ';
				strSOQL +='(Select '+strRepPerformanceField+',MailPlan_Order_Oppty__r.MLPLN_CD__c,UPLN_ACCT_NR__c, YTD_PRSNL_SLS_AMT__c, SPPY_YTD_PRSNL_SLS_AMT__c,TOTAL_N_CMPGNS_PV_AMT__c, SPPY_TOTAL_N_CMPGNS_PV_AMT__c,BAL_DUE_AMT__c, BAD_DEBT_AMT__c, PAST_DUE_AMT__c, NXT_DUE_DT__c,YTD_GRP_UNIT_SLS_AMT__c, SPPY_YTD_GRP_UNIT_SLS_AMT__c,TOTAL_N_CMPGNS_GRP_UNIT_SLS__c, SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c ';
				strSOQL +=' from '+StrRepPerfObj +' where FLD_SLS_CMPGN_NR__c IN: listCCPC order by FLD_SLS_CMPGN_NR__c desc),';
				strSOQL +='(Select '+strSalesHistoryField+' from Sales_Leader_Histories__r where FLD_SLS_CMPGN_NR__c IN: listAllCmpgn order by FLD_SLS_CMPGN_NR__c desc) ';
				strSOQL += 'From Contact where MRKT_ACCT_KEY__c =:strContactKey';
			} else {				
				strSOQL = 'Select '+strContactField + ', MRKT_SLS_ORG_KEY__c, REP_WORK_PHONE_NR__c, ';
				strSOQL +='(Select '+strRepPerformanceField+',MailPlan_Order_Oppty__r.MLPLN_CD__c, UPLN_ACCT_NR__c, YTD_PRSNL_SLS_AMT__c, SPPY_YTD_PRSNL_SLS_AMT__c,TOTAL_N_CMPGNS_PV_AMT__c, SPPY_TOTAL_N_CMPGNS_PV_AMT__c,BAL_DUE_AMT__c, BAD_DEBT_AMT__c, PAST_DUE_AMT__c, NXT_DUE_DT__c,YTD_GRP_UNIT_SLS_AMT__c, SPPY_YTD_GRP_UNIT_SLS_AMT__c,TOTAL_N_CMPGNS_GRP_UNIT_SLS__c, SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c ';
				strSOQL +=' from '+StrRepPerfObj +' where FLD_SLS_CMPGN_NR__c IN: listCCPC order by FLD_SLS_CMPGN_NR__c desc),';
				strSOQL +='(Select FLD_SLS_CMPGN_NR__c from Sales_Leader_Histories__r where FLD_SLS_CMPGN_NR__c IN: listAllCmpgn order by FLD_SLS_CMPGN_NR__c desc) ';
				strSOQL += 'From Contact where MRKT_ACCT_KEY__c =:strContactKey';			
			}
		} else {
			if(strSalesHistoryField != null && strSalesHistoryField != '') {
				strSOQL = 'Select ACCT_NR__c, MRKT_SLS_ORG_KEY__c, REP_WORK_PHONE_NR__c, ';
				strSOQL +='(Select '+strRepPerformanceField+',MailPlan_Order_Oppty__r.MLPLN_CD__c, UPLN_ACCT_NR__c, YTD_PRSNL_SLS_AMT__c, SPPY_YTD_PRSNL_SLS_AMT__c,TOTAL_N_CMPGNS_PV_AMT__c, SPPY_TOTAL_N_CMPGNS_PV_AMT__c,BAL_DUE_AMT__c, BAD_DEBT_AMT__c, PAST_DUE_AMT__c, NXT_DUE_DT__c,YTD_GRP_UNIT_SLS_AMT__c, SPPY_YTD_GRP_UNIT_SLS_AMT__c,TOTAL_N_CMPGNS_GRP_UNIT_SLS__c, SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c ';
				strSOQL +=' from '+StrRepPerfObj +' where FLD_SLS_CMPGN_NR__c IN: listCCPC order by FLD_SLS_CMPGN_NR__c desc),';
				strSOQL +='(Select '+strSalesHistoryField+' from Sales_Leader_Histories__r where FLD_SLS_CMPGN_NR__c IN: listAllCmpgn order by FLD_SLS_CMPGN_NR__c desc) ';
				strSOQL += 'From Contact where MRKT_ACCT_KEY__c =:strContactKey';
				
			} else {
				strSOQL = 'Select ACCT_NR__c, MRKT_SLS_ORG_KEY__c, REP_WORK_PHONE_NR__c, ';
				strSOQL +='(Select '+strRepPerformanceField+',MailPlan_Order_Oppty__r.MLPLN_CD__c, UPLN_ACCT_NR__c, YTD_PRSNL_SLS_AMT__c, SPPY_YTD_PRSNL_SLS_AMT__c,TOTAL_N_CMPGNS_PV_AMT__c, SPPY_TOTAL_N_CMPGNS_PV_AMT__c,BAL_DUE_AMT__c, BAD_DEBT_AMT__c, PAST_DUE_AMT__c, NXT_DUE_DT__c,YTD_GRP_UNIT_SLS_AMT__c, SPPY_YTD_GRP_UNIT_SLS_AMT__c,TOTAL_N_CMPGNS_GRP_UNIT_SLS__c, SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c ';
				strSOQL +=' from '+StrRepPerfObj +' where FLD_SLS_CMPGN_NR__c IN: listCCPC order by FLD_SLS_CMPGN_NR__c desc),';
				strSOQL +='(Select FLD_SLS_CMPGN_NR__c from Sales_Leader_Histories__r where FLD_SLS_CMPGN_NR__c IN: listAllCmpgn order by FLD_SLS_CMPGN_NR__c desc) ';
				strSOQL += 'From Contact where MRKT_ACCT_KEY__c =:strContactKey';			
			}
		}
		System.debug('SOQL for Rep(Contact): '+strSOQL+'>>strContactKey..'+this.strContactKey);
		return strSOQL;
	}
		
	/**
	* create soql to retreive upline details
	* @param strUplineAcctNum String
	* @param strUplineField String
	* return String 
	*/
	public String createUplineSOQL(String strUplineAcctNum, String stringUplineField) {
		String strSOQL = '';		
		String strMktId = this.market.Market_Id__c;
		String strUplineKey = strMktId + strUplineAcctNum;
		if(stringUplineField != null && stringUplineField != '') {
			strSOQL = 'Select ACCT_NR__c, '+stringUplineField;
		} else {
			strSOQL = 'Select ACCT_NR__c ';
		}
		strSOQL += ' FROM Contact WHERE MRKT_ACCT_KEY__c=\''+strUplineKey+'\' AND ACCT_NR__c=\''+strUplineAcctNum+'\' limit 1';
		
		System.debug('SOQL for Upline: '+strSOQL);
		return strSOQL;
	}
	
	/**
	* create soql to retreive sales organization details
	* @param strMktSalesOrgKey String
	* @param strSalesOrgField String
	* reutrn String
	*/
	public String createSalesOrgSOQL(String strMktSalesOrgKey, String stringSalesOrgField) {
		String strSOQL = '';
		if(stringSalesOrgField != null && stringSalesOrgField != '') {
			strSOQL = 'Select MRKT_ID__c, '+stringSalesOrgField;
		} else {
			strSOQL = 'Select MRKT_ID__c ';	
		}
		strSOQL += ' From  Sales_Organization__c where MRKT_ID__c=\''+ this.contactUser.MRKT_ID__c +'\' and MRKT_ID_LVL_SLS_ORG_CD_KEY__c=\''+strMktSalesOrgKey+'\' limit 1';
		
		System.debug('SOQL for Sales: '+strSOQL);
		return strSOQL;
	}

	/**
	* Get double formatted value
	* @param sobj SObject
	* @param strField String
	* return Double 
	*/
	//private Long getDoubleValue(SObject sobj, String strField) {
	private Double getDoubleValue(SObject sobj, String strField) {
		Object objValue = '';
		Double dVal=0;
		try {
    		objValue = sobj.get(strField);
			if(objValue != null) {
				dVal = Double.valueOf(objValue);
			}
		} catch(Exception exe) {
			System.debug('**getDoubleValue exception: '+exe);	
		}
		System.debug('getDoubleValue: '+strField+',Value- '+dVal);
		//return dVal.longValue();
		return dVal;
	}
	
	/**
	* format the decimal value
	* @param val Double
	* return String
	*/
	private String formatValue(Double val) {
		String temp = '';
		try {
			if(val > 0.0) {
				temp = strMktCurrencySymbol + val.format();
			} else if(val < 0.0) {
				String strVal = val.format();
				strVal = strVal.substring(1);
				temp = '-'+strMktCurrencySymbol + strVal;//added '-' symbol as per UK market.
			} else {
				temp = strMktCurrencySymbol+'0.0';
			}
			String t = temp.substring(temp.indexOf('.')+1);
			if(t.length() == 1){
				temp = temp + '0';
			}
			if(!temp.contains('.')) {
				temp += '.0';
			}
			System.debug('formatValue----'+temp);
		} catch(Exception exe) {
			System.debug('**formatValue Exception: '+exe);
		}
		return temp;
	}
	
	/**
	* ppopulate all block informaiotn for each section
	* @param sobjData SObject
	* return void 
	*/
	//subhamay 23102013_qc#3252
	//private void populateBlockInfo(SObject sobjData) {
	private void populateBlockInfo(SObject sobjData, SObject sobjDataCC) {
	//eoc subhamay 23102013_qc#3252
		Double dCurrentYTD;
		Double dPriorYTD;
		Double diffCurrentPrior;
		Double dPersonalNVOL;
		Double dSPPYPersonalNVOL;
		Double diffCurrentSPPYN;
		Double dCurrentBalnVOL;
		Double dAmtDue;
		strDueDate = '';
		Date DueDate;
		if(sobjData != null) {
			dCurrentYTD = getDoubleValue(sobjData, 'YTD_PRSNL_SLS_AMT__c');
			dPriorYTD = getDoubleValue(sobjData, 'SPPY_YTD_PRSNL_SLS_AMT__c');
			diffCurrentPrior = (dCurrentYTD - dPriorYTD);			
			
			dPersonalNVOL = getDoubleValue(sobjData, 'TOTAL_N_CMPGNS_PV_AMT__c');
			dSPPYPersonalNVOL = getDoubleValue(sobjData, 'SPPY_TOTAL_N_CMPGNS_PV_AMT__c');
			//DueDate = (Date)sobjData.get('NXT_DUE_DT__c'); subhamay_23102013_qc#3252
			diffCurrentSPPYN = (dPersonalNVOL - dSPPYPersonalNVOL);
			/* subhamay 23102013_qc#3252
			try {
		        //String strMon = DueDate.month() > 10 ? String.valueOf(DueDate.month()) : '0'+DueDate.month(); 
		        //String strDay = DueDate.day() > 10 ? String.valueOf(DueDate.day()) : '0'+DueDate.day(); 
		        //strDueDate = strMon +'/'+ strDay +'/'+ DueDate.year();
		        strDueDate = DueDate.format();
	        } catch(Exception exe) {
	        	strDueDate = '';
	        }
	        subhamay 23102013_qc#3252 */
	        
	        //subhamay 23102013_qc#3252
			//dCurrentBalnVOL = getDoubleValue(sobjData, 'BAL_DUE_AMT__c');
			//dAmtDue = getDoubleValue(sobjData, 'BAD_DEBT_AMT__c');
			//eoc subhamay 23102013_qc#3252
			
			// for the double value into proper string value			
			strCurrentYTD = PersonalSalesBusinessHandller.formatData(formatValue(dCurrentYTD), 'Number');
			strPriorYTD = PersonalSalesBusinessHandller.formatData(formatValue(dPriorYTD), 'Number');
			strDiffCurrentPrior = PersonalSalesBusinessHandller.formatData(formatValue(diffCurrentPrior), 'Number');
			
			strPerslVolNCamps = PersonalSalesBusinessHandller.formatData(formatValue(dPersonalNVOL), 'Number');
			strSPPYPerslVolNCamps = PersonalSalesBusinessHandller.formatData(formatValue(dSPPYPersonalNVOL), 'Number');
			strDiffCurrentSPPYN = PersonalSalesBusinessHandller.formatData(formatValue(diffCurrentSPPYN), 'Number');
			//subhamay 23102013_qc#3252
			//strCurrentBaln = PersonalSalesBusinessHandller.formatData(formatValue(dCurrentBalnVOL), 'Number');
			//strAmtDue = PersonalSalesBusinessHandller.formatData(formatValue(dAmtDue), 'Number');
			//subhamay 23102013_qc#3252
			dCurrentYTD = getDoubleValue(sobjData, 'YTD_GRP_UNIT_SLS_AMT__c');
			dPriorYTD = getDoubleValue(sobjData, 'SPPY_YTD_GRP_UNIT_SLS_AMT__c'); // field not created.
			diffCurrentPrior = (dCurrentYTD - dPriorYTD);			
			
			dPersonalNVOL = getDoubleValue(sobjData, 'TOTAL_N_CMPGNS_GRP_UNIT_SLS__c');
			dSPPYPersonalNVOL = getDoubleValue(sobjData, 'SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c');
			diffCurrentSPPYN = (dPersonalNVOL - dSPPYPersonalNVOL);
			
			strCurrentYTDLdr = PersonalSalesBusinessHandller.formatData(formatValue(dCurrentYTD), 'Number');
			strPriorYTDLdr = PersonalSalesBusinessHandller.formatData(formatValue(dPriorYTD), 'Number');
			strDiffCurrentPriorLdr = PersonalSalesBusinessHandller.formatData(formatValue(diffCurrentPrior), 'Number');
			
			strPerslVolNCampsLdr = PersonalSalesBusinessHandller.formatData(formatValue(dPersonalNVOL), 'Number');
			strSPPYPerslVolNCampsLdr = PersonalSalesBusinessHandller.formatData(formatValue(dSPPYPersonalNVOL), 'Number');
			strDiffCurrentSPPYNLdr = PersonalSalesBusinessHandller.formatData(formatValue(diffCurrentSPPYN), 'Number');
			
		}
		
		//subhamay 23102013_qc#3252
		//from current campaign data in alm_rep_performance
		if(sobjDataCC != null) {
			dCurrentBalnVOL = getDoubleValue(sobjDataCC, 'BAL_DUE_AMT__c');
			//dAmtDue = getDoubleValue(sobjDataCC, 'BAD_DEBT_AMT__c');
			dAmtDue = getDoubleValue(sobjDataCC, 'PAST_DUE_AMT__c');
			
			DueDate = (Date)sobjDataCC.get('NXT_DUE_DT__c');
			try {
		        strDueDate = DueDate.format();
	        } catch(Exception exe) {
	        	strDueDate = '';
	        }
			strCurrentBaln = PersonalSalesBusinessHandller.formatData(formatValue(dCurrentBalnVOL), 'Number');
			strAmtDue = PersonalSalesBusinessHandller.formatData(formatValue(dAmtDue), 'Number');
	        
	        System.debug('CC Balance details: dCurrentBalnVOL-'+strCurrentBaln+'dAmtDue-'+strAmtDue+'DueDate-'+strDueDate);
		}
		//eoc subhamay 23102013_qc#3252
	}
	
	/**
	* Static method to get field label from constant class
	* fldFieldToMap String
	* return String
	*/
    public static String getFieldLabel(String fldFieldToMap){
        String fldLabel;
        fldLabel = ALMReportLabels.getCoachRecordLabel(fldFieldToMap);//fldFieldToMap; 
        return fldLabel;
    }

    /**
    * populate all static value for Month
    */
    private void populateCustomValues() {
    	mapMonth = new Map<Integer, String>();
        mapPresidentClubStatus = new Map<Integer, String>();
        // subhamay 16092013_to access traslated value(Mexico) for month
    	/*for(Coaching_Header_Items__c coachingItem : [select Name, KEY__C, VALUE__c, TYPE__c from Coaching_Header_Items__c  order by TYPE__c, KEY__C]) {
    		if(coachingItem.TYPE__c == 'month') {
    			mapMonth.put(Integer.valueOf(coachingItem.KEY__C), coachingItem.VALUE__c);
    		}
    	}*/
    	mapMonth.put(1 ,System.Label.LJanuary);
    	mapMonth.put(2 ,System.Label.LFebruary);
    	mapMonth.put(3 ,System.Label.LMarch);
    	mapMonth.put(4 ,System.Label.LApril);
    	mapMonth.put(5 ,System.Label.LMay);
    	mapMonth.put(6 ,System.Label.LJun);
    	mapMonth.put(7 ,System.Label.LJuly);
    	mapMonth.put(8 ,System.Label.LAugust);
    	mapMonth.put(9 ,System.Label.LSeptember);
    	mapMonth.put(10 ,System.Label.LOctober);
    	mapMonth.put(11 ,System.Label.LNovember);
    	mapMonth.put(12 ,System.Label.LDecember);
    	//eoc subhamay 16092013_to access traslated value(Mexico) for mont
    }
    /**
    * Static methos to get month value in 'MMM' format
    * @param key Integer
    * return String
    */
    public static String getMonth(Integer key) {
    	String strVal = '';
    	if(mapMonth != null) {
    		strVal = mapMonth.containsKey(key)? mapMonth.get(key):String.valueOf(key);
    	}
    	System.debug('Month key: '+key+', Value: '+strVal);
    	return strVal;
    }
}