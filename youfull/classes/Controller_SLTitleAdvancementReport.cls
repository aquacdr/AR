/***************************************************************************
 Name          : Controller_SLTitleAdvancementReport 
 Created By    : Parul Gupta
 Description   : Controller_SLTitleAdvancementReport  
 Created Date  : Dec 31, 2013                
****************************************************************************/
public with sharing class Controller_SLTitleAdvancementReport { 
    //Properties, variables
    public Id selectedReport {get; set;}    
    public String reportId {get;set;}
    public Boolean isEmailEnabled {get; set;}
    public Boolean isPrintEnabled {get; set;}
    public Boolean isExportEnabled {get; set;}
    public SalesLeader_DTO salesLeaderDTO {get;set;}
    public List<SelectOption> reportList {get;set;}
    public Integer columnsToFreeze {get;set;}
    public String emailField {get;set;}
    
    public String emailSubject {get;set;}
    public String emailBody {get;set;}
    public String toAddresses {get;set;}
    public String emailToFlag {get;set;}
    
    private List<SelectOption> titleList = new List<SelectOption>();
    private Map<Id, ZM_Report_Translation__c> mapReportTranslations;    
    
    //==============================================================================================//
    //Constructor
    //==============================================================================================//
    public Controller_SLTitleAdvancementReport () {  
        init();         
    }

    //==============================================================================================//
    //Init Method
    //==============================================================================================//    
    private void init() {
        isEmailEnabled = true;
        isPrintEnabled = true;
        isExportEnabled = true;
        emailField = 'ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.REP_EMAIL_ADDR_TXT__c';
        salesLeaderDTO = new SalesLeader_DTO();          
        
        // Initialize the list of reports
        reportList = new List<Selectoption>();
        mapReportTranslations = salesLeaderDTO.getReportTranslationsMap('Title Advancement');       
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
    
    //=================================================================//
    // Send mail to all/selected records of report
    //=================================================================//
    //=================================================================//
    // Send mail to all/selected records of report
    //=================================================================//
    public PageReference sendEmail(){
        Set<String> addressSet;
        
        // Retrieving email addresses set
        if(emailToFlag == 'All'){
        	List<String> fieldNames = new List<String>{emailField};        
            Map<String, Set<String>> mapColumnValueSets = salesLeaderDTO.getMapOfColumnsValueSet(selectedReport, fieldNames);
            
            addressSet = mapColumnValueSets.get(emailField);
        }else{
            addressSet = new Set<String>(toAddresses.split(','));
        }
             
        List<String> mailAddresses = new List<String>(addressSet);
        //send email
        Boolean result = ALM_Utility_Email.sendEmail(null, false, mailAddresses, null, null, null, emailSubject, 
                                emailBody, false, false, null, null, null, false);
        
        if(result){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Email has been sent successfully!'));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Sending failed'));
        }
        
        return null;
    }
    
    //==============================================================================================//
    //Dummy placeholder method
    //==============================================================================================//
    public void doNothing(){ }      
    
}