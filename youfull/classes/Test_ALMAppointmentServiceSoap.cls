@isTest
private class Test_ALMAppointmentServiceSoap {
    
    public static String mktIdKey = 'XX';
    static testMethod void runtest() {
            
        
        TestDataHelper testData =   new TestDataHelper();
        
         // Creating market data
		Market__c mrkt = testData.createMarket();
        mrkt.Market_Id__c = 'XX';
    	mrkt.Allow_Freeform_Email__c = 'Avon Leader; Avon Division Manager';
    	mrkt.Market_Currency_Symbol__c = '₱';
    	mrkt.Batch_Load_In_Process__c = false;
    	mrkt.NEXT_1_CMPGN_NR__c = '1234';
        mrkt.CMPGN_NR__c = '3456';
    	update  mrkt;
    	 
    	// Creating user data
    	User ldrUsr = testData.createLeaderUser(mktIdKey);
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
    	insert con1;
    	
    	
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', 
                                                ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = con1.Id,
                                                MRKT_KEY__c = mrkt.Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,
                                                Genealogy_Key__c = mrkt.Market_ID__c+mrkt.CMPGN_NR__c+mktIdKey,
                                                SLS_ZONE_CD__c = 'ttt'
                                            );
      insert rep1;
      
      String salesOrgSummaryKey = rep1.MRKT_ID__c + rep1.OPERTNL_CMPGN_NR__c + 'Z' + rep1.SLS_ZONE_CD__c;
      
      Sales_Org_Summary__c sos = New Sales_Org_Summary__c (  ACTV_REP_CNT__c=300, UPR_CNT__c=8
                                                           , SLS_ORG_DESC_TXT__c='601'
                                                           , TITLD_STF_CNT__c=8
                                                           , RTURN_NET_SLS_PLAN_SPPY_AMT__c=1550.00
                                                           , TITL_0_STF_CNT__c=8
                                                           , UPR_DIV_RNK_CNT__c=100
                                                           , RNSTMT_DIV_RNK__c=100
                                                           , UPR_PLAN_SPPY_CNT__c=9
                                                           , RMOVL_PLAN_CNT__c=6
                                                           , LOA_1_6_NET_SLS_DIV_RNK__c=100
                                                           , RTURN_NET_SLS_AMT__c=1500.00
                                                           , RMOVL_SPPY_CNT__c=8
                                                           , LOA_1_6_NET_SLS_PLAN_SPPY_AMT__c=1000.00
                                                           , RMOVL_PLAN_SPPY_CNT__c=8
                                                           , NET_SLS_SPPY_AMT__c=1555000.00
                                                           , LOA_1_6_NET_SLS_SPPY_AMT__c=1000.00
                                                           , RNSTMT_PLAN_CNT__c=5
                                                           , RMOVL_CNT__c=9
                                                           , TITLD_STF_DIV_RNK__c=100
                                                           , RNSTMT_CNT__c=2
                                                           , ACTV_REP_PLAN_SPPY_CNT__c=1500
                                                           , NET_SLS_DIV_RNK__c=100
                                                           , TITL_0_STF_PLAN_SPPY_CNT__c=9
                                                           , APPT_CNT__c=9
                                                           , TITL_0_STF_PLAN_CNT__c=9
                                                           , TITL_0_STF_DIV_RNK__c=100
                                                           , LOA_1_6_NET_SLS_AMT__c=30000.00
                                                           , UPR_PLAN_CNT__c=9
                                                           , OPERTNL_CMPGN_NR__c='201303'
                                                           , ACTV_REP_DIV_RNK__c=100
                                                           , RNSTMT_SPPY_CNT__c=7
                                                           , LOA1_NET_SLS_DIV_RNK__c=100
                                                           , ACTV_REP_SPPY_CNT__c=1600
                                                           , LOA1_NET_SLS_AMT__c=1000.00
                                                           , RMOVL_DIV_RNK__c=100
                                                           , LOA1_NET_SLS_SPPY_AMT__c=1000.00
                                                           , NET_SLS_PLAN_SPPY_AMT__c=1555000.00
                                                           , LOA1_NET_SLS_PLAN_SPPY_AMT__c=1000.00
                                                           , TITLD_STF_SPPY_CNT__c=9
                                                           , TITL_0_STF_SPPY_CNT__c=9
                                                           , APPT_DIV_RNK__c=100
                                                           , UPR_SPPY_CNT__c=9
                                                           , APPT_PLAN_CNT__c=12
                                                           , LOA_1_6_NET_SLS_PLAN_AMT__c=322000.00
                                                           , RTURN_NET_SLS_DIV_RNK__c=100
                                                           , Analysis_Done__c=false
                                                           , RTURN_NET_SLS_SPPY_AMT__c=1550.00
                                                           , APPT_PLAN_SPPY_CNT__c=15
                                                           , NET_SLS_PLAN_AMT__c=500000.00
                                                           , RNSTMT_PLAN_SPPY_CNT__c=7
                                                           , APPT_SPPY_CNT__c=15
                                                           , ACTV_REP_PLAN_CNT__c=200
                                                           , LOA1_NET_SLS_PLAN_AMT__c=100000.00
                                                           , TITLD_STF_PLAN_SPPY_CNT__c=9
                                                           , RTURN_NET_SLS_PLAN_AMT__c=1500.00
                                                           , TITLD_STF_PLAN_CNT__c=9
                                                           , SLS_ORG_SUMRY_KEY__c = salesOrgSummaryKey); 
        
