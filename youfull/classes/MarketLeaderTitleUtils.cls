public class MarketLeaderTitleUtils {
	//return list of executive leaders and above for specific market
	public static Set<String> findELeaders(String mktId){
		Set<String> ELeaderTitles = new Set<String>();
		for(Leader_Title__c lt: [Select l.Name, l.MRKT_ID__c, l.LDRSHP_TITL_LVL_NR__c, l.Id, l.EXEC_IND__c From Leader_Title__c l
								 where MRKT_ID__c=:	mktId and EXEC_IND__c ='Y']){
				ELeaderTitles.add(lt.LDRSHP_TITL_LVL_NR__c);							 	
		}
		return ELeaderTitles;
	}
	private Map<String,String> ldrTitles = new Map<String,String>();
	private Map<String, Leader_Title__c> mapLeaderTitle = new Map<String, Leader_Title__c>(); //added Gaziz. 3/16/2012

	public void initialize(User currUser){
		ldrTitles = new Map<String,String>();
		for(Leader_Title__c ldrTitle :[	Select	Market__c, MRKT_TAG_QLFR_3_NR__c, LDRSHP_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR_NUMBER__c,
												LCL_LDRSHP_TITL_LANG_DESC_TXT__c, 
												LCL_LDRSHP_TITL_CD__c, LANG_CD__c, GENRTN_3_MIN_ORD_AMT__c, 
												GENRTN_3_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, 
												GENRTN_2_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, 
												GENRTN_1_ERNGS_PCT__c, MIN_PRSNL_SLS_REQD_AMT__c,
												MIN_GRP_SLS_REQD_AMT__c, MIN_REP_RCRTMNTS_REQD_NR__c
												//,EXEC_IND__c
										From 	Leader_Title__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey])
		{
			//ldrTitles.put(ldrTitle.LDRSHP_TITL_LVL_NR__c,ldrTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
			ldrTitles.put(ldrTitle.LDRSHP_TITL_LVL_NR__c,ldrTitle.LCL_LDRSHP_TITL_CD__c);
		}
	}		
	
	//return map of Title_Level_Number to Leader_Title_Record
	public Map<String, Leader_Title__c> initializeAndRetMapLT(User currUser) {  //added Gaziz. 3/16/2012
		mapLeaderTitle = new Map<String, Leader_Title__c>();
		for(Leader_Title__c ldrTitle :[	Select	Market__c, MRKT_TAG_QLFR_3_NR__c, LDRSHP_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR_NUMBER__c,
												LCL_LDRSHP_TITL_LANG_DESC_TXT__c, 
												LCL_LDRSHP_TITL_CD__c, LANG_CD__c, GENRTN_3_MIN_ORD_AMT__c, 
												GENRTN_3_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, 
												GENRTN_2_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, 
												GENRTN_1_ERNGS_PCT__c, MIN_PRSNL_SLS_REQD_AMT__c,
												MIN_GRP_SLS_REQD_AMT__c, MIN_REP_RCRTMNTS_REQD_NR__c
												,EXEC_IND__c
										From 	Leader_Title__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey])
		{
			mapLeaderTitle.put(ldrTitle.LDRSHP_TITL_LVL_NR__c,ldrTitle);
		}
		
		return mapLeaderTitle;
	}
	
	//List sorted by Number title badge
	public List<Leader_Title__c> initializeAndRestListSortedByTitleNumber(Id marketId, String languageKey) {
        System.debug('====================== MarketLeaderTitleUtils. marketID : ' + marketID);
        System.debug('====================== MarketLeaderTitleUtils. languageKey : ' + languageKey);
		if ((marketId == null) || 
		         (languageKey == null && languageKey.length() == 0)) {
		         	
		    return null;
		}
		
		List<Leader_Title__c> result = new List<Leader_Title__c>();
		
		result = [Select	Market__c, MRKT_TAG_QLFR_3_NR__c, LDRSHP_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR_NUMBER__c,
												LCL_LDRSHP_TITL_LANG_DESC_TXT__c, 
												LCL_LDRSHP_TITL_CD__c, LANG_CD__c, GENRTN_3_MIN_ORD_AMT__c, 
												GENRTN_3_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, 
												GENRTN_2_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, 
												GENRTN_1_ERNGS_PCT__c, MIN_PRSNL_SLS_REQD_AMT__c,
												MIN_GRP_SLS_REQD_AMT__c, MIN_REP_RCRTMNTS_REQD_NR__c
												,EXEC_IND__c
										From 	Leader_Title__c
										where	Market__r.Id =: marketId
										and		LANG_CD__c=:languageKey
										ORDER BY LDRSHP_TITL_LVL_NR_NUMBER__c asc];
										
        LandingPageUtils.debugList(result, 'Leader Title in Market Utils');
		return result;
	}


    // List sorted by String title Badge
	public List<Leader_Title__c> initializeAndRetList(User currUser){
		ldrTitles = new Map<String,String>();
		List<Leader_Title__c> tempLdrList = new List<Leader_Title__c>();
		for(Leader_Title__c ldrTitle :[	Select	Market__c, MRKT_TAG_QLFR_3_NR__c, LDRSHP_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR_NUMBER__c,
												LCL_LDRSHP_TITL_LANG_DESC_TXT__c, 
												LCL_LDRSHP_TITL_CD__c, LANG_CD__c, GENRTN_3_MIN_ORD_AMT__c, 
												GENRTN_3_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, 
												GENRTN_2_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, 
												GENRTN_1_ERNGS_PCT__c
										From 	Leader_Title__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey
										order by LDRSHP_TITL_LVL_NR__c asc])
		{
			tempLdrList.add(ldrTitle);
			ldrTitles.put(ldrTitle.LDRSHP_TITL_LVL_NR__c,ldrTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
		}
		return tempLdrList;
	}		

	public Leader_Title__c initializeAndRetTitle(User currUser,String lvlNbr){
		ldrTitles = new Map<String,String>();
		Leader_Title__c leaderTitl;
		for(Leader_Title__c ldrTitle :[	Select	Market__c, MRKT_TAG_QLFR_3_NR__c, LDRSHP_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR_NUMBER__c,
												LCL_LDRSHP_TITL_LANG_DESC_TXT__c, 
												LCL_LDRSHP_TITL_CD__c, LANG_CD__c, GENRTN_3_MIN_ORD_AMT__c, 
												GENRTN_3_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, 
												GENRTN_2_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, 
												GENRTN_1_ERNGS_PCT__c
										From 	Leader_Title__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey])
		{
			if(lvlNbr == ldrTitle.LDRSHP_TITL_LVL_NR__c){
				leaderTitl = ldrTitle;	
			}
			ldrTitles.put(ldrTitle.LDRSHP_TITL_LVL_NR__c,ldrTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
		}
		return leaderTitl;
	}		

	public void initialize(User currUser,String titleLevel){
		ldrTitles = new Map<String,String>();
		for(Leader_Title__c ldrTitle :[	Select	Market__c, MRKT_TAG_QLFR_3_NR__c, LDRSHP_TITL_LVL_NR__c, LDRSHP_TITL_LVL_NR_NUMBER__c,
												LCL_LDRSHP_TITL_LANG_DESC_TXT__c, 
												LCL_LDRSHP_TITL_CD__c, LANG_CD__c, GENRTN_3_MIN_ORD_AMT__c, 
												GENRTN_3_ERNGS_PCT__c, GENRTN_2_MIN_ORD_AMT__c, 
												GENRTN_2_ERNGS_PCT__c, GENRTN_1_MIN_ORD_AMT__c, 
												GENRTN_1_ERNGS_PCT__c
										From 	Leader_Title__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey
										and		LDRSHP_TITL_LVL_NR__c = :titleLevel])
		{
			ldrTitles.put(ldrTitle.LDRSHP_TITL_LVL_NR__c,ldrTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
		}
	}		
	
	public String getLeaderTitle(String titleLevelNbr){
		return this.ldrTitles.get(titleLevelNbr);
	}
	//subhamay 022012
	public Map<String,String> getLeaderTitle(){
		return this.ldrTitles;
	}
	//eoc subhamay 022012

    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testLeaderTitles(){
		MarketLeaderTitleUtils ctlr = new MarketLeaderTitleUtils();
		TestDataHelper testData = new TestDataHelper();
		testData.createLeaderTitles();
		User testUsr = testData.createLeaderUser('123456');
		System.runAs(testUsr){
			ctlr.initialize(testUsr);
			System.assert(ctlr.getLeaderTitle('1')=='TL 1');
			List<Leader_Title__c> tempList = ctlr.initializeAndRetList(testUsr);
			system.debug('>><><><><><<'+tempList.size());
			System.assert(tempList.size()==8);
			
			ctlr.initialize(testUsr,'1');
			System.assert(ctlr.getLeaderTitle('1')=='Title 1');
			System.assert(ctlr.initializeAndRetTitle(testUsr,'1').LCL_LDRSHP_TITL_LANG_DESC_TXT__c=='Title 1');
			ctlr.initializeAndRetTitle(testUsr,'1');
			//TODO add System.assert
			ctlr.initializeAndRetList(testUsr);
			//TODO add System.assert
			ctlr.initializeAndRestListSortedByTitleNumber(testData.market.Id,testUsr.LanguageLocaleKey);
			//TODO add System.assert
			ctlr.initializeAndRetMapLT(testUsr);
			//TODO add System.assert
		}
    	
    }*/
	

}