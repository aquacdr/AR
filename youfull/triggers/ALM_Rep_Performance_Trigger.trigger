trigger ALM_Rep_Performance_Trigger on ALM_Rep_Performance_1__c (before update, before insert) {
	
	map<Id, Market__c> marketMap = new map<Id, Market__c>();
	map<string, Id> sosMap = new map<string, Id>();
	
	for(ALM_Rep_Performance_1__c a : trigger.new)
	{
		marketMap.put(a.MRKT_KEY__c, new Market__c(Id = a.MRKT_KEY__c));
		sosMap.put(a.MRKT_ID__c + a.FLD_SLS_CMPGN_NR__c + 'Z' + a.SLS_ZONE_CD__c, null);
	}
	
	if(trigger.isUpdate && trigger.isBefore)
	{
		for(Market__c m : [Select NRT_HAS_SUBMTD_AMT__c
		                        , NRT_ACTIVE_USES_NET__c
		                     from market__c
		                    where Id in :marketMap.keySet() ])
		{
			marketMap.put(m.Id, m);
		}
		
		for(ALM_Rep_Performance_1__c a : trigger.new)
		{
			//if(trigger.oldMap.get(a.Id).NRT_SBMTD_IS_ACTIVE__c != a.NRT_SBMTD_IS_ACTIVE__c)
			
				/*
				 IF( 
				     NRT_INVC_IS_ACTIVE__c ==0
					, IF(MRKT_KEY__r.NRT_HAS_SUBMTD_AMT__c
						, IF ( MRKT_KEY__r.NRT_ACTIVE_USES_NET__c
							, IF(NRT_SUBMTD_SLS_AMT__c > 0, 1, 0)
						    , IF (NRT_SUBMTD_AWRD_SLS_AMT__c > 0, 1, 0
						    )
					) 
				 */
				if(marketMap.containsKey(a.MRKT_KEY__c) && marketMap.get(a.MRKT_KEY__c).NRT_HAS_SUBMTD_AMT__c)
				{
					if(marketMap.get(a.MRKT_KEY__c).NRT_ACTIVE_USES_NET__c)
					{
						if((trigger.oldMap.get(a.Id).NRT_SUBMTD_SLS_AMT__c != 0 && a.NRT_SUBMTD_SLS_AMT__c == 0)
						  ||(trigger.oldMap.get(a.Id).NRT_SUBMTD_SLS_AMT__c == 0 && a.NRT_SUBMTD_SLS_AMT__c != 0)
						  ||(trigger.oldMap.get(a.Id).NRT_SUBMTD_AWRD_SLS_AMT__c != 0 && a.NRT_SUBMTD_AWRD_SLS_AMT__c == 0)
						  ||(trigger.oldMap.get(a.Id).NRT_SUBMTD_AWRD_SLS_AMT__c == 0 && a.NRT_SUBMTD_AWRD_SLS_AMT__c != 0))
						{
							a.CHK_NRT_SBMTD_IS_ACTIVE__c = false;
							a.CHK_NRT_IS_ACTIVE_APPT__c = false;
			
						}
					}
				}
				
			//if(trigger.oldMap.get(a.Id).NRT_INVC_IS_ACTIVE__c != a.NRT_INVC_IS_ACTIVE__c)
		
				/*
				 If (
					(MRKT_KEY__r.NRT_ACTIVE_USES_NET__c)
					, IF(NRT_INVC_SLS_AMT__c > 0, 1, 0)
					, IF(NRT_INVC_AWRD_SLS_AMT__c > 0, 1, 0)
					)
				 */
				if(marketMap.containsKey(a.MRKT_KEY__c) && marketMap.get(a.MRKT_KEY__c).NRT_ACTIVE_USES_NET__c)
				{
					if( (trigger.oldMap.get(a.Id).NRT_INVC_SLS_AMT__c == 0 && a.NRT_INVC_SLS_AMT__c != 0)
					  ||(trigger.oldMap.get(a.Id).NRT_INVC_SLS_AMT__c != 0 && a.NRT_INVC_SLS_AMT__c == 0)
					  ||(trigger.oldMap.get(a.Id).NRT_INVC_AWRD_SLS_AMT__c == 0 && a.NRT_INVC_AWRD_SLS_AMT__c != 0)
					  ||(trigger.oldMap.get(a.Id).NRT_INVC_AWRD_SLS_AMT__c !=0 && a.NRT_INVC_AWRD_SLS_AMT__c == 0))
				    {
				    	a.CHK_NRT_INVC_IS_ACTIVE__c = false;
				    	a.CHK_NRT_IS_ACTIVE_APPT__c = false;
				    }
				}
			
		}
		
	}
	
	for(Sales_Org_Summary__c s : [select Id, SLS_ORG_SUMRY_KEY__c from Sales_Org_Summary__c where SLS_ORG_SUMRY_KEY__c in :sosMap.keySet()])
	{
		sosMap.put(s.SLS_ORG_SUMRY_KEY__c, s.Id);
	}
	
	for(ALM_Rep_Performance_1__c a : trigger.new)
	{
		a.SLS_ORG_SUMRY_KEY__c = sosMap.get(a.MRKT_ID__c + a.FLD_SLS_CMPGN_NR__c + 'Z' + a.SLS_ZONE_CD__c);
	}

}