public with sharing class ZM_Controller_ReportCenterOOB {

    public Boolean redirectOnly {get; set;}
    public Boolean multipleZones {get; set;}
    public Boolean isALMPlusEnabled {get; set;}
    public String type {get; set;}
    public String templateReportURL {get; set;}
    public String sfdcURL {get; set;}
    public Id selectedStandardReport {get; set;}
    private Id selectedLeadReport {get; set;}
    public String selectedPersonalReport {get; set;}
    public String selectedOfflineReport {get; set;}
    public String userProfile {get;set;}
    public String selectedZone {get; set;}
    public String selectedStdZone {get; set;}
    public String selectedStandardCampaign {get; set;}
    public String selectedPersonalCampaign {get; set;}
    public String selectedOfflineCampaign {get; set;}
    public String thrShldAge {get; set;}
    public String test {get; set;}
    public boolean DispCampaign {get; set;}
    private List<SelectOption> standardReportList = new List<SelectOption>();
    private List<SelectOption> LeadReportList = new List<SelectOption>();
    private List<SelectOption> personalReportList = new List<SelectOption>();
    private List<SelectOption> offlineReportList = new List<SelectOption>();
    private Map<Id,CDW_Market_Report__c> offlineReportMap = new Map<Id,CDW_Market_Report__c>();
    public Map<String, String> mapForReportFilter{get;set;}
    private List<SelectOption> zoneList = new List<SelectOption>();
    private Market__c market;
    private User currentUser;
    private String mp;
    
    /*public String selectedClosed {get; set;}
    public String selectedCampaign {get; set;}
    public String selectedEligible {get; set;}
    public String selectedLdType {get; set;}
    private List<SelectOption> closedList = new List<SelectOption>();
    private List<SelectOption> campaignList1 = new List<SelectOption>();
    private List<SelectOption> eligibleList = new List<SelectOption>();
    private List<SelectOption> ldTypeList = new List<SelectOption>();*/
    
    public String omniSuitName {get; set;} //variable added by Raktim for Omniture - on 23rd Sept, 2013

    public ZM_Controller_ReportCenterOOB() {
        this.type = 'Report'; // For now, only dealing with reports
        String reportName = ApexPages.CurrentPage().getParameters().get('report');
        initializeData(reportName); 
        
        this.selectedPersonalCampaign = market.CMPGN_NR__c;
        this.selectedOfflineCampaign = market.CMPGN_NR__c;
        this.selectedStandardCampaign = ApexPages.CurrentPage().getParameters().get('campaign');
        
       // If campaign is not specified, default to current
        if (this.selectedStandardCampaign == null) {
            if(!market.Mail_Plan_Enabled__c){
            //this.selectedStandardCampaign = market.CMPGN_NR__c;            
            }else{
            //Added by Milon on 7/9/2013
            String  mailPlanCampaignNumbr = '';
            if (currentUser.Profile.Name.contains('Division')){
                //Changed by Milon on 10/17
                //MailPlanUtils mp = new MailPlanUtils(market);//changed by swarnava:added argument
                //MailPlan_Order_Oppty__c mop =   mp.getMailPlanForDivManager(currentUser);
                //mailPlanCampaignNumbr = mop.CMPGN_NR__c;
                mailPlanCampaignNumbr = market.CMPGN_NR__c;
            }else {
                String zones = getZones(market.Id);
                mailPlanCampaignNumbr =  MailPlanUtils.getMailPlanCampaignZMDM(zones, currentUser.MRKT_ID__c);
                system.debug('========mailPlanCampaignNumbr ====='+mailPlanCampaignNumbr );
            }
            
           if(mailPlanCampaignNumbr == market.CMPGN_NR__c)
           this.selectedStandardCampaign = market.CMPGN_NR__c;
           else if(mailPlanCampaignNumbr == market.NEXT_1_CMPGN_NR__c)
           this.selectedStandardCampaign = market.NEXT_1_CMPGN_NR__c;
           else
           this.selectedStandardCampaign = market.CMPGN_NR__c;
           }
        }
        
        this.redirectOnly = (selectedStandardReport != null) && (selectedStandardCampaign != null);
        System.debug('Selected campaign: ' + selectedStandardCampaign + ' and reportName: ' + reportName + ' and reportId: ' + selectedStandardReport);
    }
    
    private void initializeData(String selectedReportName) {
        // Initialize user
        currentUser = [SELECT Id, Profile.Name, MRKT_ID__c, DFALT_DIV_NM__c, DFALT_ZONE_CD__c, User.LanguageLocaleKey, UserRole.Name 
                from User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        userProfile = currentUser.Profile.Name;
        if(userProfile.contains('Zone Manager')){
            userProfile='ZM';
        }
        else if(userProfile.contains('Division Manager')){
            userProfile='DM';
        }
        // Initialize zones
        initializeZoneList();
        if (currentUser.Profile.Name.contains('Division')) {
              multipleZones = true;
            selectedZone = currentUser.DFALT_DIV_NM__c;
        } else {
            
            selectedZone = currentUser.DFALT_ZONE_CD__c;
        }
        System.debug('zoneList:'+zoneList);
        if(zoneList.size() > 1)
            multipleZones = true;
            
        // Initialize campaign
        // 'Mgr_Omniture_Suite_Name__c' field included in SOQL - by Raktim on 8th Oct 2013
        this.market = [SELECT Id,Market_Id__c, PREV_1_CMPGN_NR__c, Mail_Plan_Enabled__c,CMPGN_NR__c, NEXT_1_CMPGN_NR__c, Is_ALMPLUS_Enabled__c, Lead_Purge_Min__c, Legal_Purge_Age__c,  
                       Omniture_Suite_Name__c, Mgr_Omniture_Suite_Name__c  FROM Market__c 
                        where Market_Id__c = :currentUser.MRKT_ID__c];
       
         //is lead enabled
        isALMPlusEnabled = this.market.Is_ALMPLUS_Enabled__c;
       
        // Initialize template URL
        templateReportURL = URL.getSalesforceBaseUrl().toExternalForm() +'/$REPORT?pv0=$CAMPAIGN';
        
        //variable populated from market. Omniture Change - on 23rd Sept, 2013
        //omniSuitName = market.Omniture_Suite_Name__c;
        omniSuitName = market.Mgr_Omniture_Suite_Name__c; // modified by Raktim - on 8th Oct, 2013
        
        //thresold age
        /*if(isALMPlusEnabled)
            thrShldAge = String.valueOf(this.market.Legal_Purge_Age__c - this.market.Lead_Purge_Min__c);
        else
            thrShldAge =  null;
        
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
        mapForReportFilter = new Map<String, String>();
        mapForReportFilter.put('All','00OJ0000000YM89');
        mapForReportFilter.put('Rep','00OJ0000000YQm8');
        mapForReportFilter.put('Customer','00OJ0000000YUGu');
        
        ldTypeList.add(new SelectOption('00OJ0000000YM89','All'));
        ldTypeList.add(new SelectOption('00OJ0000000YQm8','Rep'));
        ldTypeList.add(new SelectOption('00OJ0000000YUGu','Customer'));*/
        
        
        // Initialize reports
        /****
         * Retrieve Reports from the translation table
         **/
        mp=(this.market.Mail_Plan_Enabled__c?'Y':'N');    //Added by swarnava:Mail Plan        
        
        for(ZM_Report_Translation__c z : [Select z.Sort_Order__c
                                               , z.Report_URL__c
                                               , z.Report_Label__c
                                               , z.Report_Id__c
                                               , z.Market_Id__c
                                               , z.Language_Code__c
                                               , z.Id
                                               , z.Application_Context__c
                                               , z.Report_Role__c 
                                            From ZM_Report_Translation__c z
                                           where Language_Code__c = :currentUser.LanguageLocaleKey
                                            and Market_Id__c includes(:currentUser.MRKT_ID__c)
                                            and Application_Context__c includes ('Report Center','Lead')
                                            and Is_Mail_Plan_Specific__c IN (null,:mp)      //changed by swarnava:Mail Plan 
                                           order by sort_order__c]){
                                           	
            if(currentUser.Profile.Name == null || currentUser.Profile.Name.containsIgnoreCase(z.Report_Role__c))
                standardReportList.add(new SelectOption(z.Report_URL__c, z.Report_Label__c));   
        }
    
      /*eligibleList.add(new SelectOption('0',System.Label.No));
        eligibleList.add(new SelectOption('1',System.Label.Yes));
        
        closedList.add(new SelectOption('0',System.Label.No));
        closedList.add(new SelectOption('1',System.Label.Yes));*/
        
             
        for(Report r : [SELECT Id, OwnerId, Name, Description, DeveloperName 
                          FROM Report 
                         WHERE OwnerId = :currentUser.Id ORDER BY Name]) {
            personalReportList.add(new SelectOption(r.Id, r.Name));
        }
         
        // Initialize market reports
        list<CDW_Market_Report__c>marketReports = new list<CDW_Market_Report__c>();
        for(CDW_Market_Report__c  mr : [SELECT Name, Branch__c, FileName__c, Market__c, Market__r.Market_Id__c, Profile__c, Report_Code__c, User_Type_Index__c 
                                          FROM CDW_Market_Report__c 
                                         WHERE User_Type_Index__c = 'Z' AND Market__r.Market_Id__c = :currentUser.MRKT_ID__c ORDER BY Name])
           marketReports.add(mr);
           
        if (currentUser.Profile.Name.contains('Division')) {
            for(CDW_Market_Report__c mr2 : [SELECT Name, Branch__c, FileName__c, Market__c, Market__r.Market_Id__c, Profile__c, Report_Code__c, User_Type_Index__c 
                                              FROM CDW_Market_Report__c
                                             WHERE User_Type_Index__c = 'D' AND Market__r.Market_Id__c = :currentUser.MRKT_ID__c ORDER BY Name])
            marketReports.add(mr2);
        }
        
        String filename;
        for (CDW_Market_Report__c report : marketReports) {
            filename = report.User_Type_Index__c + '$ZONE_' + report.Report_Code__c + '_$CAMPAIGN_' + currentUser.LanguageLocaleKey;
            offlineReportList.add(new SelectOption(report.Id+':'+filename, report.Name));
            //offlineReportMap.put(report.Id, report);
        }
    }
    
    // New Method - Omniture Addition
    public String getOmniturePageName() {  
        return ALMPlusUtils.generateOmniturePageName('ZM_ReportCenter', null, currentUser.Profile.Name);         
    } //this is for getting page name mapping for omniture
    
    private void initializeZoneList() {
        
        ZM_UtilityClassOOB util = new ZM_UtilityClassOOB();
        util.SetVariable();
        zoneList = util.getZoneList();
    }
    
    public void doNothing(){ }
        
    public List<SelectOption> getStandardReportList() {
        return standardReportList;
    }
    
    /*public List<SelectOption> getLeadReportList() {
        return leadReportList;
    }
    
    public Id getSelectedLeadReport() {
        return selectedLeadReport;
    }
    
    public void setSelectedLeadReport(Id leadReport) {
        selectedLeadReport = leadReport;
    }*/
    
    public List<SelectOption> getPersonalReportList() {
        return personalReportList;
    }
    
    public Boolean getShowPersonalReport() {
        return personalReportList.size() > 0;
    }
    
    public List<SelectOption> getOfflineReportList() {
        return offlineReportList;
    }

    public List<SelectOption> getZoneList() {
        return zoneList;
        
    }
    
    /*public List<SelectOption> getLdTypeList() {
        return ldTypeList;
    }
    
    public List<SelectOption> getClosedList() {
        return closedList;
    }
    
    public List<SelectOption> getEligibleList() {
        return eligibleList;
    }*/
            
    public List<SelectOption> getCampaignList() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new selectoption(market.PREV_1_CMPGN_NR__c, market.PREV_1_CMPGN_NR__c)); // Prior
        options.add(new selectoption(market.CMPGN_NR__c, market.CMPGN_NR__c)); // Current
        options.add(new selectoption(market.NEXT_1_CMPGN_NR__c, market.NEXT_1_CMPGN_NR__c)); // Next
        return options;
    }
    
    /*public List<SelectOption> getLeadCampaignList() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new selectoption(market.CMPGN_NR__c, market.CMPGN_NR__c)); // Current
        options.add(new selectoption(market.PREV_1_CMPGN_NR__c, market.PREV_1_CMPGN_NR__c)); // Prior
        //options.add(new selectoption(market.NEXT_1_CMPGN_NR__c, market.NEXT_1_CMPGN_NR__c)); // Next
        return options;
    }*/

    public String getReportURL() {
        String reportURL = templateReportURL;
        if (selectedStandardReport != null) {
            reportURL.replace('$REPORT', selectedStandardReport);
        }
        if (selectedStandardCampaign != null) {
            reportURL.replace('$REPORT', selectedStandardCampaign);
        }
        System.debug('URL for redirect is: ' + reportURL);
        return reportURL;
    }
    
    public PageReference redirectToStandardReport(){
        PageReference p = new PageReference(selectedStandardReport);
        p.getParameters().put('pv0', selectedStandardCampaign);
        p.getParameters().put('pv1', selectedStdZone);
        p.setRedirect(true);
        return p;        
    }
    
    public PageReference selectedPersonalReport(){
        PageReference p = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+selectedPersonalReport);
        p.getParameters().put('pv0', selectedStandardCampaign);
        p.getParameters().put('pv1', selectedStdZone);
        
        p.setRedirect(true);
        return p;
    }
    
    public PageReference openOfflineReport(){      
        
        string reportId = selectedOfflineReport.split(':')[0];
        string filename = selectedOfflineReport.split(':')[1];
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'reportId: '+reportId +'  filename: '+filename ));
        //return null;
        string fileUrl = getAttachmentURL(reportId, filename);
        
        if(fileUrl == null || fileUrl == '')
          return null;
        PageReference p = new PageReference(fileUrl);
        p.setRedirect(true);
        return p;
    }
    
    public String getAttachmentId(CDW_Market_Report__c marketReport, String campaign) {   
        Id attachmentId;        
        String fileName = marketReport.User_Type_Index__c + selectedZone + '_' + 
                marketReport.Report_Code__c + '_' + campaign + '_' + currentUser.LanguageLocaleKey; //TODO: make the naming convention configuration driven!
                        
        List<Attachment> attachments = new List<Attachment>();
        for(Attachment a : [  select Id from Attachment
                                where Name like :fileName 
                                and Parent.Id = :marketReport.Id 
                                order by CreatedDate desc
                                limit 1])
            attachments.add(a);
                
        if (attachments.size() > 0) {
            attachmentId = attachments[0].Id;
        }
        
        System.debug('File name: ' + fileName + ' and Attachment Id: ' + attachmentId);         
        return attachmentId;                     
    }
    
    @RemoteAction
    public static String getAttachmentId(String reportId, String filename) {   
        Id attachmentId;
        filename += '%';
                                
        List<Attachment> attachments = [select Id from Attachment
                where Name like :filename
                and Parent.Id = :reportId 
                order by CreatedDate desc
                limit 1];
                
        if (attachments.size() > 0) {
            attachmentId = attachments[0].Id;
        }
        
        System.debug('File name: ' + filename + ' and Attachment Id: ' + attachmentId);         
        return attachmentId;                     
    }   
    
    @RemoteAction
    public static String getAttachmentURL(String reportId, String filename) {
        String attachmentURL = '';
        Id attachmentId = getAttachmentId(reportId, filename);
        if (attachmentId != null) {
            attachmentURL = '/servlet/servlet.FileDownload?file=' + attachmentId;
        }
        System.debug('===================== In ReportCenterController.getAttachmentURL(). URL for attachment is: ' + attachmentURL);
        return attachmentURL;
    }
    
    public String getZones(Id id){
        String zones = '';
        list<Sales_Org_Summary__c> lstSLSOrgs= [ select SLS_ORG_DESC_TXT__c 
                                                   from Sales_Org_Summary__c 
                                                   where ZONE_MGR__c=:Userinfo.getUserId() 
                                                   and MRKT_KEY__c = :id
                                                   and SLS_ORG_LVL_DESC_TXT__c = 'Z'
                                                   order by SLS_ORG_DESC_TXT__c asc ];   
        Set<String> uniqueSlsOrgDescSet = new Set<String>();
        if(lstSLSOrgs.size()>0){
            for(Sales_Org_Summary__c slsOrg : lstSLSOrgs) {
                    uniqueSlsOrgDescSet.add(slsOrg.SLS_ORG_DESC_TXT__c);
            }   
        }
        
        for(String zoneName : uniqueSlsOrgDescSet) {
                zones += '\'' + zoneName + '\',';
        }
        zones = (zones.length() > 0) ? zones.left(zones.length() - 1) : '\'\'';
        System.debug('\n ######### USER ZONE LIST '+zones);
        return zones;
        
    }
    
    //@T-214186 : Commented by Barkha Jain on Nov 21
   /* @isTest(SeeAllData=true)
    static void testThisClass()
    {
        TestDataHelper testData =   new TestDataHelper();
        
        String acctNbr = '123456';
        
        // Creates Market Data
        Market__c mkt = testData.createMarket();
        User zmUsr, dmUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            zmUsr = testData.createUser(acctNbr, 'XZ1', ' Zone Manager');
            
            mkt.OwnerId = zmUsr.Id;
            mkt.Mail_Plan_Enabled__c = true;
            update  mkt;
            
            // Creating Sales org Summary data
            Sales_Org_Summary__c sos = new Sales_Org_Summary__c(ZONE_MGR__c=zmUsr.Id, OPERTNL_CMPGN_NR__c=mkt.CMPGN_NR__c,
                                                               SLS_ORG_LVL_DESC_TXT__c='Z', SLS_ORG_DESC_TXT__c=zmUsr.DFALT_ZONE_CD__c,
                                                               MRKT_KEY__c=mkt.Id,  FLD_SLS_CMPGN_NR__c=mkt.CMPGN_NR__c,
                                                                OwnerId=zmUsr.Id);
            insert sos;
            System.debug('\n SOS ############# \n'+sos);
        }
        
        // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mkt, zmUsr.DFALT_ZONE_CD__c);
        
        // Creates ZM Report Market Translation data
        Report r = [Select Name, Id from Report limit 1];
                        
        ZM_Report_Translation__c z = new ZM_Report_Translation__c();
        z.Sort_Order__c = 1;
        z.Report_URL__c = 'x';
        z.Report_Label__c = r.Name;
        z.Report_Id__c = r.Id;
        z.Market_Id__c = mkt.Market_Id__c;
        z.Language_Code__c = zmUsr.LanguageLocaleKey;
        z.Application_Context__c = 'Report Center;Lead';
        z.Report_Role__c = 'Zone';
        z.Name = r.Name;
        z.OwnerId = zmUsr.Id;
        
        insert z;
        
        
        
        PageReference pageRef = Page.ZM_ReportCenter;
        pageRef.getParameters().put('report', 'test');
        Test.setCurrentPage(pageRef);
        
        System.runAs(zmUsr){
            ZM_Controller_ReportCenter ctlr = new ZM_Controller_ReportCenter();
            
            ctlr.initializeZoneList();
            ctlr.initializeData('');
            
            ctlr.selectedStandardReport=[select Id from Report limit 1].Id;
            ctlr.selectedOfflineReport= ctlr.selectedStandardReport+':testfile';
            
            ctlr.getOfflineReportList();
            ctlr.getOfflineReportList();
            ctlr.getPersonalReportList();
            ctlr.getReportURL();
            ctlr.getShowPersonalReport();
            ctlr.getStandardReportList();
            ctlr.getZones(mkt.Id);
            
            ctlr.openOfflineReport();
            ctlr.redirectToStandardReport();
            ctlr.getZoneList();
            ctlr.getOmniturePageName();
            ctlr.getCampaignList();
            ctlr.selectedPersonalReport();
            
            
            //ZM_Controller_ReportCenter.getAttachmentURL('123', 'test');
            
        }
        
        System.runAs ( thisUser ) {
            dmUsr = testData.createUser(acctNbr+'02', 'XZ2', ' Division Manager');
            
            mkt.OwnerId = dmUsr.Id;
            mkt.Mail_Plan_Enabled__c = true;
            update  mkt;
            
            // Creating Sales org Summary data
            Sales_Org_Summary__c sos = new Sales_Org_Summary__c(ZONE_MGR__c=dmUsr.Id, OPERTNL_CMPGN_NR__c=mkt.CMPGN_NR__c,
                                                               SLS_ORG_LVL_DESC_TXT__c='Z', SLS_ORG_DESC_TXT__c=dmUsr.DFALT_ZONE_CD__c,
                                                               MRKT_KEY__c=mkt.Id,  FLD_SLS_CMPGN_NR__c=mkt.CMPGN_NR__c,
                                                                OwnerId=dmUsr.Id);
            insert sos;
        }
        
        // Creating CDW Market Report data
        CDW_Market_Report__c cdwMrkReprt = new CDW_Market_Report__c(Name = 'TestCDWReport', CurrencyISOCode='USD', 
                                                                    OwnerId = dmUsr.Id, User_Type_Index__c = 'Z',
                                                                    Market__c = mkt.Id);
        insert cdwMrkReprt;                                                     
        
        PageReference pageRef1 = Page.ZM_ReportCenter;
        Test.setCurrentPage(pageRef1);
        
        System.runAs(dmUsr){
            ZM_Controller_ReportCenter ctlr1 = new ZM_Controller_ReportCenter();
            ctlr1.getAttachmentId(cdwMrkReprt, mkt.CMPGN_NR__c);
        }
        
        
    }
    */
    
    
    
}