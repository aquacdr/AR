global without sharing class GenealogyOverlayInfo {
    
    private Map<String, List<Genealogy_Field_Detail__c>> mapFlds_gen;
    private Integer s_Current_Campaign{get; private set;}
    private String marketAccKey{get; private set;}
    private List<Genealogy_Field_Detail__c> listGenAllFlds;
    private String strOverlayField='';
    public Contact g_Contact{get;set;}
    public String g_Name{get;set;}
    public String g_SalesZoneCode{get;set;}
    public String gen_mailPlanCd{get;set;}
    public List<GenealogyDataWrapper> col1{get; private set;}
    public List<GenealogyDataWrapper> col2{get; private set;}
    private String strKPILabel;
    public  Map<String,String> g_ldrTitles {get;set;}
    public List<GenealogyDataWrapper> overlayLeaderCount{get;set;}
    String s_Gen_Disp_Type {get;set;}
    public String g_TitleStatusCode {get;set;}
    public String leaderTitleCodes {get;set;}
    public String leftOverlayData {get;set;}
    
    public GenealogyOverlayInfo() {     
        
    }
    
    public GenealogyOverlayInfo(ID mrktID,String s_Query_Object,Boolean isMailPlan,Integer s_Current_Campaign,String marketAccKey,String s_UserLanguage, String s_Gen_Disp_Type) {
        
        this.mapFlds_gen = null;
        this.mapFlds_gen = YOUUtil.getGenealogyMapFields(mrktID) ;
        System.debug('mapFlds_gen  :'+this.mapFlds_gen);
        this.s_Current_Campaign = s_Current_Campaign;
        this.marketAccKey = marketAccKey;
        this.listGenAllFlds = new List<Genealogy_Field_Detail__c>();
        this.g_ldrTitles = new Map<String,String>();
        this.s_Gen_Disp_Type = s_Gen_Disp_Type;
                
        
        List<Leader_title__c> Leader_Title = [Select Id,LANG_CD__c,LCL_LDRSHP_TITL_CD__c,LDRSHP_TITL_LVL_NR__c,MRKT_ID__c,EXEC_IND__c From  Leader_Title__c Where Market__c=:mrktID and LANG_CD__c=:s_UserLanguage order by LDRSHP_TITL_LVL_NR__c];
                
                if(Leader_Title.size()>0){
                    for(Leader_Title__c obj_Leader : Leader_Title){
                        g_ldrTitles.put(String.valueOf(obj_Leader.LDRSHP_TITL_LVL_NR__c),obj_Leader.LCL_LDRSHP_TITL_CD__c);  
                    }
                }
        
                
        
        if(mapFlds_gen.get('Overlay') != null){
            listGenAllFlds.addAll(mapFlds_gen.get('Overlay'));
        } 
        
        System.debug('listGenAllFlds --->'+listGenAllFlds);
        for(Genealogy_Field_Detail__c fld : listGenAllFlds) {
            System.debug('fld  -----:'+fld);
            if(fld.Fields_To_Map__c != null) {
                String temp = fld.Fields_To_Map__c;
                if(fld.Group__c.equals('Overlay')) {
                                if(temp.contains(':')){
                                    String[] strFieldFrom = temp.split(':');                            
                                    if(strFieldFrom[0] == 'ALM_Rep_Performance_1'){
                                        strOverlayField += strFieldFrom[1] + ',';
                                    }
                                }               
                                
                            }
                }
            }
                    
            if(isMailPlan){
                strOverlayField = strOverlayField+'MailPlan_Order_Oppty__r.MLPLN_CD__c,';
            }   
            
     //Generate Dynamic query to retrieve leader count from Combined object       
     for(Leader_title__c ldrttl : Leader_Title)
       { 
            if(ldrttl.EXEC_IND__c!='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2'){        
                strOverlayField+='GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
            }
           else if(ldrttl.EXEC_IND__c =='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2')
           {
                strOverlayField+='EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
           }
       }
            
            
        strOverlayField = strOverlayField !='' ? strOverlayField.substring(0, strOverlayField.length()-1):strOverlayField;
        System.debug('strOverlayField: '+strOverlayField);
        
        String queryContact = '';  
        SObject personalPerformObj; 
        g_TitleStatusCode = '';      
         queryContact = 'Select Id,ACCT_NR__c,Shortened_Name__c,Name,SLS_ZONE_CD__c,(Select Id,'+strOverlayField+',TITL_STUS__c,RSNG_STR_IND__c From ' + s_Query_Object + ' Where FLD_SLS_CMPGN_NR__c='+s_Current_Campaign+') From Contact Where MRKT_ACCT_KEY__c='+'\''+marketAccKey+'\'';         
         System.debug('queryContact  -->'+queryContact);    
         
         g_Contact = Database.query(queryContact);
         
         if(g_Contact!=null){
            sObject[] obj_Rep_Performance = g_Contact.getSObjects(s_Query_Object);
            g_Name = g_Contact.Name;
            g_SalesZoneCode = g_Contact.SLS_ZONE_CD__c;
            if(obj_Rep_Performance != null){
                personalPerformObj = obj_Rep_Performance.get(0);
                if(personalPerformObj.get('TITL_STUS__c') != null){
                    g_TitleStatusCode = String.valueOf(personalPerformObj.get('TITL_STUS__c'));
                }
                if(isMailPlan == true && personalPerformObj.getsObject('MailPlan_Order_Oppty__r') != null){
                    gen_mailPlanCd = String.valueOf((personalPerformObj.getSObject('MailPlan_Order_Oppty__r')).get('MLPLN_CD__c'));
                }
            }
        }
        
        col1 = new List<GenealogyDataWrapper>();
        col2 = new List<GenealogyDataWrapper>();
        
        populateData(personalPerformObj, col1,col2, listGenAllFlds,this.g_ldrTitles);
        
        
        
        overlayLeaderCount = new List<GenealogyDataWrapper>();
        Integer sumexec=0;
        Boolean executivePresent = false;
        for(Leader_title__c ldrttl : Leader_Title)
        { 
            if(ldrttl.EXEC_IND__c!='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2' && this.s_Gen_Disp_Type == 'N')                
            {
                String fldname='GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';                      
                overlayLeaderCount.add(new GenealogyDataWrapper(ldrttl.LCL_LDRSHP_TITL_CD__c,String.valueOf(personalPerformObj.get(fldname)),'Number')  );            
            }else if(ldrttl.EXEC_IND__c =='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2')
            {
            	executivePresent = true;
                String fldname='EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
                if(this.s_Gen_Disp_Type == 'E'){
                        overlayLeaderCount.add(new GenealogyDataWrapper(ldrttl.LCL_LDRSHP_TITL_CD__c,String.valueOf(personalPerformObj.get(fldname)),'Number')  );
                    }
                sumexec+=(personalPerformObj.get(fldname)!=null)?Integer.valueOf(personalPerformObj.get(fldname)):0;           
           }
        } 
        if(this.s_Gen_Disp_Type == 'N' && executivePresent == true){
            overlayLeaderCount.add(new GenealogyDataWrapper(System.Label.EUL,String.valueOf(sumexec),'Number'));
        }
        
        
        leaderTitleCodes = '';
        for(GenealogyDataWrapper leaderttl : overlayLeaderCount){
            leaderTitleCodes+=leaderttl.strKPILabel;
            leaderTitleCodes+=':';
            leaderTitleCodes+=leaderttl.kpiValue;
            leaderTitleCodes+='    ';       
        }
        
        System.debug('leaderTitleCodes    --->'+leaderTitleCodes);
        
    }
    
    
    private void populateData(SObject combinedObjData, List<GenealogyDataWrapper> colData1,List<GenealogyDataWrapper> colData2, List<Genealogy_Field_Detail__c> listFld,Map<String,String> g_leaderttls) {
        
        //*****************populate KPI values.
        for(Genealogy_Field_Detail__c fld : listFld) {
            String fldValue = '';
            
            String[] strFldMaps = fld.Fields_To_Map__c.split(':');
          
            String strFieldMap = fld.Fields_To_Map__c;            
            strFldMaps = strFieldMap.split(':');
                       
            String strField = strFldMaps[1];
            String strType = fld.Type__c;
            if(strKPILabel != null || strKPILabel != '') {
                strKPILabel = this.getFieldLabel(fld.Fields_To_Map__c);// need to change here
            }
            
            fldValue = populateFields(combinedObjData, strField, strType);
            if(strKPILabel.equals(System.Label.Title)){
                fldValue = g_leaderttls.get(fldValue);
            }  
            
            
            if(fldValue != null) {
                if(fld.Column__c == '1') {
                    colData1.add(new GenealogyDataWrapper(strKPILabel, fldValue,strType));
                } else {
                    colData2.add(new GenealogyDataWrapper(strKPILabel, fldValue,strType));
                }               
            }         
                   
            
        } // end of field loop
    }
    
    
    
    
    private String populateFields(SObject sobject1, String strFields, String strType) {
        
        Integer nIndicator = 0;
        String val1 = '';
        if(sobject1 != null ) {
            System.debug('Here in loop PSB');
             if(nIndicator == 0) {
              Object oval1 = getFieldValue(sobject1, strFields);
               val1 = formatData(getStrValue(oval1, strType), strType);
             }else {
                    val1 = formatData(getStrValue(getFieldValue(sobject1, strFields), strType), strType);
             }
        }           
            
          return  val1;
    }
    
     public Object getFieldValue(SObject sobj, String strField) {       
        Object objValue = '';
        try {            
              objValue = sobj.get(strField);  
              System.debug(' inside getFieldValue  objValue :'+objValue);          
        } catch(Exception exe) {
            System.debug('getFieldValue Exception: '+exe);
            System.debug('SObject sobj: '+sobj+', String strField: '+strField);
        }
        return objValue;
    }
    
    public String formatData(String strData, String strType) {
        String strValue = strData;
        System.debug('formatData original value::::::::::'+strData+', Type::::::::-'+strType);
        if(strData != '' && (strType == 'Number' || strType == 'Percent'|| strType == 'Count')) {
            if(strData.contains('.')) {
                String[] strArr = strData.split('\\.', 2);
                if(strArr[1].length() > 0) {
                    strValue = strArr[0];
                    
                }
            }
        }
        System.debug('final formatData original value::::::::::'+strValue);
        return strValue;
    }
    
    
    
    
    
    public String getStrValue(Object val, String type) {
        String value = '';
        System.debug('getStrValue original value::::::::::'+val+', Type::::::::-'+type);
        try {
            if(type == 'Text') {
                value = (val!=null?String.valueOf(val):'-');    
            } else if(type == 'Number'){
                value = (val!=null?(((Double)val).format()):'0');               
            }
        } catch(Exception exe) {            
            System.debug('getValue Exception: '+exe);
            System.debug('Object val: '+val+', String type: '+type);            
        }
        System.debug('getStrValue after processed value::::::::::'+value);
        return value;
    }    
    
    
     public String getFieldLabel(String fldFieldToMap){
        String fldLabel;
        fldLabel = ALMReportLabels.getGenealogyReportLabel(fldFieldToMap);//fldFieldToMap; 
        return fldLabel;
    }
    
   
}