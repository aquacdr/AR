global class ActionAlertBatch implements Database.Batchable<sObject>,Database.Stateful{
    private Market__c market;
    private String query;
    private Map<String,Action_Items__c> actionItems;
    private static Integer MAX_ALERTS=3;
    private static String CLASSNAME='ActionAlertBatch';
    private Datetime runDate;
    global ActionAlertBatch(){
        
        this.runDate = System.now();
        actionItems = new Map<String,Action_Items__c>();
        for(Action_Items__c actionItem: [Select Zone_Or_Leader__c, Smry_Criteria_Fld__c, Category__c 
                                        From Action_Items__c a where a.Zone_Or_Leader__c='Leader'])
        {
            actionItems.put(actionItem.Zone_Or_Leader__c+'-'+actionItem.Category__c,actionItem);
            ALMLogUtils.log('ActionAlerBatch','kpiName:'+actionItem.Category__c+',key='+(actionItem.Zone_Or_Leader__c+'-'+actionItem.Category__c));                                 
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        ALMLogUtils.log(CLASSNAME,'start() called !!!!');
        String qryString;
        //Start with Avon Leader Profile
        List<String> profilesToLook = new String[]{'Avon Leader'};
        String query='';
        Integer actionAlertHr = this.runDate.hour();//This will be 0-23
        System.debug('actionAlertHr :'+actionAlertHr);
	        query +=' select Id,SMS_Address__c,Action_Alert_1__c,Action_Alert_2__c,Action_Alert_3__c,GI3_Email__c,ACCT_NR__c,MRKT_ID__c,'+
	                '           Profile.Name,MRKT_ID_ACCT_NR_KEY__c,Name,Action_Alert_Time__c,Action_Alert_View__c,Action_Alert_Frequency__c,'+
	                '           (select Type__c,Count__c,ALM_User__c from Action_Alerts__r)'+
	                ' from      User'+
	                ' where Action_Alert_Enabled__c=true'+
	                ' and IsActive=true'+
	                ' and Action_Alert_Time__c=:actionAlertHr'+
                ' and Profile.Name in :profilesToLook';
        ALMLogUtils.log(CLASSNAME,'query:'+query);  
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        ALMLogUtils.log(CLASSNAME,'Processing Users:'+scope.size());
        List<User> usrList = (List<User>)scope;
        Map<String,User> userMap = new Map<String,User>();
        List<User> userIdsToAlert = new List<User>();
        String dayOfWeek = runDate.format('EEE');
        Map<Id,List<String>> addlRecipients = new Map<Id,List<String>>();
        List<String> usrEmailList;
        
        Map<String,String> cmpMap =new Map<String,String>();
	    Map<String,Market__c> cmpMap1 =new Map<String,Market__c>();
        Map<String,String> obj_to_query_Map =new Map<String,String>();
        
        Pattern EmailPattern = Pattern.compile('^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$');
        //create Market id list
        List<String> mktLst = new List<String>();
        
        for(Market__c mkt: [Select CMPGN_NR__c,Market_Id__c,Mail_Plan_Enabled__c,ALM_Rep_Indicator__c from Market__c]){
	        	cmpMap1.put(mkt.Market_Id__c,mkt);
	            obj_to_query_Map.put(mkt.Market_Id__c,mkt.ALM_Rep_Indicator__c);//changed by swarnava for Genealogy Model Change
        }
        
        for(User usr: usrList){
            //Set this to true so that the Welcome task trigger does'nt fire
            //Need to determine a better way to do this.
            userMap.put(usr.MRKT_ID_ACCT_NR_KEY__c,usr);
            mktLst.add(usr.MRKT_ID__c);
            usr.Welcome_Message__c=true;
            if( usr.Action_Alert_Frequency__c=='Daily'||
                (dayOfWeek!='SAT' && dayOfWeek!='SUN' && usr.Action_Alert_Frequency__c=='Weekdays')||
                dayOfWeek==usr.Action_Alert_Frequency__c)
            {
                usrEmailList = new List<String>();
                userIdsToAlert.add(usr);
                if(usr.Email!=usr.GI3_Email__c){
                    usrEmailList.add(usr.GI3_Email__c);
                }
                if(usr.SMS_Address__c!=null){
                    Matcher EmailMatcher = EmailPattern.matcher(usr.SMS_Address__c);
                    if(EmailMatcher.matches()){
                            usrEmailList.add(usr.SMS_Address__c);
                    }
                }
                addlRecipients.put(usr.Id,usrEmailList);
                Market__c mkt = cmpMap1.get(usr.MRKT_ID__c);
			if(mkt.Mail_Plan_Enabled__c && (usr.Action_Alert_View__c == 'Selling Month')) {
				try{
				    List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c, usr.ACCT_NR__c, usr.MRKT_ID__c);
					String mailPlanCampaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lst_CombinedObj[0].getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
					cmpMap.put(usr.id,mailPlanCampaignNumbr);
				}catch(Exception e){
					System.debug('\n Caught Exception while getting Mail Plan in ActionAlerBatch '+e.getMessage());
					cmpMap.put(usr.id,mkt.CMPGN_NR__c);
				}
			}else{
			cmpMap.put(usr.id,mkt.CMPGN_NR__c);
                }
            }
        }
        Set<String> mktAcctKeyList = userMap.keySet();
        //Trace Campaign number
        
         /*
	        if(mktLst.size()>0){
	            for(Market__c mkt: [Select CMPGN_NR__c,Market_Id__c,Mail_Plan_Enabled__c,ALM_Rep_Indicator__c from Market__c where Market_Id__c in :mktLst]){
	                if (!mkt.Mail_Plan_Enabled__c){
	                	cmpMap.put(mkt.Market_Id__c,mkt.CMPGN_NR__c);
	                }else {
		        		cmpMap.put(mkt.Market_Id__c,mkt.CMPGN_NR__c);
	                }
	                obj_to_query_Map.put(mkt.Market_Id__c,mkt.ALM_Rep_Indicator__c);//changed by swarnava for Genealogy Model Change
	            }
        }*/
        
        List<Action_Alert__c> toUpsert = new List<Action_Alert__c>();
        for(String mktid:mktLst){//changed by swarnava for Genealogy Model Change
        String obj_to_query=obj_to_query_Map.get(mktid);//changed by swarnava for Genealogy Model Change
        obj_to_query=obj_to_query.replace('__c','__r');//changed by swarnava for Genealogy Model Change
        for(Contact conrec : Database.query(getDownlineSummarySoql(obj_to_query))){//changed by swarnava for Genealogy Model Change
            toUpsert.addAll(updateActionAlerts(userMap.get(conrec.MRKT_ACCT_KEY__c),conrec.getSObjects(obj_to_query),cmpMap));
        }   
        }
        
        upsert toUpsert Action_Alert_Unique_Key__c;

        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        
        EmailUtils.sendEmail(userIdsToAlert, addlRecipients,globalConfig.Action_Alert_Template_Id__c,null,null,true);
        
    }
    
    global void finish(Database.BatchableContext BC){

    }
    
    private List<Action_Alert__c> updateActionAlerts(User usr,List<sObject> smryRecLst, Map<String,String> cmpMap){
        Action_Items__c actItem;
        String kpiName;
        String usrType = (usr.Profile.Name=='Avon Leader')?'Leader':'Zone';
        Decimal count=0.0,tempCount=0.0;
        List<Action_Alert__c> alerts2Update = new List<Action_Alert__c>();
        sObject smryRec;
        for(sObject ldr:smryRecLst){
            if(ldr.get('FLD_SLS_CMPGN_NR__c')==Integer.valueOf(cmpMap.get(usr.id))){
                ALMLogUtils.log(CLASSNAME,'Ldr Summary Record='+ldr);
                smryRec = ldr;
            }
        }
        for(Integer i=1;i<=MAX_ALERTS;i++){
            kpiName = (String)usr.get('Action_Alert_'+i+'__c');
            ALMLogUtils.log(CLASSNAME,'kpiName='+kpiName);
            count=0.0;
            if(kpiName!=null&&kpiName!=''){
                actItem = actionItems.get(usrType+'-'+kpiName);
                ALMLogUtils.log(CLASSNAME,'actItem='+actItem);
                if(smryRec!=null){
                    try{
                        tempCount = getFieldValue(smryRec,actItem.Smry_Criteria_Fld__c);
                        ALMLogUtils.log(CLASSNAME,'tempCount='+tempCount);
                        count +=tempCount;
                        ALMLogUtils.log(CLASSNAME,'Action_Alert_Unique_Key__c='+(usr.MRKT_ID_ACCT_NR_KEY__c+'-'+kpiName));
                        alerts2Update.add(new Action_Alert__c(  OwnerId=usr.Id,ALM_User__c=usr.Id,
                                                                Count__c=count,Type__c=kpiName,
                                                                Action_Alert_Unique_Key__c=usr.MRKT_ID_ACCT_NR_KEY__c+'-'+kpiName,
                                                                Name=usr.Name+'-'+kpiName));
                    }catch(Exception ex){}
                }else{
                    String errId=ErrorHandler.handleError('No Summary Record Found for User >>>>>> '+usr);
                }
            }
            
        }
        return alerts2Update;
    }
    
    private String getDownlineSummarySoql(String query_obj){//changed by swarnava for Genealogy Model Change
        Schema.SObjectType obj = Schema.getGlobalDescribe().get(query_obj.replace('__r','__c'));//changed by swarnava for Genealogy Model Change
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select CurrencyIsoCode, Id, Name, ';
        for(String fldName: fldMap.keySet()){
            if(fldName.endsWith('__c')){
                tempSoql+=fldName+', ';
            }
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' from '+query_obj;//changed by swarnava for Genealogy Model Change
        ALMLogUtils.log('SOQLUtils','soqlForLeaderDownline:soql=['+tempSoql+']');
        String conSoql ='Select Id, Name, MRKT_ACCT_KEY__c, ('+tempSoql+') From Contact Where MRKT_ACCT_KEY__c IN :mktAcctKeyList';
        return conSoql;     
    }
    
    private Decimal getFieldValue(Sobject currRec,String colFlds){
        Decimal totVal = 0.0;
        ALMLogUtils.log(CLASSNAME,'colFlds='+colFlds);
        String tempFld;
        if(colFlds!=null){
            for(String fldName: colFlds.split('\n')){
                tempFld = fldName.trim();
                totVal+=(currRec.get(tempFld)!=null?(Decimal)currRec.get(tempFld):0.0);
            }
        }
        return totVal;
    }
 //@S-144891 : Commented by Blaine Rothrock on Nov 23   
    /*public static testmethod void testActionAlertBatch(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        String acctNbr = '123456';
        User usr = testData.createLeaderUser(acctNbr);
        testData.createActionItems();
        usr.Action_Alert_Enabled__c=true;
        usr.Action_Alert_1__c='Orders Not submitted';
        usr.Action_Alert_Frequency__c='Daily';
        Datetime dt = System.now();
        Integer actionAlertHr = dt.hour();
        usr.Action_Alert_Time__c=actionAlertHr;
        usr.SMS_Address__c='test@avon.com';
        update usr;
        
        mkt.OwnerId = usr.Id;
        update mkt;
        
        Contact conData =testData.createContact(usr.ACCT_NR__c,usr.Id);
        List<SObject> ldrData = testData.createRepPerformance(usr.ACCT_NR__c,usr.Id);
        System.debug('>>>>>> Contact Data'+conData+'>>>>>> Ldr Data'+ldrData[0]);
        Test.startTest();
        ActionAlertBatch alertBatch = new ActionAlertBatch();
        Database.executeBatch(alertBatch,200);
        Test.stopTest(); 
        List<Action_Alert__c> alerts = [select Id,Type__c from Action_Alert__c where OwnerId=:usr.Id];
        System.assert(usr.Action_Alert_Time__c==System.now().hour());
        if(alerts.size() > 0) {
            System.assert(alerts.size()==1);
            System.assert(alerts[0].Type__c=='Orders Not submitted');
        }
    }*/
    
}