/***************************************************************************
 Name          : Controller_SLMyTeamOrdersReport
 Created By    : Barkha Jain
 Description   : Controller for SLMyTeamOrdersReport 
 Created Date  : Jan 9, 2014                
****************************************************************************/
public with sharing class Controller_SLMyTeamOrdersReport {
    //Properties, variables
    public Id selectedReport {get; set;}
    public String reportId {get;set;}   
    public Boolean isEmailEnabled {get; set;}
    public Boolean isPrintEnabled {get; set;}
    public Boolean isExportEnabled {get; set;}
    public SalesLeader_DTO salesLeaderDTO {get;set;}
    public List<SelectOption> reportList {get;set;}
    public Integer columnsToFreeze {get;set;}   
    
    private Map<Id, ZM_Report_Translation__c> mapReportTranslations;
    
    //constructor
    public Controller_SLMyTeamOrdersReport(){
        init();     
    }
    
    //Init method
    private void init() {
        isEmailEnabled = true;
        isPrintEnabled = true;
        isExportEnabled = true;
        salesLeaderDTO = new SalesLeader_DTO();
        
        // Initialize the list of reports
        reportList = new List<Selectoption>();
        mapReportTranslations = salesLeaderDTO.getReportTranslationsMap('My Team Orders');       
        for(ZM_Report_Translation__c z: mapReportTranslations.values()){
            reportList.add(new SelectOption(z.Report_Id__c, z.Report_Label__c));
        }
        
        if(reportList.size() > 0){
            selectedReport = reportList[0].getValue();
            populateFilterColumns();
        }        
    }
    
    //==============================================================================================//
    // Method to uddate the Gen Level of the logged in user in custom settings
    // calling this method in page Action to handle the Deep link parameter 'mode=run' case also
    // so that the Current User's cutom setting record gets updated before all report callouts
    //==============================================================================================//
    public void updateUserGenIndex(){
    	salesLeaderDTO.updateUserGenIndex();
    }
    
    //=================================================================//
    //Get report data through analytics api call
    //=================================================================//
    public PageReference getReportData() {
        if(selectedReport != null){  
            reportId = selectedReport;
            Decimal freezingCount = mapReportTranslations.get(reportId).NumberOfColumnstoFreeze__c;
            if(freezingCount != null) 
                columnsToFreeze = Integer.valueOf(freezingCount);       
        }
        return null;
    }   
    
    //=================================================================//
    // Method populates filter columns
    //=================================================================//
    public PageReference populateFilterColumns(){
        salesLeaderDTO.populateReportFilters((String)selectedReport);
        reportId = null;
        return null;
    }
    
    //=================================================================//
    //Get report arguments for download
    //=================================================================//
    public String getReportArguments(){
        return salesLeaderDTO.getReportArgumentsForDownload();
    }
    
    //==============================================================================================//
    //Dummy placeholder method
    //==============================================================================================//
    public void doNothing(){}

}