/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.   
 */
@isTest
public class BusinessPlanControllerTest 
{
    public static String mktIdKey = 'XX';
    public static String sURL = '';
    public static User ldrUsr;
    public static Market__c mrkt;
    public static Contact con1;
    public static Leader_Title__c title;
    
    // public static Map<Double,Sales_Leader_History__c> cmpNoSLH_map = new Map<Double,Sales_Leader_History__c>(); 
    static testMethod void testCreateDataBusinessPlan() 
    {
        TestDataHelper testData =   new TestDataHelper();
        
        // Creating market data
        mrkt = testData.createMarket();
        mrkt.Market_Id__c = 'XX';
        mrkt.Allow_Freeform_Email__c = 'Avon Leader; Avon Division Manager';
        mrkt.Market_Currency_Symbol__c = '₱';
        update  mrkt;
        
        // Creating user data
        ldrUsr = testData.createLeaderUser(mktIdKey);
        ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
        ldrUsr.IsActive = true;
        update ldrUsr;
        
        // Updating market data
        mrkt.OwnerId = ldrUsr.Id;
        mrkt.Is_ALMPLUS_Enabled__c = true;
        mrkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        mrkt.X90_Day_Camp_CNT__c = 6;
        mrkt.Business_Plan_KPIs__c ='Personal_Volume_dollar;Personal_Appointments;Qualified_Personal_Appointments;G1_Removals;G1_Active_Representatives;G1_Activity_Rate;Total_Unit_Sales_dollor;G1_Sales_Leaders_UL;New_G1_UL;New_G1_AUL;New_G1_EUL;';
        mrkt.CMPGN_NR__c ='191203';
        mrkt.CMPGN_STRT_DT__c = date.valueOf('1912-04-02');
        mrkt.CMPGN_END_DT__c = date.valueOf('1912-04-30');
        update  mrkt;
        
        // Creating Leader Title data
        title = new Leader_Title__c(
                                            GENRTN_1_ERNGS_PCT__c=10.0, GENRTN_1_MIN_ORD_AMT__c=100.00,
                                            GENRTN_2_ERNGS_PCT__c=10.0, GENRTN_2_MIN_ORD_AMT__c=200.00,
                                            GENRTN_3_ERNGS_PCT__c=40.0, GENRTN_3_MIN_ORD_AMT__c=500.00,
                                            LANG_CD__c='en_US', LCL_LDRSHP_TITL_LANG_DESC_TXT__c='Title 01',
                                            LDRSHP_TITL_LVL_NR__c='1', Market__c=mrkt.Id,
                                          //  MIN_01_LVL_TITL_REQD_NR__c=100.00, MIN_GRP_SLS_REQD_AMT__c=100.0,
                                            MIN_PRSNL_SLS_REQD_AMT__c=100.00, MIN_REP_RCRTMNTS_REQD_NR__c=10,
                                          //  MIN_02_LVL_TITL_REQD_NR__c=10, MIN_03_LVL_TITL_REQD_NR__c=10,
                                            MIN_EST_ERNGs_AMT__c = 15000.00, MRKT_TAG_QLFR_1_NR__c=10, 
                                            MRKT_TAG_QLFR_2_NR__c=10,MRKT_TAG_QLFR_3_NR__c=10,
                                            GRAPHIC_ERNG_IMG__c='http://media.gadgetsin.com/uploads//2009/10/ropid_small_size_robot_1.JPG',
                                            MIN_GRP_SLS_REQD_AMT__c = 100.0, MRKT_ID__c = mrkt.Market_Id__c,
                                            LCL_LDRSHP_TITL_CD__c = 'TL 01', EXEC_IND__c ='Y');
        
        
        insert title;
        
        //create test calendars
        List<Calendar__c> calendars = new List<Calendar__c>();
        List<String> perPerfKeys = new List<String>();
        List<String> acctNbrLst = new List<String>();
        for(Integer i=191201;i<191212;i++){
            //calendars
            Calendar__c tempFutCal = new Calendar__c();
            tempFutCal.CMPGN_NR__c = i;
            tempFutCal.YEAR_NR__c = 1912;
            tempFutCal.Market__c = mrkt.Id;
            tempFutCal.MRKT_ID__c = mrkt.Market_Id__c;
            calendars.add(tempFutCal);
            String ppkey = mrkt.Market_Id__c + String.valueOf(i)+ '636363';
            acctNbrLst.add(String.valueOf(i)+ '636363');
            perPerfKeys.add(ppkey);
        }
        
        for(Integer j=191109;j<191116;j++){
            Calendar__c tempHistCal = new Calendar__c();
            tempHistCal.CMPGN_NR__c = j;
            tempHistCal.YEAR_NR__c = 1911;
            tempHistCal.Market__c = mrkt.Id;
            tempHistCal.MRKT_ID__c = mrkt.Market_Id__c;
            calendars.add(tempHistCal);
            String ppkey = mrkt.Market_Id__c + String.valueOf(j)+ '636363';
            perPerfKeys.add(ppkey);
        }
        insert calendars;
        
        // Creating Account data
        Account testAcct = new Account(Name='Test Acount');
        insert testAcct;
        
        // Creating Contact data
        List<Contact> lstContact = new List<Contact>();
        con1    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey,
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
        
         // Creating Business Plan Parameter data 
        /*Business_Plan_Parameter__c testBPpar = new Business_Plan_Parameter__c(Name='testBppar',Market_Id__c=mrkt.Id, AVG_LVL_1_G1_UNIT_COMMSN_PCT__c = 3.0, 
                                                                                AVG_LVL_1_G1_DSTRBTN_PCT__c = 3.0, AVG_LVL_1_G2_UNIT_COMMSN_PCT__c = 3.0,
                                                                                AVG_LVL_1_G2_DSTRBTN_PCT__c = 3.0, AVG_LVL_1_G3_UNIT_COMMSN_PCT__c = 3.0,
                                                                                AVG_LVL_1_G3_DSTRBTN_PCT__c = 3.0
                                                                                );
        insert testBPpar;*/
        
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
                                                UPLN_ACCT_KEY__c = con1.Id,
                                                LFT_ND_ID__c = 0, RGT_ND_ID__c = 9
                                            );
        lstRepPerf.add(rep2);
        /*
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
        */
        
