public class GenealogyRootNodeInfo {
    
    private Map<String, List<Genealogy_Field_Detail__c>> mapFlds;
    private Market__c market;
    private Integer s_Current_Campaign{get; private set;}
    private String marketAccKey{get; private set;}
    private List<Genealogy_Field_Detail__c> listRepAllFlds;
    private String strRootNodeField='';
    public Contact p_Contact{get;set;}
    public String p_Name{get;set;}
    public String p_SalesZoneCode{get;set;}
    public List<GenealogyDataWrapper> listrootNodeData{get; private set;}
    public Integer g_Lft{get;set;}
    public Integer g_Rgt{get;set;}
    public String g_Root_Upline{get;set;}
    public Integer g_My_Level_From_Root{get;set;}
    public String g_CurrUsr_Title{get;set;}
    private String strKPILabel;
    private Map<String,String> g_LeaderTitles{get; private set;}
    public String g_mailPlanCd{get;set;}
    public List<Leader_title__c> leaderTitles{get;set;}
    public List<GenealogyDataWrapper> leaderCount{get;set;}
    public String s_title_Status {get; set;}
    
    
    public GenealogyRootNodeInfo() {        
        
    }
    public GenealogyRootNodeInfo(Market__c market,Map<String, List<Genealogy_Field_Detail__c>> mapGenFlds,Integer s_Current_Campaign,String marketAccKey,Map<String,String> m_LeaderTitles,List<Leader_title__c> leader_titles) {
        
        System.debug('inside GenealogyRootNodeInfo --');
        this.mapFlds = mapGenFlds;
        this.market = market;
        this.s_Current_Campaign = s_Current_Campaign;
        this.marketAccKey = marketAccKey;
        this.g_LeaderTitles = m_LeaderTitles;
        this.leaderTitles = leader_titles;
        listRepAllFlds = new List<Genealogy_Field_Detail__c>();
        
        String s_Genealogy_Display_Type='';
        String leaderGenealogy = ALMConstants.REPORT_TYPE_SL_GENEALOGY;
        if(String.valueOf(Apexpages.currentPage().getURL()).contains(leaderGenealogy) && Apexpages.currentPage().getParameters().get('pgId').equals('18')){
            s_Genealogy_Display_Type='N'; //N for Normal Genealogy & 'E' for Executive Genealogy
        }        
        else if(String.valueOf(Apexpages.currentPage().getURL()).contains(leaderGenealogy) && Apexpages.currentPage().getParameters().get('pgId').equals('11')){
            s_Genealogy_Display_Type='E'; 
        }
        
        if(mapFlds.get('Root') != null){
            listRepAllFlds.addAll(mapFlds.get('Root'));
        } 
        
        System.debug('listRepAllFlds --->'+listRepAllFlds);
        for(Genealogy_Field_Detail__c fld : listRepAllFlds) {
            System.debug('fld  -----:'+fld);
            if(fld.Fields_To_Map__c != null) {
                String temp = fld.Fields_To_Map__c;
                
                
                if(fld.Group__c.equals('Root')) {
                        if(temp.contains(':')){
                            String[] strFieldFrom = temp.split(':');                            
                            if(strFieldFrom[0] == 'ALM_Rep_Performance_1'){
                                strRootNodeField += strFieldFrom[1] + ',';
                            }
                        }               
                        
                    }
            }
        }
        
        if(this.market.Mail_Plan_Enabled__c == true){
            strRootNodeField = strRootNodeField+'MailPlan_Order_Oppty__r.MLPLN_CD__c,';
        }
        
     for(Leader_title__c ldrttl : this.leaderTitles)
       { if(ldrttl.EXEC_IND__c!='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2')        
       strRootNodeField+='GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
       else if(ldrttl.EXEC_IND__c =='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2')
       {
        strRootNodeField+='EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
       }
       }
        
        
        strRootNodeField = strRootNodeField !='' ? strRootNodeField.substring(0, strRootNodeField.length()-1):strRootNodeField;
        System.debug('strRootNodeField: '+strRootNodeField);
        
        
        String combinedQuery = '';
        SObject personalPerformObj;
        combinedQuery = 'Select Id,Name,SLS_ZONE_CD__c,(Select Id,TITL_STUS__c,'+strRootNodeField+',Genealogy_Level__c,LFT_ND_ID__c,RGT_ND_ID__c,ROOT_UPLN_ACCT_NR__c ,LDRSHP_TITL_LVL_NR__c From '+String.valueOf(this.market.ALM_Rep_Indicator__c).replace('__c', '__r')+' Where FLD_SLS_CMPGN_NR__c= ' +s_Current_Campaign + ') From Contact Where MRKT_ACCT_KEY__c='+'\''+marketAccKey+'\'';
        System.debug('combinedQuery ---->'+combinedQuery);
        
        p_Contact = Database.query(combinedQuery);
        if(p_Contact!=null){
            sObject[] obj_Rep_Performance = p_Contact.getSObjects(String.valueOf(this.market.ALM_Rep_Indicator__c).replace('__c', '__r'));
            p_Name = p_Contact.Name;
            p_SalesZoneCode = p_Contact.SLS_ZONE_CD__c;
            if(obj_Rep_Performance != null){
                personalPerformObj = obj_Rep_Performance.get(0);                
                g_Lft=Integer.valueOf(personalPerformObj.get('LFT_ND_ID__c'));
                g_Rgt=Integer.valueOf(personalPerformObj.get('RGT_ND_ID__c'));
                g_Root_Upline=String.valueOf(personalPerformObj.get('ROOT_UPLN_ACCT_NR__c'));
                g_My_Level_From_Root=Integer.valueOf(personalPerformObj.get('Genealogy_Level__c'));
                g_CurrUsr_Title=g_LeaderTitles.get(String.valueOf(personalPerformObj.get('LDRSHP_TITL_LVL_NR__c')));
                if(personalPerformObj.get('TITL_STUS__c') != null){
                	s_title_Status = String.valueOf(personalPerformObj.get('TITL_STUS__c'));
                }
                //s_CurrUsr_Style=m_LeaderStyles.get(String.valueOf(l_Rep_Performance.get('LDRSHP_TITL_LVL_NR__c')));
                if(this.market.Mail_Plan_Enabled__c == true && personalPerformObj.getsObject('MailPlan_Order_Oppty__r') != null){
                    g_mailPlanCd = String.valueOf((personalPerformObj.getSObject('MailPlan_Order_Oppty__r')).get('MLPLN_CD__c'));
                }
            }
        }
        
        listrootNodeData = new List<GenealogyDataWrapper>();
        populateData(personalPerformObj, listrootNodeData, this.mapFlds.get('Root'));
             
        leaderCount = new List<GenealogyDataWrapper>();
        Integer sumexec=0;
        Boolean executivePresent = false;
        for(Leader_title__c ldrttl:this.leaderTitles)
        { 
            if(ldrttl.EXEC_IND__c!='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2' && s_Genealogy_Display_Type == 'N')                
            {
            String fldname='GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
                      
            leaderCount.add(new GenealogyDataWrapper(ldrttl.LCL_LDRSHP_TITL_CD__c,String.valueOf(personalPerformObj.get(fldname)),'Number')  );
            //sum+=(leadercounttemp.ttl_count!=null)?Integer.valueOf(leadercounttemp.ttl_count):0;
            }else if(ldrttl.EXEC_IND__c =='Y' && String.valueOf(ldrttl.LDRSHP_TITL_LVL_NR__c) != '-2')
            {
            	executivePresent = true;
                String fldname='EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
                if(s_Genealogy_Display_Type == 'E'){
                    GenealogyDataWrapper leadercounttempexec=new GenealogyDataWrapper(ldrttl.LCL_LDRSHP_TITL_CD__c,String.valueOf(personalPerformObj.get(fldname)),'Number');
                    leaderCount.add(leadercounttempexec);
                }
            
            sumexec+=(personalPerformObj.get(fldname)!=null)?Integer.valueOf(personalPerformObj.get(fldname)):0;          
           }
        } 
        if(s_Genealogy_Display_Type == 'N' && executivePresent == true){
            leaderCount.add(new GenealogyDataWrapper(System.Label.EUL,String.valueOf(sumexec),'Number'));
        }        
        
    }
    
    
    
     private void populateData(SObject combinedObjData, List<GenealogyDataWrapper> listNodeData, List<Genealogy_Field_Detail__c> listFld) {
        
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
         
           listNodeData.add(new GenealogyDataWrapper(strKPILabel, fldValue,strType));           
            
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