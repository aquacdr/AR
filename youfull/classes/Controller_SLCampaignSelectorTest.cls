/***************************************************************************
 Name         : Controller_SLCampaignSelectorTest
 Created By   : Barkha Jain 
 Description  : Test class for Controller_SLCampaignSelector
 Created Date : Jan 13, 2014                
****************************************************************************/
@isTest
private class Controller_SLCampaignSelectorTest{

    static testMethod void testCampaignSelector() {
        //creating test user
        User usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = 'XX';
        usr.MRKT_ID_ACCT_NR_KEY__c = 'XX' + '1234';
        insert usr;
        
        System.runAs(usr){
            Market__c mkt = TestDataHelper.createMarket('XX', true);
            
            Test.startTest();
            Controller_SLCampaignSelector ctrl = new Controller_SLCampaignSelector();
            //verify result
            system.assertEquals(mkt.CMPGN_NR__c, ctrl.selectedCampaign);
            Test.stopTest();
        }
    }
}