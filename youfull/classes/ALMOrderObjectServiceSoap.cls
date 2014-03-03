global class ALMOrderObjectServiceSoap {

	global class OrderObject 
	{
		webservice String   ORD_KEY;/**/
		webservice String	ACCT_NR;/**/
		webservice Decimal	AWRD_SLS_AMT;
		webservice String	FLD_SLS_CMPGN_NR;/**/
		webservice String	HOLD_REASON_CD;
		webservice String	INVC_NR;
		webservice String	MLPLN_CD;
		webservice String	MRKT_ID;/**/
		webservice String	OPERTNL_CMPGN_NR;
		webservice Decimal	SLS_AMT;/*Amount in the BRD*/
		webservice String	ORD_NR;/**/
		webservice String	OPPTY_NR;
		webservice String	STUS_CD;/**/
		webservice DateTime	TRNSCTN_TIME;/*CHANGED*//**/
		webservice Date		SUBMTD_DT;/**/
		webservice String	ORD_TYP;/**/
		webservice String	Genealogy_Key;/**/
		webservice String	SRC_SYS;
		webservice String	TRNSCTN_SRC;/**/
		webservice boolean  Has_Errors;
		webservice string 	Error_Type;
		webservice string 	Error_Message;
		webservice string	SF_Order_Id;
	}
	
	static map<String, Integer> winnerStatusPriorityMap = new map<String, Integer>();
	
	
	class nrtException extends Exception {} 
	webservice static list<OrderObject> upsertOrderObject(list<OrderObject> OrderObjects, String CallerSystem)
	{
		
		 list<NRT_Log__c> logs = new list<NRT_Log__c>();
		
		
		 
		 		                       
		 //log the transaction start time
		 //return OrderObjects;
		winnerStatusPriorityMap.put('-100',0);
		winnerStatusPriorityMap.put('1',1);
		winnerStatusPriorityMap.put('2',2);
		winnerStatusPriorityMap.put('3',4);
		winnerStatusPriorityMap.put('4',3);
		winnerStatusPriorityMap.put('5',5);
		winnerStatusPriorityMap.put('6',3);
		winnerStatusPriorityMap.put('7',4);
		winnerStatusPriorityMap.put('8',4);
		 
		 
		 /*if(NRT_Utils.isBatchLoadInProcess()) 
		 {
		 	throw new nrtException('CDW_BATCH_IN_PROCESS');
		 }*/
		 
		 Id transactionLogId = NRT_Utils.logTransactionStart( CallerSystem
														    ,'ALMOrderObjectServiceSoap.upsertOrderObject'
														    ,'APEX WEB SERVICE'
														    ,System.now());
		 
		 
		 map<String, Boolean> marketProcessingMap = new map<String, Boolean>();
		 
		 map<string, OrderObject> resultsMap = new map<string, OrderObject>();
		 set<String> genealogyKeys = new set<string>();
		 set<String> orderKeys = new set<string>();
    	 //list<NRT_Error_Log__c> errors = new list<NRT_Error_Log__c>();
		 
		 list<Order_1__c> orders = new list<Order_1__c>();
    	 map<String,Order_1__c> survivorMap = new map<String,Order_1__c>();
    	 set<String> orderParents = new set<string>();
    	 
    	 List<String> genealogyKeyList=new List<String>();
    	 
    	 //pull together a list of geneology keys
    	 for(OrderObject ord:OrderObjects){
    	 	genealogyKeyList.add(ord.Genealogy_Key);
    	 	marketProcessingMap.put(ord.MRKT_ID, false);
    	 }
    	 
    	 //Added by Prakash to compute the sales org summary key
    	 Map<String,ALM_Rep_Performance_1__c> almRepPerfMap=new Map<String,ALM_Rep_Performance_1__c>();
		 
		 
		 /*select ALM_Rep_Indicator__c, MRKT_ID__c
		   from Market__c
		 where MRKT_ID__c = MRKT_ID*/
		 
		 
		 for(ALM_Rep_Performance_1__c repPerformance:[select Id, FLD_SLS_CMPGN_NR__c, OPERTNL_CMPGN_NR__c,SLS_ZONE_CD__c, MRKT_ID__c,Genealogy_Key__c 
		                                                from ALM_Rep_Performance_1__c 
		                                               where Genealogy_Key__c in :genealogyKeyList]){
		 	almRepPerfMap.put(repPerformance.Genealogy_Key__c,repPerformance);
		 }
		 
		 for(Market__c m : [Select Market_Id__c, Batch_Load_In_Process__c from Market__c where Market_Id__c = :marketProcessingMap.keySet()])
		 {
		 	   marketProcessingMap.put(m.Market_Id__c, m.Batch_Load_In_Process__c);
		 	  // throw new nrtException('CDW_BATCH_IN_PROCESS');
		 }
		    
		 
		
		 
		 //process the Order Objects creating a map of records to compare to the database for a consilidated list if winner order accounts
		for(OrderObject ord : OrderObjects)
		{
			if(NRT_Log_Level__c.getInstance().Log_Level__c == 'Debug')
		 	{
		 		logs.add(new NRT_Log__c(Application_Class__c = 'ALMOrderObjectServiceSoap'
		 		                       ,Method__c = 'upsertOrderObject'
		 		                       ,Severity__c = NRT_Log_Level__c.getInstance().Log_Level__c
		 		                       ,Log__c = 'ORDER OBJECT: '+ord));
		 	}
			//check the market batch processing status flag
			if(marketProcessingMap.get(ord.MRKT_ID) == true)
			{
				ord.Has_Errors = false;
				ord.Error_Type = 'CDW_BATCH_IN_PROCESS';
				ord.Error_Message = 'CDW BATCH PROCESS IS RUNNING. NRT UPDATES ARE NOT ALLOWED.';
				resultsMap.put(ord.ORD_KEY+'ERROR', ord);
				continue;
			}
			
			ord.Has_Errors = false;
			string orderKey = ord.ORD_KEY;
			//Check for a Valid Rep Performance record
			if(! almRepPerfMap.containsKey(ord.Genealogy_Key))
			{
				ord.Error_Type = 'GENEOLOGY_KEY_NOT_FOUND';
				ord.Has_Errors = true;
				ord.Error_Message = 'The geneology Key supplied on this record does not relate to an existing Rep Performanc Record.';
				resultsMap.put(ord.ORD_KEY+'ERROR', ord);
				continue;
			}
			
			ALM_Rep_Performance_1__c alm = almRepPerfMap.get(ord.Genealogy_Key);
			
			String salesOrgSummaryKey=alm.MRKT_ID__c + alm.FLD_SLS_CMPGN_NR__c + 'Z' + alm.SLS_ZONE_CD__c;
			Sales_Org_Summary__c sos = new Sales_Org_Summary__c(SLS_ORG_SUMRY_KEY__c = salesOrgSummaryKey);
			
			alm = new ALM_Rep_Performance_1__c(Genealogy_Key__c = ord.Genealogy_Key);
			
    	 	genealogyKeys.add(ord.Genealogy_Key);
    	 	orderParents.add(orderKey);
    	 	boolean updateSurvivor = true;
    	 	
    	 	resultsMap.put(orderKey, ord);
    	 	
    	 	
    	 	if(survivorMap.containsKey(orderKey))
    	 	{
    	 		
    	 		Integer dt1 = Integer.ValueOf(ord.TRNSCTN_TIME.getTime()/1000);
    	 		Integer dt2 = Integer.ValueOf(survivorMap.get(ord.ORD_KEY).TRNSCTN_TIME__c.getTime()/1000);
    	 		
    	 		System.debug('::::::dt1::::: '+dt1+' ::::dt2:::: '+dt2);
    	 		
    	 		if(dt1 <= dt2)//add it only if the one in the Map is newer
    	 		{
    	 		   System.Debug(':::::if(dt1 <= dt2):::::');
    	 		   updateSurvivor = false;
    	 		}
    	 		
    	 		if(dt1 == dt2 && winnerStatusPriorityMap.get(ord.STUS_CD) <= winnerStatusPriorityMap.get(survivorMap.get(ord.ORD_KEY).STUS_CD__c))
    	 		{
    	 		   System.Debug(':::::if(dt1 == dt2):::::');
    	 		   updateSurvivor = false;
    	 		}
    	 		
    	 	}
    	 	
    	 	/*SObject obj new SObject('Order_1__c');
    	 	obj.put('ACCT_NR__c', ord.ACCT_NR);
    	 	*/
    	 	if(updateSurvivor)
    	 	{
	    	 	System.Debug(':::::if(updateSurvivor):::::ORD_KEY__c: '+ord.ORD_KEY);
    	 		   
	    	 	survivorMap.put(orderKey,
	    	 	                    new Order_1__c(ACCT_NR__c		=	ord.ACCT_NR
												,AWRD_SLS_AMT__c	=	ord.AWRD_SLS_AMT
												,FLD_SLS_CMPGN_NR__c=	ord.FLD_SLS_CMPGN_NR
												,HOLD_REASON_CD__c	=	ord.HOLD_REASON_CD
												,INVC_NR__c			=	ord.INVC_NR
												,MLPLN_CD__c		=	ord.MLPLN_CD
												,MRKT_ID__c			=	ord.MRKT_ID
												,OPERTNL_CMPGN_NR__c=	ord.OPERTNL_CMPGN_NR
												,SLS_AMT__c			=	ord.SLS_AMT
												,ORD_KEY__c			=	orderKey
												,ORD_NR__c			=	ord.ORD_NR
												,OPPTY_NR__c		=	ord.OPPTY_NR
												,STUS_CD__c			=	ord.STUS_CD
												,SUBMTD_DT__c		=	ord.SUBMTD_DT
												,ORD_TYP__c			=	ord.ORD_TYP
												,SRC_SYS__c			=	ord.SRC_SYS
												,TRNSCTN_SRC__c		=	ord.TRNSCTN_SRC
												,TRNSCTN_TIME__c    =   ord.TRNSCTN_TIME
											    ,Genealogy_Key_1__r = alm
										        ,SLS_ORG_SUMRY_KEY__r = sos));
    	 	}
			
		}

		
		//retrieve the matching records from the database and compare to assess the winner
		for(Order_1__c ord : [ Select Id 
								,	ACCT_NR__c
								,	AWRD_SLS_AMT__c
								,	CDW_PROC__c
								,	FLD_SLS_CMPGN_NR__c
								,	HOLD_REASON_CD__c
								,	INVC_NR__c
								,	MLPLN_CD__c
								,	MRKT_ID__c
								//,	NET_SLS_AMT__c
								,	OPERTNL_CMPGN_NR__c
								,	SLS_AMT__c
								,	ORD_KEY__c
								,	ORD_NR__c
								,	OPPTY_NR__c
								,	STUS_CD__c
								//,	STUS_DT__c
								,	SUBMTD_DT__c
								,	ORD_TYP__c
								,	Genealogy_Key_1__c
								,	SLS_ORG_SUMRY_KEY__c
								,	SRC_SYS__c
								,	TRNSCTN_SRC__c
								,   TRNSCTN_TIME__c 
                               from Order_1__c 
                              where ORD_KEY__c in :survivorMap.keySet() ])
		{	
			boolean updateSurvivor = true;
    	 	if(survivorMap.containsKey(ord.ORD_KEY__c))
    	 	{
    	 		
    	 		Long dt1 = ((Decimal)(ord.TRNSCTN_TIME__c.getTime()/1000)).longValue();
    	 		Long dt2 = ((Decimal)(survivorMap.get(ord.ORD_KEY__c).TRNSCTN_TIME__c.getTime()/1000)).longValue();
    	 		System.debug('::::::<dt1>::::: '+dt1+' ::::dt2:::: '+dt2);
    	 		System.debug('::::ord.TRNSCTN_TIME__c.getTime():::'+ord.TRNSCTN_TIME__c.getTime()+'::::survivorMap.get(ord.ORD_KEY__c).TRNSCTN_TIME__c.getTime()::'+survivorMap.get(ord.ORD_KEY__c).TRNSCTN_TIME__c.getTime());
    	 		
    	 		if(dt1 < dt2)//add it if the one in the DB is newer
    	 		{
    	 		   System.Debug(':::::if(dt1 <= dt2):::::');
    	 		   updateSurvivor = false;
    	 		}
    	 		
    	 		if(dt1 == dt2 && winnerStatusPriorityMap.get(ord.STUS_CD__c) < winnerStatusPriorityMap.get(survivorMap.get(ord.ORD_KEY__c).STUS_CD__c))
    	 		{
    	 			System.Debug(':::::if(dt1 == dt2::::');
    	 			updateSurvivor = false;
    	 		}   
    	 		
    	 	}
    	 	
    	 	if(updateSurvivor)
    	 	{
    	 		System.Debug('>>>>>> Adding From DB>>>'+ord);
    	 		survivorMap.put(ord.ORD_KEY__c, ord);
    	 	}
    	 	
		}
		
		list<Order_1__c> survivors = new list<Order_1__c>();
		for(Order_1__c o : survivorMap.values())
		{
			if(o.Id == null)//exclude items that are already in the database
			{
			   survivors.add(o);
			   System.debug('::::::::if(o.Id == null)::::::>'+o);
			   /*errors.add(new NRT_Error_Log__c(Component_Name__c = 'ALMAppointmentServiceSoap'
                                               ,Error_Text__c = '::::::::if(o.Id == null)::::::>'+o));*/
			}
		}
		
    	
    	map<String,OrderObject> lockMap = new map<String,OrderObject>();
		survivorMap.clear();
		System.Debug('::::::survivors::::::'+survivors);
		if(survivors.size() > 0)
		{
		   //upsert the records
		   Database.UpsertResult[] results = Database.upsert(survivors, Order_1__c.Fields.ORD_KEY__c, false);
		   list<Order_1__c> locks = new list<Order_1__c>();
		   //check for errors and return
		   if (!results.isEmpty()) 
		   {
		   	    
		   	    
                for (integer row = 0; row < survivors.size(); row++) 
                {
                	Order_1__c os = survivors[row];
                    OrderObject ord = resultsMap.get(os.ORD_KEY__c);
                    
                    
                    if (!results[row].isSuccess()) 
                    {
                        Database.Error err = results[row].getErrors()[0];
                        
                        ord.Error_Message = err.getMessage();//get the type
                        ord.Has_Errors = true;
                        ord.Error_Type = err.getStatusCode()+'';
                        System.Debug('::::::err.getMessage()::::::'+err.getMessage());
                        //capture the errors
                        if(NRT_Log_Level__c.getInstance().Log_Level__c == 'Error' || NRT_Log_Level__c.getInstance().Log_Level__c == 'Debug')
					 	{
					 		logs.add(new NRT_Log__c(Application_Class__c = 'ALMOrderObjectServiceSoap'
					 		                       ,Method__c = 'upsertOrderObject'
					 		                       ,Severity__c = 'Error'
					 		                       ,Log__c = ord.Error_Type + ' - '+ err.getMessage()));
					 	}
                        
                        if(err.getStatusCode().name().containsIgnoreCase('LOCK'))
                        {
                          lockMap.put(os.ORD_KEY__c, ord);
                        }
                    }
                    else
                    {
                    	ord.SF_Order_Id = results[row].Id;
                    	//get the successes to check against the failures
                    	survivorMap.put(os.ORD_KEY__c, os);
                    	
                    }
                }
                
                
		   }
		  
		}
		
		NRT_Utils.logTransactionEnd(transactionLogId, System.now()); 
		
		if(logs.size() > 0)
                  insert logs;
		//return the records and include errrors if there were any error
		return resultsMap.values(); 
		
	}

}