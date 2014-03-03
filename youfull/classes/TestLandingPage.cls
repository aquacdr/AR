/*
** Apex Class/Controller Name           : TestLandingPage
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : Yes
**
** Purpose [short summary]              : Test client side code for the components of LandingPage
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** ~Format: Date | Author | Change description 
**  March 13, 2012. Created
** 
*/

@isTest
public class TestLandingPage {
    
    private static TestDataHelper tdh = new TestDataHelper();
    private static String lang = 'en_US';
    private static String currentCmpgn = '201204';
    private static String priorCmpgn = '201203';
    private static String uplineAcctNr = 'upln1';
    private static String downlineOneAcctNr = uplineAcctNr+'01';
    private static String downlineOneZoneNumber = 'DW1';
    private static String downlineOneProfileName = 'Avon Leader';
    private static String downlineTwoAcctNr = uplineAcctNr+'02';
    private static String downlineThreeAcctNr = uplineAcctNr+'03';
    private static String downlineFourAcctNr = uplineAcctNr+'04';
    private static String demoMktCode = 'DE';
    private static MailPlan_Order_Oppty__c mpOpp;
    private static Market__c mkt;
    private static User uplineUser, downlineOneUser, downlineTwoUser, downlineThreeUser, downlineFourUser;
    private static List<ALM_Rep_Performance_1__c> lstRepPerf;
    private static Map<String, Contact> mapContact;
    
    //test landing page
    private static testMethod void testLandingPageDataCreate() {
        //create market
        mkt = tdh.createMarket(demoMktCode);
        mkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        update mkt;
        tdh.createLeaderTitles();
        tdh.createSellerStatus();
        createMPOrderOpp(mkt);
        Account a = createAccount();
        //create upline user
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            uplineUser = tdh.createLeaderUser(uplineAcctNr);
            downlineOneUser = tdh.createLeaderUser(downlineOneAcctNr);
            downlineTwoUser = tdh.createLeaderUser(downlineTwoAcctNr);
            downlineThreeUser = tdh.createLeaderUser(downlineThreeAcctNr);
            downlineFourUser = tdh.createLeaderUser(downlineFourAcctNr);
        }
        
        mapContact = new Map<String, Contact>();
    //public Boolean populateAttributes(List<SObject> listSObject, Map<String, Contact> mapContact) {
        //tdh.createAccount();
        //create contact, personal perf. downline summary
        //Contact c = createContact(mkt, uplineAcctNr, uplineUser.Id);
       // tdh.createContact(uplineAcctNr, uplineUser.Id);
       // tdh.createMyBusiness(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        //tdh.createLdrDwnSumm(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        //added by SG
        
        List<Contact> lstContact = new List<Contact>();
        Contact con1    = new Contact(  AccountId=a.Id, ACCT_NR__c=uplineAcctNr,
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'First1',LastName=uplineAcctNr+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr, MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=uplineUser.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con1);
        
        Contact con2    = new Contact(  AccountId=a.Id, ACCT_NR__c=uplineAcctNr+'01',
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'01'+'First1',LastName=uplineAcctNr+'01'+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'01', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=downlineOneUser.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con2);
        
        
        Contact con3    = new Contact(  AccountId=a.Id, ACCT_NR__c=uplineAcctNr+'02',
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'02'+'First1',LastName=uplineAcctNr+'02'+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'02', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=downlineTwoUser.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con3);
        
        Contact con4    = new Contact(  AccountId=a.Id, ACCT_NR__c=uplineAcctNr+'03',
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'03'+'First1',LastName=uplineAcctNr+'03'+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'03', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=downlineThreeUser.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con4);
        
        Contact con5    = new Contact(  AccountId=a.Id, ACCT_NR__c=uplineAcctNr+'04',
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'04'+'First1',LastName=uplineAcctNr+'04'+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'04', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=downlineThreeUser.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con5);
        
