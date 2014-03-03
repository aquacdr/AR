/**
    this class is used to get all Personal Information Data
*/
public class PersonalInfoConfig {

    public String fldLabel {get; set;}
    public String fldType {get; private set;}
    public String fldName {get; private set;}
    public String fldFieldToMap {get; private set;}
    public String fldGroup {get; private set;}
    public String fldValue {get; private set;}
    public Boolean isRuntime {get; private set;}
    public String strLdrTitle{get; private set;}
    
    private String[] strFieldFrom;
    private String strTempFieldToMap;
    private MarketLeaderTitleUtils ldrTitlUtils;
    private MarketSellerStsUtils sellStsUtils;
    private MarketTagUtils mktTags;
    public Boolean IsEmpty {get; set;}
    private SObject sobjData;
    private Sales_Organization__c salesData;
    private Rep_Detail_Field__c fldMaster;
    private Map<String,Sales_Organization__c> salesOrgMap;
    private Map<Integer, String> mapMonth;
    private Map<Integer, String> mapPresidentClubStatus;
    
    //default constructor
    public PersonalInfoConfig(){}    
    /**
    * overloaded constructor for PersnalInfoConfig
    * @param objData SObject
    * @param fldMaster Rep_Detail_Field__c
    * @param ldrTitlUtils MarketLeaderTitleUtils
    * @param sellStsUtils MarketSellerStsUtils
    */
    public PersonalInfoConfig(SObject objData, Rep_Detail_Field__c fldMaster, MarketLeaderTitleUtils ldrTitlUtils, MarketSellerStsUtils sellStsUtils, MarketTagUtils mktTags) {    
        this.ldrTitlUtils = ldrTitlUtils;
        this.sellStsUtils = sellStsUtils;
        this.mktTags = mktTags;
        this.fldMaster = fldMaster;
        
        this.fldName = fldMaster.Name;
        this.fldType = fldMaster.Type__c;
        this.fldGroup = fldMaster.Group__c;
        this.isRuntime = fldMaster.isRuntime__c;
        this.strTempFieldToMap = fldMaster.Fields_To_Map__c;
        //this.fldLabel = PersonalInfoHandeller.getFieldLabel(strTempFieldToMap); to include Market Code
        this.fldLabel = getFieldLabel(this.fldName, strTempFieldToMap);
        this.fldFieldToMap = this.strTempFieldToMap;
        this.sobjData = objData;
                
        Object fldVal;
        if(this.sobjData != null) {
            fldVal = getFieldValue();
        }
		if(fldVal != null) {
			fldValue = String.valueOf(fldVal);
			/*if(this.fldType== 'DDMM' && fldValue != '') {
				List<String> listdt = fldValue.split(' ',2);
				String[] dt = listdt.get(0).split('-',3);
				fldValue = dt[1] +'-'+ dt[2];
			} else*/ if(this.fldType== 'DDMMM' && fldValue != '') {
				List<String> listdt = fldValue.split(' ',2);
				String[] dt = listdt.get(0).split('-',3);
				fldValue = dt[2] +'-'+ PersonalInfoHandeller.getMonth(Integer.valueOf(dt[1]));
			} /*else if(this.fldType== 'MMDD' && fldValue != '') {
				List<String> listdt = fldValue.split(' ',2);
				String[] dt = listdt.get(0).split('-',3);
				fldValue = dt[2] +'-'+ dt[1];			
			} else*/ if(this.fldType== 'DDMMYYYY' && fldValue != '') {
				List<String> listdt = fldValue.split(' ',2);
				String[] dt = listdt.get(0).split('-',3);
				fldValue = dt[1] +'/'+ dt[2] +'/'+ dt[0];			
			}
			System.debug('Date value: '+fldValue+', fldType: '+fldType);
		}
    }
    