      insert sos;
        
     
    
	    ALMAppointmentServiceSoap.Appointment a = new ALMAppointmentServiceSoap.Appointment();
	    a.ACCT_NR = '06968021';
	    a.Appointment_Campaign='201210';
	    a.Appointment_Date= System.Today();
	    a.DOB=System.Today().addYears(21);
	    a.Email='rama.chintalapati@avon.com';
	    a.Error_Message='';
	    a.Error_Type='';   
	    a.First_Name='Rama'; 
	    a.Has_Errors=false;
	    a.Home_Phone='111111111';
	    a.Last_Name='Chintalapati';
	    a.Mailplan_NR='1';
	    a.Mobile='2222222222';
	    a.MRKT_SLS_ORG_KEY='2';    
	    a.MRKT_ID='XX';
	    a.MRKT_SLS_ORG_KEY='1';
	    a.Phone='3333333333'; 
	    a.Rep_Status='1';
	    a.Response_Salesforce_Id=''; 
	    a.UPLN_ACCT_NR=mktIdKey; 
	    a.Zone='1';
	    
	    list<ALMAppointmentServiceSoap.Appointment> aList = new list<ALMAppointmentServiceSoap.Appointment>();
	    aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a},'TEST');
	    
	    //System.Assert('UPLINE_ACCOUNT_NOT_FOUND' == a.Error_Type);
	    
	    a.UPLN_ACCT_NR = mktIdKey;
	    a.ACCT_NR = '06968022';
	    a.Error_Type = '';
	    
	    aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
	    System.debug('::::rep1:::>:'+rep1);
	    System.Debug(':::aList::::>'+aList);
//	    System.AssertEquals('DUPLICATE_VALUE',a.Error_Type);
	    
	    ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', 
                                                ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = con1.Id,
                                                MRKT_KEY__c = mrkt.Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.NEXT_1_CMPGN_NR__c + mktIdKey,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,
                                                Genealogy_Key__c = mrkt.Market_ID__c+mrkt.NEXT_1_CMPGN_NR__c+mktIdKey,
                                                SLS_ZONE_CD__c = 'ttt'
                                            );
      insert rep2;
	    aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
	    System.Debug(':::::::>Error_Type::::::>' + a.Error_Type);
//	    System.AssertEquals('DUPLICATE_VALUE',a.Error_Type);
	    
       a.UPLN_ACCT_NR=mktIdKey+'x';
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       a.UPLN_ACCT_NR=null;
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       a.UPLN_ACCT_NR=mktIdKey;
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       a.Last_Name=null;
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       a.Last_Name='boogieman';
       a.Rep_Status= 'owhataschmuckliam';
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       a.Rep_Status= '1';
       a.ACCT_NR='11111'; 
       a.UPLN_ACCT_NR=mktIdKey; 
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       a.UPLN_ACCT_NR='11111';
       a.ACCT_NR='2222';//add appointemnt to appointemnt  
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       mrkt.Batch_Load_In_Process__c = true;
       update mrkt;//test batch load in process
       a.UPLN_ACCT_NR=mktIdKey;
       aList = ALMAppointmentServiceSoap.upsertOrderObject(new list<ALMAppointmentServiceSoap.Appointment>{a}, 'NATHAN');
       
       mrkt.Batch_Load_In_Process__c = false;
       update mrkt;//test batch load in process
       
       
	    
    }
}