@isTest
public class ActionItemControllerTest {
  
    public static String mktIdKey = 'XX';
    
    static testMethod void testActionItems() 
    {
        TestDataHelper testData =   new TestDataHelper();
        // Creating user data
        User thisUser = [ select Id from User where Id <> :UserInfo.getUserId() and Profile.Name='System Administrator' and isActive=true limit 1];
        User uplineUser;
        User ldrUsr;
        //User downlineOneUser;
        System.runAs ( thisUser ) {
            ldrUsr =testData.createLeaderUser('XX');
            ldrUsr.MRKT_ID__c = 'XX';
            ldrUsr.IsActive = true;
            update ldrUsr;
        }
        // Creating Market Action Items
        testData.createActionItems();
        List<Market_Action_Items__c> testItmLst=testData.createMarketActionItems();
        testData.createContact(ldrUsr.ACCT_NR__c, ldrUsr.Id);
        List<String> mktKeyLst=new List<String>();
        mktKeyLst.add(testData.market.Market_Id__c + testData.market.CMPGN_NR__c + ldrUsr.ACCT_NR__c);
        mktKeyLst.add(testData.market.Market_Id__c + testData.market.NEXT_1_CMPGN_NR__c + ldrUsr.ACCT_NR__c);
        testData.createMulRepPerformance(mktKeyLst, testData.market.Market_Id__c, ldrUsr.Id);
        String uplineAcctNr=ldrUsr.ACCT_NR__c;
        //testData.createRepPerformance(new List<String> {testData.market.Market_Id__c + testData.market.NEXT_1_CMPGN_NR__c + ldrUsr.ACCT_NR__c}, testData.market.Market_Id__c, ldrUsr.Id);
        List<ALM_Rep_Performance_1__c> ppList = [SELECT Id, MailPlan_Order_Oppty__c,AVG_GENRTN_3_UNIT_COMM_PCT__c, AVG_GENRTN_3_DISTR_SLS_PCT__c, AVG_GENRTN_2_UNIT_COMM_PCT__c,OPERTNL_CMPGN_NR__c FROM ALM_Rep_Performance_1__c
                                                WHERE ACCT_NR__c =:uplineAcctNr];
        
        List<Market_Action_Items__c> mktActItems2 = [Select  Action_Item__r.Zone_Or_Leader__c, Threshold__c, Filter_Param__c,
                        Action_Item__r.Smry_Criteria_Fld__c, Report__r.Report_Id__c,Report__r.Report_Type__c, Report__r.Report_URL__c,
                        Action_Item__r.Order_Criteria_Fld__c,Action_Item__r.Rep_Criteria_Fld__c,
                        Action_Item__r.Genealogy_Criteria_Fld__c,Action_Item__r.Default__c,
                        Priority__c, Market__c, Campaign_Stage__c,
                        Action_Item__r.Action_Item_Type__c,Action_Item__r.Category__c,
                        Action_Item__r.Subject_Area__c,Action_Item__r.Datatype__c,Campaign__c,Default__c  
                    From   Market_Action_Items__c
                    where  Market__c=:testdata.market.Id
                    and    Action_Item__r.Zone_Or_Leader__c = 'Leader'
                    order by Action_Item__r.Subject_Area__c,Priority__c asc];
        
        System.debug('ppList is ->'+testData.actItems);
        System.debug('passing ppList is ->'+mktActItems2);
        //test case for markets do not have Mailplan
        System.runAs(ldrUsr)
        {
            ActionItemsController objController = new ActionItemsController();
            objController.mkt_actionitem=mktActItems2;
            objController.combObjLst=ppList;
            objController.itemsToDisplay=2;
            objController.userProfile=null;
            objController.isSideBar='1';
            objController.getInitialize();  
            objController.getcoachActionItems();
            objController.getmngNbrActionItems();
            objController.getmngPrsRepActionItems();
            system.debug('objController.mkt_actionitem.size()'+objController.mkt_actionitem.size());
            System.assert(objController.mkt_actionitem.size() == 8);
        }
        
        //test case for markets enables Mailplan
        testData.market.Mail_Plan_Enabled__c=true;
        update testData.market;
        List<MailPlan_Order_Oppty__c> mplst=testData.createMailPlans();
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
         System.runAs(ldrUsr)
        {
            ActionItemsController objController = new ActionItemsController();
            objController.mkt_actionitem=mktActItems2;
            objController.cmpTxt='Current';
            objController.combObjLst=ppList;
            objController.market=testData.market;
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
         System.runAs(ldrUsr)
        {
            ActionItemsController objController = new ActionItemsController();
            objController.mkt_actionitem=mktActItems2;
            objController.cmpTxt='Next';
            objController.combObjLst=ppList;
            objController.market=testData.market;
            objController.itemsToDisplay=2;
            objController.isSideBar='1';
            objController.getInitialize();  
            objController.getcoachNCActionItems();
            objController.getmngNbrNCActionItems();
            objController.getmngPrsRepNCActionItems();
            system.debug('objController.mkt_actionitem.size()3'+objController.mkt_actionitem.size());
            System.assert(objController.mkt_actionitem.size() == 8);
        }
        //Testing for No Campaign Scenarios
         /*PageReference pageRefnoc = Page.MyActionItems;
          Test.setCurrentPageReference(pageRefnoc);*/
         System.runAs(ldrUsr)
        {
            /*MyActionItemsController objController = new MyActionItemsController();
            objController.init();   
            System.assert(objController.mkt_action_item.size() == 8);
            ActionItemsController objController = new ActionItemsController();
            
            objController.mkt_actionitem = newlst;
            objController.combObj  = combobjRec;
            
            objController.getInitialize();  
            objController.getcoachActionItems();
            objController.getmngNbrActionItems();
            objController.getmngPrsRepActionItems();
            
            System.assert(objController.mkt_actionitem.size() == 15);*/
        }
        //****************
        
        // Creating user data
        /*User ldrUsr = testData.createLeaderUser(mktIdKey);
        ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
        ldrUsr.IsActive = true;
        update ldrUsr;
        
        // Updating market data
        mrkt.OwnerId = ldrUsr.Id;
        mrkt.Is_ALMPLUS_Enabled__c = true;
        mrkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        update  mrkt;
        
        // Creating Account data
         Account testAcct = new Account(Name='Test Acount');
         insert testAcct;
        
        // Creating Contact data
        List<Contact> lstContact = new List<Contact>();
        Contact con1    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey,
                                            Email='test1@avon.com',FirstName=mktIdKey+'First1',LastName=mktIdKey+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey, MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con1); 
        
        Contact con2    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey+'01',
                                            Email='test2@avon.com',FirstName=mktIdKey+'First2',LastName=mktIdKey+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'01', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con2);
        
        Contact con3    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c='XX'+'02',
                                            Email='test2@avon.com',FirstName=mktIdKey+'First2',LastName=mktIdKey+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'02', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con3);
        
        Contact con4    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c='XX'+'03',
                                            Email='test2@avon.com',FirstName=mktIdKey+'First2',LastName=mktIdKey+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'03', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con4);
        insert lstContact; 
        
        // Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
                                            );
        lstRepPerf.add(rep1);
        ALM_Rep_Performance_1__c rep11 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.PREV_1_CMPGN_NR__c + mktIdKey,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
                                            );
        lstRepPerf.add(rep11);
                                        
        ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'01' ,
                                                UPLN_ACCT_NR__c = mktIdKey, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7
                                            );
        lstRepPerf.add(rep2);
        ALM_Rep_Performance_1__c rep21 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'01' ,
                                                UPLN_ACCT_NR__c = mktIdKey, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.PREV_1_CMPGN_NR__c + mktIdKey+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7
                                            );
        lstRepPerf.add(rep21);
                                            
        ALM_Rep_Performance_1__c rep3 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'02' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6
                                            );
        lstRepPerf.add(rep3);
        ALM_Rep_Performance_1__c rep31 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'02' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.PREV_1_CMPGN_NR__c + mktIdKey+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6
                                            );
        lstRepPerf.add(rep31);
                                            
        ALM_Rep_Performance_1__c rep4 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'03' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'02', Genealogy_Level__c = 3,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[3].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey+'03' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 4, RGT_ND_ID__c = 5
                                            );
        lstRepPerf.add(rep4);
        insert lstRepPerf;      
        
        
        // Creating Action Items data
        List<Action_Items__c> lstActionItems = testData.createActionItems();
        for(Action_Items__c t:lstActionItems)
            t.OwnerId=ldrUsr.Id;
        update lstActionItems;
        
        // Creating Market Action Items data
        Market_Action_Items__c mrktActItem ;
        List<Market_Action_Items__c> lstMrktActItems = new List<Market_Action_Items__c>();
        for(Integer i=0; i < lstActionItems.size(); i++){
            mrktActItem = new Market_Action_Items__c(Market__c=mrkt.Id, Action_Item__c=lstActionItems[i].Id, Campaign_Stage__c=10, Default__c=false,
                                                     Priority__c=''+i, Report__c=null, Threshold__c=5);
            lstMrktActItems.add(mrktActItem);
        }
        insert lstMrktActItems; 
        
        
        List<Market_Action_Items__c> newlst=[Select Id, Market__c, Action_Item__c, Campaign_Stage__c, Default__c, Priority__c, Report__c,
                                            Threshold__c, Action_Item__r.Action_Item_Type__c, Action_Item__r.Category__c, Action_Item__r.Default__c,
                                            Action_Item__r.Genealogy_Criteria_Fld__c, Action_Item__r.Order_Criteria_Fld__c, Action_Item__r.Rep_Criteria_Fld__c,
                                            Action_Item__r.Zone_Or_Leader__c, Action_Item__r.Smry_Criteria_Fld__c, Action_Item__r.Subject_Area__c, Action_Item__r.Datatype__c,
                                            Filter_Param__c, Report__r.Report_URL__c from Market_Action_Items__c];
                                            
                                            
        // Creating Combined object data
        String name_Comb_Obj  = mrkt.ALM_Rep_Indicator__c.replace('__c','__r');
        String tempSoql = 'Select CurrencyIsoCode, Id, Name, ';
        for(Market_Action_Items__c m: newlst){ 
                if(m.Action_Item__r.Smry_Criteria_Fld__c != NULL)          
                    tempSoql+=m.Action_Item__r.Smry_Criteria_Fld__c+', ';
            
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' From '+name_Comb_Obj;
        tempSoql += ' where MRKT_ID__c=\''+mrkt.Market_Id__c+'\' '+' and FLD_SLS_CMPGN_NR__c='+Double.valueOf(mrkt.CMPGN_NR__c)+' '; 
        
        String query_Comb_Obj = 'Select Id, Name, ('+tempSoql+') From Contact Where MRKT_ACCT_KEY__c=\''+ldrUsr.MRKT_ID_ACCT_NR_KEY__c+'\' '+' and MRKT_ID__c=\''+mrkt.Market_Id__c+'\' ';
        //System.debug('\n ### Combo Query \n'+query_Comb_Obj);
        
        Sobject combobjRec = Database.query(query_Comb_Obj);
        //System.debug('\n ### combobjRec ### \n'+combobjRec);
                                                    
        System.runAs(ldrUsr)
        {
            ActionItemsController objController = new ActionItemsController();
            
            objController.mkt_actionitem = newlst;
            objController.combObj  = combobjRec;
            
            objController.getInitialize();  
            objController.getcoachActionItems();
            objController.getmngNbrActionItems();
            objController.getmngPrsRepActionItems();
            
            System.assert(objController.mkt_actionitem.size() == 15);
            
        }*/
    
    }

}