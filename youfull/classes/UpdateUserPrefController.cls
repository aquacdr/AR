/**
 * This class is used for Profile page controller.
 *
 *  This class will be called whenever the profile page is invoked.
 *
 * @name UpdateUserPrefController.cls
 * @author Snehashis Ghosh
 * @date March 30, 2012
 *
 */
public class UpdateUserPrefController {
	public String repDetailAcctNbr {get; set;}//subhamay 17092013 to display coaching record page
    public User userRec {get; set;}
   // public Map<String,ObjectRow> allowedSlsOrgs;
   // public List<ObjectRow> slsOrgs;
    public String selOrgCdId {get; set;}
    public String userProfile {get; private set;}
    public Boolean isError {get; set;}
    public Boolean isLeadOptinError {get; set;}
    public Boolean testMode {get; set;}
    public String tempPassword {get; private set;}
    public Boolean updateSuccess{ get; private set;}
    public Boolean actionAlertError{ get; private set;}
    public Market__c market {get; private set;}
    private static String CLASSNAME='UpdateUserPrefController';
    public ALM_Global_Settings__c globalConfig {get; set;}
    private static Map<String,String> actionAlertLabels;
    private static Map<String,String> actionAlertFreq;
    private static List<String> actionAlertFreqDays;  
    private static Map<String,String> actionAlertView;
    //Apr-29-2011
    public Boolean bDuplicate {get; set;}
    
    public Boolean isMainPlan {get; set;}
    //eoc Apr-29-2011
    //ALM+ variables
   /* public transient Boolean usrElgblty {get; set;}
    public List<String> inelgResn {get; set;}
    //SA 11/23/2011
    private Boolean oooOriginalValue;
    public Boolean hasOOOChanged {
        get{
            if(hasOOOChanged == null)
                hasOOOChanged = false;
            return hasOOOChanged;
        }
        set;
    }
    private Boolean optInOriginalValue;
    public Boolean hasOptInChanged {
        get{
            if(hasOptInChanged == null)
                hasOptInChanged = false;
            return hasOptInChanged;
        }
        set;
    }*/
    public Boolean aAlertEnabled {
        get{
            if(aAlertEnabled == null)
                aAlertEnabled = false;
            return aAlertEnabled;
        }
        set;
    }
    public Boolean inclSendEmail {get;set;}
        
    public String smsAdrs {get;set;}
    
