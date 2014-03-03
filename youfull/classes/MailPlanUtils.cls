public class MailPlanUtils {
    //Array of all mail plan data for that market
    private List<MailPlan_Order_Oppty__c> mailPlans;
    private Map<Date,List<MailPlan_Order_Oppty__c>> mplnsByDate;
    private Map<String,List<MailPlan_Order_Oppty__c>> mplnsByZone;
    private Date nextMPlnEndDt;
    //Market
    private Market__c market;
    public Contact repDetail {get; set;}

    public MailPlanUtils(Market__c market){
        this.market=market;
        initializeMailPlanData();
    }
    public MailPlanUtils(){
    }
    
    public void setMarket(Market__c mkt){
        this.market=mkt;
    }   
    
    private void initializeMailPlanData(){
        Date currDate = System.today();
        //System.debug(' initializeMailPlanData  currDate :'+currDate);
        List<MailPlan_Order_Oppty__c> mplnList;
        mplnsByDate = new Map<Date,List<MailPlan_Order_Oppty__c>>();
        mplnsByZone = new Map<String,List<MailPlan_Order_Oppty__c>>();
        //System.debug('@@@@  nextMPlnEndDt :'+nextMPlnEndDt);
        for(MailPlan_Order_Oppty__c mailPlan:[  Select  SLS_ZONE_CD__c, NEXT_MLPLN_TO_CLOS_CD__c, MRKT_ID__c, 
                                                        MLPLN_CD__c, CURRNT_NEXT_CMPGN_PRFX_CD__c, 
                                                        CURRNT_CMPGN_ONLN_RMN_DAY_CNT__c, CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c, 
                                                        CMPGN_NR__c ,MLPLN_END_DT__c
                                                From    MailPlan_Order_Oppty__c 
                                                where   Market__c = :this.market.Id
                                                order by MLPLN_END_DT__c,MLPLN_CD__c,CURRNT_NEXT_CMPGN_PRFX_CD__c
                                                LIMIT 9999])
        {
            //log('Processing mail Plan data:'+mailPlan);
            if(nextMPlnEndDt == null && currDate < mailPlan.MLPLN_END_DT__c ){
                log('setting nextMPlnEndDt to '+mailPlan.MLPLN_END_DT__c);
                this.nextMPlnEndDt=mailPlan.MLPLN_END_DT__c;
            }
            //Add mail plan to the Date grouping. Skip this group for any mail plans where the 
            //mail plan end date is not the earliest end date
            if(mailPlan.MLPLN_END_DT__c == nextMplnEndDt){
                mplnList = mplnsByDate.get(mailPlan.MLPLN_END_DT__c);
                log('Matching mailplans for date:'+mailPlan.MLPLN_END_DT__c+'='+mplnList);
                if(mplnList==null){
                    log('No matching mailplans found for date:'+mailPlan.MLPLN_END_DT__c);
                    mplnList = new List<MailPlan_Order_Oppty__c>();
                    mplnsByDate.put(mailPlan.MLPLN_END_DT__c,mplnList);
                }
                mplnList.add(mailPlan);
            }           
            //Add mail plan to the Zone Grouping
            mplnList = mplnsByZone.get(mailPlan.SLS_ZONE_CD__c);
            if(mplnList==null){
                mplnList = new List<MailPlan_Order_Oppty__c>();
                mplnsByZone.put(mailPlan.SLS_ZONE_CD__c,mplnList);
            }
            mplnList.add(mailPlan);
        }
    }
   
    private void log(String message){
        ALMLogUtils.log('MailPlanUtils',message);
    }
    
   //Method added by Milon on 8/29 
   public String getNextMailPlansToClose(){
		log('nextMPlnEndDt='+this.nextMPlnEndDt);
		String nextMPlnsToClose='';
		if(this.nextMPlnEndDt!=null){
			List<MailPlan_Order_Oppty__c> mailPlans = this.mplnsByDate.get(this.nextMPlnEndDt);
			
			for(MailPlan_Order_Oppty__c mailPlan: mailPlans){
				if(mailPlan.MLPLN_CD__c !='DFLT' && nextMPlnsToClose.indexOf(mailPlan.MLPLN_CD__c)<0){
					log('Mail Plan "'+mailPlan.MLPLN_CD__c+'" was previously not added to list of mail plans');
					nextMPlnsToClose +=mailPlan.MLPLN_CD__c+',';
				}
			}
			//Trim out the last ','
			log('nextMPlnsToClose='+nextMPlnsToClose);
			if(nextMplnsToClose.length()>0){
				nextMPlnsToClose = nextMPlnsToClose.substring(0,nextMPlnsToClose.length()-1);
			}
		} 		
		return nextMPlnsToClose;
	}
	
	
    
    // Method added by Swarnava on 25th Jun 2013 - Mail Plan Record Retrieval for Sales Leader
    public static List<sObject> getRepPerf_MailPlan(String obj_to_query, String acct_no, String mrkt_Id)
    {
        System.debug('\n #### acct_no -- '+acct_no+', mrkt_Id -- '+mrkt_Id);
        String query_str = 'SELECT Id, MailPlan_Order_Oppty__c, MailPlan_Order_Oppty__r.CMPGN_NR__c, MailPlan_Order_Oppty__r.MLPLN_CD__c,'+ 
                             'MailPlan_Order_Oppty__r.MLPLN_END_DT__c, MailPlan_Order_Oppty__r.MLPLN_STRT_DT__c,'+ 
                              'MailPlan_Order_Oppty__r.SLS_ZONE_CD__c, MailPlan_Order_Oppty__r.NEXT_MLPLN_TO_CLOS_CD__c';
        
        query_str+=' FROM '+obj_to_query;
        
        String whereClause = ' WHERE ACCT_NR__c=:acct_no AND MRKT_ID__c=:mrkt_Id AND MailPlan_Order_Oppty__r.MLPLN_CLOSD_IND__c !=\'Y\'';
        //Date currDate = System.today();
        DateTime d = datetime.now();
        String timeStr = d.format('yyyy-MM-dd');
        whereClause+=' AND MailPlan_Order_Oppty__r.MLPLN_END_DT__c >= '+timeStr+' ORDER BY MailPlan_Order_Oppty__r.MLPLN_END_DT__c ';
        
        query_str+= whereClause;
        
        System.debug('\n ======= MailPlanUtil.query_str SL ======= \n'+query_str);
        List<sObject> lst = Database.query(query_str);//should return 3 records prior,current,next campaign
        return lst;
    }
    
    
    // Method added by Raktim on 27th Jun 2013 - Mail Plan Record Retrieval for Zone / Division Manager
    public static String getMailPlanCampaignZMDM(String zones, String mrkt_Id)
    {
        String mailPlanCmpgnZMDM = '';
        
        String query_str = 'SELECT CMPGN_NR__c, MLPLN_END_DT__c, MLPLN_STRT_DT__c, MLPLN_CLOSD_IND__c';
        
        query_str+=' FROM MailPlan_Order_Oppty__c';
        
        String whereClause = ' WHERE SLS_ZONE_CD__c IN ( '+zones+')  AND MRKT_ID__c= \''+mrkt_Id+'\' AND MLPLN_CLOSD_IND__c !=\'Y\'';
        
        DateTime d = datetime.now();
        String timeStr = d.format('yyyy-MM-dd');
        whereClause+=' AND MLPLN_END_DT__c >= '+timeStr+' ORDER BY MLPLN_END_DT__c ';
        
        query_str+= whereClause;
        
        System.debug('\n ======= MailPlanUtil.getMailPlanCampaignZMDM query_str ZM_DM ======= \n'+query_str);
        List<MailPlan_Order_Oppty__c> lstMailPln = Database.query(query_str); //should return 3 records prior,current,next campaign
        System.debug('\n ======= MailPlanUtil.getMailPlanCampaignZMDM lstMailPln ZM_DM ======= \n'+lstMailPln);
        
        mailPlanCmpgnZMDM = YOUUtil.getCampaignNumbrMailPlan(lstMailPln[0].CMPGN_NR__c);
        System.debug('\n ======= MailPlanUtil.getMailPlanCampaignZMDM mailPlanCmpgnZMDM ======= '+mailPlanCmpgnZMDM);
        
        return mailPlanCmpgnZMDM;
    }
    
    public  MailPlan_Order_Oppty__c getMailPlanForDivManager(User currUsr){

        String campaignNbrs='';
        List<MailPlan_Order_Oppty__c> mailPlans;
        String divMailPlans = '';
        for(Sales_Organization__c slsOrg: [ Select  SLS_REGN_NM__c,
                                                    SLS_ZONE_CD__c
                                            From    Sales_Organization__c 
                                            where   SLS_DIV_NM__c=:currUsr.DFALT_DIV_NM__c
                                            and     SLS_ORG_LVL_CD__c='Z'])
        {   
            System.debug('inside getmailplanfordivmanage loop');
            System.debug('testing-->'+slsOrg.SLS_ZONE_CD__c+'---'+this.mplnsByZone);
            mailPlans = this.mplnsByZone.get(slsOrg.SLS_ZONE_CD__c);
            System.debug('mailplans got--->'+mailPlans);
            if(mailPlans!=null && mailPlans.size()>0){
                for(MailPlan_Order_Oppty__c mailPlan: mailPlans){
                    log('getMailPlanForDivision:Processing mail plan:'+mailPlan);
                    //Add the campaign number only if the mail plan is yet to close
                    if(mailPlan.MLPLN_END_DT__c>System.today() && divMailPlans.indexOf(mailPlan.MLPLN_CD__c)==-1){
                        log('getMailPlanForDivision:Adding Campaign Number:'+mailPlan.CMPGN_NR__c+' to list of campaigns');
                        if(campaignNbrs.indexOf(mailPlan.CMPGN_NR__c)==-1){
                            campaignNbrs+=YOUUtil.getCampaignNumbrMailPlan(mailPlan.CMPGN_NR__c)+',';
                        }
                    }
                    if(divMailPlans.indexOf(mailPlan.MLPLN_CD__c)==-1){
                        divMailPlans+=mailPlan.MLPLN_CD__c+',';
                    }
                }
            }
        }
        if(campaignNbrs.length()>0){
            campaignNbrs = campaignNbrs.substring(0,campaignNbrs.length()-1);
        }
        log('getMailPlanForDivision:campaignNbrs='+campaignNbrs);
        return new MailPlan_Order_Oppty__c(CMPGN_NR__c=campaignNbrs);       

    }
    
   public static testmethod void testNext3MailPlansToClose(){
		TestDataHelper testData = new TestDataHelper();
		testData.createMailPlanMarket('XX');
		List<MailPlan_Order_Oppty__c> mailPlans = testData.createMailPlans();
		Market__c mkt = testData.market;
		mkt.Action_Item_Mail_Plans__c=3;
		update mkt;
		
		MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
		mplnUtils.setMarket(mkt);
		String expectedMplans = '\'M0\',\'M1\',\'M2\',\'M3\',\'M4\'';
		//System.assert(expectedMplans.equals(mplnUtils.getMailPlansClosingNextNDays()));
	}	
	
	public static testmethod void testMailPlanForZoneManager(){
		String acctNbr = '123456';
		TestDataHelper testData = new TestDataHelper();
		testData.createMailPlanMarket('XX');
        User testUsr = testData.createZoneUser('123456');
		List<MailPlan_Order_Oppty__c> mailPlans = testData.createMailPlans();
		testUsr = [Select 	Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
								LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
								DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
						From User
						where Id = :testUsr.Id];		
		Market__c mkt = testData.market;
		MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
		MailPlan_Order_Oppty__c mplan = mplnUtils.getMailPlanForDivManager(testUsr);
		
	}
	
	/*
	public static testmethod void testMailPlanForZoneManager2(){
		String acctNbr = '123456';
		TestDataHelper testData = new TestDataHelper();
		testData.createMailPlanMarket('XX');
        User testUsr = testData.createZoneUser('123456');
		testUsr = [Select 	Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
								LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
								DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
						From User
						where Id = :testUsr.Id];		
		Market__c mkt = testData.market;
		MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
		String mktid = 'DE';
		String zone = '201';
		List<MailPlan_Order_Oppty__c> mailPlans = testData.createMailPlans();
		String mplan = MailPlanUtils.getMailPlanCampaignZMDM(mailPlans[0].SLS_ZONE_CD__c,mailPlans[0].MRKT_ID__c);
		
	}*/
    
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testMailPlanForSalesLeader(){
		String acctNbr = '123456';
		TestDataHelper testData = new TestDataHelper();
		testData.createMailPlanMarket('XX');
		List<MailPlan_Order_Oppty__c> mailPlans = testData.createMailPlans();
		User ldrUsr = testData.createLeaderUser(acctNbr);
		ldrUsr = [Select 	Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
								LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
								DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
						From User
						where Id = :ldrUsr.Id];		
		Contact ct = testData.createContact(acctNbr,ldrUsr.Id);
		Market__c mkt = testData.market;
		MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
		mplnUtils.repDetail=ct;
		// Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
		ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
	                                            Name = 'Test REP1', ACCT_NR__c = acctNbr,
	                                            Genealogy_Level__c = 0,
	                                            CurrencyISOCode='USD',
	                                            MRKT_ID__c=mkt.Market_ID__c,
	                                            MRKT_ACCT_KEY__c = ct.Id,
	                                            FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mkt.CMPGN_NR__c),
	                                            OPERTNL_CMPGN_NR__c =mkt.CMPGN_NR__c,
	                                            REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
	                                            LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
	                                            ROOT_UPLN_ACCT_NR__c = acctNbr,
	                                            MailPlan_Order_Oppty__c = mailPlans[0].Id,
	                                            LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
	                                        );
	    lstRepPerf.add(rep1);
	    insert lstRepPerf;
		List<ALM_Rep_Performance_1__c> mplan = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c ,acctNbr ,mkt.Market_Id__c );
		System.assert(mplan[0].MailPlan_Order_Oppty__r.MLPLN_CD__c==mailPlans[0].MLPLN_CD__c);
		//System.assert(mplan[0].MailPlan_Order_Oppty__r.CURRNT_NEXT_CMPGN_PRFX_CD__c=='C');
		
	}*/
}