public class SummaryOverlayController{
public User currentUser {get; set;}
public String currUserLanguage{get;set;}
public List<SummaryOverlay_Row_Config__c> sorc_list{get;set;}
public Map<String,Leader_Title__c> m_LeaderTitles = new Map<String,Leader_Title__c>();
public boolean isExec{get;set;}
public boolean isExceptionCaught{get;set;}
public PageReference errPage {get; set;}
public String Cmpn_no{get;set;}
public boolean is_CC{get;set;}
public boolean is_PC{get;set;}
public List<SummaryData> info{get;set;}
public List<SummaryDataExec> infoexec{get;set;}
public List<LdrttlCount> leadercount{get;set;}
public List<LdrttlCountExec> leadercountexec{get;set;}
public List<Contact> cont_list{get;set;} 
public String EUL{get;set;}
public String EL{get;set;}
public String SEL1{get;set;}
public String SEL2{get;set;}
public String SEL3{get;set;}
public String TOTAL{get;set;}
public String EXECTOTAL{get;set;}
public SiteHeaderController shc{get; set;}
String strquerycontact;
String strquerymybusiness;
String strqueryldrdwn;
String strqueryavonrepperf;//added by object model change
public String obj_rel_to_query;//added by object model change
Set<String> mbset=new Set<String>();
Set<String> ldrset=new Set<String>();
public boolean is_null_G0{get;set;}
public boolean is_null_G1{get;set;}
public boolean is_null_G2{get;set;}
public boolean is_null_G3{get;set;}
public boolean is_null_EG0{get;set;}
public boolean is_null_EG1{get;set;}
public boolean is_null_EG2{get;set;}
public boolean is_null_EG3{get;set;}
public boolean is_null_EG4PLUS{get;set;}
public String dt{get;set;}
public String disp_camp{get;set;}
public boolean is_Mail_Plan{get;set;}
public boolean Exec_ldr_ttl_available{get;set;}


    //changed for Object Model change:swarnava
    private void querybuilder(String colFld)
    {
        Integer i=mbset.size();
            mbset.add(colFld);
            Integer j=mbset.size();
            if(j>i)
            strqueryavonrepperf+=colFld+',';
    } 
    