    static{
        actionAlertLabels = new Map<String,String>();
        //In ALM3.1 we have defined 27 Action item list
        actionAlertLabels.put('Rising Stars',System.Label.Rising_Stars);
		actionAlertLabels.put('Title at Risk',System.Label.Title_at_Risk);
		actionAlertLabels.put('Title Lost',System.Label.Title_Lost);
		actionAlertLabels.put('Title Promoted',System.Label.Title_Status_Promotions);
		actionAlertLabels.put('Balance due',System.Label.Balance_Due);
		actionAlertLabels.put('Featured Product no activity',System.Label.Featured_Product_no_activity);
		actionAlertLabels.put('New and In-Progress Leads',System.Label.New_Inprogress_Leads);
		actionAlertLabels.put('Orders Not submitted',System.Label.Orders_Not_Submitted);
		actionAlertLabels.put('Orders Over Minimum to earn',System.Label.Rising_Stars);
		actionAlertLabels.put('Orders Received Billed and Invoiced',System.Label.Order_Invoiced);
		actionAlertLabels.put('Orders Received In Process',System.Label.Orders_Received_In_Process);
		actionAlertLabels.put('Orders under minimum to earn',System.Label.Orders_Under_Minimum);
		actionAlertLabels.put('Past Due',System.Label.Past_Due);
		actionAlertLabels.put('Pending Orders',System.Label.Pending_Orders);
		actionAlertLabels.put('Reps with overdue',System.Label.Reps_with_Overdue);
		actionAlertLabels.put('Return sales',System.Label.Returned_Sales);
		actionAlertLabels.put('Team sales above minimum',System.Label.Team_sales_above_minimum);
		actionAlertLabels.put('Team sales below minimum',System.Label.Team_sales_below_minimum);
		actionAlertLabels.put('Avon Anniversary',System.Label.Avon_Anniversary);
		actionAlertLabels.put('Birthday',System.Label.BirthdayYOU);
		actionAlertLabels.put('Downline PSQ not achieved',System.Label.Downline_PSQ_not_achieved);
		actionAlertLabels.put('G1 Appointments',System.Label.G1_Appointments);
		actionAlertLabels.put('G1 Candidates',System.Label.G1_Candidates);
		actionAlertLabels.put('Inactive',System.Label.Inactive);
		actionAlertLabels.put('Inherited',System.Label.Inherited);
		actionAlertLabels.put('LOA 0-6',System.Label.LOA_0_6);
		actionAlertLabels.put('New Repr LOA 0',System.Label.New_Repr_LOA_0);
		        

        actionAlertFreq = new Map<String,String>();
        actionAlertFreq.put('Daily',System.Label.Daily);
        actionAlertFreq.put('Weekdays',System.Label.Weekdays);
        actionAlertFreq.put('SUN',System.Label.Sunday);
        actionAlertFreq.put('MON',System.Label.Monday);
        actionAlertFreq.put('TUE',System.Label.Tuesday);
        actionAlertFreq.put('WED',System.Label.Wednesday);
        actionAlertFreq.put('THU',System.Label.Thursday);
        actionAlertFreq.put('FRI',System.Label.Friday);
        actionAlertFreq.put('SAT',System.Label.Saturday);
        
        actionAlertFreqDays = new List<String>();
        actionAlertFreqDays.add('Daily');
        actionAlertFreqDays.add('Weekdays');
        actionAlertFreqDays.add('SUN');
        actionAlertFreqDays.add('MON');
        actionAlertFreqDays.add('TUE');
        actionAlertFreqDays.add('WED');
        actionAlertFreqDays.add('THU');
        actionAlertFreqDays.add('FRI');
        actionAlertFreqDays.add('SAT');
        actionAlertView = new Map<String,String>();
		actionAlertView.put(System.Label.Current_Campaign,'Operational Campaign');
        actionAlertView.put(System.Label.Selling_Campaign,'Selling Campaign');
    }   
    public PageReference init(){
    	
    	isMainPlan = false;
    	
        this.globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        
        this.userRec = [select  Id,DFALT_ZONE_CD__c,DFALT_DIV_NM__c,ACCT_NR__c,ProfileId,
                                MRKT_ID__c,LanguageLocaleKey,UserPermissionsMobileUser,Action_Alert_View__c,
                                UserName,Name, Action_Alert_Enabled__c,LDRSHP_TITL_LVL_NBR__c,
                                Action_Alert_1__c,Action_Alert_2__c,Action_Alert_3__c,
                                SMS_Address__c,Profile.Name,Action_Alert_Terms__c,Is_Other_Email_Alert__c,
                                GI3_Email__c,MRKT_ID_ACCT_NR_KEY__c,Action_Alert_Frequency__c,Ineligibility_Codes__c,
                                Email,Action_Alert_Time__c,Out_of_Office__c,Opt_In__c,System_Override__c,Lead_Opt_in_Terms__c,Is_Eligible__c
                        from    User
                        where   Id=:UserInfo.getUserId()];
       //  oooOriginalValue = userRec.Out_of_Office__c;   //SA: store the original value of OOO
        // optInOriginalValue = userRec.Opt_In__c;        //SA: original value of opt in flag
         this.aAlertEnabled = userRec.Action_Alert_Enabled__c;
         this.inclSendEmail = userRec.Is_Other_Email_Alert__c;
         this.smsAdrs = userRec.SMS_Address__c;
         if(smsAdrs==''&& smsAdrs==null){
            smsAdrs=System.Label.Second_Email;
         }
         //added for ALM+ by Snehashis
      /*   this.usrElgblty=userRec.Is_Eligible__c;
         if(!userRec.Is_Eligible__c){
            String tempFld;
            inelgResn = new List<String>();
            List<Ineligibility_Reason__c> inRns=[select id,LANG_CD__c,MRKT_ID__c,Short_Desc_In_Eng__c,Ineligibility_Reason_Key__c,Ineligibility_Reason_In_Eng__c,
                                            Ineligibility_Reason__c,Ineligibility_Code__c
                                            From Ineligibility_Reason__c where LANG_CD__c=:userRec.LanguageLocaleKey 
                                            and Market__r.Market_id__c=:userRec.MRKT_ID__c order by Order__c asc];
            ALMLogUtils.log('UpdateUserPrefController','::'+inRns.size()+'>>>'+userRec.Ineligibility_Codes__c);
            String seperator;
            if(userRec.Ineligibility_Codes__c!=null){
                for(String fldName: userRec.Ineligibility_Codes__c.split(ALMPLusConstants.SEMICOLON)){
                    tempFld = fldName.trim();
                    for(Ineligibility_Reason__c ir:inRns){
                        if(tempFld==ir.Ineligibility_Code__c){
                            inelgResn.add(ir.Ineligibility_Reason__c);
                        }
                    }
               }
            }
        }*/
        if(userRec.Action_Alert_Frequency__c==null){
            userRec.Action_Alert_Frequency__c='Daily';
        }
        
        if(userRec.Action_Alert_View__c==null){
	            userRec.Action_Alert_View__c=System.Label.Current_Campaign;
        }
        
        market = [  select  Action_Alerts__c,Market_Id__c,Id, Omniture_Suite_Name__c,
                            Action_Alert_Enabled__c,Mail_Plan_Enabled__c,
                            //eMobile_Enabled__c,
                            Is_ALMPLUS_Enabled__c,Conditions_Of_Use_URL__c,
                            Omniture_RSID__c
                    from Market__c
                    where Market_Id__c=:userRec.MRKT_ID__c];
                    
        if(market.Mail_Plan_Enabled__c){ isMainPlan = true;}
        
        userProfile = userRec.Profile.Name;
        if(updateSuccess==null){
            updateSuccess=false;    
        }
        if(this.actionAlertError==null){
            actionAlertError=false;
        }
        if(this.isError==null){
            isError =false;
        }
        //added by Snehashis for ALM+
        /*if(this.isLeadOptinError==null){
            isLeadOptinError =false;
        }*/
        //Apr-29-2011
        if(this.bDuplicate == null) {
            bDuplicate = false;
        }
        //eoc Apr-29-2011
        getRecords();
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
        return null;
    }
    
