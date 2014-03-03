public with sharing class ZM_User_Sales_Org_Hierarchy_Handler {
	
	//======================================
	//Generigc Handler for the before delete event
	public void onBeforeDelete(map<Id,User_Sales_Org_Hierarchy__c> oldMap)
	{
		set<String> stringSet = new set<String>();
		for(String s :oldMap.keySet())
		  stringSet.add(s);
		  	removeFromZoneGroup(stringSet);
	}
	
	//===========================================
	//Generigc Handler for the after update event
	public void onAfterInsert(map<Id,User_Sales_Org_Hierarchy__c> oldMap, map<Id,User_Sales_Org_Hierarchy__c> newMap)
	{
		set<String> stringSet = new set<String>();
		for(String s :newMap.keySet())
		  stringSet.add(s);
		  
		addToZoneGroup(stringSet);
		
	}
	
	//===============================================
	//removes the user from the associated zone Group
	public static void removeFromZoneGroup(set<String> userSalesOrgHierarchyUtil)
	{
		//User_Sales_Org_Hierarchy__c.SLS_ORG_CD__c
		System.debug('DEL userSalesOrgHierarchyUtil: '+userSalesOrgHierarchyUtil);
		set<String> zoneGroupNames = new set<String>();
		set<String> zoneUsers = new set<String>();
		set<String> zoneMarket = new set<String>();
		map<String, Id> userAcctMap = new map<String, Id>();
		map<String, Id> zoneGroupMap = new map<String, Id>();
		map<String, String> gMemberMap = new map<String, String>();
		set<String> delGroupMembers = new set<String>();
		
		//create a list of zone Ids
		for(User_Sales_Org_Hierarchy__c u : [Select Id,MRKT_ID__c,SLS_ORG_CD__c,ACCT_NR__c , SLS_ORG_LVL_CD__c
		                                       from User_Sales_Org_Hierarchy__c 
		                                      	where Id in :userSalesOrgHierarchyUtil]){
		   zoneGroupNames.add('Mrkt '+u.MRKT_ID__c+' '+u.SLS_ORG_LVL_CD__c+' '+u.SLS_ORG_CD__c);
		   zoneUsers.add(u.ACCT_Nr__c);
		   zoneMarket.add(u.MRKT_ID__c);
		}
		
		//get the user data
		for(user u : [Select Id, ACCT_Nr__c, MRKT_ID__c from User where ACCT_Nr__c in :zoneUsers ])
		   userAcctMap.put(u.ACCT_Nr__c+'-'+u.MRKT_ID__c, u.Id);
		
		System.debug('::::::::: ADD userAcctMap :::::::: '+userAcctMap);
		
		//retrieve the groups based on the zone - Select g.UserOrGroupId, g.GroupId From GroupMember g
		for(Group g : [Select Id, Name from Group where name in :zoneGroupNames])
		{
			zoneGroupMap.put(g.Name.substring(g.Name.indexOf(' Zone ')+6, g.Name.length()), g.Id);
		}
		
		System.debug('::::::::: DEL zoneGroupMap :::::::: '+zoneGroupMap);
		//create a map that identifies which groups to delete
		for(User_Sales_Org_Hierarchy__c u :  [Select Id,MRKT_ID__c,SLS_ORG_CD__c , ACCT_NR__c from User_Sales_Org_Hierarchy__c where Id in :userSalesOrgHierarchyUtil]){
			
			System.debug('::::::::: DEL u.ACCT_Nr__c+-+u.MRKT_ID__c >>> '+u.ACCT_Nr__c+'-'+u.MRKT_ID__c);
			gMemberMap.put(userAcctMap.get(u.ACCT_Nr__c+'-'+u.MRKT_ID__c)+'-'+zoneGroupMap.get(u.SLS_ORG_CD__c),'DEL');
		}
		System.debug('::::::::: DEL gMemberMap :::::::: '+gMemberMap);
		//retrieve the GroupMember Records to delete
		for(GroupMember gm : [Select Id, UserOrGroupId, GroupId 
		                        from GroupMember 
		                       where GroupId in :zoneGroupMap.values() 
		                         and UserOrGroupId in :userAcctMap.values()] )
		{
			
			System.debug('::::::::: DEL gm.UserOrGroupId+-+gm.GroupId >>> '+gm.UserOrGroupId+'-'+gm.GroupId);
			if(gMemberMap.containsKey(gm.UserOrGroupId+'-'+gm.GroupId))
			   delGroupMembers.add(gm.Id);
		}
		
		System.debug('::::::::: DEL delGroupMembers :::::::: '+delGroupMembers);
		//delete the GroupMember Records
		if(delGroupMembers.size() > 0) deleteUserGroup(delGroupMembers);
	}
	
	@future
	public static void deleteUserGroup(set<String> delGroupMembers)
	{
		list<GroupMember> gMembers = new list<GroupMember>();
		for(String s : delGroupMembers)
		  gMembers.add(new GroupMember(Id=s));
		  
		if(gMembers.size() > 0) delete gMembers; 
	}
	//===========================================
	//Adds the user to the associated zone Group
	@future
	public static void addToZoneGroup(set<string> userSalesOrgHierarchyUtil)
	{
		//User_Sales_Org_Hierarchy__c.SLS_ORG_CD__c
		System.debug('ADD userSalesOrgHierarchyUtil: '+userSalesOrgHierarchyUtil);
		set<String> zoneGroupNames = new set<String>();
		set<String> zoneUsers = new set<String>();
		set<String> zoneMarket = new set<String>();
		map<String, Id> userAcctMap = new map<String, Id>();
		map<String, Id> zoneGroupMap = new map<String, Id>();
		list<GroupMember> gMembers = new list<GroupMember>();
		
		//create a list of zone Ids
		for(User_Sales_Org_Hierarchy__c u : [Select Id,MRKT_ID__c,SLS_ORG_CD__c, ACCT_NR__c , SLS_ORG_LVL_CD__c
		                                       from User_Sales_Org_Hierarchy__c 
		                                      where Id in :userSalesOrgHierarchyUtil]){
		   
		  
		   zoneGroupNames.add('Mrkt '+u.MRKT_ID__c+' '+u.SLS_ORG_LVL_CD__c+' '+u.SLS_ORG_CD__c);
		   zoneUsers.add(u.ACCT_Nr__c);
		   zoneMarket.add(u.MRKT_ID__c);
		}
		
		//get the user data
		for(user u : [Select Id, ACCT_Nr__c, MRKT_ID__c from User where ACCT_Nr__c in :zoneUsers ])
		   userAcctMap.put(u.ACCT_Nr__c+'-'+u.MRKT_ID__c, u.Id);
		
		System.debug('::::::::: ADD userAcctMap :::::::: '+userAcctMap);
		
		//retrieve the groups based on the zone - Select g.UserOrGroupId, g.GroupId From GroupMember g
		for(Group g : [Select Id, Name from Group where name in :zoneGroupNames])
		{
			zoneGroupMap.put(g.Name.substring(g.Name.indexOf(' Z ') + 3, g.Name.length()), g.Id);
		}
		System.debug('::::::::: ADD zoneGroupMap :::::::: '+zoneGroupMap);
		
		for(User_Sales_Org_Hierarchy__c u :  [Select Id,MRKT_ID__c,SLS_ORG_CD__c,ACCT_NR__c from User_Sales_Org_Hierarchy__c where Id in :userSalesOrgHierarchyUtil]){
			System.debug('::::::::: ADD userAcctMap.get(u.ACCT_Nr__c+-+u.MRKT_ID__c) >>> '+userAcctMap.get(u.ACCT_Nr__c+'-'+u.MRKT_ID__c));
			System.debug('::::::::: ADD zoneGroupMap.get(u.SLS_ORG_CD__c) >>> '+zoneGroupMap.get(u.SLS_ORG_CD__c));
			
			gMembers.add(new GroupMember(UserOrGroupId = userAcctMap.get(u.ACCT_Nr__c+'-'+u.MRKT_ID__c)
			                            ,GroupId = zoneGroupMap.get(u.SLS_ORG_CD__c)));
		}
		
		if(gMembers.size() > 0) database.insert(gMembers, false);
		
		System.debug('::::::::: ADD gMembers :::::::: '+gMembers);
	}
	
	//@S-144891 : Commented by Blaine Rothrock on Nov 23
	/*static testMethod void testThisClass()
	{
		//create the user
		User usr = [Select Id from User where Id = :UserInfo.getUserId()];
		usr.MRKT_ID__c = '62';
		usr.ACCT_NR__c = '12345';
		update usr;
		
		//create or retrieve the group
		Group g = new Group( Name = 'Mrkt '+usr.MRKT_ID__c+' Z '+usr.ACCT_NR__c
			                ,Type = 'Regular');
		insert g;
		
		//create the market
		Market__c market = new Market__c(   Name='Test Market',
	                                        Market_Id__c='62',
	                                        Market_Administrator__c=UserInfo.getUserId(),
	                                        Available_Languages__c='en_US',
	                                        CurrencyISOCode='USD',
	                                        Mail_Plan_Enabled__c=true,
	                                        ASLF_Timezone_Offset__c=0.0,
	                                        ASLF_Report_URL__c='http://aslf.report.avon.com',
	                                        CURRNT_CMPGN_RMN_DAY_CNT__c=10,
	                                        CMPGN_NR__c='201204',
	                                        OPERTNL_CMPGN_CMPLTN_PCT__c=25,
	                                        NEXT_1_CMPGN_NR__c='201205',
	                                        CURRENT_QRTR__c='2012-Q3',
	                                        Enabled_Action_Item__c='Orders; Sales; Current Business',
	                                        PREV_1_CMPGN_NR__c='201203',
	                                        SPONSOR_QLFYING_ORD_AMT__c=1,
	                                        CMPGN_STRT_DT__c=System.today(),
	                                        CMPGN_END_DT__c=System.today(),
	                                        Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c',
	                                        Eligibility_Yes_Flags__c='Opt_In__c',
	                                        LeadMandatoryFields__c='User_Type__c,FirstName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c,Geo_Level_4__c,Mobile__c',
	                                        SPPY_CMPGN_NR__c='201001',
	                                        X90_Day_Camp_CNT__c=6,
	                                        Business_Plan_KPIs__c ='Unit_Earnings_dollar;Total_Unit_Sales_dollor;G1_Sales_Leaders_UL;G1_Activity_Rate;Bonus_Earnings;Earnings_from_Personal_Sales;Executive_Earnings;New_G1_UL;New_G1_EUL;New_G1_AUL;Total_and_Est_Earnings_dollar;Personal_Appointments;Qualified_Personal_Appointments;Personal_Volume_dollar;G1_Removals;G1_Active_Representatives',
	                                        Max_Ldr_Titl_LVL__c = 9,
	                                        Allow_Freeform_Email__c='Avon Leader;Avon Division Manager',
	                                        Allow_Free_Emails_For__c ='G1');
                                        
          insert market;
                    
		//create the User_Sales_Org_Hierarchy__c record
		User_Sales_Org_Hierarchy__c u = new User_Sales_Org_Hierarchy__c();
		u.SLS_ORG_LVL_CD__c = 'Z';
		u.SLS_ORG_CD__c = '111';
		u.Market__c = market.Id; 
		u.MRKT_ID__c = '62';
		u.MRKT_ID_ACCT_NR_SLS_ORG_KEY__c = '620000000129660111'; 
        u.ACCT_NR__c = '12345';
        //call the insert method
        insert u;
		
		//verify results
		//System.assertEquals(usr.Id, [select UserOrGroupId from GroupMember where UserOrGroupId = :usr.Id and GroupId = :g.Id].UserOrGroupId);
		
		//call the delete method
		delete u;
	}*/

}