public without sharing class ZM_Report_RouterCtl {
	
	User currentUser;
	public string getDefaultZone()
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
  
  // Modified by Raktim on 28Jun 2013 - Mail Plan
	public pageReference routReport()
	{
		String DefaultCampaignId;
		currentUser = [Select Id, User.LanguageLocaleKey, DFALT_ZONE_CD__c, MRKT_ID__c, Profile.Name, Has_Seen_Legal_Message__c 
		                      from User 
		                     where Id = :UserInfo.getUserId()];
		                     
		// New field added for Mail Plan - raktim on 28Jun 2013                     
		for(Market__c	market : [SELECT Id, Market_Id__c, PREV_1_CMPGN_NR__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c, Mail_Plan_Enabled__c
	                                FROM Market__c 
	                                where Market_Id__c = :currentUser.MRKT_ID__c])
	    
	    //Modified by Raktim on 28Jun 2013 - Mail Plan                             
	    if( !market.Mail_Plan_Enabled__c )                            
			DefaultCampaignId = market.CMPGN_NR__c; 
		else{
			if(currentUser.Profile.Name.contains(ALMConstants.ZONE)){
				//DefaultCampaignId = MailPlanUtils.getMailPlanCampaignZMDM(currentUser.DFALT_ZONE_CD__c, market.Market_Id__c);
				ZM_UtilityClass z = new ZM_UtilityClass();
				String zones = z.getZones(market.id);
				try{
					DefaultCampaignId = MailPlanUtils.getMailPlanCampaignZMDM(zones, market.Market_Id__c);
				}catch(Exception e){
            		System.debug('\n Caught Exception in ZM_Report_Router for Mail Plan '+e.getMessage());
            		DefaultCampaignId = market.CMPGN_NR__c;
            	}
				
			}else if(currentUser.Profile.Name.contains(ALMConstants.DIVISION))
				DefaultCampaignId = market.CMPGN_NR__c; 
		}
    
		string reportName = ApexPages.currentPage().getParameters().get('reportname');
		System.debug('Report Name--'+reportname);
		reportName = reportName.replace('_',' ');	                   
		reportName = reportName.replace('+',' ');	  
		// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, reportName));
		//return null;               
		//reportName = reportName.replace('_',' ');	                   
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
										    //and Application_Context__c includes ('Quick Links')
										    and Name = :reportName])
		{
			if(currentUser.Profile.Name == null || currentUser.Profile.Name.containsIgnoreCase(z.Report_Role__c)) 
				return new PageReference(z.Report_URL__c+'?pv0='+DefaultCampaignId+'&pv1='+getDefaultZone());
		}
		
		return Page.ZM_ReportCenter;
	}
	
	// New Method - Omniture Addition
    public String getOmniturePageName()      
    {  
        return ALMPlusUtils.generateOmniturePageName('ZM_Report_Router', null, currentUser.Profile.Name);         
    } //this is for getting page name mapping for omniture
		
	@isTest(SeeAllData=true)
	static void testThisClass()
	{
		
	    Report r = [Select Name, Id from Report limit 1];
	    
	    
		ZM_Report_Translation__c z = new ZM_Report_Translation__c();
		z.Sort_Order__c = 1;
	    z.Report_URL__c = 'x';
	    z.Report_Label__c = r.Name.replace('_',' ').replace('+',' ');
	    z.Report_Id__c = r.Id;
	    z.Market_Id__c = '62';
	    z.Language_Code__c = 'en_US';
	    z.Application_Context__c = 'Quick Links';
	    z.Report_Role__c = 'System';
	    z.Name = r.Name.replace('_',' ').replace('+',' ');
	    
	    insert z;
		System.debug('zm report translation--'+z);
		User u = [Select Id, MRKT_ID__c,DFALT_DIV_NM__c from User where Id = :UserInfo.getUserId()];
		if(u.MRKT_ID__c == null) 
		{
			u.MRKT_ID__c = '62';
			u.LanguageLocaleKey = 'en_US';
		}
    	if(u.DFALT_DIV_NM__c == null) 
		{
			u.DFALT_DIV_NM__c = 'Metro Achievers';
		}
    	
		update u;
		PageReference pr = Page.ZM_Report_Router;
		pr.getParameters().put('reportname',z.Report_Label__c);
		Test.setCurrentPage(pr);
		ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
		h.routReport();
		
		pr.getParameters().put('reportname','testxtest');
		Test.setCurrentPage(pr);
		ZM_Report_RouterCtl h2 = new ZM_Report_RouterCtl();
		h2.routReport();
		
	}
	
	//@S-144891 : Commented by Blaine Rothrock on Nov 23
	/*@isTest(SeeAllData=true)
	static void testThisClassmp()
	{
		
	    Report r = [Select Name, Id from Report limit 1];
	    
		ZM_Report_Translation__c z = new ZM_Report_Translation__c();
		z.Sort_Order__c = 1;
	    z.Report_URL__c = 'x';
	    z.Report_Label__c = r.Name;
	    z.Report_Id__c = r.Id;
	    z.Market_Id__c = '62';
	    z.Language_Code__c = 'en_US';
	    z.Application_Context__c = 'Quick Links';
	    z.Report_Role__c = 'System';
	    z.Name = r.Name;
	    
	    insert z;

		User u = [Select Id, MRKT_ID__c,DFALT_DIV_NM__c from User where Id = :UserInfo.getUserId()];
		if(u.MRKT_ID__c == null) 
		{
			u.MRKT_ID__c = '62';
			u.LanguageLocaleKey = 'en_US';
		}
    	if(u.DFALT_DIV_NM__c == null) 
		{
			u.DFALT_DIV_NM__c = 'Metro Achievers';
		}
    	
    	TestDataHelper th=new TestDataHelper();
    	//create zone user
    	User runuser=th.createUser('1234','201','Avon Mkt 62 Zone Manager');
    	runuser.MRKT_ID__c='62';
    	update runuser;
    	
    	//create division user
    	User runuserdiv=th.createUser('12345','202','Avon Mkt 62 Division Manager');
    	runuserdiv.MRKT_ID__c='62';
    	update runuserdiv;
    	
    	Market__c testmarket=[select Id,Mail_Plan_Enabled__c from Market__c where Market_ID__c=:u.MRKT_ID__c];
        testmarket.Mail_Plan_Enabled__c=true;
        update testmarket;
		update u;
		System.RunAs(u){		
		PageReference pr = Page.ZM_Report_Router;
		pr.getParameters().put('reportname',z.Report_Label__c);
		Test.setCurrentPage(pr);
		ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
		h.routReport();
		
		pr.getParameters().put('reportname','testxtest');
		Test.setCurrentPage(pr);
		ZM_Report_RouterCtl h2 = new ZM_Report_RouterCtl();
		h2.routReport();
		}
		System.RunAs(runuser){
		PageReference pr = Page.ZM_Report_Router;
		pr.getParameters().put('reportname',z.Report_Label__c);
		Test.setCurrentPage(pr);
		ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
		h.routReport();	
		}
		
		System.RunAs(runuserdiv){
		PageReference pr = Page.ZM_Report_Router;
		pr.getParameters().put('reportname',z.Report_Label__c);
		Test.setCurrentPage(pr);
		ZM_Report_RouterCtl h = new ZM_Report_RouterCtl();
		h.routReport();
		h.getOmniturePageName();	
		}
		
	}*/
	
	

}