    //added by Snehashis for ALM+
   /* public List<SelectOption> getOOOMsg(){
       List<SelectOption> uOptn = new List<SelectOption>();
        uOptn.add(new SelectOption('True', System.Label.On));
        uOptn.add(new SelectOption('False', System.Label.Off));
        return uOptn;
    }
    
    public List<SelectOption> getOIMsg(){
       List<SelectOption> uOptn = new List<SelectOption>();
        uOptn.add(new SelectOption('True', System.Label.Enroll));
        uOptn.add(new SelectOption('false', System.Label.Unenroll));
        return uOptn;
    }
    
/*    public List<ObjectRow> getAllowedSlsOrgs(){
        return this.slsOrgs;
    }*/
    //subhamay 17092013_to display coaching record page from Profile page
	public PageReference callRepDetails() {
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
    }
    //eoc subhamay 17092013_to display coaching record page from Profile page
    public List<SelectOption> getAllowedActionAlerts(){
        List<SelectOption> allowedAlerts = new List<SelectOption>();
        allowedAlerts.add(new SelectOption('',System.Label.Select_Alert));  
        for(String alert:this.market.Action_Alerts__c.split(';')){
            allowedAlerts.add(new SelectOption(alert,actionAlertLabels.get(alert)));
        }
        return allowedAlerts;
    }
    
    public List<SelectOption> getAllowedActionAlertsView(){
        	System.debug('>>View Called');
            List<SelectOption> allowedAlertsView = new List<SelectOption>();
            //allowedAlertsView.add(new SelectOption('','Select Action Alert View'));  
            for(String view:actionAlertView.keySet()){
            	System.debug('>>>MILON : '+view);
                allowedAlertsView.add(new SelectOption(actionAlertView.get(view),view));
            }
            return allowedAlertsView;
    }
    
    public List<SelectOption> getAllowedFrequencies(){
        List<SelectOption> allowedFreq = new List<SelectOption>();
        allowedFreq.add(new SelectOption('',System.Label.Select_Frequency));
        for(String frequency:actionAlertFreqDays){
            allowedFreq.add(new SelectOption(frequency,actionAlertFreq.get(frequency)));
        }
        return allowedFreq;
    }

