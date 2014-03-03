/***************************************************************************
 Name          : ALM_Controller_LegalStatement
 Created By    : Barkha Jain
 Description   : Controller for ALM_LegalStatement 
 Created Date  : Feb 13, 2014                
****************************************************************************/
public with sharing class ALM_Controller_LegalStatement {
	//variables
	private static User u;
	
	//constructor
	public ALM_Controller_LegalStatement(){		
		u = [Select Profile.Name, Has_Seen_Legal_Message__c from User where Id = :UserInfo.getUserId()];
	}
	
	public PageReference setUserViewedMessage(){
		u.Has_Seen_Legal_Message__c = true;
		update u;		
		return new PageReference(URL.getSalesforceBaseUrl().toExternalForm());
	}
	
	public PageReference returnToHomePage(){
		if(u.Has_Seen_Legal_Message__c)
		   return new PageReference(URL.getSalesforceBaseUrl().toExternalForm());
		else
		   return null;
	}	
	
	// New Method - Omniture Addition
    public String getOmniturePageName(){  
        return ALMPlusUtils.generateOmniturePageName('ALM_LegalStatement', null, u.Profile.Name);         
    } //this is for getting page name mapping for omniture
}