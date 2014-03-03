/***************************************************************************
 Name         : Test_EarningCalController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for EarningCalController
 Created Date : Oct. 25, 2013                
****************************************************************************/

@isTest
private class Test_EarningCalController {  

    //----------------------------------------------------------------------------
    // Method Name  : testEarningCalController
    // Description  : Method for Test Coverage of Class : EarningCalController
    //----------------------------------------------------------------------------  
    public static testmethod void testEarningCalController() {
        String mktIdKey = 'TESTEARN1234';
        Market__c mrkt;
        
        //Create and Insert Object : User
        User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true); 
        
        System.runAs(testUsr) {
            //Create and Insert Object : Market
            mrkt = TestDataHelper.createMarket(mktIdKey, false);
            mrkt.OwnerId = testUsr.Id;
            mrkt.EARN_ILLT_VIDEO_LNK_TYP__c = 'Link';
            insert mrkt;
        }
        
        //Create and Insert Object : eTools_Widget__c
        eTools_Widget__c eTools = TestDataHelper.createEToolsWidget(String.valueOf(mrkt.Id), mrkt.EARN_ILLT_VIDEO_LNK_TYP__c, true);
        
        List <Leader_Title__c> leaderTitleList = TestDataHelper.createLeaderTitlesList(mrkt.Id, mrkt.Market_Id__c, true);
        
        EarningCalController ctlr;
        
        System.runAs(testUsr) {
            ctlr = new EarningCalController();
            
            //eTools_Widget__c data is available
            ctlr.loadData();
            System.assertEquals(ctlr.lst_EstimtdErngLevel.size(), 9);
            System.assert(EarningCalController.mapEstimtdErng == null);
            
            EarningCalController.getData(0);
            EarningCalController.getPicture(0, false);
            System.assertEquals(ctlr.lst_EstimtdErngLevel.size(), 9);
            System.assertEquals(EarningCalController.mapEstimtdErng.size(), 9);
            
            EarningCalController.getData(1);
            EarningCalController.getPicture(1, false);
            System.assertEquals(ctlr.lst_EstimtdErngLevel.size(), 9);
            System.assertEquals(EarningCalController.mapEstimtdErng.size(), 9);
            
            EarningCalController.getData(4);
            EarningCalController.getPicture(4, false);
            System.assertEquals(ctlr.lst_EstimtdErngLevel.size(), 9);
            System.assertEquals(EarningCalController.mapEstimtdErng.size(), 9);
                        
            EarningCalController.getData(10);
            EarningCalController.getPicture(10, false);
        }   
        
        PageReference pageRef = Page.EarningCalculatorPage;
        pageRef.getParameters().put('repDetailAcctNbr', mktIdKey); 
        Test.setCurrentPage(pageRef);  
        
        System.runAs(testUsr) {
            ctlr = new EarningCalController();
            ctlr.loadData();
            
            ctlr.getOmniturePageName();
            ctlr.callRepDetails();       
        }
    }
}