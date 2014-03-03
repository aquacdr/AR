/***************************************************************************
 Name          : ReportFilter 
 Created By    : Parul Gupta
 Description   : Report Filter Wrapper 
 Created Date  : Jan 7, 2014                
****************************************************************************/
global with sharing class ReportFilter {    
    public String column {get;set;}
    public String operator {get;set;}
    public String label {get;set;}
    public boolean showFilter {get;set;}  
    public String apiName {get;set;} 
    public String value {get{
    	if(value != null && value.contains('[')){
    		value = value.replace('[','').replace(']','');
    	}
    	return value;
    }
    set;}	  
}