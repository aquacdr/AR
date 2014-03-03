global  without sharing class cls_My_Genealogy {
    
    public String s_Impersonate;
    public String s_DrillDown;
    public String s_ImpersonationUser {get; set;}
    public String s_mktID{get;  set;}
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
    public static String s_Rep_Object{get;set;}
    public Integer i_Lft{get;set;}
    public Integer i_Rgt{get;set;}
    public String s_Root_Upline {get;set;}
    public String i_Cmpgn {get;set;}
    public String s_Current_Selected_Campaign {get;set;}
    public Integer i_UserTitleLevel {get;set;}
    public Integer i_My_Level_From_Root {get;set;}
    public static String s_Google_Chart {get;set;}
    public Boolean s_IsImpersonated{get;set;}
    public List<Report_Config__c> lst_ReportLinks{get;set;} //For Report Link
    public static List<RisingStars> l_RisingStars {get;set;}    
    public Integer i_Downline_Depth{get;set;}   
    public String  s_Genealogy_String{get;set;}
    public String s_UserAgent{get;set;}

    //Object Declerations
    public User currUsr {get; private set;}
    public User orgnUsr {get; private set;}
    public Market__c market {get; private set;}
    //public static Integer i_Node_Count {get;set;}
    //public static Integer i_Level_One_Node_Count {get;set;}
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
    public String searchText {get;set;}  //added by swarnava for Search
    //added by Rajib
    public Boolean mailPlanEnabled {get; set;}
    public String genealogyDisplayType {get; set;}
    public String s_mailPlanCd {get; set;}     
	 //EOC
	 public Map<String, List<Genealogy_Field_Detail__c>> mapGenFlds{get;set;}	 
	 public GenealogyRootNodeInfo genRootNodeInfo{get; private set;}	 	
	 public ID s_mrkt_ID{get;set;}	  
	 // For Comma Separation
	public String  commaSeprtr {get; set;}
	// For Decimal Separation 
   	public String  decimlSeprtr {get; set;}
	public String currUserLocale{get;set;} 
	 
     
     
     // ADDED BY Vijay Mittal FOR SEARCH COMPONENT POPUP WINODOW
    public Pagereference saveSearchText() {
        searchText = Apexpages.currentPage().getParameters().get(ALMConstants.SEARCH_URL_PARAM);
        return null;
    }
    // CHNAGES BY Vijay Mittal ENDS HERE
   
    public cls_My_Genealogy()
    {
            try{
                //i_Node_Count=0;
                //i_Level_One_Node_Count=0;
                s_IsImpersonated=false;
                lst_ReportLinks = new List<Report_Config__c>();
                m_ColorCoding= new Map<String,String>();
                m_LeaderTitles= new Map<String,String>();
                m_LeaderStyles= new Map<String,String>();                
               
    
                this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
                s_UserAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
                SiteHeaderController obj_Controller = new SiteHeaderController();
                String s_Impersonated_User = Apexpages.currentPage().getParameters().get('acctkey');
                String sellingCampaign = Apexpages.currentPage().getParameters().get('mpCampaign');
				System.debug('\n ####### mailPlnCampgn -->>. '+sellingCampaign);
        
		        String isSellingCmpgn_Deflt_Landng = Apexpages.currentPage().getParameters().get('mpsellingdefaultlanding');
		        System.debug('\n ####### isSellingCmpgn_Deflt_Landng -->>. '+isSellingCmpgn_Deflt_Landng);
		        
		        String operationalCampaign = Apexpages.currentPage().getParameters().get('operatnCampaign');
		        System.debug('\n ####### operationalCampaign -->>. '+operationalCampaign);
                User currLogUser;
                   
                if(s_Impersonated_User!=null && s_Impersonated_User.trim()!=''){
                        currLogUser=[SELECT Id, Profile.Id, Profile.Name, DFALT_ZONE_CD__c, 
                        DFALT_DIV_NM__c, MRKT_ID__c, ACCT_NR__c, LDRSHP_TITL_LVL_NBR__c, 
                        Name, LanguageLocaleKey, MRKT_ID_ACCT_NR_KEY__c 
                        FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                        
                        // Modified by Rajib
                        //Integer campaignNr = YOUUtil.getCurrentCampaignNumber(currLogUser.MRKT_ID__c);
                        //String campaign = String.valueOf(campaignNr);
			String campaign = isSellingCmpgn_Deflt_Landng == 'Y' ? sellingCampaign : operationalCampaign;
                        //String campaign = sellingCampaign;
                        // EOC
                        
                        Boolean IsImp = LandingPageUtils.isImpersonationValid(currLogUser.Profile.Name, 
                                        currLogUser.MRKT_ID__c, currLogUser.DFALT_ZONE_CD__c, 
                                        currLogUser.DFALT_DIV_NM__c, currLogUser.ACCT_NR__c, 
                                        campaign, s_Impersonated_User);
    
                        if (IsImp){
                            User u = [Select Id,Name,LanguageLocaleKey,LocaleSidKey,MRKT_ID__c,
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
                                    USER_CNTRY_CD__c,LastName, LanguageLocaleKey,LocaleSidKey, FirstName,
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
                currUserLocale=currUsr.LocaleSidKey;
                System.debug('Market Id-->'+s_mktID);
                System.debug('s_User_Language  -->'+s_User_Language);
                System.debug('currUsr.LocaleSidKey  -->'+currUserLocale);
                
                
                /** Comma , Decimal Separation - START **/
	            List<String> lstSeprtn =  YOUUtil.getLocaleSeparator(currUserLocale);
	            commaSeprtr = lstSeprtn[0];
	            decimlSeprtr = lstSeprtn[1];
            	/** Comma , Decimal Separation - END **/
               
               
               //Market Information
                ////added NEXT_1_CMPGN_NR__c ,Mail_Plan_Enabled__c to the query-- by Rajib
                this.market = [ Select  Id,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, Name,Genealogy_Report_Configurable__c, 
                                        Market_Id__c,CMPGN_STRT_DT__c, CMPGN_NR__c,CMPGN_END_DT__c,
                                        Omniture_Suite_Name__c,CURRENT_QRTR__c,ALM_Rep_Indicator__c,Mail_Plan_Enabled__c,
                                        NEXT_1_CMPGN_NR__c , NRT_Enabled__c  
                                From    
                                        Market__c
                                Where   
                                        Market_Id__c =:s_mktID];
                                        
               // Rajib added - 09/2013
               s_mrkt_ID = this.market.ID;
               System.debug('s_mrkt_ID   at Main Class '+s_mrkt_ID);                          
                                        
                l_Campaign = new List<SelectOption>();
                
                //added by Rajib
                mailPlanEnabled = this.market.Mail_Plan_Enabled__c;                
                
               if(!mailPlanEnabled){
                	l_Campaign.add(new SelectOption(this.market.CMPGN_NR__c,this.market.CMPGN_NR__c));
                	l_Campaign.add(new SelectOption( this.market.PREV_1_CMPGN_NR__c,this.market.PREV_1_CMPGN_NR__c));
            	 }else{
            	 	l_Campaign.add(new SelectOption( this.market.PREV_1_CMPGN_NR__c,this.market.PREV_1_CMPGN_NR__c)); 
            	 	l_Campaign.add(new SelectOption(this.market.CMPGN_NR__c, this.market.CMPGN_NR__c));
            	 	l_Campaign.add(new SelectOption(this.market.NEXT_1_CMPGN_NR__c, this.market.NEXT_1_CMPGN_NR__c));
            		              		
            		System.debug('sellingCampaign -->'+sellingCampaign);  
            		System.debug('l_Campaign -->'+l_Campaign); 
            		
            	 }            	
            	             	
            	   
            	//Ended by Rajib
                
                s_mrktSalesforceId = this.market.Id;
                s_Rep_Object = this.market.ALM_Rep_Indicator__c;
                
                System.debug('ALM_Rep_Indicator__c-->'+this.market.ALM_Rep_Indicator__c);  
                
                s_Current_Campaign = 'C'+String.valueOf((this.market.CMPGN_NR__c)).substring(5,(String.valueOf((this.market.CMPGN_NR__c))).length());
                s_Campaign_Start_Date = String.valueOf((this.market.CMPGN_STRT_DT__c).day())+'/'+String.valueOf((this.market.CMPGN_STRT_DT__c).month());
                s_Campaign_End_Date = String.valueOf((this.market.CMPGN_END_DT__c).day())+'/'+String.valueOf((this.market.CMPGN_END_DT__c).month());
                
                
               List<Leader_title__c> Leader_Title = [Select Id,LANG_CD__c,LCL_LDRSHP_TITL_CD__c,LDRSHP_TITL_LVL_NR__c,MRKT_ID__c,EXEC_IND__c From  Leader_Title__c Where Market__c=:s_mrktSalesforceId and LANG_CD__c=:s_User_Language order by LDRSHP_TITL_LVL_NR__c];
                
                if(Leader_Title.size()>0){
	                for(Leader_Title__c obj_Leader : Leader_Title){
	                    m_LeaderTitles.put(String.valueOf(obj_Leader.LDRSHP_TITL_LVL_NR__c),obj_Leader.LCL_LDRSHP_TITL_CD__c);  
	                }
                }
                for(Genealogy_Leader_Level__c obj_StyleCode : [Select Color__c,LDRSHP_TITL_LVL_NR__c From Genealogy_Leader_Level__c Where MRKT_ID__c =:s_mktID]){
                    m_LeaderStyles.put(obj_StyleCode.LDRSHP_TITL_LVL_NR__c,obj_StyleCode.Color__c);
                }
                //Assigning a Default Color in case no Style is available
                if(m_LeaderStyles.size()<=0){
                    for (String s_LeaderLevel : m_LeaderTitles.keySet()) {
                           m_LeaderStyles.put(s_LeaderLevel,'#EF1351');
                        }
                }               
               
               // SiteHeaderController obj_Controller = new SiteHeaderController();
                obj_Controller.currUsr=currUsr;
                //Start of Modification - by Rajib on 29072013
                String GenealogyURL = String.valueOf(Apexpages.currentPage().getURL());
                 
                 if(s_IsImpersonated){
		                     if(obj_Controller.getReportLinks(this.market.Market_Id__c, this.currUsr.Profile.Name,this.currUsr.LDRSHP_TITL_LVL_NBR__c,true).size()>0){
		                         for(Report_Config__c obj_RC : obj_Controller.getReportLinks(this.market.Market_Id__c, s_Impersonated_Profile,s_Impersonated_LDRTitlLvl,true)){
		                             if(GenealogyURL.contains(ALMConstants.REPORT_TYPE_SL_GENEALOGY) && Apexpages.currentPage().getParameters().get('pgId').equals('18')){
		                             	if(String.valueOf(obj_RC.Report_Type__c) != ALMConstants.REPORT_TYPE_SL_GENEALOGY){
		                             		lst_ReportLinks.add(obj_RC);                                	
		                         		}
		                             	
		                             }
		                             if(GenealogyURL.contains(ALMConstants.REPORT_TYPE_SL_GENEALOGY) && Apexpages.currentPage().getParameters().get('pgId').equals('11')){
		 	                            	if(String.valueOf(obj_RC.Report_Type__c) != ALMConstants.REPORT_TYPE_EXEC_SL_GENEALOGY){                            	
		 	                                	lst_ReportLinks.add(obj_RC);
		 	                        		}
		                             	}
		                         		
		                             }
		                         }  
		                     }
		                      else{
		                         if(obj_Controller.getReportLinks(this.market.Market_Id__c, this.currUsr.Profile.Name , this.currUsr.LDRSHP_TITL_LVL_NBR__c,false).size()>0){
		                             for(Report_Config__c obj_RC : obj_Controller.getReportLinks(this.market.Market_Id__c, this.currUsr.Profile.Name , this.currUsr.LDRSHP_TITL_LVL_NBR__c,false)){
		                             	
		                                 if(GenealogyURL.contains(ALMConstants.REPORT_TYPE_SL_GENEALOGY) && Apexpages.currentPage().getParameters().get('pgId').equals('18')){
		                             	if(String.valueOf(obj_RC.Report_Type__c) != ALMConstants.REPORT_TYPE_SL_GENEALOGY){
		                             		lst_ReportLinks.add(obj_RC);                                	
		                         		}
		                             	
		                             }
		                             if(GenealogyURL.contains(ALMConstants.REPORT_TYPE_SL_GENEALOGY) && Apexpages.currentPage().getParameters().get('pgId').equals('11')){
		 	                            	if(String.valueOf(obj_RC.Report_Type__c) != ALMConstants.REPORT_TYPE_EXEC_SL_GENEALOGY){                            	
		 	                                	lst_ReportLinks.add(obj_RC);
		 	                        		}
		                             	}                        		
		                             }
		                         }
		                     }
                   //End of Modification - by Rajib on 29072013
                    System.debug('testing-->'+this.market.Market_Id__c+'  '+this.market.CMPGN_NR__c);
                    if(this.market.Market_Id__c!=null && this.market.CMPGN_NR__c!=null){
                       if(Apexpages.currentPage().getParameters().get('Campaign')!=null){
                            s_Current_Selected_Campaign=Apexpages.currentPage().getParameters().get('Campaign');
                       }
                       else{
                       // Modified by Rajib
                       		if(!mailPlanEnabled)
                             s_Current_Selected_Campaign=this.market.CMPGN_NR__c;
                            else
                            	//s_Current_Selected_Campaign=sellingCampaign;
                            	s_Current_Selected_Campaign = isSellingCmpgn_Deflt_Landng == 'Y' ? sellingCampaign : operationalCampaign;                            
                            // EOC 
                       }
                         //Current User Details
                        
						System.debug('s_Current_Selected_Campaign -->'+s_Current_Selected_Campaign);
                        // Code added by Rajib - to make it configurable                        
                        System.debug('Before Initialize');                          
                        this.mapGenFlds = YOUUtil.getGenealogyMapFields(s_mrkt_ID) ;    
                        System.debug('this.mapGenFlds  -->'+this.mapGenFlds);                
                        genRootNodeInfo = new GenealogyRootNodeInfo(this.market,this.mapGenFlds,Integer.valueOf(s_Current_Selected_Campaign),String.valueOf(s_MktId+s_User_Account_Number),this.m_LeaderTitles,Leader_Title);                        
                        // Code added - to make it configurable 
                                               
                        if(this.market.ALM_Rep_Indicator__c!=null){
                          //Added by Rajib for Mail Plan
                        	i_Lft = genRootNodeInfo.g_Lft;
                        	i_Rgt = genRootNodeInfo.g_Rgt;
                        	s_Root_Upline = genRootNodeInfo.g_Root_Upline;
                        	i_My_Level_From_Root = genRootNodeInfo.g_My_Level_From_Root;
                            String s_Genealogy_Display_Type=''; 
                            
                            String leaderGenealogy = ALMConstants.REPORT_TYPE_SL_GENEALOGY;
                            String execleaderGenealogy = ALMConstants.REPORT_TYPE_EXEC_SL_GENEALOGY;                        
                            
                            Integer iCampaign=Integer.valueOf(s_Current_Selected_Campaign);                            
                             if(String.valueOf(Apexpages.currentPage().getURL()).contains(leaderGenealogy) && Apexpages.currentPage().getParameters().get('pgId').equals('18')){
                                s_Genealogy_Display_Type='N'; //N for Normal Genealogy & 'E' for Executive Genealogy
                            }                            
                            else if(String.valueOf(Apexpages.currentPage().getURL()).contains(leaderGenealogy) && Apexpages.currentPage().getParameters().get('pgId').equals('11')){
                                s_Genealogy_Display_Type='E'; 
                            }
                            else{
                                s_Genealogy_Display_Type='';
                            }
                            
                            //added by Rajib
                            this.genealogyDisplayType = s_Genealogy_Display_Type;
                            
                            if(s_Genealogy_Display_Type!=null && s_Genealogy_Display_Type.trim()!=''){                               
                               //getGenealogy(s_Rep_Object,i_Lft,i_Rgt,s_Root_Upline,iCampaign,s_User_Account_Number,i_My_Level_From_Root,s_Genealogy_Display_Type,m_LeaderTitles, m_LeaderStyles,this.market.Market_Id__c);
                               getGenealogy(s_Rep_Object,i_Lft,i_Rgt,s_Root_Upline,iCampaign,s_User_Account_Number,i_My_Level_From_Root,s_Genealogy_Display_Type,m_LeaderTitles, m_LeaderStyles,this.market.Market_Id__c,mailPlanEnabled); 
                            }
                            
                        }
                    }
            }
            catch(Exception e){
            
            }
    }
    
     global static String getGenealogy(String s_RepObject,Integer i_left,Integer i_right,String s_Root, Integer i_Campaign,String s_Account_Number,Integer i_Level_From_Root,String s_Genealogy_Display_Type ,Map<String,String> m_Leader_Titles, Map<String, String> m_LeaderStyles,String marketID,Boolean mailPlanEnabled) {
        try{
                
                List<String> s_Titles = new List<String>();
                Integer iIndex=0;
                
                String s_Construct_Org_Chart='';
                String s_Zone='';
                String s_Image=System.Label.OpenLinkImage;
                String s_Class_Style='';
                Integer s_Genealogy_Level_Child=0;
                l_RisingStars = new List<RisingStars>();
                List<sObject> l_Rising_Stars = new List<sObject>();
                
                for(String s_Key : m_Leader_Titles.keySet()){
                    if(Integer.valueOf(s_Key)>=0){
                        s_Titles.add(s_Key);
                    }
                }
                System.debug('m_LeaderStyles --> '+m_LeaderStyles);
                System.debug('Genealogy Query-->'+'Select Id,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles');
                List<sObject> l_Tree = new List<sObject>();
                
                if(s_Genealogy_Display_Type=='N'){                   
           //l_Tree = Database.query('Select Id,TITL_STUS__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and MRKT_ID__c='+'\''+marketID+'\'');
           if(!mailPlanEnabled){
		      l_Tree = Database.query('Select Id,TITL_STUS__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and MRKT_ID__c='+'\''+marketID+'\'');
		      }else{
			l_Tree = Database.query('Select Id,TITL_STUS__c,MailPlan_Order_Oppty__r.MLPLN_CD__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and MRKT_ID__c='+'\''+marketID+'\'');
                   }
                }
                else if(s_Genealogy_Display_Type=='E'){                    
            //l_Tree = Database.query('Select Id,TITL_STUS__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and MRKT_ID__c='+'\''+marketID+'\''+' and EXEC_TITL_IND__c='+'\''+'Y'+'\' Order By Genealogy_Level__c');                    
            if(!mailPlanEnabled){
				l_Tree = Database.query('Select Id,TITL_STUS__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and MRKT_ID__c='+'\''+marketID+'\''+' and EXEC_TITL_IND__c='+'\''+'Y'+'\' Order By Genealogy_Level__c');
			 }else{
				l_Tree = Database.query('Select Id,TITL_STUS__c,MailPlan_Order_Oppty__r.MLPLN_CD__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and MRKT_ID__c='+'\''+marketID+'\''+' and EXEC_TITL_IND__c='+'\''+'Y'+'\' Order By Genealogy_Level__c');
                 }
                //l_Rising_Stars = Database.query('Select Id,TITL_STUS__c,FLD_SLS_CMPGN_NR__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+ ' and MRKT_ID__c='+'\''+marketID+'\''+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and RSNG_STR_IND__c='+'\''+'Y'+'\' Order By Genealogy_Level__c');
            if(!mailPlanEnabled){
			 	l_Rising_Stars = Database.query('Select Id,TITL_STUS__c,FLD_SLS_CMPGN_NR__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+ ' and MRKT_ID__c='+'\''+marketID+'\''+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and RSNG_STR_IND__c='+'\''+'Y'+'\' Order By Genealogy_Level__c');
			}else{
			 	l_Rising_Stars = Database.query('Select Id,TITL_STUS__c,MailPlan_Order_Oppty__r.MLPLN_CD__c,FLD_SLS_CMPGN_NR__c,LDRSHP_TITL_LVL_NR__c,MRKT_ACCT_KEY__c,MRKT_ACCT_KEY__r.Name,MRKT_ACCT_KEY__r.ACCT_NR__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,MRKT_ACCT_KEY__r.Shortened_Name__c,UPLN_ACCT_KEY__c,UPLN_ACCT_KEY__r.ACCT_NR__c,Genealogy_Level__c From '+s_RepObject+' Where LFT_ND_ID__c>'+i_Left+' and RGT_ND_ID__c<='+i_right+' and ROOT_UPLN_ACCT_NR__c='+'\''+s_Root+'\''+' and FLD_SLS_CMPGN_NR__c='+i_Campaign+ ' and MRKT_ID__c='+'\''+marketID+'\''+' and LDRSHP_TITL_LVL_NR__c In : s_Titles and RSNG_STR_IND__c='+'\''+'Y'+'\' Order By Genealogy_Level__c');
                }
                    
                    if(l_Rising_Stars.size()>0){
                        for(sObject r_RisingStars : l_Rising_Stars){
                        	iIndex++;
                            l_RisingStars.add(new RisingStars(r_RisingStars, m_Leader_Titles, iIndex, m_LeaderStyles,mailPlanEnabled));
                        }
                    }
                
                }
                if(l_Tree.size()>0){
                        
                        s_Construct_Org_Chart+='[{v:'+'\''+s_Account_Number+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" style="#FFFFFF" id="primary_node"><a style="cursor: pointer;" id="o_opener:'+s_Account_Number+':'+String.valueOf(i_Campaign)+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+s_Account_Number+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+s_Account_Number+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+s_Account_Number+'" style="align:left;"><a href="javascript:void(0);" id="'+s_Account_Number+'" onclick="f_ImpersonateUser(this.id)" class="node_href_LevelUp1">'+s_Account_Number+'</a></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+s_Account_Number+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+s_Account_Number+'" style="background:#FFFFFF"></p></div></div>'+'\''+'}'+','+'\''+s_Account_Number+'\''+','+'\''+'\''+'],';
                                                
                        for(sObject s_Tree : l_Tree){
                        String s_Level = String.valueOf(s_Tree.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(s_Tree.get('LDRSHP_TITL_LVL_NR__c')) : '';
                        String s_Level_Title = m_Leader_Titles.get(s_Level);//String.valueOf(s_Title_Level_Status_Child.get('LDRSHP_TITL_LVL_CD__c'));//String.valueOf(s_Genealogy.get('Title_Level_Number__c')) !=null ? String.valueOf(s_Genealogy.get('Title_Level_Number__c')) : '';
                        String s_Level_Color = s_Level =='0' ? '79d3ff' : 'ec008c';
                        String s_Title_Level_Child = String.valueOf(s_Tree.get('TITL_STUS__c'))!=null ? String.valueOf(s_Tree.get('TITL_STUS__c')) :''; 
                        //String s_Title_Color_Child = s_Title_Level_Child =='Rising Star' ? '#339933' :'#ff0000'; 
                        String s_Title_Color_Child = s_Title_Level_Child == System.Label.ZM_Formula_Rising_Star ? '#339933' :'#ff0000';
                        
                        s_Genealogy_Level_Child = Integer.valueOf(s_Tree.get('Genealogy_Level__c')) !=null ? Integer.valueOf(s_Tree.get('Genealogy_Level__c')) : -1;
                     
                     
                     s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child == System.Label.ZM_Formula_Rising_Star ? 'node_p_container_2_Titl_RS':'node_p_container_2_Titl') : 'node_p_container_2';
                     
 					if(!mailPlanEnabled){
						s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+string.escapeSingleQuotes((string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c'))+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'</span><br/><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						//s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						}else{
						s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+string.escapeSingleQuotes((string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c'))+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_In_Short+':'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'/'+System.Label.MailPlan_In_Short+':'+(string)s_Tree.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c')+'</span><br/><span style="font-style:italic;font-weight:bold;color:'+s_Title_Color_Child+'">'+''+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						//s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_In_Short+':'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'/'+System.Label.MailPlan_In_Short+':'+(string)s_Tree.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c')+'</span><span style="font-style:italic;font-weight:bold;color:'+s_Title_Color_Child+'">'+''+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
                        
                        }
                        
                    /* 
                      
                    if((Integer.valueOf(s_Tree.get('Genealogy_Level__c')))==(i_Level_From_Root+1)){                    
                    s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child == System.Label.ZM_Formula_Rising_Star ? 'node_p_container_2_Titl_RS':'node_p_container_2_Titl') : 'node_p_container_2';
                    //s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
                    if(!mailPlanEnabled){
						s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+string.escapeSingleQuotes((string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c'))+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'</span><br/><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						//s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						}else{
						s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+string.escapeSingleQuotes((string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c'))+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_In_Short+':'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'/'+System.Label.MailPlan_In_Short+':'+(string)s_Tree.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c')+'</span><br/><span style="font-style:italic;font-weight:bold;color:'+s_Title_Color_Child+'">'+''+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						//s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1" id="node_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" style="cursor: pointer;" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_1" id="img_div_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" src="'+s_Image+'"></img></a><div class="node_div_2" id="node_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p id="node_p_container_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" class="node_p_container_1" style="font-size:1.1em;" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.2em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_In_Short+':'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'/'+System.Label.MailPlan_In_Short+':'+(string)s_Tree.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c')+'</span><span style="font-style:italic;font-weight:bold;color:'+s_Title_Color_Child+'">'+''+s_Title_Level_Child+'</span></p></div><div class="node_div_3" id="node_div_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="vio_icon_node_highlight" id="vio_icon_node_highlight_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
                        
                        }
                                    
                   }else
                        {                        
                        s_Class_Style= s_Title_Level_Child!='' ? (s_Title_Level_Child ==System.Label.ZM_Formula_Rising_Star ? 'node_p_container_3_Titl_RS':'node_p_container_3_Titl') : 'node_p_container_3';
                        //s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a style="cursor: pointer;" id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.0em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c')+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><span>'+System.Label.Zone_Genealogy_Tree+' '+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c')+'</span><span style="font-style:italic;color:'+s_Title_Color_Child+'">'+' '+s_Title_Level_Child+'</span></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
                        
                        if(!mailPlanEnabled){
							s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a style="cursor: pointer;" id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.0em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+string.escapeSingleQuotes((string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c'))+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
						}else{
							s_Construct_Org_Chart+='[{v:'+'\''+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'\''+',f:'+'\''+'<div class="node_div_1_LevelUp_1" id="node_div_1_LevelUp_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><a style="cursor: pointer;" id="o_opener:'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(i_Campaign)+':'+s_Level_Title+'" onclick="f_OpenDetailedDiv(this.id);"><img class="img_div_2" id="img_div_2_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"  src="'+s_Image+'"/></a><div class="node_div_2_LevelUp_1" id="node_div_2_LevelUp_1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="node_p_container_1_LevelUp1" id="node_p_container_1_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="align:left;"><label id="'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="font-family: arial,helvatica;color: #34312C;font-size: 1.0em;font-weight: 700;cursor: pointer;text-decoration: underline;" onclick="f_ImpersonateUser(this.id);"  class="node_href_LevelUp1">'+string.escapeSingleQuotes((string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c'))+'</label></p><p class="'+s_Class_Style+'" id="node_p_container_3_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"></p></div><div class="node_div_3_LevelUp1" id="node_div_3_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'"><p class="node_p_container_3_LevelUp1" id="node_p_container_3_LevelUp1_'+(string)s_Tree.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+'" style="background:#'+s_Level_Color+';">'+s_Level_Title+'</p></div></div>'+'\''+'}'+','+'\''+(string)s_Tree.getsObject('UPLN_ACCT_KEY__r').get('ACCT_NR__c')+'\''+','+'\''+'\''+'],';
                            }
                                                  
                        }
                        
                        */
                        
                    }
                }
                 s_Google_Chart = s_Construct_Org_Chart.substring(0,(s_Construct_Org_Chart.length())-1);  
                 
                 System.debug('Google Chart-->'+s_Google_Chart);
                return s_Google_Chart;
        }
        catch(Exception e){
                System.debug('Exception e-->'+e.getMessage());
                return null;
        }
      }
     public PageReference filterReport(){
        PageReference pageref = Page.My_Sales_Leaders_Genealogy;
        System.debug('test'+Apexpages.currentPage().getURL());
        pageRef.getParameters().put('reportid', ApexPages.currentPage().getParameters().get('reportid'));
        pageRef.getParameters().put('pgId', ApexPages.currentPage().getParameters().get('pgId'));
        pageRef.getParameters().put('Campaign',this.s_Current_Selected_Campaign);
        //pageRef.getParameters().put('LOA',this.loaFselect);
        if(ApexPages.currentPage().getParameters().get('acctkey')!=null){
            pageRef.getParameters().put('acctkey',ApexPages.currentPage().getParameters().get('acctkey'));
        }
        
        String sUrl = Apexpages.currentPage().getURL();
        if(sUrl.contains('my_sales_leaders_genealogy')) // My_Sales_Leaders_Genealogy
            sUrl = sUrl.replace('my_sales_leaders_genealogy', 'My_Sales_Leaders_Genealogy');
            
        if(sUrl.indexOf('com.salesforce.visualforce') > -1) // My_Sales_Leaders_Genealogy
        {
            System.debug('test again IF ---->>> '+sUrl);
            integer iIndx = sUrl.indexOf('com.salesforce.visualforce');
            sUrl = sUrl.substring(0, iIndx - 1);
            System.debug('test again IF NOW  ---->>> '+sUrl);
        }
        
        System.debug(' @@@@@ test again ---->>> '+Apexpages.currentPage().getURL());
            
        PageReference pageRef1 = new PageReference(sUrl);   
        pageRef1.getParameters().put('reportid', ApexPages.currentPage().getParameters().get('reportid'));
        pageRef1.getParameters().put('Campaign',this.s_Current_Selected_Campaign);     
        pageRef1.getParameters().put('pgId', ApexPages.currentPage().getParameters().get('pgId'));
        System.debug('test again ---->>> '+Apexpages.currentPage().getURL());
        
        //pageRef.setRedirect(true);
        pageRef1.setRedirect(true);
        
        return pageRef1;
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
    
      @RemoteAction
    global static GenealogyOverlayInfo s_GetDetails(String s_Market_Account_Key,String s_Campaign,String s_Query_Object,Boolean isMailPlan, Id mrktID,String userLanguage, String s_Gen_Disp_Type){
    //global static List<Contact> s_GetDetails(String s_Market_Account_Key,String s_Campaign,String s_Query_Object,Boolean isMailPlan, ID mrkt){
        System.debug('Account Number-->'+s_Market_Account_Key);
        System.debug('Campaign Number-->'+s_Campaign);
        
        System.debug('Market ID-->'+mrktID);
        GenealogyOverlayInfo genOverlayInfo = new GenealogyOverlayInfo(mrktID,s_Query_Object,isMailPlan,Integer.valueOf(s_Campaign),s_Market_Account_Key,userLanguage,s_Gen_Disp_Type);
        
         return genOverlayInfo;
    }
    
    public class RisingStars
    {
        public RisingStars(){
        }
        
        public SObject sObj {get;set;}
        public Map<String,String> m_LeaderTitles = new Map<String,String>();
        public Integer iIndexRising;
        public Map<String, String> mLeaderStyles = new Map<String, String>();        
        Boolean r_MailPlan = false;
	         
	 	//mail Plan method added by Rajib
		public  String  getMailPlanCode(){

	    return r_MailPlan?(string)sObj.getsObject('MailPlan_Order_Oppty__r').get('MLPLN_CD__c'):'';     		
        }        
        public  String  getTitleStatus(){
	    return String.valueOf(sObj.get('TITL_STUS__c'))!=null ? String.valueOf(sObj.get('TITL_STUS__c')) :''; 		
        }        
        public  String  getColorCode(){
        String s_Title_Level_Child = String.valueOf(sObj.get('TITL_STUS__c'))!=null ? String.valueOf(sObj.get('TITL_STUS__c')) :'';
        String s_Title_Color_Child = s_Title_Level_Child == System.Label.ZM_Formula_Rising_Star ? '#339933' :'#ff0000';
	    return s_Title_Color_Child;   		
        }
                    
       public String getAccountNumber(){       
            return (string)sObj.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c');
        }
        public  String  getName(){
            return (string)sObj.getsObject('MRKT_ACCT_KEY__r').get('Shortened_Name__c');
        }
        public  String  getZone(){
            return (string)sObj.getsObject('MRKT_ACCT_KEY__r').get('SLS_ZONE_CD__c');
        }
         public  String  getCampaignNumber(){
            return String.valueOf(sObj.get('FLD_SLS_CMPGN_NR__c'));
        }
        public String getAccNoCmpgn() {
        	String s_Level = String.valueOf(sObj.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(sObj.get('LDRSHP_TITL_LVL_NR__c')) : '';
        	return ':'+(string)sObj.getsObject('MRKT_ACCT_KEY__r').get('ACCT_NR__c')+':'+String.valueOf(sObj.get('FLD_SLS_CMPGN_NR__c'))+':'+s_Level;
        }
        public String getTitle(){
            String s_Level = String.valueOf(sObj.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(sObj.get('LDRSHP_TITL_LVL_NR__c')) : '';
            return (string)m_LeaderTitles.get(s_Level);
        }
        
        public String getstr_LeaderStyle(){
        	String s_Level = String.valueOf(sObj.get('LDRSHP_TITL_LVL_NR__c')) !=null ? String.valueOf(sObj.get('LDRSHP_TITL_LVL_NR__c')) : '';
            return mLeaderStyles.get(s_Level);
        }
        
        public String geti_RisingStarIndex(){
            return String.valueOf(iIndexRising);
        }
        
        public RisingStars(SObject s , Map<String,String> m_Titles,Integer iRisingStarIndex,Map<String, String> m_LeaderStyles,Boolean m_mailPlanEnabled){
            sObj = s;
            m_LeaderTitles = m_Titles;
            iIndexRising = iRisingStarIndex;
            mLeaderStyles= m_LeaderStyles;
            r_MailPlan = m_mailPlanEnabled;            
        }
    }
    
    public string getBatchTimeStamp(){
    	return NRT_Utils.getLastUpdatedTimeStampBatch(market.Market_Id__c);
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
        mrkt.ALM_Rep_Indicator__c = 'ALM_Rep_Performance_1__c';
        mrkt.Mail_Plan_Enabled__c = true;
        mrkt.Genealogy_Root_Node_Section__c='Test1';
        mrkt.Genealogy_Overlay_Section__c = 'Test2';
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
       
    
    // Creates MailPlan data
        MailPlan_Order_Oppty__c mlplnOrdOppty = testData.creatMailPlans(mrkt, ldrUsr.DFALT_ZONE_CD__c);
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
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
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
                                                LFT_ND_ID__c = 1, RGT_ND_ID__c = 8,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
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
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
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
                                                LFT_ND_ID__c = 2, RGT_ND_ID__c = 7,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
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
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
                                            );
        lstRepPerf.add(rep3);
        
        System.debug('lstContact[2].Id -->'+lstContact[2].Id +':::lstContact[3].Id-->'+lstContact[3].Id);
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
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '2',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,EXEC_TITL_IND__c = 'Y',RSNG_STR_IND__c='Y',
                                                LFT_ND_ID__c = 3, RGT_ND_ID__c = 6,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
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
                                                LDRSHP_LOA_NR__c=1, LDRSHP_TITL_LVL_NR__c = '2',
                                                ROOT_UPLN_ACCT_NR__c = mktIdKey,EXEC_TITL_IND__c = 'Y',RSNG_STR_IND__c='Y',
                                                LFT_ND_ID__c = 4, RGT_ND_ID__c = 5,MailPlan_Order_Oppty__c = mlplnOrdOppty.Id
                                            );
        lstRepPerf.add(rep4);
        System.debug('rep4 --->'+rep4.MRKT_ACCT_KEY__r.SLS_ZONE_CD__c);
        insert lstRepPerf;
        
        Genealogy_Field_Detail__c genFldDtl = new Genealogy_Field_Detail__c(Name='Test1',Column__c='',Group__c='Root',
        										Fields_To_Map__c ='ALM_Rep_Performance_1:GENTRTN_1_ACTV_REP_CNT__c',
        										Order__c=1,Type__c='Number');
        										
			insert genFldDtl;
			
		Genealogy_Field_Detail__c genFldDtl1 = new Genealogy_Field_Detail__c(Name='Test2',Column__c='1',Group__c='Overlay',
						Fields_To_Map__c ='ALM_Rep_Performance_1:GRP_INVC_AWRD_SLS_AMT__c',
						Order__c=1,Type__c='Number');
        
        insert genFldDtl1;
        
        Boolean mpEnabled = true;
       
        Sobject sObj = [select Name, ACCT_NR__c, UPLN_ACCT_NR__c, Genealogy_Level__c ,MRKT_ID__c,MRKT_ACCT_KEY__r.ACCT_NR__c,
        				MRKT_ACCT_KEY__r.Shortened_Name__c,MRKT_ACCT_KEY__r.SLS_ZONE_CD__c,
        				FLD_SLS_CMPGN_NR__c,OPERTNL_CMPGN_NR__c,LDRSHP_TITL_LVL_NR__c,
                                                ROOT_UPLN_ACCT_NR__c,MailPlan_Order_Oppty__r.MLPLN_CD__c from ALM_Rep_Performance_1__c where Id = :lstRepPerf[6].Id];
        
       
        RisingStars risingStar = new RisingStars(sObj,m_Titles,2,m_LeaderStyles,mpEnabled);        
       	risingStar.getMailPlanCode();
        risingStar.getAccountNumber();
        risingStar.getName();
        risingStar.getZone();
        risingStar.getCampaignNumber();
        risingStar.getAccNoCmpgn();
        
        
        
        for(ALM_Rep_Performance_1__c almC : lstRepPerf){
            System.debug('\n ##### ALM_Rep_Performance_1__c \n'+almC);
        }
        
        
        testData.createReportConfig();
        
        PageReference pageRef = Page.My_Sales_Leaders_Genealogy;
        PageRef.getParameters().put('pgId' , '11');
        PageRef.getHeaders().put('USER-AGENT' , 'XX');
        pageRef.getParameters().put('repDetailAcctNbr', 'XX');
        pageRef.getParameters().put('Campaign',mrkt.CMPGN_NR__c);
        pageRef.getParameters().put('mpCampaign',mrkt.CMPGN_NR__c);        
        pageRef.getParameters().put('acctkey',ldrUsr.ACCT_NR__c);
        Test.setCurrentPage(pageRef);
        
        System.debug('\n #### Apexpages.currentPage().getURL()) --> '+Apexpages.currentPage().getURL());
        
        
        
        mrkt.Mail_Plan_Enabled__c = false;
        update  mrkt;
        System.runAs(ldrUsr)
        {
              cls_My_Genealogy gen_Controller = new cls_My_Genealogy();
              
             // getGenealogy(ldrUsr.ACCT_NR__c, mrkt.Market_Id__c, mrkt.CMPGN_NR__c,gen_Controller.m_LeaderTitles);
              gen_Controller.filterReport();
              gen_Controller.callRepDetails();
              gen_Controller.reportRedirect();
              gen_Controller.getOmniturePageName();
              gen_Controller.getReportTypesOptions();
              Boolean isMailPlan = true;
             s_GetDetails(String.valueOf(mrkt.Market_Id__c+ldrUsr.ACCT_NR__c),mrkt.CMPGN_NR__c, mrkt.ALM_Rep_Indicator__c.replace('__c','__r'),isMailPlan,mrkt.Id,'en_US','E');
                          
              
        }
        
        PageReference pageRef1 = Page.My_Sales_Leaders_Genealogy;
        PageRef1.getParameters().put('pgId' , '18');
        PageRef1.getHeaders().put('USER-AGENT' , 'XX');
        pageRef1.getParameters().put('repDetailAcctNbr', 'XX');
        pageRef.getParameters().put('Campaign',mrkt.CMPGN_NR__c);
        pageRef.getParameters().put('mpCampaign',mrkt.CMPGN_NR__c); 
        String sUrl = Apexpages.currentPage().getURL();
        System.debug('##### sUrl :: '+sUrl);
        if(sUrl.contains('my_sales_leaders_genealogy'))
         sUrl = sUrl.replace('my_sales_leaders_genealogy', 'My_Sales_Leaders_Genealogy');
        
        pageRef1 = new PageReference(sUrl);
        
        Test.setCurrentPage(pageRef1);
        
          System.runAs(ldrUsr)
        {
              cls_My_Genealogy gen_Controller1 = new cls_My_Genealogy();
            //  getGenealogy(ldrUsr.ACCT_NR__c, mrkt.Market_Id__c, mrkt.CMPGN_NR__c,gen_Controller1.m_LeaderTitles);
              gen_Controller1.filterReport();
              gen_Controller1.callRepDetails();
              Boolean isMailPlan = false;                       
              s_GetDetails(String.valueOf(mrkt.Market_Id__c+ldrUsr.ACCT_NR__c),mrkt.CMPGN_NR__c, mrkt.ALM_Rep_Indicator__c.replace('__c','__r'),isMailPlan,mrkt.Id,'en_US','N');
                                          
        }
        
        
        
        
        
       // Test.stopTest();
    }*/
    
    
    
}