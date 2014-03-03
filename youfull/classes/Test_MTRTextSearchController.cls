/***************************************************************************
 Name         : Test_MTRTextSearchController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for MTRTextSearchController
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_MTRTextSearchController {

    //---------------------------------------------------------------------------
    // Method Name  : testMTRTextSearchController
    // Description  : Method for Test Coverage of controller MTRTextSearchController
    //---------------------------------------------------------------------------
    static testMethod void testMTRTextSearchController () {
        MTRTextSearchController cont = new MTRTextSearchController();
       
        Market__c mkt = TestDataHelper.createMarket('99', true);  
        Branch_Summary__c branch = new Branch_Summary__c(CMPGN_NR__c=201306, 
                    ACCT_NR__c='1234567890', MRKT_ID__c=mkt.Market_Id__c, BRNCH_SCTN_CD__c='test',
                    Branch_Summary_Key__c = '992013061234567890');
        insert branch;
        
        cont.AccountNum = '1234567890';
        cont.InternalCampaignId= '201306';
        cont.MarketId = mkt.Market_Id__c;
        cont.GetBranches(201306);
        cont.RefreshBranches();
        cont.InternalCampaignId= 'CMPGN201305_201306';
        cont.RefreshBranches();
        cont.BranchSearchCampaignId = '201306';
        cont.RefreshBranches();
        cont.BranchSearchCampaignId= 'CMPGN201305_201306';
        cont.RefreshBranches();
    }
}