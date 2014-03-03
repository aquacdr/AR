/***************************************************************************
 Name          : Controller_SLKeyDataSummary 
 Created By    : Barkha Jain
 Description   : Controller for SLKeyDataSummary 
 Created Date  : Jan 17, 2014                
****************************************************************************/
public with sharing class Controller_SLKeyDataSummary {
	public User currentUser {get; set;}
	public boolean isExec {get;set;}
	public boolean isExceptionCaught {get;set;}
	public String Cmpn_no {get;set;}
	public boolean is_CC {get;set;}
	public boolean is_PC {get;set;}
	public List<SummaryData> info {get;set;}
	public List<SummaryDataExec> infoexec {get;set;}
	public List<LdrttlCount> leadercount {get;set;}
	public List<LdrttlCountExec> leadercountexec {get;set;}
	public String EUL {get;set;}
	public String TOTAL {get;set;}
	public String EXECTOTAL {get;set;}
	public boolean is_null_G0 {get;set;}
	public boolean is_null_G1 {get;set;}
	public boolean is_null_G2 {get;set;}
	public boolean is_null_G3 {get;set;}
	public boolean is_null_EG0 {get;set;}
	public boolean is_null_EG1 {get;set;}
	public boolean is_null_EG2 {get;set;}
	public boolean is_null_EG3 {get;set;}
	public boolean is_null_EG4PLUS {get;set;}
	public String disp_camp {get;set;}
	public boolean is_Mail_Plan {get;set;}
	public boolean Exec_ldr_ttl_available {get;set;}
	
	public Market__c market {get; set;}
	
	Map<String,Leader_Title__c> m_LeaderTitles = new Map<String,Leader_Title__c>();
	List<SummaryOverlay_Row_Config__c> sorc_list ;
	List<Contact> cont_list; 
	Set<String> mbset = new Set<String>();
	Set<String> ldrset = new Set<String>();
	String strquerycontact;
	String strquerymybusiness;
	String strqueryldrdwn;
	String strqueryavonrepperf;
	String obj_rel_to_query;	
	
    //changed for Object Model change:swarnava
    private void querybuilder(String colFld){
        Integer i = mbset.size();
	    mbset.add(colFld);
	    Integer j = mbset.size();
	    if(j > i)
	    	strqueryavonrepperf += colFld+',';
    } 
    
  	private String getvalue(String colFld,boolean avonrepperf_present){
        String strVal='';                       
        strVal = (avonrepperf_present)?String.valueOf(cont_list[0].getSObjects(obj_rel_to_query).get(0).get(colFld)):null;
        return strval;
    }
  
	private String calsum(String s,String s1,String s2,String s3,String s4) {
        Decimal sum = 0;
        Integer count_null = 0;
        if(s != null)
        	sum += Decimal.valueOf(s); 
        else count_null++;
        if(s1 != null)        
        	sum += Decimal.valueOf(s1); 
        else count_null++;
        if(s2 != null)
        	sum += Decimal.valueOf(s2); 
        else count_null++;
        if(s3 != null)
        	sum += Decimal.valueOf(s3); 
        else count_null++;
        if(s4 != null)
        	sum += Decimal.valueOf(s4); 
        else count_null++;        
        
        if(count_null==5)
        	return null;        	
        else 
        	return String.valueOf(sum);      
    }  
  
	Private String putcomma(String typ,String data){
 		if(typ == 'Number' && data != null){   
 	  		Decimal s = Decimal.valueOf(data);
      		return String.valueOf(s.format());
 		}
		else 
			return data;
	}      

	public pagereference getinitializeSupportData() {
      try{
	    boolean pp_present;
	    boolean ldr_present;
	    boolean avonrep_present;//added for object model change
	    ldrset.clear();
	    mbset.clear();
	    is_null_G0 = false;
	    is_null_G1 = false;
	    is_null_G2 = false;
	    is_null_G3 = false;
	    is_null_EG0 = false;
	    is_null_EG1 = false;
	    is_null_EG2 = false;
	    is_null_EG3 = false;
	    is_null_EG4PLUS = false;
	    isExceptionCaught = false;
	    is_Mail_Plan = false;
	    Exec_ldr_ttl_available = false;
	    
	    this.currentUser = [Select  Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                    LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,TRNDSTTR_IND__c,ACCT_NR__c,
                                    DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name,Is_Eligible__c,Opt_In__c,Out_of_Office__c,
                                    LDRSHP_TITL_LVL_NBR__c
                        From User
                        where Id = :UserInfo.getUserId()];
                            
        this.market = [Select  Id,SPPY_CMPGN_NR__c, PREV_1_CMPGN_NR__c, Name,LastModifiedDate, 
                                Market_Id__c, Mail_Plan_Enabled__c, CURRNT_CMPGN_RMN_DAY_CNT__c, 
                                CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_END_DT__c,ALM_Rep_Indicator__c,
                                LAST_UPDT_DT__c,GI3_Keep_Alive_URL__c,CURRENT_CAMPAIGN_NR__c,NEXT_1_CMPGN_NR__c,
                                Site_Maintenance_Enabled__c,Omniture_Suite_Name__c,Conditions_Of_Use_URL__c,
                                Security_and_Privacy_URL__c,eCard_Status_Message_Header__c,MailPlan_LndingPg_Deflt__c,
                                Campaign_Report_Override_URL__c,Is_ALMPLUS_Enabled__c,ALMPlus_Calendar__c,
                                Omniture_RSID__c,CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c,CURRNT_CMPGN_ONLN_RMN_DAY_CNT__c, NRT_Enabled__c
                       From    Market__c   
                       where   Market_Id__c =:currentUser.MRKT_ID__c];
                            
	    if(Cmpn_no >= market.CMPGN_NR__c && market.Mail_Plan_Enabled__c){
          	is_Mail_Plan = true;
      	}
      
        String strMktAcctKey = '';
        String strAcctKey = '';
        String strMktId = ''; 
        info = new List<SummaryData>();
        infoexec = new List<SummaryDataExec>();
        leadercount = new List<LdrttlCount>();
        leadercountexec = new List<LdrttlCountExec>();
        String impersonatedAcctNo = Apexpages.currentPage().getParameters().get('acctkey');
        
        if(impersonatedAcctNo != null)
        	impersonatedAcctNo = market.Market_Id__c + impersonatedAcctNo;
        
        if(String.isEmpty(cmpn_no))
        	cmpn_no = market.CMPGN_NR__c;
        else 
        	cmpn_no = cmpn_no.substring(cmpn_no.indexOf('_')+1);
        	
        if(market.CMPGN_NR__c == Cmpn_no){
        	is_CC = true;
        	is_PC = false;
        }
        else if(market.PREV_1_CMPGN_NR__c == Cmpn_no){
        	is_CC = false;
        	is_PC = true;
        }else{
        	is_CC = false;
        	is_PC = false;
        }
        obj_rel_to_query = market.ALM_Rep_Indicator__c.replace('__c','__r');
                       
        if(impersonatedAcctNo != null) {
            this.currentUser = [Select Name, MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, USER_CNTRY_CD__c, LastName, LanguageLocaleKey, 
                FirstName, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, ACCT_NR__c, Profile.Name, LDRSHP_TITL_LVL_NBR__c 
                From User where MRKT_ID_ACCT_NR_KEY__c = :impersonatedAcctNo];            
        }
        	
        strAcctKey = this.currentUser.ACCT_NR__c;
        strMktId = this.currentUser.MRKT_ID__c;
        String dt = market.LastModifiedDate.format('MM/dd/yy hh:mm a');
        disp_camp = ' '+cmpn_no.substring(4,6)+' '+cmpn_no.substring(0,4);
		
		List<Leader_title__c> Leader_Title = [Select Id, LDRSHP_TITL_LVL_NR__c, LANG_CD__c, LCL_LDRSHP_TITL_CD__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c, EXEC_IND__c 
			                                From Leader_Title__c 
			                                Where Market__c = :market.Id 
			                                and LANG_CD__c = :currentUser.LanguageLocaleKey 
			                                and LDRSHP_TITL_LVL_NR_NUMBER__c > -1 
			                                order by LDRSHP_TITL_LVL_NR__c asc];
			                                
        if(Leader_Title.size()>0){
			for(Leader_Title__c obj_Leader_Title : Leader_Title){
            	m_LeaderTitles.put(obj_Leader_Title.LDRSHP_TITL_LVL_NR__c, obj_Leader_Title);            
        	}
        }
       
        if(m_LeaderTitles.get(this.currentUser.LDRSHP_TITL_LVL_NBR__c).EXEC_IND__c == 'Y')
			isExec = true;
      
        sorc_list = [Select G0__c,G1__c,G2__c,G3__c,EG0__c,EG1__c,EG2__c,EG3__c,EG4PLUS__c,Is_Market_Tag__c,Data_Type__c,Executive_Data_Type__c,Row_Label__c,Executive_Row_Label__c
                 	From SummaryOverlay_Row_Config__c 
                 	where Market__c = :market.Id Order by Row_Order__c asc];
       
        strquerycontact = 'Select Id,';
        strquerymybusiness = '(Select Id,';
        strqueryldrdwn = '(Select Id,';
        strqueryavonrepperf = '(Select Id,';
      
        for(SummaryOverlay_Row_Config__c sorc : sorc_list){
       		if(!String.isEmpty(sorc.G0__c)){
       			querybuilder(sorc.G0__c);
       			is_null_G0 = true;
       		}
       		if(!String.isEmpty(sorc.G1__c)){
       			querybuilder(sorc.G1__c);
       			is_null_G1 = true;
       		}
       		if(!String.isEmpty(sorc.G2__c)){
       			querybuilder(sorc.G2__c);
       			is_null_G2 = true;
       		}
	        if(!String.isEmpty(sorc.G3__c)){
	        	querybuilder(sorc.G3__c);
	        	is_null_G3 = true;
	        }
	        if(!String.isEmpty(sorc.EG0__c)){
	        	querybuilder(sorc.EG0__c);
	        	is_null_EG0 = true;
	        }
	        if(!String.isEmpty(sorc.EG1__c)){
	        	querybuilder(sorc.EG1__c);
	        	is_null_EG1 = true;
	        }
	        if(!String.isEmpty(sorc.EG2__c)){
	        	querybuilder(sorc.EG2__c);
	        	is_null_EG2 = true;
	        }
	        if(!String.isEmpty(sorc.EG3__c)){
	        	querybuilder(sorc.EG3__c);
	        	is_null_EG3 = true;
	        }
	        if(!String.isEmpty(sorc.EG4PLUS__c)){
	        	querybuilder(sorc.EG4PLUS__c);
	        	is_null_EG4PLUS = true;
	        }
        }
        //Leaders by Title
        strqueryavonrepperf += 'GENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c,'; 
        for(Leader_title__c ldrttl : Leader_Title){ 
        	if(ldrttl.EXEC_IND__c != 'Y')        
        		strqueryavonrepperf += 'GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
       		else {
       			strqueryavonrepperf += 'EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
       		}
        }
        if(is_Mail_Plan)
       		strqueryavonrepperf += ' FROM '+obj_rel_to_query+' where FLD_SLS_CMPGN_NR__c IN '+'('+cmpn_no+','+market.PREV_1_CMPGN_NR__c+')'+' ORDER BY FLD_SLS_CMPGN_NR__c DESC)';
       	else
      		strqueryavonrepperf += ' FROM '+obj_rel_to_query+' where FLD_SLS_CMPGN_NR__c='+Cmpn_no+')';      
   		
   		strquerycontact += strqueryavonrepperf+' FROM Contact WHERE MRKT_ACCT_KEY__c=\''+this.currentUser.MRKT_ID_ACCT_NR_KEY__c+'\'';
	    strquerycontact = strquerycontact.replace(', FROM',' FROM');
	    List<sObject> temp1 = Database.query(strquerycontact);
	    cont_list = (List<Contact>)temp1;
	    
  		avonrep_present = (cont_list.size()>0)&&(cont_list[0].getSObjects(obj_rel_to_query)!=NULL);
  		
  		for(SummaryOverlay_Row_Config__c sorc:sorc_list){
        	SummaryData tempinfo = new SummaryData();
       		SummaryDataExec tempinfoexec = new SummaryDataExec();
       		tempinfo.G0 = (!String.isEmpty(sorc.G0__c)) ? getvalue(sorc.G0__c,avonrep_present) : null;
       		tempinfo.G1 = (!String.isEmpty(sorc.G1__c)) ? getvalue(sorc.G1__c,avonrep_present) : null;
       		tempinfo.G2 = (!String.isEmpty(sorc.G2__c)) ? getvalue(sorc.G2__c,avonrep_present) : null;
       		tempinfo.G3 = (!String.isEmpty(sorc.G3__c)) ? getvalue(sorc.G3__c,avonrep_present) : null;
       		if(sorc.Data_Type__c == 'Number')
       			tempinfo.sum = putcomma(sorc.Data_Type__c,calsum(tempinfo.G0,tempinfo.G1,tempinfo.G2,tempinfo.G3,null));
       		else 
       			tempinfo.sum = null;
   			
   			tempinfo.G0 = putcomma(sorc.Data_Type__c,tempinfo.G0);
   			tempinfo.G1 = putcomma(sorc.Data_Type__c,tempinfo.G1);
   			tempinfo.G2 = putcomma(sorc.Data_Type__c,tempinfo.G2);
   			tempinfo.G3 = putcomma(sorc.Data_Type__c,tempinfo.G3);
   			tempinfo.name_label = sorc.Row_Label__c;
   			tempinfoexec.EG0 = (!String.isEmpty(sorc.EG0__c)) ? getvalue(sorc.EG0__c,avonrep_present) : null;
   			tempinfoexec.EG1 = (!String.isEmpty(sorc.EG1__c)) ? getvalue(sorc.EG1__c,avonrep_present) : null;
  			tempinfoexec.EG2 = (!String.isEmpty(sorc.EG2__c)) ? getvalue(sorc.EG2__c,avonrep_present) : null;
  			tempinfoexec.EG3 = (!String.isEmpty(sorc.EG3__c)) ? getvalue(sorc.EG3__c,avonrep_present) : null;
   			tempinfoexec.EG4PLUS = (!String.isEmpty(sorc.EG4PLUS__c)) ? getvalue(sorc.EG4PLUS__c,avonrep_present) : null;
   			if(sorc.Executive_Data_Type__c == 'Number')
   				tempinfoexec.sumexec = putcomma(sorc.Executive_Data_Type__c,calsum(tempinfoexec.EG0,tempinfoexec.EG1,tempinfoexec.EG2,tempinfoexec.EG3,tempinfoexec.EG4PLUS));
   			else 
   				tempinfoexec.sumexec = null;
   				
   			tempinfoexec.EG0 = putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG0);
   			tempinfoexec.EG1 = putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG1);
   			tempinfoexec.EG2 = putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG2);
   			tempinfoexec.EG3 = putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG3);
   			tempinfoexec.EG4PLUS = putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG4PLUS);
   			tempinfoexec.name_label = sorc.Executive_Row_Label__c;
   			if(tempinfo.name_label != null)
   				info.add(tempinfo);
   			if(tempinfoexec.name_label != null)
   				infoexec.add(tempinfoexec);   			
   			
   		}
       	//Leaders by Title
        Integer inc1 = 1, sum = 0, sumexec = 0;
        for(Leader_title__c ldrttl : Leader_Title){
        	
        	if(ldrttl.EXEC_IND__c != 'Y'){
            	String fldname = 'GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
            	LdrttlCount leadercounttemp = new LdrttlCount();
            	leadercounttemp.name_label = ldrttl.LCL_LDRSHP_TITL_CD__c;
            	leadercounttemp.ttl_count = (avonrep_present) ? String.valueOf(cont_list[0].getSObjects(obj_rel_to_query).get(is_Mail_Plan ? 1 : 0).get(fldname)) : null;
            	leadercount.add(leadercounttemp);
            	sum += (leadercounttemp.ttl_count != null) ? Integer.valueOf(leadercounttemp.ttl_count) : 0;
            }else{
            	String fldname = 'EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
            	LdrttlCountExec leadercounttempexec = new LdrttlCountExec();
            	leadercounttempexec.name_label = ldrttl.LCL_LDRSHP_TITL_CD__c;
            	leadercounttempexec.ttl_count = (avonrep_present) ? String.valueOf(cont_list[0].getSObjects(obj_rel_to_query).get(is_Mail_Plan ? 1 : 0).get(fldname)) : null;
            	leadercountexec.add(leadercounttempexec);
            	sumexec += (leadercounttempexec.ttl_count != null) ? Integer.valueOf(leadercounttempexec.ttl_count) : 0;
            	Exec_ldr_ttl_available = true;
           }
        } 
        
        EXECTOTAL = String.valueOf(sumexec);       
        TOTAL = String.valueOf(sum+sumexec); 
     }catch(Exception e){
     	isExceptionCaught = true;
     }
     return null;
	}
	
    public class SummaryData{
		public String G0{set;get;}
        public String G1{set;get;}
        public String G2{set;get;}
        public String G3{set;get;}
        public String sum{set;get;}         
        public String name_label{set;get;}
    }
	
	public class SummaryDataExec{         
		public String EG0{set;get;}
		public String EG1{set;get;}
		public String EG2{set;get;}
		public String EG3{set;get;}
		public String EG4PLUS{set;get;}
		public String sumexec{set;get;}         
		public String name_label{set;get;}
    }
    
    public class LdrttlCount{
        public String name_label{set;get;}
        public String ttl_count{set;get;}
    }
    
    public class LdrttlCountExec{
        public String name_label{set;get;}
        public String ttl_count{set;get;}
    }
        
}