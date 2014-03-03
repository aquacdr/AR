/***************************************************************************
 Name          : Controller_SLCampaignSelector
 Description   : Controller class for CampaignSelector component
 Created By    : Barkha Jain 
 Created Date  : Jan 6, 2014                
****************************************************************************/
public with sharing class Controller_SLCampaignSelector{
    //properties
    public Market__c market {get; set;}     
    
    public String selectedCampaign {get{
        if(selectedCampaign == null){
            selectedCampaign = market.CMPGN_NR__c;
        }
        return selectedCampaign;
    } set;} 
    
    //constructor
    public Controller_SLCampaignSelector(){
        User currentUser = [SELECT Id, MRKT_ID__c from User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        market = [SELECT PREV_1_CMPGN_NR__c, CMPGN_NR__c, NEXT_1_CMPGN_NR__c
                        FROM Market__c 
                        WHERE Market_Id__c = :currentUser.MRKT_ID__c]; 
    }

}