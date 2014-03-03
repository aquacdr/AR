global without sharing class NRT_ALM_SalesOrgSummaryRollupBatch  implements Database.Batchable<Sobject>{
	
	/**
		
	**/
	
	public class AlmCounts
	{
		public Decimal submitedCnt{get;set;}
		public Decimal invoicedCount{get;set;}
		public Decimal activeCount{get;set;}
	}
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		set<String> marketKeys = new set<String>();
		for(Market__c m : [Select Market_Id__c 
		                     from Market__c 
		                    where Batch_Load_In_Process__c = false 
		                      and NRT_Enabled__c = true])  
		{
			marketKeys.add(m.Id);
		}
		return Database.getQueryLocator([Select Id
		                                   From Sales_Org_Summary__c 
		                                  where Sales_Org_Summary__c.MRKT_KEY__c in :marketKeys]);
	}
	global void execute(Database.BatchableContext BC, List<Sales_Org_Summary__c> sos)
	{ 
		map<string, AlmCounts> SalesOrgSummaryCounts = new map<string, AlmCounts>();
		set<String> marketKeys = new set<String>();
		for(Market__c m : [Select Market_Id__c from Market__c where Batch_Load_In_Process__c = false and NRT_Enabled__c = true])  
		{
			marketKeys.add(m.Market_Id__c);
		}
			
		
		//NRT_SBMTD_ACTIVE_CNT 
		for(AggregateResult r1 :[select sum(NRT_SBMTD_IS_ACTIVE__c) submitedCnt
		                              , sum(NRT_INVC_IS_ACTIVE__c) invoicedCount
		                              , sum(NRT_IS_ACTIVE_APPT__c) activeCount
		                              , SLS_ORG_SUMRY_KEY__c
		                           from ALM_Rep_Performance_1__c 
		                          where SLS_ORG_SUMRY_KEY__c in :sos
		                          group by SLS_ORG_SUMRY_KEY__c])
	   {
	   		AlmCounts cnt = new AlmCounts(); 
	   		string sosId = (String)r1.get('SLS_ORG_SUMRY_KEY__c');
	   		cnt.submitedCnt = (Decimal)r1.get('submitedCnt');
	   		cnt.invoicedCount = (Decimal)r1.get('invoicedCount');
	   		cnt.activeCount = (Decimal)r1.get('activeCount');
	   		
	   		SalesOrgSummaryCounts.put(sosId, cnt);
	   }  
	   
	   list<Sales_Org_Summary__c> sosUpdateList = new  list<Sales_Org_Summary__c>();
	   for(Sales_Org_Summary__c sos1 : [Select Id
	                                        , NRT_SBMTD_ACTIVE_CNT__c
	                                        , NRT_INVC_ACTIVE_CNT__c
	                                        , NRT_ACTIVE_APPT_CNT__c
	                                        , SLS_ORG_SUMRY_KEY__c
	                                     from Sales_Org_Summary__c
	                                    where Id in :SalesOrgSummaryCounts.keySet()]) 
	  {
	  	  if(SalesOrgSummaryCounts.containsKey(sos1.SLS_ORG_SUMRY_KEY__c))
	  	  {
	  	     AlmCounts cnt = SalesOrgSummaryCounts.get(sos1.SLS_ORG_SUMRY_KEY__c);
	  	     sos1.NRT_ACTIVE_APPT_CNT__c += cnt.activeCount;
	  	     sos1.NRT_INVC_ACTIVE_CNT__c += cnt.invoicedCount;
	  	     sos1.NRT_SBMTD_ACTIVE_CNT__c += cnt.submitedCnt;
	  	  }
	  	     
	  	  sosUpdateList.add(sos1);
	  }
	  
	  //Set the counts on the Sales Org Summary Records
	  if(sosUpdateList.size() > 0)
	    update sosUpdateList;
	    
	  //reset all the ALM_Rep_Performance_1__c records in this batch so that they don't reprocess
	  list<ALM_Rep_Performance_1__c> repList = new list<ALM_Rep_Performance_1__c>();
	  for(ALM_Rep_Performance_1__c a :[Select Id
	  										, NRT_SBMTD_IS_ACTIVE__c
		                              		, NRT_INVC_IS_ACTIVE__c
		                              		, NRT_IS_ACTIVE_APPT__c 
		                                 from ALM_Rep_Performance_1__c 
		                                where SLS_ORG_SUMRY_KEY__c in :sos])
	  {
	  		a.CHK_NRT_SBMTD_IS_ACTIVE__c = true;
		    a.CHK_NRT_INVC_IS_ACTIVE__c = true;
		    a.CHK_NRT_IS_ACTIVE_APPT__c = true;
		    repList.add(a);
	  }
	  
	  if(repList.Size() > 0)
	  	update repList;
	  
	}
	
	global void finish(Database.BatchableContext BC){	
		
	}
	/*
	@isTest(seeAllData=true)
	static void runTest()
	{
		SchedulableContext sc;
		NRT_ALM_SalesOrgSummaryRollup nrt = new NRT_ALM_SalesOrgSummaryRollup();
		nrt.execute(sc);
		
	}
	*/
	
}