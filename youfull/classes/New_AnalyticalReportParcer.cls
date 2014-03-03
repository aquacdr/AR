global class New_AnalyticalReportParcer {
//Store the parsing Information in the top Level object
    private Map<String,Object> mpTopLevelParse = new Map<String,Object>();
  
    //===================================================================//
    //Constructor
    //===================================================================//
    public New_AnalyticalReportParcer(String inputJSONStr) {
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
	        		system.debug('-------------------- dataCell--------------'+dataCell);
	        		columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';
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
  	
  	
  	//=================================================================//
  	// Method returning report data
  	//=================================================================//
  	public String getReportDataForTreeView() {
	    String sName;
		String sSponsor;
		Integer Index;
	    Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
	    List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
      	set<String> setParents=new set<String>();
      	set<String> setNames=new set<String>();
    	Integer i = 0;
    	String columnsJson = '[';
        map<String,map<Integer,String>> mapSponsor=new map<String,map<Integer,String>>();
    	Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
    	Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        List<Object> dataRows = (List<Object>)mpDataMap.get('rows');
        if(dataRows.size() > 0){        	
        	for(Object row : dataRows) {
					Map<String, Object> mpRowObj = (Map<String, Object>)row;	      		 
					List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
					for(Object dataCellRow : lstDataCell) { 
		      			Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;	        		
		        		if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.Name'){
		        			 sName=String.valueOf(dataCell.get('label'));
		        		}
						else if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.UPLN_ACCT_KEY__c.Name'){
		        			 sSponsor=String.valueOf(dataCell.get('label'));
		        		}
						else if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.Relative_Gen_Index__c'){
		        			 Index=Integer.valueOf(dataCell.get('label'));
		        		}	        		
		      		}
					if(!mapSponsor.containskey(sSponsor)){		
						map<Integer,String> mapNameIndex=new map<Integer,String>();
						mapSponsor.put(sSponsor,mapNameIndex);							
			        }
					else if(mapSponsor.containskey(sSponsor)){	
						map<Integer,String> mapNameIndex=mapSponsor.get(sSponsor);
						mapNameIndex.put(Index,sName);
					}
			}        	
        	
	    	for(Object row : dataRows) {	    		
	      		columnsJson += '{';
	      		Map<String, Object> mpRowObj = (Map<String, Object>)row;
	      		 
	      		List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
	             
	      		i = 0;
	      		String id;
	      		String sponsor;
	      		String name;	      		
	      		for(Object dataCellRow : lstDataCell) {   
	      			      
	        		Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;	        		
	        		// level 
	        		if((String)mpReportDetailColumnLst.get(i)=='	'){
	        			id=String.valueOf(dataCell.get('label'));
	        		}
	        		// sponsor name
	        		else if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.UPLN_ACCT_KEY__c.Name'){
	        			sponsor=String.valueOf(dataCell.get('label'));
	        		}
	        		// own name
	        		else if((String)mpReportDetailColumnLst.get(i)=='ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.Name'){
	        			name=String.valueOf(dataCell.get('label'));
	        		}
	        		columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';	        		
	      		}
	      		// its a parent node
	      		if(id=='1'){	      			
	      			columnsJson += '"'+'parent'+ '":"' + '' + '",';
	      			columnsJson += '"'+'isLeaf'+ '":"' + 'false' + '",';
	      			columnsJson += '"'+'level'+ '":"' + '0' + '",';	      			 
	      			columnsJson += '"'+'id'+ '":"' + name + '",';
	      			columnsJson += '"'+'loaded'+ '":"' + 'true' + '",';
	      			columnsJson += '"'+'expanded'+ '":"' + 'true' + '",';	      			 
	      		}
	      		else if(id != '1'){
	      			Integer iVal=Integer.valueOf(id)-1;	 
	      			if(setParents.contains(name)){
	      				columnsJson += '"'+'isLeaf'+ '":"' + 'false' + '",';
	      			}
	      			else{
	      				columnsJson += '"'+'isLeaf'+ '":"' + 'true' + '",';
	      			}    			 
	      			columnsJson += '"'+'parent'+ '":"' + sponsor + '",';	      			 
	      			columnsJson += '"'+'level'+ '":"' + iVal + '",';	      			 
	      			columnsJson += '"'+'id'+ '":"' + name + '",';
	      			columnsJson += '"'+'loaded'+ '":"' + 'true' + '",';
	      			columnsJson += '"'+'expanded'+ '":"' + 'true' + '",';
	      		}	      		
	      		columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
	      		columnsJson += '},';
	    	}       
	    	columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
        }
    	columnsJson += ']';
    	
    	system.debug('-------------------- setParents--------------'+setParents);
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
}