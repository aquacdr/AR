/***************************************************************************
 Name          : ReportParser 
 Description   : Report JSON string parser
 Created By    : Parul Gupta 
 Created Date  : 16 Dec, 2013                
****************************************************************************/
public class ReportParser {
  
  	//Store the parsing Information in the top Level object
  	private Map<String,Object> mpTopLevelParse = new Map<String,Object>();
  
  	//===================================================================//
  	//Constructor
  	//===================================================================//
  	public ReportParser(String inputJSONStr) {
  		system.debug('*****inputJSONStr*****'+inputJSONStr);
    	this.mpTopLevelParse = (Map<String,Object>)JSON.deserializeUntyped(inputJSONStr);
  	}
   
	//========================================================================//
	//Retrieve Data Table using the Report JSON String
	//========================================================================//
  	public Component.Apex.DataTable getVFDataTable() {
  		Component.Apex.DataTable tbl = new Component.Apex.DataTable(var='item');
		List<String> lstHeader = getHeader();
    	List<List<String>> data = getDataHtml();
        tbl.value = data;
		for(Integer index = 0; index < lstHeader.size(); index++){
	   		Component.Apex.OutputText header = 
	    			new Component.Apex.OutputText(value=lstHeader[index]);
	    	header.style = 'padding-right:5px';
	    	Component.Apex.Column col = new Component.Apex.Column();
			col.expressions.value = '{!item[' + index + ']}';
			col.facets.header = header;
			col.style = 'padding-right:5px';
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
  	}
  
}