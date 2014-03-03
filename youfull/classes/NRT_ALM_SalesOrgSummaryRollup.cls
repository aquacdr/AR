global class NRT_ALM_SalesOrgSummaryRollup implements Schedulable 
{ 
	/**
		
	**/
	global void execute (SchedulableContext ctx) 
	
	{ 
		map<string, Integer> SalesOrgSummaryActive = new map<string, Integer>();
		map<string, Integer> SalesOrgSummaryInvoiced = new map<string, Integer>();
		map<string, Integer> SalesOrgSummaryAppointment = new map<string, Integer>();
		//map<string, AlmCounts> SalesOrgSummaryCounts = new map<string, AlmCounts>();
		set<String> marketKeys = new set<String>();
		for(Market__c m : [Select Market_Id__c from Market__c where Batch_Load_In_Process__c = false and NRT_Enabled__c = true])  
		{
			marketKeys.add(m.Market_Id__c);
		}
		//NRT_SBMTD_ACTIVE_CNT 
		for(AggregateResult r1 :[select sum(NRT_SBMTD_IS_ACTIVE__c)  cnt
		                              , SLS_ORG_SUMRY_KEY__c
		                           from ALM_Rep_Performance_1__c 
		                          where NRT_SBMTD_IS_ACTIVE__c = 1 
		                            and CHK_NRT_SBMTD_IS_ACTIVE__c = false
		                            and MRKT_ID__c in :marketKeys
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		string sosId = (String)r1.get('MRKT_ID__c') +(String)r1.get('FLD_SLS_CMPGN_NR__c')+ 'Z' +(String)r1.get('SLS_ZONE_CD__c');
	   		Integer cnt = (Integer)r1.get('cnt');
	   		if(SalesOrgSummaryActive.containsKey(sosId))
	   		{
	   			Integer x = SalesOrgSummaryActive.get(sosId);
	   			x += cnt;
	   			SalesOrgSummaryActive.put(sosId, x);
	   		}
	   		else
	   		{
	   			SalesOrgSummaryActive.put(sosId, cnt);
	   		}
	   } 
	   //NRT_INVC_ACTIVE_CNT 
		for(AggregateResult r1 :[select count(Id) cnt 
		                              , SLS_ORG_SUMRY_KEY__c 
		                           from ALM_Rep_Performance_1__c 
		                          where NRT_INVC_IS_ACTIVE__c = 1 
		                            and CHK_NRT_INVC_IS_ACTIVE__c = false
		                            and MRKT_ID__c in :marketKeys
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		string sosId = (String)r1.get('MRKT_ID__c') +(String)r1.get('FLD_SLS_CMPGN_NR__c')+ 'Z' +(String)r1.get('SLS_ZONE_CD__c');
	   		Integer cnt = (Integer)r1.get('cnt');
	   		if(SalesOrgSummaryInvoiced.containsKey(sosId))
	   		{
	   			Integer x = SalesOrgSummaryInvoiced.get(sosId);
	   			x += cnt;
	   			SalesOrgSummaryInvoiced.put(sosId, x);
	   		}
	   		else
	   		{
	   			SalesOrgSummaryInvoiced.put(sosId, cnt);
	   		}
	   } 
	   //NRT_ACTIVE_APPT_CNT 
		for(AggregateResult r1 :[select count(Id) 
		                              , SLS_ORG_SUMRY_KEY__c
		                           from ALM_Rep_Performance_1__c 
		                          where NRT_IS_ACTIVE_APPT__c = 1
		                            and CHK_NRT_IS_ACTIVE_APPT__c = false
		                            and MRKT_ID__c in :marketKeys
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		string sosId = (String)r1.get('MRKT_ID__c') +(String)r1.get('FLD_SLS_CMPGN_NR__c')+ 'Z' +(String)r1.get('SLS_ZONE_CD__c');
	   		Integer cnt = (Integer)r1.get('cnt');
	   		if(SalesOrgSummaryAppointment.containsKey(sosId))
	   		{
	   			Integer x = SalesOrgSummaryAppointment.get(sosId);
	   			x += cnt;
	   			SalesOrgSummaryAppointment.put(sosId, x);
	   		}
	   		else
	   		{
	   			SalesOrgSummaryAppointment.put(sosId, cnt);
	   		}
	   } 
	   
	   //==============================
	   //Negative amounts
	   
	  for(AggregateResult r1 :[select count(Id)  cnt
		                              , SLS_ORG_SUMRY_KEY__c
		                           from ALM_Rep_Performance_1__c 
		                          where NRT_SBMTD_IS_ACTIVE__c = 0 
		                            and CHK_NRT_SBMTD_IS_ACTIVE__c = false
		                            and MRKT_ID__c in :marketKeys
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		string sosId = (String)r1.get('MRKT_ID__c') +(String)r1.get('FLD_SLS_CMPGN_NR__c')+ 'Z' +(String)r1.get('SLS_ZONE_CD__c');
	   		Integer cnt = (Integer)r1.get('cnt');
	   		if(SalesOrgSummaryActive.containsKey(sosId))
	   		{
	   			Integer x = SalesOrgSummaryActive.get(sosId);
	   			x -= cnt;
	   			SalesOrgSummaryActive.put(sosId, x);
	   		}
	   		else
	   		{
	   			SalesOrgSummaryActive.put(sosId, 0-cnt);
	   		}
	   } 
	   //NRT_INVC_ACTIVE_CNT 
		for(AggregateResult r1 :[select count(Id) cnt 
		                              , SLS_ORG_SUMRY_KEY__c 
		                           from ALM_Rep_Performance_1__c 
		                          where NRT_INVC_IS_ACTIVE__c =0 
		                            and CHK_NRT_INVC_IS_ACTIVE__c = false
		                            and MRKT_ID__c in :marketKeys
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		string sosId = (String)r1.get('MRKT_ID__c') +(String)r1.get('FLD_SLS_CMPGN_NR__c')+ 'Z' +(String)r1.get('SLS_ZONE_CD__c');
	   		Integer cnt = (Integer)r1.get('cnt');
	   		if(SalesOrgSummaryInvoiced.containsKey(sosId))
	   		{
	   			Integer x = SalesOrgSummaryInvoiced.get(sosId);
	   			x -= cnt;
	   			SalesOrgSummaryInvoiced.put(sosId, x);
	   		}
	   		else
	   		{
	   			SalesOrgSummaryInvoiced.put(sosId, 0-cnt);
	   		}
	   } 
	   //NRT_ACTIVE_APPT_CNT 
		for(AggregateResult r1 :[select count(Id) 
		                              , SLS_ORG_SUMRY_KEY__c
		                           from ALM_Rep_Performance_1__c 
		                          where NRT_IS_ACTIVE_APPT__c = 0
		                            and CHK_NRT_IS_ACTIVE_APPT__c = false
		                            and MRKT_ID__c in :marketKeys
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		string sosId = (String)r1.get('MRKT_ID__c') +(String)r1.get('FLD_SLS_CMPGN_NR__c')+ 'Z' +(String)r1.get('SLS_ZONE_CD__c');
	   		Integer cnt = (Integer)r1.get('cnt');
	   		if(SalesOrgSummaryAppointment.containsKey(sosId))
	   		{
	   			Integer x = SalesOrgSummaryAppointment.get(sosId);
	   			x -= cnt;
	   			SalesOrgSummaryAppointment.put(sosId, x);
	   		}
	   		else
	   		{
	   			SalesOrgSummaryAppointment.put(sosId, 0-cnt);
	   		}
	   } 
	   
	   list<Sales_Org_Summary__c> sosUpdateList = new  list<Sales_Org_Summary__c>();
	   for(Sales_Org_Summary__c sos : [Select Id
	                                        , NRT_SBMTD_ACTIVE_CNT__c
	                                        , NRT_INVC_ACTIVE_CNT__c
	                                        , NRT_ACTIVE_APPT_CNT__c
	                                        , SLS_ORG_SUMRY_KEY__c
	                                     from Sales_Org_Summary__c
	                                    where SLS_ORG_SUMRY_KEY__c in :SalesOrgSummaryAppointment.keySet()
	                                       or SLS_ORG_SUMRY_KEY__c in :SalesOrgSummaryInvoiced.keySet()
	                                       or SLS_ORG_SUMRY_KEY__c in :SalesOrgSummaryActive.keySet()]) 
	  {
	  	  if(SalesOrgSummaryAppointment.containsKey(sos.SLS_ORG_SUMRY_KEY__c))
	  	     sos.NRT_ACTIVE_APPT_CNT__c += SalesOrgSummaryAppointment.get(sos.SLS_ORG_SUMRY_KEY__c);
	  	  
	  	  if(SalesOrgSummaryInvoiced.containsKey(sos.SLS_ORG_SUMRY_KEY__c))
	  	     sos.NRT_INVC_ACTIVE_CNT__c += SalesOrgSummaryInvoiced.get(sos.SLS_ORG_SUMRY_KEY__c);
	  	     
	  	  if(SalesOrgSummaryActive.containsKey(sos.SLS_ORG_SUMRY_KEY__c))
	  	     sos.NRT_SBMTD_ACTIVE_CNT__c += SalesOrgSummaryActive.get(sos.SLS_ORG_SUMRY_KEY__c);
	  	     
	  	  sosUpdateList.add(sos);
	  }
	  
	  //Set the counts on the Sales Org Summary Records
	  if(sosUpdateList.size() > 0)
	    update sosUpdateList;
	    
	  //flip the flags to false on the ALM Records
	  list<ALM_Rep_Performance_1__c> almRepUpdateList = new list<ALM_Rep_Performance_1__c>();
	  for(ALM_Rep_Performance_1__c rep : [select Id
	                                            , CHK_NRT_IS_ACTIVE_APPT__c
	                                            , CHK_NRT_INVC_IS_ACTIVE__c
	                                            , CHK_NRT_SBMTD_IS_ACTIVE__c
	                                         from ALM_Rep_Performance_1__c
	                                        where CHK_NRT_SBMTD_IS_ACTIVE__c = false
	                                           or CHK_NRT_INVC_IS_ACTIVE__c = false
	                                           or CHK_NRT_IS_ACTIVE_APPT__c = false])
	  {
		  rep.CHK_NRT_SBMTD_IS_ACTIVE__c = true;
		  rep.CHK_NRT_INVC_IS_ACTIVE__c = true;
	      rep.CHK_NRT_IS_ACTIVE_APPT__c = true;
	    
	      almRepUpdateList.add(rep);
	  }
	  
	  if(almRepUpdateList.size() > 0)
	    update almRepUpdateList;
	}

}