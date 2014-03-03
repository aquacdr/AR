public without sharing class ALMReportLabels {
    private transient static Map<String,String> COACH_LABEL;
    // map is used to generate column headers on most reports
    private transient static Map<String,String> REPORT_LABEL_MASTER;
    
    // used for column header in New Rep report
    private transient static Map<String,String> REP_FULLNAME_LABEL_MASTER;
    private transient static Map<String,String> REP_DETL_LABEL_MASTER;
    private transient static Map<String,String> REP_FILTER_LABEL_MASTER;
    private transient static Map<String,String> REP_COLGROUP_LABEL_MASTER;
    
    // map is used to generate hover links on column headers
    private transient static Map<String,String> REP_COL_SHORT;
    
    
    private transient static Map<String,String> REP_COL_HEADR;
    private transient static Map<String,String> GENEALOGY_LABEL;
    
    public transient static String reportType;
    
    
    static{
        
        //Added by Rajib for Genealogy Report
        GENEALOGY_LABEL = new Map<String,String>();
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:GRP_INVCD_BLCKD_SLS_AMT__c',System.Label.Blkd_Team_Sales);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:GRP_INVC_AWRD_SLS_AMT__c',System.Label.Team_Sales);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:PRSNL_SLS_AMT__c',System.Label.Personal_Sales);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:GENTRTN_1_ACTV_REP_CNT__c',System.Label.G1_Actives);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:GENTRTN_1_ACTV_REP_CNT__c',System.Label.G1_Actives);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:TTL_LEG_CNT__c',System.Label.Titled_Legs);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:LDRSHP_TITL_LVL_NR__c',System.Label.Title);
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:MRKT_INVC_SLS_AMT__c',System.Label.Personal_Sales);  
        GENEALOGY_LABEL.put('ALM_Rep_Performance_1:MRKT_INVC_GRP_SLS_AMT__c',System.Label.Team_Sales);  
    
    
        REPORT_LABEL_MASTER = new Map<String,String>();
        REPORT_LABEL_MASTER.put('SELECT_VALUE',System.Label.Select_Value);
        REPORT_LABEL_MASTER.put('Representative__r.CMPGN_OF_UDATE_NR__c',System.Label.Nbr_of_Campaigns);
        REPORT_LABEL_MASTER.put('ACCT_NR__c',System.Label.Account_Nbr);
        REPORT_LABEL_MASTER.put('Representative__r.Email',System.Label.eMail2);
        REPORT_LABEL_MASTER.put('Representative__r.Birthday__c',System.Label.Birthday);
        REPORT_LABEL_MASTER.put('Representative__r.HomePhone',System.Label.Home_Phone);
        
        // Change of mapping for new column display in MTO on 18feb, 2013
        //REPORT_LABEL_MASTER.put('Representative__r.INACTV_CMPGN_CNT__c',System.Label.Nbr_of_Campaigns_with_no_order);
        REPORT_LABEL_MASTER.put('INACTV_CMPGN_CNT__c',System.Label.Nbr_of_Campaigns_with_no_order);
        REPORT_LABEL_MASTER.put('LCL_TOP_SLR_LVL_KEY__c',System.Label.Top_seller_title);
        REPORT_LABEL_MASTER.put('LCL_TOP_SLR_LVL_LANG_DESC_TXT__c',System.Label.Top_seller_title);
        // EoC
        
        REPORT_LABEL_MASTER.put('Representative__r.LOA_NR__c',System.Label.Length_of_Association);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_CTT_IND__c',System.Label.Performing_at_Next_Level);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_LOA_NR__c',System.Label.Leadership_Association);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_PRGRM_IND__c',System.Label.Leadership);
        REPORT_LABEL_MASTER.put('Representative__r.MLPLN_CD__c',System.Label.Mail_Plans);
        REPORT_LABEL_MASTER.put('Representative__r.MobilePhone',System.Label.Mobile_Phone);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_TAR_IND__c',System.Label.At_Risk);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_TITL_DMTD_IND__c',System.Label.Demoted);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_TITL_LVL_NBR__c',System.Label.Current_Title);
        REPORT_LABEL_MASTER.put('Representative__r.LDRSHP_TITL_PROMTD_IND__c',System.Label.Promoted);
        REPORT_LABEL_MASTER.put('Representative__r.MRKT_TOP_SLR_LANG_KEY__c',System.Label.Seller_Status);
        REPORT_LABEL_MASTER.put('Representative__r.REP_APPT_CMPGN_NR__c',System.Label.Appointment_Campaign);
        REPORT_LABEL_MASTER.put('Representative__r.REP_APPT_DT__c',System.Label.Anniversary);
        REPORT_LABEL_MASTER.put('Representative__r.REP_RMOVL_CMPGN_NR__c',System.Label.Removal_Campaign);
        REPORT_LABEL_MASTER.put('Representative__r.REP_RNSTMT_CMPGN_NR__c',System.Label.Reinstatement_Campaign);
        REPORT_LABEL_MASTER.put('Representative__r.Representative_Phone__c',System.Label.Phone);
        REPORT_LABEL_MASTER.put('Representative__r.SLS_ZONE_CD__c',System.Label.Zone);
        REPORT_LABEL_MASTER.put('Representative__r.TERR_IND__c',System.Label.Territory_Code);
        REPORT_LABEL_MASTER.put('UPLN_GENRTN_1_ACCT_NR__c',System.Label.Upline_Acct_Nbr);
        REPORT_LABEL_MASTER.put('Representative__r.PATD_CERTFCTN_IND__c',System.Label.PATD_Certified);
        REPORT_LABEL_MASTER.put('Representative__r.PATD_CERTFCTN_LVL_A_IND__c',System.Label.Certified_A);
        REPORT_LABEL_MASTER.put('Representative__r.PATD_CERTFCTN_LVL_D_IND__c',System.Label.Certified_D);
        REPORT_LABEL_MASTER.put('Representative__r.PATD_CERTFCTN_LVL_P_IND__c',System.Label.Certified_P);
        REPORT_LABEL_MASTER.put('Representative__r.PATD_CERTFCTN_LVL_T_IND__c',System.Label.Certified_T);
        REPORT_LABEL_MASTER.put('UPLN_GENRTN_1_FULL_NM__c',System.Label.Upline);
        REPORT_LABEL_MASTER.put('UPLN_GENRTN_1_PHON_NR__c',System.Label.Upline_Phone);
        REPORT_LABEL_MASTER.put('Representative__r.MailingCity__c',System.Label.City);
        REPORT_LABEL_MASTER.put('Representative__r.MailingState__c',System.Label.State);
        REPORT_LABEL_MASTER.put('Representative__r.MailingPostalCode',System.Label.Postal_Code);
        //Current Campaign Fields and Labels
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_APPT_CNT__c',System.Label.Appointments);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_AVG_CUST_CNT__c',System.Label.Group_Avg_Customer_Count);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_AWRD_SLS_AMT__c',System.Label.Group_Award_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_INHRTD_CNT__c',System.Label.Inherited);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_NET_CHNG_CNT__c',System.Label.Downline_Change_from_Last_Campaign);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_ORD_ABV_MIN_CNT__c',System.Label.Orders_Above_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_RMOVL_CNT__c',System.Label.Removals);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_GRP_RNSTMT_CNT__c',System.Label.Reinstatements);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_NEW_REP_1ST_ORD_CNT__c',System.Label.X1st_Order);
        REPORT_LABEL_MASTER.put('Group_Sales__r.CC_TOTAL_ORD_RCVD__c',System.Label.Active_Downline);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_ACTVTY_PCT__c',System.Label.X1st_Generation_Activity);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_FRST_ORD_CNT__c',System.Label.Gen_1_First_Orders);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_APPT_CNT__c',System.Label.Gen_1_Appointments);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_AWRD_SLS_AMT__c',System.Label.X1st_Generation_Group_Award_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_INHRTD_CNT__c',System.Label.Frst_Gen_Grp_Inhrtd_cnt);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_ORD_RCVD_CNT__c',System.Label.X1st_Generation_Active_Downline);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_RMOVL_CNT__c',System.Label.Gen_1_Removals);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_RNSTMT_CNT__c',System.Label.Gen_1_Reinstatements);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_TITL_CHNG_CNT__c',System.Label.X1st_Generation_Title_Changes);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_TITL_DMTD_CNT__c',System.Label.Generation_1_Demoted);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_1_GRP_TITL_PROMTD_CNT__c',System.Label.Generation_1_Promoted);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_2_GRP_INHRTD_CNT__c',System.Label.X2nd_Generation_Inherited);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GENRTN_3_GRP_INHRTD_CNT__c',System.Label.X3rd_Generation_Inherited);
        REPORT_LABEL_MASTER.put('Group_Sales__r.GRP_QLFR_SLS_AMT__c',System.Label.Group_Qualifiers);
        REPORT_LABEL_MASTER.put('Group_Sales__r.IN_ZONE_CC_GRP_STF_CNT__c',System.Label.In_Zone_Grp_Stf_cnt);
        REPORT_LABEL_MASTER.put('Group_Sales__r.TOTAL_CTT_CNT__c',System.Label.Performing_at_Next_Level);
        REPORT_LABEL_MASTER.put('Group_Sales__r.TOTAL_GENRTN_1_STF_CNT__c',System.Label.X1st_Generation_Staff_Count);
        REPORT_LABEL_MASTER.put('Group_Sales__r.TOTAL_GRP_ADDS_CNT__c',System.Label.Additions);
        REPORT_LABEL_MASTER.put('Group_Sales__r.TOTAL_GRP_TITL_CHNG_CNT__c',System.Label.Title_Changes);
        REPORT_LABEL_MASTER.put('Group_Sales__r.TOTAL_PRMOTD_CNT__c',System.Label.Promoted_Last_Campaign);
        REPORT_LABEL_MASTER.put('Group_Sales__r.TOTAL_TAR_CNT__c',System.Label.At_Risk);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.AVG_AWRD_SLS_AMT__c',System.Label.Average_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.AVG_CUST_CNT__c',System.Label.PRSNL_AVG_CUST_CNT);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.AVG_MULT_ORD_AMT__c',System.Label.Average_Order_with_Multiples);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.AWRD_SLS_AMT__c',System.Label.Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.BAL_DUE_AMT__c',System.Label.Balance_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.BRCHR_CNT__c',System.Label.Brochures_Purchased);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.CTD_AWRD_SLS_AMT__c',System.Label.Selling_Cycle);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.CUST_CNT__c',System.Label.Customers_Served);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.DEMO_ITEM_ORDRD_CNT__c',System.Label.Demo_Items_Purchased);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.FAP_AWD_SLS_AMT__c',System.Label.FAP_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.FAP_CNT__c',System.Label.FAP_Units);
        REPORT_LABEL_MASTER.put('Personal_sales__r.FRST_ORD_IND__c',System.Label.First_Order);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.LAST_PYMT_RECVD_AMT__c',System.Label.Last_Payment_Received);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.LAST_PYMT_RECVD_DT__c',System.Label.Last_Payment_Received_Date);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.MIN_PRSNL_SLS_REQD_AMT__c',System.Label.Personal_Sales_Qual_Rpt);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.MLPLN_CLOSD_IND__c',System.Label.Mail_Plan_Closed);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.MLPLN_CLOSD_IND_TRN__c',System.Label.Mail_Plan_Closed);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.MULT_ORD_CNT__c',System.Label.Mail_Plan_Closed);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NET_SLS_AMT__c',System.Label.Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.ORD_ON_HOLD_CNT__c',System.Label.Orders_On_Hold);
       
        REPORT_LABEL_MASTER.put('Personal_Sales__r.ORD_SRCE_DESC_TXT__c',System.Label.Order_Placement_Method);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PAST_DUE_AMT__c',System.Label.Past_Due_Amount);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PAST_DUE_CMPGN_CNT__c',System.Label.Campaigns_Past_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PENDNG_ORD_AMT__c',System.Label.Pending_Order_Amount);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PENDNG_ORD_CNT__c',System.Label.Pending_Orders);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.Percent_of_Current_Net_Sales__c',System.Label.Pct_of_Current_Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.Percent_of_YTD_Net_Sales__c',System.Label.Pct_of_Year_to_Date_Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PRFRMNC_POINT_QTY__c',System.Label.Performance_Points);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PRSNL_MIN_ORD_AMT__c',System.Label.Minimum_Order_Value);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PRSNL_QLFR_SLS_AMT__c',System.Label.Personal_Qualifier);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.RTURN_AWRD_SLS_AMT__c',System.Label.Return_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.RTURN_NET_SLS_AMT__c',System.Label.Return_net_sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.YTD_AWRD_SLS_AMT__c',System.Label.YTD_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.YTD_NET_SLS_AMT__c',System.Label.YTD_Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.YTD_RTURN_NET_SLS_AMT__c',System.Label.Year_to_date_Return_Sales);
        REPORT_LABEL_MASTER.put('Runtime.MIN_TO_EARN__c',System.Label.Needed_for_Minimum);
        
        //Bad Debt - Hemanth 
        REPORT_LABEL_MASTER.put('Personal_Sales__r.BAD_DEBT_AMT__c',System.Label.Bad_Debt);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_BAD_DEBT_AMT__c',System.Label.Bad_Debt);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_BAD_DEBT_AMT__c',System.Label.Bad_Debt);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_BAD_DEBT_AMT__c',System.Label.Bad_Debt);

        //Prior Campaign Fields and Labels
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_ACTVTY_PCT__c',System.Label.Activity);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_APPT_CNT__c',System.Label.Appointments);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_AWRD_SLS_AMT__c',System.Label.Group_Award_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_CUST_CNT__c',System.Label.Group_Customers_Served);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_ERNGS_PD_AMT__c',System.Label.Earnings_Paid);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_NET_SLS_AMT__c',System.Label.Group_Net_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_NO_ORD_CNT__c',System.Label.Orders_Not_Submitted);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_ORD_ABV_MIN_CNT__c',System.Label.Orders_Achieving_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_ORD_ON_HOLD_CNT__c',System.Label.Group_Orders_on_Hold);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_ORD_UND_MIN_CNT__c',System.Label.Orders_Under_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_PAST_DUE_AMT__c',System.Label.Group_Past_Due);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_PD_SLS_AMT__c',System.Label.Group_Paid_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_RMOVL_CNT__c',System.Label.Removals);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_RNSTMT_CNT__c',System.Label.Reinstatements);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_GRP_RTURN_AMT__c',System.Label.Group_Return_Amount);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_IN_ZONE_GRP_STF_CNT__c',System.Label.In_Zone_Grp_Stf_cnt);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_MULT_ORD_CNT__c',System.Label.Group_Orders_with_Multiples);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_OUT_ZONE_GRP_STF_CNT__c',System.Label.Out_of_Zone_Staff_Count);
        REPORT_LABEL_MASTER.put('Group_Sales__r.PC_TOTAL_ORD_RCVD__c',System.Label.Active_Downline);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_AVG_AWRD_SLS_AMT__c',System.Label.Average_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_AWRD_SLS_AMT__c',System.Label.Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_BAL_DUE_AMT__c',System.Label.Balance_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_CUST_CNT__c',System.Label.Customers_Served);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_FAP_AWD_SLS_AMT__c',System.Label.FAP_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_FAP_CNT__c',System.Label.FAP_Units);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_MULT_ORD_CNT__c',System.Label.Orders_submitted);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_NET_SLS_AMT__c',System.Label.Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_ORD_ON_HOLD_CNT__c',System.Label.Orders_on_Hold);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_PAST_DUE_AMT__c',System.Label.Past_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_RTURN_AWRD_SLS_AMT__c',System.Label.Return_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_RTURN_NET_SLS_AMT__c',System.Label.Return_net_sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SBMTD_ORD_AMT__c',System.Label.Order_Amount);

        //Next campaign
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_APPT_CNT__c',System.Label.Appointments);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_AWRD_SLS_AMT__c',System.Label.Group_Award_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_CUST_CNT__c',System.Label.Group_Customers_Served);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_NET_SLS_AMT__c',System.Label.Group_Net_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_NO_ORD_CNT__c',System.Label.Orders_Not_Submitted);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_ORD_ABV_MIN_CNT__c',System.Label.Orders_Achieving_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_ORD_ON_HOLD_CNT__c',System.Label.Group_Orders_on_Hold);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_ORD_UND_MIN_CNT__c',System.Label.Orders_Under_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_PAST_DUE_AMT__c',System.Label.Group_Past_Due);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_PD_SLS_AMT__c',System.Label.Group_Paid_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_RMOVL_CNT__c',System.Label.Removals);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_RNSTMT_CNT__c',System.Label.Reinstatements);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_GRP_RTURN_AMT__c',System.Label.Group_Return_Amount);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_IN_ZONE_GRP_STF_CNT__c',System.Label.In_Zone_Grp_Stf_cnt);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_MULT_ORD_CNT__c',System.Label.Group_Orders_with_Multiples);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_OUT_ZONE_GRP_STF_CNT__c',System.Label.Out_of_Zone_Staff_Count);
        REPORT_LABEL_MASTER.put('Group_Sales__r.NC_TOTAL_ORD_RCVD__c',System.Label.Active_Downline);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_AVG_AWRD_SLS_AMT__c',System.Label.Average_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_AWRD_SLS_AMT__c',System.Label.Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_BAL_DUE_AMT__c',System.Label.Balance_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_CUST_CNT__c',System.Label.Customers_Served);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_FAP_AWD_SLS_AMT__c',System.Label.FAP_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_FAP_CNT__c',System.Label.FAP_Units);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_MULT_ORD_CNT__c',System.Label.Orders_submitted);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_NET_SLS_AMT__c',System.Label.Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_ORD_HOLD_AMT__c', Label.Orders_Hold_Amount);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_PAST_DUE_AMT__c',System.Label.Past_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_RTURN_AWRD_SLS_AMT__c',System.Label.Return_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_RTURN_NET_SLS_AMT__c',System.Label.Return_net_sales);

        //SPPY Labels
        REPORT_LABEL_MASTER.put('Group_Sales__r.IN_ZONE_SPPY_GRP_STF_CNT__c',System.Label.In_Zone_Grp_Stf_cnt);
        REPORT_LABEL_MASTER.put('Group_Sales__r.OUT_ZONE_SPPY_GRP_STF_CNT__c',System.Label.Out_of_Zone_Staff_Count);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_ACTVTY_PCT__c',System.Label.Activity);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_APPT_CNT__c',System.Label.Appointments);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_AWRD_SLS_AMT__c',System.Label.Group_Award_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_CUST_CNT__c',System.Label.Group_Customers_Served);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_ERNGS_PD_AMT__c',System.Label.Earnings_Paid);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_NET_SLS_AMT__c',System.Label.Group_Net_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_NO_ORD_CNT__c',System.Label.Orders_Not_Submitted);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_ORD_ABV_MIN_CNT__c',System.Label.Orders_Achieving_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_ORD_ON_HOLD_CNT__c',System.Label.Group_Orders_on_Hold);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_ORD_UND_MIN_CNT__c',System.Label.Orders_Under_Minimum);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_PAST_DUE_AMT__c',System.Label.Group_Past_Due);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_PD_SLS_AMT__c',System.Label.Group_Paid_Sales);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_RMOVL_CNT__c',System.Label.Removals);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_RNSTMT_CNT__c',System.Label.Reinstatements);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_RTURN_AMT__c',System.Label.Group_Return_Amount);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SPPY_MULT_ORD_CNT__c',System.Label.Group_Orders_with_Multiples);
        REPORT_LABEL_MASTER.put('Group_Sales__r.SSPY_TOTAL_ORD_RCVD__c',System.Label.Active_Downline);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_RTURN_NET_SLS_AMT__c',System.Label.Return_net_sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_AWRD_SLS_AMT__c',System.Label.Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_BAL_DUE_AMT__c',System.Label.Balance_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_CMPGN_AVG_AWRD_SLS_AMT__c',System.Label.Average_Award_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_CUST_CNT__c',System.Label.Customers_Served);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_MULT_ORD_CNT__c',System.Label.Orders_submitted);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_NET_SLS_AMT__c',System.Label.Net_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_ORD_ON_HOLD_CNT__c',System.Label.Orders_on_Hold);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_PAST_DUE_AMT__c',System.Label.Past_Due);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SPPY_RTURN_NET_SLS_AMT__c',System.Label.Return_net_sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.ORD_HOLD_AMT__c',System.Label.Orders_Hold_Amount);
        REPORT_LABEL_MASTER.put('Group_Sales__r.OUT_ZONE_CC_GRP_STF_CNT__c',System.Label.Out_of_Zone_Staff_Count);
        REPORT_LABEL_MASTER.put('Representative__r.TRNDSTTR_IND__c',System.Label.TrendSetter);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_SBMTD_ORD_AMT__c',System.Label.Order_Amount);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_ORD_HOLD_AMT__c',System.Label.Orders_Hold_Amount);
        REPORT_LABEL_MASTER.put('Group_Sales__r.ACTVTY_PCT__c',System.Label.Activity);      
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_ORD_SBMTD_AMT__c',System.Label.Order_Amount);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_ORD_INV_CNT__c',System.Label.Order_Invoiced);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_ORD_INV_CNT__c',System.Label.Order_Invoiced);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.ORD_INV_CNT__c',System.Label.Order_Invoiced);        
        REPORT_LABEL_MASTER.put('Personal_Sales__r.PC_GRP_SBMTD_ORD_CNT__c',System.Label.Orders_submitted);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.NC_GRP_SBMTD_ORD_CNT__c',System.Label.Orders_submitted);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.SBMTD_ORD_CNT__c',System.Label.Orders_submitted); 
        REPORT_LABEL_MASTER.put('Personal_Sales__r.MY_BUS_MRKT_TAG_6_PCT__c',System.Label.Leadership_Sales);
        REPORT_LABEL_MASTER.put('Personal_Sales__r.MY_BUS_MRKT_TAG_2_AMT__c',System.Label.Recruit_Orders_Count);
        
        //SA 4-25-2012: added new mappings for the 'my team' report columns
        REPORT_LABEL_MASTER.put('UPLN_GEN_INDX__c',System.Label.Generation);
        REPORT_LABEL_MASTER.put('TITL_STUS__c',System.Label.Title_Status_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.FirstName',System.Label.FirstName_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.LastName',System.Label.LastName_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.FirstName,MRKT_ACCT_KEY__r.LastName',System.Label.First_Last_Name);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.LastName,MRKT_ACCT_KEY__r.FirstName',System.Label.Last_First_Name);
        REPORT_LABEL_MASTER.put('BRNCH_SCTN_CD__c',System.Label.Branch_Number_Short);
        REPORT_LABEL_MASTER.put('BRNCH_NM__c',System.Label.Branch_Number_Short);
        
        REPORT_LABEL_MASTER.put('GENRTN_1_TITL_0_STF_CNT__c',System.Label.G1_Candidate);
        
        
        REPORT_LABEL_MASTER.put('SLS_ZONE_CD__c',System.Label.Zone_Number_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.ACCT_NR__c',System.Label.Account_Number_Short);
      //REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c',System.Label.eMail2);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.Email',System.Label.eMail2);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.Representative_Phone__c',System.Label.Home_Phone);
        REPORT_LABEL_MASTER.put('UPLN_ACCT_KEY__r.Name',System.Label.Sponsor_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.REP_BRTH_DT__c',System.Label.Birthday_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.REP_APPT_DT__c',System.Label.Anniversary_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.BIRTH_DATE__c',System.Label.Birthday_Short);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.Anniversary_Date__c',System.Label.Anniversary_Short);
        REPORT_LABEL_MASTER.put('LDRSHP_TITL_LVL_NR__c',System.Label.Badge_Title_Short);  
        REPORT_LABEL_MASTER.put('PD_TITL_LVL_NR__c',System.Label.Paid_Title);
        
        if(reportType != ALMConstants.REPORT_TYPE_MYTEAM_REPORT && reportType != AlMConstants.REPORT_TYPE_MYTEAM_ORDER)
        {
            REPORT_LABEL_MASTER.put('GRP_UNIT_SLS_AMT__c',System.Label.Group_Sales);
            REPORT_LABEL_MASTER.put('MRKT_INVC_GRP_SLS_AMT__c',System.Label.Group_Sales);
        }
        else
        {
            REPORT_LABEL_MASTER.put('GRP_UNIT_SLS_AMT__c',System.Label.Team_Prsnl_Vol_Short);
            REPORT_LABEL_MASTER.put('MRKT_INVC_GRP_SLS_AMT__c',System.Label.Group_Sales);
        }
        
        REPORT_LABEL_MASTER.put('GENRTN_1_TITL_2_STF_CNT__c',System.Label.Gen_1_UMs);
        REPORT_LABEL_MASTER.put('GENRTN_1_TITL_3_STF_CNT__c',System.Label.Gen_1_AUMs);
        REPORT_LABEL_MASTER.put('GENRTN_1_TITL_4_STF_CNT__c',System.Label.Gen_1_ELs);
        REPORT_LABEL_MASTER.put('GENRTN_1_TITL_5_STF_CNT__c',System.Label.Gen_1_SELs);
        
        
        REPORT_LABEL_MASTER.put('GRP_BLCKD_UNIT_SLS_AMT__c',System.Label.Blocked_Sales); 
        REPORT_LABEL_MASTER.put('PRSNL_SLS_AMT__c',System.Label.Personal_Sales);
        REPORT_LABEL_MASTER.put('GENTRTN_1_ACTV_REP_CNT__c',System.Label.G1_Active_Reps_Short);
        REPORT_LABEL_MASTER.put('GRP_QPA_CNT__c',System.Label.Team_Prsnl_QPA_Short);
        REPORT_LABEL_MASTER.put('GENRTN_1_QPA_CNT__c',System.Label.Team_Prsnl_QPA_Short);
        REPORT_LABEL_MASTER.put('GRP_APPT_CNT__c',System.Label.Team_Prsnl_Appt_Short);
        REPORT_LABEL_MASTER.put('GENRTN_1_APPT_CNT__c',System.Label.Team_Prsnl_Appt_Short);
        REPORT_LABEL_MASTER.put('GENRTN_1_LDR_CNT_TXT__c',System.Label.G1_Leaders_Short);
        REPORT_LABEL_MASTER.put('GRP_FAP_CNT__c',System.Label.Super_Hit_Units_Short);
        REPORT_LABEL_MASTER.put('FAP_CNT__c',System.Label.Super_Hit_Units_Short);
        REPORT_LABEL_MASTER.put('GRP_BRCHR_CNT__c',System.Label.Brochures_Ordered_Short);
        REPORT_LABEL_MASTER.put('BRCHR_CNT__c',System.Label.Brochures_Ordered_Short);
        REPORT_LABEL_MASTER.put('LST_ORD_CMPGN_NR__c',System.Label.Last_Order_Cmpgn_Short); 
        REPORT_LABEL_MASTER.put('LDRSHP_LOA_NR__c,LOA_NR__c',System.Label.LLOA_LOA);
        REPORT_LABEL_MASTER.put('LDRSHP_LOA_NR__c',System.Label.LLOA);
        REPORT_LABEL_MASTER.put('LOA_NR__c',System.Label.LOA);
        REPORT_LABEL_MASTER.put('ERNGS_PD_AMT__c',System.Label.Paid_Earnings_Short);
        REPORT_LABEL_MASTER.put('YTD_GRP_NET_SLS_AMT__c',System.Label.TY_YTD_PNet);
        REPORT_LABEL_MASTER.put('YTD_NET_SLS_AMT__c',System.Label.TY_YTD_PNet);
        REPORT_LABEL_MASTER.put('SPPY_YTD_GRP_NET_SLS_AMT__c',System.Label.LY_YTD_PNet);
        REPORT_LABEL_MASTER.put('SPPY_YTD_NET_SLS_AMT__c',System.Label.LY_YTD_PNet);
        REPORT_LABEL_MASTER.put('YTD_GRP_UNIT_SLS_AMT__c',System.Label.Annual_YTD_Short);
        REPORT_LABEL_MASTER.put('YTD_PRSNL_SLS_AMT__c',System.Label.YTD_Personal_Sales_short);
        REPORT_LABEL_MASTER.put('TTL_LEG_CNT__c',System.Label.Titled_Legs_Short);
        REPORT_LABEL_MASTER.put('GRP_MRKT_TAG_1_CNT__c',System.Label.Market_Tag_1_Short);
        REPORT_LABEL_MASTER.put('PRSNL_MRKT_TAG_1_CNT__c',System.Label.Market_Tag_1_Short);
        REPORT_LABEL_MASTER.put('GRP_MRKT_TAG_2_AMT__c',System.Label.Market_Tag_2_Short);
        REPORT_LABEL_MASTER.put('PRSNL_MRKT_TAG_2_AMT__c',System.Label.Market_Tag_2_Short);
        
        REPORT_LABEL_MASTER.put('BOOK1_GRP_UNIT_SLS_AMT__c',System.Label.Book_1_Team_Prsnl_Vol_Short);
        REPORT_LABEL_MASTER.put('BOOK2_GRP_UNIT_SLS_AMT__c',System.Label.Book_2_Team_Prsnl_Vol_Short);
        REPORT_LABEL_MASTER.put('BOOK1_BLCKD_UNIT_SLS_AMT__c',System.Label.Book_1_Team_Prsnl_Vol_Short);
        REPORT_LABEL_MASTER.put('BOOK2_BLCKD_UNIT_SLS_AMT__c',System.Label.Book_2_Team_Prsnl_Vol_Short);
        REPORT_LABEL_MASTER.put('SPPY_GRP_UNIT_SLS_AMT__c',System.Label.LY_Prsnl_Vol_Short);
        REPORT_LABEL_MASTER.put('SPPY_AWRD_SLS_AMT__c',System.Label.LY_Prsnl_Vol_Short);
        REPORT_LABEL_MASTER.put('NXT_DUE_DT__c',System.Label.Next_Due_Date_Short);
        REPORT_LABEL_MASTER.put('GRP_BAL_AMT__c',System.Label.Current_Due_Amount_Short);
        REPORT_LABEL_MASTER.put('GRP_PAST_DUE_AMT__c',System.Label.Amount_Overdue_Short);
        //end of SA 4-25-2012
        
        //start GT 5-17-2-12 Create labels for G1Appointments Report
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.CONVRSN_DT__c',System.Label.Contact_Conv_Date);
        REPORT_LABEL_MASTER.put('FRST_ORD_REQ_DT__c',System.Label.First_Ord_Req_Dat);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.PATD_CERTFCTN_LVL_A_IND__c',System.Label.Sell_Ord_Train);
        REPORT_LABEL_MASTER.put('FRST_ORDR_DT__c',System.Label.Actual_Order_Date);
        REPORT_LABEL_MASTER.put('FRST_ORDR_AMT__c',System.Label.Qualified_Order);
        REPORT_LABEL_MASTER.put('FRST_ORDER_DUE_DT__c',System.Label.Fir_Ord_Pay_By_Date);
        //end of GT 5-17-2-12 

        //for SiteMap Start Milon
        REPORT_LABEL_MASTER.put('MY DASHBOARD',System.Label.MY_DASHBOARD);
        REPORT_LABEL_MASTER.put('MY BUSINESS',System.Label.MY_BUSINESS);
        REPORT_LABEL_MASTER.put('MY DOWNLINE',System.Label.MY_DOWNLINE);
        REPORT_LABEL_MASTER.put('eTOOLS',System.Label.eTOOLS);
        REPORT_LABEL_MASTER.put('View Ecard History',System.Label.View_eCard_History);
        REPORT_LABEL_MASTER.put('Earning Illustrator',System.Label.Leadership_Earning_Illustrator);
        REPORT_LABEL_MASTER.put('My Coaching Record',System.Label.My_Coaching_Record);
        REPORT_LABEL_MASTER.put('My Business Plan',System.Label.My_Business_Plan);
        REPORT_LABEL_MASTER.put('My Earnings Statement',System.Label.My+' '+System.Label.Earning+' '+System.Label.Statement);
        REPORT_LABEL_MASTER.put('My Top Sellers',System.Label.Top_Seller);
        REPORT_LABEL_MASTER.put('My New Representatives',System.Label.New_Rep);
        REPORT_LABEL_MASTER.put('My Team',System.Label.My_Team);
        REPORT_LABEL_MASTER.put('My Team Orders',System.Label.My_Team_Orders);
        REPORT_LABEL_MASTER.put('My Executive Leaders',System.Label.My_Executive_Leaders);
        REPORT_LABEL_MASTER.put('My Team Business',System.Label.My+' '+System.Label.Team+' '+System.Label.Business);
        REPORT_LABEL_MASTER.put('My Reports',System.Label.My_Reports);
        REPORT_LABEL_MASTER.put('Rising Stars',System.Label.Rising_Stars);
        REPORT_LABEL_MASTER.put('G1 Sales Leaders',System.Label.G1SalesLeaders);
        REPORT_LABEL_MASTER.put('G1 Candidates',System.Label.Candidates);
        REPORT_LABEL_MASTER.put('G1 Appointments',System.Label.G1_Appointments);
        REPORT_LABEL_MASTER.put('Group Appointments',System.Label.Group_Appointments);
        REPORT_LABEL_MASTER.put('My_Sales_Leaders_Genealogy',System.Label.My_Sales_Leaders_Genealogy);
        
        //for SiteMap End
        
        //NRT changes added by Supriyo - August 28, 2013
        REPORT_LABEL_MASTER.put('NRT_INVC_SLS_AMT__c',System.Label.NRT_Invoiced_Personal_Volume);
        REPORT_LABEL_MASTER.put('NRT_SUBMTD_SLS_DISPLAY__c',System.Label.NRT_Submitted_Personal_Volume);
        REPORT_LABEL_MASTER.put('NRT_TOTAL_SLS_DISPLAY__c',System.Label.NRT_Total_Potential_Personal_Volume);
        REPORT_LABEL_MASTER.put('NRT_HOLD_SLS_DISPLAY__c',System.Label.NRT_Held_Personal_Volume);
        REPORT_LABEL_MASTER.put('NRT_SVD_SLS_DISPLAY__c',System.Label.NRT_Saved_Personal_Volume);
        REPORT_LABEL_MASTER.put('MRKT_INVC_SLS_AMT__c',System.Label.Personal_Sales);
        
         // Additon for Report Center - Raktim on feb 18, 2013
        REPORT_LABEL_MASTER.put('Report Center',System.Label.Report_Center);
        // Eoc 
        
        // Additon for Title Advancement - Raktim on feb 20, 2013
        REPORT_LABEL_MASTER.put('Title Advancement',System.Label.Title_Advancement);  
        REPORT_LABEL_MASTER.put('EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c',System.Label.EG_Leaders);
        REPORT_LABEL_MASTER.put('NXT_MIN_GRP_SLS_REQD_AMT__c',System.Label.Next_Title_Group_Sales);
        REPORT_LABEL_MASTER.put('NXT_MIN_G1_ACTV__c',System.Label.Next_Title_G1_Actives);
        REPORT_LABEL_MASTER.put('REQD_GENRTN_1_LDR_CNT_TXT__c',System.Label.Next_Title_G1_Leaders);
        REPORT_LABEL_MASTER.put('MIN_BLCKD_SLS_REQD_AMT__c',System.Label.Next_Title_Blocked_Group_sales);
        REPORT_LABEL_MASTER.put('NXT_BLCKD_SLS_REQD_AMT__c',System.Label.Next_Title_Blocked_Group_sales);
        REPORT_LABEL_MASTER.put('NXT_LVL_MIN_PRSNL_SLS_REQD_AMT__c',System.Label.Next_Title_in_Personal_Sales);
        REPORT_LABEL_MASTER.put('PAST_DUE_AMT__c',System.Label.Personal_Amount_Overdue);
        REPORT_LABEL_MASTER.put('BAL_DUE_AMT__c',System.Label.Current_Due_Amount);
        
        REPORT_LABEL_MASTER.put('NXT_LVL_MIN_PRSNL_SLS_REQD_AMT__c',System.Label.Next_Title_in_Personal_Sales);
        
        // Added by raktim - mail plan
        REPORT_LABEL_MASTER.put('MailPlan_Order_Oppty__r.CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c', System.Label.Days_to_Close);
        REPORT_LABEL_MASTER.put('MailPlan_Order_Oppty__r.MLPLN_CD__c', System.Label.Mail_Plans); //added subhamay_17062013_for UK market to display mailplan code
        REPORT_LABEL_MASTER.put('Total_Award_Sales__c', System.Label.Award_Sales); //added subhamay_17062013_for UK market to display mailplan code
        
        // Added by Parul Gupta - T-216798
        REPORT_LABEL_MASTER.put('MailPlan_Order_Oppty__r.MLPLN_CLOSD_IND_TRN__c', System.Label.Open_Mail_Plan);
        
        // Added by Raktim - SPONSOR on 11th Sept, 2013
        REPORT_LABEL_MASTER.put('UPLN_ACCT_NR__c', System.Label.Sponsor);
        
        //Added by MFISHER - S-158775
        REPORT_LABEL_MASTER.put('GRP_MRKT_TAG_3_TXTTRNS__c',System.Label.Grp_Mrkt_Tag3_booleanTrans);
        REPORT_LABEL_MASTER.put('PRSNL_MRKT_TAG_3_TXTTRNS__c',System.Label.PRSNL_Mrkt_Tag3_booleanTrans);
         
        //Added by Barkha - S-158775
        REPORT_LABEL_MASTER.put('LST_ORD_CMPGN_NR__c', System.Label.Last_Campaign_Order_Number);
        REPORT_LABEL_MASTER.put('DETL_CNTCT_MRKT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
        REPORT_LABEL_MASTER.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TXT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
        
        // Additon for New Rep Report - Swarnava on feb 20, 2013
       /* REP_COL_HEADR.put('NXT_DUE_DT__c',System.Label.Next_Due_Date);
        REP_COL_HEADR.put('BOOK1_GRP_UNIT_SLS_AMT__c',System.Label.C0_B1_Personal_Sales);
        REP_COL_HEADR.put('BOOK2_GRP_UNIT_SLS_AMT__c',System.Label.C0_B2_Personal_Sales);
        REP_COL_HEADR.put('BOOK1_PRSNL_SLS_AMT__c',System.Label.C0_B1_Personal_Sales);
        REP_COL_HEADR.put('BOOK2_PRSNL_SLS_AMT__c',System.Label.C0_B2_Personal_Sales);
        REP_COL_HEADR.put('GRP_BAL_AMT__c',System.Label.Current_Due_Amount);
        REP_COL_HEADR.put('GRP_PAST_DUE_AMT__c',System.Label.Amount_Overdue);
        REP_COL_HEADR.put('BAL_DUE_AMT__c',System.Label.Amount_Overdue);
        REP_COL_HEADR.put('PAST_DUE_AMT__c',System.Label.Current_Due_Amount);*/
        // Eoc
        
        REP_FULLNAME_LABEL_MASTER = new Map<String,String>();
        
        //SA 4-25-2012: added new mappings for the 'my team' report FULL column names
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.FirstName',System.Label.FirstName);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.LastName',System.Label.LastName);
        REP_FULLNAME_LABEL_MASTER.put('BRNCH_SCTN_CD__c',System.Label.Branch_Name);
        REP_FULLNAME_LABEL_MASTER.put('SLS_ZONE_CD__c',System.Label.Zone_number);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.ACCT_NR__c',System.Label.Account_Number);
      //REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c',System.Label.Preferred_Email);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.Representative_Phone__c',System.Label.Preferred_Phone_Number);
        REP_FULLNAME_LABEL_MASTER.put('UPLN_ACCT_KEY__r.Name',System.Label.Sponsor);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.REP_BRTH_DT__c',System.Label.BirthdayYOU);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.REP_APPT_DT__c',System.Label.Anniversary);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.BIRTH_DATE__c',System.Label.BirthdayYOU);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.Anniversary_Date__c',System.Label.Anniversary);
        REP_FULLNAME_LABEL_MASTER.put('LDRSHP_TITL_LVL_NR__c',System.Label.Badge_Title);  
        REP_FULLNAME_LABEL_MASTER.put('PD_TITL_LVL_NR__c',System.Label.Paid_Title);
        REP_FULLNAME_LABEL_MASTER.put('BRNCH_NM__c',System.Label.Branch_Name);
        
        //GRP_UNIT_SLS_AMT__c should be 'Team & Personal Sales' only for MT and MTO reports
        if(reportType != ALMConstants.REPORT_TYPE_MYTEAM_REPORT && reportType != AlMConstants.REPORT_TYPE_MYTEAM_ORDER)
        {
            REP_FULLNAME_LABEL_MASTER.put('GRP_UNIT_SLS_AMT__c',System.Label.ErngIllustratr_TotUnitSl);
            REP_FULLNAME_LABEL_MASTER.put('MRKT_INVC_GRP_SLS_AMT__c',System.Label.ErngIllustratr_TotUnitSl);
        }
        else
        {
            REP_FULLNAME_LABEL_MASTER.put('GRP_UNIT_SLS_AMT__c',System.Label.Team_Personal_Volume);
            REP_FULLNAME_LABEL_MASTER.put('MRKT_INVC_GRP_SLS_AMT__c',System.Label.Team_Personal_Volume);
        }
        
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_TITL_2_STF_CNT__c',System.Label.Promoted_G1_ULs);
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_TITL_3_STF_CNT__c',System.Label.Promoted_G1_AULs);
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_TITL_4_STF_CNT__c',System.Label.Promoted_G1_ELs);
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_TITL_5_STF_CNT__c',System.Label.Promoted_G1_SELs);
        
        REP_FULLNAME_LABEL_MASTER.put('GRP_BLCKD_UNIT_SLS_AMT__c',System.Label.Blocked_Total_Unit_Sales);
        REP_FULLNAME_LABEL_MASTER.put('PRSNL_SLS_AMT__c',System.Label.Total_Personal_Sales);
        REP_FULLNAME_LABEL_MASTER.put('GENTRTN_1_ACTV_REP_CNT__c',System.Label.G1_Active_Reps);
        REP_FULLNAME_LABEL_MASTER.put('GRP_QPA_CNT__c',System.Label.Team_Personal_QPA_Full);
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_QPA_CNT__c',System.Label.Team_Personal_QPA_Full);
        REP_FULLNAME_LABEL_MASTER.put('GRP_APPT_CNT__c',System.Label.Team_Personal_Appointment);
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_APPT_CNT__c',System.Label.Team_Personal_Appointment);
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_LDR_CNT_TXT__c',System.Label.G1_Leaders_Short);
        REP_FULLNAME_LABEL_MASTER.put('GRP_FAP_CNT__c',System.Label.Super_Hit_Units);
        REP_FULLNAME_LABEL_MASTER.put('FAP_CNT__c',System.Label.Super_Hit_Units);
        REP_FULLNAME_LABEL_MASTER.put('GRP_BRCHR_CNT__c',System.Label.Brochures_Ordered);
        REP_FULLNAME_LABEL_MASTER.put('BRCHR_CNT__c',System.Label.Brochures_Ordered);
        REP_FULLNAME_LABEL_MASTER.put('LST_ORD_CMPGN_NR__c',System.Label.Last_Order_Campaign);
        REP_FULLNAME_LABEL_MASTER.put('LDRSHP_LOA_NR__c,LOA_NR__c',System.Label.LLOA_LOA_Full);
        REP_FULLNAME_LABEL_MASTER.put('LDRSHP_LOA_NR__c',System.Label.Length_of_Association_in_Leadership);
        REP_FULLNAME_LABEL_MASTER.put('LOA_NR__c',System.Label.Length_of_Association);
        REP_FULLNAME_LABEL_MASTER.put('ERNGS_PD_AMT__c',System.Label.Paid_Earnings);
        REP_FULLNAME_LABEL_MASTER.put('YTD_GRP_NET_SLS_AMT__c',System.Label.TYTD_Personal_Net_Sales);
        REP_FULLNAME_LABEL_MASTER.put('YTD_NET_SLS_AMT__c',System.Label.TYTD_Personal_Net_Sales);
        REP_FULLNAME_LABEL_MASTER.put('SPPY_YTD_GRP_NET_SLS_AMT__c',System.Label.LYTD_Personal_Net_Sales);
        REP_FULLNAME_LABEL_MASTER.put('SPPY_YTD_NET_SLS_AMT__c',System.Label.LYTD_Personal_Net_Sales);
        REP_FULLNAME_LABEL_MASTER.put('YTD_GRP_UNIT_SLS_AMT__c',System.Label.Annual_YTD);
        REP_FULLNAME_LABEL_MASTER.put('YTD_PRSNL_SLS_AMT__c',System.Label.YTD_Personal_Sales);
        REP_FULLNAME_LABEL_MASTER.put('TTL_LEG_CNT__c',System.Label.Titled_Legs);
        REP_FULLNAME_LABEL_MASTER.put('GRP_MRKT_TAG_1_CNT__c',System.Label.Market_Tag_1);
        REP_FULLNAME_LABEL_MASTER.put('PRSNL_MRKT_TAG_1_CNT__c',System.Label.Market_Tag_1);
        REP_FULLNAME_LABEL_MASTER.put('GRP_MRKT_TAG_2_AMT__c',System.Label.Market_Tag_2);
        REP_FULLNAME_LABEL_MASTER.put('PRSNL_MRKT_TAG_2_AMT__c',System.Label.Market_Tag_2);
        
        REP_FULLNAME_LABEL_MASTER.put('BOOK1_GRP_UNIT_SLS_AMT__c',System.Label.Book_1_Team_Prsnl_Vol);
        REP_FULLNAME_LABEL_MASTER.put('BOOK2_GRP_UNIT_SLS_AMT__c',System.Label.Book_2_Team_Prsnl_Vol);
        REP_FULLNAME_LABEL_MASTER.put('BOOK1_BLCKD_UNIT_SLS_AMT__c',System.Label.Book_1_Team_Prsnl_Vol);
        REP_FULLNAME_LABEL_MASTER.put('BOOK2_BLCKD_UNIT_SLS_AMT__c',System.Label.Book_2_Team_Prsnl_Vol);
        REP_FULLNAME_LABEL_MASTER.put('SPPY_GRP_UNIT_SLS_AMT__c',System.Label.LY_Prsnl_Vol);
        REP_FULLNAME_LABEL_MASTER.put('SPPY_AWRD_SLS_AMT__c',System.Label.LY_Prsnl_Vol);
        REP_FULLNAME_LABEL_MASTER.put('NXT_DUE_DT__c',System.Label.Next_Due_Date);
        REP_FULLNAME_LABEL_MASTER.put('GRP_BAL_AMT__c',System.Label.Current_Due_Amount);
        REP_FULLNAME_LABEL_MASTER.put('GRP_PAST_DUE_AMT__c',System.Label.Amount_Overdue);
        
        // Added for new columns display in MTO on 18feb, 2012
        REP_FULLNAME_LABEL_MASTER.put('INACTV_CMPGN_CNT__c',System.Label.Nbr_of_Campaigns_with_no_order);
        REP_FULLNAME_LABEL_MASTER.put('LCL_TOP_SLR_LVL_KEY__c',System.Label.Top_seller_title);
        REP_FULLNAME_LABEL_MASTER.put('LCL_TOP_SLR_LVL_LANG_DESC_TXT__c',System.Label.Top_seller_title);
        
        // End of Addition
        
        // Additon for Title Advancement - Raktim on feb 20, 2013
        REP_FULLNAME_LABEL_MASTER.put('EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c',System.Label.EG_Leaders);
        REP_FULLNAME_LABEL_MASTER.put('NXT_MIN_GRP_SLS_REQD_AMT__c',System.Label.Next_Title_Group_Sales_FullName);
        REP_FULLNAME_LABEL_MASTER.put('NXT_MIN_G1_ACTV__c',System.Label.Next_Title_G1_Actives_FullName);
        REP_FULLNAME_LABEL_MASTER.put('REQD_GENRTN_1_LDR_CNT_TXT__c',System.Label.Next_Title_G1_Leaders_FullName);
        REP_FULLNAME_LABEL_MASTER.put('MIN_BLCKD_SLS_REQD_AMT__c',System.Label.Next_Title_Blocked_Group_sales);
        REP_FULLNAME_LABEL_MASTER.put('NXT_BLCKD_SLS_REQD_AMT__c',System.Label.Next_Title_Blocked_Group_sales);
        REP_FULLNAME_LABEL_MASTER.put('NXT_LVL_MIN_PRSNL_SLS_REQD_AMT__c',System.Label.Next_Title_in_Personal_Sales_FullName);
        REP_FULLNAME_LABEL_MASTER.put('PAST_DUE_AMT__c',System.Label.Personal_Amount_Overdue);
        REP_FULLNAME_LABEL_MASTER.put('BAL_DUE_AMT__c',System.Label.Current_Due_Amount);
        REP_FULLNAME_LABEL_MASTER.put('NXT_LVL_MIN_PRSNL_SLS_REQD_AMT__c',System.Label.Next_Title_in_Personal_Sales);
        //EOC
        
        //end of SA 4-25-2012
        
        // Added by raktim - mail plan
        REP_FULLNAME_LABEL_MASTER.put('MailPlan_Order_Oppty__r.CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c', System.Label.Days_to_Close);
        REP_FULLNAME_LABEL_MASTER.put('MailPlan_Order_Oppty__r.MLPLN_CD__c', System.Label.Mail_Plans); //added subhamay_17062013_for UK market to display mailplan code
        REP_FULLNAME_LABEL_MASTER.put('Total_Award_Sales__c', System.Label.Award_Sales); //added subhamay_17062013_for UK market to display mailplan code        
        REP_FULLNAME_LABEL_MASTER.put('GENRTN_1_TITL_0_STF_CNT__c',System.Label.G1_Candidate);
        
        //NRT changes added by Supriyo - August 28, 2013
        REP_FULLNAME_LABEL_MASTER.put('NRT_INVC_SLS_AMT__c',System.Label.NRT_Invoiced_Personal_Volume);
        REP_FULLNAME_LABEL_MASTER.put('NRT_SUBMTD_SLS_DISPLAY__c',System.Label.NRT_Submitted_Personal_Volume);
        REP_FULLNAME_LABEL_MASTER.put('NRT_TOTAL_SLS_DISPLAY__c',System.Label.NRT_Total_Potential_Personal_Volume);
        REP_FULLNAME_LABEL_MASTER.put('NRT_HOLD_SLS_DISPLAY__c',System.Label.NRT_Held_Personal_Volume);
        REP_FULLNAME_LABEL_MASTER.put('NRT_SVD_SLS_DISPLAY__c',System.Label.NRT_Saved_Personal_Volume);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_INVC_SLS_AMT__c',System.Label.Personal_Sales);
        
        // Added by Raktim - SPONSOR on 11th Sept, 2013
        REP_FULLNAME_LABEL_MASTER.put('UPLN_ACCT_NR__c', System.Label.Sponsor);
        
        // Added by Parul Gupta - T-216798
        REP_FULLNAME_LABEL_MASTER.put('MailPlan_Order_Oppty__r.MLPLN_CLOSD_IND_TRN__c', System.Label.Open_Mail_Plan_label);
        
        //Added by MFISHER - S-158775
        REP_FULLNAME_LABEL_MASTER.put('GRP_MRKT_TAG_3_TXTTRNS__c',System.Label.Grp_Mrkt_Tag3_booleanTrans);
        REP_FULLNAME_LABEL_MASTER.put('PRSNL_MRKT_TAG_3_TXTTRNS__c',System.Label.PRSNL_Mrkt_Tag3_booleanTrans);      
        
        
        //Added by Barkha - S-158775
        REP_FULLNAME_LABEL_MASTER.put('LST_ORD_CMPGN_NR__c', System.Label.Last_Campaign_Order_Number);
        REP_FULLNAME_LABEL_MASTER.put('DETL_CNTCT_MRKT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
        REP_FULLNAME_LABEL_MASTER.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TXT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
       
       
        //TODO:Add all the labels corresponding to the field names in here
        REP_DETL_LABEL_MASTER = new Map<String,String>();
        REP_DETL_LABEL_MASTER.put('Name',System.Label.Upline);
        REP_DETL_LABEL_MASTER.put('Upline',System.Label.Upline);
        REP_DETL_LABEL_MASTER.put('Address',System.Label.Address);
        REP_DETL_LABEL_MASTER.put('HomePhone',System.Label.Home_Phone);
        REP_DETL_LABEL_MASTER.put('MobilePhone',System.Label.Mobile_Phone);
        REP_DETL_LABEL_MASTER.put('Birthday__c',System.Label.Birthday);
        REP_DETL_LABEL_MASTER.put('REP_LANG_CD__c',System.Label.Language);
        REP_DETL_LABEL_MASTER.put('MRKT_TOP_SLR_LANG_KEY__c',System.Label.Seller_Status);
        REP_DETL_LABEL_MASTER.put('LDRSHP_TITL_LVL_NBR__c',System.Label.Title);
        REP_DETL_LABEL_MASTER.put('SLS_ZONE_CD__c',System.Label.Zone);
        REP_DETL_LABEL_MASTER.put('SLS_DIV_NM__c',System.Label.Division);
        REP_DETL_LABEL_MASTER.put('SLS_REGN_NM__c',System.Label.Region);
        REP_DETL_LABEL_MASTER.put('SLS_ZONE_MGR_FULL_NM__c',System.Label.Zone_Sales_Manager);
        REP_DETL_LABEL_MASTER.put('REP_APPT_DT__c',System.Label.Appointment_Date);
        REP_DETL_LABEL_MASTER.put('TERR_IND__c',System.Label.Territory_Code);
        REP_DETL_LABEL_MASTER.put('LOA_NR__c',System.Label.Avon_Length_of_Association);
        REP_DETL_LABEL_MASTER.put('LDRSHP_LOA_NR__c',System.Label.Length_of_Association_in_Leadership);
        REP_DETL_LABEL_MASTER.put('PATD_CERTFCTN_IND__c',System.Label.PATD_Certified);
        REP_DETL_LABEL_MASTER.put('PATD_CERTFCTN_LVL_DESC_TXT__c',System.Label.PATD_Current_Achieved_Level);
        REP_DETL_LABEL_MASTER.put('LDRSHP_TAR_IND__c',System.Label.Title_at_Risk);
        REP_DETL_LABEL_MASTER.put('MLPLN_CD__c',System.Label.Mail_Plan);
        //subhamay 0112
        REP_DETL_LABEL_MASTER.put('Zip_Code',System.Label.Zip_Code);
        //eoc subhamay 0112
        
        
        REP_FILTER_LABEL_MASTER = new Map<String,String>();
        
        //SA 4-3-2012: added new mappings for the 'my team' report filter
        //todo: change the approach to rely more on the Visulforce {!$Label[labelName]}
        REP_FILTER_LABEL_MASTER.put('Amount_Due_in_Next_7_Days', System.Label.Amount_Due_in_Next_7_Days);        
        REP_FILTER_LABEL_MASTER.put('All_Badge_Titles', System.Label.All_Badge_Titles);        
        REP_FILTER_LABEL_MASTER.put('G1_Sales_Leader', System.Label.G1_Sales_Leader);
        REP_FILTER_LABEL_MASTER.put('All_Paid_Titles', System.Label.All_Paid_Titles);
        REP_FILTER_LABEL_MASTER.put('G1_Candidate', System.Label.Candidates);
        REP_FILTER_LABEL_MASTER.put('Candidate', System.Label.Candidate);
        REP_FILTER_LABEL_MASTER.put('Rising_Stars', System.Label.Rising_Stars);
        REP_FILTER_LABEL_MASTER.put('Executive_Rising_Stars', System.Label.Executive_Rising_Stars);
        REP_FILTER_LABEL_MASTER.put('New_Title_Achievers', System.Label.New_Title_Achievers);
        REP_FILTER_LABEL_MASTER.put('Title_at_Risk_Single', System.Label.Title_at_Risk_Single);
        REP_FILTER_LABEL_MASTER.put('Title_Status_Promotions', System.Label.Title_Status_Promotions);
        REP_FILTER_LABEL_MASTER.put('Title_Status_Demotions', System.Label.Title_Status_Demotions);
        REP_FILTER_LABEL_MASTER.put('Reinstatements', System.Label.Reinstatements);
        REP_FILTER_LABEL_MASTER.put('Removed_Representatives', System.Label.Removed_Representatives);
        REP_FILTER_LABEL_MASTER.put('Inherited_Last_Campaign', System.Label.Inherited_Last_Campaign);
        REP_FILTER_LABEL_MASTER.put('First_Order_Single', System.Label.First_Order_Single);
        REP_FILTER_LABEL_MASTER.put('Personal_Order_Over_Minimum', System.Label.Personal_Order_Over_Minimum);
        REP_FILTER_LABEL_MASTER.put('Personal_Volume_Over_MOE', System.Label.Personal_Volume_Over_MOE);
        REP_FILTER_LABEL_MASTER.put('Personal_Volume_Under_MOE', System.Label.Personal_Volume_Under_MOE);
        REP_FILTER_LABEL_MASTER.put('Minimum_Order_Value_Explicit', System.Label.Minimum_Order_Value_Explicit);
        REP_FILTER_LABEL_MASTER.put('Earnings_Paid', System.Label.Earnings_Paid);
        REP_FILTER_LABEL_MASTER.put('G1_Representatives', System.Label.G1_Representatives);
        REP_FILTER_LABEL_MASTER.put('G2_Representatives', System.Label.G2_Representatives);
        REP_FILTER_LABEL_MASTER.put('G3_Representatives', System.Label.G3_Representatives);
        REP_FILTER_LABEL_MASTER.put('G4_Representatives', System.Label.G4_Representatives);
        REP_FILTER_LABEL_MASTER.put('G5_Representatives', System.Label.G5_Representatives);
        REP_FILTER_LABEL_MASTER.put('G6_Representatives', System.Label.G6_Representatives);
        REP_FILTER_LABEL_MASTER.put('G4_Representatives_Plus', System.Label.G4_Representatives_Plus);
        REP_FILTER_LABEL_MASTER.put('Tagged_as_President_Club', System.Label.Tagged_as_President_Club);
        REP_FILTER_LABEL_MASTER.put('Birthdays', System.Label.Birthdays);
        REP_FILTER_LABEL_MASTER.put('Anniversaries', System.Label.Anniversaries);
        
        REP_FILTER_LABEL_MASTER.put('LOA_1_Rep', System.Label.LOA_1_Rep);
        REP_FILTER_LABEL_MASTER.put('LOA_1_6_Rep', System.Label.LOA_1_6_Rep);
        REP_FILTER_LABEL_MASTER.put('Ending_Rep_Cnt', System.Label.Ending_Rep_Cnt);
        REP_FILTER_LABEL_MASTER.put('Held_Orders', System.Label.Held_Orders);
        REP_FILTER_LABEL_MASTER.put('Overdue_Balance', System.Label.Overdue_Balance);
        REP_FILTER_LABEL_MASTER.put('Rep_Accts_Sent_to_Collections', System.Label.Rep_Accts_Sent_to_Collections);
        REP_FILTER_LABEL_MASTER.put('Inactive_In_Campaign', System.Label.Inactive_In_Campaign);
        REP_FILTER_LABEL_MASTER.put('Inactive_In_Prior_Campaign', System.Label.Inactive_In_Prior_Campaign);
        REP_FILTER_LABEL_MASTER.put('P_Rem_In_Last_Two_Cmpgn', System.Label.P_Rem_In_Last_Two_Cmpgn);
        REP_FILTER_LABEL_MASTER.put('No_Brochures_Ordered', System.Label.No_Brochures_Ordered);
        REP_FILTER_LABEL_MASTER.put('Brochures_Ordered', System.Label.Brochures_Ordered);
        REP_FILTER_LABEL_MASTER.put('No_Super_Hits_Ordered', System.Label.No_Super_Hits_Ordered);
        REP_FILTER_LABEL_MASTER.put('Super_Hits_Ordered', System.Label.Super_Hits_Ordered);
        REP_FILTER_LABEL_MASTER.put('Team_sales_below_minimum', System.Label.Team_sales_below_minimum);
        REP_FILTER_LABEL_MASTER.put('Team_sales_above_minimum', System.Label.Team_sales_above_minimum);
        REP_FILTER_LABEL_MASTER.put('Return_net_sales', System.Label.Return_net_sales);
        REP_FILTER_LABEL_MASTER.put('PSQ_Below', System.Label.PSQ_Below);
        REP_FILTER_LABEL_MASTER.put('LOA_0', System.Label.LOA_0);
        REP_FILTER_LABEL_MASTER.put('LOA_1_6', System.Label.LOA_1_6);  
        REP_FILTER_LABEL_MASTER.put('LLOA_1_6', System.Label.LLOA_1_6); 
        REP_FILTER_LABEL_MASTER.put('Non_Top_Sellers', System.Label.Non_Top_Sellers);
        REP_FILTER_LABEL_MASTER.put('All_Generations', System.Label.All);  
        //end of SA 4-3-2012
        
        // Addition for New Business Representative - Start on 15-05-2012
        REP_FILTER_LABEL_MASTER.put('LOA (1-6)', System.Label.LOA_1_6);
        REP_FILTER_LABEL_MASTER.put('LOA 1', System.Label.LOA_1);
        REP_FILTER_LABEL_MASTER.put('LOA_0_6', System.Label.LOA_0_6);
        REP_FILTER_LABEL_MASTER.put('LOA_0_1', System.Label.LOA_0_1); 
        // Addition for New Business Representative - End on 15-05-2012
        
        // Mail Plan Addition - by Raktim on 1Jul 2013
        REP_FILTER_LABEL_MASTER.put('Open_Mail_Plan', System.Label.Open_Mail_Plan);
        
        // NRT changes by Supriyo - 28 August, 2013
        REP_FILTER_LABEL_MASTER.put('Personal_volume_on_hold', System.Label.Personal_volume_on_hold);
        REP_FILTER_LABEL_MASTER.put('Appointments_And_Potential_Appointments', System.Label.Appointments_and_Potential_Appointments);
        REP_FILTER_LABEL_MASTER.put('Inactive_In_Curr_Prior_Campaign', System.Label.Inactive_in_current_prior_campaign);
        
        //Personal Sales
        REP_DETL_LABEL_MASTER.put('AWRD_SLS_AMT__c',System.Label.Current_Campaign);
        REP_DETL_LABEL_MASTER.put('PC_AWRD_SLS_AMT__c',System.Label.Prior_Campaign);
        REP_DETL_LABEL_MASTER.put('YTD_AWRD_SLS_AMT__c',System.Label.Year_to_date_Award_Sales);
        REP_DETL_LABEL_MASTER.put('BAL_DUE_AMT__c',System.Label.Balance);
        REP_DETL_LABEL_MASTER.put('RTURN_NET_SLS_AMT__c',System.Label.Return_net_sales);
        REP_DETL_LABEL_MASTER.put('Percent_of_Current_Net_Sales__c',System.Label.Returns_to_Net_Current_Campaign);
        REP_DETL_LABEL_MASTER.put('YTD_RTURN_NET_SLS_AMT__c',System.Label.Year_to_date_Return_Sales);
        REP_DETL_LABEL_MASTER.put('Percent_of_YTD_Net_Sales__c',System.Label.Returns_to_Net_YTD);
        REP_DETL_LABEL_MASTER.put('PAST_DUE_AMT__c',System.Label.Past_Due);
        REP_DETL_LABEL_MASTER.put('AVG_CUST_CNT__C',System.Label.Avg_Customer_Served);
        REP_DETL_LABEL_MASTER.put('YTD_CUST_SERVD_CNT__c',System.Label.Year_to_date_Customer_Served);
        REP_DETL_LABEL_MASTER.put('PRFRMNC_POINT_QTY__c',System.Label.Performance_Points);
        REP_DETL_LABEL_MASTER.put('YTD_AVG_CUST_CNT__c',System.Label.YTD_Average_Customers_Served);
        
        //Group Sales
        REP_DETL_LABEL_MASTER.put('CC_GRP_AWRD_SLS_AMT__c',System.Label.Group_Award_Sales);
        REP_DETL_LABEL_MASTER.put('CC_GRP_NO_ORD_CNT__c',System.Label.Orders_Not_Submitted);
        REP_DETL_LABEL_MASTER.put('CC_GRP_ORD_ABV_MIN_CNT__c',System.Label.Orders_Achieving_Minimum);
        REP_DETL_LABEL_MASTER.put('CC_GRP_ORD_UND_MIN_CNT__c',System.Label.Orders_Under_Minimum);
        REP_DETL_LABEL_MASTER.put('TOTAL_TAR_CNT__c',System.Label.Title_at_Risk);
        REP_DETL_LABEL_MASTER.put('TOTAL_CTT_CNT__c',System.Label.Performing_at_Next_Level);
        REP_DETL_LABEL_MASTER.put('CC_GRP_AVG_CUST_CNT__c',System.Label.Avg_Customer_Served);
        REP_DETL_LABEL_MASTER.put('YTD_CUST_SERVD_CNT__c',System.Label.Year_to_date_Customer_Served);
        REP_DETL_LABEL_MASTER.put('TOTAL_GENRTN_1_STF_CNT__c',System.Label.X1st_Generation);
        REP_DETL_LABEL_MASTER.put('TOTAL_GENRTN_2_STF_CNT__c',System.Label.X2nd_Generation);
        REP_DETL_LABEL_MASTER.put('TOTAL_GENRTN_3_STF_CNT__c',System.Label.X3rd_Generation);
        REP_DETL_LABEL_MASTER.put('CC_GRP_APPT_CNT__c',System.Label.Appointments);
        REP_DETL_LABEL_MASTER.put('YTD_APPT_CNT__c',System.Label.Appointments_Year_to_Date);
        REP_DETL_LABEL_MASTER.put('CC_GRP_RMOVL_CNT__c',System.Label.Removals);
        REP_DETL_LABEL_MASTER.put('YTD_RMOVL_CNT__c',System.Label.Year_to_Date_Removals);
        REP_DETL_LABEL_MASTER.put('Personal_Sales__r.NC_GENRTN_1_APPT_CNT__c',System.Label.Gen_1_Appointments);
        REP_DETL_LABEL_MASTER.put('Personal_Sales__r.PC_GENRTN_1_APPT_CNT__c',System.Label.Gen_1_Appointments);
        REP_DETL_LABEL_MASTER.put('Personal_sales__r.SPPY_GENRTN_1_APPT_CNT__c',System.Label.Gen_1_Appointments);
        REP_DETL_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_TITL_DMTD_CNT__C',System.Label.Generation_1_Demoted);
        REP_DETL_LABEL_MASTER.put('Group_Sales__r.SPPY_GRP_TITL_PROMTD_CNT__C',System.Label.Generation_1_Promoted);
        
        //Added by MFISHER - S-158775
        REP_DETL_LABEL_MASTER.put('GRP_MRKT_TAG_3_TXTTRNS__c',System.Label.Grp_Mrkt_Tag3_booleanTrans);
        REP_DETL_LABEL_MASTER.put('PRSNL_MRKT_TAG_3_TXTTRNS__c',System.Label.PRSNL_Mrkt_Tag3_booleanTrans);
          
        // Added by Parul Gupta - T-216798
        REP_DETL_LABEL_MASTER.put('MailPlan_Order_Oppty__r.MLPLN_CLOSD_IND_TRN__c', System.Label.Open_Mail_Plan_label);
        REP_DETL_LABEL_MASTER.put('DETL_CNTCT_MRKT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
        REP_DETL_LABEL_MASTER.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TXT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
      
        REP_DETL_LABEL_MASTER.put('PRSNL_MRKT_TAG_3_TXTTRNS__c',System.Label.PRSNL_Mrkt_Tag3_booleanTrans);
       
        
        REP_COLGROUP_LABEL_MASTER = new Map<String,String>();
        
        //SA 4-25-2012: added new mappings for the 'my team' report FULL column names
        REP_COLGROUP_LABEL_MASTER.put('Personal Information',System.Label.Personal_Info_Title);
        REP_COLGROUP_LABEL_MASTER.put('Amount Due',System.Label.Amount_Due);
        REP_COLGROUP_LABEL_MASTER.put('Sales',System.Label.Sales);
        REP_COLGROUP_LABEL_MASTER.put('Group 1',System.Label.Column_Group_1);
        REP_COLGROUP_LABEL_MASTER.put('Group 2',System.Label.Column_Group_2);
        REP_COLGROUP_LABEL_MASTER.put('Group 3',System.Label.Column_Group_3);
        REP_COLGROUP_LABEL_MASTER.put('Group 4',System.Label.Column_Group_4);
        REP_COLGROUP_LABEL_MASTER.put('Group 5',System.Label.Column_Group_5);
        REP_COLGROUP_LABEL_MASTER.put('Group 6',System.Label.Column_Group_6);
        REP_COLGROUP_LABEL_MASTER.put('Group 7',System.Label.Column_Group_7);
        REP_COLGROUP_LABEL_MASTER.put('Group 8',System.Label.Column_Group_8);
        REP_COLGROUP_LABEL_MASTER.put('Group 9',System.Label.Column_Group_9);
        REP_COLGROUP_LABEL_MASTER.put('Group 10',System.Label.Column_Group_10);
        REP_COLGROUP_LABEL_MASTER.put('Group 11',System.Label.Column_Group_11);
        REP_COLGROUP_LABEL_MASTER.put('Group 12',System.Label.Column_Group_12);
        REP_COLGROUP_LABEL_MASTER.put('Group 13',System.Label.Column_Group_13);
        REP_COLGROUP_LABEL_MASTER.put('Group 14',System.Label.Column_Group_14);
        REP_COLGROUP_LABEL_MASTER.put('Group 15',System.Label.Column_Group_15);
        //end of SA 4-25-2012
        
        
        // Addition of Short Column Names - June 08, 2012
        REP_COL_SHORT = new Map<String,String>();
        
        REP_COL_SHORT.put('Genealogy_Level__c', System.Label.YOU_NEWREP_UPLNINDX_DISPLY);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.FirstName,MRKT_ACCT_KEY__r.LastName', System.Label.YOU_NEWREP_FNAME_LNAME_DISPLY); 
        REP_COL_SHORT.put('Personal Information', System.Label.YOU_NEWREP_PI_DISPLY);
        REP_COL_SHORT.put('LOA 1-6 Volume', System.Label.YOU_NEWREP_LOA1_6_DISPLY);
        
        REP_COL_SHORT.put('PRSNL_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        REP_COL_SHORT.put('PC1_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        REP_COL_SHORT.put('PC2_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        REP_COL_SHORT.put('PC3_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        REP_COL_SHORT.put('PC4_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        REP_COL_SHORT.put('PC5_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        
        //REP_COL_SHORT.put('Campaign n Volume', System.Label.YOU_NEWREP_CAMPGN_NVOL_DISPLY);
        REP_COL_SHORT.put('Current Campaign Brochure', System.Label.YOU_NEWREP_CAMPGN_BRCHR_DISPLY);
        REP_COL_SHORT.put('Customer Served', System.Label.YOU_NEWREP_CUST_SERVD_DISPLY);
        REP_COL_SHORT.put('Total_LOA_0_6_Personal_Sales__c', System.Label.YOU_NEWREP_TOTAL_6_CAMPGN_PV_DISPLY);
        REP_COL_SHORT.put('TTL_PAST_6_CMPGN_SLS_AMT__c', System.Label.YOU_NEWREP_TOTAL_6_CAMPGN_PV_DISPLY);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.ACCT_NR__c', System.Label.Account_Number_Short);
        REP_COL_SHORT.put('Preferred Email', System.Label.eMail2);
        REP_COL_SHORT.put('Zone Number', System.Label.Zone_Number_Short);
        REP_COL_SHORT.put('LOA', System.Label.LLOA);
        REP_COL_SHORT.put('Branch Name', System.Label.Branch_Number_Short);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.Representative_Phone__c', System.Label.Phone);
        REP_COL_SHORT.put('Sponsor', System.Label.Sponsor_Short);
        REP_COL_SHORT.put('Birthday', System.Label.Birthday_Short);
        REP_COL_SHORT.put('Anniversary', System.Label.Anniversary_Short);
        REP_COL_SHORT.put('Badge Title', System.Label.Badge_Title_Short);
        REP_COL_SHORT.put('TC Personal Volume', System.Label.YOU_TOP_SELLER_PERSONAL_VOLUME_SHRT);
        REP_COL_SHORT.put('LC Personal Volume', System.Label.YOU_TOP_SELLER_LC_PERSONAL_VOLUME_SHRT);
        REP_COL_SHORT.put('TY CTD Personal Volume', System.Label.YOU_TOP_SELLER_PY_CTD_TY_SHRT);
        REP_COL_SHORT.put('PY CTD Personal Volume', System.Label.YOU_TOP_SELLER_PY_CTD_PV_SHRT);
        REP_COL_SHORT.put('TY CTD Top Seller Target',System.Label.YOU_TOP_SELLER_TARGET_SHRT);
        REP_COL_SHORT.put('Top Seller Tracking Status', System.Label.YOU_TOP_SELLER_TRACKING_STATUS_SHRT);
        REP_COL_SHORT.put('Change',System.Label.Change_SHRT);
        REP_COL_SHORT.put('Variance',System.Label.Variance);
        REP_COL_SHORT.put('President Club Level',System.Label.Top_seller_title);
        REP_COL_SHORT.put('LLOA',System.Label.LLOA_LOA);
        REP_COL_SHORT.put('Avon LOA',System.Label.Avon_LOA);
        REP_COL_SHORT.put('Badge Title',System.Label.Badge_Title);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.REP_APPT_CMPGN_NR__c',System.Label.Appointment_Campaign);
        
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TAG_4_TXT__c',System.Label.QPA_Short);
        REP_COL_SHORT.put('QPA_Achievement__c',System.Label.QPA_Short);
        REP_COL_SHORT.put('BOOK1_GRP_UNIT_SLS_AMT__c',System.Label.C0_B1_Personal_Sales);
        REP_COL_SHORT.put('BOOK2_GRP_UNIT_SLS_AMT__c',System.Label.C0_B2_Personal_Sales);
        REP_COL_SHORT.put('NXT_DUE_DT__c',System.Label.Next_Due_Date_Short);
        REP_COL_SHORT.put('Current Due Amount',System.Label.Current_Due_Amount_Short);
        REP_COL_SHORT.put('Amount Overdue',System.Label.Amount_Overdue_Short);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.Representative_Phone__c',System.Label.Phone);
        
        //Paid Title added by Rupayan, 12182012
        REP_COL_SHORT.put('Paid Title',System.Label.Paid_Title);
        
        REP_COL_SHORT.put('UPLN_GEN_INDX__c', System.Label.YOU_NEWREP_UPLNINDX_DISPLY);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.Name', System.Label.YOU_NEWREP_FNAME_LNAME_DISPLY); 
        REP_COL_SHORT.put('Personal Information', System.Label.YOU_NEWREP_PI_DISPLY);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.ACCT_NR__c', System.Label.Account_Number_Short);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.Email', System.Label.eMail2);
        REP_COL_SHORT.put('SLS_ZONE_CD__c', System.Label.Zone_Number_Short);
        REP_COL_SHORT.put('LDRSHP_LOA_NR__c', System.Label.LLOA);
        REP_COL_SHORT.put('BRNCH_SCTN_CD__c', System.Label.Branch_Number_Short);
        REP_COL_SHORT.put('BRNCH_NM__c',System.Label.Branch_Number_Short);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.Representative_Phone__c', System.Label.Phone);
        REP_COL_SHORT.put('UPLN_ACCT_NR__c', System.Label.Sponsor_Short);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.BIRTH_DATE__c', System.Label.Birthday_Short);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.Anniversary_Date__c', System.Label.Anniversary_Short);
        REP_COL_SHORT.put('LDRSHP_TITL_LVL_NR__c', System.Label.Badge_Title_Short);
        //REP_COL_SHORT.put('PRSNL_SLS_AMT__c', System.Label.YOU_TOP_SELLER_PERSONAL_VOLUME_SHRT);
        REP_COL_SHORT.put('YOU_TOP_SELLER_LC_PERSONAL_VOLUME_LBL', System.Label.YOU_TOP_SELLER_LC_PERSONAL_VOLUME_SHRT);
        REP_COL_SHORT.put('CTD_AWRD_SLS_AMT__c', System.Label.YOU_TOP_SELLER_PY_CTD_TY_SHRT);
        REP_COL_SHORT.put('SPPY_CTD_PRSNL_SLS_AMT__c', System.Label.YOU_TOP_SELLER_PY_CTD_PV_SHRT);
        REP_COL_SHORT.put('YOU_TOP_SELLER_TARGET_LBL',System.Label.YOU_TOP_SELLER_TARGET_SHRT);
        REP_COL_SHORT.put('TOP_SLR_TRCKNG_STUS__c', System.Label.YOU_TOP_SELLER_TRACKING_STATUS_SHRT);
        REP_COL_SHORT.put('Change',System.Label.Change_SHRT);
        REP_COL_SHORT.put('Variance',System.Label.Variance);
        REP_COL_SHORT.put('LCL_TOP_SLR_LVL_KEY__c',System.Label.Top_seller_title);
        REP_COL_SHORT.put('LCL_TOP_SLR_LVL_LANG_DESC_TXT__c',System.Label.Top_seller_title);
        REP_COL_SHORT.put('LOA_NR__c',System.Label.Avon_LOA);
        REP_COL_SHORT.put('UPLN_FULL_NAME__c', System.Label.Sponsor);
        REP_COL_SHORT.put('YOU_TOP_SELLER_LEVEL_LBL',System.Label.Top_seller_title);
        REP_COL_SHORT.put('BAL_DUE_AMT__c',System.Label.Current_Due_Amount);
        REP_COL_SHORT.put('PAST_DUE_AMT__c',System.Label.Amount_Overdue);
        
        //NRT changes added by Supriyo - August 28, 2013
        REP_COL_SHORT.put('NRT_INVC_SLS_AMT__c',System.Label.NRT_Invoiced_Personal_Volume);
        REP_COL_SHORT.put('NRT_SUBMTD_SLS_DISPLAY__c',System.Label.NRT_Submitted_Personal_Volume);
        REP_COL_SHORT.put('NRT_TOTAL_SLS_DISPLAY__c',System.Label.NRT_Total_Potential_Personal_Volume);
        REP_COL_SHORT.put('NRT_HOLD_SLS_DISPLAY__c',System.Label.NRT_Held_Personal_Volume);
        REP_COL_SHORT.put('NRT_SVD_SLS_DISPLAY__c',System.Label.NRT_Saved_Personal_Volume);
        
        //Paid Title added by Rupayan, 12182012
        REP_COL_SHORT.put('PD_TITL_LVL_NR__c', System.Label.Paid_Title);
        
        //Mail Plan by Raktim
        REP_COL_SHORT.put('MailPlan_Order_Oppty__r.CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c', System.Label.Days_to_Close);
        REP_COL_SHORT.put('MailPlan_Order_Oppty__r.MLPLN_CD__c', System.Label.Mail_Plans); //added subhamay_17062013_for UK market to display mailplan code
        REP_COL_SHORT.put('Total_Award_Sales__c', System.Label.Award_Sales); //added subhamay_17062013_for UK market to display mailplan code
        
        REP_COL_SHORT.put('MRKT_INVC_SLS_AMT__c',System.Label.Personal_Sales);
        
        // Added by Parul Gupta - T-216798
        REP_COL_SHORT.put('MailPlan_Order_Oppty__r.MLPLN_CLOSD_IND_TRN__c', System.Label.Open_Mail_Plan_label_short);
        REP_COL_SHORT.put('DETL_CNTCT_MRKT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
        REP_COL_SHORT.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TXT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
      
        //Added by MFISHER - S-158775
        REP_COL_SHORT.put('GRP_MRKT_TAG_3_TXTTRNS__c',System.Label.Grp_Mrkt_Tag3_booleanTrans);
        REP_COL_SHORT.put('PRSNL_MRKT_TAG_3_TXTTRNS__c',System.Label.PRSNL_Mrkt_Tag3_booleanTrans);       
        REP_COL_SHORT.put('LST_ORD_CMPGN_NR__c',System.Label.Award_Sales);
        
        
                
        // For Column Header - June 08, 2012 
        REP_COL_HEADR = new Map<String,String>();
        
        REP_COL_HEADR.put('Genealogy_Level__c', System.Label.YOU_NEWREP_UPLNINDX);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.Name', System.Label.YOU_NEWREP_FNAME_LNAME); 
        REP_COL_HEADR.put('Personal Information', System.Label.YOU_NEWREP_PI);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.ACCT_NR__c', System.Label.Account_Number);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.Email', System.Label.eMail2);
        REP_COL_HEADR.put('SLS_ZONE_CD__c', System.Label.Zone_Number);
        REP_COL_HEADR.put('LDRSHP_LOA_NR__c', System.Label.LLOA);
        REP_COL_HEADR.put('BRNCH_SCTN_CD__c', System.Label.Branch_Number_Short);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.Representative_Phone__c', System.Label.Phone);
        REP_COL_HEADR.put('UPLN_ACCT_NR__c', System.Label.Sponsor);
        REP_COL_HEADR.put('UPLN_FULL_NAME__c', System.Label.Sponsor);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.BIRTH_DATE__c', System.Label.Birthday);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.Anniversary_Date__c', System.Label.Anniversary);
        REP_COL_HEADR.put('LDRSHP_TITL_LVL_NR__c', System.Label.Badge_Title);
         // Additon for New Rep Report - Swarnava on feb 20, 2013
        REP_COL_HEADR.put('NXT_DUE_DT__c',System.Label.Next_Due_Date);
        REP_COL_HEADR.put('BOOK1_GRP_UNIT_SLS_AMT__c',System.Label.C0_B1_Personal_Sales);
        REP_COL_HEADR.put('BOOK2_GRP_UNIT_SLS_AMT__c',System.Label.C0_B2_Personal_Sales);
        REP_COL_HEADR.put('BOOK1_PRSNL_SLS_AMT__c',System.Label.C0_B1_Personal_Sales);
        REP_COL_HEADR.put('BOOK2_PRSNL_SLS_AMT__c',System.Label.C0_B2_Personal_Sales);
        REP_COL_HEADR.put('GRP_BAL_AMT__c',System.Label.Current_Due_Amount);
        REP_COL_HEADR.put('GRP_PAST_DUE_AMT__c',System.Label.Amount_Overdue);
        REP_COL_HEADR.put('BAL_DUE_AMT__c',System.Label.Current_Due_Amount);
        REP_COL_HEADR.put('PAST_DUE_AMT__c',System.Label.Amount_Overdue);
        // Eoc
        
        //Paid Title added by Rupayan, 12182012
        REP_COL_HEADR.put('PD_TITL_LVL_NR__c', System.Label.Paid_Title);
        
        //REP_COL_HEADR.put('PRSNL_SLS_AMT__c', System.Label.YOU_TOP_SELLER_PERSONAL_VOLUME);
        REP_COL_HEADR.put('YOU_TOP_SELLER_LC_PERSONAL_VOLUME_LBL', System.Label.YOU_TOP_SELLER_LC_PERSONAL_VOLUME);
        REP_COL_HEADR.put('CTD_AWRD_SLS_AMT__c', System.Label.YOU_TOP_SELLER_PY_CTD_TY);
        REP_COL_HEADR.put('SPPY_CTD_PRSNL_SLS_AMT__c', System.Label.YOU_TOP_SELLER_PY_CTD_PV);
        REP_COL_HEADR.put('YOU_TOP_SELLER_TARGET_LBL',System.Label.YOU_TOP_SELLER_TARGET);
        REP_COL_HEADR.put('TOP_SLR_TRCKNG_STUS__c', System.Label.YOU_TOP_SELLER_TRACKING_STATUS);
        REP_COL_HEADR.put('Change',System.Label.Change);
        REP_COL_HEADR.put('Variance',System.Label.Variance);
        REP_COL_HEADR.put('LCL_TOP_SLR_LVL_KEY__c',System.Label.Top_seller_title);
        REP_COL_HEADR.put('LOA_NR__c',System.Label.Avon_LOA);
        REP_COL_HEADR.put('YOU_TOP_SELLER_LEVEL_LBL',System.Label.Top_seller_title);
        
        REP_COL_HEADR.put('ACCT_NR__c', System.Label.YOU_NEWREP_UPLNINDX);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.FirstName,MRKT_ACCT_KEY__r.LastName', System.Label.YOU_NEWREP_FNAME_LNAME); 
        REP_COL_HEADR.put('Personal Information', System.Label.YOU_NEWREP_PI);
        REP_COL_HEADR.put('LOA 1-6 Volume', System.Label.YOU_NEWREP_LOA1_6);
        REP_COL_HEADR.put('PRSNL_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL);
        REP_COL_HEADR.put('PC1_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL);
        REP_COL_HEADR.put('PC2_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL);
        REP_COL_HEADR.put('PC3_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL);
        REP_COL_HEADR.put('PC4_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL);
        REP_COL_HEADR.put('PC5_INVC_AWRD_SLS_AMT__c', System.Label.YOU_NEWREP_CAMPGN_NVOL);
        REP_COL_HEADR.put('Current Campaign Brochure', System.Label.YOU_NEWREP_CAMPGN_BRCHR);
        REP_COL_HEADR.put('Customer Served', System.Label.YOU_NEWREP_CUST_SERVD);
        REP_COL_HEADR.put('Total_LOA_0_6_Personal_Sales__c', System.Label.YOU_NEWREP_TOTAL_6_CAMPGN_PV);
        REP_COL_HEADR.put('TTL_PAST_6_CMPGN_SLS_AMT__c', System.Label.YOU_NEWREP_TOTAL_6_CAMPGN_PV);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.ACCT_NR__c', System.Label.Account_Number);
        REP_COL_HEADR.put('Preferred Email', System.Label.Preferred_Email);
        REP_COL_HEADR.put('Zone Number', System.Label.Zone_number);
        REP_COL_HEADR.put('LOA', System.Label.LLOA_LOA);
        REP_COL_HEADR.put('BRNCH_NM__c', System.Label.Branch_Name);
        REP_COL_HEADR.put('Preferred phone number', System.Label.Preferred_Phone_Number);
        REP_COL_HEADR.put('UPLN_FULL_NAME__c', System.Label.Sponsor);
        REP_COL_HEADR.put('Birthday', System.Label.BirthdayYOU);
        REP_COL_HEADR.put('Anniversary', System.Label.Anniversary);
        REP_COL_HEADR.put('Badge Title', System.Label.Badge_Title);
        REP_COL_HEADR.put('Paid Title', System.Label.Paid_Title);
        REP_COL_HEADR.put('TC Personal Volume', System.Label.YOU_TOP_SELLER_PERSONAL_VOLUME);
        REP_COL_HEADR.put('LC Personal Volume', System.Label.YOU_TOP_SELLER_LC_PERSONAL_VOLUME);
        REP_COL_HEADR.put('Variance Personal Volume', System.Label.YOU_TOP_SELLER_VAR_PERSONAL_VOLUME);
        REP_COL_HEADR.put('TY CTD Personal Volume', System.Label.YOU_TOP_SELLER_PY_CTD_TY); 
        REP_COL_HEADR.put('PY CTD Personal Volume', System.Label.YOU_TOP_SELLER_PY_CTD_PV);
        REP_COL_HEADR.put('Variance CTD Personal Volume', System.Label.YOU_TOP_SELLER_CTD_PERSONAL_VOLUME);
        REP_COL_HEADR.put('TY CTD Top Seller Target',System.Label.YOU_TOP_SELLER_TARGET);
        REP_COL_HEADR.put('Variance TY to Target', System.Label.YOU_TOP_SELLER_VAR_TY_TO_TARGET);
        REP_COL_HEADR.put('Top Seller Tracking Status', System.Label.YOU_TOP_SELLER_TRACKING_STATUS);
        REP_COL_HEADR.put('President Club Level',System.Label.Top_seller_title);
        REP_COL_HEADR.put('Variance',System.Label.Variance);
        REP_COL_HEADR.put('Change',System.Label.Change);
        REP_COL_HEADR.put('LLOA',System.Label.LLOA_LOA);
        REP_COL_HEADR.put('LOA_NR__c',System.Label.Avon_LOA);
        REP_COL_HEADR.put('LDRSHP_TITL_LVL_NR__c',System.Label.Badge_Title);
        
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.REP_APPT_CMPGN_NR__c',System.Label.Appointment_Campaign);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TAG_4_TXT__c',System.Label.QPA);
        REP_COL_HEADR.put('QPA_Achievement__c',System.Label.QPA);
        REP_COL_HEADR.put('BOOK1_GRP_UNIT_SLS_AMT__c',System.Label.C0_B1_Personal_Sales);
        REP_COL_HEADR.put('BOOK2_GRP_UNIT_SLS_AMT__c',System.Label.C0_B2_Personal_Sales);
        REP_COL_HEADR.put('NXT_DUE_DT__c',System.Label.Next_Due_Date);
        REP_COL_HEADR.put('BAL_DUE_AMT__c',System.Label.Current_Due_Amount);
        REP_COL_HEADR.put('PAST_DUE_AMT__c',System.Label.Amount_Overdue);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.Representative_Phone__c',System.Label.Phone);
        
        //NRT changes added by Supriyo - August 28, 2013
        REP_COL_HEADR.put('NRT_INVC_SLS_AMT__c',System.Label.NRT_Invoiced_Personal_Volume);
        REP_COL_HEADR.put('NRT_SUBMTD_SLS_DISPLAY__c',System.Label.NRT_Submitted_Personal_Volume);
        REP_COL_HEADR.put('NRT_TOTAL_SLS_DISPLAY__c',System.Label.NRT_Total_Potential_Personal_Volume);
        REP_COL_HEADR.put('NRT_HOLD_SLS_DISPLAY__c',System.Label.NRT_Held_Personal_Volume);
        REP_COL_HEADR.put('NRT_SVD_SLS_DISPLAY__c',System.Label.NRT_Saved_Personal_Volume);
        
        // Mail Plan - by Raktim
        REP_COL_HEADR.put('MailPlan_Order_Oppty__r.CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c',System.Label.Days_to_Close);
        REP_COL_HEADR.put('MailPlan_Order_Oppty__r.MLPLN_CD__c', System.Label.Mail_Plans); //added subhamay_17062013_for UK market to display mailplan code
        REP_COL_HEADR.put('Total_Award_Sales__c', System.Label.Award_Sales); //added subhamay_17062013_for UK market to display mailplan code
        
        REP_COL_HEADR.put('MRKT_INVC_SLS_AMT__c',System.Label.Personal_Sales);
        
        // Added by Parul Gupta - T-216798
        REP_COL_HEADR.put('MailPlan_Order_Oppty__r.MLPLN_CLOSD_IND_TRN__c', System.Label.Open_Mail_Plan_label); 
        REP_COL_HEADR.put('DETL_CNTCT_MRKT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
        REP_COL_HEADR.put('MRKT_ACCT_KEY__r.DETL_CNTCT_MRKT_TXT4_TRN__c', System.Label.Contact_Market_Tag_4_Title_Translation);
      
        //Added by MFISHER - S-158775
        REP_COL_HEADR.put('GRP_MRKT_TAG_3_TXTTRNS__c',System.Label.Grp_Mrkt_Tag3_booleanTrans);
        REP_COL_HEADR.put('PRSNL_MRKT_TAG_3_TXTTRNS__c',System.Label.PRSNL_Mrkt_Tag3_booleanTrans);
                 
        // for coaching record page
        COACH_LABEL = new Map<String,String>();
        
        COACH_LABEL.put('FirstName',System.Label.FirstName);
        COACH_LABEL.put('LastName',System.Label.LastName);
        COACH_LABEL.put('ACCT_NR__c',System.Label.Account_Number);
        COACH_LABEL.put('REP_BRTH_DT__c',System.Label.BirthdayYOU);
        COACH_LABEL.put('REP_MOBILE_PHON_NR__c',System.Label.Preferred_Phone_Number);
        COACH_LABEL.put('REP_HM_PHON_NR__c',System.Label.Secondary_Phone_Number);
        COACH_LABEL.put('Email',System.Label.Preferred_Email);
        COACH_LABEL.put('REP_EMAIL_ADDR_TXT__c',System.Label.Preferred_Email);//added subhamay on 10302013_proper maping for Preferred
        COACH_LABEL.put('REP_ADDR_STR_1_TXT__c,REP_ADDR_CITY_NM__c,REP_ADDR_ST_NM__c,REP_ADDR_PSTL_CD__c',System.Label.Home_Address);
        COACH_LABEL.put('REP_LANG_CD__c',System.Label.Preferred_Language);
        COACH_LABEL.put('REP_APPT_DT__c',System.Label.Appointment_Date);
        COACH_LABEL.put('REP_APPT_CMPGN_NR__c',System.Label.Appointment_Campaign);//added Subhamay on 05092013_new KPI for Mexico
        COACH_LABEL.put('SLS_ZONE_CD__c',System.Label.Zone_number);
        COACH_LABEL.put('ALM_Rep_Performance_1:LOA_NR__c',System.Label.Avon_LOA);
        COACH_LABEL.put('ALM_Rep_Performance_1:LDRSHP_LOA_NR__c',System.Label.LLOA);
        //COACH_LABEL.put('LDRSHP_LOA_NR__c',System.Label.LLOA);
        //COACH_LABEL.put('ALM_Rep_Performance_1:LCL_TOP_SLR_LVL_KEY__c',System.Label.Current +' '+ System.Label.President_Club_Status);
        COACH_LABEL.put('ALM_Rep_Performance_1:LCL_TOP_SLR_LVL_KEY__c',System.Label.Current_Top_Seller_Title_Status);        
        COACH_LABEL.put('ALM_Rep_Performance_1:PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c',System.Label.Prior +' '+ System.Label.President_Club_Status);        
        COACH_LABEL.put('ALM_Rep_Performance_1:LDRSHP_TITL_LVL_NR__c',System.Label.Badge_Title);
        COACH_LABEL.put('ALM_Rep_Performance_1:RSNG_STR_DT__c',System.Label.Rising_Star_Status);
        COACH_LABEL.put('ALM_Rep_Performance_1:RSNG_STR_IND__c',System.Label.Rising_Star_Status);
        COACH_LABEL.put('ALM_Rep_Performance_1:Total_Award_Sales__c',System.Label.Award_Sales);
        
        // For Top lavel Rep personal details
        COACH_LABEL.put('MRKT_ACCT_KEY__r.FirstName',System.Label.FirstName);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.LastName',System.Label.LastName);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.ACCT_NR__c',System.Label.Account_Number);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_BRTH_DT__c',System.Label.BirthdayYOU);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_MOBILE_PHON_NR__c',System.Label.Preferred_Phone_Number);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_HM_PHON_NR__c',System.Label.Secondary_Phone_Number);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.Email',System.Label.Preferred_Email);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c',System.Label.Preferred_Email);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_ADDR_STR_1_TXT__c,MRKT_ACCT_KEY__r.REP_ADDR_CITY_NM__c,MRKT_ACCT_KEY__r.REP_ADDR_ST_NM__c,MRKT_ACCT_KEY__r.REP_ADDR_PSTL_CD__c',System.Label.Home_Address);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_LANG_CD__c',System.Label.Preferred_Language);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.REP_APPT_DT__c',System.Label.Appointment_Date);
        COACH_LABEL.put('MRKT_ACCT_KEY__r.SLS_ZONE_CD__c',System.Label.Zone_number);
        COACH_LABEL.put('LOA_NR__c',System.Label.Avon_LOA);
        COACH_LABEL.put('LDRSHP_LOA_NR__c',System.Label.LLOA);
        COACH_LABEL.put('LCL_TOP_SLR_LVL_KEY__c',System.Label.Current +' '+ System.Label.President_Club_Status);
        COACH_LABEL.put('PREV_CYCL_LCL_TOP_SLR_LVL_KEY__c',System.Label.Prior +' '+ System.Label.President_Club_Status);
        COACH_LABEL.put('LDRSHP_TITL_LVL_NR__c',System.Label.Badge_Title);
        COACH_LABEL.put('RSNG_STR_DT__c',System.Label.Rising_Star_Status);
        COACH_LABEL.put('RSNG_STR_IND__c',System.Label.Rising_Star_Status);
        // eoc For Top lavel Rep personal details
        
        COACH_LABEL.put('Upline:FirstName,LastName',System.Label.Sponsor);
        COACH_LABEL.put('Upline:REP_MOBILE_PHON_NR__c',System.Label.Sponsor_Preferred_Phone);
        COACH_LABEL.put('Upline:REP_EMAIL_ADDR_TXT__c',System.Label.Sponsor_Preferred_Email);
        COACH_LABEL.put('SalesOrg:SLS_REGN_NM__c',System.Label.Region);
        COACH_LABEL.put('SalesOrg:SLS_DIV_NM__c',System.Label.Division);
        COACH_LABEL.put('SalesOrg:SLS_ZONE_MGR_FULL_NM__c',System.Label.Zone_Manager);
        COACH_LABEL.put('SalesOrg:SLS_ZONE_MGR_PHON_NR__c',System.Label.Zone_Manager_Phone);
        COACH_LABEL.put('SalesOrg:SLS_ZONE_MGR_EMAIL_TXT__c',System.Label.Zone_Manager_email);
        // subhamay 31012013_for missing mapping in CR page
        COACH_LABEL.put('Sales_History:RTURN_NET_SLS_AMT__c,SPPY_RTURN_NET_SLS_AMT__c',System.Label.Returns_to_Total_Campaign);
        COACH_LABEL.put('Sales_History:PD_TITL_LVL_NR__c,SPPY_PD_TITL_LVL_NR__c',System.Label.Paid_Title);
        COACH_LABEL.put('Sales_History:GRP_LDR_EARNING_AMT__c,SPPY_GRP_LDR_EARNING_AMT__c',System.Label.Earnings_leadership_only);
        COACH_LABEL.put('Sales_History:GRP_QPA_RATE_PCT__c,SPPY_GRP_QPA_RATE_PCT__c',System.Label.Qualified_Personal_Appointments_Rate);
        // eoc subhamay
        //COACH_LABEL.put('Sales_History:PRSNL_SLS_AMT__c,SPPY_PRSNL_SLS_AMT__c',System.Label.Personal_Sales+' ('+System.Label.ErngIllustratr_CurrencySymbl+')');
        COACH_LABEL.put('Sales_History:PRSNL_SLS_AMT__c,SPPY_PRSNL_SLS_AMT__c',System.Label.Personal_Sales_New);
        COACH_LABEL.put('Sales_History:INVC_AWRD_SLS_AMT__c,SPPY_PRSNL_SLS_AMT__c',System.Label.Personal_Sales_New);
        COACH_LABEL.put('Sales_History:RTURNS_PCT__c,SPPY_RTURNS_PCT__c',System.Label.Returns_to_Total_Campaign);
        COACH_LABEL.put('Sales_History:GENRTN_1_APPT_CNT__c,SPPY_GENRTN_1_APPT_CNT__c',System.Label.Personal_Appointments);
        //COACH_LABEL.put('Personal_Performance_Key__r:GENRTN_1_QPA_CNT__c,SPPY_GENRTN_1_QPA_CNT__c',System.Label.Qualified_Personal_Appointments);
        COACH_LABEL.put('Sales_History:GENRTN_1_QPA_CNT__c,SPPY_GENRTN_1_QPA_CNT__c',System.Label.Qualified_Personal_Appointments_Rate);
        COACH_LABEL.put('Sales_History:CUST_CNT__c,SPPY_CUST_CNT__c',System.Label.Customers_Served);
        COACH_LABEL.put('Sales_History:LDRSHP_TITL_LVL_NR__c,SPPY_LDRSHP_TITL_LVL_NR__c',System.Label.Badge_Title);
        COACH_LABEL.put('Sales_History:LDR_ERNGS_AMT__c,SPPY_LDR_ERNGS_AMT__c',System.Label.Earnings_leadership_only);
        COACH_LABEL.put('Sales_History:GENRTN_1_QPA_CONVRSN_PCT__c,SPPY_GENRTN_1_QPA_CONVRSN_PCT__c',System.Label.Qualified_Personal_Appointments_Rate);
        COACH_LABEL.put('Sales_History:GRP_UNIT_SLS_AMT__c,SPPY_GRP_UNIT_SLS_AMT__c',System.Label.Total_Unit_Sales);
        COACH_LABEL.put('Sales_History:EXEC_UNIT_SLS__c,SPPY_EXEC_UNIT_SLS__c',System.Label.Executive_Volume);
        COACH_LABEL.put('Sales_History:LOA1_GRP_UNIT_SLS__c,SPPY_LOA1_GRP_UNIT_SLS__c',System.Label.Total_Unit_Sales_LOA1);
        COACH_LABEL.put('Sales_History:LOA_1_6_GRP_UNIT_SLS__c,SPPY_LOA_1_6_GRP_UNIT_SLS__c',System.Label.TUS_from_New_Rep_Business);
        COACH_LABEL.put('Sales_History:TSRP_GRP_UNIT_SLS__c,SPPY_TSRP_GRP_UNIT_SLS__c',System.Label.TUS_TopSeller);
        COACH_LABEL.put('Sales_History:GENTRTN_1_ACTV_REP_CNT__c,SPPY_GENRTN_1_ACTV_REP_CNT__c',System.Label.G1_Actives);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_0_STF_CNT__c,SPPY_GENRTN_1_TITL_0_STF_CNT__c',System.Label.G1_Candidate);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_1_STF_CNT__c,SPPY_GENRTN_1_TITL_1_STF_CNT__c',System.Label.G1_Unit_Leaders);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_2_STF_CNT__c,SPPY_GENRTN_1_TITL_2_STF_CNT__c',System.Label.G1_Advanced_Unit_Leaders);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_3_STF_CNT__c,SPPY_GENRTN_1_TITL_3_STF_CNT__c',System.Label.G1_Executive_Unit_Leaders);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_4_STF_CNT__c,SPPY_GENRTN_1_TITL_4_STF_CNT__c',System.Label.G1_Senior_EUL); // added by subhamay 10082013_proper mapping
        //COACH_LABEL.put('Leader_Downline_Summary__r:GENRTN_1_TITL_4_STF_CNT__c,SPPY_GENRTN_1_TITL_4_STF_CNT__c',System.Label.G1_Senior_EUL); used for UIat leadership section
        COACH_LABEL.put('Sales_History:GRP_QPA_CNT__c,SPPY_UNIT_QPA_CNT__c',System.Label.Unit_QPA);
        COACH_LABEL.put('Sales_History:GRP_APPT_CNT__c,SPPY_UNIT_APPT_CNT__c',System.Label.Unit_Appointments);
        COACH_LABEL.put('Sales_History:TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c,SPPY_TOTAL_GENRTN_1_EXEC_TITL_STF_CNT__c',System.Label.Total_Executive_Leaders);
        COACH_LABEL.put('Sales_History:Unit_Actives__c,SPPY_Unit_Actives__c',System.Label.G1_3_actives);//Qc#3180_subhamay 13112013. 
        
        // End of Addition
        // subhamay 12032013 as per new requirment
        COACH_LABEL.put('Sales_History:PD_TITL_LVL_NR__c,SPPY_PD_TITL_LVL_NR__c',System.Label.Paid_Title);
        COACH_LABEL.put('Sales_History:GENRTN_1_UNIT_SLS_AMT__c,SPPY_GENRTN_1_UNIT_SLS_AMT__c',System.Label.G1_Sales+' ('+System.Label.ErngIllustratr_CurrencySymbl+')');
        //COACH_LABEL.put('Leader_Downline_Summary__r:GENTRTN_1_ACTV_REP_CNT__c,SPPY_GENRTN_1_ACTV_REP_CNT__c',System.Label.G1_Actives); line: 772
        COACH_LABEL.put('Sales_History:GENRTN_1_ACT_PCT__c,SPPY_GENRTN_1_ACT_PERC__c',System.Label.G1_Activity_Rate);
        //COACH_LABEL.put('Duplicate-Sales_History:GENRTN_1_APPT_CNT__c,SPPY_GENRTN_1_APPT_CNT__c',System.Label.G1Appointments); //line: 761 /* Blocked on 3rd Oct 2013 */
        COACH_LABEL.put('Duplicate-Sales_History:GENRTN_1_APPT_CNT__c,SPPY_GENRTN_1_APPT_CNT__c',System.Label.G1Appointments_CR); /* Added on 3rd Oct 2013 */
        COACH_LABEL.put('Sales_History:GENRTN_2_UNIT_SLS_AMT__c,SPPY_GENRTN_2_UNIT_SLS_AMT__c',System.Label.G2_Sales+' ('+System.Label.ErngIllustratr_CurrencySymbl+')');
        COACH_LABEL.put('Sales_History:GENTRTN_2_ACTV_REP_CNT__c,SPPY_GENTRTN_2_ACTV_REP_CNT__c',System.Label.G2_Actives);
        COACH_LABEL.put('Sales_History:GENRTN_2_ACT_PCT__c,SPPY_GENRTN_2_ACT_PCT__c',System.Label.G2_Activity_Rate);
        COACH_LABEL.put('Sales_History:GENRTN_2_APPT_CNT__c,SPPY_GENRTN_2_APPT_CNT__c',System.Label.G2_Appointments);
        COACH_LABEL.put('Sales_History:GENRTN_3_UNIT_SLS_AMT__c,SPPY_GENRTN_3_UNIT_SLS_AMT__c',System.Label.G3_Sales+' ('+System.Label.ErngIllustratr_CurrencySymbl+')');
        COACH_LABEL.put('Sales_History:GENTRTN_3_ACTV_REP_CNT__c,SPPY_GENTRTN_3_ACTV_REP_CNT__c',System.Label.G3_Actives);
        COACH_LABEL.put('Sales_History:GENRTN_3_ACT_PCT__c,SPPY_GENRTN_3_ACT_PCT__c',System.Label.G3_Activity_Rate);
        COACH_LABEL.put('Sales_History:GENRTN_3_APPT_CNT__c,SPPY_GENRTN_3_APPT_CNT__c',System.Label.G3_Appointments);
        //COACH_LABEL.put('Leader_Downline_Summary__r:Team_Qualified_Appots_Rate__c,SPPY_Team_Qualified_Appots_Rate__c',System.Label.Team+' '+System.Label.Qualified_Appointments_Rate);
        COACH_LABEL.put('Sales_History:Team_Qualified_Appots_Rate__c,SPPY_Team_Qualified_Appots_Rate__c',System.Label.Qualified_Appointments_Rate);
        COACH_LABEL.put('Sales_History:BRCHR_CNT__c,SPPY_BRCHR_CNT__c', System.Label.Brochures_Ordered);//added by subhamay_20092013 Brochures order kpi for UK
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_10_STF_CNT__c,SPPY_GENRTN_1_TITL_10_STF_CNT__c',System.Label.Nbr_of_EG1_ELs);
        //subhamay 10082013_to add proper mapping
        //COACH_LABEL.put('Sales_History:GENRTN_1_TITL_3_STF_CNT__c,SPPY_GENRTN_1_TITL_3_STF_CNT__c',System.Label.G1_Senior_EUL);
        COACH_LABEL.put('Duplicate-Sales_History:GENRTN_1_TITL_3_STF_CNT__c,SPPY_GENRTN_1_TITL_3_STF_CNT__c',System.Label.Nbr_of_EG1_SEL_Silver);
        COACH_LABEL.put('Duplicate-Sales_History:GENRTN_1_TITL_4_STF_CNT__c,SPPY_GENRTN_1_TITL_4_STF_CNT__c',System.Label.Nbr_of_EG1_SEL_Silver_Elite);
        //eoc subhamay 10082013_to add proper mapping
        COACH_LABEL.put('Sales_History:EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c,SPPY_EXGENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c',System.Label.Total_Executive_Leaders);
        COACH_LABEL.put('Sales_History:EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c,SPPY_EXGENRTN_2_TOTAL_EXEC_TITL_STF_CNT__c',System.Label.Nbr_EG2_Leaders_Total);
        COACH_LABEL.put('Sales_History:EXGENRTN_3_TOTAL_EXEC_TITL_STF_CNT__c,SPPY_EXGENRTN_TH_TOTAL_EXEC_TITL_STF_CNT__C',System.Label.Nbr_of_Els_in_EG3_plus);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_4_STF_CNT__c,SPPY_GENRTN_1_TITL_4_STF_CNT__c',System.Label.EG1_SEL_SE_Count);
        COACH_LABEL.put('Sales_History:GENRTN_1_TITL_5_STF_CNT__c,SPPY_GENRTN_1_TITL_5_STF_CNT__c',System.Label.EG1_SEL_G_plus_Count);
        //COACH_LABEL.put('',System.Label.Team+' '+System.Label.);
        // eoc subhamay 12032013 as per new requirment
        // Added level for Mail plan and TL on 06/19/2013 - by Rajib
        COACH_LABEL.put('Mail_Plan:MLPLN_CD__c',System.Label.Mail_Plan);
        COACH_LABEL.put('Mail_Plan:MailPlan_Order_Oppty__r.MLPLN_CD__c',System.Label.Mail_Plan);        
        COACH_LABEL.put('LDR_TYP__c',System.Label.Leader_Type);
        COACH_LABEL.put('ALM_Rep_Performance_1:G1_ACTV_BASE_CNT__c',System.Label.G1_Actives_Base_Count);
        COACH_LABEL.put('Sales_History:G1_Active_Base_Gap_for_CC_TY__c,G1_Active_Base_Gap_for_CC_PY__c',System.Label.G1_Actives_Base_Gap);
        COACH_LABEL.put('ALM_Rep_Performance_1:FLD_SLS_CMPGN_NR__c',System.Label.Campaign_Number);
        //EOC - By Rajib        
        
    }
    
    public static String getGenealogyReportLabel(String fldName){
            return GENEALOGY_LABEL.containsKey(fldName)?GENEALOGY_LABEL.get(fldName):fldName;
    }
    
    public static String getCoachRecordLabel(String fldName){
        return COACH_LABEL.containsKey(fldName)?COACH_LABEL.get(fldName):fldName;
    }
    
    public static String getReportColumnLabel(String fldName){
        return REPORT_LABEL_MASTER.get(fldName);
    }
    
    public static String getReportColumnFullNameLabel(String fldName) {
        return REP_FULLNAME_LABEL_MASTER.get(fldName);
    }
    
    public static String getReportFilterLabel(String fldName) {
        return REP_FILTER_LABEL_MASTER.get(fldName);
    }

    public static String getRepDetailLabel(String fldName){
        return REP_DETL_LABEL_MASTER.containsKey(fldName)?REP_DETL_LABEL_MASTER.get(fldName):fldName;
    }

    public static String getReportColumnGroupLabel(String fldName) {
        return REP_COLGROUP_LABEL_MASTER.get(fldName);
    }
    
    // Addition of New Method to get Short Column Name - 08 June, 2012
    public static String getReportShortColumn(String fldName) {
        return REP_COL_SHORT.get(fldName);
    } // End
    
    // Addition of New Method to Column Header - 08 June, 2012
    public static String getColumnHeader(String fldName) {       
        return REP_COL_HEADR.get(fldName);        
    } // End
      
}