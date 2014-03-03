/***************************************************************************
 Name          : ALM_Controller_Report
 Description   : Demo version
 Created By    : Parul Gupta 
 Created Date  : Feb 12, 2013                
****************************************************************************/
public with sharing class ALM_Controller_Report{ 
    //Properties, variables
    public String selectedReport {get; set;}    
    public String reportId {get;set;}
    public Boolean isEmailEnabled {get; set;}
    public Boolean isPrintEnabled {get; set;}
    public Boolean isExportEnabled {get; set;}
    public SalesLeader_DTO salesLeaderDTO {get;set;}
    public List<SelectOption> reportList {get;set;}
    public Integer columnsToFreeze {get;set;}
    public String emailField {get;set;}
    public String contactIdField {get; set;}
    
    public String emailSubject {get;set;}
    public String emailBody {get;set;}
    public String toAddresses {get;set;}
    public String emailToFlag {get;set;}
    public String contactIds {get;set;}
    
    private List<SelectOption> titleList = new List<SelectOption>();
    private Map<Id, ZM_Report_Translation__c> mapReportTranslations;    
    private Set<String> contactIdSet;
    
    //==============================================================================================//
    //Constructor
    //==============================================================================================//
    public ALM_Controller_Report() {  
    	system.debug('In controller');
        init();         
    }

    //==============================================================================================//
    //Init Method
    //==============================================================================================//    
    private void init() {
        emailField = 'ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.REP_EMAIL_ADDR_TXT__c';
        contactIdField = 'ALM_Rep_Performance_1__c.MRKT_ACCT_KEY__c.FirstName';
        
        salesLeaderDTO = new SalesLeader_DTO();          
        //isEmailEnabled = salesLeaderDTO.checkIsEmailAllowedForProfile();
        isEmailEnabled = true;
        isPrintEnabled = true;
        isExportEnabled = true;
        
        // Initialize the list of reports
        reportList = new List<Selectoption>();
        mapReportTranslations = salesLeaderDTO.getReportTranslationsMap(); 
            
        for(ZM_Report_Translation__c z: mapReportTranslations.values()){
            reportList.add(new SelectOption(z.Report_Id__c, z.Report_Label__c));
        }
        
        if(reportList.size() > 0){
        	if(salesLeaderDTO.selectedReportId != null){
        		selectedReport = salesLeaderDTO.selectedReportId; 
        	}else{
        		selectedReport = reportList[0].getValue();
        	}         	      	
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
            if(freezingCount != null){ 
                columnsToFreeze = Integer.valueOf(freezingCount); 
            }
            salesLeaderDTO.setSelectedCampaignFilter();              
        }
        return null;
    }

    //=================================================================//
    // Method populates filter columns
    //=================================================================//
    public PageReference populateFilterColumns(){
    	salesLeaderDTO.populateReportFilters(selectedReport);
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
    public PageReference sendEmail(){
        Set<String> addressSet;
        
        // Retrieving email addresses and Contact ids set
        if(emailToFlag == 'All'){
        	List<String> fieldNames = new List<String>{emailField, contactIdField};        
            Map<String, Set<String>> mapColumnValueSets = salesLeaderDTO.getMapOfColumnsValueSet(selectedReport, fieldNames);
            
            addressSet = mapColumnValueSets.get(emailField);
            contactIdSet = mapColumnValueSets.get(contactIdField);
        }else{
            addressSet = new Set<String>(toAddresses.split(','));
            contactIdSet = new Set<String>(contactIds.split(','));
        }
             
        List<String> mailAddresses = new List<String>(addressSet);
        
        //send email
        Boolean result = ALM_Utility_Email.sendEmail(null, false, mailAddresses, null, null, null, emailSubject, 
                               emailBody, false, false, null, null, null, false);
        
        //Creating activity info. records for sent mails
        createEmailActivityHistories();
        
        if(result){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Email has been sent successfully!'));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Sending failed'));
        }
        
        return null;
    }
    
    //==============================================================================================//
    // Method to create activityHistory records to store email info on contact record
    //==============================================================================================//
    public void createEmailActivityHistories(){
    	List<Contact> contactLst = [select Id, REP_EMAIL_ADDR_TXT__c from Contact
    								where Id IN : contactIdSet
    								and REP_EMAIL_ADDR_TXT__c != null];
    	
    	String description = '\nSubject: '+emailSubject+'\nBody: \n'+emailBody;
    							
    	List<Task> activitiesToBeInserted = new List<Task>();
    	for(Contact con : contactLst){
    		Task task = new Task();
    		task.ActivityDate = Date.today();
    		task.Status = 'Completed';
    		task.WhoId = con.Id;
    		task.Subject = 'Email: '+emailSubject;
    		task.Description = 'Additional To: '+ con.REP_EMAIL_ADDR_TXT__c + '\n' + description;
    		activitiesToBeInserted.add(task);
    	}
    	
    	if(activitiesToBeInserted.size() > 0){
    		insert activitiesToBeInserted;
    	}
    }
    
    //==============================================================================================//
    //Dummy placeholder method
    //==============================================================================================//
    public void doNothing(){ }      
    
}