/***************************************************************************
 Name          : AnalyticReportParser 
 Description   : Report JSON string parser
 Created By    : Parul Gupta 
 Created Date  : 16 Dec, 2013                
****************************************************************************/
global class AnalyticReportParser {
  
    //Store the parsing Information in the top Level object
    private Map<String,Object> mpTopLevelParse = new Map<String,Object>();
  
    //===================================================================//
    //Constructor
    //===================================================================//
    public AnalyticReportParser(String inputJSONStr) {
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
        for(Integer index = 0; index < reportFilters.size(); index++){
        	Map<String,Object> filterDetail = (Map<String,Object>)reportFilters[index];                    
          	ReportFilter filter = new ReportFilter();            
          	filter.value = refineFilterValue((String)filterDetail.get('value')); 
          	filter.column = (String)filterDetail.get('column');  
          	filter.operator = (String)filterDetail.get('operator');  
          	filter.showFilter = false;          	
          	if(filter.column.contains('.')){
  		  		Schema.DescribeFieldResult fieldDescribe = getFieldDetail(filter.column);
	  			if(fieldDescribe != null){
	  				filter.label = fieldDescribe.getLabel();
	  				filter.apiName = fieldDescribe.getName();
	  			} 					
  		  	} 	         
          	lstFilters.add(filter);
        }     
        return lstFilters;
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
  			system.debug('=========objectName============='+splited[0]);
  			system.debug('=========fieldName============='+splited[1]);
  		    fieldDescribe = getFieldDescribe(splited[0], splited[1]);
  		    if(fieldDescribe != null && fieldDescribe.getType() == Schema.Displaytype.REFERENCE){	  						
				fieldDescribe = getFieldDescribe(fieldDescribe.getLabel(), splited[splited.size() - 1]);
	  		}		
  		}	
  		return fieldDescribe;
				
  	}
  
   //=================================================================//
   //Method returns field describe result
   //=================================================================//
  	private Schema.DescribeFieldResult getFieldDescribe(String objectName, String fieldName){
  		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
	  	Schema.SObjectType objectSchema = schemaMap.get(objectName);
		Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
		return fieldMap.get(fieldName).getDescribe();
  	}
    
    //==============================================================================//
    //Get Filters
    //=============================================================================//
    public String getReportFilterLogic() {
        Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
        String reportBooleanFilter     = (String)mpReportMetadata.get('reportBooleanFilter');      
        return reportBooleanFilter;
    }
    
    //=================================================================//
  	// Method Returning List of Column Headers
  	//=================================================================//
  	public String getReportHeader() {    
    	List<WrapperColumns> listWrapperColumns = new List<WrapperColumns>();       
     	
      	// Creating json header
      	Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
      	List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
      	Map<String,Object> mpReportExtendedMetadata = (Map<String,Object>)mpTopLevelParse.get('reportExtendedMetadata'); 
      	Map<String,Object> mpReportDetailColumn = (Map<String,Object>)mpReportExtendedMetadata.get('detailColumnInfo');
               
      	for(Object detailCol : mpReportDetailColumnLst){
      		Map<String,Object> mpDetail = (Map<String,Object>)mpReportDetailColumn.get((String)detailCol);
        	WrapperColumns objWrapperColumns = new WrapperColumns();
         	objWrapperColumns.ColumnLabel = String.valueOf(mpDetail.get('label'));
         	objWrapperColumns.ColumnName = (String)detailCol;       
         	listWrapperColumns.add(objWrapperColumns);
      	} 
      	system.debug('------------- JSON.serialize(listWrapperColumns-----------------'+JSON.serialize(listWrapperColumns));
		return JSON.serialize(listWrapperColumns);     
  	}
  
    //=================================================================//
  	// Method returning report data
  	//=================================================================//
  	public String getReportData() {
	    Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
	    List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
      
    	Integer i = 0;
    	String columnsJson = '[';
       
    	Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
    	Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        List<Object> dataRows = (List<Object>)mpDataMap.get('rows');
        system.debug('-------------------- mpFactMap--------------'+mpFactMap);
        system.debug('-------------------- mpDataMap--------------'+mpDataMap);
        String value;
        if(dataRows.size() > 0){
	    	for(Object row : dataRows) {
	    		system.debug('-------------------- dataRows--------------'+dataRows);
	      		columnsJson += '{';
	      		Map<String, Object> mpRowObj = (Map<String, Object>)row;
	      		system.debug('-------------------- mpRowObj--------------'+mpRowObj);
	      		List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
	            system.debug('-------------------- lstDataCell--------------'+lstDataCell);
	      		i = 0;
	      		for(Object dataCellRow : lstDataCell) {   
	      			system.debug('-------------------- dataCellRow--------------'+dataCellRow);        
	        		Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
	        		value = String.valueOf(dataCell.get('label')).replaceAll('\'', ' ').replaceAll('"', ' ');
	        		columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +value+ '",';
	      		}
	      		columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
	      		columnsJson += '},';
	    	}       
	    	columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
        }
    	columnsJson += ']';
    	system.debug('-------------------- columnsJson--------------'+columnsJson);
    	return columnsJson;
  	}
  	
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
    //	system.debug('-------------------- setParents--------------'+setParents);
    	system.debug('-------------------- columnsJson--------------'+columnsJson);
    	return columnsJson;
  	}
  	
  	//=================================================================//
  	//Wrapper Class for table columns
  	//=================================================================//
  	public class WrapperColumns{
    	public String ColumnLabel{get;set;} 
    	public String ColumnName{get;set;}    
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
    public TreeView(){
    	
    }
  }
}