	/**
	* get field value
	* return Object 
	*/ 
    private Object getFieldValue() {
        Object objTemp = '';
        Object fldVal = '';
        System.debug('fldFieldToMap---'+fldFieldToMap+' ------ '+isRuntime+' ------fldName: '+fldName);
        if(fldFieldToMap != null && fldFieldToMap != '') {
        	if(this.fldGroup == 'Contact' && (fldFieldToMap.contains('ALM_Rep_Performance_1:') || fldFieldToMap.contains('Mail_Plan:'))) {
        		String[] strData = fldFieldToMap.split(':');
        		//try {
        		if(fldFieldToMap.contains('Mail_Plan:') && sobjData != null){        			
        			String strMPlanData = strData[1];
        			String[] strArr = strMPlanData.split('\\.');        			
        			fldVal = sobjData.get(strArr[1]);       			     			
        		}else{
        			if(sobjData != null) { 	
        				fldVal = sobjData.get(strData[1]);
        			} 
        		}
	        		if(isRuntime == true) {
	        			if(fldName == ALMConstants.LEADER_TITLE || fldName == ALMConstants.TOP_TITLE){
	        				strLdrTitle = (String)fldVal;
	        				if(strLdrTitle == null) {
        						strLdrTitle = '-2';
        					}
	        				fldVal = this.ldrTitlUtils.getLeaderTitle(strLdrTitle);
	        			} else if(fldName == ALMConstants.LEADER_PCS || fldName == ALMConstants.LEADER_PCS_PREV 
        					|| fldName == ALMConstants.TOP_PCS || fldName == ALMConstants.TOP_PCS_PREV) {
	        				fldVal = this.sellStsUtils.getSellerStatus((String)fldVal);
	        			}
	        		}
        		/*} catch(Exception e) {
        			System.debug('Sales Leader History object is not found. Error: '+e);
        			fldVal='';
        		}*/
        	} else if(this.fldGroup == 'Contact' && fldFieldToMap.contains('SalesOrg:')) {
        		String[] strData = fldFieldToMap.split(':');        		
        		fldVal = sobjData.get(strData[1]);
        	} else if(this.fldGroup == 'Contact') {
        		if(fldFieldToMap.contains('Upline:')) {
        			fldFieldToMap = fldFieldToMap.split(':')[1];
        		}
	        	for(String fld : fldFieldToMap.split(',')) {
		            if(isRuntime == true) {
		                //fldVal = getRuntimeValue(fld);
		                if(fldName == ALMConstants.LEADER_TITLE || fldName == ALMConstants.TOP_TITLE){
	        				strLdrTitle = (String)fldVal;
	        				if(strLdrTitle == null) {
        						strLdrTitle = '-2';
        					}
	        				fldVal = this.ldrTitlUtils.getLeaderTitle(strLdrTitle);
	        			} else if(fldName == ALMConstants.LEADER_PCS || fldName == ALMConstants.LEADER_PCS_PREV 
        					|| fldName == ALMConstants.TOP_PCS || fldName == ALMConstants.TOP_PCS_PREV) {
	        				fldVal = this.sellStsUtils.getSellerStatus((String)fldVal);
	        			}
		            } else {
		            	if(fld.contains('.')) {
		            		String[] strArr = fld.split('\\.',2);
		            		try {
		            			fldVal = sobjData.getsObject(strArr[0]).get(strArr[1]);
		            		} catch(Exception exe) {
		            			fldVal = sobjData.get(strArr[1]);
		            		}
		            	} else {
		            		fldVal = sobjData.get(fld);
		            	}
		            }
		            if(this.fldName == ALMConstants.SPONSOR_NAME) {
		            	if(fldVal != null) {
		                    objTemp += fldVal + ' ';
		                } else {
		                    objTemp += '' + '-';
		                }
		            } else if(this.fldName == ALMConstants.CURRENT_PRESIDENT_STATUS) {
		                if(fldVal != null) {
		                    objTemp += fldVal + '-';
		                } else {
		                    objTemp += '';
		                }
		            } else if(this.fldName == ALMConstants.HOME_ADDRESS) {
		                if(fldVal != null) {
		                    objTemp += fldVal + ',';
		                } else {
		                    objTemp += '' + '-';
		                }
		            } else if(this.fldName == ALMConstants.SECONDARY_PH) {
		            	if(fldVal == null || String.valueOf(fldVal).equals('')) {
		            		fldVal = sobjData.get(ALMConstants.WORK_PH_FIELD);
		            	}
		            }
	            }
	        }
	    }
        if(objTemp != '') {
            String strValue = (String)objTemp;
            strValue = strValue.substring(0, strValue.length() - 1);
            if(strValue == '-' || strValue == '---' || strValue == '0' || strValue == '') {
            	strValue = null;
            }
            return (Object)strValue;  
        } else {
            return fldVal;
        }
    }
    
    public String getFieldLabel(String fldName, String fldFieldToMap){
		String fldLabel; 
		if(fldName.indexOf(ALMConstants.RUNTIME)==-1){
			//fldLabel = PersonalInfoHandeller.getFieldLabel(this.strTempFieldToMap);
			fldLabel = fldLabel = ALMReportLabels.getCoachRecordLabel(fldFieldToMap);
		}else{
			//ALMLogUtils.log('ReportDetail.getFieldLabel','fldName:'+fldName);
			if(fldName.indexOf(ALMConstants.REP_MKT_TAG)>-1){
				fldLabel = mktTags.getLabel('Representative Detail', 'Market Tag '+fldName.substring(fldName.length()-1));
			}else if(fldName.indexOf(ALMConstants.ALM_MKT_TAG)>-1){
				fldLabel = mktTags.getLabel('ALMRepPerf Detail', 'Market Tag '+fldName.substring(fldName.length()-1));			
			}else if(fldName.indexOf(ALMConstants.TITLE_TAG)>-1){
				fldLabel = ldrTitlUtils.getLeaderTitle(fldName.substring(fldName.length()-1));
			}
		}
		//System.debug('Label got: '+fldLabel);
		return fldLabel;
	}
}