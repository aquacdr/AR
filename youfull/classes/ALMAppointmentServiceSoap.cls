global class ALMAppointmentServiceSoap {
    
    global class Appointment
    {
        webservice  string  MRKT_ID; 
        webservice  string  ACCT_NR;
        webservice  string  First_Name;
        webservice  string  Last_Name;
        webservice  Date    DOB;
        webservice  string  Appointment_Campaign;
        webservice  string  Rep_Status;
        webservice  string  Email;
        webservice  string  Home_Phone;
        webservice  string  Phone;
        webservice  string  Mobile;
        webservice  string  Mailplan_NR;
        webservice  string  UPLN_ACCT_NR;
        webservice  String  MRKT_SLS_ORG_KEY;
        webservice  string  Zone;
        webservice  Date    Appointment_Date;
        webservice  String  Response_Salesforce_Id; 
        webservice boolean  Has_Errors;
        webservice string   Error_Type;
        webservice string   Error_Message; 
        
    }
    
    class campaign
    {
        public string CMPGN_NR;
        public string NEXT_1_CMPGN_NR;
    }
    
    class nrtException extends Exception {}
    
    webservice static list<Appointment> upsertOrderObject(list<Appointment> Appointments, String SourceSystem)
    {
        
        list<NRT_Log__c> logs = new list<NRT_Log__c>();
        list<Contact> almContacts = new list<Contact>();
        set<string> uplineRepSet = new set<string>();
        map<string, Appointment>resultsMap = new map<string, Appointment>();
        map<string, campaign> marketMap = new map<string, campaign>();
        map<string, ALM_Rep_Performance_1__c> repPerformanceMap = new map<string, ALM_Rep_Performance_1__c>();
        map<string, boolean> marketProcessingMap = new map<string, boolean>();
        map<Id,Contact> deletedContacts = new map<Id,Contact>();
        list<String> marketZoneCodes = new List<String>();
        list<NRT_Log__c> errors = new list<NRT_Log__c>();
        
        for(Appointment apt : Appointments)
            marketProcessingMap.put(apt.MRKT_ID, false);
        
        
        
        for(Appointment apt : Appointments)
        {
        	string MRKT_ACCT_KEY = apt.MRKT_ID + apt.ACCT_NR;
            resultsMap.put(MRKT_ACCT_KEY, apt);
            
            
            if(NRT_Log_Level__c.getInstance().Log_Level__c == 'Debug')
		 	{
		 		logs.add(new NRT_Log__c(Application_Class__c = 'ALMAppointmentServiceSoap'
		 		                       ,Method__c = 'upsertOrderObject'
		 		                       ,Severity__c = NRT_Log_Level__c.getInstance().Log_Level__c
		 		                       ,Log__c = 'APPOINTMENT OBJECT: '+apt));
		 	}
            
            almContacts.add(new Contact(MRKT_ID__c  =   apt.MRKT_ID
                                        ,MRKT_ACCT_KEY__c   =   MRKT_ACCT_KEY
                                        ,ACCT_NR__c         =   apt.ACCT_NR
                                        ,FirstName          =   apt.First_Name
                                        ,LastName           =   apt.Last_Name
                                        ,REP_BRTH_DT__c     =   apt.DOB
                                        ,REP_APPT_CMPGN_NR__c   =   apt.Appointment_Campaign
                                        ,REP_OMS_STUS_CD__c     =   apt.Rep_Status
                                        ,Email                  =       apt.Email
                                        ,HomePhone          =   apt.Home_Phone
                                        ,Phone              =   apt.Phone
                                        ,MobilePhone        =   apt.Mobile
                                        ,MLPLN_CD__c        =   apt.Mailplan_NR
                                        ,MRKT_SLS_ORG_KEY__c    =   apt.MRKT_SLS_ORG_KEY
                                        ,SLS_ZONE_CD__c         =   apt.Zone
                                        ,REP_APPT_DT__c         =   apt.Appointment_Date)   );
                
            
            marketMap.put(apt.MRKT_ID, new campaign());
            uplineRepSet.add(apt.UPLN_ACCT_NR);
            marketZoneCodes.add(apt.MRKT_ID + 'z' + apt.Zone);
        }
        
         //get the current and next campaigns
        for(Market__c m : [select Batch_Load_In_Process__c, LAST_UPDT_DT__c, NEXT_1_CMPGN_NR__c, Market_Id__c, CMPGN_NR__c 
                             from Market__c 
                            where Market_Id__c in :marketMap.keySet()])
        {
            campaign c = new campaign();
            c.NEXT_1_CMPGN_NR = m.NEXT_1_CMPGN_NR__c;
            c.CMPGN_NR = m.CMPGN_NR__c;
            marketMap.put(m.Market_Id__c, c);
            marketProcessingMap.put(m.Market_Id__c, m.Batch_Load_In_Process__c);
            
        }  
        
        //collect the right/left indicators for the parents
        for(ALM_Rep_Performance_1__c rep : [Select RGT_ND_ID__c, LFT_ND_ID__c, ACCT_NR__c,UPLN_ACCT_NR__c
                                                 , Genealogy_level__c, ROOT_UPLN_ACCT_NR__c, Genealogy_Key__c
                                              from ALM_Rep_Performance_1__c 
                                             where ACCT_NR__c in :uplineRepSet])
        {
            repPerformanceMap.put(rep.Genealogy_Key__c, rep);
            System.debug('>>>>> repPerformanceMap >>>>'+repPerformanceMap);
        }
        
        map<String, Contact> contactKeyMap = new map<string, Contact>();
        if(almContacts.size() > 0)
        {
           // I-77980 : Populate account on contact
           linkAccountToContact(marketZoneCodes, almContacts);
        	
           //insert the records
           Database.saveResult[] results = Database.insert(almContacts, false);//, Contact.Fields.MRKT_ACCT_KEY__c
           if (!results.isEmpty()) 
           {
               
                for (integer row = 0; row < almContacts.size(); row++) 
                {
                    Contact con = almContacts[row];
                    Appointment appt = resultsMap.get(con.MRKT_ACCT_KEY__c);
                    
                    if (!results[row].isSuccess()) 
                    {
                        Database.Error err = results[row].getErrors()[0];
                        appt.Error_Message = err.getMessage();//get the type
                        appt.Error_Type = err.getStatusCode()+'';
                        appt.Has_Errors = true;
                        //Commented by Prakash on 10/8 to apply a pending fix with Nathan.
                       /* if(NRT_Utils.lockingErrorCodeMap().containsKey(appt.Error_Type) && !NRT_Utils.lockingErrorCodeMap().get(appt.Error_Type)) 
                           appt.Has_Errors = false;*/
                        
                        if((results[row].getErrors()[0].getMessage()).contains('DUPLICATE_VALUE'))
                           appt.Error_Type = 'DUPLICATE_ACCOUNT';
                        
                        //oo.Error_Type = err.getFields()
                        if(NRT_Log_Level__c.getInstance().Log_Level__c == 'Error' || NRT_Log_Level__c.getInstance().Log_Level__c == 'Debug')
					 	{
					 		errors.add(new NRT_Log__c(Application_Class__c = 'ALMAppointmentServiceSoap'
					 		                       ,Method__c = 'upsertOrderObject'
					 		                       ,Severity__c = 'Error'
					 		                       ,Log__c = appt.Error_Type + ' - '+ err.getMessage()));
					 	}
                    }
                    else
                    {
                        contactKeyMap.put(con.MRKT_ACCT_KEY__c, con);
                    }
                }
                if(errors.size() > 0) {
                   insert errors;
                   errors = new list<NRT_Log__c>(); // Empty out, so that future insert will not attempt to insert the same errors again
                }
           }
        }
        
        map<string,ALM_Rep_Performance_1__c> almList = new map<string,ALM_Rep_Performance_1__c>();
        //create the ALM Rep Performance records
        for(Appointment apt : Appointments)
        {
        	Integer errLoc = 0;
	         try{
	          //Prevent processing if CDW Batch is processing
	          if(marketProcessingMap.get(apt.MRKT_ID) == true)
	          {
	            apt.Has_Errors = false;
	            apt.Error_Type = 'CDW_BATCH_IN_PROCESS';
	            apt.Error_Message = 'CDW BATCH PROCESS IS RUNNING. NRT UPDATES ARE NOT ALLOWED.';
	            continue;
	          }
	          
	          if(!contactKeyMap.containsKey(apt.MRKT_ID + apt.ACCT_NR))
	          {
	          	System.Debug(':::::::!contactKeyMap.containsKey:::: '+apt.MRKT_ID + apt.ACCT_NR);
	            continue;
	          }
	           
	          errLoc = 10;          
	          campaign camp = marketMap.get(apt.MRKT_ID);
	          Contact con = new Contact(MRKT_ACCT_KEY__c = apt.MRKT_ID + apt.ACCT_NR);
	          Contact parentContact;
	          
	          ALM_Rep_Performance_1__c a1 =  new ALM_Rep_Performance_1__c(); 
	          a1.MRKT_ID__c =   apt.MRKT_ID;
	          //,MRKT_ACCT_KEY__c   =   contactKeyMap.get(apt.MRKT_ACCT_KEY)
	          a1.REP_APPT_CMPGN_NR__c   =   apt.Appointment_Campaign;
	          a1.REP_OMS_STUS_CD__c =   apt.Rep_Status;
	          a1.MLPLN_CD__c    =   apt.Mailplan_NR;
	          a1.UPLN_ACCT_NR__c    =   apt.UPLN_ACCT_NR;
	          
	          a1.LOA_NR__c  =   0;
	          a1.MRKT_ACCT_KEY__r = con;
			  
			  errLoc = 20;
			  
	          a1.FLD_SLS_CMPGN_NR__c = Decimal.ValueOf(camp.CMPGN_NR);
	          a1.OPERTNL_CMPGN_NR__c = camp.CMPGN_NR;
	          a1.Genealogy_Key__c = apt.MRKT_ID+camp.CMPGN_NR+apt.ACCT_NR;
	          string uplineGenealogyKey = apt.MRKT_ID+camp.CMPGN_NR+apt.UPLN_ACCT_NR;
	          
	          System.Debug('::::a1.Genealogy_Key__c:::::'+a1.Genealogy_Key__c);
	          errLoc = 30;
	          a1.ACCT_NR__c=apt.ACCT_NR;
	          
	          a1.SLS_ZONE_CD__c=apt.Zone;
	          a1.MRKT_CMPGN_SLS_ZONE_CD__c=apt.MRKT_ID+camp.CMPGN_NR+apt.Zone;
	          //END: Modified by Prakash to set the values of the fields as suggested by Cristina on 09/18
	          if(repPerformanceMap.containsKey(uplineGenealogyKey))
	          {
	              System.debug( '>>>>> repPerformance Upline for '+apt.UPLN_ACCT_NR+' >>>>'+repPerformanceMap.get(uplineGenealogyKey) );
	              errLoc = 40;
		          //Check to see if we are adding this to a child record that was added today by seeing if there is a decimal value for LFT_ND_ID__c
		          Decimal lftInd = repPerformanceMap.get(uplineGenealogyKey).LFT_ND_ID__c;
		          if(Integer.ValueOf(lftInd) < lftInd)
		          {
		            apt.Error_Message = 'Adding an Appointment as a child of another Appointment is not supported.';
		            apt.Has_Errors = true;
		            apt.Error_Type = 'CHILD_APPOINTMENT_NOT_ALLOWED';
		            continue;
		          }
		          errLoc = 50;	          
		          a1.RGT_ND_ID__c = repPerformanceMap.get(uplineGenealogyKey).RGT_ND_ID__c  - .001;
		          a1.LFT_ND_ID__c = repPerformanceMap.get(uplineGenealogyKey).LFT_ND_ID__c  + .001;
		          String aptRootUplnAccNbr=repPerformanceMap.get(uplineGenealogyKey).ROOT_UPLN_ACCT_NR__c;
		          a1.ROOT_UPLN_ACCT_NR__c=aptRootUplnAccNbr;
		          a1.MRKT_CMPGN_ROOT_UPLN_ACCT__c=apt.MRKT_ID+camp.CMPGN_NR+aptRootUplnAccNbr;
		          
		          errLoc = 60;
		          //Start: Modified by Prakash to set the values of the fields as suggested by Cristina on 09/18
	              Integer aptGenLevel=(repPerformanceMap.get(uplineGenealogyKey).Genealogy_Level__c + 1).intValue();
	              a1.Genealogy_Level__c=aptGenLevel;
	              errLoc = 70;
	              a1.UPLN_ACCT_NR__c = apt.UPLN_ACCT_NR;
	              //Added by Prakash on 09/13 to set the value of upline contact on ALMRepPerformance.
	          	  parentContact  = new Contact(MRKT_ACCT_KEY__c = apt.MRKT_ID + apt.UPLN_ACCT_NR);
	              a1.UPLN_ACCT_KEY__r=parentContact;                            
	          }
	          else
	          {
	          	  if(apt.UPLN_ACCT_NR != null)
	          	  {
			          errLoc = 80;
			          apt.Error_Message = 'The Upline Account specified was not found.';
		              apt.Has_Errors = true;
		              apt.Error_Type = 'UPLINE_ACCOUNT_NOT_FOUND';
		              //delete the associated contact created for this appointment
		              Contact cont1 = contactKeyMap.get(apt.MRKT_ID + apt.ACCT_NR);
		              deletedContacts.put(cont1.Id, cont1);
		              continue;
	          	  }
	          	  errLoc = 90;
	          	  a1.RGT_ND_ID__c = 2;
		          a1.LFT_ND_ID__c = 1;
		          a1.ROOT_UPLN_ACCT_NR__c=apt.ACCT_NR;
		          a1.MRKT_CMPGN_ROOT_UPLN_ACCT__c=apt.MRKT_ID+camp.CMPGN_NR+apt.ACCT_NR;
		          a1.UPLN_ACCT_NR__c = apt.ACCT_NR;
		          a1.UPLN_ACCT_KEY__r = con;          
	          }
	                  
	          almList.put(a1.Genealogy_Key__c,a1); 
	          
	          //validate against child of child	          
	          errLoc = 100;
	          ALM_Rep_Performance_1__c a2 =  new ALM_Rep_Performance_1__c(); 
	          a2.MRKT_ID__c =   apt.MRKT_ID;
	          //,MRKT_ACCT_KEY__c   =   contactKeyMap.get(apt.MRKT_ACCT_KEY)
	          a2.REP_APPT_CMPGN_NR__c   =   apt.Appointment_Campaign;
	          a2.REP_OMS_STUS_CD__c =   apt.Rep_Status;
	          a2.MLPLN_CD__c    =   apt.Mailplan_NR;
	          a2.UPLN_ACCT_NR__c    =   apt.UPLN_ACCT_NR;
	          errLoc = 110;
	          a2.LOA_NR__c  =   0;
	          a2.MRKT_ACCT_KEY__r = con;
	           //Added by Prakash on 09/13 to set the value of upline contact on ALMRepPerformance.
	          a2.UPLN_ACCT_KEY__r=parentContact;
	          a2.FLD_SLS_CMPGN_NR__c = Decimal.ValueOf(camp.NEXT_1_CMPGN_NR);
	          a2.OPERTNL_CMPGN_NR__c = camp.CMPGN_NR;
	          a2.Genealogy_Key__c = apt.MRKT_ID+camp.NEXT_1_CMPGN_NR+apt.ACCT_NR;
	          uplineGenealogyKey = apt.MRKT_ID+camp.NEXT_1_CMPGN_NR+apt.UPLN_ACCT_NR;
	          errLoc = 120;
	          a2.ACCT_NR__c=apt.ACCT_NR;
	          a2.SLS_ZONE_CD__c=apt.Zone;
	          a2.MRKT_CMPGN_SLS_ZONE_CD__c=apt.MRKT_ID+camp.NEXT_1_CMPGN_NR+apt.Zone;
	          //END: Modified by Prakash to set the values of the fields as suggested by Cristina on 09/18
	          if(repPerformanceMap.containsKey(uplineGenealogyKey))
	          {
		          errLoc = 130;
		          a2.RGT_ND_ID__c = repPerformanceMap.get(uplineGenealogyKey).RGT_ND_ID__c  - .001;
		          a2.LFT_ND_ID__c = repPerformanceMap.get(uplineGenealogyKey).LFT_ND_ID__c  + .001;
		          String aptRootUplnAccNbr=repPerformanceMap.get(uplineGenealogyKey).ROOT_UPLN_ACCT_NR__c;
		          a2.ROOT_UPLN_ACCT_NR__c=aptRootUplnAccNbr;
		          a2.MRKT_CMPGN_ROOT_UPLN_ACCT__c=apt.MRKT_ID+camp.CMPGN_NR+aptRootUplnAccNbr;
		          
		          errLoc = 140;
		          //Start: Modified by Prakash to set the values of the fields as suggested by Cristina on 09/18
	          	  a2.Genealogy_Level__c=(repPerformanceMap.get(uplineGenealogyKey).Genealogy_Level__c + 1).intValue();
		          a2.UPLN_ACCT_NR__c = apt.UPLN_ACCT_NR;
	          	  errLoc = 150;
	          	  //Added by Prakash on 09/13 to set the value of upline contact on ALMRepPerformance.
				  parentContact  = new Contact(MRKT_ACCT_KEY__c = apt.MRKT_ID + apt.UPLN_ACCT_NR);
	              a2.UPLN_ACCT_KEY__r=parentContact;
	          }
	          else
	          {
	          	  
	          	  if(apt.UPLN_ACCT_NR != null)
	          	  {
			          errLoc = 160;
			          apt.Error_Message = 'The Upline Account specified was not found.';
		              apt.Has_Errors = true;
		              apt.Error_Type = 'UPLINE_ACCOUNT_NOT_FOUND';
		              Contact cont2 = contactKeyMap.get(apt.MRKT_ID + apt.ACCT_NR);
		              deletedContacts.put(cont2.Id, cont2);
		              //remove the first appointment from the list since we errored out here
		              if(almList.containsKey(apt.MRKT_ID+camp.CMPGN_NR+apt.ACCT_NR))
		              {
		              	almList.remove(apt.MRKT_ID+camp.CMPGN_NR+apt.ACCT_NR);
		              }
		              continue;
	          	  }
	          	  errLoc = 170;
	          	  a2.RGT_ND_ID__c = 2;
		          a2.LFT_ND_ID__c = 1;
		          a2.ROOT_UPLN_ACCT_NR__c=apt.ACCT_NR;
		          a2.MRKT_CMPGN_ROOT_UPLN_ACCT__c=apt.MRKT_ID+camp.CMPGN_NR+apt.ACCT_NR;
		          a2.Genealogy_Level__c=1;
		          a2.UPLN_ACCT_NR__c = apt.ACCT_NR;
		          a2.UPLN_ACCT_KEY__r = con;
		          
	          }
	          
	          almList.put(a2.Genealogy_Key__c,a2);     
	         }
	         catch(Exception e)
	         {
	         	apt.Error_Message = ' Error loc ['+errLoc+'] '+ e.getMessage();
                apt.Has_Errors = true;
                apt.Error_Type = 'UNEXPECTED EXCEPTION';
			 	Contact cont2 = contactKeyMap.get(apt.MRKT_ID + apt.ACCT_NR);
		        deletedContacts.put(cont2.Id, cont2);
		        if(NRT_Log_Level__c.getInstance().Log_Level__c == 'Error' || NRT_Log_Level__c.getInstance().Log_Level__c == 'Debug')
			 	{
			 		errors.add(new NRT_Log__c(Application_Class__c = 'ALMAppointmentServiceSoap'
			 		                       ,Method__c = 'upsertOrderObject'
			 		                       ,Severity__c = 'Error'
			 		                       ,Log__c = apt.Error_Type + ' - loc ['+errLoc+'] '+ e.getMessage()));
			 	}
	         }                                
          
        }
        
        if(almList.size() > 0)
        {
        	list<ALM_Rep_Performance_1__c> almLov = almList.values();
           //insert the records
           Database.UpsertResult[] results = Database.upsert(almLov, ALM_Rep_Performance_1__c.Fields.Genealogy_Key__c, false);
           if (!results.isEmpty()) 
           {
                
                for (integer row = 0; row < almLov.size(); row++) 
                {
                    ALM_Rep_Performance_1__c con1 = almLov[row];
                    Appointment appt = resultsMap.get(con1.MRKT_ACCT_KEY__r.MRKT_ACCT_KEY__c);
                    appt.Response_Salesforce_Id = con1.Id;
                    if (!results[row].isSuccess()) 
                    {
                        Database.Error err = results[row].getErrors()[0];
                        appt.Error_Message = err.getMessage();//get the type
                        appt.Error_Type = err.getStatusCode()+'';
                        appt.Has_Errors = true;
                        //Commented by Prakash on 10/8 to apply a pending fix with Nathan.
                       /*
                        if(NRT_Utils.lockingErrorCodeMap().containsKey(appt.Error_Type) && !NRT_Utils.lockingErrorCodeMap().get(appt.Error_Type)) 
                           appt.Has_Errors = false;
                           */
                        Contact cont3 = contactKeyMap.get(appt.MRKT_ID + appt.ACCT_NR);
	              		deletedContacts.put(cont3.Id, cont3);
                        //oo.Error_Type = err.getFields()
                        if(NRT_Log_Level__c.getInstance().Log_Level__c == 'Error' || NRT_Log_Level__c.getInstance().Log_Level__c == 'Debug')
					 	{
					 		errors.add(new NRT_Log__c(Application_Class__c = 'ALMAppointmentServiceSoap'
					 		                       ,Method__c = 'upsertOrderObject'
					 		                       ,Severity__c = 'Error'
					 		                       ,Log__c = appt.Error_Type + ' - '+ err.getMessage()));
					 	}
                        
                    }
                }
                if(errors.size() > 0)
                 insert errors;
           }
        }  
        if(logs.size() > 0)
            insert logs;
            
        if(deletedContacts.size() > 0)
           delete deletedContacts.values();
              
        return resultsMap.values();
    }
    
      /*********************************************************	
	* I-77980 : Link/Populate account on contact
	* @Author : Parul Gupta(Appirio JDC), updated by Fay Salwen on 10/25/2013
	**********************************************************/   
    public static void linkAccountToContact(
        		list<String> acctExtIds,
        		list<Contact> almContacts){
        						
    	map<String, Account> accountMap = new map<String, Account>();
    	
    	// Get accounts
        for (Account account : [select id, MRKT_ZONE_CD__c
        					   from Account 
                               where MRKT_ZONE_CD__c in :acctExtIds]){
			accountMap.put(account.MRKT_ZONE_CD__c, account);                     	
        }
        
       	System.debug('::::::::::Account map for linking to Contacts is ' + accountMap);
        
        String accountExtId;
        String accountId;
        
        // Link account to contact as per MRKT_ACCT_KEY__c
        for (Contact contact : almContacts){
        	accountExtId = contact.MRKT_ID__c + 'z' + contact.SLS_ZONE_CD__c;
        	System.debug('::::::::::External Id of Account for Contact ' + contact.MRKT_ACCT_KEY__c + ' is: ' + accountExtId);
        	if (accountMap.get(accountExtId) != null){
        		accountId = accountMap.get(accountExtId).id;
        		contact.accountId = accountId;
        		System.debug('::::::::::Successfully set Account on Contact ' + contact.MRKT_ACCT_KEY__c + ' to: ' + accountId);
        	}	
        }         	
    }   

}