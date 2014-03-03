public class MyActionItemsController {

    public List<SObject> combobjRec {get; set;}
    public List<SObject> leadRecs {get; set;}
    public String repMktAcctNbr {get; private set;}
    public String repAcctNbr {get; private set;}
    public String mktId {get; private set;}
    public List<Decimal> cmpnNbr {get; private set;}
    public List<String> stsLead {get; private set;}
    public List<Market_Action_Items__c> mkt_action_item{get; private set;}
    public String obj_to_query;
    public String actionItemCampaign {get; set;} 
    public Market__c currMrkt {get;set;}
    
    public PageReference init(){
        User currUsr;
        String comb_obj='';
        String conSoql='';
        //added by Snehashis
        String sidBarInd=ApexPages.currentPage().getParameters().get('sidebar');
        currUsr =   [   select  ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c,MRKT_ID__c,Profile.Name,
                                DFALT_ZONE_CD__c,DFALT_DIV_NM__c,Is_Eligible__c,Opt_In__c,Out_of_Office__c
                        from    User
                        where   Id = :UserInfo.getUserId()];  
        String usrID = currUsr.Id;
        currMrkt =[Select      Id,Name,Is_ALMPLUS_Enabled__c,
									OPERTNL_CMPGN_CMPLTN_PCT__c,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, NEXT_1_CMPGN_NR__c,Omniture_Suite_Name__c,Enabled_Action_Item__c,
                                        Market_Id__c,  CURRNT_CMPGN_RMN_DAY_CNT__c,ALM_Rep_Indicator__c, 
                                        CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_NR_NUMBER__c, CMPGN_END_DT__c,
                                        LAST_UPDT_DT__c,GI3_Keep_Alive_URL__c,CURRENT_CAMPAIGN_NR__c , Mail_Plan_Enabled__c 
                                From    Market__c   
                                where   Market_Id__c =:currUsr.MRKT_ID__c ];
        this.mktId=currUsr.MRKT_ID__c;
        if(!currMrkt.Mail_Plan_Enabled__c)
        	this.cmpnNbr = new Decimal[]{currMrkt.CMPGN_NR_NUMBER__c};
        else {
        		List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(currMrkt.ALM_Rep_Indicator__c, currUsr.ACCT_NR__c, currUsr.MRKT_ID__c);
        		system.debug('>>>> Action item Combined Object List'+lst_CombinedObj);
        		String currCmpgn, nxtCmpgn;
        		//Decide CC campaign and Next Campaign
        		if(lst_CombinedObj.size()>0){
	        		for(Sobject obj :lst_CombinedObj){
	        			String tmpCmp=YOUUtil.getCampaignNumbrMailPlan((String)obj.getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
	        			system.debug('>>>> Action item Combined Cmapign List'+(String)obj.getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
	        			//Assumption 1: Mailplan data only exist for current and future campaign
	        			if(tmpCmp==currMrkt.CMPGN_NR__c){
	        				system.debug('>>>> Action item 1');
	        				currCmpgn=tmpCmp;
	        			} else if(tmpCmp==currMrkt.NEXT_1_CMPGN_NR__c){
	        				system.debug('>>>> Action item 2');
	        				nxtCmpgn=tmpCmp;
	        				currCmpgn=currMrkt.CMPGN_NR__c;
	        			}else{
	        				system.debug('>>>> Action item 3');
	        				currCmpgn=currCmpgn!=null?currCmpgn:currMrkt.CMPGN_NR__c;
	        				nxtCmpgn=nxtCmpgn!=null?nxtCmpgn:currMrkt.NEXT_1_CMPGN_NR__c;
	        			}
	        		}
        		}else{
        			currCmpgn=currMrkt.CMPGN_NR__c;
        			nxtCmpgn=currMrkt.NEXT_1_CMPGN_NR__c;
        			system.debug('>>>>In Else of dynamically detection for 1st time--> ');
        		}
        		system.debug('>>>> Action item 1 currCmpgn '+currCmpgn);
        		system.debug('>>>> Action item 1 nxtCmpgn '+nxtCmpgn);
	      //  	String mailPlanCampaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lst_CombinedObj[0].getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
	        	System.debug('@@@ campaign : '+Apexpages.currentPage().getParameters().get('campaign'));
	        	List<Decimal> tmpCmpLst= new List<Decimal>();
	        	tmpCmpLst.add(Decimal.valueOf(currCmpgn));
                if(nxtCmpgn!=null)
                    tmpCmpLst.add(Decimal.valueOf(nxtCmpgn));
                else{
                    nxtCmpgn=currCmpgn;
                    tmpCmpLst.add(Decimal.valueOf(nxtCmpgn));
                }
                String tmpParam=ApexPages.currentPage().getParameters().get(ALMConstants.CAMPAIGN);
	        	if (tmpParam.equalsIgnoreCase(ALMConstants.NEXT_CAMPAIGN)){
	        		this.cmpnNbr = (sidBarInd=='4'?tmpCmpLst:new Decimal[]{Decimal.valueOf(nxtCmpgn)});
	        		actionItemCampaign = (sidBarInd=='4'?'Current;Next':'Next');
	        	}else if(tmpParam.equalsIgnoreCase(ALMConstants.CURRENT_CAMPAIGN)){
	        		this.cmpnNbr = (sidBarInd=='4'?tmpCmpLst:new Decimal[]{currMrkt.CMPGN_NR_NUMBER__c});
	        		actionItemCampaign = (sidBarInd=='4'?'Current;Next':'Current');
	        	}else if(tmpParam.equalsIgnoreCase(ALMConstants.PRIOR_CAMPAIGN)){
	        		this.cmpnNbr = (sidBarInd=='4'?tmpCmpLst:new Decimal[]{Decimal.valueOf(currMrkt.PREV_1_CMPGN_NR__c)});
	        		actionItemCampaign = (sidBarInd=='4'?'Current;Next':'');
	        	}else{
	        		System.debug('No Campaign Selected::');
	        		//if (currMrkt.CMPGN_NR__c == currCmpgn){
	        			actionItemCampaign = (sidBarInd=='4'?'Current;Next':'Current');
	        			this.cmpnNbr=(sidBarInd=='4'?tmpCmpLst:new Decimal[]{currMrkt.CMPGN_NR_NUMBER__c});
	        	/*	}else{
	        			actionItemCampaign = (sidBarInd=='4'?'Current;Next':'Next');
	        			this.cmpnNbr=(sidBarInd=='4'?tmpCmpLst:new Decimal[]{Decimal.valueOf(nxtCmpgn)});	
	        		}  */
	        	}
        	} 
        	
        
        System.debug('\n #### MyActionItemsController . initialized this.cmpnNbr --->> '+this.cmpnNbr); 
        mkt_action_item= [Select	Action_Item__r.Zone_Or_Leader__c, Threshold__c, Filter_Param__c,
												Action_Item__r.Smry_Criteria_Fld__c, Report__r.Report_Id__c,Report__r.Report_Type__c, Report__r.Report_URL__c,
												Action_Item__r.Order_Criteria_Fld__c,Action_Item__r.Rep_Criteria_Fld__c,
												Action_Item__r.Genealogy_Criteria_Fld__c,Action_Item__r.Default__c,
												Priority__c, Market__c, Campaign_Stage__c,
												Action_Item__r.Action_Item_Type__c,Action_Item__r.Category__c,
												Action_Item__r.Subject_Area__c,Action_Item__r.Datatype__c,Campaign__c,Default__c  
										From 	Market_Action_Items__c
										where	Market__c=:currMrkt.Id
										and		Action_Item__r.Zone_Or_Leader__c = 'Leader'
										order by Action_Item__r.Subject_Area__c,Priority__c asc];
      if(currUsr.Profile.Name=='Avon Leader'){
            if(currUsr.MRKT_ID_ACCT_NR_KEY__c!=null && currUsr.MRKT_ID_ACCT_NR_KEY__c!=''){
                this.repMktAcctNbr=currUsr.MRKT_ID_ACCT_NR_KEY__c;
                this.repAcctNbr=currUsr.ACCT_NR__c;
                obj_to_query=currMrkt.ALM_Rep_Indicator__c.replace('__c','__r');
                comb_obj=aisoqlForcombobj(mkt_action_item,obj_to_query);
                conSoql ='Select Id, Name, ('+comb_obj+') From Contact Where MRKT_ACCT_KEY__c=:repMktAcctNbr and MRKT_ID__c=:mktId';
                ALMLogUtils.log('MyActionItemsController','Contact SOQL=['+conSoql+']');
                try{
                    SObject conobj= Database.query(conSoql);
                    this.combobjRec=conobj.getSObjects(obj_to_query);
                }catch(exception ex){
                    ALMLogUtils.log('MyActionItemsController','Message is -> '+ex.getStackTraceString());   
                }
            
            //Added by Snehashis for Lead Action Items -- Required for Phase -2
            /*stsLead = new List<String>{ALMPLusConstants.LEAD_STS_NEW,ALMPLusConstants.LEAD_STS_INPRGRS};
            ALMLogUtils.log('MyActionItemsController','usrID=['+usrID+'] & mktId=['+mktId+']');
            this.leadRecs = Database.query(SOQLUtils.soqlForLead());
            ALMLogUtils.log('MyActionItemsController','Lead Record=['+leadRecs.size()+']');*/
            }
        }
        
        return null;
    }
    public static String aisoqlForcombobj(List<Market_Action_Items__c> so,String obj_to_query){
       // Schema.DescribeSObjectResult descResult= obj.getDescribe();
       // Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select CurrencyIsoCode, Id, Name,FLD_SLS_CMPGN_NR__c,OPERTNL_CMPGN_NR__c, ';
        for(Market_Action_Items__c s: so){ 
        		if(s.Action_Item__r.Smry_Criteria_Fld__c!=NULL)          
                tempSoql+=s.Action_Item__r.Smry_Criteria_Fld__c+', ';
            
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' from '+obj_to_query;
        tempSoql += ' where MRKT_ID__c=:mktId and FLD_SLS_CMPGN_NR__c IN :cmpnNbr';
        ALMLogUtils.log('SOQLUtils','soqlForLeaderDownline:soql=['+tempSoql+']');
        return tempSoql;
    }   
   
  
   //@S-144891 : Commented by Blaine Rothrock on Nov 23
   /*@isTest(SeeAllData=true)  
   public static void testMyActionItems()
   {
   		TestDataHelper testData=new TestDataHelper();
	    // Creating user data
    	User ldrUsr = testData.createLeaderUser('XX');
        ldrUsr.MRKT_ID__c = 'XX';
        ldrUsr.IsActive = true;
        update ldrUsr;
        
        // Creating Market Action Items
        testData.createMarketActionItems();
        //test case for markets do not have Mailplan
        Test.startTest();
        System.runAs(ldrUsr)
        {
        	MyActionItemsController objController = new MyActionItemsController();
        	objController.init();	
        	//System.assert(objController.mkt_action_item.size() == 8);
        }
        Test.stopTest();
        //test case for markets enables Mailplan
        testData.market.Mail_Plan_Enabled__c=true;
        update testData.market;
        List<MailPlan_Order_Oppty__c> mplst=testData.createMailPlans();
        testData.createContact(ldrUsr.ACCT_NR__c, ldrUsr.Id);
        List<String> mktKeyLst=new List<String>();
        mktKeyLst.add(testData.market.Market_Id__c + testData.market.CMPGN_NR__c + ldrUsr.ACCT_NR__c);
        mktKeyLst.add(testData.market.Market_Id__c + testData.market.NEXT_1_CMPGN_NR__c + ldrUsr.ACCT_NR__c);
       	testData.createMulRepPerformance(mktKeyLst, testData.market.Market_Id__c, ldrUsr.Id);
      	String uplineAcctNr=ldrUsr.ACCT_NR__c;
        //testData.createRepPerformance(new List<String> {testData.market.Market_Id__c + testData.market.NEXT_1_CMPGN_NR__c + ldrUsr.ACCT_NR__c}, testData.market.Market_Id__c, ldrUsr.Id);
        List<ALM_Rep_Performance_1__c> ppList = [SELECT Id, MailPlan_Order_Oppty__c,AVG_GENRTN_3_UNIT_COMM_PCT__c, AVG_GENRTN_3_DISTR_SLS_PCT__c, AVG_GENRTN_2_UNIT_COMM_PCT__c,OPERTNL_CMPGN_NR__c FROM ALM_Rep_Performance_1__c
                                                WHERE ACCT_NR__c =:uplineAcctNr];
        List<MailPlan_Order_Oppty__c> tmpMp=new List<MailPlan_Order_Oppty__c>();
        for(MailPlan_Order_Oppty__c mp:mplst){
        	for(ALM_Rep_Performance_1__c ar:ppList){
	        	if(ar.OPERTNL_CMPGN_NR__c.contains(mp.CMPGN_NR__c)){
	        		ar.MailPlan_Order_Oppty__c=mp.Id;
	        		tmpMp.add(mp);
	        	}
	     	}                           
        }
        update ppList;
        
        //Testing for Current Campaign Scenarios
        PageReference pageRef = Page.MyActionItems;
        pageRef.getParameters().put('sidebar','1');
        pageRef.getParameters().put('campaign','current');
        Test.setCurrentPageReference(pageRef);
         System.runAs(ldrUsr)
        {
        	MyActionItemsController objController = new MyActionItemsController();
        	objController.init();	
        	//System.assert(objController.mkt_action_item.size() == 8);
        }
        //Testing for Next Campaign Scenarios
        PageReference pageRefnxt = Page.MyActionItems;
        pageRefnxt.getParameters().put('sidebar','1');
        pageRefnxt.getParameters().put('campaign','next');
        Test.setCurrentPageReference(pageRefnxt);
         System.runAs(ldrUsr)
        {
        	MyActionItemsController objController = new MyActionItemsController();
        	objController.init();	
        	//System.assert(objController.mkt_action_item.size() == 8);
        }
        //Testing for No Campaign Scenarios
         PageReference pageRefnoc = Page.MyActionItems;
         pageRefnoc.getParameters().put('campaign','Current');
          Test.setCurrentPageReference(pageRefnoc);
         System.runAs(ldrUsr)
        {
        	MyActionItemsController objController = new MyActionItemsController();
        	objController.init();	
        	//System.assert(objController.mkt_action_item.size() == 8);
        }
   }*/
}