    public PageReference updatePreferences(){
        System.debug('>>>>>>>>>>>>>>>this.selOrgCdId='+this.selOrgCdId);
        updateSuccess=false;
        isError=false;
        isLeadOptinError=false;
        actionAlertError=false;
        Boolean isActionAlertValid = validateActionAlertPrefs();
        //Apr-29-2011
        bDuplicate = false;
        //eoc Apr-29-2011
        ALMLogUtils.log(CLASSNAME,'isActionAlertValid='+isActionAlertValid);
        //@@@ Check for Action Alert selection
        if(!validateActionAlertPrefs()){
            ALMLogUtils.log(CLASSNAME,'Action Alert settings not valid !!!!');
            return null;
        }
     /*  Not Required for Phase 1 delivery - Snehashis Ghosh
     
        if(this.allowedSlsOrgs !=null && this.selOrgCdId !=null &&this.selOrgCdId !=''){
            if(userProfile == 'Avon Zone Manager'){
                System.debug('allowed sales orgs:'+allowedSlsOrgs);
                User_Sales_Org_Hierarchy__c currSelect = this.allowedSlsOrgs.get(this.selOrgCdId).getUserSalesOrg();
                this.userRec.DFALT_ZONE_CD__c = currSelect.SLS_ORG_CD__c;
            }else if(userProfile == 'Avon Division Manager'){
                if(this.selOrgCdId == 'All'){
                    this.userRec.DFALT_ZONE_CD__c = null;
                }else{
                    Sales_Organization__c currSelect = this.allowedSlsOrgs.get(this.selOrgCdId).getSalesOrg();
                    if(currSelect.SLS_ORG_LVL_CD__c == 'Z'){
                        this.userRec.DFALT_ZONE_CD__c = currSelect.SLS_ORG_CD__c;
                    }
                }
            }
            /*
            If the user was previously not a mobile user and now has opted in
            for being a mobile user, we'll create a task for the market administrator.
            */
           /* 
            System.debug('>>>>>>>>>>>>>>>>>>>>this.userRec.UserPermissionsMobileUser='+this.userRec.UserPermissionsMobileUser);
        }   */
        Market__c market = [select  Name,Market_Administrator__c,
                                    Market_Administrator__r.Email,
                                    Market_Administrator__r.Name,
                                    Available_Languages__c
                            from Market__c
                            where Market_Id__c=:this.userRec.MRKT_ID__c];
        System.debug('>>>>>>>>>>>>>>>>>>>>this.userRec.LanguageLocaleKey='+this.userRec.LanguageLocaleKey);
        System.debug('>>>>>>>>>>>>>>>>>>>>market.Available_Languages__c='+market.Available_Languages__c);
        //modified checking of language by Snehashis 12/02
        if(!(market.Available_Languages__c+';').contains(userRec.LanguageLocaleKey+';')){
            isError =true;
            return null;    
        } 
        
       System.debug('>>>>>>>>>>>>>>>>>>>> userRec.ProfileId:'+userRec.ProfileId);
        
    
        //added by Snehashis for ALM+
       /* if(this.userRec.Profile.Name==ALMPLusConstants.AVON_LEADER){
            if(this.userRec.Opt_In__c && !this.userRec.Lead_Opt_in_Terms__c){
                isLeadOptinError=true;
                return null;
            }
        }
        
     /*   if(!this.userRec.Opt_In__c){
            this.userRec.Lead_Opt_in_Terms__c=false;
        }*/
        
        if(this.aAlertEnabled){
        
            //add new code to update current user record
            Datetime dt = System.now();
            String dtStr = dt.format('yyyy-MM-dd');
            dtStr+=' 10:00:00';
             
            //Get the 10am for the logged in user
            Datetime dtGmt = Datetime.valueOf(dtStr); 
             
            //The next line will print "10"
            System.debug('>>>>>>>>>>>>>dtGmt.hour()'+dtGmt.hour());
             
            // The next line will print the GMT equivalent of 10
            System.debug('>>>>>>>>>>>>>dtGmt.hourGmt()'+dtGmt.hourGmt());
             
            //Update the custom field
            userRec.Action_Alert_Time__c= dtGmt.hourGmt();
                    
            //update user selected action alerts    
            upsertActionAlerts();
        }
         userRec.Action_Alert_Enabled__c=aAlertEnabled;
         if(smsAdrs!=System.Label.Second_Email){
            userRec.SMS_Address__c=this.smsAdrs;
            userRec.Is_Other_Email_Alert__c=inclSendEmail;
         }else{
            userRec.SMS_Address__c='';
            userRec.Is_Other_Email_Alert__c=false;
         }
        if(testMode==null || !testMode){
            update userRec;
        }
        ALMLogUtils.log(CLASSNAME,'Updated User sucessfully');
        isError =false;
        getRecords();
        ALMLogUtils.log(CLASSNAME,'After getRecords()');
        updateSuccess=true;
        //SA: check if OOO value was changed
       // hasOOOChanged = oooOriginalValue != userRec.Out_of_Office__c ? true : false;
      //  oooOriginalValue = userRec.Out_of_Office__c;            
        //SA: check for opt in change, if it is set to true and prior value was false
      //  hasOptInChanged = optInOriginalValue != userRec.Opt_In__c && userRec.Opt_In__c == true ? true : false;
      //  optInOriginalValue = userRec.Opt_In__c;
        return null;
    }
   
