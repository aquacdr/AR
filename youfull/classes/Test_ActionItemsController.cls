/***************************************************************************
 Name          : Test_ActionItemsController 
 Modified By   : Parul Gupta (JDC)
 Description   : Test class for ActionItemsController
 Modified Date : Oct 29, 2013                
****************************************************************************/
@isTest
public class Test_ActionItemsController {
  
    public static String mktIdKey = 'XX';
    
    //---------------------------------------------------------------------------
    // Method Name  : testActionItems
    // Description  : Method for Test Coverage for ActionItemsController
    //---------------------------------------------------------------------------
    static testMethod void testActionItems(){
    
        // Create Basic test data
        User ldrUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true); 
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);     
        Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
        Contact ldrContact = TestDataHelper.createContact(mktIdKey, account.Id, true);        
        Market__c market = TestDataHelper.createMarket(mktIdKey, true);
        
        // Creating Market Action Items        
        List <Action_Items__c> actItems = TestDataHelper.createActionItems(true);
        List<Market_Action_Items__c> testItmLst = TestDataHelper.createMarketActionItems(market.id, actItems, true);
        
        // Create market key list     
        List<String> mktKeyLst = new List<String>();
        mktKeyLst.add(market.Market_Id__c + market.CMPGN_NR__c + ldrUsr.ACCT_NR__c);
        mktKeyLst.add(market.Market_Id__c + market.NEXT_1_CMPGN_NR__c + ldrUsr.ACCT_NR__c);
        
        // Create ALM_Rep_Indicator__c records
        TestDataHelper.createMulRepPerformance(mktKeyLst, market.Market_Id__c, ldrUsr.Id, 
                                                market, ldrContact.id, true);
        
        
        List<ALM_Rep_Performance_1__c> ppList = [SELECT Id, MailPlan_Order_Oppty__c,AVG_GENRTN_3_UNIT_COMM_PCT__c, 
                                                AVG_GENRTN_3_DISTR_SLS_PCT__c, 
                                                AVG_GENRTN_2_UNIT_COMM_PCT__c,OPERTNL_CMPGN_NR__c,
                                                FLD_SLS_CMPGN_NR__c 
                                                FROM ALM_Rep_Performance_1__c
                                                WHERE ACCT_NR__c =:ldrUsr.ACCT_NR__c];
        
        List<Market_Action_Items__c> mktActItems2 = [Select  Action_Item__r.Zone_Or_Leader__c, Threshold__c, Filter_Param__c,
                        Action_Item__r.Smry_Criteria_Fld__c, Report__r.Report_Id__c,Report__r.Report_Type__c, Report__r.Report_URL__c,
                        Action_Item__r.Order_Criteria_Fld__c,Action_Item__r.Rep_Criteria_Fld__c,
                        Action_Item__r.Genealogy_Criteria_Fld__c,Action_Item__r.Default__c,
                        Priority__c, Market__c, Campaign_Stage__c,
                        Action_Item__r.Action_Item_Type__c,Action_Item__r.Category__c,
                        Action_Item__r.Subject_Area__c,Action_Item__r.Datatype__c,Campaign__c,Default__c  
                        From   Market_Action_Items__c
                        where Market__c=:market.Id
                        and  Action_Item__r.Zone_Or_Leader__c = 'Leader'
                        order by Action_Item__r.Subject_Area__c,Priority__c asc];
        
        //Test case for markets do not have Mailplan
        System.runAs(ldrUsr){
            ActionItemsController objController = new ActionItemsController();
            objController.mkt_actionitem=mktActItems2;
            objController.combObjLst=ppList;
            objController.itemsToDisplay=2;
            objController.userProfile=null;
            objController.isSideBar='1';
            objController.getInitialize(); 
            objController.isSideBar='4'; 
            objController.getInitialize();
            objController.getcoachActionItems();
            objController.getmngNbrActionItems();
            objController.getmngPrsRepActionItems();
            System.assert(objController.mkt_actionitem.size() == 8);
        }
        
        //Test case for markets enables Mailplan
        market.Mail_Plan_Enabled__c=true;
        update market;
       
        // Create MailPlan_Order_Oppty__c records
        List<MailPlan_Order_Oppty__c> mplst = new List<MailPlan_Order_Oppty__c>();
        Date currDate = System.today().addDays(1);
        Date nextCDate= currDate.addDays(10);
        MailPlan_Order_Oppty__c mplan;
        for (Integer i=0;i<5;i++) {
            mplan = TestDataHelper.createMPOrderOpp(market.Id, '4', 'N', currDate.addDays(1+10), 
                                                    'M'+(i+1), 'XZ1', 'M'+i, false);            
            mplst.add(mplan);           
            mplan = TestDataHelper.createMPOrderOpp(market.Id, '4', 'N', nextCDate.addDays(1+10), 
                                                    'M'+(i+1), 'XZ1', 'M'+i, false);
            mplst.add(mplan);  
        }
        insert mplst;
        
        List<MailPlan_Order_Oppty__c> tmpMp=new List<MailPlan_Order_Oppty__c>();
        for(MailPlan_Order_Oppty__c mp:mplst){
            for(ALM_Rep_Performance_1__c ar:ppList){
                if(ar.OPERTNL_CMPGN_NR__c.contains(mp.CMPGN_NR__c)){
                    ar.MailPlan_Order_Oppty__c=mp.Id;
                    tmpMp.add(mp);
                }
            }                           
        }
        update ppList;
        
        //Testing for Current Campaign Scenarios
        System.runAs(ldrUsr){
            ActionItemsController objController = new ActionItemsController();
            objController.mkt_actionitem=mktActItems2;
            objController.cmpTxt='Current';
            objController.combObjLst=ppList;
            objController.market=market;
            objController.itemsToDisplay=2;
            objController.isSideBar='1';
            objController.getInitialize();  
            objController.getcoachActionItems();
            objController.getmngNbrActionItems();
            objController.getmngPrsRepActionItems();
            system.debug('objController.mkt_actionitem.size()2'+objController.mkt_actionitem.size());
            System.assert(objController.mkt_actionitem.size() == 8);
        }
        
        //Testing for Next Campaign Scenarios
        System.runAs(ldrUsr){
            ActionItemsController objController = new ActionItemsController();
            objController.mkt_actionitem=mktActItems2;
            objController.cmpTxt='Next';
            objController.combObjLst=ppList;
            objController.market=market;
            objController.itemsToDisplay=2;
            objController.isSideBar='1';
            objController.getInitialize();  
            objController.getcoachNCActionItems();
            objController.getmngNbrNCActionItems();
            objController.getmngPrsRepNCActionItems();
            system.debug('objController.mkt_actionitem.size()3'+objController.mkt_actionitem.size());
            System.assert(objController.mkt_actionitem.size() == 8);
        }
       
    }

}