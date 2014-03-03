global class NRT_Overlay_Summary_Ctl extends ComponentController{
	
	public string zoneName{get;set;}
	public string marketId{get; set;}
	public string campaignId{get; set;}
	public string nextCampaignId{get; set;}
	public boolean shoEmptyDialog{get;set;}
	public boolean showHeld{get;set;}
	public boolean showSaved{get;set;}
	public Integer numColumns{get;set;}
	public string MRKT_CMPGN_SLS_ZONE_CD{get;set;}
	public Market__c mkt{get;set;}
	public User u{get;set;}
	public String campVersion{get;set;}
	public String cpgnNumber{get;set;}
	
	
	public class AlmRollup
	{
		public decimal NRT_INVC_ACTV_CNT{get;set;}// NRT_INVC_SLS_AMT
		public decimal NRT_SUBMTD_ACTV_CNT{get;set;}//NRT_SUBMTD_SLS_DISPLAY
		public decimal NRT_TOTAL_ACTV_CNT{get;set;} //NRT_TOTAL_AWRD_SLS_AMT
		public decimal NRT_HOLD_ACTV_CNT{get;set;}//NRT_HOLD_SLS_DISPLAY
		public decimal NRT_SVD_ACTV_CNT{get;set;}// NRT_SVD_SLS_DISPLAY
		//public string NRT_TOTAL_AWRD_SLS_AMT_DISP{get;set;}//NRT_TOTAL_ACTV_CNT
	}
	
	public class AlmRollupDisplay
	{
		public decimal NRT_INVC_SLS_AMT{get;set;}
		public string NRT_SUBMTD_SLS_DISPLAY{get;set;}
		public decimal NRT_TOTAL_AWRD_SLS_AMT{get;set;} 
		public string NRT_HOLD_SLS_DISPLAY{get;set;}
		public string NRT_SVD_SLS_DISPLAY{get;set;}
		public string NRT_TOTAL_AWRD_SLS_AMT_DISP{get;set;}
	}
	
	public ALM_Rep_Performance_1__c RepPerformance{get;set;}
	public AlmRollup G1Activities{get;set;}
	public AlmRollup Actives{get;set;}
	public AlmRollup Appointments{get;set;}
	public AlmRollupDisplay GroupSales{get;set;}
	
	
	public boolean getNrtEnabled()
	{
		return NRT_Utils.isNrtEnabled();
	}
	
	public NRT_Overlay_Summary_Ctl()
	{
		//geneologyKey = '5520131204035415';
		// System.Debug(':::::::: CONSTRUCTOR ::::::::';
		//repPerformance = setRepPerformance();
		//getGroupSales();
		shoEmptyDialog=false;
		showHeld = true;
		showSaved = true;
		numColumns = 5;
		if(currUser != null)
		  u = currUser;
	    else
		  u = [Select Id, ACCT_NR__c, MRKT_ID__c from User where Id = :userInfo.getUserId()];
		  
		string mktId = u.MRKT_ID__c;
		if(currMarket != null)
		  mktId = currMarket.Market_Id__c;
		
		mkt = [Select PREV_1_CMPGN_NR__c, NEXT_1_CMPGN_NR__c, CMPGN_NR__c, NRT_HAS_DLY_INVC__c, Market_Id__c,
		              NRT_HAS_SUBMTD_AMT__c, NRT_Hide_Held_Column__c, NRT_Hide_Saved_Column__c 
		         from Market__c 
		        where Market_Id__c = :mktId limit 1];
		                  
		
		if(!(mkt.NRT_HAS_DLY_INVC__c || mkt.NRT_HAS_SUBMTD_AMT__c))
		  shoEmptyDialog = true;
		
		if(mkt.NRT_Hide_Held_Column__c)
		{
		  numColumns --;
		  showHeld = false;
		}
		  
		  
		if(mkt.NRT_Hide_Saved_Column__c)
		{
		  numColumns --;
		  showSaved = false;
		}
		  
		campVersion = ApexPages.currentPage().getParameters().get('campaign');
		cpgnNumber = campaignNumber;
		
		if(campVersion == 'prior'){
                cpgnNumber = mkt.PREV_1_CMPGN_NR__c;
        }else if(campVersion == 'next'){  //campainNumber logic changed by swarnava as suggested by milon
            cpgnNumber = mkt.NEXT_1_CMPGN_NR__c;
        }else{
        	 cpgnNumber = mkt.CMPGN_NR__c;
        }
		 
		
	}
	
	public static ALM_Rep_Performance_1__c setRepPerformance(string ACCT_NR, string MRKT_ID, decimal FLD_SLS_CMPGN_NR)
	{
		for(ALM_Rep_Performance_1__c ap : [Select NRT_INVC_SLS_AMT__c
		                                        , NRT_SUBMTD_SLS_DISPLAY__c
		                                        , NRT_TOTAL_AWRD_SLS_AMT__c 
		                                        , NRT_TOTAL_SLS_DISPLAY__c
		                                        , NRT_HOLD_SLS_DISPLAY__c
		                                        , NRT_SVD_SLS_DISPLAY__c
		                                        , NRT_TOTAL_SLS_AMT__c
		                                        , NRT_SUBMTD_ORDER_CNT__c
		                                        , ACCT_NR__c
		                                        , LFT_ND_ID__c
		                                        , RGT_ND_ID__c
		                                        , ROOT_UPLN_ACCT_NR__c
		                                        , Genealogy_Level__c
		                                        , FLD_SLS_CMPGN_NR__c
		                                        , MRKT_ACCT_KEY__c
		                                        , MRKT_ID__c
		                                        , Id
		                                     from ALM_Rep_Performance_1__c
		                                     //Commented by Prakash on 09/24 to put back the fix for impersonation so that
		                                     // the correct account number ( logged in or impersonated user is set )
		                                  //  where ACCT_NR__c = :u.ACCT_NR__c
		                                 where ACCT_NR__c = :ACCT_NR
		                                   and MRKT_ID__c = :MRKT_ID
		                                   and FLD_SLS_CMPGN_NR__c = :FLD_SLS_CMPGN_NR])
		{
			return ap;
		} 
	//IF(NRT_TOTAL_SLS_AMT__c != 0, text(NRT_TOTAL_SLS_AMT__c), IF (NRT_SUBMTD_ORDER_CNT__c <= 0, '-', '0')) 
	return new ALM_Rep_Performance_1__c();
		
		
	}
	
	
	public string getNrtTimestamp()
	{
		if(mkt != null)
		  return NRT_Utils.getLastUpdatedTimeStamp(mkt.Market_Id__c); 
		else
		{
			User u = [Select MRKT_ID__c from User where Id = :UserInfo.getUserId()];
		    return NRT_Utils.getLastUpdatedTimeStamp(u.MRKT_ID__c);
		}
	}
	
	
	
	public static AlmRollup setG1Activities(ALM_Rep_Performance_1__c repPerformance)
	{
		
		AlmRollup alm2 = new AlmRollup();
		alm2.NRT_HOLD_ACTV_CNT = 0;
		alm2.NRT_INVC_ACTV_CNT = 0;
		alm2.NRT_SUBMTD_ACTV_CNT = 0;
		alm2.NRT_SVD_ACTV_CNT = 0;
		alm2.NRT_TOTAL_ACTV_CNT = 0;
		System.debug('::::::RepPerformance::::::'+RepPerformance);
		
		for(aggregateResult ap : [ Select sum(NRT_INVC_IS_ACTIVE__c) inv
                                        , sum(NRT_SBMTD_IS_ACTIVE__c) sbmtd
                                        , sum(NRT_HOLD_ORDER_CNT__c) hld
                                        , sum(NRT_SVD_ORDER_CNT__c) svd
                                       // , sum(NRT_TOTAL_SLS_AMT__c) total
                                     from ALM_Rep_Performance_1__c
                                    where LFT_ND_ID__c > :repPerformance.LFT_ND_ID__c 
									  and LFT_ND_ID__c < :repPerformance.RGT_ND_ID__c
									  and ROOT_UPLN_ACCT_NR__c = :repPerformance.ROOT_UPLN_ACCT_NR__c 
                                      and Genealogy_Level__c = :repPerformance.Genealogy_Level__c + 1
                                      and FLD_SLS_CMPGN_NR__c = :repPerformance.FLD_SLS_CMPGN_NR__c
                                    ])

		 {
		 	    alm2.NRT_INVC_ACTV_CNT = (Decimal)ap.get('inv')==null?0:(Decimal)ap.get('inv');
				alm2.NRT_SUBMTD_ACTV_CNT = (Decimal)ap.get('sbmtd')==null?0:(Decimal)ap.get('sbmtd');
				alm2.NRT_HOLD_ACTV_CNT = (Decimal)ap.get('hld')==null?0:(Decimal)ap.get('hld');
				alm2.NRT_SVD_ACTV_CNT = (Decimal)ap.get('svd')==null?0:(Decimal)ap.get('svd');
				
		 }
	   alm2.NRT_TOTAL_ACTV_CNT =  (alm2.NRT_INVC_ACTV_CNT==null?0:alm2.NRT_INVC_ACTV_CNT) + (alm2.NRT_SUBMTD_ACTV_CNT==null?0:alm2.NRT_SUBMTD_ACTV_CNT);
	   return alm2;
		
		
	}
	
	public static AlmRollup setActives(string marketId, decimal campaignId, string zoneName)
	{
		
		AlmRollup alm2 = new AlmRollup();
		alm2.NRT_HOLD_ACTV_CNT = 0;
		alm2.NRT_INVC_ACTV_CNT = 0;
		alm2.NRT_SUBMTD_ACTV_CNT = 0;
		alm2.NRT_SVD_ACTV_CNT = 0;
		alm2.NRT_TOTAL_ACTV_CNT = 0;
		
		//User u = [Select Id, ACCT_NR__c, Market_Id__c  from User where Id = :userInfo.getUserId()];
		
		string MRKT_CMPGN_SLS_ZONE_CD = marketId+campaignId+zoneName;//campaignId
		
		System.debug(':::::::::::::::MRKT_CMPGN_SLS_ZONE_CD:::::::::::::::::'+MRKT_CMPGN_SLS_ZONE_CD);
		
		for(aggregateResult ap : [ Select sum(NRT_INVC_IS_ACTIVE__c) inv
                                        , sum(NRT_SBMTD_IS_ACTIVE__c) sbmtd
                                        , sum(NRT_HOLD_ORDER_CNT__c) hld
                                        , sum(NRT_SVD_ORDER_CNT__c) svd
                                     from ALM_Rep_Performance_1__c
                                    where MRKT_CMPGN_SLS_ZONE_CD__c = :MRKT_CMPGN_SLS_ZONE_CD
                                      and NRT_IS_ACTIVE__c = true
                                    ])

		 {
		 	    alm2.NRT_INVC_ACTV_CNT = (Decimal)ap.get('inv');
		 	    System.debug(':::::::::::::::alm2.NRT_INVC_ACTV_CNT:::::::::::::::::'+ alm2.NRT_INVC_ACTV_CNT);
		
				alm2.NRT_SUBMTD_ACTV_CNT = (Decimal)ap.get('sbmtd');
				
				System.debug(':::::::::::::::alm2.NRT_SUBMTD_ACTV_CNT:::::::::::::::::'+ alm2.NRT_SUBMTD_ACTV_CNT);
				
				alm2.NRT_HOLD_ACTV_CNT = (Decimal)ap.get('hld');
				System.debug(':::::::::::::::alm2.NRT_HOLD_ACTV_CNT::::::::::::::::'+ alm2.NRT_HOLD_ACTV_CNT);
				
				alm2.NRT_SVD_ACTV_CNT = (Decimal)ap.get('svd');
				System.debug(':::::::::::::::alm2.NRT_SVD_ACTV_CNT::::::::::::::::'+ alm2.NRT_SVD_ACTV_CNT);
				
		 }
	   alm2.NRT_TOTAL_ACTV_CNT =  (alm2.NRT_INVC_ACTV_CNT==null?0:alm2.NRT_INVC_ACTV_CNT) + (alm2.NRT_SUBMTD_ACTV_CNT==null?0:alm2.NRT_SUBMTD_ACTV_CNT);
	   return alm2;
		
		
	}
	
	public static AlmRollup setAppointments(string marketId, decimal campaignId, string zoneName)
	{
		AlmRollup alm2 = new AlmRollup();
		alm2.NRT_HOLD_ACTV_CNT = 0;
		alm2.NRT_INVC_ACTV_CNT = 0;
		alm2.NRT_SUBMTD_ACTV_CNT = 0;
		alm2.NRT_SVD_ACTV_CNT = 0;
		alm2.NRT_TOTAL_ACTV_CNT = 0;
		
		string MRKT_CMPGN_SLS_ZONE_CD = marketId+campaignId+zoneName;
		
			System.debug(':::::::::::::::MRKT_CMPGN_SLS_ZONE_CD APPT:::::::::::::::::'+MRKT_CMPGN_SLS_ZONE_CD);
	
		
		for(aggregateResult ap : [ Select sum(NRT_INVC_IS_ACTIVE__c) inv
                                        , sum(NRT_SBMTD_IS_ACTIVE__c) sbmtd
                                        , sum(NRT_HOLD_IS_ACTIVE__c) hld
                                        , sum(NRT_SVD_ORDER_CNT__c) svd
                                     from ALM_Rep_Performance_1__c
                                    where MRKT_CMPGN_SLS_ZONE_CD__c = :MRKT_CMPGN_SLS_ZONE_CD
                                      and NRT_IS_ACTIVE_APPT__c = 1
                                    ])

		 {
		 	    alm2.NRT_INVC_ACTV_CNT = (Decimal)ap.get('inv')==null?0:(Decimal)ap.get('inv');
				alm2.NRT_SUBMTD_ACTV_CNT = (Decimal)ap.get('sbmtd')==null?0:(Decimal)ap.get('sbmtd');
				alm2.NRT_HOLD_ACTV_CNT = (Decimal)ap.get('hld')==null?0:(Decimal)ap.get('hld');
				alm2.NRT_SVD_ACTV_CNT = (Decimal)ap.get('svd')==null?0:(Decimal)ap.get('svd');
				
		 }
	   alm2.NRT_TOTAL_ACTV_CNT =  (alm2.NRT_INVC_ACTV_CNT==null?0:alm2.NRT_INVC_ACTV_CNT) + (alm2.NRT_SUBMTD_ACTV_CNT==null?0:alm2.NRT_SUBMTD_ACTV_CNT);
	   
	   return alm2;
		
		
	}

	
	public static AlmRollupDisplay setGroupSales(ALM_Rep_Performance_1__c repPerformance)
	{
		
		AlmRollupDisplay alm3 = new AlmRollupDisplay();
		
		
		for(AggregateResult ar : [Select sum(NRT_INVC_SLS_AMT__c) invcdSales
									   , sum(NRT_SUBMTD_RTURN_AWRD_SLS_AMT__c) sbmt_rtn
		                               , sum(NRT_SUBMTD_AWRD_SLS_AMT__c) sbmt_awrd
		                               , sum(NRT_SUBMTD_AWRD_ORDER_CNT__c) awd_cnt
		                               , sum(NRT_SUBMTD_AWRD_RTURN_ORDER_CNT__c) awd_rtn_cnt
		                               , sum(NRT_SUBMTD_ORDER_CNT__c) sbmt_ord_cnt
                                       , sum(NRT_HOLD_SLS_AMT__c) hld_sls
                                       , sum(NRT_HOLD_ORDER_CNT__c) hld_ord
                                       , sum(NRT_SVD_ORDER_CNT__c) svd_cnt
                                       , sum(NRT_SVD_ORDER_AMT__c) svd_amt
                                       , sum(NRT_TOTAL_SLS_AMT__c) total
                                    from ALM_Rep_Performance_1__c
		                           where LFT_ND_ID__c >= :repPerformance.LFT_ND_ID__c 
								     and LFT_ND_ID__c <= :repPerformance.RGT_ND_ID__c
									 and Genealogy_Level__c >= :repPerformance.Genealogy_Level__c 
		                             and Genealogy_Level__c <= :repPerformance.Genealogy_Level__c + 3
									 and ROOT_UPLN_ACCT_NR__c = :repPerformance.ROOT_UPLN_ACCT_NR__c 
	                                 and FLD_SLS_CMPGN_NR__c = :repPerformance.FLD_SLS_CMPGN_NR__c])
		{
			alm3.NRT_INVC_SLS_AMT = (Decimal) ar.get('invcdSales')==null?0:(Decimal) ar.get('invcdSales');
			
			decimal sbmt_ord_cnt = (Decimal)ar.get('sbmt_ord_cnt')==null?0:(Decimal)ar.get('sbmt_ord_cnt');
			decimal sbmt_awrd = (Decimal)ar.get('sbmt_awrd')==null?0:(Decimal)ar.get('sbmt_awrd');
			decimal sbmt_rtn = (Decimal)ar.get('sbmt_rtn')==null?0:(Decimal)ar.get('sbmt_rtn');
			decimal awd_cnt = (Decimal)ar.get('awd_cnt')==null?0:(Decimal)ar.get('awd_cnt');
			if(sbmt_ord_cnt <= 0)
			  alm3.NRT_SUBMTD_SLS_DISPLAY = '-';
			else if(sbmt_awrd != null && sbmt_rtn != null & (sbmt_awrd != 0 || sbmt_rtn != 0))
			   alm3.NRT_SUBMTD_SLS_DISPLAY = (sbmt_rtn+sbmt_awrd).format();
			else if(awd_cnt > 0)
			  alm3.NRT_SUBMTD_SLS_DISPLAY = 'Y';
			else
			  alm3.NRT_SUBMTD_SLS_DISPLAY = 'R';
			
			//Fixed the saved field issue by creating the additional roll up summary field..commented the below line and added the section below
			//alm3.NRT_SVD_SLS_DISPLAY = (Decimal)ar.get('awd_cnt') > 0  ? 'Y': '-';
			
			decimal hld_sls = (Decimal)ar.get('hld_sls');
			decimal hld_ord = (Decimal)ar.get('hld_ord');
			
			if(hld_sls > 0)
			  alm3.NRT_HOLD_SLS_DISPLAY = hld_sls.format();
			else if(hld_ord > 0)
			  alm3.NRT_HOLD_SLS_DISPLAY = 'Y';
			else
			  alm3.NRT_HOLD_SLS_DISPLAY = '-';
			  
			decimal svd_cnt = (Decimal)ar.get('svd_cnt');
			decimal svd_amt = (Decimal)ar.get('svd_amt');
			
			/*Added by Prakash on 10/23 to add the code to use saved amount field instead of saved count : START */
			if(svd_amt > 0)
			  alm3.NRT_SVD_SLS_DISPLAY = svd_amt.format();
			else if(svd_cnt > 0)
			  alm3.NRT_SVD_SLS_DISPLAY = 'Y';
			else
			  alm3.NRT_SVD_SLS_DISPLAY = '-';
			
			/*Added by Prakash on 10/23 to add the code to use saved amount field instead of saved count : END */
			  
		    alm3.NRT_TOTAL_AWRD_SLS_AMT = (Decimal)ar.get('total')==null?0:(Decimal)ar.get('total');
		    if(alm3.NRT_TOTAL_AWRD_SLS_AMT > 0)
		      alm3.NRT_TOTAL_AWRD_SLS_AMT_DISP = alm3.NRT_TOTAL_AWRD_SLS_AMT.format();
		    else if (sbmt_ord_cnt <= 0) 
		      alm3.NRT_TOTAL_AWRD_SLS_AMT_DISP = '-';
		    else alm3.NRT_TOTAL_AWRD_SLS_AMT_DISP = '0';
		}
		
		
		return alm3;
	}
	
	@RemoteAction
    public static string refreshData( string ACCT_NR
		                             ,string MRKT_ID
		                             ,decimal FLD_SLS_CMPGN_NR
		                             ,string zoneName
		                             ,boolean showHeld //Added by Prakash on 10/22 to account for hide or show held nos.
		                             ,boolean showSaved//Added by Prakash on 10/22 to account for hide or show held nos.
		                             )
    {
    	//set the ALM Rep Record
    	ALM_Rep_Performance_1__c RepPerformance = setRepPerformance(ACCT_NR, MRKT_ID, FLD_SLS_CMPGN_NR);
    	
    	string html = '<tr>';
    	if(zoneName == null || zoneName == '')
    	{
	    	
	    	html += '<td class="decimal-align">'+RepPerformance.NRT_INVC_SLS_AMT__c+'</td>';
	    	html += '<td class="decimal-align">'+RepPerformance.NRT_SUBMTD_SLS_DISPLAY__c+'</td>';
	    	html += '<td class="decimal-align">'+RepPerformance.NRT_TOTAL_SLS_DISPLAY__c+'</td>';
	    	//Changes by Prakash on 10/22 to account for hide or show held nos: START
	        if(showHeld){
	            html += '<td class="decimal-align">'+RepPerformance.NRT_HOLD_SLS_DISPLAY__c+'</td>';
	        }
	        if(showSaved){
	            html += '<td class="decimal-align">'+RepPerformance.NRT_SVD_SLS_DISPLAY__c+'</td>';
	        }
	        //Changes by Prakash on 10/22 to account for hide or show held nos: END

	        html += '</tr>';
	        
	        
	        AlmRollup a = setG1Activities(RepPerformance);
			html += '<tr>';
			html += '<td class="decimal-align table-gray_bg">'+a.NRT_INVC_ACTV_CNT.format()+'</td>';
			html += '<td class="decimal-align table-gray_bg">'+a.NRT_SUBMTD_ACTV_CNT.format()+'</td>';
			html += '<td class="decimal-align table-gray_bg">'+a.NRT_TOTAL_ACTV_CNT.format()+'</td>';
		    
		    //Changes by Prakash on 10/22 to account for hide or show held nos: START
	    	if(showHeld){
			 	html += '<td class="decimal-align table-gray_bg">'+a.NRT_HOLD_ACTV_CNT.format()+'</td>';
			
			 }
			 
			 if(showSaved){
			   	html += '<td class="decimal-align table-gray_bg">'+a.NRT_SVD_ACTV_CNT.format()+'</td>';
			
			 }
	         	//Changes by Prakash on 10/22 to account for hide or show held nos: END
	    
			 
			html += '</tr>';
			
			AlmRollupDisplay g = setGroupSales(RepPerformance);
			html += '<tr>';
	    	html += '<td class="decimal-align">'+g.NRT_INVC_SLS_AMT.format()+'</td>';
	    	html += '<td class="decimal-align">'+g.NRT_SUBMTD_SLS_DISPLAY+'</td>';
	    	html += '<td class="decimal-align">'+g.NRT_TOTAL_AWRD_SLS_AMT_DISP+'</td>';
	    	
	    	//Changes by Prakash on 10/22 to account for hide or show held nos: START
	    
	    	if(showHeld){
			 	html += '<td class="decimal-align">'+g.NRT_HOLD_SLS_DISPLAY+'</td>';
	    	 }
			 
			 if(showSaved){
			   	html += '<td class="decimal-align">'+g.NRT_SVD_SLS_DISPLAY+'</td>';
	    	 }
	    	 //Changes by Prakash on 10/22 to account for hide or show held nos: END
	    
			 
			  html += '</tr>';
    	}
    	else
    	{
    		try{
	    		AlmRollup a = setActives(MRKT_ID, FLD_SLS_CMPGN_NR, zoneName);
				html += '<tr>';
				html += '<td class="decimal-align">'+(a.NRT_INVC_ACTV_CNT ==null?'0': a.NRT_INVC_ACTV_CNT.format())+'</td>';
				html += '<td class="decimal-align">'+(a.NRT_SUBMTD_ACTV_CNT ==null?'0': a.NRT_SUBMTD_ACTV_CNT.format())+'</td>';
				html += '<td class="decimal-align">'+(a.NRT_TOTAL_ACTV_CNT ==null?'0': a.NRT_TOTAL_ACTV_CNT.format())+'</td>';
				
				//Changes by Prakash on 10/22 to account for hide or show held nos: START
	    
				if(showHeld){
					html += '<td class="decimal-align">'+(a.NRT_HOLD_ACTV_CNT ==null?'0': a.NRT_HOLD_ACTV_CNT.format())+'</td>';
			    }
			 
			    if(showSaved){
			   		html += '<td class="decimal-align">'+(a.NRT_SVD_ACTV_CNT ==null?'0': a.NRT_SVD_ACTV_CNT.format())+'</td>';
			    }
			    //Changes by Prakash on 10/22 to account for hide or show held nos: END
	    
			    
				html += '</tr>';
				
	    		AlmRollup a2 = setAppointments(MRKT_ID, FLD_SLS_CMPGN_NR, zoneName);
				html += '<tr>';
				html += '<td class="decimal-align table-gray_bg">'+(a2.NRT_INVC_ACTV_CNT ==null?'0': a2.NRT_INVC_ACTV_CNT.format())+'</td>';
				html += '<td class="decimal-align table-gray_bg">'+(a2.NRT_SUBMTD_ACTV_CNT ==null?'0': a2.NRT_SUBMTD_ACTV_CNT.format())+'</td>';
				html += '<td class="decimal-align table-gray_bg">'+(a2.NRT_TOTAL_ACTV_CNT ==null?'0': a2.NRT_TOTAL_ACTV_CNT.format())+'</td>';
				
				//Changes by Prakash on 10/22 to account for hide or show held nos: START
	    
				if(showHeld){
			 	     html += '<td class="decimal-align table-gray_bg">'+(a2.NRT_HOLD_ACTV_CNT ==null?'0': a2.NRT_HOLD_ACTV_CNT.format())+'</td>';
			    }
			 
			    if(showSaved){
			   	    html += '<td class="decimal-align table-gray_bg">'+(a2.NRT_SVD_ACTV_CNT ==null?'0': a2.NRT_SVD_ACTV_CNT.format())+'</td>';
			    }
			    //Changes by Prakash on 10/22 to account for hide or show held nos: END
	    
			 
			    html += '</tr>';
    		}
    		catch(Exception e)
    		{
    			System.debug('::::::::::ERROR:::::::::::'+e.getMessage());
    			html += '<tr><td class="decimal-align">&nbsp;</td><td class="decimal-align">&nbsp;</td><td class="decimal-align">&nbsp;</td></tr>';
    			html += '<tr><td class="decimal-align table-gray_bg" colspan=3>'+e.getMessage()+'</td></tr>';
    		}
			
			
    	}
		 
    	
    	return html;
    	
    	
    }
		

}