        Contact con6    = new Contact(  AccountId=a.Id, ACCT_NR__c=uplineAcctNr+'05',
                                            Email='test1@avon.com',FirstName=uplineAcctNr+'05'+'First1',LastName=uplineAcctNr+'05'+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                           /* LOA_NR__c=15,  MLPLN_CD__c=this.mplans[0].MLPLN_CD__c,*/
                                            MRKT_ACCT_KEY__c=mkt.Market_Id__c+uplineAcctNr+'05', MRKT_ID__c=mkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=downlineThreeUser.Id, 
                                            REP_BRTH_DT__c =System.today()
                                          );
        lstContact.add(con6);
        
        insert lstContact;
        
        // Insert ALM Rep Performance records for each contact for each campaign
        lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        
        // LEADER
        
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
        										Name = 'Test REP1', ACCT_NR__c = uplineAcctNr,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,
                                                MailPlan_Order_Oppty__c = mpOpp.Id,
                                                GRP_INVC_AWRD_SLS_AMT__c = 1000,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = 1500
        									);
        lstRepPerf.add(rep1);
        									
        ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
        										Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'01' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 3,
                                                MailPlan_Order_Oppty__c = mpOpp.Id,
                                                GRP_INVC_AWRD_SLS_AMT__c = 1000,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = 1500
        									);
        lstRepPerf.add(rep2);
        									
        ALM_Rep_Performance_1__c rep3 = new ALM_Rep_Performance_1__c(
        										Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'02' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '0',
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 4, RGT_ND_ID__c = 5,
                                                MailPlan_Order_Oppty__c = mpOpp.Id,
                                                GRP_INVC_AWRD_SLS_AMT__c = 1000,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = 1500
        									);
        lstRepPerf.add(rep3);
        									
        ALM_Rep_Performance_1__c rep4 = new ALM_Rep_Performance_1__c(
        										Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'03' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr+'02', Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[3].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'03' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '2',
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 6, RGT_ND_ID__c = 7,
                                                MailPlan_Order_Oppty__c = mpOpp.Id,
                                                GRP_INVC_AWRD_SLS_AMT__c = 1000,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = 1500,
                                                GRP_INVCD_BLCKD_SLS_AMT__c = 2000
        									);
        lstRepPerf.add(rep4);
        
        ALM_Rep_Performance_1__c rep5 = new ALM_Rep_Performance_1__c(
        										Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'04' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr+'02', Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[3].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'04' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '7',
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 6, RGT_ND_ID__c = 7,
                                                MailPlan_Order_Oppty__c = mpOpp.Id,
                                                GRP_INVC_AWRD_SLS_AMT__c = 1000,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = 1500,
                                                GRP_INVCD_BLCKD_SLS_AMT__c = 2000,
                                                INVC_AWRD_SLS_AMT__c = 500,
                                                SUBMTD_AWRD_SLS_AMT__c = 700
        									);
        lstRepPerf.add(rep5);
        
        ALM_Rep_Performance_1__c rep6 = new ALM_Rep_Performance_1__c(
        										Name = 'Test REP1', ACCT_NR__c = uplineAcctNr+'05' ,
                                                UPLN_ACCT_NR__c = uplineAcctNr, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[4].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mkt.Market_Id__c + mkt.CMPGN_NR__c + uplineAcctNr+'05' ,
                                                REP_OMS_STUS_CD__c = '-2', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '7',
                                                ROOT_UPLN_ACCT_NR__c = uplineAcctNr,
                                                LFT_ND_ID__c = 6, RGT_ND_ID__c = 7,
                                                MailPlan_Order_Oppty__c = mpOpp.Id,
                                                GRP_INVC_AWRD_SLS_AMT__c = 1000,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c = 1500,
                                                GRP_INVCD_BLCKD_SLS_AMT__c = 2000,
                                                INVC_AWRD_SLS_AMT__c = 500,
                                                SUBMTD_AWRD_SLS_AMT__c = 700
        									);
        lstRepPerf.add(rep6);
        insert lstRepPerf;
        
        
        /*
        tdh.createListContact(new List<String>{uplineAcctNr},uplineUser.Id);
        
        //tdh.createMyBusiness(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        //tdh.createLdrDwnSumm(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        tdh.createRepPerformance(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, uplineUser.Id);
        
        //create download users
        
        
        
        List<Contact> lstContact = new List<Contact>();
        
        
        
        //create genealogy, personal perf. downline summary for downline users 
        tdh.createGenealogyData(downlineOneAcctNr, uplineUser.Id, uplineAcctNr);
        tdh.createGenealogyData(downlineTwoAcctNr, uplineUser.Id, uplineAcctNr);
        tdh.createGenealogyData(downlineThreeAcctNr, uplineUser.Id, downlineTwoAcctNr);
        
        /*
        List<XDE_Genealogy__c> listGen = [SELECT 
                                                ACCT_NR__c,
                                                Contact_Key__r.CONVRSN_DT__c,
                                                Contact_Key__r.FirstName,
                                                Contact_Key__r.LastName,
                                                Contact_Key__r.Name,
                                                Contact_Key__r.PATD_CERTFCTN_LVL_A_IND__c,
                                                Contact_Key__r.REP_EMAIL_ADDR_TXT__c,
                                                Contact_Key__r.Representative_Phone__c,
                                                Contact_Key__r.REP_APPT_DT__c, //Added by Rupayan
                                                EXEC_GEN_INDX__c,
                                                GENRTN_1_LDR_CNT_TXT__c,
                                                GENTRTN_1_ACTV_REP_CNT__c,
                                                GRP_APPT_CNT__c,
                                                GRP_BLCKD_UNIT_SLS_AMT__c,
                                                GRP_UNIT_SLS_AMT__c,
                                                TTL_LEG_CNT__c,
                                                BRNCH_SCTN_CD__c,
                                                DWNLN_ONLY_IND__c,
                                                FRST_ORDER_DUE_DT__c,
                                                FRST_ORDR_AMT__c,
                                                FRST_ORDR_DT__c,
                                                FRST_ORDR_PD_DT__c,
                                                FRST_ORD_REQ_DT__c,
                                                GENRTN_1_APPT_CNT__c,
                                                GENRTN_1_QPA_CNT__c,
                                                LDRSHP_TAR_IND__c,
                                                LDRSHP_TITL_LVL_NR_NUMBER__c,
                                                LDRSHP_TITL_LVL_NR__c,
                                                PD_TITL_LVL_NR__c,
                                                PRSNL_SLS_AMT__c,
                                                REP_APPT_CMPGN_NR_NUMBER__c,
                                                REP_APPT_CMPGN_NR__c,
                                                REP_OMS_STUS_CD__c,
                                                RSNG_STR_IND__c,
                                                SLS_ZONE_CD__c,
                                                TITL_STUS__c,
                                                UPLN_ACCT_NR__c,
                                                ZONE_MGR_NAME__c,
                                                Qualified_Candidate_Value__c, //Added by Rupayan
                                                UPLN_GEN_INDX__c
                        FROM XDE_Genealogy__c
        ];
        
        
        
        List<My_Business__c> ppList = [SELECT Id, LDRSHP_TITL_LVL_NR__c FROM My_Business__c
                                                WHERE ACCT_NR__c IN (:uplineAcctNr, :downlineOneAcctNr, :downlineTwoAcctNr)];
                                                
                                                
        for(My_Business__c mb: ppList) {
            mb.LDRSHP_TITL_LVL_NR__c = '1';
        }
        
        update ppList;
        */
        //share market 
        Market__Share mShare = new Market__Share();
        mShare.UserOrGroupId = uplineUser.id;
        mShare.ParentId = mkt.id;
        mShare.AccessLevel = 'Edit';
        insert mShare;
        
        createCampaignCalendarRecords(mkt); 
        createCustomMessages(mkt, uplineUser.Id);
        createIncentives(mkt, uplineUser.Id);
        createTopSellet(mkt, uplineUser.Id);
        mapContact.put(LandingPageUtils.getMarketAccountKey(mkt.Market_Id__c, uplineAcctNr) , con1);
        createLandingPageConfig(mkt);
        
        List<ALM_Rep_Performance_1__c> lstALM = new List<ALM_Rep_Performance_1__c>();
        lstALM.add(rep1);
        
    }
    
    private static testMethod void testLandingPage() {
    	testLandingPageDataCreate();
        //Landing Page
        PageReference pageRef = Page.YOUHome;
        PageRef.getParameters().put('pageId','1');
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            LandingPageConfigController lpController = new LandingPageConfigController();              
            lpController.priorCampaign();
            lpController.currentCampaign();
            lpController.nextCampaign();
            lpController.saveSearchText();
            lpController.getOmniturePageName();
            lpController.callRepDetails();
            LandingPageUtils.setBattery(new BatteryChartParams(), 100, 50, 200); 
            LPDownlineWrapper wrapper = new LPDownlineWrapper();
            
            List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, uplineAcctNr, mkt.Market_ID__c);
            lpController.getMailPlanCampaign(lst_CombinedObj);
        }
        
        // Search Page for Non Mailplan Market
        pageRef = Page.searchPage;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put(ALMConstants.SEARCH_URL_PARAM, downlineOneAcctNr);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            SearchResultController searchController = new SearchResultController();
            searchController.keyword=downlineOneAcctNr;
            searchController.defaultKeyword=downlineOneAcctNr;
            searchController.option='accountnumber';
            searchController.getInitialized();
            
            searchController.doSearch();
            searchController.FirstPageList();
            searchController.LastPageList();
            searchController.getCurrentPageList();
            searchController.NextPageList();
            searchController.PrevPageList();
            searchController.getNumberOfPages();
            searchController.getLast();
            searchController.getPrevious();
            searchController.getNext();
            searchController.viewLink();
           // String omn=searchController.getOmniturePageName();
            
        }
        
        
        // Title achievement
        pageRef = Page.Title_Achievement;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put('mpCampaign',mkt.CMPGN_NR__c);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            List<Custom_Message__c> lM = [Select Id from Custom_Message__c];
            TitleAchievementController titleController = new TitleAchievementController();
        }
        System.runAs(downlineThreeUser){
            TitleAchievementController titleController = new TitleAchievementController();
        }
        System.runAs(downlineFourUser){
            TitleAchievementController titleController = new TitleAchievementController();
        }
        
        //test landing page for mail plan market
        Market__c mpmarket=[Select Id,Mail_Plan_Enabled__c from Market__c where Market_Id__c=:uplineUser.MRKT_ID__c];
        mpmarket.Mail_Plan_Enabled__c=true;
        update mpmarket;
        System.runAs(uplineUser){
            LandingPageConfigController lpController = new LandingPageConfigController();              
            lpController.priorCampaign();
            lpController.currentCampaign();
            lpController.nextCampaign();
            lpController.saveSearchText();
            lpController.getOmniturePageName();
            lpController.callRepDetails();
            LandingPageUtils.setBattery(new BatteryChartParams(), 100, 50, 200); 
            LPDownlineWrapper wrapper = new LPDownlineWrapper();
            
            List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, uplineAcctNr, mkt.Market_ID__c);
            lpController.getMailPlanCampaign(lst_CombinedObj);
        }
    }
     
     private static testMethod void testLandingPage2() {  
     	testLandingPageDataCreate(); 
     	PageReference pageRef = Page.YOUHome;
        PageRef.getParameters().put('pageId','1');
        Test.setCurrentPage(pageRef);
        // Incentives
        pageRef = Page.Incentives;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put('mpCampaign',mkt.CMPGN_NR__c);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            IncentivesController incController = new IncentivesController();
        }
        
        
        // G1SalesLeader
        pageRef = Page.G1SalesLeaders;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put('mpCampaign',mkt.CMPGN_NR__c);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            G1SalesLeadersController g1SLController = new G1SalesLeadersController();
            System.debug('mapContact --> '+mapContact);
            g1SLController.populateAttributes(lstRepPerf, mapContact);
        }
        
        //G1Appointments 
        pageRef = Page.G1Appointments;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put('mpCampaign',mkt.CMPGN_NR__c);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            G1AppointmentsController g1AppControlelr = new G1AppointmentsController();
            g1AppControlelr.populateAttributes(lstRepPerf, mapContact);
        }
        
        //RisingStars
        pageRef = Page.ELRisingStars;
        PageRef.getParameters().put('imperson',downlineOneAcctNr);
        PageRef.getParameters().put('mpCampaign',mkt.CMPGN_NR__c);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            RisingStarsController risingController = new RisingStarsController();
            risingController.populateAttributes(lstRepPerf, mapContact);
        }
        
        // G1Candidates 
        pageRef = Page.G1Candidates;
        pageRef.getParameters().put('imperson',downlineOneAcctNr);
        pageRef.getParameters().put('mpCampaign',mkt.CMPGN_NR__c);
        Test.setCurrentPage(pageRef);
        System.runAs(uplineUser){
            G1CandidatesController g1CandController = new G1CandidatesController();
            g1CandController.populateAttributes(lstRepPerf, mapContact);
        }
    }

    private static Contact createContact(Market__c market, String acctNbr, String ownerId){
        
         Contact c = new Contact(  AccountId=createAccount().Id, ACCT_NR__c=acctNbr,
                                   Email='test@avon.com', FirstName=acctNbr+'First', LastName=acctNbr+'Last', HomePhone='9999999999',
                                   LDRSHP_PRGRM_IND__c='Y', LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                   //LOA_NR__c=15,
                                   MRKT_ACCT_KEY__c= market.Market_Id__c+acctNbr,
                                   MRKT_ID__c=market.Market_Id__c,
                                   PATD_CERTFCTN_LVL_A_IND__c='Y', PATD_CERTFCTN_LVL_D_IND__c='Y',
                                   PATD_CERTFCTN_LVL_P_IND__c='Y', PATD_CERTFCTN_LVL_T_IND__c='Y',
                                   REP_ADDR_STR_2_TXT__c='Address 2', REP_ADDR_STR_3_TXT__c='Address 3',
                                   REP_ADDR_STR_4_TXT__c='Address 4', REP_APPT_DT__c=System.today(),
                                   REP_LANG_CD__c='en_US', SLS_ZONE_CD__c='XZ1', REP_MOBILE_PHON_NR__c = '1234546789',
                                   OwnerId=ownerId
                                          );
        insert c;
        return c;
    }
    
    private static Account createAccount(){
        Account a = new Account(name='testAccount');
        insert a;
        return a;
    }
       
    
    private static void createCampaignCalendarRecords(Market__c mrkt){
        List<Calendar__c> campaignCalendarList = new List<Calendar__c>();
        campaignCalendarList.add(new Calendar__c(Market__c = mrkt.Id, CMPGN_NR__c = Decimal.valueOf(currentCmpgn), MRKT_ID__c = mrkt.Market_Id__c, CURRNT_IND__c = 'Y',  PRIOR_CMPGN_NR__c = priorCmpgn));
        campaignCalendarList.add(new Calendar__c(Market__c = mrkt.Id, CMPGN_NR__c = Decimal.valueOf(priorCmpgn), MRKT_ID__c = mrkt.Market_Id__c, PRIOR_CMPGN_NR__c = priorCmpgn));
        insert campaignCalendarList;
        
        /*
        Calendar__c calendar = [SELECT Id, CMPGN_NR__c, CURRNT_IND__c, MRKT_ID__c, PRIOR_CMPGN_NR__c, CMPGN_STRT_DT__c, CMPGN_END_DT__c FROM Calendar__c
                                WHERE CMPGN_NR__c = :campaignNumber LIMIT 1];
        */
    }
    
    private static void createCustomMessages(Market__c mrkt, String ownerId) {
        List<Custom_Message__c> listMessages = new List<Custom_Message__c>();
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'pv_view_my_orders', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'g1_titled', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_needed_neg', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_needed_pos', Component_Name_Picklist__c = 'Title Achievements', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ri_earned_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ri_earned_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_toreach_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'ts_toreach_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'li_needed_neg', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        listMessages.add(new Custom_Message__c(OwnerId = ownerId, Message_Name__c = 'li_needed_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mrkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        //listMessages.add(new Custom_Message__c(Message_Name__c = 'ts_needed_pos', Component_Name_Picklist__c = 'Incentives', LANG_CD__c = 'en_US',  Market__c = mkt.Id, Message_Text__c = 'some text', SL_Title__c = '1;2;3;4;5', User_Type__c = 'Avon Leader'));
        
        insert listMessages;
    }
    
    private static void createIncentives(Market__c mrkt, String ownerId) {
        List<Incentive__c> listIncentive = new List<Incentive__c>();
        listIncentive.add(new Incentive__c(TITL_LVL_NR__c = '1', CMPGN_NR__c = currentCmpgn, LANG_CD__c = lang, Market__c = mrkt.Id, MRKT_ID__c = mrkt.Market_Id__c, INCNTV_PRODCT_NM__c = 'PRODUCT1',     INCNTV_REQ_CNT__c = 20,  INCNTV_STRT_DT__c = System.today() - 1,  Type__c = 'Personal'));
        listIncentive.add(new Incentive__c(TITL_LVL_NR__c = '1', CMPGN_NR__c = currentCmpgn, LANG_CD__c = lang, Market__c = mrkt.Id, MRKT_ID__c = mrkt.Market_Id__c, INCNTV_PRODCT_NM__c = 'PRODUCT1',     INCNTV_REQ_CNT__c = 20,  INCNTV_STRT_DT__c = System.today() - 1,  Type__c = 'Team'));
        insert listIncentive;
    }
    
    
    private static void createTopSellet(Market__c mrkt, String ownerId) {
        List<Seller_Status__c> listTopSeller = new List<Seller_Status__c>();
        listTopSeller.add(new Seller_Status__c(CYCLE_NR_OF_CMPGNS__c = 100, CTD_MIN_REQ_AWRD_SLS_AMT__c = 20, LANG_CD__c = lang, Market__c = mrkt.Id, MRKT_ID__c = mrkt.Market_Id__c, MRKT_TOP_SLR_LANG_KEY__c = 'TTTTT1' ));
        insert listTopSeller;
    }
    
    private static void createLandingPageConfig(Market__c mrkt) {
    	Landing_Page_Config__c lPgConfig = new Landing_Page_Config__c(Market__c=mrkt.Id, Title_Level_Number__c='All', User_Type__c='All');
    	insert lPgConfig;
    	
    	List<Landing_Page_Component__c> lstLPgComp = new List<Landing_Page_Component__c> ();
    	
    	Landing_Page_Component__c g1SalesLeader= new Landing_Page_Component__c(Landing_Page_Config__c=lPgConfig.Id,VF_Page_Name__c='G1SalesLeaders');
    	lstLPgComp.add(g1SalesLeader);
    	
    	Landing_Page_Component__c g1Candidate= new Landing_Page_Component__c(Landing_Page_Config__c=lPgConfig.Id,VF_Page_Name__c='G1Candidates');
    	lstLPgComp.add(g1Candidate);
    	
    	Landing_Page_Component__c risingStar= new Landing_Page_Component__c(Landing_Page_Config__c=lPgConfig.Id,VF_Page_Name__c='ELRisingStars');
    	lstLPgComp.add(risingStar);
    	
    	if(lstLPgComp.size() > 0) {
    		insert lstLPgComp;
    	}
    }
    
    private static void createMPOrderOpp(Market__c mrkt) {
    	DateTime d = System.now();
    	d = d.addDays(15);
    	Date mpDate = date.newinstance(d.year(), d.month(), d.day());
    	mpOpp = new MailPlan_Order_Oppty__c(Market__c = mrkt.Id, CMPGN_NR__c=mrkt.CMPGN_NR__c, MLPLN_CLOSD_IND__c='N',MLPLN_END_DT__c=mpDate);
    	insert mpOpp;
    }
}