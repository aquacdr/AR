/***************************************************************************
 Name          : Controller_SLJQGridComponent 
 Description   : Controller class for SLJQGridComponent
 Created By    : Barkha Jain
 Created Date  : 31 Dec, 2013                
****************************************************************************/
global with sharing class ALM_Controller_JQGridComm {   
    //Properties, Variables
    public string reportId {get;set;}
    public  List<ReportFilter> filters {get;set;}
    public String filterLogic {get;set;}
    public String colHeaders {get; set;} 
    
    private String sfdcServerName;
    private ALM_ServiceInt_Report reportCallout {get;set;}
    
    public Integer columnsToFreeze {
    get{
        if(columnsToFreeze == null)
            return 0;
        return columnsToFreeze;
    }set;}  
    
    public String jsonWrapperData {get;set;}
    
    //=================================================================//
    // Returns report data (JSON FORMAT)
    //=================================================================//
    public String jsonData {get{
        if(reportId != null){
            loadReportData();
        }else{
            jsonData = '';
            colHeaders = '';
        }
        return jsonData;
    }
    set;}
    
    //=================================================================//
    // Returns report name
    //=================================================================//
    public string reportName {get{
        
        return 'TopCoder Contestants Rocks';
    } set;} 
    
    //=================================================================//
    // Constructor
    //=================================================================//
    public ALM_Controller_JQGridComm() {
        sfdcServerName = Apexpages.currentpage().getheaders().get('X-Salesforce-Forwarded-To'); 
        if(String.isBlank(sfdcServerName)) {
            sfdcServerName = 'prerelna1.pre.salesforce.com';
        } 
        reportCallout = ALM_ServiceInt_ReportAnalyticsAPI.getInstance();                    
    }
    
    //=================================================================//
    //Get report data through analytics api call
    //=================================================================//
    public void loadReportData() {  
    	String reportJSONResult = reportCallout.getAnalyticsReportResponse(sfdcServerName, this.reportId, filterLogic, filters);        
        if(reportJSONResult != null){
            ALM_Utility_AnalyticsReportParser reportParser = new ALM_Utility_AnalyticsReportParser(reportJSONResult);
            List<String> resultData = reportParser.getReportDataAndHeader();
            colHeaders = resultData.get(0);
            jsonData = resultData.get(1); 
        }       
    }  
    
}