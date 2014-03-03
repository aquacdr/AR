public with sharing class ZM_HomepageQuicklinksCtl {
    public User currentUser{get;set;}
    public boolean hasSeenLegalMessage{get;set;}
    public Market__c market{get;set;}
  
  // Mail Plan addition - by Raktim
  public Boolean isMailPlan = false;
  public String sellingCampaign = '';
    
    public ZM_HomepageQuicklinksCtl()
    {
        
        currentUser = [Select Id, User.LanguageLocaleKey,DFALT_DIV_NM__c,DFALT_ZONE_CD__c,MRKT_ID_ACCT_NR_KEY__c, MRKT_ID__c, Profile.Name, Has_Seen_Legal_Message__c from User where Id = :UserInfo.getUserId()];
        hasSeenLegalMessage = currentUser.Has_Seen_Legal_Message__c;
        
        /*if((currentUser.Profile.Name.containsIgnoreCase(ALMConstants.ZONE)) || (currentUser.Profile.Name.containsIgnoreCase(ALMConstants.DIVISION)))
        {*/
            market = lookupMarket();
            isMailPlan = (market.Mail_Plan_Enabled__c?true : false);
            if( isMailPlan ){
                //Added by Milon on 7/9/2013
                if (currentUser.Profile.Name.contains('Division')){
                    sellingCampaign = market.NEXT_1_CMPGN_NR__c;
                    System.debug('Division selling Campaign :'+sellingCampaign);
                }else{
                    ZM_UtilityClass z = new ZM_UtilityClass();
                    String zones = z.getZones(market.Id);
                    //sellingCampaign =   MailPlanUtils.getMailPlanCampaignZMDM(currentUser.DFALT_ZONE_CD__c, market.Market_Id__c);
                    try{
                        sellingCampaign =   MailPlanUtils.getMailPlanCampaignZMDM(zones, market.Market_Id__c);
                    }catch(Exception e){
                        System.debug('\n Caught Exception in ZM_HomepageQuickLinks for Mail Plan '+e.getMessage());
                        sellingCampaign = market.CMPGN_NR__c;
                    }
                }
            }
        //}
    }

    public Market__c lookupMarket()
    {
        // 'Mgr_Omniture_Suite_Name__c' field included in SOQL - by Raktim on 8th Oct 2013
        for (Market__c market : [SELECT Id, Market_Id__c, PREV_1_CMPGN_NR__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c,
                                    Security_and_Privacy_URL__c, Conditions_Of_Use_URL__c, Mail_Plan_Enabled__c,Omniture_Suite_Name__c,
                                    Mgr_Omniture_Suite_Name__c FROM Market__c  
                                    where Market_Id__c = :currentUser.MRKT_ID__c]) {
            return market;
        }           
        return new Market__c();
    }
    
  // Method modified - Mail Plan by Raktim on 28thJun 2013  
    public string getDefaultCampaignId()
    {
        String campaign;
        
    if( !isMailPlan ) // For Non Mail Plan Market
        campaign = String.isNotBlank(market.CMPGN_NR__c) ? market.CMPGN_NR__c : '';
    else{  // // For Mail Plan Market
        if(currentUser.Profile.Name.contains(ALMConstants.ZONE))
            //campaign = MailPlanUtils.getMailPlanCampaignZMDM(currentUser.DFALT_ZONE_CD__c, market.Market_Id__c);
            campaign = sellingCampaign;
        else if(currentUser.Profile.Name.contains(ALMConstants.DIVISION))
            //Changed by Milon
            campaign = this.market.CMPGN_NR__c;
            //campaign = String.isNotBlank(market.CMPGN_NR__c) ? market.CMPGN_NR__c : '';
    }
    System.debug('\n ### campaign for ZM_DM ====== : '+campaign);
    
    return campaign;
    }
    
    public string getDefaultZone(Boolean multiZone)
    {
        if(!multiZone)
            return currentUser.DFALT_ZONE_CD__c; 
        else
        {
            String zones = '';
            ZM_UtilityClass z = new ZM_UtilityClass();
            z.SetVariable();
            Integer cnt = 0;
            for(SelectOption s : z.getZoneList())
            {
                if(cnt > 0)
                   zones += ','+s.getValue();
                else
                  zones = s.getValue();
                  
                cnt ++;
            }
            
            return zones;
        }
    }
    
    public list<ZM_Report_Translation__c> getReportLinks()
    {
        string DefaultCampaignId = getDefaultCampaignId();
        string DefaultZone = getDefaultZone(false);
        
    String mp;
    mp=(isMailPlan?'Y':'N'); 
    System.debug('\n ######### DefaultCampaignId '+DefaultCampaignId+', selling campaign '+sellingCampaign+', mp :: '+mp);
        list<ZM_Report_Translation__c> reports = new list<ZM_Report_Translation__c>();
        for(ZM_Report_Translation__c z : [Select z.Name
                                               , z.Sort_Order__c
                                               , z.Report_URL__c
                                               , z.Report_Label__c
                                               , z.Report_Id__c
                                               , z.Market_Id__c
                                               , z.Language_Code__c
                                               , z.Id
                                               , z.Application_Context__c 
                                               , z.Report_Role__c
                                               , Multi_zone__c
                                            From ZM_Report_Translation__c z
                                           where Language_Code__c = :currentUser.LanguageLocaleKey
                                            and Market_Id__c includes(:currentUser.MRKT_ID__c)
                                            and Application_Context__c includes ('Quick Links') 
                        and Is_Mail_Plan_Specific__c IN (null,:mp) 
                                           order by sort_order__c asc])
        {
            if(currentUser.Profile.Name == null || currentUser.Profile.Name.containsIgnoreCase(z.Report_Role__c)) 
            {
                if(!z.Report_URL__c.contains('?'))
                {
               if((z.Name.equals(ALMConstants.DM_ZONEPERF_REPORT_NAME) ||
                   z.Name.equals(ALMConstants.DM_ZONEPERF_REPORT_NAME_AT) ||  
                   z.Name.equals(ALMConstants.DM_ZONEPERF_REPORT_NAME_ACTVT_TRACKR))&& 
                  currentUser.Profile.Name.containsIgnoreCase(ALMConstants.DIVISION) &&
                  isMailPlan)        // This is only for 'My Zones Performance' / 'Campaign Performance' report of DM - Mail Plan
              {
                if(!DefaultCampaignId.equals(sellingCampaign))
                    z.Report_URL__c += '?pv0='+DefaultCampaignId+','+sellingCampaign+'&pv1='+getDefaultZone(z.Multi_zone__c);   
                else
                   z.Report_URL__c += '?pv0='+DefaultCampaignId+'&pv1='+getDefaultZone(z.Multi_zone__c);
             }
             else if(z.Report_Label__c.equals(ALMConstants.DM_ELIG_REPORT_NAME) &&
                currentUser.Profile.Name.containsIgnoreCase(ALMConstants.DIVISION)) {
                z.Report_URL__c += '';
             }
             else if(currentUser.Profile.Name.containsIgnoreCase(ALMConstants.Customer))
             {
                z.Report_URL__c += '';
             }
             else
                z.Report_URL__c += '?pv0='+DefaultCampaignId+'&pv1='+getDefaultZone(z.Multi_zone__c);
                
        }
                reports.add(z);
                System.debug('Report named: ' + z.Report_Label__c + ' was added.');
            }
        }
        System.debug('Reports added: '+ reports);
        return reports;
    }
    
    public static void fixReportUrls(String baseUrl)
    {
        //get the names of the reports
        //ZM_HomepageQuicklinksCtl.fixReportUrls(baseUrl)
        set<string> reportNames = new set<string>();
        for(ZM_Report_Translation__c z : [Select Name
                                            From ZM_Report_Translation__c])
        {
            reportNames.add(z.Name);
        }
        
        //pull together a map of correlating the names to the report Ids
        map<String, Id> nameIdMap = new map<String, Id>();
        for(Report r : [SELECT Id, Name FROM Report WHERE Name in : reportNames])
        {
          nameIdMap.put(r.Name, r.Id);
        }
        system.debug('::::> nameIdMap: '+nameIdMap);
          
        //create a list of report records with the updated URL
        list<ZM_Report_Translation__c> urlUpdateList = new list<ZM_Report_Translation__c>();
        for(ZM_Report_Translation__c z : [Select Name, Id, Report_URL__c
                                            From ZM_Report_Translation__c
                                           where name in :nameIdMap.keySet()
                                           ])
        {
            //z.Report_URL__c = baseUrl + '/apex/ZM_Report_Wrapper?reportid=' + nameIdMap.get(z.Name);
            z.Report_URL__c = baseUrl + '/' + nameIdMap.get(z.Name);
            z.Report_Id__c = nameIdMap.get(z.Name);
            system.debug('::::> nameIdMap.get: '+z.Report_URL__c);
            
            urlUpdateList.add(z);
        }
        //update the report Translation records
        if(urlUpdateList.size() > 0)
           Database.update( urlUpdateList, false);
    }
    
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*@isTest(SeeAllData=true)
    static void testThisClass()
    {
        
        TestDataHelper testData =   new TestDataHelper();
        
        String acctNbr = '123456';
        
        // Creates Market Data
        Market__c mkt = testData.createMarket();
        User zmUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            zmUsr = testData.createUser(acctNbr, 'XZ1', 'Avon Mkt 62 Zone Manager');
            
            mkt.OwnerId = zmUsr.Id;
            mkt.Mail_Plan_Enabled__c = true;
            update  mkt;
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
        z.Application_Context__c = 'Quick Links';
        z.Report_Role__c = 'Zone';
        z.Name = r.Name;
        
        insert z;
        
        System.runAs(zmUsr){
            ZM_HomepageQuicklinksCtl ctlr = new ZM_HomepageQuicklinksCtl();
            
            ctlr.getDefaultCampaignId();
            ctlr.getReportLinks();
            ctlr.getDefaultZone(true);
            
            ZM_HomepageQuicklinksCtl.fixReportUrls('https://cs11.salesforce.com');
            
            
        }
        
        System.runAs ( thisUser ) {
            mkt.Mail_Plan_Enabled__c = false;
            update  mkt;
        }
        
         System.runAs(zmUsr){
            ZM_HomepageQuicklinksCtl ctlr = new ZM_HomepageQuicklinksCtl();
            
            ctlr.getDefaultCampaignId();            
            
        }
        
    }*/

}