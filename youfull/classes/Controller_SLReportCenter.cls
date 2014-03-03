/***************************************************************************
 Name          : Controller_SLReportCenter 
 Description   : Clone of ReportCenter
 Created By    : Parul Gupta 
 Created Date  : 9 Jan, 2013                
****************************************************************************/
public without sharing class Controller_SLReportCenter {    
    
    public User currUsr {get; private set;}
    public User loggedUsr {get; private set;}
    public String impersonationUser {get; set;}
    public Market__c market {get; private set;}
    public List<Report_Center__c> lst_Reports {get;set;}
    public String mktID{get; private set;}
    public String curUsrId{get; private set;}
    String s_Report_Name;
    public List<Report_Config__c> lst_ReportLinks{get;set;} //For Report Link
    public ALM_Global_Settings__c globalConfig {get; set;}
    public List<ReportCenterDTO> lst_AddReports{get;set;}
    public Boolean s_IsImpersonated {get;set;}
    public String s_Impersonated_UserName{get;set;}
    
    public String s_Impersonate_acct{get; private set;}
    
    public String repDetailAcctNbr {get; set;}  // Required for Coaching Record Integration
    public String selectedReport {get;set;}
    
    public class ReportCenterDTO{
        public String s_Report_Name {get;set;}
        public Map<String, String> m_Report_Link {get; set;}
        public List<String> lst_Campaign {get; set;}
        public String s_Active_Link {get;set;}
        public String s_Report_Target{get;set;}
    }
    
     public Controller_SLReportCenter(){
        s_IsImpersonated = false;
        try{
            this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();   
            lst_AddReports = new List<ReportCenterDTO>(); 
            lst_ReportLinks = new List<Report_Config__c>();           
            s_Impersonate_acct = ApexPages.currentPage().getParameters().get('acctkey');  
            loggedUsr = [Select   Id,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, USER_CNTRY_CD__c,
                                    LastName, LanguageLocaleKey, FirstName,MRKT_ID_ACCT_NR_KEY__c,
                                    DFALT_ZONE_CD__c, DFALT_DIV_NM__c,ACCT_NR__c,Profile.Name,LDRSHP_TITL_LVL_NBR__c,LDRSHP_TITL_LVL_NBR_NUMBER__c,
                                    Is_Eligible__c,Opt_In__c,Out_of_Office__c,ZM_Override__c,System_Override__c
                            From    User
                            where   Id = :UserInfo.getUserId()];
                            
            if(s_Impersonate_acct!=null && s_Impersonate_acct.trim()!=''){
                String s_Impersonate_mrkt_acct_key=loggedUsr.MRKT_ID__c+s_Impersonate_acct;
                currUsr = [Select   Id,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, USER_CNTRY_CD__c,
                                    LastName, LanguageLocaleKey, FirstName,MRKT_ID_ACCT_NR_KEY__c,
                                    DFALT_ZONE_CD__c, DFALT_DIV_NM__c,ACCT_NR__c,Profile.Name,LDRSHP_TITL_LVL_NBR__c,LDRSHP_TITL_LVL_NBR_NUMBER__c,
                                    Is_Eligible__c,Opt_In__c,Out_of_Office__c,ZM_Override__c,System_Override__c
                            From    User
                            //where   Id = :UserInfo.getUserId()
                            Where MRKT_ID_ACCT_NR_KEY__c=:s_Impersonate_mrkt_acct_key limit 1];
                s_IsImpersonated = true;
                s_Impersonated_UserName=currUsr.Name;
            }
            else 
                currUsr=loggedUsr;
            this.repDetailAcctNbr=null;
            
            this.currUsr.Profile.Name = currUsr.Profile.Name;
            mktID=this.currUsr.MRKT_ID__c;
            curUsrId= this.currUsr.Id;
            
            System.debug('Market Id-->'+mktID);
            
            this.market = [ Select Id,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, Name,
                                    Market_Id__c, Mail_Plan_Enabled__c, CURRNT_CMPGN_RMN_DAY_CNT__c, 
                                    CMPGN_STRT_DT__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c,CMPGN_END_DT__c,
                                    LAST_UPDT_DT__c,                                                                                                        
                                    eCard_Status_Message_Header__c,Lead_Source_Exclusions__c,Title_Exclusion__c,
                                    Omniture_Suite_Name__c,Is_ZM_Override_Applicable__c,CURRENT_QRTR__c
                            From    Market__c   
                            where   Market_Id__c =:mktID];
                
            System.debug('Current User-->'+currUsr+'Market-->'+this.market);                              
            fetchReports(String.valueOf(currUsr.ACCT_NR__c),String.valueOf(loggedUsr.LanguageLocaleKey),String.valueOf(currUsr.Profile.Name),String.valueOf(currUsr.LDRSHP_TITL_LVL_NBR__c),String.valueOf(this.market.Id),Integer.valueOf(this.market.CMPGN_NR__c),Integer.valueOf(this.market.PREV_1_CMPGN_NR__c),Integer.valueOf(this.market.NEXT_1_CMPGN_NR__c));
            //Report List for Other Reports Start
            SiteHeaderController obj_Controller = new SiteHeaderController();
            obj_Controller.currUsr=currUsr;
            if(s_Impersonate_acct!=null){
                Report_Config__c[] obj_RC_List=obj_Controller.getReportLinks(this.market.Market_Id__c, currUsr.Profile.Name,currUsr.LDRSHP_TITL_LVL_NBR__c,true);
                if(obj_RC_List.size()>0){
                    for(Report_Config__c obj_RC : obj_RC_List){                                        
                        if(obj_RC.Report_Type__c != ALMConstants.REPORT_TYPE_TITL_RPTCENTER)                                         
                            lst_ReportLinks.add(obj_RC);
                    }
                }
            }
            else{
                Report_Config__c[] obj_RC_List=obj_Controller.getReportLinks(this.market.Market_Id__c, currUsr.Profile.Name,currUsr.LDRSHP_TITL_LVL_NBR__c,true);            
                if(obj_RC_List.size()>0){
                    for(Report_Config__c obj_RC : obj_RC_List){                   
                        if(obj_RC.Report_Type__c != ALMConstants.REPORT_TYPE_TITL_RPTCENTER)                                      
                            lst_ReportLinks.add(obj_RC);
                    }
                }
            }    
            //Report List for other reports End
        }catch(exception ex){
           System.debug('Exception e-->'+ex.getMessage()+'At Line Number->'+ex.getLineNumber()); 
        }
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
    }
    
     public Controller_SLReportCenter getThis(){
        return this;
    }
    
    public List<SelectOption> getReportLinks(){     
        List<SelectOption> reportLinks = new List<SelectOption>();
        if(lst_ReportLinks != null){
            selectedReport = Label.Other_Reports;
            //reportLinks.add(new SelectOption(Label.Other_Reports, Label.Other_Reports));
            if(s_IsImpersonated){
                reportLinks.add(new SelectOption('/apex/YouHome?pgId=1', Label.ALM_Home));
                reportLinks.add(new SelectOption('CR', Label.Coaching_Record));
            }
            
            for(Report_Config__c reportConfig : lst_ReportLinks){
                if(reportConfig.Report_URL__c != null && reportConfig.Report_URL__c.length() > 0){
                    reportLinks.add(new SelectOption(reportConfig.Report_URL__c, reportConfig.Report_Type__c));
                }else{
                    reportLinks.add(new SelectOption('/apex/YouHome?pgId=1', reportConfig.Report_Type__c)); 
                }               
            }
        }
        return reportLinks;
    }
    
    public void fetchReports(String s_Account,String s_Language,String s_Profile,String s_TitleLevel,String s_MarketId,Integer s_Current_Campaign, Integer s_Previous_Campaign,Integer s_Next_Campaign){
        try{
                lst_Reports = new List<Report_Center__c>();
                
                // To check for all and a specific profile of the user
                String [] s_Profile_Report = new String[]{};
                s_Profile_Report.add('All');
                s_Profile_Report.add(s_Profile);
                
                String slist = '';
                for (String s: s_Profile_Report) {
                    slist += '\'' + s + '\',';
                }
                slist = slist.substring (0,slist.length() -1);
                
                // Valid only for Sales Leader as Zone Manager and Division Manager would not have Leader Title
                s_TitleLevel = '\'' + s_TitleLevel + '\'';
                
                
                //Dynamically Creating the query and the parameters
                
                String s_Query_String = 'Select Id,Frequency__c,Target__c,Report_Type__c,SL_File_Mask__c,File_Extension__c,Avon_Profile__c,Campaign__c,Title_Level__c From Report_Center__c Where Report_Type__c!=null and Market__c='+'\''+s_MarketId+'\' and Avon_Profile__c INCLUDES ('+slist+') and Title_Level__c INCLUDES ('+s_TitleLevel+')'; 
                if(s_Impersonate_acct!=null){
                system.debug('s_Query_String = ' + s_Query_String);
                s_Query_String+='and Can_Impersonate__c=true';
                }               
                //Querying Report Center
                lst_Reports = Database.query(s_Query_String);
                
                system.debug ('lst_Reports size = ' + lst_Reports.size());
                 
                
                List<String> lst_ReportsLinks = new List<String>();
                Map<Id,String> m_Names = new Map<Id,String>();
                Map<String,String> m_Report_Campaign_List = new Map<String,String>();
                Map<String, String> mCampaign = new Map<String, String>();
                Map<String, ReportCenterDTO> mReportTypeRCDTO = new Map<String, ReportCenterDTO>();
                
                if(lst_Reports.size()>0){
                    if(s_Profile==ALMPLusConstants.AVON_LEADER || s_Profile=='Avon Standard Leader'&& s_Account!=null){
                        
                        Integer totalHistoricalCampaigns =0;
                        
                        for(Integer i=0;i<lst_Reports.size();i++){
                            System.debug('mask --> '+lst_Reports[i].SL_File_Mask__c);
                            if(lst_Reports[i].SL_File_Mask__c!=null){
                                String cmpgn = String.valueOf(lst_Reports[i].Campaign__c);
                                if(cmpgn.contains('PC-')){
                                    String[] periods = cmpgn.split(';');
                                    for(String period : periods) {
                                        if(period.contains('PC-')) {
                                            Integer histDepth = Integer.valueOf(period.subString(period.indexOf('PC-')+3));
                                            totalHistoricalCampaigns = totalHistoricalCampaigns<histDepth ? histdepth : totalHistoricalCampaigns;   
                                        }
                                    }
                                }
                            }
                        }
                        
                        System.debug('totalHistoricalCampaigns --> '+totalHistoricalCampaigns);
                        
                        if(totalHistoricalCampaigns > 0) {
                            List<Calendar__c> calendarList = [SELECT PRIOR_CMPGN_NR__c, CMPGN_NR__c, CMPGN_NR_TXT__c, CMPGN_NR_FRMTD__c From Calendar__c
                                                              WHERE Market__c = :s_MarketId
                                                              AND (CMPGN_NR__c IN (:s_Next_Campaign, :s_Current_Campaign) 
                                                                    OR CMPGN_NR__c < :s_Current_Campaign) 
                                                              ORDER BY CMPGN_NR__c DESC
                                                              LIMIT :totalHistoricalCampaigns+4];
                                                              
                            for(Calendar__c calendar: calendarList) {
                                String campaignText = String.valueOf(calendar.CMPGN_NR__c);
                                
                                if(calendar.CMPGN_NR__c == s_Next_Campaign) {
                                    mCampaign.put('NC', campaignText);
                                }
                                else if(calendar.CMPGN_NR__c == s_Current_Campaign) { 
                                    mCampaign.put('CC', campaignText);
                                }
                                else if(calendar.CMPGN_NR__c == s_Previous_Campaign) { 
                                    mCampaign.put('PC', campaignText);
                                }
                                else {
                                    Integer cmpgnGap = s_Current_Campaign - Integer.valueOf(calendar.CMPGN_NR__c);
                                    cmpgnGap-= 1;
                                    cmpgnGap = (cmpgnGap>11 ? cmpgnGap - 81 : cmpgnGap);
                                    mCampaign.put('PC-'+cmpgnGap,campaignText);
                                    System.debug('PC- --> '+cmpgnGap+' '+campaignText+' '+s_Current_Campaign+' '+calendar.CMPGN_NR__c);
                                }
                            }
                        }
                        else {
                            mCampaign.put('NC', String.valueOf(s_Next_Campaign));
                            mCampaign.put('CC', String.valueOf(s_Current_Campaign));
                            mCampaign.put('PC', String.valueOf(s_Previous_Campaign));
                        }
                        
                        System.debug('mCampaign --> '+mCampaign);
                        
                        if(this.lst_AddReports==null){
                            this.lst_AddReports = new List<ReportCenterDTO>();  
                        }
                        this.lst_AddReports.clear();
                        mReportTypeRCDTO = new Map<String, ReportCenterDTO>();
                        
                        for(Integer i=0;i<lst_Reports.size();i++){
                            
                            ReportCenterDTO obj_DTO = new ReportCenterDTO();
                            obj_DTO.m_Report_Link =new Map<String, String> ();
                            obj_DTO.lst_Campaign = new List<String>();
                            
                            System.debug('mask --> '+lst_Reports[i].SL_File_Mask__c);
                            
                            if(lst_Reports[i].SL_File_Mask__c!=null){
                                // Constructs the file names on the basis of the mask , checking for Current Campaign,Prior Campaign and Next Campaign
                                system.debug('in line 220');
                                if(!(String.valueOf(lst_Reports[i].SL_File_Mask__c).contains('YYYYMM'))){
                                    if(String.valueOf(lst_Reports[i].Campaign__c).contains('CC')){
                                    //  system.debug('Campaign = cc');
                                        s_Report_Name =String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('CC')).replace('LANGCD',s_Language) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase();
                                        m_Report_Campaign_List.put(s_Report_Name,'CC');
                                        obj_DTO.lst_Campaign.add(mCampaign.get('CC'));
                                    }
                                    if(String.valueOf(lst_Reports[i].Campaign__c).contains('PC')){
                                        s_Report_Name = String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('PC')).replace('LANGCD',s_Language) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase();
                                        m_Report_Campaign_List.put(s_Report_Name,'PC');
                                        obj_DTO.lst_Campaign.add(mCampaign.get('PC'));
                                      //  system.debug('Campaign = pc');
                                    }
                                    if(String.valueOf(lst_Reports[i].Campaign__c).contains('NC')){
                                        s_Report_Name = String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('NC')).replace('LANGCD',s_Language) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase();
                                        m_Report_Campaign_List.put(s_Report_Name,'NC');
                                        obj_DTO.lst_Campaign.add(mCampaign.get('NC'));
                                       // system.debug('Campaign = nc');
                                    }
                                    if(String.valueOf(lst_Reports[i].Campaign__c).contains('PC-')){
                                        //system.debug('in last if for pc-');
                                        String[] periods = String.valueOf(lst_Reports[i].Campaign__c).split(';');
                                        for(String period : periods) {
                                            if(period.contains('PC-')) {
                                                Integer cmpgnGap = Integer.valueOf(period.subString(period.indexOf('PC-')+3));
                                                System.debug('cmpgnGap --> '+cmpgnGap);
                                                s_Report_Name = String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('PC-'+cmpgnGap)).replace('LANGCD',s_Language) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase();
                                                m_Report_Campaign_List.put(s_Report_Name,'PC-'+cmpgnGap);
                                                obj_DTO.lst_Campaign.add(mCampaign.get('PC-'+cmpgnGap));
                                            }
                                        }
                                    }
                                }
                                
                                /*else{
                                    for(Integer z=0;z<3;z++){
                                        if(z==0){
                                            m_Report_Campaign_List.put(String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('NC')).replace('LANGCD',s_Language).replace('YYYYMM',String.valueOf((System.now().addMonths(z)).format('yyyyMM'))) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase(),String.valueOf(z));
                                        }
                                        else{
                                            m_Report_Campaign_List.put(String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('NC')).replace('LANGCD',s_Language).replace('YYYYMM',String.valueOf((System.now().addMonths(-z)).format('yyyyMM'))) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase(),String.valueOf(-z));
                                            m_Report_Campaign_List.put(String.valueOf(lst_Reports[i].SL_File_Mask__c).replace('ACCTNR',s_Account!=null ? s_Account : '').replace('RPTCODE',lst_Reports[i].Report_Type__c).replace('CMPGNNR',mCampaign.get('NC')).replace('LANGCD',s_Language).replace('YYYYMM',String.valueOf((System.now().addMonths(z)).format('yyyyMM'))) + String.valueOf(lst_Reports[i].File_Extension__c).toLowerCase(),String.valueOf(z));
                                        }   
                                    }
                                }*/
                                m_Names.put(lst_Reports[i].Id,lst_Reports[i].Report_Type__c);
                            }
                            system.debug ('obj_DTO = ' + obj_DTO);
                            lst_AddReports.add(obj_DTO);
                            mReportTypeRCDTO.put(lst_Reports[i].Report_Type__c, obj_DTO);
                        }
                    }
                    System.debug('m_Names --> '+m_Report_Campaign_List);
                    
           
                        System.debug('Names-->'+m_Names);
                        System.debug('List of Reports to be extracted-->'+m_Report_Campaign_List.keySet());
                        if(m_Report_Campaign_List.size()>0){
                            List<Report_Center__c> lst_ListAttachments = [Select Id,Report_Type__c,Campaign__c,Frequency__c,Target__c,(Select Id,ParentId,Name,CreatedDate,LastModifiedDate From Attachments Where Name In :m_Report_Campaign_List.keySet() Order By CreatedDate) From Report_Center__c Where Id In : m_Names.keySet()];
                            System.debug(lst_ListAttachments);
                            if(lst_ListAttachments.size()>0){
                                for(Report_Center__c obj_RC : lst_ListAttachments){
                                    ReportCenterDTO obj_DTO = mReportTypeRCDTO.get(obj_RC.Report_Type__c);
                                    obj_DTO.s_Report_Name = obj_RC.Report_Type__c;
                                    obj_DTO.s_Report_Target=obj_RC.Target__c;
                                    
                                    Attachment[] obj_Attachments = obj_RC.Attachments;
                                    if(obj_Attachments!=null){
                                        for(Attachment obj_Attach : obj_Attachments){
                                            System.debug('attachment --> '+obj_Attach.Name+' '+obj_Attach.Id);
                                            if(m_Report_Campaign_List.get(obj_Attach.Name)!=null){
                                                if(m_Report_Campaign_List.get(obj_Attach.Name)=='PC'){
                                                    obj_DTO.m_Report_Link.put(mCampaign.get('PC'),obj_Attach.Id);
                                                }
                                                if(m_Report_Campaign_List.get(obj_Attach.Name)=='CC'){
                                                    obj_DTO.m_Report_Link.put(mCampaign.get('CC'),obj_Attach.Id);
                                                }
                                                if(m_Report_Campaign_List.get(obj_Attach.Name)=='NC'){
                                                    obj_DTO.m_Report_Link.put(mCampaign.get('NC'),obj_Attach.Id);
                                                }
                                                /*if(m_Report_Campaign_List.get(obj_Attach.Name)=='0'){
                                                    System.debug('In Here 0--->'+obj_Attach.Name+'>>>>>>>>>'+obj_Attach.Id);
                                                    obj_DTO.m_Report_Link.put(mCampaign.get('CC'),obj_Attach.Id);
                                                }
                                                if(m_Report_Campaign_List.get(obj_Attach.Name)=='-1' ||
                                                    m_Report_Campaign_List.get(obj_Attach.Name)=='-2'){
                                                        System.debug('In Here -1--->'+obj_Attach.Name+'>>>>>>>>>'+obj_Attach.Name);  
                                                        obj_DTO.m_Report_Link.put(mCampaign.get('CC'),obj_Attach.Id);
                                                }*/
                                                if(m_Report_Campaign_List.get(obj_Attach.Name).contains('PC-'))
                                                {
                                                    String campaign = m_Report_Campaign_List.get(obj_Attach.Name);
                                                    obj_DTO.m_Report_Link.put(mCampaign.get(campaign),obj_Attach.Id);
                                                }
                                                System.debug(m_Report_Campaign_List.get(obj_Attach.Name));
                                            }
                                        }
                                    }   
                                    
                                    //sort the campaigns
                                    List<String> lstCampaign = new List<String>();
                                    lstCampaign.addAll(obj_DTO.lst_Campaign);
                                    lstCampaign.sort();
                                    System.debug('lstCampaign --> '+lstCampaign);
                                    obj_DTO.lst_Campaign = new List<String>();
                                    for(Integer i = lstCampaign.size()-1; i>=0; i--)
                                    {
                                        System.debug('lstCampaign[i] --> '+i+' '+lstCampaign[i]);
                                        obj_DTO.lst_Campaign.add(lstCampaign[i]);
                                        if(i==lstCampaign.size()-1)
                                            obj_DTO.s_Active_Link=obj_DTO.m_Report_Link.get(lstCampaign[i]);
                                    }
                                    System.debug('obj_DTO.s_Active_Link --> '+obj_DTO.s_Active_Link);
                                }
                            }
                        }
                    }
                    
                    System.debug('lst_AddReports --> '+lst_AddReports);
        }
        catch(Exception e){
                System.debug('Exception e-->'+e.getMessage()+'At Line Number->'+e.getLineNumber());
        }
    }
    
    public PageReference Refreshcampaign()
    {
        String camp=Apexpages.currentPage().getParameters().get('rptpar1');
        String pick=Apexpages.currentPage().getParameters().get('rptpar2');
        System.debug('campaign-->'+camp);
        //System.debug('pick-->'+pick);
        Integer pick_no=Integer.valueOf(pick);
        System.debug('pick-->'+pick_no);
        lst_AddReports[pick_no].s_Active_Link=lst_AddReports[pick_no].m_Report_Link.get(camp);

        return null;
    }//For Refreshing report link according to Selected Campaign
    
    // Omniture Integration - Start
    public String getOmniturePageName() {        
        return ALMPlusUtils.generateOmniturePageName('ReportCenter', null, currUsr.Profile.Name);    
        
    } // End of method
    
    // Coaching Record Integration - Start
    public PageReference callRepDetails(){
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
         
    } // End of method
}