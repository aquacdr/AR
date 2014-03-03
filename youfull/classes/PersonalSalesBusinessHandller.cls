public class PersonalSalesBusinessHandller {
    
    public List<CoachingRecordWrapper> listPSBData{get; private set;}
    public List<CoachingRecordWrapper> listLDRData{get; private set;}
    //Code Changes by Rajib
    //public List<CoachingRecordWrapper> listLDRUIData{get; private set;} // subhamay 12032013 as per new requirment
     public List<CoachingRecordWrapper> listLDRUIG1Data{get; private set;} 
     public List<CoachingRecordWrapper> listLDRUIG2Data{get; private set;} 
     public List<CoachingRecordWrapper> listLDRUIG3Data{get; private set;}
     //EOC - Code Changes by Rajib 
    public List<CoachingRecordWrapper> listEUPData{get; private set;}
    
    public Boolean boolEUL{get; private set;}
        
    private String strKPILabel;
    private User currentUser;
    private Contact contactUser;
    private Market__c market;
    private List<Coaching_Header_Items__c> listBlkItm;
    private Map<String, List<Rep_Detail_Field__c>> mapFlds;
    private String strAccountNbr;
    private String strCmpgnNr;
    private List<Integer> listAllCmpgn;
    private List<String> listExternalKey;
    
    private MarketLeaderTitleUtils ldrTitlUtils;
    private MarketTagUtils mktTags;
    private ApexPages.Standardsetcontroller ctlrContact {get; private set;}
    private ApexPages.Standardsetcontroller ctlrMyBuiss {get; private set;}
    private ApexPages.Standardsetcontroller ctlrLdrSmry {get; private set;}
    
    private String strContactFlds = '';
    private String strMyBuissFlds = '';
    private String strLdrSmryFlds = '';
    
    /**
    * default constructor
    */
    public PersonalSalesBusinessHandller() {
        
    }
    
    /**
    * overloaded constructor
    * @param contactUser Contact
    * @param market Market__c
    * @param strAccountNbr String
    * @param mapFlds Map<String, List<Rep_Detail_Field__c>>
    * @param listAllCmpgn List<Integer>
    * @param ldrTitlUtils MarketLeaderTitleUtils
    */
    public PersonalSalesBusinessHandller(Contact salesContactData, Contact contactUser, Market__c market, String strAccountNbr, Map<String, List<Rep_Detail_Field__c>> mapFlds, List<Integer> listAllCmpgn, MarketLeaderTitleUtils ldrTitlUtils, MarketTagUtils mktTags) {
        this.contactUser = contactUser;
        this.market = market;
        this.strAccountNbr = strAccountNbr;
        this.mapFlds = mapFlds;
        this.listAllCmpgn = listAllCmpgn;
        this.ldrTitlUtils = ldrTitlUtils;
        this.mktTags = mktTags;
        /*
        // create external key for My Business and Ldr Dwn Summry object
        listExternalKey = new List<String>();
        for(Integer camp : this.listAllCmpgn) {
            String val = String.valueOf(this.contactUser.MRKT_ID__c) + String.valueOf(camp) + String.valueOf(this.contactUser.ACCT_NR__c);
            listExternalKey.add(val);
        }
        //System.debug('External Key: '+listExternalKey);
                
        //strMktCurrencySymbol = market.Market_Currency_Symbol__c;
        for(Rep_Detail_Field__c fld : this.mapFlds.get(ALMConstants.CR_PSB)) {
            createQueryString(fld.Fields_To_Map__c);
        }
        for(Rep_Detail_Field__c fld : this.mapFlds.get(ALMConstants.CR_LDR_TUS)) {
            createQueryString(fld.Fields_To_Map__c);
        }
        //subhamay 12032013 as per new requirment
        for(Rep_Detail_Field__c fld : this.mapFlds.get(ALMConstants.CR_LDR_UI)) {
            createQueryString(fld.Fields_To_Map__c);
        }
        //eoc subhamay 12032013 as per new requirment
        for(Rep_Detail_Field__c fld : this.mapFlds.get(ALMConstants.CR_EUP)) {
            createQueryString(fld.Fields_To_Map__c);
        }
        
        //final query fields in string
        if(strContactFlds != '') {
            strContactFlds = strContactFlds.substring(0, strContactFlds.length()-1);
        }
        if(strMyBuissFlds != '') {
            strMyBuissFlds = strMyBuissFlds.substring(0, strMyBuissFlds.length()-1);
        }
        if(strLdrSmryFlds != '') {
            strLdrSmryFlds = strLdrSmryFlds.substring(0, strLdrSmryFlds.length()-1);
        }
        //System.debug('listExternalKey: '+listExternalKey);
        //System.debug('listAllCmpgn: '+listAllCmpgn);
        
        String strCont = '';
        if(strContactFlds != null && strContactFlds != '') {
            strCont = 'SELECT ACCT_NR__c, '+strContactFlds;
        } else {
            strCont = 'SELECT ACCT_NR__c ';
        }
        strCont += ' FROM Contact WHERE MRKT_ACCT_KEY__c=\''+this.contactUser.MRKT_ACCT_KEY__c+'\' AND MRKT_ID__c=\''+this.contactUser.MRKT_ID__c+'\' AND  ACCT_NR__c=\''+this.contactUser.ACCT_NR__c+'\'';         
        //System.debug('create Contact sql: '+strCont);
        
        String strMyBuinsSOQL = '';
        if(strMyBuissFlds != null && strMyBuissFlds != '') {
            strMyBuinsSOQL = 'SELECT ACCT_NR__c, '+strMyBuissFlds;
        } else {
            strMyBuinsSOQL = 'SELECT ACCT_NR__c ';
        }
        strMyBuinsSOQL += ' FROM My_Business__c WHERE MRKT_ID__c=\''+this.contactUser.MRKT_ID__c+'\' AND  ACCT_NR__c=\''+this.contactUser.ACCT_NR__c+'\' AND Personal_Performance_Key__c IN :listExternalKey AND FLD_SLS_CMPGN_NR__c IN :listAllCmpgn ORDER BY FLD_SLS_CMPGN_NR__c DESC';           
        //System.debug('create My Business sql: '+strMyBuinsSOQL);
        
        String strLdrSOQL = '';
        if(strLdrSmryFlds != null && strLdrSmryFlds != '') {
            strLdrSOQL = 'SELECT ACCT_NR__c, '+strLdrSmryFlds;
        } else {
            strLdrSOQL = 'SELECT ACCT_NR__c ';
        }
        strLdrSOQL += ' FROM Leader_Downline_Summary__c WHERE MRKT_ID__c=\''+this.contactUser.MRKT_ID__c+'\' AND  ACCT_NR__c=\''+this.contactUser.ACCT_NR__c+'\' AND Leadership_Summary_Key__c IN :listExternalKey AND FLD_SLS_CMPGN_NR__c IN :listAllCmpgn ORDER BY FLD_SLS_CMPGN_NR__c DESC';         
        //System.debug('create LDR sql: '+strLdrSOQL);
        
        ctlrContact = new ApexPages.Standardsetcontroller(database.query(strCont));
        ctlrMyBuiss = new ApexPages.Standardsetcontroller(database.query(strMyBuinsSOQL));
        ctlrLdrSmry = new ApexPages.Standardsetcontroller(database.query(strLdrSOQL));
        */
        listPSBData = new List<CoachingRecordWrapper>();
        //populateData(ctlrContact, ctlrMyBuiss, ctlrLdrSmry, listPSBData, this.mapFlds.get('PSB'));
        populateData(salesContactData, listPSBData, this.mapFlds.get('PSB'));
        //System.debug('listPSBData: '+listPSBData);
               
        listLDRData = new List<CoachingRecordWrapper>();
        populateData(salesContactData, listLDRData, this.mapFlds.get('LDR_TUS'));
        //System.debug('listLDRData: '+listLDRData);
		    //subhamay 12032013 as per new requirment
        //Code Changes by Rajib
      //  listLDRUIData = new List<CoachingRecordWrapper>();
       // populateData(salesContactData, listLDRUIData, this.mapFlds.get('LDR_UI'));
        
        listLDRUIG1Data = new List<CoachingRecordWrapper>();
        populateData(salesContactData, listLDRUIG1Data, this.mapFlds.get('LDR_UI_G1'));
        
        listLDRUIG2Data = new List<CoachingRecordWrapper>();
        populateData(salesContactData, listLDRUIG2Data, this.mapFlds.get('LDR_UI_G2'));
        
        listLDRUIG3Data = new List<CoachingRecordWrapper>();
        populateData(salesContactData, listLDRUIG3Data, this.mapFlds.get('LDR_UI_G3'));
        
        //System.debug('listLDRUIData: '+listLDRData);
        //eoc subhamay 12032013 as per new requirment
        //EOC - Code Changes by Rajib
        boolEUL = false;
        listEUPData = new List<CoachingRecordWrapper>();
        populateData(salesContactData, listEUPData, this.mapFlds.get('EUP'));
        //System.debug('listEUPData: '+listEUPData);
    }
    
    /**
    * create query string for each objects.
    * @param strFldMap String
    * return void
    */
    /*private void createQueryString(String strFldMap) {
        if(strFldMap != null) {
        	if(!strFldMap.contains(ALMConstants.DUPLICATE_KPI)) {
	            String[] str = strFldMap.split(':',2);
	            if(str[0].equals('Contact_Key__r')) {
	                strContactFlds += str[1] + ',';
	            } else if(str[0].equals('Personal_Performance_Key__r')) {
	                strMyBuissFlds += str[1] + ',';
	            } else if(str[0].equals('Leader_Downline_Summary__r')) {
	                strLdrSmryFlds += str[1] + ',';
	            }
        	}
        }
    }*/
    /**
    * populate all KPI value far section in Coaching record page.
    * @param rsltCont ApexPages.Standardsetcontroller
    * @param rsltBuss ApexPages.Standardsetcontroller
    * @param rsltLdr ApexPages.Standardsetcontroller
    * @param listCampgn List<CoachingRecordWrapper>
    * @param listFld List<Rep_Detail_Field__c>
    * return void
    */
    private void populateData(Contact salesHistoryData, List<CoachingRecordWrapper> listCampgn, List<Rep_Detail_Field__c> listFld) {
        Boolean altRow = false;
        Boolean firstBlock = false;
        Boolean secondBlock = false;
        //List<SObject> listCont = (List<SObject>)rsltCont.getRecords();
        //List<SObject> listBuss = (List<SObject>)rsltBuss.getRecords();
        //List<SObject> listLdr = (List<SObject>)rsltLdr.getRecords();
        //*****************populate KPI values.
        for(Rep_Detail_Field__c fld : listFld) {
            altRow = !altRow;
            Boolean isRuntime = fld.isRuntime__c;
            //String strRunTime = fld.Fields_To_Map__c.split(',')[0].replace(':','.');
            String[] strFldMaps = fld.Fields_To_Map__c.split(':');
            //subhamay for duplicate kpi
            String strFieldMap = fld.Fields_To_Map__c;
            if(strFieldMap.contains(ALMConstants.DUPLICATE_KPI)) {
            	strFldMaps = strFieldMap.split('-')[1].split(':');
            } else {
            	strFldMaps = strFieldMap.split(':');
            }
            //eoc subhamay for duplicate kpi
            //String strObj = strFldMaps[0];
            String strField = strFldMaps[1];
            String strType = fld.Type__c;
            if(strKPILabel != null || strKPILabel != '') {
                //strKPILabel = PersonalInfoHandeller.getFieldLabel(fld.Fields_To_Map__c);// need to change here
                strKPILabel = (new PersonalInfoConfig()).getFieldLabel(fld.Name, fld.Fields_To_Map__c);// to change market tag.
            }
            
            List<String> listData;
            /*if(strObj.equals('Contact_Key__r')) {
                listData = populateFields(listCont, strField, strType, isRuntime);
            } else if(strObj.equals('Personal_Performance_Key__r')) {
                listData = populateFields(listBuss, strField, strType, isRuntime);
            } else if(strObj.equals('Leader_Downline_Summary__r')) {
                listData = populateFields(listLdr, strField, strType, isRuntime);
            }*/
            //if(salesHistoryData.Sales_Leader_Histories__r != null && salesHistoryData.Sales_Leader_Histories__r.size()>0) {
            	listData = populateFields(salesHistoryData.Sales_Leader_Histories__r, strField, strType, isRuntime);
            //}
            //listData = populateFields(salesHistoryData.Sales_Leader_Histories__r, strField, strType, isRuntime);
            System.debug('strKPILabel: '+strKPILabel+', altRow: '+altRow+', listData: '+listData);
            //subhamay 01042013 as requirment in google docs row 25/26
            /*if(fld.isZeroRow__c && !isDataContains(listData)) {
            	System.debug('!!!Empty KPI!!!. name: '+fld.Name+'Field to mapping: '+fld.Fields_To_Map__c);
            } else {*/
            	listCampgn.add(new CoachingRecordWrapper(strKPILabel, altRow, listData));
            //}
            //eoc subhamay 01042013
            
        } // end of field loop
    }
    /**
    * fetched all campaign value for each KPI
    * @param listSObject List<SObject>
    * @param strFields String
    * @param strType String
    * @param isRuntime Boolean
    * return List<String>
    */
    private List<String> populateFields(List<SObject> listSObject, String strFields, String strType, Boolean isRuntime) {
        String[] strFieldToMap = strFields.split(',');
        String strFieldMap1 = strFieldToMap[0];
        String strFieldMap2 = strFieldToMap[1];
        Integer nIndicator = 0;
        List<String> listData = new  List<String>();
        System.debug('listSObject size--------'+listSObject.size()); 
        if(listSObject != null && listSObject.size() > 0) {System.debug('Here in loop PSB');
	        for(SObject sData: listSObject) {
	            if(nIndicator == 0) {
	                Object oval1 = getFieldValue(sData, strFieldMap1);
	                Object oval2 = getFieldValue(sData, strFieldMap2);
	                
	                String val1 = formatData(getStrValue(oval1, strType), strType);
	                String val2 = formatData(getStrValue(oval2, strType), strType);
	                String diff = formatData(getDiff(oval1, oval2, strType), strType);
	                if(isRuntime) {
	                    if(strFields.equals(ALMConstants.LDR_TITLE) || strFields.equals(ALMConstants.PD_TITLE)) {                      
	                        val1 = this.ldrTitlUtils.getLeaderTitle(val1)!=null?this.ldrTitlUtils.getLeaderTitle(val1):'-';
	                        val2 = this.ldrTitlUtils.getLeaderTitle(val2)!=null?this.ldrTitlUtils.getLeaderTitle(val2):'-';
	                    }
	                }
	                listData.add(diff);
	                listData.add(val1); // current campaign value
	                listData.add(val2); // sppy campaign value
	            } else {
	                String val1 = formatData(getStrValue(getFieldValue(sData, strFieldMap1), strType), strType);
	                if(isRuntime) {
	                    if(strFields.equals(ALMConstants.LDR_TITLE) || strFields.equals(ALMConstants.PD_TITLE)) {
	                        val1 = this.ldrTitlUtils.getLeaderTitle(val1)!=null?this.ldrTitlUtils.getLeaderTitle(val1):'-';
	                    }
	                }
	                listData.add(val1); // previous campaign value
	            }
	            nIndicator++;
	        } // end of data loop
        }
        // add extra campaign default value 
        Integer nCampgnCnt = (this.market.X90_Day_Camp_CNT__c == null)? 0 : Integer.valueOf(this.market.X90_Day_Camp_CNT__c);
        if(nCampgnCnt > 6) {
            nCampgnCnt = 6;
        }
        
        Integer nListDataSize = listData.size();
        // subhamay 01092013_to remove current campaign details from list
        //Integer nCount = (nCampgnCnt + 3) - nListDataSize; 
        Integer nCount = (nCampgnCnt + 3) - nListDataSize - 1;
        // eoc subhamay 01092013
        for(Integer i = 0; i < nCount; i++) {
            listData.add('-');
        }
        return listData;
    }
    /**
    * get object value for a field
    * @param sobj SObject
    * @param strField String
    * return Object
    */
    public static Object getFieldValue(SObject sobj, String strField) {
        Object objValue = '';
        try {
            /*if(strField.contains('.')) {
                String[] strArr = strField.split('\\.', 2);
                objValue = sobj.getsObject(strArr[0]).get(strArr[1]);
            } else {*/
                objValue = sobj.get(strField);
            //}
        } catch(Exception exe) {
            System.debug('getFieldValue Exception: '+exe);
            System.debug('SObject sobj: '+sobj+', String strField: '+strField);
        }
        return objValue;
    }
    /**
    * get KPI value in String format
    * @param val Object
    * @param type String
    * return String
    */
    public static String getStrValue(Object val, String type) {
        String value = '';
        try {
            if(type == 'Text') {
                value = (val!=null?String.valueOf(val):'-');    
            } else if(type == 'Percent') {
            	//subhamay 010420113_ removed '%' as Supriyo's mail dated 30/03/2013 pts#2
                //value = (val!=null?String.valueOf(val)+'%':'-');
                value = (val!=null?String.valueOf(val) : '-');
                //eoc subhamay 010420113
            } else if(type == ALMConstants.DATE_DDMM) { 
                value = (val!=null?String.valueOf(val):'');
                if(value != '') {
                    List<String> listdt = value.split(' ',2);
                    String[] dt = listdt.get(0).split('-',3);
                    value = dt[1] +'-'+ dt[2];
                }
            } else if(type == ALMConstants.DATE_MMDD) { 
                value = (val!=null?String.valueOf(val):'');
                if(value != '') {
                    List<String> listdt = value.split(' ',2);
                    String[] dt = listdt.get(0).split('-',3);
                    value = dt[2] +'-'+ dt[1];
                }
            } else if(type == ALMConstants.DATE_DDMMYY) { 
                value = (val!=null?String.valueOf(val):'');
                if(value != '') {
                    List<String> listdt = value.split(' ',2);
                    String[] dt = listdt.get(0).split('-',3);
                    value = dt[1] +'/'+ dt[2] +'/'+ dt[0].substring(1);
                }
            } else if(type == ALMConstants.DATE_DDMMYYYY) { 
                value = (val!=null?String.valueOf(val):'');
                if(value != '') {
                    List<String> listdt = value.split(' ',2);
                    String[] dt = listdt.get(0).split('-',3);
                    value = dt[1] +'-'+ dt[2] +'-'+ dt[0];
                }
            } else if(type == 'Number'){
                value = (val!=null?(((Double)val).format()):'0');
                /*if(value != '0' && !value.contains('.')) {
                    value += '.0';
                }*/ //changed by swarnava for Number Truncating
            } else if(type == 'Count') {
                value = (val!=null?String.valueOf(val):'0');
            }
        } catch(Exception exe) {            
            System.debug('getValue Exception: '+exe);
            System.debug('Object val: '+val+', String type: '+type);            
        }
        return value;
    }
    /**
    * calculate variance between current campaign and SPPY campaign
    * @param val1 Object
    * @param val2 Object
    * @param type String
    * return String
    */
    private String getDiff(Object val1, Object val2, String type) {
        String diff = '';    
        Double d1 = 0;
        Double d2 = 0;    
        try {
            //if(type == 'Count') {
            	//System.debug('val1 Integer--->'+val1);
            	if(type == 'Text') {
                    diff = '-';
            	} else {
	            	//if(val1 != '-'){
	                	d1 = (val1!=null?Double.valueOf(formatData(String.valueOf(val1), type)):0);
	            	//}
	            	//if(val2 != '-'){
	                	d2 = (val2!=null?Double.valueOf(formatData(String.valueOf(val2), type)):0);
	            	//}
	                Double dVariance = (d1 - d2);
	                if(dVariance != 0) {
	                    diff = String.valueOf(dVariance);
	                } else {
	                    diff = '-';
	                }
            	}
            /*} else {
            	System.debug('val1 Double--->'+val1);
            	if(val1 != '-'){
                	d1 = (val1!=null?Integer.valueOf(val1):0);
            	}
            	if(val2 != '-'){
                	d2 = (val2!=null?Integer.valueOf(val2):0);
            	}
                Integer dVariance = (d1 - d2);
                   
                if(type == 'Text') {
                    diff = '-';
                } else if(type == 'Number') {
                    if(dVariance != 0) {
                        //diff = String.valueOf(dVariance);
                        diff = dVariance.format();
                       /* if(!diff.contains('.')) {
                            System.debug('Here:::::: diff: '+diff);
                            diff += '.0';
                            System.debug('Here:::::: diff: '+diff);
                        }*/  //changed by swarnava for Number Truncating
                    /*} else {
                        diff = '-';
                    }
                } else if(type == 'Percent') {
                    if(dVariance > 0) {
                        //diff = String.valueOf(dVariance)+'0%';
                        //subhamay 010420113_removed '%' as Supriyo's mail dated 30/03/2013 pts#2
                        diff = dVariance.format();
                        //subhamay 01042013
                    } else if(dVariance < 0) {
                        //diff = String.valueOf(dVariance)+'0%';
                        //subhamay 010420113_removed '%' as Supriyo's mail dated 30/03/2013 pts#2
                        diff = dVariance.format();
                        //subhamay 01042013
                    } else {
                        diff = '-';
                    }
                }
            }*/
            //System.debug('type: '+type+', diff: '+diff+', val1: '+val1+', val2: '+val2);
        } catch(Exception exe) {
            System.debug('getDiff Exception: '+exe);
            System.debug('Object val1: '+val1+', Object val2: '+val2+', String type: '+type);
        } 
        return diff;        
    }
    
    public static String formatData(String strData, String strType) {
        String strValue = strData;
        System.debug('formatData original value::::::::::'+strData+', Type::::::::-'+strType);
        if(strData != '' && (strType == 'Number' || strType == 'Percent'|| strType == 'Count')) {
            if(strData.contains('.') && strType != 'Count') {
                String[] strArr = strData.split('\\.', 2);
                if(strArr[1].length() == 1) {
                    //strValue = strArr[0]/*+'.'+strArr[1].subString(0, 1)*/;// Changed by Swarnava - defect id : 2350 Truncate Number
                    strValue = strArr[0]+'.'+strArr[1].subString(0, 1)+'0';// Changed by Swarnava - defect id : 2350 Truncate Number
                    //subhamay 010420113_removed '%' as Supriyo's mail dated 30/03/2013 pts#2
                    //if(strType == 'Percent') {
                        //strValue += '%';
                    //}
                    //eoc subhamay 010420113
                } else if(strArr[1].length() > 1) {
                	strValue = strArr[0]+'.'+strArr[1].subString(0, 2);
                }
            } else if(strData.contains('.') && strType == 'Count') {
            	String[] strArr = strData.split('\\.', 2);
            	if(strArr[1].length() > 0) {
            		strValue = strArr[0];
            	}
            }
        }
        //System.debug('final formatData original value::::::::::'+strValue);
        return strValue;
    }
    //subhamay 01042013 as requirment in google docs row 25/26
    /*private Boolean isDataContains(List<String> listValues) {
    	Boolean isBlank = false;
    	for(String strKpiValue : listValues) {
    		System.debug('strKpiValue----: '+strKpiValue);
    		if(strKpiValue != '0' && strKpiValue != '-') {
    			isBlank = true;
    			break;
    		}
    	}
    	return isBlank;
    }
    //eoc subhamay 01042013
    /**
    * Wrapper class will contain all KPI details.
    */
    public class CoachingRecordWrapper {
        public String strKPILabel{get; private set;}
        public Boolean altRow{get; private set;}
        public List<String> listData{get; private set;}
        public CoachingRecordWrapper(String strKPI, Boolean bRow, List<String> data) {
            strKPILabel = strKPI;
            altRow = bRow;
            listData = data;
        }        
    }
}