    private void upsertActionAlerts(){
        Map<String,Action_Alert__c> currAlerts = new Map<String,Action_Alert__c>();
        List<Action_Alert__c> toUpsert = new List<Action_Alert__c>(); 
        for(Action_Alert__c alert:[select Id,Type__c,Count__c,ALM_User__c from Action_Alert__c where ALM_User__c=:UserInfo.getUserId()]){
            currAlerts.put(alert.Type__c,alert);
        }
        Action_Alert__c tempAlert;
        String kpiName;
        for(Integer i=1;i<=3;i++){
            kpiName = (String)userRec.get('Action_Alert_'+i+'__c');
            if(kpiName!=null && kpiName!=''){
                tempAlert = currAlerts.get(kpiName);
                if(tempAlert!=null){
                    currAlerts.remove(kpiName);
                }else{
                    tempAlert = new Action_Alert__c(OwnerId=UserInfo.getUserId(),ALM_User__c=UserInfo.getUserId(),
                                                    Type__c=kpiName,Count__c=0,
                                                    Name=UserInfo.getName()+'-'+kpiName,
                                                    Action_Alert_Unique_Key__c=userRec.MRKT_ID_ACCT_NR_KEY__c+'-'+kpiName);
                }
                toUpsert.add(tempAlert);
            }
        }
        delete currAlerts.values();
        upsert toUpsert Id;
    }
    private Boolean validateActionAlertPrefs(){
        ALMLogUtils.log(CLASSNAME,'userRec.Action_Alert_Enabled__c='+userRec.Action_Alert_Enabled__c);
        ALMLogUtils.log(CLASSNAME,'userRec.SMS_Address__c='+userRec.SMS_Address__c);
        ALMLogUtils.log(CLASSNAME,'userRec.Action_Alert_1__c='+userRec.Action_Alert_1__c);
        ALMLogUtils.log(CLASSNAME,'userRec.Action_Alert_2__c='+userRec.Action_Alert_2__c);
        ALMLogUtils.log(CLASSNAME,'userRec.Action_Alert_3__c='+userRec.Action_Alert_3__c);
        if( (userRec.Action_Alert_1__c=='' || userRec.Action_Alert_1__c==null) && 
            (userRec.Action_Alert_2__c=='' || userRec.Action_Alert_2__c==null) && 
            (userRec.Action_Alert_3__c=='' || userRec.Action_Alert_3__c==null) && 
            this.aAlertEnabled)
        {
            ALMLogUtils.log(CLASSNAME,'No alerts have been selected. Atleast 1 is required to be selected !!!');
            actionAlertError=true;
            return false;
        }
        ALMLogUtils.log(CLASSNAME,'userRec.Action_Alert_Frequency__c='+userRec.Action_Alert_Frequency__c);
        if( (userRec.Action_Alert_Frequency__c==null || userRec.Action_Alert_Frequency__c=='') && 
            this.aAlertEnabled)
        {
            ALMLogUtils.log(CLASSNAME,'Need to specify a frequency for receiving action alerts');
            actionAlertError=true;
            return false;
        }
        //Apr-29-2011
        //Check that action alert can not be duplicate
        if(this.aAlertEnabled) {
            if((userRec.Action_Alert_1__c != null && userRec.Action_Alert_2__c != null) && (userRec.Action_Alert_1__c.equalsIgnoreCase(userRec.Action_Alert_2__c))) {
                ALMLogUtils.log(CLASSNAME,'Need to select different Action Alert[1, 2]!!!.');
                updateSuccess = false;
                bDuplicate = true;
                return false;               
            } else if((userRec.Action_Alert_1__c != null && userRec.Action_Alert_3__c != null) && (userRec.Action_Alert_1__c.equalsIgnoreCase(userRec.Action_Alert_3__c))) {
                ALMLogUtils.log(CLASSNAME,'Need to select different Action Alert[1, 3]!!!.');
                updateSuccess = false;
                bDuplicate = true;
                return false;               
            } else if((userRec.Action_Alert_2__c != null && userRec.Action_Alert_3__c != null) && (userRec.Action_Alert_2__c.equalsIgnoreCase(userRec.Action_Alert_3__c))) {
                ALMLogUtils.log(CLASSNAME,'Need to select different Action Alert[2, 3]!!!.');
                updateSuccess = false;
                bDuplicate = true;
                return false;               
            } else {
                //updateSuccess = true;
                bDuplicate = false;             
            }
        }
        //eoc Apr-29-2011
        return true;
    }
  
