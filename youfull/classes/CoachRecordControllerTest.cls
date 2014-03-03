/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CoachRecordControllerTest {
    
    static testMethod void testCoachController() {
        // TO DO: implement unit test
        TestDataHelper testData = new TestDataHelper();
        String ldrUsrAcctNbr='100001';
        String contactAcctNbr='100002';
        Market__c mkt = testData.createMarket();
        mkt.CMPGN_NR__c='201306';
        mkt.Market_Id__c='DE';
        mkt.X90_Day_Camp_CNT__c = 1;
        mkt.Section_EUP__c = 'EG1_EL_Count\nNbr_EG2_Leaders_Total\nExecutive Volume';
        mkt.Section_Ldrship__c = 'Paid Title\nTotal Unit Sales\nG1 Sales\nG2 Sales\nG3 Sales\nBadge_Title';
        mkt.Section_PSB__c = 'Personal Sales\nReturns to Total Campaign';
        mkt.Rep_Detail_Columns__c = 'First Name\nAccount Number\nPreferred Phone Number\nCurrent President Club Status'+
                            '\nSecondary Phone Number\nBadge Title\nSponsor\nZone Manager\nZone Manager Phone'+
                            '\nBirthday\nHome Address\nMail Plan';
        mkt.LAST_UPDT_DT__c = datetime.newInstance(2013, 12, 1, 12, 30, 2);
        mkt.is_YOU_ASLF_Enabled__c = true;
        mkt.Market_Currency_Symbol__c = '$';
        mkt.isDisplayBlock__c = true;
        mkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        mkt.X90_Day_Camp_CNT__c = 6;
        update mkt;
        
        User ldrUsr = testData.createLeaderUser(ldrUsrAcctNbr);
        ldrUsr.MRKT_ID__c = mkt.Market_Id__c;
        ldrUsr.IsActive = true;
        ldrUsr.LDRSHP_TITL_LVL_NBR__c = '2';
        update ldrUsr;
        
        mkt.OwnerId = ldrUsr.Id;
        update  mkt;
        
        Calendar__c c1 = new Calendar__c(CMPGN_NR__c=201306.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013,Market__c=mkt.Id);
        insert c1;
        Calendar__c c2 = new Calendar__c(CMPGN_NR__c=201305.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013,Market__c=mkt.Id);
        insert c2;
        Calendar__c c3 = new Calendar__c(CMPGN_NR__c=201304.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013.0,Market__c=mkt.Id);
        insert c3;
        Calendar__c c4 = new Calendar__c(CMPGN_NR__c=201303.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013.0,Market__c=mkt.Id);
        insert c4;
        
        //String strUniqueKey1 = mkt.Market_Id__c + '201203' + ldrUsrAcctNbr;
        //String strUniqueKey2 = mkt.Market_Id__c + '201202' + ldrUsrAcctNbr;
        //String strUniqueKey3 = mkt.Market_Id__c + '201201' + ldrUsrAcctNbr;
        //System.debug('strUniqueKey1: '+strUniqueKey1+', strUniqueKey2: '+strUniqueKey2+', strUniqueKey3: '+strUniqueKey3);
        
        testData.createLeaderTitles();
        testData.createSellerStatus();
        testData.createSalesOrgs();
        MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mkt, ldrUsr.DFALT_ZONE_CD__c);
        
        // create contact data
        Contact contact = testData.createContact(ldrUsrAcctNbr, ldrUsr.Id);
        contact.LDR_TYP__c = 'TL';
        contact.FirstName = 'AAA';
        contact.LastName = 'BBB';
        contact.REP_MOBILE_PHON_NR__c = '987654321';
        contact.REP_HM_PHON_NR__c = '9879878878';
        contact.MRKT_SLS_ORG_KEY__c = 'Division Manager 1';
        contact.REP_BRTH_DT__c = Date.newInstance(1985, 12, 1);
        contact.REP_APPT_DT__c = Date.newInstance(2010, 12, 20);
        contact.REP_ADDR_STR_1_TXT__c = 'Street 1';
        contact.REP_ADDR_CITY_NM__c = 'City 1';
        contact.REP_ADDR_ST_NM__c = 'Street 2';
        contact.REP_ADDR_PSTL_CD__c = 'Postal Code 1';
        contact.REP_APPT_CMPGN_NR__c = '201202';
        contact.SLS_ZONE_CD__c = 'Zone 805';
        contact.MailingCity = 'PEMBO';
        contact.MailingCountry='US';
        update contact;
        //System.debug('contact.MRKT_ACCT_KEY__c---:'+contact.MRKT_ACCT_KEY__c);
		ALM_Rep_Performance_1__c personalPerform = new ALM_Rep_Performance_1__c(
						UPLN_ACCT_NR__c = contact.ACCT_NR__c,
						YTD_PRSNL_SLS_AMT__c=1000.00,
						SPPY_YTD_PRSNL_SLS_AMT__c=987.98,
						TOTAL_N_CMPGNS_PV_AMT__c=876.00,
						SPPY_TOTAL_N_CMPGNS_PV_AMT__c=1801.00,
						BAL_DUE_AMT__c=700.00, 
						BAD_DEBT_AMT__c=201305.00,
						NXT_DUE_DT__c=Date.parse('6/6/2013'),
						YTD_GRP_UNIT_SLS_AMT__c=2000.00,
						SPPY_YTD_GRP_UNIT_SLS_AMT__c=2500.00,
						TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=800.00, 
						SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=900.00,
						ACCT_NR__c=contact.ACCT_NR__c,
						LCL_TOP_SLR_LVL_KEY__c = '1',
						LDRSHP_LOA_NR__c=508	,
						LDRSHP_TITL_LVL_NR__c='5'	,
						LOA_NR__c=509,
						PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c = '2',
						RSNG_STR_IND__c='N',
						FLD_SLS_CMPGN_NR__c = 201305,
						MRKT_ID__c = mkt.Market_ID__c,
						MRKT_ACCT_KEY__c = contact.Id,
						MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
						);
		insert personalPerform;	
		System.debug('personalPerform :::'+personalPerform.MRKT_ACCT_KEY__c);	
		System.debug('contact.Id :::'+contact.Id);			
												
												
					 ALM_Rep_Performance_1__c personalPerform1 = new ALM_Rep_Performance_1__c(
					 				UPLN_ACCT_NR__c = contact.ACCT_NR__c,
									YTD_PRSNL_SLS_AMT__c=1050.00,
									SPPY_YTD_PRSNL_SLS_AMT__c=999.98,
									TOTAL_N_CMPGNS_PV_AMT__c=875.00,
									SPPY_TOTAL_N_CMPGNS_PV_AMT__c=1506.00,
									BAL_DUE_AMT__c=500.00, 
									BAD_DEBT_AMT__c=201304.00,
									NXT_DUE_DT__c=Date.parse('6/6/2013'),
									YTD_GRP_UNIT_SLS_AMT__c=2000.00,
									SPPY_YTD_GRP_UNIT_SLS_AMT__c=2500.00,
									TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=800.00, 
									SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=900.00,
									ACCT_NR__c=contact.ACCT_NR__c,
									LCL_TOP_SLR_LVL_KEY__c = '1',
									LDRSHP_LOA_NR__c=508	,
									LDRSHP_TITL_LVL_NR__c='5'	,
									LOA_NR__c=509,
									PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c = '2',
									RSNG_STR_IND__c='N',
									FLD_SLS_CMPGN_NR__c = 201304,
									MRKT_ID__c = mkt.Market_ID__c,
									MRKT_ACCT_KEY__c = contact.Id,
									MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
									);
						insert personalPerform1;
						System.debug('personalPerform1 :::'+personalPerform1.MRKT_ACCT_KEY__c);
						ALM_Rep_Performance_1__c personalPerform2 = new ALM_Rep_Performance_1__c(
									UPLN_ACCT_NR__c = contact.ACCT_NR__c,
									YTD_PRSNL_SLS_AMT__c=1150.00,
									SPPY_YTD_PRSNL_SLS_AMT__c=699.98,
									TOTAL_N_CMPGNS_PV_AMT__c=975.00,
									SPPY_TOTAL_N_CMPGNS_PV_AMT__c=1206.00,
									BAL_DUE_AMT__c=500.00, 
									BAD_DEBT_AMT__c=201306.00,
									NXT_DUE_DT__c=Date.parse('6/6/2013'),
									YTD_GRP_UNIT_SLS_AMT__c=2000.00,
									SPPY_YTD_GRP_UNIT_SLS_AMT__c=2500.00,
									TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=800.00, 
									SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=900.00,
									ACCT_NR__c=contact.ACCT_NR__c,
									LCL_TOP_SLR_LVL_KEY__c = '1',
									LDRSHP_LOA_NR__c=508	,
									LDRSHP_TITL_LVL_NR__c='5'	,
									LOA_NR__c=509,
									PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c = '2',
									RSNG_STR_IND__c='N',
									FLD_SLS_CMPGN_NR__c = 201306,
									MRKT_ID__c = mkt.Market_ID__c,
									MRKT_ACCT_KEY__c = contact.Id,
									MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
								);
								
						insert personalPerform2;			
								
								
				Sales_Leader_History__c salesLeaderHistory = new Sales_Leader_History__c(
								PD_TITL_LVL_NR__c='2',
								SPPY_PD_TITL_LVL_NR__c='1',
								FLD_SLS_CMPGN_NR__c = 201305.0,
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
								Contact__c = contact.Id
					);	
					insert salesLeaderHistory;		
					System.debug('salesLeaderHistory :::'+salesLeaderHistory.Contact__c);
					Sales_Leader_History__c salesLeaderHistory1 = new Sales_Leader_History__c(
								PD_TITL_LVL_NR__c='2',
								SPPY_PD_TITL_LVL_NR__c='2',
								FLD_SLS_CMPGN_NR__c = 201304.0,
								GENRTN_1_TITL_10_STF_CNT__c=120,
								SPPY_GENRTN_1_TITL_10_STF_CNT__c=199,
								EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=100,
								SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=120,
								GENRTN_1_TITL_5_STF_CNT__c=100,
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
								Contact__c = contact.Id
					);	
					insert salesLeaderHistory1;
					
					Sales_Leader_History__c salesLeaderHistory2 = new Sales_Leader_History__c(
								PD_TITL_LVL_NR__c='3',
								SPPY_PD_TITL_LVL_NR__c='1',
								FLD_SLS_CMPGN_NR__c = 201303.0,
								GENRTN_1_TITL_10_STF_CNT__c=110,
								SPPY_GENRTN_1_TITL_10_STF_CNT__c=119,
								EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=110,
								SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=120,
								GENRTN_1_TITL_5_STF_CNT__c=100,
								SPPY_GENRTN_1_TITL_5_STF_CNT__c=120,
								GENRTN_1_TITL_4_STF_CNT__c=110,
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
								Contact__c = contact.Id
					);		
					
					insert salesLeaderHistory2;

        
        PageReference pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey',ldrUsrAcctNbr);
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr) {
            Test.startTest();
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();

           /* System.assertEquals(ctrl.togglePSB()==null, true);
            System.assertEquals(ctrl.toggleLeadership()==null, true);
            System.assertEquals(ctrl.toggleEUP()==null, true);*/
            ctrl.displayPSB = true;
            ctrl.displayLeadership = true;
            ctrl.displayEUP = true;
            System.assertEquals(ctrl.togglePSB()==null, true);
            System.assertEquals(ctrl.toggleLeadership()==null, true);
            System.assertEquals(ctrl.toggleEUP()==null, true);
            
            ctrl.displayPSB = null;
            ctrl.displayLeadership = null;
            ctrl.displayEUP = null;
            System.assertEquals(ctrl.displayPSB==false, true);
            System.assertEquals(ctrl.displayLeadership==false, true);
            System.assertEquals(ctrl.displayEUP==false, true);
            
            ctrl.currentUser = null;            
            //Changed by Milon on 3rd Jan 2013
            //System.assert(ctrl.getOmniturePageName4Coach()=='Coaching_Record_SL');
           /* System.assert(ctrl.getOmniturePageName4Coach()=='Coaching Record_SL');
            
            
            System.assert(ctrl.psbInfo.listPSBData.size() == 2);
            System.assert(ctrl.psbInfo.listLDRData.size() == 2);
            System.assert(ctrl.psbInfo.listEUPData.size() == 3);
            */
            //PageReference pg = ctrl.printRedirect();
            //System.assert(pg != null);
            
            ctrl.getPrintFunction();
            //System.assert(ctrl.psbInfo.listPSBData.size() == 2);
            Test.stopTest();
        }
        
        
        pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey',null);
        PageRef.getParameters().put('repDetailAcctNbr',ldrUsrAcctNbr);
        Test.setCurrentPage(pageRef);
        
        contact.REP_HM_PHON_NR__c = '';
        contact.REP_WORK_PHONE_NR__c = '9999977777';
        update contact;
        
        ldrUsr.LDRSHP_TITL_LVL_NBR__c = '-1';
        update ldrUsr;
        //updated by Milon 3rd Jan 2013. As campaign cnt cannot be more then 6
        //mkt.X90_Day_Camp_CNT__c = 7;
        mkt.X90_Day_Camp_CNT__c = 6;
        update mkt;
        System.runAs(ldrUsr) {
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();            
        }

        pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey',null);
        PageRef.getParameters().put('repDetailAcctNbr',null);
        Test.setCurrentPage(pageRef);
        
        ldrUsr.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUsr;
        
        /*mybuss1.LDRSHP_TITL_LVL_NR__c = '';
        update mybuss1;
        */
        
        mkt.X90_Day_Camp_CNT__c = 2;
        mkt.Market_Currency_Symbol__c = null;
        mkt.LAST_UPDT_DT__c = null;
        update mkt;
        System.runAs(ldrUsr) {
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
            System.debug('ctrl.personalInfo.col1--'+ctrl.personalInfo.col1);
           /* System.assert(ctrl.personalInfo.col1.size()>=6);
            System.assert(ctrl.personalInfo.col2.size() > 0);*/
        }
    }
    static testMethod void testCoachController2() {
        // TO DO: implement unit test
        TestDataHelper testData = new TestDataHelper();
        String ldrUsrAcctNbr='100001';
        String contactAcctNbr='100002';
        Market__c mkt = testData.createMarket();
        mkt.CMPGN_NR__c='201306';
        mkt.Market_Id__c='DE';
        mkt.X90_Day_Camp_CNT__c = 1;
        mkt.Section_EUP__c = 'EG1_EL_Count\nNbr_EG2_Leaders_Total\nExecutive Volume';
        mkt.Section_Ldrship__c = 'Paid Title\nTotal Unit Sales\nG1 Sales\nG2 Sales\nG3 Sales';
        mkt.Section_PSB__c = 'Personal Sales\nReturns to Total Campaign';
        mkt.Rep_Detail_Columns__c = 'First Name\nAccount Number\nPreferred Phone Number\nPresident Club Status'+
                            '\nSecondary Phone Number\nBadge Title\nSponsor\nZone Manager\nZone Manager Phone'+
                            '\nBirthday\nAppointment Date\nHome Address\nMail Plan';
        mkt.LAST_UPDT_DT__c = datetime.newInstance(2013, 12, 1, 12, 30, 2);
        mkt.is_YOU_ASLF_Enabled__c = true;
        mkt.Market_Currency_Symbol__c = '$';
        mkt.isDisplayBlock__c = true;
        mkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        mkt.X90_Day_Camp_CNT__c = 2;
        update mkt;
        
        User ldrUsr = testData.createLeaderUser(ldrUsrAcctNbr);
        ldrUsr.MRKT_ID__c = mkt.Market_Id__c;
        ldrUsr.IsActive = true;
        ldrUsr.LDRSHP_TITL_LVL_NBR__c = '-2';
        update ldrUsr;
        
        mkt.OwnerId = ldrUsr.Id;
        update  mkt;
        
        Calendar__c c1 = new Calendar__c(CMPGN_NR__c=201306.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013,Market__c=mkt.Id);
        insert c1;
        Calendar__c c2 = new Calendar__c(CMPGN_NR__c=201305.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013,Market__c=mkt.Id);
        insert c2;
        Calendar__c c3 = new Calendar__c(CMPGN_NR__c=201304.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013.0,Market__c=mkt.Id);
        insert c3;
        Calendar__c c4 = new Calendar__c(CMPGN_NR__c=201303.00,MRKT_ID__c=mkt.Market_Id__c,YEAR_NR__c=2013.0,Market__c=mkt.Id);
        insert c4;
        
        
        testData.createLeaderTitles();
        testData.createSellerStatus();
        testData.createSalesOrgs();
		MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mkt, ldrUsr.DFALT_ZONE_CD__c);
		        
        // create contact data
        Contact contact = testData.createContact(ldrUsrAcctNbr, ldrUsr.Id);
        contact.FirstName = 'VVVV';
        contact.LastName = 'SSSS';
        contact.REP_MOBILE_PHON_NR__c = '987654321';
        contact.REP_HM_PHON_NR__c = '9879878878';
        contact.MRKT_SLS_ORG_KEY__c = 'Division Manager 1';
        contact.REP_BRTH_DT__c = Date.newInstance(1985, 12, 1);
        contact.REP_APPT_DT__c = Date.newInstance(2010, 12, 20);
        contact.REP_ADDR_STR_1_TXT__c = 'Street 1';
        contact.REP_ADDR_CITY_NM__c = 'City 1';
        contact.REP_ADDR_ST_NM__c = 'Street 2';
        contact.REP_ADDR_PSTL_CD__c = 'Postal Code 1';
        contact.REP_APPT_CMPGN_NR__c = '201304';
        update contact;
        
		ALM_Rep_Performance_1__c personalPerform = new ALM_Rep_Performance_1__c(
						UPLN_ACCT_NR__c = contact.ACCT_NR__c,
						YTD_PRSNL_SLS_AMT__c=2323.00,
						SPPY_YTD_PRSNL_SLS_AMT__c=544.98,
						TOTAL_N_CMPGNS_PV_AMT__c=75.00,
						SPPY_TOTAL_N_CMPGNS_PV_AMT__c=1801.00,
						BAL_DUE_AMT__c=700.00, 
						BAD_DEBT_AMT__c=201305.00,
						NXT_DUE_DT__c=Date.parse('6/6/2013'),
						YTD_GRP_UNIT_SLS_AMT__c=2000.00,
						SPPY_YTD_GRP_UNIT_SLS_AMT__c=2500.00,
						TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=800.00, 
						SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=900.00,
						ACCT_NR__c=contact.ACCT_NR__c,
						LCL_TOP_SLR_LVL_KEY__c = '1',
						LDRSHP_LOA_NR__c=23	,
						LDRSHP_TITL_LVL_NR__c='2'	,
						LOA_NR__c=509,
						PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c = '2',
						RSNG_STR_IND__c='N',
						FLD_SLS_CMPGN_NR__c = 201305,
						MRKT_ID__c = mkt.Market_ID__c,
						MRKT_ACCT_KEY__c = contact.Id,
						MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
						);
		insert personalPerform;	
		System.debug('personalPerform :::'+personalPerform.MRKT_ACCT_KEY__c);	
		System.debug('contact.Id :::'+contact.Id);			
												
												
					 ALM_Rep_Performance_1__c personalPerform1 = new ALM_Rep_Performance_1__c(
					 				UPLN_ACCT_NR__c = contact.ACCT_NR__c,
									YTD_PRSNL_SLS_AMT__c=1050.00,
									SPPY_YTD_PRSNL_SLS_AMT__c=999.98,
									TOTAL_N_CMPGNS_PV_AMT__c=875.00,
									SPPY_TOTAL_N_CMPGNS_PV_AMT__c=1506.00,
									BAL_DUE_AMT__c=500.00, 
									BAD_DEBT_AMT__c=201304.00,
									NXT_DUE_DT__c=Date.parse('6/6/2013'),
									YTD_GRP_UNIT_SLS_AMT__c=2000.00,
									SPPY_YTD_GRP_UNIT_SLS_AMT__c=2500.00,
									TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=800.00, 
									SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=900.00,
									ACCT_NR__c=contact.ACCT_NR__c,
									LCL_TOP_SLR_LVL_KEY__c = '1',
									LDRSHP_LOA_NR__c=508	,
									LDRSHP_TITL_LVL_NR__c='1'	,
									LOA_NR__c=509,
									PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c = '2',
									RSNG_STR_IND__c='N',
									FLD_SLS_CMPGN_NR__c = 201304,
									MRKT_ID__c = mkt.Market_ID__c,
									MRKT_ACCT_KEY__c = contact.Id,
									MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
									);
						insert personalPerform1;
						System.debug('personalPerform1 :::'+personalPerform1.MRKT_ACCT_KEY__c);
						ALM_Rep_Performance_1__c personalPerform2 = new ALM_Rep_Performance_1__c(
									UPLN_ACCT_NR__c = contact.ACCT_NR__c,
									YTD_PRSNL_SLS_AMT__c=1150.00,
									SPPY_YTD_PRSNL_SLS_AMT__c=699.98,
									TOTAL_N_CMPGNS_PV_AMT__c=555.00,
									SPPY_TOTAL_N_CMPGNS_PV_AMT__c=1212.00,
									BAL_DUE_AMT__c=500.00, 
									BAD_DEBT_AMT__c=201306.00,
									NXT_DUE_DT__c=Date.parse('6/6/2013'),
									YTD_GRP_UNIT_SLS_AMT__c=2000.00,
									SPPY_YTD_GRP_UNIT_SLS_AMT__c=2500.00,
									TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=800.00, 
									SPPY_TOTAL_N_CMPGNS_GRP_UNIT_SLS__c=900.00,
									ACCT_NR__c=contact.ACCT_NR__c,
									LCL_TOP_SLR_LVL_KEY__c = '1',
									LDRSHP_LOA_NR__c=508	,
									LDRSHP_TITL_LVL_NR__c='1'	,
									LOA_NR__c=509,
									PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c = '2',
									RSNG_STR_IND__c='N',
									FLD_SLS_CMPGN_NR__c = 201306,
									MRKT_ID__c = mkt.Market_ID__c,
									MRKT_ACCT_KEY__c = contact.Id,
									MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
								);
								
						insert personalPerform2;			
								
								
				Sales_Leader_History__c salesLeaderHistory = new Sales_Leader_History__c(
								PD_TITL_LVL_NR__c='2',
								SPPY_PD_TITL_LVL_NR__c='1',
								FLD_SLS_CMPGN_NR__c = 201305.0,
								GENRTN_1_TITL_10_STF_CNT__c=454,
								SPPY_GENRTN_1_TITL_10_STF_CNT__c=22,
								EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=200,
								SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=100,
								GENRTN_1_TITL_5_STF_CNT__c=150,
								SPPY_GENRTN_1_TITL_5_STF_CNT__c=120,
								GENRTN_1_TITL_4_STF_CNT__c=100,
								SPPY_GENRTN_1_TITL_4_STF_CNT__c=171,
								GENRTN_1_TITL_3_STF_CNT__c=34,
								SPPY_GENRTN_1_TITL_3_STF_CNT__c=170,
								EXEC_UNIT_SLS__c=100,
								SPPY_EXEC_UNIT_SLS__c=100,
								EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=100,
								SPPY_EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=45,
								EXGENRTN_3_TOTAL_EXEC_TITL_STF_CNT__c=100,
								SPPY_EXGENRTN_TH_TOTAL_EXEC_TITL_STF_CNT__C=100,
								TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=22,
								SPPY_TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=55,
								CUST_CNT__c=55,
								SPPY_CUST_CNT__c=55,
								SPPY_PRSNL_SLS_AMT__c=988.00,
								GENRTN_1_APPT_CNT__c=55,
								SPPY_GENRTN_1_APPT_CNT__c=33,
								GENRTN_1_QPA_CNT__c=100,
								SPPY_GENRTN_1_QPA_CNT__c=100,
								RTURNS_PCT__c=100,
								Contact__c = contact.Id
					);	
					insert salesLeaderHistory;
					Sales_Leader_History__c salesLeaderHistory1 = new Sales_Leader_History__c(
								PD_TITL_LVL_NR__c='2',
								SPPY_PD_TITL_LVL_NR__c='2',
								FLD_SLS_CMPGN_NR__c = 201304.0,
								GENRTN_1_TITL_10_STF_CNT__c=120,
								SPPY_GENRTN_1_TITL_10_STF_CNT__c=199,
								EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=100,
								SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=120,
								GENRTN_1_TITL_5_STF_CNT__c=100,
								SPPY_GENRTN_1_TITL_5_STF_CNT__c=120,
								GENRTN_1_TITL_4_STF_CNT__c=100,
								SPPY_GENRTN_1_TITL_4_STF_CNT__c=171,
								GENRTN_1_TITL_3_STF_CNT__c=191,
								SPPY_GENRTN_1_TITL_3_STF_CNT__c=170,
								EXEC_UNIT_SLS__c=100,
								SPPY_EXEC_UNIT_SLS__c=100,
								EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=200,
								SPPY_EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c=500,
								EXGENRTN_3_TOTAL_EXEC_TITL_STF_CNT__c=100,
								SPPY_EXGENRTN_TH_TOTAL_EXEC_TITL_STF_CNT__C=300,
								TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=22,
								SPPY_TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c=55,
								CUST_CNT__c=55,
								SPPY_CUST_CNT__c=55,
								SPPY_PRSNL_SLS_AMT__c=121.00,
								GENRTN_1_APPT_CNT__c=55,
								SPPY_GENRTN_1_APPT_CNT__c=33,
								GENRTN_1_QPA_CNT__c=100,
								SPPY_GENRTN_1_QPA_CNT__c=100,
								RTURNS_PCT__c=100,
								Contact__c = contact.Id
					);	
					insert salesLeaderHistory1;
					
					Sales_Leader_History__c salesLeaderHistory2 = new Sales_Leader_History__c(
								PD_TITL_LVL_NR__c='3',
								SPPY_PD_TITL_LVL_NR__c='1',
								FLD_SLS_CMPGN_NR__c = 201303.0,
								GENRTN_1_TITL_10_STF_CNT__c=110,
								SPPY_GENRTN_1_TITL_10_STF_CNT__c=119,
								EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=110,
								SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c=120,
								GENRTN_1_TITL_5_STF_CNT__c=100,
								SPPY_GENRTN_1_TITL_5_STF_CNT__c=120,
								GENRTN_1_TITL_4_STF_CNT__c=110,
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
								SPPY_PRSNL_SLS_AMT__c=988.00,
								GENRTN_1_APPT_CNT__c=55,
								SPPY_GENRTN_1_APPT_CNT__c=33,
								GENRTN_1_QPA_CNT__c=100,
								SPPY_GENRTN_1_QPA_CNT__c=100,
								RTURNS_PCT__c=100,
								Contact__c = contact.Id
					);		
					
					insert salesLeaderHistory2;

        
        PageReference pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey',ldrUsrAcctNbr);
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr) {
            Test.startTest();
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();

            ctrl.displayPSB = true;
            ctrl.displayLeadership = true;
            ctrl.displayEUP = true;
            System.assertEquals(ctrl.togglePSB()==null, true);
            System.assertEquals(ctrl.toggleLeadership()==null, true);
            System.assertEquals(ctrl.toggleEUP()==null, true);
            
            ctrl.displayPSB = null;
            ctrl.displayLeadership = null;
            ctrl.displayEUP = null;
            System.assertEquals(ctrl.displayPSB==false, true);
            System.assertEquals(ctrl.displayLeadership==false, true);
            System.assertEquals(ctrl.displayEUP==false, true);
            
            ctrl.currentUser = null;            
            ctrl.getPrintFunction();
            Test.stopTest();
        }
        
        
        pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey',null);
        PageRef.getParameters().put('repDetailAcctNbr',ldrUsrAcctNbr);
        Test.setCurrentPage(pageRef);
        
        contact.REP_HM_PHON_NR__c = '';
        contact.REP_WORK_PHONE_NR__c = '9999977777';
        update contact;
        
        ldrUsr.LDRSHP_TITL_LVL_NBR__c = '-1';
        update ldrUsr;
        mkt.X90_Day_Camp_CNT__c = 3;
        update mkt;
        System.runAs(ldrUsr) {
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();            
        }

        pageRef = Page.BusinessPlan;
        PageRef.getParameters().put('AccKey',null);
        PageRef.getParameters().put('repDetailAcctNbr',null);
        Test.setCurrentPage(pageRef);
        
        ldrUsr.LDRSHP_TITL_LVL_NBR__c = '-2';
        update ldrUsr;
        mkt.X90_Day_Camp_CNT__c = 2;
        mkt.Market_Currency_Symbol__c = null;
        mkt.LAST_UPDT_DT__c = null;
        update mkt;
        System.runAs(ldrUsr) {
            CoachRecordController ctrl = new CoachRecordController();
            ctrl.getInitialized();
            System.debug('ctrl.personalInfo.col1--'+ctrl.personalInfo.col1);
        }
    }    
}