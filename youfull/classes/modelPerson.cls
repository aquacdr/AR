/*******************************************************************************
 Name          : modelPerson 
 Description   : An abstract class modelling person in organization.
 Created By    : Parul Gupta 
 Created Date  : 4 Feb, 2014               
*******************************************************************************/
public abstract class modelPerson {
	
	//========================================================================//
  	// Method returns current campaign
  	//========================================================================//
	Public abstract String getCurrentCampaign();
	
	//========================================================================//
  	// Method returns previous campaign
  	//========================================================================//
	Public abstract String getPreviousCampaign();
	
	//========================================================================//
  	// Method returns mail plan
  	//========================================================================//
	Public abstract MailPlan_Order_Oppty__c getMailPlan();
	
	//========================================================================//
  	// Method returns market information
  	//========================================================================//
	Public Market__c getMarketInformation(String marketId){		
		Market__c market = [SELECT Id, Market_Id__c, 
							CMPGN_NR__c, PREV_1_CMPGN_NR__c, 
							NEXT_1_CMPGN_NR__c 
                       		FROM Market__c 
                       		WHERE Market_Id__c = :marketId];
		return market;		
	}
	
	//========================================================================//
  	// Method returns person information
  	//========================================================================//
	Public User getPersonInformation(){
		User person = [SELECT Id, Profile.Name, MRKT_ID__c, 
							DFALT_DIV_NM__c, DFALT_ZONE_CD__c,
							ACCT_NR__c, LanguageLocaleKey,
							UserRole.Name
                       		FROM User 
                       		WHERE Id = :UserInfo.getUserId() 
                       		LIMIT 1];              		
		return person;		
	}
	

}