    private void getRecords(){
        String slsOrgLvl='';
        if(userProfile == 'Avon Leader'){  //CRF: use constant
            slsOrgLvl='N/A';
        }
        if(userProfile.contains(ALMPlusConstants.AVON_ZM_BASE)){  //CRF: use constant
            slsOrgLvl='Z';
        }
        /*if(userProfile == 'Avon Division Manager'){
            slsOrgLvl='D';
        }*/
      /* Not required for Phase-1 delivery -Snehashis
      
        if(userProfile == 'Avon Division Manager'){  //CRF: use constant
            allowedSlsOrgs = new Map<String,ObjectRow>();
            slsOrgs = new List<ObjectRow>();
            Boolean oddRow = false;
            ObjectRow row;
            /*
                Get all Zones for the Division that the Division
                Manager has on their user record
            */
            /*ObjectRow divRow;
            divRow = new ObjectRow(new Sales_Organization__c(SLS_ORG_LVL_CD__c='D',
                                                             SLS_ORG_CD__c=userRec.DFALT_DIV_NM__c),
                                       oddRow);
            if(userRec.DFALT_ZONE_CD__c=='All' ||userRec.DFALT_ZONE_CD__c == null){
                divRow.selected = true;             
            }else{
                divRow.selected = false;                
            }
            allowedSlsOrgs.put('All',divRow);
            */
            
        /*    System.debug('>>>>>>>>>>> userRec.DFALT_DIV_NM__c='+userRec.DFALT_DIV_NM__c);
            System.debug('>>>>>>>>>userRec.DFALT_ZONE_CD__c='+userRec.DFALT_ZONE_CD__c);
            for(Sales_Organization__c slsOrg: [     Select  SLS_ORG_LVL_CD__c, SLS_ZONE_CD__c,SLS_DIV_CD__c,
                                                            SLS_DIV_NM__c 
                                                    From    Sales_Organization__c
                                                    where   SLS_ORG_LVL_CD__c = 'Z'
                                                    and     SLS_DIV_NM__c = :userRec.DFALT_DIV_NM__c
                                                    and     Market__r.Market_Id__c=:this.userRec.MRKT_ID__c])
            {
                row = new ObjectRow(slsOrg,oddRow);
                System.debug('>>>>>>>>>slsOrg.SLS_ZONE_CD__c='+slsOrg.SLS_ZONE_CD__c);
                if( slsOrg.SLS_ZONE_CD__c == userRec.DFALT_ZONE_CD__c)
                {
                    row.selected=true;
                    this.selOrgCdId = slsOrg.SLS_ZONE_CD__c;
                }else{
                    row.selected=false;
                }
                oddRow = !oddRow;
                allowedSlsOrgs.put(slsOrg.SLS_ZONE_CD__c,row);
                slsOrgs.add(row);
            }
                        
        }
        
        if(userProfile == 'Avon Zone Manager'){  //CRF: use constant
            allowedSlsOrgs = new Map<String,ObjectRow>();
            slsOrgs = new List<ObjectRow>();
            Boolean oddRow = true;
            ObjectRow row;
            for(User_Sales_Org_Hierarchy__c slsOrg: [
                                                    Select  Id,SLS_ORG_LVL_CD__c, SLS_ORG_CD__c,
                                                            MRKT_ID_ACCT_NR_SLS_ORG_KEY__c, ACCT_NR__c 
                                                    From    User_Sales_Org_Hierarchy__c u
                                                    where   ACCT_NR__c = :userRec.ACCT_NR__c
                                                    and     SLS_ORG_LVL_CD__c = :slsOrgLvl
                                                    and     Market__r.Market_Id__c = :userRec.MRKT_ID__c])
            {
                row = new ObjectRow(slsOrg,oddRow);
                if( slsOrg.SLS_ORG_CD__c == userRec.DFALT_ZONE_CD__c)
                {
                    row.selected=true;
                    this.selOrgCdId = slsOrg.SLS_ORG_CD__c;
                }else{
                    row.selected=false;
                }
                oddRow = !oddRow;
                allowedSlsOrgs.put(slsOrg.SLS_ORG_CD__c,row);
                slsOrgs.add(row);
            }
            System.debug('allowed sales orgs:'+allowedSlsOrgs);
        }*/
    }

