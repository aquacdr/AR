public without sharing class ZM_Controller_LegalNotice {
	
	User u;
	
	public ZM_Controller_LegalNotice(){
		
		u = [Select Profile.Name from User where Id=:UserInfo.getUserId()];
	}
	
	public PageReference setUserViewedMessage()
	{
		updateLegalMessage(UserInfo.getUserId());
		
		return new PageReference(URL.getSalesforceBaseUrl().toExternalForm());
	}
	
	public PageReference returnToHomePage()
	{
		u = [Select Has_Seen_Legal_Message__c from User where Id=:UserInfo.getUserId()];
		
		if(u.Has_Seen_Legal_Message__c)
		   return new PageReference(URL.getSalesforceBaseUrl().toExternalForm());
		else
		   return null;
	}
	
	// New Method - Omniture Addition
    public String getOmniturePageName()      
    {  
        return ALMPlusUtils.generateOmniturePageName('ZM_LegalNotice', null, u.Profile.Name);         
    } //this is for getting page name mapping for omniture
	
	public static void updateLegalMessage(String userId)
	{
		System.debug(':::::::UPDATE USER:::::::::');
		User u = [Select Has_Seen_Legal_Message__c from User where Id=:userId];
		u.Has_Seen_Legal_Message__c = true;
		update u;
		System.debug(':::::::UPDATED:::::::::');
	}
	
	@isTest
	static void testThisClass()
	{
		ZM_Controller_LegalNotice ctl = new ZM_Controller_LegalNotice();
		ctl.returnToHomePage();
		ctl.setUserViewedMessage();
		ctl.returnToHomePage();
		
	}

}