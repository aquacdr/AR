/***************************************************************************
 Name          : ZM_ReportCenter_v2Controller 
 Created By    : Parul Gupta 
 Description   : POC for Analytics Api 
 Created Date  : 16 Dec, 2013                
****************************************************************************/
public with sharing class ZM_ReportCenter_v2Controller {
  public String selectedReportID {get;set;}  
  private AnalyticReportParser reportParser;  
  
  //==========================================================//
  //Constructor
  //==========================================================//
  public ZM_ReportCenter_v2Controller() {}
  
  //================================================================//
  //Retrieve All Reports and put them as select Option
  //================================================================//
  public List<SelectOption> getAllReports() {
    List<SelectOption> lstOption = new List<SelectOption>();
    for(Report report :  [SELECT Id,Name FROM Report Order By Name Limit 100]) {
      lstOption.add(new SelectOption(report.Id,report.Name));
    }
    return lstOption;  
  }
    
  //=================================================================//
  //Method to show Report Data
  //=================================================================//
  public Pagereference showReportData(){
   	return null;
  }
    
}