    public PageReference sendTestActionAlert(){
        actionAlertError=false;
        if(!validateActionAlertPrefs()){
            actionAlertError=true;
        }else{
            updatePreferences();
            Map<Id,List<String>> smsRecipients = new Map<Id,List<String>>();
            //smsRecipients.put(userRec.Id,new List<String>{userRec.GI3_Email__c,userRec.SMS_Address__c});
            EmailUtils.sendEmail(new User[]{this.userRec},smsRecipients,this.globalConfig.Action_Alert_Template_Id__c,null,null,true);
        }
        return null;
    } 
  /*  public Integer getSlsOrgSize(){
        if(this.allowedSlsOrgs != null){
            return this.slsOrgs.size();
        }else{
            return 0;
        }
    } */
    
    public String getOmniturePageName() {
        return ALMPlusUtils.generateOmniturePageName('UpdateUserPreference', null, userRec.Profile.Name);
    }   
    
    public static testmethod void testUpdatePrefController(){
        TestDataHelper testData = new TestDataHelper();
        String acctNbr = '123456';
        User ldrUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            ldrUsr = testData.createLeaderUser(acctNbr);
        }
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;
        
        // Added by Raktim on 28Dec, 2012 - Start
        testData.market.OwnerId = ldrUsr.Id;
       