  private String getvalue(String colFld,boolean avonrepperf_present){
         String strVal='';                       
            strVal=(avonrepperf_present)?String.valueOf(cont_list[0].getSObjects(obj_rel_to_query).get(0).get(colFld)):null;
        return strval;
        }
  
private String calsum(String s,String s1,String s2,String s3,String s4) {
        Decimal sum=0;
        Integer count_null=0;
        if(s!=null)
        //sum+=Math.floor(Decimal.valueOf(s)); else count_null++; //change to show decimal by AG 11-Nov
        sum+=Decimal.valueOf(s); else count_null++;
        if(s1!=null)
        //sum+=Math.floor(Decimal.valueOf(s1)); else count_null++;
        sum+=Decimal.valueOf(s1); else count_null++;
        if(s2!=null)
        //sum+=Math.floor(Decimal.valueOf(s2)); else count_null++;
        sum+=Decimal.valueOf(s2); else count_null++;
        if(s3!=null)
        //sum+=Math.floor(Decimal.valueOf(s3)); else count_null++;
        sum+=Decimal.valueOf(s3); else count_null++;
        if(s4!=null)
        //sum+=Math.floor(Decimal.valueOf(s4)); else count_null++; 
        sum+=Decimal.valueOf(s4); else count_null++;
        
        if(count_null==5)
        return null;
        else return String.valueOf(sum/*.setScale(2)*/);      
  }  
  
Private String putcomma(String typ,String data)
{
 if(typ=='Number' && data!=null)
 {    Decimal s = Decimal.valueOf(data);
      //return String.valueOf(Math.floor(s).format()); //change to show decimal by AG 11-Nov
      return String.valueOf(s.format());
 }
else return data;
}      

public pagereference getinitializeSupportData() {
      try{
      boolean pp_present;
      boolean ldr_present;
      boolean avonrep_present;//added for object model change
      ldrset.clear();
      mbset.clear();
      is_null_G0=false;
      is_null_G1=false;
      is_null_G2=false;
      is_null_G3=false;
      is_null_EG0=false;
      is_null_EG1=false;
      is_null_EG2=false;
      is_null_EG3=false;
      is_null_EG4PLUS=false;
      isExceptionCaught=false;
      is_Mail_Plan=false;
      Exec_ldr_ttl_available=false;
      System.debug('inside getinitializeSupportData***----');
      if(Cmpn_no>= shc.market.CMPGN_NR__c && shc.market.Mail_Plan_Enabled__c)
      {
        //Cmpn_no='('+shc.market.CMPGN_NR__c+','+shc.market.PREV_1_CMPGN_NR__c+')';
        is_Mail_Plan=true;
      }
      System.debug('campaign_no--->'+Cmpn_no);
        String strMktAcctKey = '';
        String strAcctKey = '';
        String strMktId = ''; 
        info=new List<SummaryData>();
        infoexec=new List<SummaryDataExec>();
        leadercount=new List<LdrttlCount>();
        leadercountexec=new List<LdrttlCountExec>();
        String impersonatedAcctNo=Apexpages.currentPage().getParameters().get('acctkey');
        if(impersonatedAcctNo!=null)
        impersonatedAcctNo=shc.market.Market_Id__c+impersonatedAcctNo;
        System.debug('campaign_number-->'+cmpn_no);
        if(String.isEmpty(cmpn_no))
        cmpn_no=shc.market.CMPGN_NR__c;
        else cmpn_no=cmpn_no.substring(cmpn_no.indexOf('_')+1);
        if(shc.market.CMPGN_NR__c==Cmpn_no)
        {is_CC=true;is_PC=false;}
        else if(shc.market.PREV_1_CMPGN_NR__c==Cmpn_no)
        {is_CC=false;is_PC=true;}
        else
        {is_CC=false;is_PC=false;}
       // System.debug('campaign_number-->'+cmpn_no);   
      // obj_rel_to_query='ALM_Rep_Performance_'+shc.market.ALM_Rep_Indicator__c+'__r';
         obj_rel_to_query=shc.market.ALM_Rep_Indicator__c.replace('__c','__r');
          System.debug('child rel to query-->'+obj_rel_to_query);  
                       
        if(/*this.currentUser == null && */impersonatedAcctNo!=null) {
            this.currentUser = [Select Name, MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, USER_CNTRY_CD__c, LastName, LanguageLocaleKey, 
                FirstName, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c, DFALT_DIV_NM__c, ACCT_NR__c, Profile.Name, LDRSHP_TITL_LVL_NBR__c 
                From User where MRKT_ID_ACCT_NR_KEY__c = :impersonatedAcctNo];            
        }
        else this.currentUser=shc.currUsr;
        strAcctKey = this.currentUser.ACCT_NR__c;
        strMktId = this.currentUser.MRKT_ID__c;
        currUserLanguage=this.currentUser.LanguageLocaleKey;
        dt=shc.market.LastModifiedDate.format('MM/dd/yy hh:mm a');
        disp_camp=' '+cmpn_no.substring(4,6)+' '+cmpn_no.substring(0,4);

        List<Leader_title__c>Leader_Title = [Select Id,LDRSHP_TITL_LVL_NR__c,LANG_CD__c,LCL_LDRSHP_TITL_CD__c,LCL_LDRSHP_TITL_LANG_DESC_TXT__c,EXEC_IND__c 
                                From 
                                    Leader_Title__c 
                                Where 
                                    Market__c =:shc.market.Id and LANG_CD__c=:currUserLanguage and LDRSHP_TITL_LVL_NR_NUMBER__c>-1 order by LDRSHP_TITL_LVL_NR__c asc];
                                    
             if(Leader_Title.size()>0){
                for(Leader_Title__c obj_Leader_Title : Leader_Title){
                    m_LeaderTitles.put(obj_Leader_Title.LDRSHP_TITL_LVL_NR__c,obj_Leader_Title);
                    
                }
       }
       if(m_LeaderTitles.get(this.currentUser.LDRSHP_TITL_LVL_NBR__c).EXEC_IND__c == 'Y')
       isExec=true;
      /* if(m_LeaderTitles.get(this.currentUser.LDRSHP_TITL_LVL_NBR__c).EXEC_IND__c == 'Y')     */  
       sorc_list=[Select G0__c,G1__c,G2__c,G3__c,EG0__c,EG1__c,EG2__c,EG3__c,EG4PLUS__c,Is_Market_Tag__c,Data_Type__c,Executive_Data_Type__c,Row_Label__c,Executive_Row_Label__c
                 From SummaryOverlay_Row_Config__c 
                 where Market__c=:shc.market.Id Order by Row_Order__c asc];
       System.debug('abcd-->'+shc.market.Market_Id__c);
       
       strquerycontact='Select Id,';
       strquerymybusiness='(Select Id,';
       strqueryldrdwn='(Select Id,';
       strqueryavonrepperf='(Select Id,';
      
       for(SummaryOverlay_Row_Config__c sorc:sorc_list)
       {
       if(!String.isEmpty(sorc.G0__c))       
       {querybuilder(sorc.G0__c);is_null_G0=true;}
       if(!String.isEmpty(sorc.G1__c))
       {querybuilder(sorc.G1__c);is_null_G1=true;}
       if(!String.isEmpty(sorc.G2__c))
       {querybuilder(sorc.G2__c);is_null_G2=true;}
       if(!String.isEmpty(sorc.G3__c))
       {querybuilder(sorc.G3__c);is_null_G3=true;}
       if(!String.isEmpty(sorc.EG0__c))
       {querybuilder(sorc.EG0__c);is_null_EG0=true;}
       if(!String.isEmpty(sorc.EG1__c))
       {querybuilder(sorc.EG1__c);is_null_EG1=true;}
       if(!String.isEmpty(sorc.EG2__c))
       {querybuilder(sorc.EG2__c);is_null_EG2=true;}
       if(!String.isEmpty(sorc.EG3__c))
       {querybuilder(sorc.EG3__c);is_null_EG3=true;}
       if(!String.isEmpty(sorc.EG4PLUS__c))
       {querybuilder(sorc.EG4PLUS__c);is_null_EG4PLUS=true;}
       }
       //Leaders by Title
       strqueryavonrepperf+='GENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c,'; 
      // Integer inc=1;
       for(Leader_title__c ldrttl:Leader_Title)
       { if(ldrttl.EXEC_IND__c!='Y')        
       strqueryavonrepperf+='GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
       else 
       {strqueryavonrepperf+='EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c,';
       /*inc++;*/}
       }
       if(is_Mail_Plan)
       strqueryavonrepperf+=' FROM '+obj_rel_to_query+' where FLD_SLS_CMPGN_NR__c IN '+'('+cmpn_no+','+shc.market.PREV_1_CMPGN_NR__c+')'+' ORDER BY FLD_SLS_CMPGN_NR__c DESC)';
       else
      // strquerymybusiness+=' FROM My_Businesses__r where FLD_SLS_CMPGN_NR__c='+Cmpn_no+')';
       strqueryavonrepperf+=' FROM '+obj_rel_to_query+' where FLD_SLS_CMPGN_NR__c='+Cmpn_no+')';      
       strquerycontact+=strqueryavonrepperf+' FROM Contact WHERE MRKT_ACCT_KEY__c=\''+this.currentUser.MRKT_ID_ACCT_NR_KEY__c+'\'';
       strquerycontact=strquerycontact.replace(', FROM',' FROM');
       System.debug('query-->'+strquerycontact);
       List<sObject> temp1=Database.query(strquerycontact);
       cont_list=(List<Contact>)temp1;
      // pp_present=(cont_list.size()>0)&&(cont_list[0].My_Businesses__r.size()>0);
     //  ldr_present=(cont_list.size()>0)&&(cont_list[0].Leadership_Summary__r.size()>0);
       avonrep_present=(cont_list.size()>0)&&(cont_list[0].getSObjects(obj_rel_to_query)!=NULL);
      // System.debug('contact returned-->'+String.valueOf(cont_list[0].My_Businesses__r[0].get('PRSNL_SLS_AMT__c')));
       for(SummaryOverlay_Row_Config__c sorc:sorc_list)
       {System.debug('field-->'+sorc.G0__c);
       System.debug('insideloop');               
       SummaryData tempinfo=new SummaryData();
       SummaryDataExec tempinfoexec=new SummaryDataExec();
       tempinfo.G0=(!String.isEmpty(sorc.G0__c))?getvalue(sorc.G0__c,avonrep_present):null;
       //if(tempinfo.G0!=null) is_null_G0=true;
       tempinfo.G1=(!String.isEmpty(sorc.G1__c))?getvalue(sorc.G1__c,avonrep_present):null;
       //if(tempinfo.G1!=null) is_null_G1=true;
       tempinfo.G2=(!String.isEmpty(sorc.G2__c))?getvalue(sorc.G2__c,avonrep_present):null;
       //if(tempinfo.G2!=null) is_null_G2=true;
       tempinfo.G3=(!String.isEmpty(sorc.G3__c))?getvalue(sorc.G3__c,avonrep_present):null;
       //if(tempinfo.G3!=null) is_null_G3=true;
       if(sorc.Data_Type__c == 'Number')
       tempinfo.sum=putcomma(sorc.Data_Type__c,calsum(tempinfo.G0,tempinfo.G1,tempinfo.G2,tempinfo.G3,null));
       else tempinfo.sum=null;
       tempinfo.G0=putcomma(sorc.Data_Type__c,tempinfo.G0);
       tempinfo.G1=putcomma(sorc.Data_Type__c,tempinfo.G1);
       tempinfo.G2=putcomma(sorc.Data_Type__c,tempinfo.G2);
       tempinfo.G3=putcomma(sorc.Data_Type__c,tempinfo.G3);
       tempinfo.name_label=sorc.Row_Label__c;
       tempinfoexec.EG0=(!String.isEmpty(sorc.EG0__c))?getvalue(sorc.EG0__c,avonrep_present):null;
       //if(tempinfoexec.EG0!=null) is_null_EG0=true;
       tempinfoexec.EG1=(!String.isEmpty(sorc.EG1__c))?getvalue(sorc.EG1__c,avonrep_present):null;
      // if(tempinfoexec.EG1!=null) is_null_EG1=true;
       tempinfoexec.EG2=(!String.isEmpty(sorc.EG2__c))?getvalue(sorc.EG2__c,avonrep_present):null;
      // if(tempinfoexec.EG2!=null) is_null_EG2=true;
       tempinfoexec.EG3=(!String.isEmpty(sorc.EG3__c))?getvalue(sorc.EG3__c,avonrep_present):null;
       //if(tempinfoexec.EG3!=null) is_null_EG3=true;
       tempinfoexec.EG4PLUS=(!String.isEmpty(sorc.EG4PLUS__c))?getvalue(sorc.EG4PLUS__c,avonrep_present):null;
       //if(tempinfoexec.EG4PLUS!=null) is_null_EG4PLUS=true;
       if(sorc.Executive_Data_Type__c == 'Number')
       tempinfoexec.sumexec=putcomma(sorc.Executive_Data_Type__c,calsum(tempinfoexec.EG0,tempinfoexec.EG1,tempinfoexec.EG2,tempinfoexec.EG3,tempinfoexec.EG4PLUS));
       else tempinfoexec.sumexec=null;
       System.debug('sorc.Executive_Data_Type__c --> '+sorc.Executive_Data_Type__c+' '+tempinfoexec.EG0);
       tempinfoexec.EG0=putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG0);
       System.debug('tempinfoexec.EG0 --> '+tempinfoexec.EG0);
       tempinfoexec.EG1=putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG1);
       tempinfoexec.EG2=putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG2);
       tempinfoexec.EG3=putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG3);
       tempinfoexec.EG4PLUS=putcomma(sorc.Executive_Data_Type__c,tempinfoexec.EG4PLUS);
       tempinfoexec.name_label=sorc.Executive_Row_Label__c;
       if(tempinfo.name_label!=null)
       info.add(tempinfo);
       if(tempinfoexec.name_label!=null)
       infoexec.add(tempinfoexec);
       }
       System.debug('is_null_G1'+is_null_G1);
       //Leaders by Title
        /*Candidate=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].GENRTN_1_TITL_0_STF_CNT__c):null;
        UL=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].GENRTN_1_TITL_1_STF_CNT__c):null;
        AUL=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].GENRTN_1_TITL_2_STF_CNT__c):null;*/
        Integer inc1=1,sum=0,sumexec=0;
        for(Leader_title__c ldrttl:Leader_Title)
        { 
            if(ldrttl.EXEC_IND__c!='Y')                
            {String fldname='GENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
            LdrttlCount leadercounttemp=new LdrttlCount();
            leadercounttemp.name_label=ldrttl.LCL_LDRSHP_TITL_CD__c;
            leadercounttemp.ttl_count=(avonrep_present)?String.valueOf(cont_list[0].getSObjects(obj_rel_to_query).get(is_Mail_Plan?1:0).get(fldname)):null;
            leadercount.add(leadercounttemp);
            sum+=(leadercounttemp.ttl_count!=null)?Integer.valueOf(leadercounttemp.ttl_count):0;}
            else
            {String fldname='EXGENRTN_1_TITL_'+ldrttl.LDRSHP_TITL_LVL_NR__c+'_STF_CNT__c';
            LdrttlCountExec leadercounttempexec=new LdrttlCountExec();
            leadercounttempexec.name_label=ldrttl.LCL_LDRSHP_TITL_CD__c;
            leadercounttempexec.ttl_count=(avonrep_present)?String.valueOf(cont_list[0].getSObjects(obj_rel_to_query).get(is_Mail_Plan?1:0).get(fldname)):null;
            leadercountexec.add(leadercounttempexec);
            sumexec+=(leadercounttempexec.ttl_count!=null)?Integer.valueOf(leadercounttempexec.ttl_count):0;
            Exec_ldr_ttl_available=true;
           /* inc1++;*/}
        } 
        EXECTOTAL=String.valueOf(sumexec);       
        //EUL=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].GENRTN_1_TOTAL_EXEC_TITL_STF_CNT__c):null;
        TOTAL=String.valueOf(sum+sumexec);//Total of Leaders
        //TOTAL=String.valueOf(sum+((EUL!=null)?Integer.valueOf(EUL):0));//Total of Leaders
        /*EL=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].EXGENRTN_1_TITL_1_STF_CNT__c):null;
        SEL1=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].EXGENRTN_1_TITL_2_STF_CNT__c):null;
        SEL2=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].EXGENRTN_1_TITL_3_STF_CNT__c):null;
        SEL3=(ldr_present)?String.valueOf(cont_list[0].Leadership_Summary__r[0].EXGENRTN_1_TITL_4_STF_CNT__c):null;*/
        //TOTAL=calsum(Candidate,UL,AUL,EUL,null);
        
      // sorc=[Select Current_Campaign_Fld__c,Is_Market_Tag__c from SummaryOverlay_Row_Config__c where Market__c=:mrktId];
     // System.debug('infoexec-->'+infoexec[0].EG0);
     // System.debug('infoG0-->'+info[0].G0); 
     }catch(Exception e){
     // String errorId = ErrorHandler.handleError(e.getMessage());
     isExceptionCaught=true;
     System.debug('exception-->'+e.getMessage()+e.getLineNumber());
          //  errPage = Page.ErrorPage;
          //  errPage.getParameters().put('errId',errorId);
           // return errPage;
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
    
    //@T-214186 : Commented by Barkha Jain on Nov 21
    /*@isTest(SeeAllData=true)  
     public static void testSummaryOverlay()
    {
        String mktIdKey = 'XX';
        
        // Creating instance of TestDataHelper.
        TestDataHelper testData = new TestDataHelper();
        
        // Creating Market record
        Market__c mrkt = testData.createMarket();
        Account testAcct;
        // Creating User record
        User testUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {         
            testUsr = testData.createLeaderUser(mktIdKey);
            testUsr.LDRSHP_TITL_LVL_NBR__c='4';
            update testUsr;
            testAcct = new Account(Name='Test Acount',OwnerId=testUsr.Id);
            insert testAcct;
            // Updating Market record with User's Id
            mrkt.OwnerId = testUsr.Id;
            mrkt.ALM_Rep_Indicator__c='ALM_Rep_Performance_1__c';
            update  mrkt;
        }
        //Create contact along with ALM_Rep_Performance Data:Start
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(mrkt.ALM_Rep_Indicator__c);
        sObject s=targetType.newSObject();
        //s.put('GRP_ACTV_REP_CNT__c',876);
        s.put('EXGENRTN_1_GRP_ACTV_REP_CNT__c',234);
        s.put('GENTRTN_3_ACTV_REP_CNT__c',612);
        s.put('Name','Test');
        s.put('FLD_SLS_CMPGN_NR__c',Decimal.valueOf(testData.market.CMPGN_NR__c));
        s.put('MRKT_ACCT_KEY__c',Database.insert(new Contact(LastName='Test Contact',MRKT_ACCT_KEY__c=mrkt.Market_Id__c+testUsr.ACCT_NR__c,AccountId=testAcct.Id,OwnerId=testUsr.Id),false).getId());
        insert s;
        

        // Creating leder titles record.
        testData.createLeaderTitles();  
        for(Integer i=0;testData.titles.size()>i;i++)
        {if(testData.titles[i].LDRSHP_TITL_LVL_NR_NUMBER__c>2 && testData.titles[i].LDRSHP_TITL_LVL_NR_NUMBER__c<8)  testData.titles[i].EXEC_IND__c='Y';
        else  testData.titles[i].EXEC_IND__c='N'; }  //Setting Executives titles to be greater than 2
        update testData.titles;
        SummaryOverlay_Row_Config__c smrc= new SummaryOverlay_Row_Config__c(EG0__c='GRP_ACTV_REP_CNT__c',EG1__c='EXGENRTN_1_GRP_ACTV_REP_CNT__c',EG2__c='EXGENRTN_2_GRP_ACTV_REP_CNT__c',EG3__c='EXGENRTN_3_GRP_ACTV_REP_CNT__c',
        EG4PLUS__c='EXGENRTN_4PLUS_GRP_ACTV_REP_CNT__c',G0__c='PRSNL_SLS_AMT__c',G1__c='GENTRTN_1_ACTV_REP_CNT__c',G2__c='GENTRTN_2_ACTV_REP_CNT__c',G3__c='GENTRTN_3_ACTV_REP_CNT__c',Market__c=testData.market.Id,Row_Label__c='Actives',
        Executive_Row_Label__c='Actives',Data_Type__c='Number',Executive_Data_Type__c='Number');
        insert smrc;
        SummaryOverlayController ctlr ;
        
        System.runAs(testUsr)
        {
        ctlr = new SummaryOverlayController();
        ctlr.Cmpn_no=testData.market.CMPGN_NR__c;
        ctlr.shc= new SiteHeaderController();
        ctlr.shc.init();
        ctlr.getinitializeSupportData();
        System.assert((ctlr.cont_list.size()>0)&&(ctlr.cont_list[0].getSObjects(ctlr.obj_rel_to_query)!=NULL));
       // System.assert((ctlr.cont_list.size()>0)&&(ctlr.cont_list[0].My_Businesses__r.size()>0));
       // System.assert((ctlr.cont_list.size()>0)&&(ctlr.cont_list[0].Leadership_Summary__r.size()>0));        
        }
    }*/
}