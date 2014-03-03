/*******************************************************************************
 Name          : modelZoneManager 
 Description   : Modelling Zone Manager
 Created By    : Parul Gupta 
 Created Date  : 4 Feb, 2014               
*******************************************************************************/
public with sharing class modelZoneManager extends modelPerson{
	
	public Market__c market {get;set;} 
	
	//========================================================================//
  	// Method returns current campaign
  	//========================================================================//
	Public override String getCurrentCampaign(){
		return market.CMPGN_NR__c;
	}
	
	//========================================================================//
  	// Method returns previous campaign
  	//========================================================================//
	Public override String getPreviousCampaign(){
		return market.PREV_1_CMPGN_NR__c;
	}
	
	//========================================================================//
  	// Method returns mail plan
  	//========================================================================//
	Public override MailPlan_Order_Oppty__c getMailPlan(){
		MailPlan_Order_Oppty__c mailPlan;
		return mailPlan;
	}
}