public with sharing class Controller_SLCoachingRecordHome {
    public Boolean showTabs{get;set;}
    public Controller_SLCoachingRecordHome (ApexPages.StandardController controller){
        showTabs=false;
        User currLogUser=[Select id,Profile.Name,MRKT_ID__c,DFALT_ZONE_CD__c,DFALT_DIV_NM__c,ACCT_NR__c from User 
        where id=:Userinfo.GetUserId()];
        Integer campaignNr = 201403;  // YOUUtil.getCurrentCampaignNumber(currLogUser.MRKT_ID__c);
        String campaign = String.valueOf(campaignNr);
        Contact con = [SELECT Id, Name, ACCT_NR__c, SLS_ZONE_CD__c FROM Contact where Id = :controller.getId()];
        showTabs = true;
        /* LandingPageUtils.isImpersonationValid(currLogUser.Profile.Name, 
                                        currLogUser.MRKT_ID__c, currLogUser.DFALT_ZONE_CD__c, 
                                        currLogUser.DFALT_DIV_NM__c, currLogUser.ACCT_NR__c, 
                                        campaign, con.ACCT_NR__c);
                                        */
    }
}