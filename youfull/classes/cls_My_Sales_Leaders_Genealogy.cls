global  without sharing class cls_My_Sales_Leaders_Genealogy {
    
    //Public Declerations
    
    //String Declerations
    
    public String s_Impersonate;
    public String s_DrillDown;
    public String s_ImpersonationUser {get; set;}
    public String s_mktID{get;  set;}
    public String s_mktIndicator{get; set;}
    public String s_curUsrId{get; private set;}
    public String s_User_Account_Number{get;set;}
    public String s_User_Language{get;set;}
    public String s_Current_Campaign{get;set;}
    public String s_Campaign_Start_Date{get;set;}
    public String s_Campaign_End_Date{get;set;}
    public String s_CurrUsr_Title{get;set;}
    public String s_CurrUsr_Style{get;set;}
    public String repDetailAcctNbr {get; set;}
    public String s_mrktSalesforceId {get;set;}
    public String s_Impersonated_Profile{get;set;}
    public String s_Impersonated_LDRTitlLvl{get;set;}
    public String s_Impersonated_UserName{get;set;}
    public String s_UL{get;set;}
    public String s_AUL{get;set;}
    public String s_EUL{get;set;}
    public String s_SEUL{get;set;}
    public String s_Current_Selected_Campaign {get;set;}
    public Integer i_UserTitleLevel {get;set;}
    public static String s_Google_Chart {get;set;}
    public Boolean s_IsImpersonated{get;set;}
    public List<Report_Config__c> lst_ReportLinks{get;set;} //For Report Link
    
     public Integer i_CurrUsr_TotalPersonalSales{get;set;}
     public Integer i_CurrUsr_GroupSales{get;set;}
     public Integer i_CurrUsr_BlockedGS{get;set;}
     public Integer i_CurrUsr_G1Actives{get;set;}
     public Integer i_CurrUsr_TitleLegs{get;set;}
     public String s_CurrUsr_UL{get;set;}
     public String s_CurrUsr_AUL{get;set;}
     public String s_CurrUsr_EUL{get;set;}
     public String s_CurrUsr_SEUL{get;set;}
    
    //Integer & Double Declerations
    public Contact p_Contact{get;set;}
    public Integer i_Downline_Depth{get;set;}   
    public String  s_Genealogy_String{get;set;}
    public String s_UserAgent{get;set;}

    //Object Declerations
    public User currUsr {get; private set;}
    public User orgnUsr {get; private set;}
    public Market__c market {get; private set;}
    public static Integer i_Node_Count {get;set;}
    public static Integer i_Level_One_Node_Count {get;set;}
     public String s_User{get;set;}
    public Leader_Title__c leadTitles {get;set;}
    public  Map<String,String> m_ColorCoding {get;set;}
    public  Map<String,String> m_LeaderTitles {get;set;}
    public  Map<String,String> m_LeaderStyles {get;set;}
    public List<SelectOption> l_Campaign {get;set;}
    public ALM_Global_Settings__c globalConfig {get; set;}
    
    public  Set<String> s_String = new Set<String>();
    public  Set<String> s_String_MKey = new Set<String>();
    public  transient Map<String,String> m_Map = new Map<String,String>();
    public  transient Map<String,Contact> m_Details = new Map<String,Contact>();
    public  transient Map<String,sObject> m_PP_Details = new Map<String,sObject>();
    
    public  String s_FirstNode {get;set;}
    
    public String mode {get; set;}
    
    public cls_My_Sales_Leaders_Genealogy(){
    
                system.debug(':::::::::::: Constructor CALL' );
                
                i_Node_Count=0;
                i_Level_One_Node_Count=0;
                s_IsImpersonated=false;
                lst_ReportLinks = new List<Report_Config__c>();
                m_ColorCoding= new Map<String,String>();
                m_LeaderTitles= new Map<String,String>();
                m_LeaderStyles= new Map<String,String>();
                
                i_CurrUsr_TotalPersonalSales=0;
                i_CurrUsr_GroupSales=0;
                i_CurrUsr_BlockedGS=0;
                i_CurrUsr_G1Actives=0;
                i_CurrUsr_TitleLegs=0;
    
                this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
                s_UserAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
                initializeReport();
                
    }
    
   public void initializeReport(){
   		
   		try{
   				String s_Impersonated_User = Apexpages.currentPage().getParameters().get('acctkey');
                User currLogUser;
                   
            	if(s_Impersonated_User!=null && s_Impersonated_User.trim()!=''){
		                currLogUser=[SELECT Id, Profile.Id, Profile.Name, DFALT_ZONE_CD__c, 
		                DFALT_DIV_NM__c, MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, 
		                Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c 
		                FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		                
		                Integer campaignNr = YOUUtil.getCurrentCampaignNumber(currLogUser.MRKT_ID__c);
		                String campaign = String.valueOf(campaignNr);
		                
		                Boolean IsImp = LandingPageUtils.isImpersonationValid(currLogUser.Profile.Name, 
		                                currLogUser.MRKT_ID__c, currLogUser.DFALT_ZONE_CD__c, 
		                                currLogUser.DFALT_DIV_NM__c, currLogUser.ACCT_NR__c, 
		                                campaign, s_Impersonated_User);
	
		                if (IsImp){
		                    User u = [Select Id,Name,LanguageLocaleKey,MRKT_ID__c,
		                                ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c,Profile.Name,
		                                LDRSHP_TITL_LVL_NBR__c 
		                                from User 
		                                where ACCT_NR__c =: s_Impersonated_User
		                                and MRKT_ID__c=:currLogUser.MRKT_ID__c Limit 1 ];
		                            s_User=u.Id;
		                            s_Impersonated_UserName=u.Name;
		                            s_IsImpersonated = true;
		                            s_Impersonated_Profile=u.Profile.Name;
		                            s_Impersonated_LDRTitlLvl=u.LDRSHP_TITL_LVL_NBR__c;
		                }else {
		                    s_User = UserInfo.getUserId();
		                }
	            }else{
	                s_User = UserInfo.getUserId();
	            }
                  
                  
             	// Logged In or Impersonated User
              	currUsr = [Select   Id,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, 
                                    USER_CNTRY_CD__c,LastName, LanguageLocaleKey, FirstName,
                                    MRKT_ID_ACCT_NR_KEY__c,DFALT_ZONE_CD__c, DFALT_DIV_NM__c,ACCT_NR__c,
                                    Profile.Name,LDRSHP_TITL_LVL_NBR__c,LDRSHP_TITL_LVL_NBR_NUMBER__c,Is_Eligible__c,
                                    Opt_In__c,Out_of_Office__c,ZM_Override__c,System_Override__c
                       From   User
                       Where  Id=:s_User];
                
                this.currUsr.Profile.Name = currUsr.Profile.Name;
                s_User_Account_Number=currUsr.ACCT_NR__c;
                s_mktID=this.currUsr.MRKT_ID__c;
                s_curUsrId= this.currUsr.Id;
                s_User_Language=this.currUsr.LanguageLocaleKey;
                i_UserTitleLevel = Integer.valueOf(currUsr.LDRSHP_TITL_LVL_NBR_NUMBER__c) !=null ? Integer.valueOf(currUsr.LDRSHP_TITL_LVL_NBR_NUMBER__c) : 0 ;
                System.debug('Market Id-->'+s_mktID);
                System.debug('User Titl Level-->'+i_UserTitleLevel);
               
               
               //Market Information
                
                this.market = [ Select  Id,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, Name,Genealogy_Report_Configurable__c, 
                                        Market_Id__c,CMPGN_STRT_DT__c, CMPGN_NR__c,CMPGN_END_DT__c,
                                        Omniture_Suite_Name__c,CURRENT_QRTR__c, ALM_Rep_Indicator__c
                                From    
                                        Market__c
                                Where   
                                        Market_Id__c =:s_mktID];
                                        
                s_mktIndicator = this.market.ALM_Rep_Indicator__c;                        
                l_Campaign = new List<SelectOption>();
                l_Campaign.add(new SelectOption(this.market.CMPGN_NR__c,this.market.CMPGN_NR__c));
                l_Campaign.add(new SelectOption( this.market.PREV_1_CMPGN_NR__c,this.market.PREV_1_CMPGN_NR__c));
                s_mrktSalesforceId = this.market.Id;
                
                s_Current_Campaign = 'C'+String.valueOf((this.market.CMPGN_NR__c)).substring(5,(String.valueOf((this.market.CMPGN_NR__c))).length());
                s_Campaign_Start_Date = String.valueOf((this.market.CMPGN_STRT_DT__c).day())+'/'+String.valueOf((this.market.CMPGN_STRT_DT__c).month());
                s_Campaign_End_Date = String.valueOf((this.market.CMPGN_END_DT__c).day())+'/'+String.valueOf((this.market.CMPGN_END_DT__c).month());
                
                for(Leader_Title__c obj_Leader : [Select Id,LANG_CD__c,LCL_LDRSHP_TITL_CD__c,LDRSHP_TITL_LVL_NR__c,MRKT_ID__c From  Leader_Title__c Where Market__c=:s_mrktSalesforceId and LANG_CD__c=:s_User_Language]){
                    m_LeaderTitles.put(String.valueOf(obj_Leader.LDRSHP_TITL_LVL_NR__c),obj_Leader.LCL_LDRSHP_TITL_CD__c);  
                }
                
                if(m_LeaderTitles.size()>0){
                    s_UL = m_LeaderTitles.get('1');
                    s_AUL = m_LeaderTitles.get('2');
                    s_EUL = m_LeaderTitles.get('3');
                    s_SEUL = m_LeaderTitles.get('4');
                }
                 
                SiteHeaderController obj_Controller = new SiteHeaderController();
                obj_Controller.currUsr=currUsr;
                 if(s_IsImpersonated){
                    if(obj_Controller.getReportLinks(this.market.Market_Id__c, this.currUsr.Profile.Name,this.currUsr.LDRSHP_TITL_LVL_NBR__c,true).size()>0){
                        for(Report_Config__c obj_RC : obj_Controller.getReportLinks(this.market.Market_Id__c, s_Impersonated_Profile,s_Impersonated_LDRTitlLvl,true)){
                            
                            // Added by Raktim  - defect id : 2400
                            if(obj_RC.Report_Type__c !='My_Sales_Leaders_Genealogy')//changed by swarnava 
                            // End of Addition
                            
                                lst_ReportLinks.add(obj_RC);
                        	}
                    	}  
            		}
           			 else{
                		if(obj_Controller.getReportLinks(this.market.Market_Id__c, this.currUsr.Profile.Name , this.currUsr.LDRSHP_TITL_LVL_NBR__c,false).size()>0){
                			for(Report_Config__c obj_RC : obj_Controller.getReportLinks(this.market.Market_Id__c, this.currUsr.Profile.Name , this.currUsr.LDRSHP_TITL_LVL_NBR__c,false)){
		                        // Added by Raktim  - defect id : 2400 
		                        if(obj_RC.Report_Type__c != 'My_Sales_Leaders_Genealogy')
		                        // End of Addition
                        		    lst_ReportLinks.add(obj_RC);
                			}
            			}
         			}
                
            		if(this.market.Market_Id__c!=null && this.market.CMPGN_NR__c!=null){
	                   if(Apexpages.currentPage().getParameters().get('Campaign')!=null){
	                        s_Current_Selected_Campaign=Apexpages.currentPage().getParameters().get('Campaign');
	                   }
	                   else{
	                        s_Current_Selected_Campaign=this.market.CMPGN_NR__c;
	                   }
               
                     	//Current User Details
               			p_Contact = [Select Id,Name,SLS_ZONE_CD__c,(Select Id,GRP_SUBMTD_AWRD_SLS_AMT__c,GRP_BLCKD_UNIT_SLS_AMT__c,GENTRTN_1_ACTV_REP_CNT__c,TTL_LEG_CNT__c,GRP_INVCD_BLCKD_SLS_AMT__c,GRP_INVC_AWRD_SLS_AMT__c,GENRTN_1_TITL_1_STF_CNT__c,GENRTN_1_TITL_2_STF_CNT__c,GENRTN_1_TITL_3_STF_CNT__c,GENRTN_1_TITL_4_STF_CNT__c From Leadership_Summary__r Where FLD_SLS_CMPGN_NR__c=:Integer.valueOf(s_Current_Selected_Campaign)),(Select Id, PRSNL_SLS_AMT__c,SUBMTD_AWRD_SLS_AMT__c,LDRSHP_TITL_LVL_NR__c From My_Businesses__r Where FLD_SLS_CMPGN_NR__c=:Integer.valueOf(s_Current_Selected_Campaign)) From Contact Where MRKT_ACCT_KEY__c=:String.valueOf(s_MktId+s_User_Account_Number)];
               			if(p_Contact!=null){
                    
	                        sObject[] obj_Leadership = p_Contact.getSObjects('Leadership_Summary__r');
	                        if(obj_Leadership!=null){
	                            for(sObject l_Leadership : obj_Leadership){
	                                i_CurrUsr_G1Actives = Integer.valueOf(l_Leadership.get('GENTRTN_1_ACTV_REP_CNT__c'));
	                                i_CurrUsr_TitleLegs= Integer.valueOf(l_Leadership.get('TTL_LEG_CNT__c'));
	                                i_CurrUsr_GroupSales=Integer.valueOf(l_Leadership.get('GRP_INVC_AWRD_SLS_AMT__c'));
	                                i_CurrUsr_BlockedGS=Integer.valueOf(l_Leadership.get('GRP_INVCD_BLCKD_SLS_AMT__c'));
	                                s_CurrUsr_UL=String.valueOf(l_Leadership.get('GENRTN_1_TITL_1_STF_CNT__c'));
	                                s_CurrUsr_AUL=String.valueOf(l_Leadership.get('GENRTN_1_TITL_2_STF_CNT__c'));
	                                s_CurrUsr_EUL=String.valueOf(l_Leadership.get('GENRTN_1_TITL_3_STF_CNT__c'));
	                                s_CurrUsr_SEUL=String.valueOf(l_Leadership.get('GENRTN_1_TITL_4_STF_CNT__c'));
	                            }
	                            
	                        }
	                        sObject[] obj_Business = p_Contact.getSObjects('My_Businesses__r');
	                        if(obj_Business!=null){
	                            for(sObject l_Business : obj_Business)
	                            {
	                                i_CurrUsr_TotalPersonalSales = Integer.valueOf(l_Business.get('PRSNL_SLS_AMT__c'));
	                                s_CurrUsr_Title=m_LeaderTitles.get(String.valueOf(l_Business.get('LDRSHP_TITL_LVL_NR__c')));
	                                s_CurrUsr_Style=m_LeaderStyles.get(String.valueOf(l_Business.get('LDRSHP_TITL_LVL_NR__c')));
	                        	}
	                        }
               			}
               
	                    // Later Run only Option A
	                   	//mode = ApexPages.currentPage().getParameters().get('mode');
	                   	//if(mode == 'optionA'){
	                   		loadGoogleChart_OptA(s_User_Account_Number,s_mktID,s_Current_Selected_Campaign,m_LeaderTitles, this.market.ALM_Rep_Indicator__c);
	                   	//}
	                   	//else {
	                   	//	getGenealogy(s_User_Account_Number,s_mktID,s_Current_Selected_Campaign,m_LeaderTitles);
	                   	//}
 		           }
   		}
   		catch(Exception ex){
   			System.debug('Exception e-->'+ex.getMessage());
   		}	
   		
   }
    
 /*  global static String getGenealogy(String s_Account_Number, String s_Market, String s_Campaign ,Map<String,String> m_Leader_Titles) {
        try{
                
                System.debug(s_Account_Number+'---------'+s_Market+'------'+s_Campaign);
                
                String s_Construct_Org_Chart='';
                String s_Zone='';
                String s_Image=System.Label.OpenLinkImage;
                Map<String,String> m_Map = new Map<String,String>();
                Map<String,Contact> m_Contact_Details = new Map<String,Contact>();
                Map<String,sObject> m_PP_Details = new Map<String,sObject>();
                List<String> lst_Downline_Nodes = new List<String>();
                Map<String,String> m_Map_Details_Child = new Map<String,String>();
                Map<String,sObject>m_Map_Genealogy = new Map<String,sObject>();
                Set<String> s_Downline_Nodes = new Set<String>();
                Set<String> s_Downline_Nodes_Market_Key = new Set<String>();
                String s_Primary_Market_Key = s_Market+s_Account_Number;
                
                List<String> l_UplineIndex = new List<String>();
                List<String> l_UplineDownlineIndex = new List<String>();
               
                for(Integer i=0;i<=20;i++){
                    l_UplineIndex.add(s_Account_Number+String.valueOf(i));
                }
                    
                for(sObject l_Genealogy : Database.query('Select Id,ACCT_NR__c,UPLN_ACCT_NR__c,UPLN_GEN_INDX__c,Title_Level_Number__c From X'+s_Market+'_Genealogy__c Where CMPGN_NR__c='+'\''+s_Campaign+'\''+' and Title_Level_Number__c>=0 and UPLN_ACCT_GEN_INDX__c In :l_UplineIndex Order By UPLN_ACCT_GEN_INDX__c'))
                {
                    if(l_Genealogy!=null){
                        if(String.valueOf(l_Genealogy.get('UPLN_GEN_INDX__c'))=='1'){
                                m_Map.put(String.valueOf(l_Genealogy.get('ACCT_NR__c')),String.valueOf(l_Genealogy.get('UPLN_ACCT_NR__c')));                        
                            }
                            //if(String.valueOf(l_Genealogy.get('UPLN_GEN_INDX__c'))=='1' && String.valueOf(l_Genealogy.get('Title_Level_Number__c'))=='0'){
                                m_Map_Details_Child.put(String.valueOf(l_Genealogy.get('ACCT_NR__c')),String.valueOf(l_Genealogy.get('UPLN_ACCT_NR__c')));                        
                            //}
                            m_Map_Genealogy.put(String.valueOf(l_Genealogy.get('ACCT_NR__c')),l_Genealogy);
                            s_Downline_Nodes.add(String.valueOf(l_Genealogy.get('ACCT_NR__c')));
                            l_UplineDownlineIndex.add(String.valueOf(l_Genealogy.get('ACCT_NR__c'))+String.valueOf('1'));
                            s_Downline_Nodes_Market_Key.add(s_Market+String.valueOf(l_Genealogy.get('ACCT_NR__c')));
                    }
                }
               
                if(s_Downline_Nodes.size()>0)
                {
                    String s_UserAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
                    
                    
                    for(sObject l_Genealogy : Database.query('Select Id,ACCT_NR__c,UPLN_ACCT_NR__c,UPLN_GEN_INDX__c,Title_Level_Number__c From X'+s_Market+'_Genealogy__c Where CMPGN_NR__c='+'\''+s_Campaign+'\''+' and UPLN_GEN_INDX__c=1 and Title_Level_Number__c>=0  and UPLN_ACCT_GEN_INDX__c In : l_UplineDownlineIndex Order By UPLN_ACCT_GEN_INDX__c'))
                    {
                            if(l_Genealogy!=null){
                                m_Map_Details_Child.put(String.valueOf(l_Genealogy.get('ACCT_NR__c')),String.valueOf(l_Genealogy.get('UPLN_ACCT_NR__c')));                      
                                m_Map_Genealogy.put(String.valueOf(l_Genealogy.get('ACCT_NR__c')),l_Genealogy);
                                s_Downline_Nodes.add(String.valueOf(l_Genealogy.get('ACCT_NR__c')));
                                s_Downline_Nodes_Market_Key.add(s_Market+String.valueOf(l_Genealogy.get('ACCT_NR__c')));
                            }
                    }
                    
                    
                    
                    for(Contact obj_Contact : [Select Id ,Shortened_Name__c,SLS_Zone_CD__c,ACCT_NR__c,(Select Id,TITL_STUS__c,LDRSHP_TITL_LVL_CD__c,LDRSHP_TITL_LVL_NR__c,LDRSHP_TAR_IND__c,RSNG_STR_IND__c From My_Businesses__r Where FLD_SLS_CMPGN_NR__c=:Integer.valueOf(s_Campaign)) From Contact Where MRKT_ACCT_KEY__c In : s_Downline_Nodes_Market_Key ]){
                        m_Contact_Details.put(obj_Contact.ACCT_NR__c,obj_Contact);
                        sObject[] obj_Personal_Performance  = obj_Contact.getSObjects('My_Businesses__r');
                        if(obj_Personal_Performance!=null){
                            for(sObject l_Personal_Performance: obj_Personal_Performance)
                            m_PP_Details.put(obj_Contact.ACCT_NR__c,l_Personal_Performance);
                        }
                    }
                    
                    if(s_Downline_Nodes.size()>0){
                        
                        Set<String>  s_KeySet_Master = new Set<String>();
                        List<String> l_KeySet_Master = new List<String>();
                        
                        Set<String>  s_KeySet = m_Map_Details_Child.keySet();
                        List<String> l_KeySet = new List<String>();
                        
                        for(String l : s_KeySet){
                            l_KeySet.add(l);
                        }
                        
                        s_KeySet_Master = m_Map.keySet();
                        
                        for(String l : s_KeySet_Master){
                            l_KeySet.add(l);
                        }
                        l_KeySet.sort();
                        System.debug('L KeySet-->'+l_KeySet.size());
                        s_Construct_Org_Chart+='[{v:'+'\''+s_Account_Number+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" style="#FFFFFF" id="primary_node"><a style="cursor: pointer;" id="o_opener:'+s_Account_Number+':'+s_Campaign+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+s_Account_Number+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+s_Account_Number+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+s_Account_Number+'" style="align:left;"><a href="javascript:void(0);" id="'+s_Account_Number+'" onclick="f_ImpersonateUser(this.id)" class="node_href_LevelUp1">'+s_Account_Number+'</a></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+s_Account_Number+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+s_Account_Number+'" style="background:#FFFFFF"></p></div></div>'+'\''+'}'+','+'\''+s_Account_Number+'\''+','+'\''+'\''+'],';
                        for(Integer i=0;i<l_KeySet.size();i++){
                            System.debug('Account---->'+l_KeySet[i]);
                            if(m_Map_Details_Child.get(l_KeySet[i])!=null){
                                System.debug('In Here.....');
                                sObject s_Genealogy = m_Map_Genealogy.get(l_KeySet[i]);
                                sObject s_Title_Level_Status_Child = m_PP_Details.get(l_KeySet[i]);
                                String s_Level = String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TITL_LVL_NR__c')) : '';
                                String s_Level_Title = m_Leader_Titles.get(s_Level);//String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TITL_LVL_CD__c'));//String.valueOf(s_Genealogy.get('Title_Level_Number__c')) !=null ? String.valueOf(s_Genealogy.get('Title_Level_Number__c')) : '';
                                String s_Level_Color = s_Level =='0' ? '79d3ff' : 'ec008c';
                                String s_Title_Level_Child ='';
                                 if(String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TAR_IND__c'))=='Y' || String.valueOf(s_Title_Level_Status_Child.get('RSNG_STR_IND__c'))=='Y'){
                                        s_Title_Level_Child = String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TAR_IND__c'))=='Y' ? 'At Risk' : 'Rising Star';
                                    } 
                                //String s_Title_Level_Child = String.valueOf(s_Title_Level_Status_Child.get('TITL_STUS__c'))!=null ? String.valueOf(s_Title_Level_Status_Child.get('TITL_STUS__c')) :''; 
                                String s_Title_Color_Child = s_Title_Level_Child =='Rising Star' ? '#339933' :'#ff0000'; 
                                String s_Genealogy_Level_Child = String.valueOf(s_Genealogy.get('UPLN_GEN_INDX__c')) !=null ? String.valueOf(s_Genealogy.get('UPLN_GEN_INDX__c')) : '';
                                String s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child =='Rising Star' ? 'node_p_container_3_Titl_RS':'node_p_container_3_Titl') : 'node_p_container_3';
                               
                                //for Candidates at Level 1 
                                if(s_Genealogy_Level_Child=='1' && String.valueOf(s_Genealogy.get('UPLN_ACCT_NR__c'))==s_Account_Number){
                                    //s_Class_Style= s_Title_Level_Child!='' ? 'node_p_container_2_Titl':'node_p_container_2';
                                    s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child =='Rising Star' ? 'node_p_container_2_Titl_RS':'node_p_container_2_Titl') : 'node_p_container_2';
                                    s_Construct_Org_Chart+='[{v:'+'\''+l_KeySet[i]+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+l_KeySet[i]+'"><a id="o_opener:'+l_KeySet[i]+':'+s_Campaign+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+l_KeySet[i]+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+l_KeySet[i]+'"><p id="node_p_container_1_'+l_KeySet[i]+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+l_KeySet[i]+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+m_Contact_Details.get(l_KeySet[i]).Shortened_Name__c+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+l_KeySet[i]+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+m_Contact_Details.get(l_KeySet[i]).SLS_ZONE_CD__c+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+l_KeySet[i]+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+l_KeySet[i]+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+m_Map_Details_Child.get(l_KeySet[i])+'\''+','+'\''+'\''+'],';
                                    i_Level_One_Node_Count++;
                                    i_Node_Count++;
                                }
                                else{
                                    s_Construct_Org_Chart+='[{v:'+'\''+l_KeySet[i]+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+l_KeySet[i]+'"><a style="cursor: pointer;" id="o_opener:'+l_KeySet[i]+':'+s_Campaign+':'+s_Level_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+l_KeySet[i]+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+l_KeySet[i]+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+l_KeySet[i]+'" style="align:left;"><label id="'+l_KeySet[i]+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.0em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+m_Contact_Details.get(l_KeySet[i]).Shortened_Name__c+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_3_'+l_KeySet[i]+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+m_Contact_Details.get(l_KeySet[i]).SLS_ZONE_CD__c+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+l_KeySet[i]+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+l_KeySet[i]+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+m_Map_Details_Child.get(l_KeySet[i])+'\''+','+'\''+'\''+'],';
                                    i_Node_Count++;
                                }
                                
                                if(m_Map.get(m_Map_Details_Child.get(l_KeySet[i]))!=null){
                                    sObject s_Genealogy_Parent = m_Map_Genealogy.get(m_Map_Details_Child.get(l_KeySet[i]));
                                    sObject s_Title_Level_Status = m_PP_Details.get(m_Map_Details_Child.get(l_KeySet[i]));
                                    String s_Title_Level ='';
                                    if(String.valueOf(s_Title_Level_Status.get('LDRSHP_TAR_IND__c'))=='Y' || String.valueOf(s_Title_Level_Status.get('RSNG_STR_IND__c'))=='Y'){
                                        s_Title_Level = String.valueOf(s_Title_Level_Status.get('LDRSHP_TAR_IND__c'))=='Y' ? 'At Risk' : 'Rising Star';
                                    }
                                    //String s_Title_Level = String.valueOf(s_Title_Level_Status.get('TITL_STUS__c'))!=null ? String.valueOf(s_Title_Level_Status.get('TITL_STUS__c')) :'';   
                                    String s_Level_Parent =String.valueOf(s_Title_Level_Status.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(s_Title_Level_Status.get('LDRSHP_TITL_LVL_NR__c')) : '';
                                    String s_Level_Parent_Title = m_Leader_Titles.get(s_Level_Parent);//String.valueOf(s_Title_Level_Status.get('LDRSHP_TITL_LVL_CD__c'));
                                    String s_Genealogy_Level = String.valueOf(s_Genealogy_Parent.get('UPLN_GEN_INDX__c')) !=null ? String.valueOf(s_Genealogy_Parent.get('UPLN_GEN_INDX__c')) : '';
                                    String s_Title_Color = s_Title_Level =='Rising Star' ? '#339933' :'#ff0000'; 
                                    String s_Level_Color_Parent = s_Level_Parent =='0' ? '79d3ff' : 'ec008c';
                                    String s_Class_Style_Parent= s_Title_Level!='' ? (s_Title_Level =='Rising Star' ? 'node_p_container_2_Titl_RS':'node_p_container_2_Titl') : 'node_p_container_2';
                                    
                                    
                                    if(s_Genealogy_Level=='1'){
                                        s_Construct_Org_Chart+='[{v:'+'\''+m_Map_Details_Child.get(l_KeySet[i])+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+m_Map_Details_Child.get(l_KeySet[i])+'"><a id="o_opener:'+m_Map_Details_Child.get(l_KeySet[i])+':'+s_Campaign+':'+s_Level_Parent_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+m_Map_Details_Child.get(l_KeySet[i])+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+m_Map_Details_Child.get(l_KeySet[i])+'"><p id="node_p_container_1_'+m_Map_Details_Child.get(l_KeySet[i])+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+m_Map_Details_Child.get(l_KeySet[i])+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+m_Contact_Details.get(m_Map_Details_Child.get(l_KeySet[i])).Shortened_Name__c+'</label></p><p class="'+s_Class_Style_Parent+'" id="node_p_container_2_'+m_Map_Details_Child.get(l_KeySet[i])+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+m_Contact_Details.get(m_Map_Details_Child.get(l_KeySet[i])).SLS_ZONE_CD__c+'</span><span style="font-style:italic;color:'+s_Title_Color+'">'+' '+s_Title_Level+'</span></p></div><div class="node_div_3" id="node_div_3_'+m_Map_Details_Child.get(l_KeySet[i])+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+m_Map_Details_Child.get(l_KeySet[i])+'" style="background:#'+s_Level_Color_Parent+';">'+s_Level_Parent_Title+'</p></div></div>'+'\''+'}'+','+'\''+m_Map.get(m_Map_Details_Child.get(l_KeySet[i]))+'\''+','+'\''+'\''+'],';
                                        i_Level_One_Node_Count++;
                                        i_Node_Count++;
                                    }
                                    else{
                                        s_Construct_Org_Chart+='[{v:'+'\''+m_Map_Details_Child.get(l_KeySet[i])+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+m_Map_Details_Child.get(l_KeySet[i])+'"><a style="cursor: pointer;" id="o_opener:'+m_Map_Details_Child.get(l_KeySet[i])+':'+s_Campaign+':'+s_Level_Parent_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+m_Map_Details_Child.get(l_KeySet[i])+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+m_Map_Details_Child.get(l_KeySet[i])+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+m_Map_Details_Child.get(l_KeySet[i])+'" style="align:left;"><label id="'+m_Map_Details_Child.get(l_KeySet[i])+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+m_Contact_Details.get(m_Map_Details_Child.get(l_KeySet[i])).Shortened_Name__c+'</label></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+m_Map_Details_Child.get(l_KeySet[i])+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+m_Map_Details_Child.get(l_KeySet[i])+'" style="background:#'+s_Level_Color_Parent+';">'+s_Level_Parent_Title+'</p></div></div>'+'\''+'}'+','+'\''+m_Map_Details_Child.get(m_Map_Details_Child.get(l_KeySet[i]))+'\''+','+'\''+'\''+'],';
                                        i_Node_Count++;
                                    }   
                                }
                            }
                        }
                        //System.debug('Node Count-->'+i_Node_Count);
                    }   
                        s_Google_Chart = s_Construct_Org_Chart.substring(0,(s_Construct_Org_Chart.length())-1);
                        
                }
                
                return s_Google_Chart;
        }
        catch(Exception e){
            System.debug('Exception e-->'+e.getMessage());
            return null;
        }
          
    }*/
    /*
     global static void loadGoogleChart_OptB(String s_Account_Number, String s_Market, String s_Campaign ,Map<String,String> m_Leader_Titles, String marketIndicator){
    	String s_Construct_Org_Chart='';
        String s_Zone='';
        String s_Image=System.Label.OpenLinkImage;
        Map<String,String> m_Map_Details_Child = new Map<String,String>();
        Map<String,sObject>m_Map_Genealogy = new Map<String,sObject>();
        String s_Primary_Market_Key = s_Market+s_Account_Number;
        
        Map<String, String> keyToAccNumber = new Map<String, String>();
        
        String leaderQuery = 'select Id, ROOT_UPLN_ACCT_NR__c, Genealogy_Level__c, Genealogy_Key__c from '+marketIndicator +' where ACCT_NR__c=:s_Account_Number and OPERTNL_CMPGN_NR__c =:s_Campaign and MRKT_KEY__r.Market_Id__c =: s_Market limit 1';
        
        List<SObject> leaderData = Database.query(leaderQuery);
        
        if(leaderData.size() == 1){
        
        	String leaderTreeAccNo = (leaderData[0].Genealogy_Level__c == 0 ? s_Account_Number : leaderData[0].ROOT_UPLN_ACCT_NR__c);
        	
        	String query = 'Select Id, MRKT_ACCT_KEY__r.Shortened_Name__c, MRKT_ACCT_KEY__r.SLS_ZONE_CD__c, ACCT_NR__c, UPLN_ACCT_NR__c, Genealogy_Level__c , Genealogy_Key__c, TITL_STUS__c,LDRSHP_TITL_LVL_CD__c,LDRSHP_TITL_LVL_NR__c from ALM_Rep_Performance__c Where OPERTNL_CMPGN_NR__c='+'\''+s_Campaign+'\''+' and Genealogy_Key__c like '+'\''+leaderData[0].Genealogy_Key__c+'%\''+' and Genealogy_Level__c >=1 and Genealogy_Level__c <= 1 and ROOT_UPLN_ACCT_NR__c = \'' + leaderTreeAccNo + '\' Order By Genealogy_Level__c, Genealogy_Key__c';
	        system.debug(query);
	        
	        for(sObject l_Genealogy : Database.query(query)){
	        	
	        	String key = String.valueOf(l_Genealogy.get('Genealogy_Key__c'));
	        	String thisAccNumber = String.valueOf(l_Genealogy.get('ACCT_NR__c'));
	        	m_Map_Genealogy.put(thisAccNumber,l_Genealogy);
	        	system.debug(l_Genealogy);
	        	keyToAccNumber.put(key, thisAccNumber);
	        	
	        	if(String.valueOf(l_Genealogy.get('Genealogy_Level__c'))=='1'){
	        		m_Map_Details_Child.put(thisAccNumber,String.valueOf(l_Genealogy.get('UPLN_ACCT_NR__c'))); 
	        	}
	        	else {
	        		
	        		// Parent Key 
	        		String immKey = key.substringBeforeLast('|');
	        		String parentKey = immKey.substring(0, immKey.lastIndexOf('|')+1);
	        		//system.debug(parentKey);
	        		if(keyToAccNumber.containsKey(parentKey)){
	        			m_Map_Details_Child.put(thisAccNumber,keyToAccNumber.get(parentKey));
	        		}
	        		//system.debug(keyToAccNumber.containsKey(parentKey));
	        		
	        	}
	        	
	        	m_Map_Genealogy.put(thisAccNumber,l_Genealogy);
	        	//s_Downline_Nodes_Market_Key.add(s_Market+thisAccNumber);
	        	
	        }
	        
	        s_Construct_Org_Chart+='[{v:'+'\''+s_Account_Number+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" style="#FFFFFF" id="primary_node"><a style="cursor: pointer;" id="o_opener:'+s_Account_Number+':'+s_Campaign+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+s_Account_Number+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+s_Account_Number+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+s_Account_Number+'" style="align:left;"><a href="javascript:void(0);" id="'+s_Account_Number+'" onclick="f_ImpersonateUser(this.id)" class="node_href_LevelUp1">'+s_Account_Number+'</a></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+s_Account_Number+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+s_Account_Number+'" style="background:#FFFFFF"></p></div></div>'+'\''+'}'+','+'\''+s_Account_Number+'\''+','+'\''+'\''+'],';
	        system.debug(s_Construct_Org_Chart);   
	        
	        for(String key : m_Map_Details_Child.keySet()){
	        	
	        	sObject s_Genealogy = m_Map_Genealogy.get(key);
	            //sObject s_Title_Level_Status_Child = s_Genealogy.get('');
	            String s_Level = String.valueOf(s_Genealogy.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(s_Genealogy.get('LDRSHP_TITL_LVL_NR__c')) : '';
	            String s_Level_Title = m_Leader_Titles.get(s_Level);//String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TITL_LVL_CD__c'));//String.valueOf(s_Genealogy.get('Title_Level_Number__c')) !=null ? String.valueOf(s_Genealogy.get('Title_Level_Number__c')) : '';
	            String s_Level_Color = s_Level =='0' ? '79d3ff' : 'ec008c';
	            String s_Title_Level_Child = String.valueOf(s_Genealogy.get('TITL_STUS__c'))!=null ? String.valueOf(s_Genealogy.get('TITL_STUS__c')) :''; 
	            String s_Title_Color_Child = s_Title_Level_Child =='Rising Star' ? '#339933' :'#ff0000'; 
	            
	            String s_Genealogy_Level_Child = String.valueOf(s_Genealogy.get('Genealogy_Level__c')) !=null ? String.valueOf(s_Genealogy.get('Genealogy_Level__c')) : '';
	            String s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child =='Rising Star' ? 'node_p_container_3_Titl_RS':'node_p_container_3_Titl') : 'node_p_container_3';
	           
	            //for Candidates at Level 1
	
	            sObject contact = s_Genealogy.getSObject('MRKT_ACCT_KEY__r');
	             
	            if(s_Genealogy_Level_Child=='1' && String.valueOf(s_Genealogy.get('UPLN_ACCT_NR__c'))==s_Account_Number){
	                //s_Class_Style= s_Title_Level_Child!='' ? 'node_p_container_2_Titl':'node_p_container_2';
	                s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child =='Rising Star' ? 'node_p_container_2_Titl_RS':'node_p_container_2_Titl') : 'node_p_container_2';
	                s_Construct_Org_Chart+='[{v:'+'\''+key+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+key+'"><a id="o_opener:'+key+':'+s_Campaign+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+key+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+key+'"><p id="node_p_container_1_'+key+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+key+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+contact.get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+key+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+contact.get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+key+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+key+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+m_Map_Details_Child.get(key)+'\''+','+'\''+'\''+'],';
	                i_Level_One_Node_Count++;
	                i_Node_Count++;
	            }
	            else{
	                s_Construct_Org_Chart+='[{v:'+'\''+key+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+key+'"><a style="cursor: pointer;" id="o_opener:'+key+':'+s_Campaign+':'+s_Level_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+key+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+key+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+key+'" style="align:left;"><label id="'+key+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.0em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+contact.get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_3_'+key+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+contact.get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+key+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+key+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+m_Map_Details_Child.get(key)+'\''+','+'\''+'\''+'],';
	                i_Node_Count++;
	            }
	                                
	        	
	        }
	        
	       
	        s_Google_Chart = s_Construct_Org_Chart.substring(0,(s_Construct_Org_Chart.length())-1);   
	        system.debug(LoggingLevel.Error,'::::Org Chart optionB::::' + s_Google_Chart);           
    	}
               
    }
    */
    global static void loadGoogleChart_OptA(String s_Account_Number, String s_Market, String s_Campaign ,Map<String,String> m_Leader_Titles, String marketIndicator){
    	String s_Construct_Org_Chart='';
        String s_Zone='';
        String s_Image=System.Label.OpenLinkImage;
        
        //string to store the parent account number
        String previousAccountNumber='';
        String parentAccountNumber='';
        String s_Primary_Market_Key = s_Market+s_Account_Number;
        Integer s_Genealogy_Level_Child=0;
        Integer previousGenealogyLevel=0;
        
        List<String> parentAccountNumbers=new List<String>();
        
        // Find the Genealogy Key of the Leader
        System.debug(LoggingLevel.Error,'::::s_Account_Number::::' + s_Account_Number);
        System.debug(LoggingLevel.Error,'::::s_Campaign::::' + s_Campaign);
        System.debug(LoggingLevel.Error,'::::s_Market::::' + s_Market);
       
       
        String leaderQuery = 'select Id, ROOT_UPLN_ACCT_NR__c, Genealogy_Level__c, Genealogy_Key__c from '+marketIndicator +' where ACCT_NR__c=:s_Account_Number and OPERTNL_CMPGN_NR__c =:s_Campaign and MRKT_KEY__r.Market_Id__c =: s_Market limit 1';
        
        List<SObject> leaderData = Database.query(leaderQuery);
         
        System.debug(LoggingLevel.Error,'::::Leader Data::::' + leaderData);
        
        if(leaderData.size() == 1){
        	system.debug('::::::::: Integer.valueOf(leaderData[0].get.Genealogy_Level__c ::::::::::' +Integer.valueOf(leaderData[0].get('Genealogy_Level__c')));
        	String leaderTreeAccNo = (Integer.valueOf(leaderData[0].get('Genealogy_Level__c')) == 0 ? s_Account_Number : String.valueOf(leaderData[0].get('ROOT_UPLN_ACCT_NR__c')));
        	
        	//system.debug(LoggingLevel.Error, ':::::::::s_Campaign::::::::::' + s_Campaign);
        	String query = 'Select Id, MRKT_ACCT_KEY__r.Shortened_Name__c, LFT_ND_ID__c,RGT_ND_ID__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c, ACCT_NR__c, UPLN_ACCT_NR__c, Genealogy_Level__c , Genealogy_Key__c, TITL_STUS__c,LDRSHP_TITL_LVL_CD__c,LDRSHP_TITL_LVL_NR__c from '+marketIndicator+' Where OPERTNL_CMPGN_NR__c='+'\''+s_Campaign+'\''+' and LFT_ND_ID__c > '+Integer.valueOf(leaderData[0].get('LFT_ND_ID__c')) + ' and RGT_ND_ID__c < ' + Integer.valueOf(leaderData[0].get('RGT_ND_ID__c')) +' and ROOT_UPLN_ACCT_NR__c = \'' + leaderTreeAccNo + '\' and Genealogy_Level__c >=1 and Genealogy_Level__c <=5 and RGT_ND_ID__c!=null and LFT_ND_ID__c!=null Order By LFT_ND_ID__c, Genealogy_Level__c LIMIT 200 ';
	        system.debug(':::::::::query::::::::::' +query);
	        
	        s_Construct_Org_Chart+='[{v:'+'\''+s_Account_Number+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" style="#FFFFFF" id="primary_node"><a style="cursor: pointer;" id="o_opener:'+s_Account_Number+':'+s_Campaign+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+s_Account_Number+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+s_Account_Number+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+s_Account_Number+'" style="align:left;"><a href="javascript:void(0);" id="'+s_Account_Number+'" onclick="f_ImpersonateUser(this.id)" class="node_href_LevelUp1">'+s_Account_Number+'</a></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+s_Account_Number+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+s_Account_Number+'" style="background:#FFFFFF"></p></div></div>'+'\''+'}'+','+'\''+s_Account_Number+'\''+','+'\''+'\''+'],';
	       
	        
	        for(sObject l_Genealogy : Database.query(query)){
	        	System.debug('inside for loop');
	        	//String key = String.valueOf(l_Genealogy.get('Genealogy_Key__c'));
	        	String thisAccNumber = String.valueOf(l_Genealogy.get('LFT_ND_ID__c'));
	        	 
	        	  //sObject s_Title_Level_Status_Child = s_Genealogy.get('');
	            String s_Level = String.valueOf(l_Genealogy.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(l_Genealogy.get('LDRSHP_TITL_LVL_NR__c')) : '';
	            String s_Level_Title = m_Leader_Titles.get(s_Level);//String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TITL_LVL_CD__c'));//String.valueOf(s_Genealogy.get('Title_Level_Number__c')) !=null ? String.valueOf(s_Genealogy.get('Title_Level_Number__c')) : '';
	            String s_Level_Color = s_Level =='0' ? '79d3ff' : 'ec008c';
	            String s_Title_Level_Child = String.valueOf(l_Genealogy.get('TITL_STUS__c'))!=null ? String.valueOf(l_Genealogy.get('TITL_STUS__c')) :''; 
	            String s_Title_Color_Child = s_Title_Level_Child =='Rising Star' ? '#339933' :'#ff0000'; 
	            
	            s_Genealogy_Level_Child = Integer.valueOf(l_Genealogy.get('Genealogy_Level__c')) !=null ? Integer.valueOf(l_Genealogy.get('Genealogy_Level__c')) : -1;
	            String s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child =='Rising Star' ? 'node_p_container_3_Titl_RS':'node_p_container_3_Titl') : 'node_p_container_3';
	           
	           Integer genealogyLevelDifference=s_Genealogy_Level_Child-previousGenealogyLevel;
	           Integer absoluteValue=Math.abs(genealogyLevelDifference);
	           
	         //  System.debug(LoggingLevel.Error,'===genealogyLevelDifference:::' + genealogyLevelDifference + '===s_Genealogy_Level_Child:::' + s_Genealogy_Level_Child+ '======previousGenealogyLevel:::' + previousGenealogyLevel);
	           
	         //  System.debug(LoggingLevel.Error,'===parentAccountNumbers===' + parentAccountNumbers );
	           
	            //if the current level is greater than the previous level, the last node read is the parent
             	if(genealogyLevelDifference>0){
            		parentAccountNumber=previousAccountNumber;
            	}
	           else{
	           	 
	           	 for(;absoluteValue>=0;absoluteValue--){
	              	parentAccountNumbers.remove(parentAccountNumbers.size()-1);
	           	 }
	           	 
	           	 if(parentAccountNumbers.size()>0){
	           	   parentAccountNumber=parentAccountNumbers.get(parentAccountNumbers.size()-1);	
	           	 }
	           	 else{
	           	 	parentAccountNumber=s_Account_Number;
	           	 }
	           	 
	           	  
	           } 
	           
	           //parentAccountNumber=s_Account_Number;
	            // System.debug(LoggingLevel.Error,'===thisAccNumber===' + thisAccNumber + '===parentAccountNumber===' + parentAccountNumber);
	        	
	           
	            sObject contact = l_Genealogy.getSObject('MRKT_ACCT_KEY__r');
	            
	        	 //for Candidates at Level 1
	            if(s_Genealogy_Level_Child==1){
	                s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child =='Rising Star' ? 'node_p_container_2_Titl_RS':'node_p_container_2_Titl') : 'node_p_container_2';
	                s_Construct_Org_Chart+='[{v:'+'\''+thisAccNumber+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+thisAccNumber+'"><a id="o_opener:'+thisAccNumber+':'+s_Campaign+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+thisAccNumber+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+thisAccNumber+'"><p id="node_p_container_1_'+thisAccNumber+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+thisAccNumber+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+contact.get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+thisAccNumber+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+contact.get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+thisAccNumber+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+thisAccNumber+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+s_Account_Number+'\''+','+'\''+'\''+'],';
	             }
	            else{
	                s_Construct_Org_Chart+='[{v:'+'\''+thisAccNumber+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+thisAccNumber+'"><a style="cursor: pointer;" id="o_opener:'+thisAccNumber+':'+s_Campaign+':'+s_Level_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+thisAccNumber+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+thisAccNumber+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+thisAccNumber+'" style="align:left;"><label id="'+thisAccNumber+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.0em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+contact.get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_3_'+thisAccNumber+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+contact.get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+thisAccNumber+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+thisAccNumber+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+parentAccountNumber+'\''+','+'\''+'\''+'],';
	            }
	            
	            parentAccountNumbers.add(thisAccNumber);
	            previousAccountNumber=thisAccNumber;
	            previousGenealogyLevel=s_Genealogy_Level_Child;
	        
	        }
	        
	        
	        
	        
	        s_Google_Chart = s_Construct_Org_Chart.substring(0,(s_Construct_Org_Chart.length())-1);    
	        system.debug(LoggingLevel.Error,'::::Org Chart::::' + s_Google_Chart);   
	             
    	}
               
    }
    
    @RemoteAction
    global static List<Contact> s_GetDetails(String s_Market_Account_Key,String s_Campaign){
        System.debug('Account Number-->'+s_Market_Account_Key);
        System.debug('Campaign Number-->'+s_Campaign);
        
        List<Contact> l_Contact = new List<Contact>();
        for(Contact obj_Contact : [Select Id,ACCT_NR__c,Shortened_Name__c,Name,SLS_ZONE_CD__c,(Select Id,GRP_SUBMTD_AWRD_SLS_AMT__c,GRP_BLCKD_UNIT_SLS_AMT__c,GENTRTN_1_ACTV_REP_CNT__c,TTL_LEG_CNT__c,GRP_INVCD_BLCKD_SLS_AMT__c,GRP_INVC_AWRD_SLS_AMT__c,GENRTN_1_TITL_1_STF_CNT__c,GENRTN_1_TITL_2_STF_CNT__c,GENRTN_1_TITL_3_STF_CNT__c,GENRTN_1_TITL_4_STF_CNT__c From Leadership_Summary__r Where FLD_SLS_CMPGN_NR__c=:Integer.valueOf(s_Campaign)),(Select Id, PRSNL_SLS_AMT__c,SUBMTD_AWRD_SLS_AMT__c,LDRSHP_TITL_LVL_NR__c,TITL_STUS__c,LDRSHP_TITL_LVL_CD__c,LDRSHP_TAR_IND__c,RSNG_STR_IND__c From My_Businesses__r Where FLD_SLS_CMPGN_NR__c=:Integer.valueOf(s_Campaign)) From Contact Where MRKT_ACCT_KEY__c=:s_Market_Account_Key]){
            l_Contact.add(obj_Contact);
        }
         return l_Contact;
    }
    
    @RemoteAction
    global static List<SObject> s_GetDetailsOption(String s_Market_Account_Key,String s_Campaign, String marketIndicator){
        
        
        System.debug('Account Number-->'+s_Market_Account_Key);
        System.debug('Campaign Number-->'+s_Campaign);
        
        List<SObject> l_DataRec = new List<SObject>();
        String query = 'Select Id, MRKT_ACCT_KEY__r.Shortened_Name__c, ACCT_NR__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,GRP_SUBMTD_AWRD_SLS_AMT__c,GRP_BLCKD_UNIT_SLS_AMT__c,GENTRTN_1_ACTV_REP_CNT__c,TTL_LEG_CNT__c,GRP_INVCD_BLCKD_SLS_AMT__c,GRP_INVC_AWRD_SLS_AMT__c,GENRTN_1_TITL_1_STF_CNT__c,GENRTN_1_TITL_2_STF_CNT__c,GENRTN_1_TITL_3_STF_CNT__c,GENRTN_1_TITL_4_STF_CNT__c , PRSNL_SLS_AMT__c,SUBMTD_AWRD_SLS_AMT__c,LDRSHP_TITL_LVL_NR__c,TITL_STUS__c,LDRSHP_TITL_LVL_CD__c From '+marketIndicator+' Where OPERTNL_CMPGN_NR__c=:s_Campaign and  MRKT_ACCT_KEY__r.MRKT_ACCT_KEY__c =:s_Market_Account_Key';
        for(SObject obj_Data : Database.query(query)){
            l_DataRec.add(obj_Data);
        }
        return l_DataRec;
    }
    
    public PageReference filterReport(){
        PageReference pageref = Page.My_Sales_Leaders_Genealogy;
        pageRef.getParameters().put('reportid', ApexPages.currentPage().getParameters().get('reportid'));
        pageRef.getParameters().put('Campaign',this.s_Current_Selected_Campaign);
        //pageRef.getParameters().put('LOA',this.loaFselect);
        if(ApexPages.currentPage().getParameters().get('acctkey')!=null){
            pageRef.getParameters().put('acctkey',ApexPages.currentPage().getParameters().get('acctkey'));
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    //For Coaching Page Invocation - Start
    public PageReference callRepDetails() {
        //repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
    }// End of method
    
    public PageReference reportRedirect(){
    	String isImpersonatedAccount = ApexPages.currentPage().getParameters().get('acctkey');
    	system.debug(isImpersonatedAccount);
    	system.debug(repDetailAcctNbr);
    	if(isImpersonatedAccount != null && isImpersonatedAccount != ''){
    		if(repDetailAcctNbr != 'CR'){
    			return new PageReference(repDetailAcctNbr+'&acctKey='+isImpersonatedAccount);
    		}
    	}
    	else{
    		return new PageReference(repDetailAcctNbr);
    	}
    	return null;
    }
    
    public String getOmniturePageName() {
        return ALMPlusUtils.generateOmniturePageName('Leadership Genealogy Report', null, currUsr.Profile.Name);
    }
    
    
    public List<SelectOption> getReportTypesOptions(){
    	List<SelectOption> reportTypes = new List<SelectOption>();
    	
    	reportTypes.add(new SelectOption('other',  System.Label.Other_Reports));
    	system.debug('\n @@@@ s_IsImpersonated -->> '+s_IsImpersonated);
    	if(s_IsImpersonated){
    		reportTypes.add(new SelectOption('/apex/YouHome?pgId=1',  System.Label.ALM_Home));
    		reportTypes.add(new SelectOption('CR',  System.Label.Coaching_Record));
    	}
    	
    	for(Report_Config__c conf : lst_ReportLinks){
    		if(conf.Report_Type__c != System.Label.My_Sales_Leaders_Genealogy){
    			String val = (conf.Report_URL__c != null)? conf.Report_URL__c : '/apex/YouHome?pgId=1';
    			reportTypes.add(new SelectOption(val ,  conf.Report_Type__c));
    		}
    	}
    	return reportTypes;
    	
    }
   
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*@isTest(SeeAllData=true)
     public static  void testLeadersGenealogyReport()
    {
        
       
        TestDataHelper testData =   new TestDataHelper();
        String s_MarketId='DE';
        String mktIdKey = 'XX';
        
        //Creating Market
        //Market__c mrkt = testData.createMarket(s_MarketId);
        Market__c mrkt = testData.createMarket(mktIdKey);
        mrkt.Allow_Freeform_Email__c = 'Avon Leader; Avon Division Manager';
        mrkt.Genealogy_Report_Configurable__c='Id,ACCT_NR__c,Contact_Key__r.Shortened_Name__c,CMPGN_NR__c,Contact_Key__c,Contact_Key__r.Name,Contact_Key__r.SLS_ZONE_CD__c,EXEC_GEN_CNT__c,EXEC_GEN_INDX__c,EXEC_RSNG_STR_IND__c,Leadership_Summary_Key__c,Market_ID__c,Personal_Performance_Key__c,RSNG_STR_IND__c,UPLN_GEN_INDX__c,UPLN_ACCT_NR__c,SUBMTD_AWRD_SLS_AMT__c,GRP_SUBMTD_AWRD_SLS_AMT__c,GRP_BLCKD_UNIT_SLS_AMT__c,GENTRTN_1_ACTV_REP_CNT__c,TTL_LEG_CNT__c,GENRTN_1_TITL_1_STF_CNT__c,GENRTN_1_TITL_2_STF_CNT__c,GENRTN_1_TITL_3_STF_CNT__c,GENRTN_1_TITL_4_STF_CNT__c,LDRSHP_TITL_LVL_NR__c';
        update  mrkt;
    
        //Create Leader User
        User ldrUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            ldrUsr = testData.createLeaderUser(mktIdKey);
            ldrUsr.MRKT_ID__c = mrkt.Market_Id__c;
            ldrUsr.IsActive = true;
            update ldrUsr;
        }
        
        List<Leader_Title__c> ldrTitle= testData.createLeaderTitles();
       
        
        Map<String,String> m_Titles = new Map<String,String>();
        Map<String,String> m_LeaderStyles = new Map<String,String>();
        List<Genealogy_Leader_Level__c> obj_LeaderTitleLevel = new List<Genealogy_Leader_Level__c>();
        
        for(Integer i=0;i<ldrTitle.size();i++)
        {
            ldrTitle[i].LANG_CD__c = ldrUsr.LanguageLocaleKey;
        }
        
        update ldrTitle;
        
        for(Leader_Title__c obj_Title: ldrTitle){
            m_Titles.put(obj_Title.LDRSHP_TITL_LVL_NR__c,obj_Title.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
            Genealogy_Leader_Level__c obj_Level = new Genealogy_Leader_Level__c();
            obj_Level.LDRSHP_TITL_LVL_NR__c=obj_Title.LDRSHP_TITL_LVL_NR__c;
            obj_Level.Color__c='#FFFFFF';
            obj_Level.MRKT_ID__c=mrkt.Market_Id__c;
            obj_Level.Name=mrkt.Market_Id__c+'-'+obj_Title.LDRSHP_TITL_LVL_NR__c;
           
            m_LeaderStyles.put(obj_Level.LDRSHP_TITL_LVL_NR__c,'#FFFFFF');
            
             obj_LeaderTitleLevel.add(obj_Level);
        } 
        
        insert obj_LeaderTitleLevel;
        update ldrTitle;
       
        //Creating Calendar
        Calendar__c c1 = new Calendar__c(CMPGN_NR__c=201203.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2012, Market__c=mrkt.Id, Name='TestCal1');
        insert c1;
        Calendar__c c2 = new Calendar__c(CMPGN_NR__c=201202.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2012, Market__c=mrkt.Id, Name='TestCal2');
        insert c2;
        Calendar__c c3 = new Calendar__c(CMPGN_NR__c=201201.00, MRKT_ID__c= mrkt.Market_Id__c, 
                                         YEAR_NR__c=2012, Market__c=mrkt.Id, Name='TestCal3');
        insert c3;
    
        //Creating Account and Contact Information
        
        
        Account testAcct = new Account(Name='Test Acount');
        insert testAcct;
        
        List<Contact> lstContact = new List<Contact>();
        Contact con1    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey,
                                            Email='test1@avon.com',FirstName=mktIdKey+'First1',LastName=mktIdKey+'Last1',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey, MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con1); 
        
        Contact con2    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c=mktIdKey+'01',
                                            Email='test2@avon.com',FirstName=mktIdKey+'First2',LastName=mktIdKey+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'01', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con2);
        
         Contact con3    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c='XX'+'02',
                                            Email='test2@avon.com',FirstName=mktIdKey+'First2',LastName=mktIdKey+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'02', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con3);
        
        Contact con4    = new Contact(  AccountId=testAcct.Id, ACCT_NR__c='XX'+'03',
                                            Email='test2@avon.com',FirstName=mktIdKey+'First2',LastName=mktIdKey+'Last2',HomePhone='9999999999',
                                            LDRSHP_PRGRM_IND__c='Y',LDRSHP_RPT_SLS_ZONE_CD__c='XZ1',
                                            MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey+'03', MRKT_ID__c=mrkt.Market_Id__c,
                                            PATD_CERTFCTN_LVL_A_IND__c='Y',PATD_CERTFCTN_LVL_D_IND__c='Y',
                                            PATD_CERTFCTN_LVL_P_IND__c='Y',PATD_CERTFCTN_LVL_T_IND__c='Y',
                                            REP_ADDR_STR_2_TXT__c='Address 2',REP_ADDR_STR_3_TXT__c='Address 3',
                                            REP_ADDR_STR_4_TXT__c='Address 4',REP_APPT_DT__c=System.today(),
                                            REP_LANG_CD__c='en_US',SLS_ZONE_CD__c='XZ1',REP_MOBILE_PHON_NR__c = '1234546789',
                                            OwnerId=ldrUsr.Id
                                          );
        
        lstContact.add(con4);
        
        insert lstContact; 
        
        //Creating Leadership Summary
        List<Leader_Downline_Summary__c> lstLdrDwln = new List<Leader_Downline_Summary__c>();   
        Leader_Downline_Summary__c rec1 = new Leader_Downline_Summary__c(
                                                Leadership_Summary_Key__c = lstContact[0].ACCT_NR__c,           //lstContact[0].ACCT_NR__c
                                                CurrencyISOCode='USD',
                                                //OwnerId=ldrUsr.Id,
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c=200,
                                                GENTRTN_1_ACTV_REP_CNT__c=2,
                                                TTL_LEG_CNT__c=2,
                                                GENRTN_1_TITL_1_STF_CNT__c=1,
                                                GENRTN_1_TITL_2_STF_CNT__c=2,
                                                GENRTN_1_TITL_3_STF_CNT__c=3,
                                                GENRTN_1_TITL_4_STF_CNT__c=4,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c, 
                                                ACCT_NR__c = String.valueOf(lstContact[0].ACCT_NR__c));  //lstContact[0].ACCT_NR__c
        lstLdrDwln.add(rec1);
        
        
        Leader_Downline_Summary__c rec2 = new Leader_Downline_Summary__c(
                                                Leadership_Summary_Key__c = lstContact[1].ACCT_NR__c,           //lstContact[0].ACCT_NR__c
                                                CurrencyISOCode='USD',
                                                //OwnerId=ldrUsr.Id,
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c=200,
                                                GENTRTN_1_ACTV_REP_CNT__c=2,
                                                TTL_LEG_CNT__c=2,
                                                GENRTN_1_TITL_1_STF_CNT__c=1,
                                                GENRTN_1_TITL_2_STF_CNT__c=2,
                                                GENRTN_1_TITL_3_STF_CNT__c=3,
                                                GENRTN_1_TITL_4_STF_CNT__c=4,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c, 
                                                ACCT_NR__c = String.valueOf(lstContact[1].ACCT_NR__c));  //lstContact[0].ACCT_NR__c
        lstLdrDwln.add(rec2);
        
         Leader_Downline_Summary__c rec3 = new Leader_Downline_Summary__c(
                                                Leadership_Summary_Key__c = lstContact[2].ACCT_NR__c,           //lstContact[0].ACCT_NR__c
                                                CurrencyISOCode='USD',
                                                //OwnerId=ldrUsr.Id,
                                                GRP_SUBMTD_AWRD_SLS_AMT__c=200,
                                                GENTRTN_1_ACTV_REP_CNT__c=2,
                                                TTL_LEG_CNT__c=2,
                                                GENRTN_1_TITL_1_STF_CNT__c=1,
                                                GENRTN_1_TITL_2_STF_CNT__c=2,
                                                GENRTN_1_TITL_3_STF_CNT__c=3,
                                                GENRTN_1_TITL_4_STF_CNT__c=4,
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c, 
                                                ACCT_NR__c = String.valueOf(lstContact[2].ACCT_NR__c));  //lstContact[0].ACCT_NR__c
        lstLdrDwln.add(rec3);
        
        insert lstLdrDwln;    
    
    
        //Creating Personal Performance
        List<My_Business__c> lstMyBusiness  =   new List<My_Business__c>();
        
        My_Business__c myB1 = new My_Business__c(
                                                 MRKT_ACCT_KEY__c = lstContact[0].Id, 
                                                 //OwnerId = ownrId,
                                                 Name = 'First1 Last1', MRKT_ID__c = mrkt.Market_Id__c,
                                                 ACCT_NR__c = String.valueOf(lstContact[0].ACCT_NR__c), 
                                                 OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                 LDRSHP_TITL_LVL_NR__c='1',
                                                 SUBMTD_AWRD_SLS_AMT__c=200,
                                                 FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                 Personal_Performance_Key__c = mrkt.Market_Id__c+mrkt.CMPGN_NR__c+String.valueOf(lstContact[0].ACCT_NR__c),
                                                 CurrencyIsoCode = 'USD', REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                 LDRSHP_LOA_NR__c=1);
        
        //myB1.OwnerId = ldrUsr.Id;
        
        lstMyBusiness.add(myB1);
        
        My_Business__c myB2 = new My_Business__c(
                                                 MRKT_ACCT_KEY__c = lstContact[1].Id, 
                                                 //OwnerId = ownrId,
                                                 Name = 'First1 Last1', MRKT_ID__c = mrkt.Market_Id__c,
                                                 ACCT_NR__c = String.valueOf(lstContact[1].ACCT_NR__c), 
                                                 OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                 LDRSHP_TITL_LVL_NR__c='2',
                                                 SUBMTD_AWRD_SLS_AMT__c=200,
                                                 FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                 Personal_Performance_Key__c = mrkt.Market_Id__c+mrkt.CMPGN_NR__c+String.valueOf(lstContact[1].ACCT_NR__c),
                                                 CurrencyIsoCode = 'USD', REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                 LDRSHP_LOA_NR__c=1);
        
      //  myB2.OwnerId = ldrUsr.Id;
        
        lstMyBusiness.add(myB2);
        
        My_Business__c myB3 = new My_Business__c(
                                                 MRKT_ACCT_KEY__c = lstContact[2].Id, 
                                                 //OwnerId = ownrId,
                                                 Name = 'First1 Last1', MRKT_ID__c = mrkt.Market_Id__c,
                                                 ACCT_NR__c = String.valueOf(lstContact[2].ACCT_NR__c), 
                                                 OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                 LDRSHP_TITL_LVL_NR__c='1',
                                                 SUBMTD_AWRD_SLS_AMT__c=200,
                                                 FLD_SLS_CMPGN_NR__c = Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                 Personal_Performance_Key__c = mrkt.Market_Id__c+mrkt.CMPGN_NR__c+String.valueOf(lstContact[2].ACCT_NR__c),
                                                 CurrencyIsoCode = 'USD', REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                 LDRSHP_LOA_NR__c=1);
        
        //myB3.OwnerId = ldrUsr.Id;
        
        lstMyBusiness.add(myB3);
        
        insert lstMyBusiness;
    
        // Insert ALM Rep Performance records for each contact for each campaign
        List<ALM_Rep_Performance_1__c> lstRepPerf = new List<ALM_Rep_Performance_1__c>();
        
        ALM_Rep_Performance_1__c rep1 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
                                            );
        lstRepPerf.add(rep1);
        ALM_Rep_Performance_1__c rep11 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey,
                                                Genealogy_Level__c = 0,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[0].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.PREV_1_CMPGN_NR__c + mktIdKey,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8
                                            );
        lstRepPerf.add(rep11);
                                        
        ALM_Rep_Performance_1__c rep2 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'01' ,
                                                UPLN_ACCT_NR__c = mktIdKey, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7
                                            );
        lstRepPerf.add(rep2);
        ALM_Rep_Performance_1__c rep21 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'01' ,
                                                UPLN_ACCT_NR__c = mktIdKey, Genealogy_Level__c = 1,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[1].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.PREV_1_CMPGN_NR__c + mktIdKey+'01' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7
                                            );
        lstRepPerf.add(rep21);
                                            
        ALM_Rep_Performance_1__c rep3 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'02' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6
                                            );
        lstRepPerf.add(rep3);
        ALM_Rep_Performance_1__c rep31 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'02' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'01', Genealogy_Level__c = 2,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[2].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.PREV_1_CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.PREV_1_CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.PREV_1_CMPGN_NR__c + mktIdKey+'02' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6
                                            );
        lstRepPerf.add(rep31);
                                            
        ALM_Rep_Performance_1__c rep4 = new ALM_Rep_Performance_1__c(
                                                Name = 'Test REP1', ACCT_NR__c = mktIdKey+'03' ,
                                                UPLN_ACCT_NR__c = mktIdKey+'02', Genealogy_Level__c = 3,
                                                CurrencyISOCode='USD',
                                                MRKT_ID__c=mrkt.Market_ID__c,
                                                MRKT_ACCT_KEY__c = lstContact[3].Id,
                                                FLD_SLS_CMPGN_NR__c=Decimal.valueOf(mrkt.CMPGN_NR__c),
                                                OPERTNL_CMPGN_NR__c =mrkt.CMPGN_NR__c,
                                                Personal_Performance_Key__c = mrkt.Market_Id__c + mrkt.CMPGN_NR__c + mktIdKey+'03' ,
                                                REP_OMS_STUS_CD__c = '1', AVON_LOA_1_6_IND__c = 'Y',
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '1',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,
                                                LFT_ND_ID__c = 4, RGT_ND_ID__c = 5
                                            );
        lstRepPerf.add(rep4);
        insert lstRepPerf;
        
        
        for(ALM_Rep_Performance_1__c almC : lstRepPerf){
        	System.debug('\n ##### ALM_Rep_Performance_1__c \n'+almC);
        }
        
        
        testData.createReportConfig();
        
        PageReference pageRef = Page.My_Sales_Leaders_Genealogy;
        PageRef.getParameters().put('pgId' , '18');
        PageRef.getHeaders().put('USER-AGENT' , 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        pageRef.getParameters().put('Campaign',mrkt.CMPGN_NR__c);
        pageRef.getParameters().put('acctkey',ldrUsr.ACCT_NR__c);
        Test.setCurrentPage(pageRef);
        
        System.runAs(ldrUsr)
        {
              cls_My_Sales_Leaders_Genealogy gen_Controller = new cls_My_Sales_Leaders_Genealogy();
             // getGenealogy(ldrUsr.ACCT_NR__c, mrkt.Market_Id__c, mrkt.CMPGN_NR__c,gen_Controller.m_LeaderTitles);
              gen_Controller.filterReport();
              gen_Controller.callRepDetails();
              gen_Controller.reportRedirect();
              gen_Controller.getOmniturePageName();
              gen_Controller.getReportTypesOptions();
             s_GetDetails(String.valueOf(mrkt.Market_Id__c+ldrUsr.ACCT_NR__c),mrkt.CMPGN_NR__c);
              
        }
        
        PageReference pageRef1 = Page.My_Sales_Leaders_Genealogy;
        PageRef1.getParameters().put('pgId' , '18');
        PageRef1.getHeaders().put('USER-AGENT' , 'XX');
        pageRef1.getParameters().put('repDetailAcctNbr', 'XX');
        Test.setCurrentPage(pageRef1);
        
          System.runAs(ldrUsr)
        {
              cls_My_Sales_Leaders_Genealogy gen_Controller1 = new cls_My_Sales_Leaders_Genealogy();
            //  getGenealogy(ldrUsr.ACCT_NR__c, mrkt.Market_Id__c, mrkt.CMPGN_NR__c,gen_Controller1.m_LeaderTitles);
              gen_Controller1.filterReport();
              gen_Controller1.callRepDetails();
              s_GetDetails(String.valueOf(mrkt.Market_Id__c+ldrUsr.ACCT_NR__c),mrkt.CMPGN_NR__c);
              
        }
        
        
        
        
        
       // Test.stopTest();
    } */
     
}