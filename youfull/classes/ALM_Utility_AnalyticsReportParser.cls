/***************************************************************************
 Name          : ALM_Utility_AnalyticsReportParser 
 Description   : Report JSON string parser
 Created By    : Parul Gupta 
 Created Date  : 16 Dec, 2013                
****************************************************************************/
global class ALM_Utility_AnalyticsReportParser {
  
    //Store the parsing Information in the top Level object
    private Map<String,Object> mpTopLevelParse = new Map<String,Object>();
    public static Map<String, Schema.SObjectType> schemaMap;
   static {
    	  
    	schemaMap = Schema.getGlobalDescribe();
    	
    	
    }
  
    //===================================================================//
    //Constructor
    //===================================================================//
    public ALM_Utility_AnalyticsReportParser(String inputJSONStr) {
        system.debug('analyticparser = ' + inputJSONStr);
        this.mpTopLevelParse = (Map<String,Object>)JSON.deserializeUntyped(inputJSONStr);
    }
   
    //========================================================================//
    //Retrieve Data Table using the Report JSON String
    //========================================================================//
    /*public Component.Apex.DataTable getVFDataTable() {
        Component.Apex.DataTable tbl = new Component.Apex.DataTable(var='item');
        List<String> lstHeader = getHeader();
        List<List<String>> data = getDataHtml();
        String tableColor = '#ced9dd';
        tbl.value = data;
        for(Integer index = 0; index < lstHeader.size(); index++){
            Component.Apex.OutputText header = 
                    new Component.Apex.OutputText(value=lstHeader[index]);
            header.style = 'padding-right:5px;border: solid '+tableColor;
            Component.Apex.Column col = new Component.Apex.Column();
            col.expressions.value = '{!item[' + index + ']}';
            col.facets.header = header;
            col.style = 'padding-right:5px;border: solid '+tableColor;
            tbl.style = 'border: solid '+tableColor;
            tbl.childComponents.add(col);
        }       
        return tbl;
    }
  
    //==============================================================================//
    //Get Data Html 
    //=============================================================================//
    private List<List<String>> getDataHtml() {
        Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
        Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        List<Object> lstArray        = (List<Object>)mpDataMap.get('rows');
    
        List<List<String>> lstRowData = new List<List<String>>();
        for(Object row :lstArray) {
          Map<String,Object> mpRowObj = (Map<String,Object>)row;
          List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
          system.debug('*****lstDataCell*****'+lstDataCell);
          List<String> lstRow = new List<String>();
          for(Object dataCellRow :lstDataCell) {
            Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
            system.debug('*****lstrow*****'+String.valueOf(dataCell.get('label')));
            lstRow.add(String.valueOf(dataCell.get('label')));
          }
          lstRowData.add(lstRow);
        }
    
        return lstRowData;
    }
  
    //==============================================================================//
    //Get Header
    //=============================================================================//
    public List<String> getHeader() {
        List<String> lstHeader = new List<String>();
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
        Map<String,Object> mpReportExtendedMetadata = (Map<String,Object>)mpTopLevelParse.get('reportExtendedMetadata'); 
        Map<String,Object> mpReportDetailColumn     = (Map<String,Object>)mpReportExtendedMetadata.get('detailColumnInfo');
        
        System.debug('***********==mpReportDetailColumnLst=>*******' + mpReportDetailColumnLst);
        for(Object detailCol : mpReportDetailColumnLst){
          Map<String,Object> mpDetail = (Map<String,Object>)mpReportDetailColumn.get((String)detailCol);
          System.debug('***********===>*******' + mpDetail);          
          System.debug('****==>LABEL****' + mpDetail.get('label'));       
          lstHeader.add(String.valueOf(mpDetail.get('label')));
        }     
        return lstHeader;
    }*/
    
    //==============================================================================//
    //Get Filters
    //=============================================================================//
    public List<ReportFilter> getReportFilters() {
        List<ReportFilter> lstFilters = new List<ReportFilter>();
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata'); 
        List<Object> reportFilters     = (List<Object>)mpReportMetadata.get('reportFilters'); 
          
        Map<String, Map<String, Schema.DescribeFieldResult>> objectFieldsMap
         = new Map<String, Map<String, Schema.DescribeFieldResult>>();
    	
        for(Integer index = 0; index < reportFilters.size(); index++){
            Map<String,Object> filterDetail = (Map<String,Object>)reportFilters[index];                    
            ReportFilter filter = new ReportFilter();            
            filter.value = refineFilterValue((String)filterDetail.get('value')); 
            filter.column = (String)filterDetail.get('column');  
            filter.operator = (String)filterDetail.get('operator');  
            filter.showFilter = false;              
            if(filter.column.contains('.')){
                /*Schema.DescribeFieldResult fieldDescribe = getFieldDetail(filter.column);
                if(fieldDescribe != null){
                    filter.label = fieldDescribe.getLabel();
                    filter.apiName = fieldDescribe.getName();
                }*/
                
                String[] splited = filter.column.split('\\.');
                
	        	if(splited.size() > 0){
	            	String objectName = splited[0];	            	
	            	String fieldName = splited[1];
	            	if(splited.size() > 2){
	            		Integer counter = 2;
	            		while(counter < splited.size()){
	            			fieldName += splited[counter++];
	            		}
	            	}
	            	if(objectFieldsMap.get(objectName) == null){
	            		objectFieldsMap.put(objectName, new Map<String, Schema.DescribeFieldResult>());
	            	}	
	            		objectFieldsMap.get(objectName).put(fieldName, null);	
	            	           	
	        	}                     
            }            
            lstFilters.add(filter);
        } 
        //system.assert(false, lstFilters);
        
        system.debug('=======objectFieldsMap==1======='+objectFieldsMap);
        populateFieldDetails(lstFilters, objectFieldsMap);   
        //system.assert(false, objectFieldsMap);
        system.debug('=======objectFieldsMap=2========'+objectFieldsMap);
        String objectName;
        String fieldName;
        Integer index = 0;
        for(ReportFilter filter : lstFilters){
        	objectName = filter.column.substring(0, filter.column.indexOf('.'));
        	fieldName = filter.column.substring(filter.column.lastIndexOf('.') + 1, filter.column.length());
        	 system.debug('=======objectName==1======='+objectName);
        	
        	 system.debug('=======fieldName==1======='+fieldName);
        	if(objectFieldsMap.containsKey(objectName)){
        		if(index == 1){
        		//system.assert(false, fieldName);
        		}
        		if(objectFieldsMap.get(objectName).containsKey(fieldName)){
        			
        			filter.label = objectFieldsMap.get(objectName).get(fieldName).getLabel();
                    filter.apiName = objectFieldsMap.get(objectName).get(fieldName).getName();
        		}
        		index++;
        	}	
        }
         system.debug('=======lstFilters========='+lstFilters);
         //system.assert(false, lstFilters);
        return lstFilters;
    }
    
    private void populateFieldDetails(List<ReportFilter> lstFilters, 
    		Map<String, Map<String, Schema.DescribeFieldResult>> objectFieldsMap){
    			Schema.DescribeFieldResult fieldDescribe;
    	system.debug('=======populateFieldDetails========='+lstFilters);
    	for(String objectName : objectFieldsMap.keyset()){
    		for(String fieldName : objectFieldsMap.get(objectName).keyset()){
    			if(fieldName.contains('.')){
    				String[] splited = fieldName.split('\\.');   				
    				Integer index = 1;
    				
    			 	fieldDescribe = schemaMap.get(objectName).getDescribe().fields.getMap().get(splited[0]).getDescribe();
    				if(fieldDescribe != null && fieldDescribe.getType() == Schema.Displaytype.REFERENCE){
		                String objName = fieldDescribe.getReferenceTo()[0].getDescribe().getName();
		                String fldName = splited[index++];
		                fieldDescribe = schemaMap.get(objName).getDescribe().fields.getMap().get(fldName).getDescribe();
	            	} 
	            	objectFieldsMap.get(objectName).put(fieldName, fieldDescribe);
    			}else{	        	
    				objectFieldsMap.get(objectName).put(fieldName, schemaMap.get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe());
    			}
    		}
    	}
    }
    
    //==============================================================================//
    //Refine filter value
    //=============================================================================//
    private String refineFilterValue(String filterValue){
        if(filterValue.startsWith('\"') && filterValue.endsWith('\"')){
            filterValue = filterValue.subString(1, filterValue.length() - 1);
            if(filterValue.indexOf(',') > -1){
                filterValue = filterValue.replace(',', '');
            }
        }
        return filterValue;
    }
    
   //=================================================================//
   //Method returns field describe detail
   //=================================================================//
    private DescribeFieldResult getFieldDetail(String colName){
        Schema.DescribeFieldResult fieldDescribe;
        String[] splited = colName.split('\\.');
        if(splited.size() > 0){
            String objectName = splited[0];
            String fieldName = splited[1];
            Integer index = 2;
            
            fieldDescribe = getFieldDescribe(objectName, fieldName);
            while(fieldDescribe != null && fieldDescribe.getType() == Schema.Displaytype.REFERENCE
                    && index < splited.size()){
                objectName = fieldDescribe.getReferenceTo()[0].getDescribe().getName();
                fieldName = splited[index++];
                fieldDescribe = getFieldDescribe(objectName, fieldName);
            }       
        }   
        return fieldDescribe;               
    }
  
   //=================================================================//
   //Method returns field describe result
   //=================================================================//
    private Schema.DescribeFieldResult getFieldDescribe(String objectName, String fieldName){
       
        Schema.SObjectType objectSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
        return fieldMap.get(fieldName).getDescribe();       
    }
    
    //==============================================================================//
    //Get Filters
    //=============================================================================//
    public String getReportFilterLogic() {
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        String reportBooleanFilter = (String)mpReportMetadata.get('reportBooleanFilter');      
        return reportBooleanFilter;
    }
    
    //=================================================================//
    // Method Returning List of Column Headers
    //=================================================================//
    public List<WrapperColumns> getReportHeader(List<Object> mpReportDetailColumnLst) {    
        List<WrapperColumns> listWrapperColumns = new List<WrapperColumns>();       
        
        Map<String,Object> mpReportExtendedMetadata = (Map<String,Object>)mpTopLevelParse.get('reportExtendedMetadata'); 
        Map<String,Object> mpReportDetailColumn = (Map<String,Object>)mpReportExtendedMetadata.get('detailColumnInfo');
        //system.assert(false, '----'+mpReportDetailColumn.values());
        for(Object colName : mpReportDetailColumnLst){
            Map<String,Object> mpDetail = (Map<String,Object>)mpReportDetailColumn.get((String)colName);
            WrapperColumns objWrapperColumns = new WrapperColumns();
            objWrapperColumns.columnLabel = String.valueOf(mpDetail.get('label'));
            objWrapperColumns.columnName = (String)colName; 
            objWrapperColumns.columnWidth = 30;
            if(String.valueOf(mpDetail.get('dataType')).equalsIgnoreCase('double')){
                objWrapperColumns.textAlign = 'right';
            }else{
                objWrapperColumns.textAlign = 'center';
            }
            Schema.DescribeFieldResult fieldDescribe = getFieldDetail((String)colName);
            if(fieldDescribe != null){
                objWrapperColumns.hoverText = fieldDescribe.getInlineHelpText();
            }  
                            
            listWrapperColumns.add(objWrapperColumns);
        } 
        return listWrapperColumns;    
    }
  
    //=================================================================//
    // Method returning report data
    //=================================================================//
    public List<String> getReportDataAndHeader() {
        
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
        Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
        Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        List<Object> dataRows = (List<Object>)mpDataMap.get('rows');
        
        //get header list
        List<WrapperColumns> listWrapperColumns = getReportHeader(mpReportDetailColumnLst);
        
        String value;
        String anchorStr;
        Integer i = 0;
        Integer size = 0;
        String columnsJson = '[';
        if(dataRows.size() > 0){
            for(Object row : dataRows) {
                Map<String, Object> mpRowObj = (Map<String, Object>)row;
                List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');                
                i = 0;
                columnsJson += '{';
                for(Object dataCellRow : lstDataCell) {
                    anchorStr = null;   
                    Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
                    
                    value = String.valueOf(dataCell.get('label')).replaceAll('\'', ' ').replaceAll('"', ' ');
                    columnsJson += '"'+(String)mpReportDetailColumnLst.get(i)+ '":"' ;
                    
                    // T-248912 :: Added for displaying anchor tag in jqgrid. 
                    if(dataCell.get('value') != null 
                    && String.valueOf(dataCell.get('value')).length() == 18
                    && Pattern.matches('^[a-zA-Z0-9]*$', String.valueOf(dataCell.get('value')))){
                        anchorStr = '<a href=\\\'/' + String.valueOf(dataCell.get('value')) + '\\\'>' + value + '</a>';
                    }
                                        
                    if(anchorStr != null){
                        columnsJson += anchorStr + '",';
                    }else{
                        columnsJson += value + '",';
                    }
                    
                    //T-249723 : Added for adjusting column width according to the largest data in column
                    size = value.length() * 8;
                    if(listWrapperColumns[i].columnWidth < size){
                        listWrapperColumns[i].columnWidth = size;
                    }   
                    i++;                
                }
                columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
                columnsJson += '},';
            }       
            columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
        }
        columnsJson += ']';
        
        List<String> resultLst = new List<String>();
        resultLst.add(JSON.serialize(listWrapperColumns));
        resultLst.add(columnsJson);
        
        return resultLst;
    }
  
    //=================================================================//
    // Returning Set Of values on a single column of report
    //=================================================================//
    public Set<String> getSetOfColumnValues(String columnName){
        Set<String> valueSet = new Set<String>();
        
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
        Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
        Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        List<Object> dataRows = (List<Object>)mpDataMap.get('rows');
        String value;
        Integer i;
        
        for(Object row : dataRows) {
            Map<String, Object> mpRowObj = (Map<String, Object>)row;
            List<Object> lstDataCell = (List<Object>)mpRowObj.get('dataCells');
            
            i = 0;
            for(Object dataCellRow : lstDataCell) {  
                Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
                if((String)mpReportDetailColumnLst.get(i++) == columnName){
                    value = String.valueOf(dataCell.get('value'));
                    if(value != null && value.trim() != '')
                        valueSet.add(value);
                } 
            }           
        }
        
        return valueSet;
    }
    
    //=================================================================//
    // Method returning report data
    //=================================================================//
    public String getReportDataForTreeView() {       
        Integer index;
        String sponserId;
        String contactId;
        Integer level;
        map<String, TreeView> Treeviews = new map<String, TreeView>();
        map<String, list<TreeView>> mapTreeview = new map<String, list<TreeView>>();
        
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns');
        Integer i = 0;
        String columnsJson = '[';        
        Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
        Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        List<Object> dataRows = (List<Object>)mpDataMap.get('rows');
        String rowJsonStr;
        if(dataRows.size() > 0){            
            for(Object row : dataRows) {
                i = 0;
                rowJsonStr = '';
                Map<String, Object> mpRowObj = (Map<String, Object>)row;                 
                List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
                for(Object dataCellRow : lstDataCell) {                           
                    Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
                    // sponsor name
                    if((String)mpReportDetailColumnLst.get(i) == 'ALM_Rep_Performance_1__c.Relative_Gen_Index__c'){
                        index = Integer.valueOf(dataCell.get('label'));
                        rowJsonStr += '"'+(String)mpReportDetailColumnLst.get(i)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';
                    }
                    // sponsor name
                    else if((String)mpReportDetailColumnLst.get(i) == 'ALM_Rep_Performance_1__c.UPLN_ACCT_KEY__c.Name'){
                        sponserId = String.valueOf(dataCell.get('value'));
                        rowJsonStr += '"'+(String)mpReportDetailColumnLst.get(i)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';
                    }
                    // own name
                    else if((String)mpReportDetailColumnLst.get(i) == 'ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.Name'){
                        contactId = String.valueOf(dataCell.get('value'));
                        rowJsonStr += '"'+(String)mpReportDetailColumnLst.get(i)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';
                    }
                    i++;
                    //columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';                  
                }
                rowJsonStr = rowJsonStr.subString(0, rowJsonStr.length() - 1);
                system.debug('--------------------- rowData ------------'+rowJsonStr);
                if(Index == 1){
                    TreeView objTreeView = new TreeView();                          
                    objTreeView.id = contactId;
                    objTreeView.level = 0;
                    objTreeView.parent = '';
                    objTreeView.isLeaf = 'true';
                    objTreeView.expanded = 'true';
                    objTreeView.loaded = 'true';
                    objTreeView.ColumnMetadata = rowJsonStr;
                    objTreeView.innerTreeView = new list<TreeView>();         
                    if(!mapTreeview.containskey(sponserId)){
                        mapTreeview.put(sponserId,new list<TreeView>());                         
                        list<TreeView> listTreeview = new list<TreeView>();                                      
                        listTreeview.add(objTreeView);                       
                        mapTreeview.put(sponserId,listTreeview);
                    }
                    else{
                        mapTreeview.get(sponserId).add(objTreeView);
                    }
                    if(!Treeviews.containskey(contactId)){
                        Treeviews.put(contactId,objTreeView);
                    }                        
                }
                else{       
                     TreeView childTreeView = new TreeView();                           
                     childTreeView.id = contactId;
                     childTreeView.level = 0;
                     childTreeView.parent = sponserId;
                     childTreeView.isLeaf = 'true';
                     childTreeView.expanded = 'true';
                     childTreeView.loaded = 'true';
                     childTreeView.ColumnMetadata = rowJsonStr;     
                     childTreeView.innerTreeView = new list<TreeView>();                     
                     system.debug('--------------------- sponserId ------------'+sponserId);
                     if(Treeviews.containskey(sponserId)) {
                        TreeView parentTree = Treeviews.get(sponserId);
                        childTreeView.level = parentTree.level+1;
                        parentTree.isLeaf = 'false';
                        parentTree.innerTreeView.add(childTreeView);
                        if(!Treeviews.containskey(contactId)){
                            Treeviews.put(contactId, childTreeView);
                        }
                     }              
                }
            }
            system.debug('--------------------- Treeviews------------'+Treeviews);
            system.debug('--------------------- mapTreeview------------'+mapTreeview);
            
            //for(TreeView treeNode : mapTreeview.keyset()){
                //system.debug('------------name---------------'+ name);
                //columnsJson += '{';
                for(String str : mapTreeview.keyset()){
                    list<TreeView> parentTreeviews = mapTreeview.get(str);  
                    for(TreeView treeNode : parentTreeviews){
                         columnsJson += traverseTreeView(treeNode, '');
                    }
                }                
                //system.debug('------------treeView.innerTreeView.size()---------------'+ treeView.innerTreeView.size());
                //system.debug('------------treeView.innerTreeView---------------'+ treeView.innerTreeView);                 
            //}
                        
            /*for(Object row : dataRows) {              
                columnsJson += '{';
                Map<String, Object> mpRowObj = (Map<String, Object>)row;                 
                List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');                 
                i = 0;
                                
                for(Object dataCellRow : lstDataCell) {   
                          
                    Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;                  
                    // level 
                    if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.Relative_Gen_Index__c'){
                        id=String.valueOf(dataCell.get('label'));
                    }
                    // sponsor name
                    else if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.UPLN_ACCT_KEY__c.Name'){
                        sponserId=String.valueOf(dataCell.get('label'));
                    }
                    // own name
                    else if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.Name'){
                        contactId=String.valueOf(dataCell.get('label'));
                    }
                    columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';                    
                }   
                if(setParents.contains(contactId)){
                    columnsJson += '"'+'isLeaf'+ '":"' + 'false' + '",';
                }
                else{
                    if(contactId != sponserId){
                        columnsJson += '"'+'isLeaf'+ '":"' + 'true' + '",';
                    }
                    else{
                        columnsJson += '"'+'isLeaf'+ '":"' + 'false' + '",';
                    }
                }
                if(Integer.valueOf(id) >0){
                    level=Integer.valueOf(id)-1;
                }
                else {
                    level=0;
                }
                columnsJson += '"'+'parent'+ '":"' + sponserId + '",';                      
                columnsJson += '"'+'level'+ '":"' + level + '",';                    
                columnsJson += '"'+'id'+ '":"' + contactId + '",';
                columnsJson += '"'+'loaded'+ '":"' + 'true' + '",';
                columnsJson += '"'+'expanded'+ '":"' + 'true' + '",';
                
                columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
                columnsJson += '},';
            }*/       
            columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
        }
        columnsJson += ']';     
        system.debug('-------------------- columnsJson--------------'+columnsJson);
        return columnsJson;
    }
    
    //=================================================================//
    // Method traversing the data and creating json rows for tree view
    //=================================================================//
    public String traverseTreeView(TreeView objTreeView, String json){
        if(objTreeView.ColumnMetadata != null){
            json += '{';
            json += objTreeView.ColumnMetadata;
            json += ',"id":"'+objTreeView.id+'"';
            json += ',"level":"'+objTreeView.level+'"';
            json += ',"parent":"'+objTreeView.parent+'"';
            json += ',"isLeaf":"'+objTreeView.isLeaf+'"';
            json += ',"expanded":"'+objTreeView.expanded+'"';
            json += ',"loaded":"'+objTreeView.loaded+'"';
            json += '},';               
            if(objTreeView.innerTreeView != null && objTreeView.innerTreeView.size()>0){
                for(TreeView innerChild : objTreeView.innerTreeView){
                    json += traverseTreeView(innerChild, '');
                }                   
            }
        } 
        return json;
    }
    
    //=================================================================//
    //Wrapper Class for table columns
    //=================================================================//
    public class WrapperColumns{
        public String columnLabel{get;set;} 
        public String columnName{get;set;}  
        public String hoverText{get;set;} 
        public Integer columnWidth{get; set;} 
        public String textAlign{get;set;}
    }  
    
    /*public List<WrapperRows> getJsonWrapperFormat(String jsonResult) {
        Map<String,Object> mpTopLevelParse = (Map<String,Object>)JSON.deserializeUntyped(jsonResult);
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
        List<WrapperRows> wrapperRows = new List<WrapperRows>();
        Integer i = 0;
        String columnsJson = '[';
       
        Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
        Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
            
        for(Object dataRecord : (List<Object>)mpDataMap.get('rows')) {
          WrapperRows row = new WrapperRows();
          List<WrapperCol> colList = new List<WrapperCol>();
          columnsJson += '{';
          Map<String, Object> mpRowObj = (Map<String, Object>)dataRecord;
          List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
             
          i = 0;
          for(Object dataCellRow : lstDataCell) {           
            Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
            WrapperCol col = new WrapperCol();
            col.columnStr = (String)mpReportDetailColumnLst.get(i++)+ ':' +String.valueOf(dataCell.get('label'));
            //col.dataStr = String.valueOf(dataCell.get('label'));
            //columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';
            colList.add(col);
          }
          //columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
          row.colList = colList;
          columnsJson += '},';
          wrapperRows.add(row);  
        } 
        
        columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
        columnsJson += ']';
        system.debug('====columnsJson============='+columnsJson);
        system.debug('====wrapperRows============='+wrapperRows);
        return wrapperRows;
    }
    public String getPagedJSON(List<WrapperRows> dataRows){
        String jsonString = JSON.serialize(dataRows);
        return jsonString;
    }
    
    
      //=================================================================//
      //Wrapper Class for table columns
      //=================================================================//
      global class WrapperRows{ 
        public List<WrapperCol> colList{get;set;}    
      }
      
      //=================================================================//
      //Wrapper Class for table columns
      //=================================================================//
      global class WrapperCol{ 
        public String columnStr {get;set;}
        //public String dataStr {get;set;}    
      }  */   
  public class TreeView{
    public String id {get;set;}
    public String ColumnMetadata {get;set;}
    public Integer level {get;set;}
    public String parent {get;set;}
    public String isLeaf {get;set;}
    public String expanded {get;set;}
    public String loaded {get;set;}
    public list<TreeView> innerTreeView{get;set;}
    // Constructor
    public TreeView(){}
  }
  
}