        System.runAs ( thisUser ) {
            update testData.market;
        }
        // Added by Raktim on 28Dec, 2012 - End
        
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
      ctlr.testMode =true; 
        System.runAs(ldrUsr){
        ctlr.init();
          ctlr.userRec.LanguageLocaleKey='fr';
          ctlr.updatePreferences();
          System.assert(ctlr.isError==true);
        }
        
    } 
    
   /* public static testmethod void testUpdatePrefController(){
        TestDataHelper testData = new TestDataHelper();
        testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr = testData.createZoneUser(acctNbr);
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;
        update testData.market;
        List<User_Sales_Org_Hierarchy__c> usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'XZ1','Z');
        testData.createUsrSlsOrgHrchy(usr,'XZ2','Z');
        List<Sales_Organization__c> slsOrgs = testData.createSalesOrgs();
        
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        System.runAs(usr){
            System.assert(ctlr.getSlsOrgSize()==0);
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==2);
            System.debug('>>>>>>>>>>> SALES ORG DATA ZONE:'+ctlr.allowedSlsOrgs);
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.userRec.LanguageLocaleKey='en_US';
            ctlr.userRec.UserPermissionsMobileUser=true;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==false);
            ctlr.userRec.LanguageLocaleKey='fr';
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==true);
        }
    }

    
    public static testmethod void test2SalesLeader(){
        TestDataHelper testData = new TestDataHelper();
        testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr = testData.createZoneUser(acctNbr);
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;
        update testData.market;
        List<User_Sales_Org_Hierarchy__c> usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'XZ1','Z');
        testData.createUsrSlsOrgHrchy(usr,'XZ2','Z');
        List<Sales_Organization__c> slsOrgs = testData.createSalesOrgs();
        
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        System.runAs(usr){
            System.assert(ctlr.getSlsOrgSize()==0);
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==2);
            System.debug('>>>>>>>>>>> SALES ORG DATA ZONE:'+ctlr.allowedSlsOrgs);
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==false);
            ctlr.userRec.LanguageLocaleKey='fr';
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==true);
        }
        System.runAs(mktAdmin){
            List<Task> mobileTask = [select Id,Subject from Task where OwnerId=:mktAdmin.Id];
            //System.debug('>>>>>>>>>>>>>> TOTAL TASKS RETURNED: '+mobileTask);
            //system.assert(mobileTask.size()==1);
        }
        usr = testData.createDivUser('D'+acctNbr);
        usr.DFALT_ZONE_CD__c ='All';
        update usr;
        //usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'D1','D');
        ctlr = new UpdateUserPrefController();
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==1);
            System.assert(ctlr.getSlsOrgSize()==1);
            ctlr.selOrgCdId = 'All';
            ctlr.updatePreferences();
            User tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c==null);  
            ctlr.selOrgCdId =   'XZ1';
            ctlr.updatePreferences();
            tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c=='XZ1'); 
        }

        ctlr = new UpdateUserPrefController();
        usr = testData.createLeaderUser('L'+acctNbr);
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs()==null);
        }
        
    }
    
    public static testmethod void testZoneManager(){
        TestDataHelper testData = new TestDataHelper();
        testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr = testData.createZoneUser(acctNbr);
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;

        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        
        update testData.market;
        List<User_Sales_Org_Hierarchy__c> usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'XZ1','Z');
        testData.createUsrSlsOrgHrchy(usr,'XZ2','Z');
        List<Sales_Organization__c> slsOrgs = testData.createSalesOrgs();
        
        usr = testData.createDivUser('D'+acctNbr);
        usr.DFALT_ZONE_CD__c ='All';
        update usr;
        //usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'D1','D');
        ctlr = new UpdateUserPrefController();
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==1);
            System.assert(ctlr.getSlsOrgSize()==1);
            ctlr.selOrgCdId = 'All';
            ctlr.updatePreferences();
            User tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c==null);  
            ctlr.selOrgCdId =   'XZ1';
            ctlr.updatePreferences();
            tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c=='XZ1'); 
        }

        ctlr = new UpdateUserPrefController();
        usr = testData.createLeaderUser('L'+acctNbr);
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs()==null);
        }
        
    }*/
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testActionAlerts(){
        TestDataHelper testData = new TestDataHelper();
        //testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            usr = testData.createLeaderUser(acctNbr);
        }
      /*usr.ZM_Override__c=true;
        usr.Opt_In__c=false;
        usr.Out_of_Office__c=false;
        usr.Lead_Opt_in_Terms__c=false;
        usr.CDW_Eligible__c=true;
        usr.LDRSHP_TITL_LVL_NBR__c='1';
        usr.SFDC_Ineligibility_Codes__c='';//
        usr.isActive=true;
        update usr;
        testData.market.Action_Alert_Enabled__c=true;
        testData.market.Action_Alerts__c='Orders Not submitted;Title Lost;';
        //testData.market.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        //testData.market.Eligibility_Yes_Flags__c='Opt_In__c';
        //testData.market.Title_Exclusion__c='0;-2';
        //testData.market.LeadMandatoryFields__c = 'User_Type__c,FirstName,LastName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c, Geo_Level_4__c, MobilePhone,PostalCode';
        
        // Added by Raktim on 28Dec, 2012 - Start
        testData.market.OwnerId = usr.Id;
        update testData.market;
        // Added by Raktim on 28Dec, 2012 - End
        
        //Create Ineligibility Reason Code
       /* List<Ineligibility_Reason__c> testRnLst= new List<Ineligibility_Reason__c>();
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='OOO',Ineligibility_Reason__c='Out Of Office',Market__c=testData.market.id,Order__c=1));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='ZMO',Ineligibility_Reason__c='Zone Manager Override',Market__c=testData.market.id,Order__c=2));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='SO',Ineligibility_Reason__c='System Override',Market__c=testData.market.id,Order__c=3));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='OI',Ineligibility_Reason__c='Opt In',Market__c=testData.market.id,Order__c=4));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='SFA',Ineligibility_Reason__c='Salesforce Active',Market__c=testData.market.id,Order__c=5));
        insert testRnLst;//
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        System.runAs(usr){
            ctlr.init();
           /* System.assert(usr.Is_Eligible__c==false);
            System.assert(ctlr.getOOOMsg().size()==2);
            System.assert(ctlr.getOIMsg().size()==2);
            System.assert(ctlr.getOOOMsg().size()==2);//
            System.assert(ctlr.getAllowedActionAlerts().size()==3);
            System.assert(ctlr.getAllowedFrequencies().size()==10);
            ctlr.userRec.LanguageLocaleKey='en_US';
           // ctlr.userRec.Action_Alert_Enabled__c=true;
            ctlr.aAlertEnabled=true;
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==true);
            ctlr.userRec.Action_Alert_1__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_Frequency__c=null;
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==true);
            ctlr.userRec.Action_Alert_1__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_Frequency__c='Daily';
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==false);
            List<Action_Alert__c> usrAlerts = [select Id from Action_Alert__c where OwnerId=:usr.Id];
            System.assert(usrAlerts.size()==1);
            ctlr.userRec.Action_Alert_1__c='Rising Stars';
            ctlr.userRec.Action_Alert_2__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_3__c='Title Lost';
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==false);
            usrAlerts = [select Id from Action_Alert__c where OwnerId=:usr.Id];
            System.assert(usrAlerts.size()==3);
            ctlr.sendTestActionAlert();
            System.assert(ctlr.actionAlertError==false);
           // ctlr.userRec.SMS_Address__c='test@avon.com';
           System.debug('My test User >>>'+ctlr.userRec);
            ctlr.userRec.Action_Alert_1__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_2__c='Orders Not submitted';
            ctlr.updatePreferences();
            System.assert(ctlr.bDuplicate==true);
            //Snehashis added for ALM+
           /* ctlr.userRec.Opt_In__c=true;
            ctlr.userRec.Lead_Opt_in_Terms__c=false;
            ctlr.updatePreferences();
            System.assert(ctlr.isLeadOptinError==true);
            System.assert(ctlr.userRec.Out_of_Office__c==false);//
        }
    } */
    
}