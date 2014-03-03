/***************************************************************************
 Name           : Test_cls_My_Sales_Leaders_Genealogy
 Madified By    : Saurabh Gupta (JDC)
 Description    : Test class for cls_My_Sales_Leaders_Genealogy
 Modified Date  : Nov 09, 2013                
****************************************************************************/
@isTest
private class Test_cls_My_Sales_Leaders_Genealogy {

	//----------------------------------------------------------------------------
    // Method Name  : testClsMySalesLeadersGenealogy
    // Description  : Method for Test Coverage of Class : cls_My_Sales_Leaders_Genealogy
    //----------------------------------------------------------------------------
    static testMethod void testClsMySalesLeadersGenealogy() {
    	
    	String mrktKey = 'XX';
    	
    	//Create Object: ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create Object: User
		User testUsr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
		testUsr.MRKT_ID__c = mrktKey;
		testUsr.ACCT_NR__c = mrktKey;
		insert testUsr;
		
		//Create Object: Market__c
		Market__c mrkt;
		
		system.runAs(testUsr) {
			mrkt = TestDataHelper.createMarket(mrktKey, false);
			mrkt.Market_Id__c = mrktKey;
			mrkt.Allow_Freeform_Email__c = 'Avon Leader; Avon Division Manager';
        	mrkt.Genealogy_Report_Configurable__c = 'Id,ACCT_NR__c,Contact_Key__r.Shortened_Name__c,CMPGN_NR__c,Contact_Key__c,Contact_Key__r.Name,Contact_Key__r.SLS_ZONE_CD__c,EXEC_GEN_CNT__c,EXEC_GEN_INDX__c,EXEC_RSNG_STR_IND__c,Leadership_Summary_Key__c,Market_ID__c,Personal_Performance_Key__c,RSNG_STR_IND__c,UPLN_GEN_INDX__c,UPLN_ACCT_NR__c,SUBMTD_AWRD_SLS_AMT__c,GRP_SUBMTD_AWRD_SLS_AMT__c,GRP_BLCKD_UNIT_SLS_AMT__c,GENTRTN_1_ACTV_REP_CNT__c,TTL_LEG_CNT__c,GENRTN_1_TITL_1_STF_CNT__c,GENRTN_1_TITL_2_STF_CNT__c,GENRTN_1_TITL_3_STF_CNT__c,GENRTN_1_TITL_4_STF_CNT__c,LDRSHP_TITL_LVL_NR__c';
			insert mrkt;
		}
		
		Map <String,String> titlesMap = new Map <String,String>();
		Map <String,String> LeaderStylesMap = new Map <String,String>();
		List <Genealogy_Leader_Level__c> genLeaderLevelList = new List <Genealogy_Leader_Level__c>();
		
		//Create Object: List of Leader_Title__c
		List <Leader_Title__c> ldrTitleList = TestDataHelper.createLeaderTitlesList(mrkt.Id, mrkt.Market_Id__c, true);
       	
       	for (Leader_Title__c leaderTitle : ldrTitleList) {
       		titlesMap.put(leaderTitle.LDRSHP_TITL_LVL_NR__c,leaderTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
            Genealogy_Leader_Level__c genLeader = new Genealogy_Leader_Level__c();
            genLeader.LDRSHP_TITL_LVL_NR__c = leaderTitle.LDRSHP_TITL_LVL_NR__c;
            genLeader.Color__c = '#FFFFFF';
            genLeader.MRKT_ID__c = mrkt.Market_Id__c;
            genLeader.Name = mrkt.Market_Id__c + '-' + leaderTitle.LDRSHP_TITL_LVL_NR__c;
            LeaderStylesMap.put(genLeader.LDRSHP_TITL_LVL_NR__c, '#FFFFFF');
            
            genLeaderLevelList.add(genLeader);
       	}
        
        insert genLeaderLevelList;
        update ldrTitleList;
        
        //Creating Object : Calendar__c
        List <Calendar__c> calList = new List <Calendar__c>();
        Calendar__c cal1 = TestDataHelper.createCalendar(201203.00, mrkt.Market_Id__c, 2012, mrkt.Id, false);
        cal1.Name = 'TestCal1';
        calList.add(cal1);
        
        Calendar__c cal2 = TestDataHelper.createCalendar(201202.00, mrkt.Market_Id__c, 2012, mrkt.Id, false);
        cal2.Name = 'TestCal2';
        calList.add(cal2);
        
        Calendar__c cal3 = TestDataHelper.createCalendar(201201.00, mrkt.Market_Id__c, 2012, mrkt.Id, false);
        cal3.Name = 'TestCal3';
        calList.add(cal3);

		insert calList;
		
		//Create Object: Account
		Account acct = TestDataHelper.createAccount('Test Account', 'USD', true);
		
		//Create Object: Contact
		List <Contact> conList = new List <Contact>();
	    Contact con1 = TestDataHelper.createContact('1234', acct.Id, false);
	    con1.AccountId = acct.Id;
	    con1.ACCT_NR__c = mrktKey;
		con1.Email = 'test1@avon.com';
		con1.FirstName = mrktKey + 'First1';
		con1.LastName = mrktKey + 'Last1';
		con1.HomePhone='9999999999';
		con1.LDRSHP_PRGRM_IND__c = 'Y';
		con1.LDRSHP_RPT_SLS_ZONE_CD__c = 'XZ1';
		con1.MRKT_ACCT_KEY__c = mrkt.Market_Id__c + mrktKey;
		con1.MRKT_ID__c = mrkt.Market_Id__c;
		con1.PATD_CERTFCTN_LVL_A_IND__c = 'Y';
		con1.PATD_CERTFCTN_LVL_D_IND__c = 'Y';
		con1.PATD_CERTFCTN_LVL_P_IND__c = 'Y';
		con1.PATD_CERTFCTN_LVL_T_IND__c = 'Y';
		con1.REP_ADDR_STR_2_TXT__c = 'Address 2';
		con1.REP_ADDR_STR_3_TXT__c = 'Address 3';
		con1.REP_ADDR_STR_4_TXT__c = 'Address 4';
		con1.REP_APPT_DT__c = System.today();
		con1.REP_LANG_CD__c = 'en_US';
		con1.SLS_ZONE_CD__c = 'XZ1';
		con1.REP_MOBILE_PHON_NR__c = '1234546789';
        con1.OwnerId = testUsr.Id;
	    conList.add(con1);
		
		Contact con2 = TestDataHelper.createContact('12345', acct.Id, false);
		con2.AccountId = acct.Id;
	    con2.ACCT_NR__c = mrktKey + '01';
		con2.Email = 'test2@avon.com';
		con2.FirstName = mrktKey + 'First2';
		con2.LastName = mrktKey + 'Last2';
		con2.HomePhone='9999999999';
		con2.LDRSHP_PRGRM_IND__c = 'Y';
		con2.LDRSHP_RPT_SLS_ZONE_CD__c = 'XZ1';
		con2.MRKT_ACCT_KEY__c = mrkt.Market_Id__c + mrktKey + '01';
		con2.MRKT_ID__c = mrkt.Market_Id__c;
		con2.PATD_CERTFCTN_LVL_A_IND__c = 'Y';
		con2.PATD_CERTFCTN_LVL_D_IND__c = 'Y';
		con2.PATD_CERTFCTN_LVL_P_IND__c = 'Y';
		con2.PATD_CERTFCTN_LVL_T_IND__c = 'Y';
		con2.REP_ADDR_STR_2_TXT__c = 'Address 2';
		con2.REP_ADDR_STR_3_TXT__c = 'Address 3';
		con2.REP_ADDR_STR_4_TXT__c = 'Address 4';
		con2.REP_APPT_DT__c = System.today();
		con2.REP_LANG_CD__c = 'en_US';
		con2.SLS_ZONE_CD__c = 'XZ1';
		con2.REP_MOBILE_PHON_NR__c = '1234546789';
        con2.OwnerId = testUsr.Id;
	    conList.add(con2);
	    
	    Contact con3 = TestDataHelper.createContact('12346', acct.Id, false);
	    con3.AccountId = acct.Id;
	    con3.ACCT_NR__c = mrktKey + '02';
		con3.Email = 'test3@avon.com';
		con3.FirstName = mrktKey + 'First3';
		con3.LastName = mrktKey + 'Last3';
		con3.HomePhone='9999999999';
		con3.LDRSHP_PRGRM_IND__c = 'Y';
		con3.LDRSHP_RPT_SLS_ZONE_CD__c = 'XZ1';
		con3.MRKT_ACCT_KEY__c = mrkt.Market_Id__c + mrktKey + '02';
		con3.MRKT_ID__c = mrkt.Market_Id__c;
		con3.PATD_CERTFCTN_LVL_A_IND__c = 'Y';
		con3.PATD_CERTFCTN_LVL_D_IND__c = 'Y';
		con3.PATD_CERTFCTN_LVL_P_IND__c = 'Y';
		con3.PATD_CERTFCTN_LVL_T_IND__c = 'Y';
		con3.REP_ADDR_STR_2_TXT__c = 'Address 2';
		con3.REP_ADDR_STR_3_TXT__c = 'Address 3';
		con3.REP_ADDR_STR_4_TXT__c = 'Address 4';
		con3.REP_APPT_DT__c = System.today();
		con3.REP_LANG_CD__c = 'en_US';
		con3.SLS_ZONE_CD__c = 'XZ1';
		con3.REP_MOBILE_PHON_NR__c = '1234546789';
        con3.OwnerId = testUsr.Id;
	    conList.add(con3);
	    
	    Contact con4 = TestDataHelper.createContact('12347', acct.Id, false);
	   	Con4.AccountId = acct.Id;
	    con4.ACCT_NR__c = mrktKey + '02';
		con4.Email = 'test4@avon.com';
		con4.FirstName = mrktKey + 'First3';
		con4.LastName = mrktKey + 'Last3';
		con4.HomePhone='9999999999';
		con4.LDRSHP_PRGRM_IND__c = 'Y';
		con4.LDRSHP_RPT_SLS_ZONE_CD__c = 'XZ1';
		con4.MRKT_ACCT_KEY__c = mrkt.Market_Id__c + mrktKey + '03';
		con4.MRKT_ID__c = mrkt.Market_Id__c;
		con4.PATD_CERTFCTN_LVL_A_IND__c = 'Y';
		con4.PATD_CERTFCTN_LVL_D_IND__c = 'Y';
		con4.PATD_CERTFCTN_LVL_P_IND__c = 'Y';
		con4.PATD_CERTFCTN_LVL_T_IND__c = 'Y';
		con4.REP_ADDR_STR_2_TXT__c = 'Address 2';
		con4.REP_ADDR_STR_3_TXT__c = 'Address 3';
		con4.REP_ADDR_STR_4_TXT__c = 'Address 4';
		con4.REP_APPT_DT__c = System.today();
		con4.REP_LANG_CD__c = 'en_US';
		con4.SLS_ZONE_CD__c = 'XZ1';
		con4.REP_MOBILE_PHON_NR__c = '1234546789';
        con4.OwnerId = testUsr.Id;
	    conList.add(con4);
	    
	    insert conList;
	    
	    //Creating Leadership Summary
        List <Leader_Downline_Summary__c> leaderDownLineList = new List <Leader_Downline_Summary__c>();
		Leader_Downline_Summary__c leaderDownLineOne = TestDataHelper.createLeaderDownlineSummary(conList[0], mrkt, false);
		leaderDownLineList.add(leaderDownLineOne);
		
		Leader_Downline_Summary__c leaderDownLineTwo = TestDataHelper.createLeaderDownlineSummary(conList[1], mrkt, false);
		leaderDownLineList.add(leaderDownLineTwo);
		
		Leader_Downline_Summary__c leaderDownLineThree = TestDataHelper.createLeaderDownlineSummary(conList[2], mrkt, false);
		leaderDownLineList.add(leaderDownLineThree);
		
		insert leaderDownLineList;
		
		//Create Object: My_Business__c
		List <My_Business__c> myBusList = new List <My_Business__c>();
		My_Business__c myBusOne = TestDataHelper.createMyBusiness(conList[0], mrkt, false);
		myBusList.add(myBusOne);
		
		My_Business__c myBusTwo = TestDataHelper.createMyBusiness(conList[1], mrkt, false);
		myBusTwo.LDRSHP_TITL_LVL_NR__c = '2';
		myBusList.add(myBusTwo);
		
		My_Business__c myBusThree = TestDataHelper.createMyBusiness(conList[2], mrkt, false);
		myBusList.add(myBusThree);
		
		insert myBusList;
		        
        // Create Object: ALM_Rep_Performance_1__c
        List <ALM_Rep_Performance_1__c> almReplist = new List<ALM_Rep_Performance_1__c>();
        
        ALM_Rep_Performance_1__c almRepOne = TestDataHelper.createRepPerformance(conList[0].Id, mrkt, mrktKey, false);
        almRepOne.Name = 'Test REP1';
        almRepOne.ACCT_NR__c = mrktKey;
        almRepOne.Genealogy_Level__c = 1;
		almRepOne.CurrencyISOCode = 'USD';
		almRepOne.MRKT_ID__c = mrkt.Market_ID__c;
		almRepOne.MRKT_ACCT_KEY__c = conList[0].Id;
		almRepOne.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
		almRepOne.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
		almRepOne.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mrktKey;
		almRepOne.REP_OMS_STUS_CD__c = '1';
		almRepOne.AVON_LOA_1_6_IND__c = 'Y';
		almRepOne.LDRSHP_LOA_NR__c = 1;
		almRepOne.LDRSHP_TITL_LVL_NR__c = '1';
		almRepOne.ROOT_UPLN_ACCT_NR__c = '1';
		almRepOne.LFT_ND_ID__c = 1;
		almRepOne.RGT_ND_ID__c = 8;
		almRepOne.MRKT_KEY__c = mrkt.Id;
        almReplist.add(almRepOne);
        
        ALM_Rep_Performance_1__c almRepTwo = TestDataHelper.createRepPerformance(conList[1].Id, mrkt, mrktKey, false);
        almRepTwo.Name = 'Test REP1';
        almRepTwo.ACCT_NR__c = mrktKey + '01';
        almRepTwo.UPLN_ACCT_NR__c = mrktKey;
        almRepTwo.Genealogy_Level__c = 1;
		almRepTwo.CurrencyISOCode = 'USD';
		almRepTwo.MRKT_ID__c = mrkt.Market_ID__c;
		almRepTwo.MRKT_ACCT_KEY__c = conList[1].Id;
		almRepTwo.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
		almRepTwo.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
		almRepTwo.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mrktKey + + '01';
		almRepTwo.REP_OMS_STUS_CD__c = '1';
		almRepTwo.AVON_LOA_1_6_IND__c = 'Y';
		almRepTwo.LDRSHP_LOA_NR__c = 1;
		almRepTwo.LDRSHP_TITL_LVL_NR__c = '1';
		almRepTwo.ROOT_UPLN_ACCT_NR__c = '1';
		almRepTwo.LFT_ND_ID__c = 2;
		almRepTwo.RGT_ND_ID__c = 7;
        almReplist.add(almRepTwo);
        
        ALM_Rep_Performance_1__c almRepThree = TestDataHelper.createRepPerformance(conList[2].Id, mrkt, mrktKey, false);
        almRepThree.Name = 'Test REP1';
        almRepThree.ACCT_NR__c = mrktKey + '02';
        almRepthree.UPLN_ACCT_NR__c = mrktKey + '01';
        almRepThree.Genealogy_Level__c = 2;
		almRepThree.CurrencyISOCode = 'USD';
		almRepThree.MRKT_ID__c = mrkt.Market_ID__c;
		almRepThree.MRKT_ACCT_KEY__c = conList[2].Id;
		almRepThree.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
		almRepThree.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
		almRepThree.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mrktKey + + '02';
		almRepThree.REP_OMS_STUS_CD__c = '1';
		almRepThree.AVON_LOA_1_6_IND__c = 'Y';
		almRepThree.LDRSHP_LOA_NR__c = 1;
		almRepThree.LDRSHP_TITL_LVL_NR__c = '1';
		almRepThree.ROOT_UPLN_ACCT_NR__c = '1';
		almRepThree.LFT_ND_ID__c = 3;
		almRepThree.RGT_ND_ID__c = 6;
        almReplist.add(almRepThree);
        
        ALM_Rep_Performance_1__c almRepFour = TestDataHelper.createRepPerformance(conList[3].Id, mrkt, mrktKey, false);
        almRepFour.Name = 'Test REP1';
        almRepFour.ACCT_NR__c = mrktKey + '03';
        almRepFour.UPLN_ACCT_NR__c = mrktKey + '02';
        almRepFour.Genealogy_Level__c = 3;
		almRepFour.CurrencyISOCode = 'USD';
		almRepFour.MRKT_ID__c = mrkt.Market_ID__c;
		almRepFour.MRKT_ACCT_KEY__c = conList[3].Id;
		almRepFour.FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c);
		almRepFour.OPERTNL_CMPGN_NR__c = mrkt.CMPGN_NR__c;
		almRepFour.Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mrktKey + '03';
		almRepFour.REP_OMS_STUS_CD__c = '1';
		almRepFour.AVON_LOA_1_6_IND__c = 'Y';
		almRepFour.LDRSHP_LOA_NR__c = 1;
		almRepFour.LDRSHP_TITL_LVL_NR__c = '2';
		almRepFour.ROOT_UPLN_ACCT_NR__c = '1';
		almRepFour.EXEC_TITL_IND__c = 'Y';
		almRepFour.RSNG_STR_IND__c = 'Y';
		almRepFour.LFT_ND_ID__c = 4;
		almRepFour.RGT_ND_ID__c = 5;
        almReplist.add(almRepFour);
        
        insert almReplist;
		
		//Create Object: Report_Config__c
        List <Report_Config__c> reportConfigList = TestDataHelper.createReportConfig(mrkt.Id, true);
		
		Test.startTest();
		PageReference pageRef = Page.My_Sales_Leaders_Genealogy;
        PageRef.getParameters().put('pgId', '18');
        PageRef.getHeaders().put('USER-AGENT', 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        pageRef.getParameters().put('Campaign', mrkt.CMPGN_NR__c);
        pageRef.getParameters().put('acctkey', testUsr.ACCT_NR__c);
        Test.setCurrentPage(pageRef);
        
        System.runAs(testUsr) {
            cls_My_Sales_Leaders_Genealogy gen_Controller = new cls_My_Sales_Leaders_Genealogy();
            gen_Controller.filterReport();
            gen_Controller.callRepDetails();
            gen_Controller.reportRedirect();
            gen_Controller.getOmniturePageName();
            gen_Controller.getReportTypesOptions();
        	cls_My_Sales_Leaders_Genealogy.s_GetDetails(String.valueOf(mrkt.Market_Id__c + testUsr.ACCT_NR__c), mrkt.CMPGN_NR__c);
        	System.assertEquals(gen_Controller.s_IsImpersonated, true);
        }
        
        PageReference pageRef1 = Page.My_Sales_Leaders_Genealogy;
        PageRef1.getParameters().put('pgId', '18');
        PageRef1.getHeaders().put('USER-AGENT', 'XX');
        pageRef1.getParameters().put('repDetailAcctNbr', 'XX');
        Test.setCurrentPage(pageRef1);
        
        System.runAs(testUsr) {
        	cls_My_Sales_Leaders_Genealogy gen_Controller1 = new cls_My_Sales_Leaders_Genealogy();
            gen_Controller1.filterReport();
            gen_Controller1.callRepDetails();
            cls_My_Sales_Leaders_Genealogy.s_GetDetails(String.valueOf(mrkt.Market_Id__c + testUsr.ACCT_NR__c), mrkt.CMPGN_NR__c);
            System.assertEquals(gen_Controller1.s_IsImpersonated, false);
        }
        
        Test.stopTest();
    }
}