        insert lstRepPerf;
    }
    
    static testMethod void testBusinessPlanNew() 
    {
        
        test.startTest();
        testCreateDataBusinessPlan();
        
        // Creating Business Plan data
        
        /*Business_Plan__c bp = new Business_Plan__c(Mrkt_Id_Acct_Nr_Key__c = ldrUsr.MRKT_ID_ACCT_NR_KEY__c,
                                                   Market_Id__c = mrkt.Market_Id__c, IsDeleted__c =false, Is_BP_Saved__c = true, OwnerId = ldrUsr.Id);
        
        insert bp;*/
        
        
        PageReference pageRef = Page.BusinessPlan;
        pageRef.getParameters().put('AccKey', 'XX');
        
        
       /* if(sUrl.contains('businessplan')) //BusinessPlan
         sUrl = sUrl.replace('businessplan', 'BusinessPlan');
        
        pageRef = new PageReference(sUrl);*/
        Test.setCurrentPageReference(pageRef);
                
        sUrl = Apexpages.currentPage().getURL();
        System.debug('\n ### URL --> '+sUrl);
        
        if(sUrl.contains('businessplan')) //BusinessPlan
         sUrl = sUrl.replace('businessplan', 'BusinessPlan');
        
        pageRef = new PageReference(sUrl);
        Test.setCurrentPageReference(pageRef);
        
        System.runAs(ldrUsr)
        {
            
             // Creating Business Plan Parameter data 
            Business_Plan_Parameter__c testBPpar = new Business_Plan_Parameter__c(Name='testBppar',Market_Id__c=mrkt.Id, 
                                                                                  AVG_LVL_1_G1_UNIT_COMMSN_PCT__c = 3.0, AVG_LVL_1_G1_DSTRBTN_PCT__c = 3.0,
                                                                                  AVG_LVL_1_G2_UNIT_COMMSN_PCT__c = 3.0, AVG_LVL_1_G2_DSTRBTN_PCT__c = 3.0, 
                                                                                  AVG_LVL_1_G3_UNIT_COMMSN_PCT__c = 3.0,  AVG_LVL_1_G3_DSTRBTN_PCT__c = 3.0
                                                                                  );
            insert testBPpar;
            
            
             
        Sales_Leader_History__c salesLeaderHistory = new Sales_Leader_History__c(
                                PD_TITL_LVL_NR__c='2',
                                SPPY_PD_TITL_LVL_NR__c='1',
                                FLD_SLS_CMPGN_NR__c = 191202.0,
                                GENRTN_1_TITL_10_STF_CNT__c=100,
                                SPPY_GENRTN_1_TITL_10_STF_CNT__c=99,
                                EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=200,
                                SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                GENRTN_1_TITL_5_STF_CNT__c=150,
                                SPPY_GENRTN_1_TITL_5_STF_CNT__c=120,
                                GENRTN_1_TITL_4_STF_CNT__c=100,
                                SPPY_GENRTN_1_TITL_4_STF_CNT__c=171,
                                GENRTN_1_TITL_3_STF_CNT__c=191,
                                SPPY_GENRTN_1_TITL_3_STF_CNT__c=170,
                                EXEC_UNIT_SLS__c=100,
                                SPPY_EXEC_UNIT_SLS__c=100,
                                EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                SPPY_EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                EXGENRTN_3_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                SPPY_EXGENRTN_TH_TOTAL_EXEC_TITL_STF_CNT__C=100,
                                TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=22,
                                SPPY_TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=55,
                                CUST_CNT__c=55,
                                SPPY_CUST_CNT__c=55,
                                LDR_ERNGS_AMT__c=100,
                                //PRSNL_SLS_AMT__c=1000.00,
                                SPPY_PRSNL_SLS_AMT__c=988.00,
                                GENRTN_1_APPT_CNT__c=55,
                                SPPY_GENRTN_1_APPT_CNT__c=33,
                                //GENRTN_1_QPA_CONVRSN_PCT__c=99,
                                //SPPY_GENRTN_1_QPA_CONVRSN_PCT__c=88,
                                GENRTN_1_QPA_CNT__c=100,
                                SPPY_GENRTN_1_QPA_CNT__c=100,
                                RTURNS_PCT__c=100,
                                //SPPY_RTURNS_PCT__c=100,                               
                                Contact__c = con1.Id
                    );  
                    insert salesLeaderHistory;
                    
                    Sales_Leader_History__c salesLeaderHistory1 = new Sales_Leader_History__c(
                                PD_TITL_LVL_NR__c='2',
                                SPPY_PD_TITL_LVL_NR__c='1',
                                FLD_SLS_CMPGN_NR__c = 191201.0,
                                GENRTN_1_TITL_10_STF_CNT__c=100,
                                SPPY_GENRTN_1_TITL_10_STF_CNT__c=99,
                                EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=200,
                                SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                GENRTN_1_TITL_5_STF_CNT__c=150,
                                SPPY_GENRTN_1_TITL_5_STF_CNT__c=120,
                                GENRTN_1_TITL_4_STF_CNT__c=100,
                                SPPY_GENRTN_1_TITL_4_STF_CNT__c=171,
                                GENRTN_1_TITL_3_STF_CNT__c=191,
                                SPPY_GENRTN_1_TITL_3_STF_CNT__c=170,
                                EXEC_UNIT_SLS__c=100,
                                SPPY_EXEC_UNIT_SLS__c=100,
                                EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                SPPY_EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                EXGENRTN_3_TOTAL_EXEC_TITL_STF_CNT__c=100,
                                SPPY_EXGENRTN_TH_TOTAL_EXEC_TITL_STF_CNT__C=100,
                                TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=22,
                                SPPY_TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=55,
                                CUST_CNT__c=55,
                                SPPY_CUST_CNT__c=55,
                                LDR_ERNGS_AMT__c=100,
                                //PRSNL_SLS_AMT__c=1000.00,
                                SPPY_PRSNL_SLS_AMT__c=988.00,
                                GENRTN_1_APPT_CNT__c=55,
                                SPPY_GENRTN_1_APPT_CNT__c=33,
                                //GENRTN_1_QPA_CONVRSN_PCT__c=99,
                                //SPPY_GENRTN_1_QPA_CONVRSN_PCT__c=88,
                                GENRTN_1_QPA_CNT__c=100,
                                SPPY_GENRTN_1_QPA_CNT__c=100,
                                RTURNS_PCT__c=100,
                                //SPPY_RTURNS_PCT__c=100,                               
                                Contact__c = con1.Id
                    );  
                    insert salesLeaderHistory1;
                    
            
            
            // Creating Business Plan data
            Business_Plan__c bp = new Business_Plan__c(Mrkt_Id_Acct_Nr_Key__c = ldrUsr.MRKT_ID_ACCT_NR_KEY__c,
                                                       Market_Id__c = mrkt.Market_Id__c, IsDeleted__c =false, Is_BP_Saved__c = true, 
                                                       PRSNL_DEV_PLN_ACTN3__c = 'TEST_PLN3', TOP_SLR_ACTN3__c = 'TEST_TOP_SLR_3',
                                                       Long_Term_Dreams__c = 'TEST_LONTRMDRM', RSNG_STR_DEV_ACTN2__c = 'TEST_RSNGSTAR_ACT',
                                                       FLWUP_MTG_60__c = System.today(), Personal_Achievement__c = 'TEST_PRSN_ACHV',
                                                       LDRSHP_TITL_ACTN2__c = 'TEST_LDR_TITLE',Short_Term_Goals__c = 'TEST_SHRT_GL',
                                                       Unit_Achievement__c = 'TEST_UNT_ACHV', Key_Learnings__c = 'TEST_KEY_LRNG',
                                                       RECR_ACTN1__c = 'TEST_RECR_ACT_1',Campaign_Numbers__c='191202.0;191203.0;191204.0;191205.0;191206.0;191207.0;191208.0;191209.0;191210.0;191211.0;191212.0',
                                                       CMPGN_NR__c = '191203.0',Current_campaign__c='191203.0',NEXT_1_CMPGN_NR__c='191204.0',NEXT_2_CMPGN_NR__c = '191204.0',
                                                       NEXT_3_CMPGN_NR__c='191205.0',NEXT_4_CMPGN_NR__c = '191206.0',NEXT_5_CMPGN_NR__c='191207.0',NEXT_6_CMPGN_NR__c = '191208.0',
                                                       Business_Plan_Parameter__c =testBPpar.Id, OwnerId = ldrUsr.Id);
            
            insert bp;          
          
            
            BusinessPlanControllerNew bpCntr = new BusinessPlanControllerNew();
            
            bpCntr.isBlankPlan=true;            
            bpCntr.BPAction();          
            bpCntr.savePage();            
            bpCntr.shortTermGoals = 'short';
            bpCntr.longTermGoals = 'long';
            bpCntr.personalAcheivementPY = 'personal';
            bpCntr.unitAcheivementPY = 'unit';
            bpCntr.keyLearnings = 'key';
            bpCntr.recruiting_ActStr1 = 'testact';
            bpCntr.recruiting_ActStr2 = 'testact';
            bpCntr.recruiting_ActStr3 = 'testact';
            bpCntr.activity_ActStr1 = 'testact';
            bpCntr.activity_ActStr2 = 'testact';
            bpCntr.activity_ActStr3 = 'testact';
            bpCntr.topSeller_ActStr1 = 'testact';
            bpCntr.topSeller_ActStr2 = 'testact';
            bpCntr.topSeller_ActStr3 = 'testact';
            bpCntr.topSeller_Candidates = 'testact';
            bpCntr.leadership_ActStr1 = 'testact';
            bpCntr.leadership_ActStr2 = 'testact';
            bpCntr.leadership_ActStr3 = 'testact';
            bpCntr.leadership_Candidates = 'testact';
            bpCntr.perDev_ActStr1 = 'testact';
            bpCntr.perDev_ActStr2 = 'testact';
            bpCntr.perDev_ActStr3 = 'testact';
            bpCntr.perDev_ActStr4 = 'testact';
            bpCntr.perDev_ActStr5 = 'testact';
            bpCntr.perDev_ActStr6 = 'testact';
            bpCntr.rising_ActStr1 = 'testact';
            bpCntr.rising_ActStr2 = 'testact';
            bpCntr.rising_ActStr3 = 'testact';
            bpCntr.rising_Candidates = 'testact';
            bpCntr.followup30 = '08/01/2012';
            bpCntr.followup60 = '09/01/2012';
            bpCntr.followup90 = '10/01/2012';
            
            bpCntr.savePage();            
            bpCntr.BPAction();            
            bpCntr.startNewPlan();            
            bpCntr.processPage();             
            bpCntr.savePage();            
            bpCntr.cancelChanges(); 
            
          //  bpCntr.sendMessages(String.valueOf(bp.Id));
        }
        
        title.EXEC_IND__c = '';
        update title;
        
        mrkt.CMPGN_NR__c ='191205';
       
        update mrkt;
        
        test.stopTest();
    }
    
      
    static testMethod void testBusinessPlan() 
    {
        /////////////////////////////////////////////////
      
                    //cmpNoSLH_map.put(191205.0,salesLeaderHistory);
                    //cmpNoSLH_map.put(191112.0,salesLeaderHistory);
        ///////////////////////////////////////////////////
        
        test.startTest();
        
        testCreateDataBusinessPlan();
        
        PageReference pageRef1 = Page.BusinessPlan;
        pageRef1.getParameters().put('repDetailAcctNbr', 'XX'); 
        pageRef1.getParameters().put('acctkey', 'XX'); 
        
        test.setCurrentPage(pageRef1);
        
        String sUrl1 = Apexpages.currentPage().getURL();
        System.debug('\n ### URL --> '+sUrl1);
        
        if(sUrl1.contains('businessplan')) //BusinessPlan
         sUrl1 = sUrl1.replace('businessplan', 'BusinessPlan');
        
        pageRef1 = new PageReference(sUrl1);
        
        Test.setCurrentPageReference(pageRef1);
        
        
        
        System.runAs(ldrUsr)
        {
            BusinessPlanControllerNew bpCntr1 = new BusinessPlanControllerNew();
            //bpCntr.coachParam = 'coach';
            
            Business_Plan_Parameter__c testBPpar = new Business_Plan_Parameter__c(Name='testBppar',Market_Id__c=mrkt.Id, 
                                                                                  AVG_LVL_1_G1_UNIT_COMMSN_PCT__c = 3.0, AVG_LVL_1_G1_DSTRBTN_PCT__c = 3.0,
                                                                                  AVG_LVL_1_G2_UNIT_COMMSN_PCT__c = 3.0, AVG_LVL_1_G2_DSTRBTN_PCT__c = 3.0, 
                                                                                  AVG_LVL_1_G3_UNIT_COMMSN_PCT__c = 3.0,  AVG_LVL_1_G3_DSTRBTN_PCT__c = 3.0
                                                                                  );
            insert testBPpar;
        
        Business_Plan__c bp = new Business_Plan__c(Mrkt_Id_Acct_Nr_Key__c = ldrUsr.MRKT_ID_ACCT_NR_KEY__c,
                                                       Market_Id__c = mrkt.Market_Id__c, IsDeleted__c =false, Is_BP_Saved__c = true, 
                                                       PRSNL_DEV_PLN_ACTN3__c = 'TEST_PLN3', TOP_SLR_ACTN3__c = 'TEST_TOP_SLR_3',
                                                       Long_Term_Dreams__c = 'TEST_LONTRMDRM', RSNG_STR_DEV_ACTN2__c = 'TEST_RSNGSTAR_ACT',
                                                       FLWUP_MTG_60__c = System.today(), Personal_Achievement__c = 'TEST_PRSN_ACHV',
                                                       LDRSHP_TITL_ACTN2__c = 'TEST_LDR_TITLE',Short_Term_Goals__c = 'TEST_SHRT_GL',
                                                       Unit_Achievement__c = 'TEST_UNT_ACHV', Key_Learnings__c = 'TEST_KEY_LRNG',
                                                       RECR_ACTN1__c = 'TEST_RECR_ACT_1',Campaign_Numbers__c='191202.0;191203.0;191204.0;191205.0;191206.0;191207.0;191208.0;191209.0;191210.0;191211.0;191212.0',
                                                       CMPGN_NR__c = '191203.0',Current_campaign__c='191203.0',NEXT_1_CMPGN_NR__c='191204.0',NEXT_2_CMPGN_NR__c = '191204.0',
                                                       NEXT_3_CMPGN_NR__c='191205.0',NEXT_4_CMPGN_NR__c = '191206.0',NEXT_5_CMPGN_NR__c='191207.0',NEXT_6_CMPGN_NR__c = '191208.0',
                                                       Business_Plan_Parameter__c =testBPpar.Id, OwnerId = ldrUsr.Id);
            
            insert bp;
            
            List<Business_Plan__c> lstBP = [SELECT  PRSNL_DEV_PLN_ACTN3__c , TOP_SLR_ACTN3__c , Long_Term_Dreams__c , RSNG_STR_DEV_ACTN2__c ,
                                                    FLWUP_MTG_60__c , Personal_Achievement__c , LDRSHP_TITL_ACTN2__c, 
                                                    Short_Term_Goals__c , Unit_Achievement__c , Key_Learnings__c , RECR_ACTN1__c 
                                            FROM Business_Plan__c where OwnerId = :ldrUsr.Id LIMIT 1 ];
            if(lstBP.size() > 0){
                System.debug('\n ### lstBP size '+lstBP.size());
                
                lstBP[0].PRSNL_DEV_PLN_ACTN3__c = null;
                lstBP[0].TOP_SLR_ACTN3__c = null;
                lstBP[0].RECR_ACTN1__c = null;
                
            update lstBP;
                
            }
            
            
            bpCntr1.BPAction();
            bpCntr1.getOmniturePageName();
            bpCntr1.callRepDetails();
        }
        
        test.stopTest();
        
        /*
        mrkt.CMPGN_NR__c ='191212';
        update mrkt;
        
        PageReference pageRef2 = Page.BusinessPlan;
        pageRef2.getParameters().put('repDetailAcctNbr', 'XX');
        Test.setCurrentPageReference(pageRef2);
        
        System.runAs(ldrUsr)
        {
            BusinessPlanControllerNew bpCntr2 = new BusinessPlanControllerNew();
            bpCntr2.coachParam = 'coach';
            bpCntr2.BPAction();
            bpCntr2.getOmniturePageName();
            bpCntr2.callRepDetails();
        }*/
        
            
    }
    
    
        
}