/***************************************************************************
 Name          : ReportFiltersController 
 Created By    : Parul Gupta
 Description   : Displays report filters as per passed filters 
 Created Date  : Jan 6, 2014               
****************************************************************************/
public with sharing class ReportFiltersController {
    
    public List<ReportFilter> filters {get;set;}    
    public List<SelectOption> titleList = new List<SelectOption>();
    public List<SelectOption> generationList = new List<SelectOption>();
    public Market__c market {get;set;}
    public String selectedReportOption {get;set;}
    public List<SelectOption> reportOptions {get;set;}
    
    //==============================================================================================//
    //Use cached data from Leader_Title__c to provide a list of SelectOptions for the different Leader Title levels
    //==============================================================================================//    
  	public List<SelectOption> getTitleList() {
        //Initialize the list of titles
        User currentUser = [SELECT Id, Profile.Name, MRKT_ID__c, ACCT_NR__c, DFALT_DIV_NM__c, DFALT_ZONE_CD__c, User.LanguageLocaleKey, UserRole.Name 
                from User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        titleList.add(new SelectOption('0,1,2,3,4', 'All Paid Titles'));
        for(Leader_Title__c t : [Select t.Market__c, t.LANG_CD__c, t.LDRSHP_TITL_LVL_NR__c, t.LDRSHP_TITL_LVL_NR_NUMBER__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c
                          From Leader_Title__c t
                          where LANG_CD__c = :currentUser.LanguageLocaleKey
                          and Market__c = :this.market.Id
                          order by Market__c, LANG_CD__c, LDRSHP_TITL_LVL_NR_NUMBER__c]) {
          titleList.add(new SelectOption(t.LDRSHP_TITL_LVL_NR__c, t.LCL_LDRSHP_TITL_LANG_DESC_TXT__c));
         }
        return titleList;
    }  
    public List<SelectOption> getGenerationList(){
    	String sAllValue='';
    	for(Integer iCount=0;iCount<=9;iCount++){
    		sAllValue+=String.valueOf(iCount)+',';
    	}
    	sAllValue+='10';
    	generationList.add(new SelectOption(sAllValue,'All'));
      	for(Integer iCount=0;iCount<=10;iCount++){
      		generationList.add(new SelectOption(String.ValueOf(iCount),String.ValueOf(iCount)));
      	}   
      	return generationList;
    }  
         
}