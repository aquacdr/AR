//udpated by SA 6/12/2012
public class DropdownComponentController  {
  public boolean impersonate {get;set;}
  public String userTitleNumber {get;set;}
  public String impersonatedAcctKey {get;set;}
  public String pgId {get;set;}
  public String marketId {get;set;}
  public String profileName {get;set;}
  public String currentReportType {get;set;}
  
    public List<SelectOption> getDropdownSelectOptions() {
      impersonatedAcctKey = ApexPages.currentPage().getParameters().get(ALMConstants.IMPERSON_PARAM_NAME);
      if(marketId == null) {
        return null;
      }
        List<SelectOption> listSelectOptions = getReportLinks(marketId, profileName, userTitleNumber, impersonate, impersonatedAcctKey, currentReportType);        
        return listSelectOptions;
    }
    
    //currentReportType - is report currently being viewed, i.e. item that should be excluded from the drop-down
    public List<SelectOption> getReportLinks(String marketId, String profileName, String userTitleNumber, Boolean impersonate, String impersonatedAcctKey, String currentReportType) {
    /*  System.debug('userTitleNumber: ' + userTitleNumber);
      System.debug('impersonatedAcctKey: ' + impersonatedAcctKey);
      System.debug('marketId: ' + marketId);
      System.debug('profileName: ' + profileName);
      System.debug('impersonate: ' + impersonate);
      System.debug('================= DropdownComponentController. impersonate: ' + impersonate);
      System.debug('================= DropdownComponentController. CurrentReportType: ' + currentReportType);*/
      impersonatedAcctKey = ApexPages.currentPage().getParameters().get(ALMConstants.IMPERSON_PARAM_NAME); //DO NOT remove this line
      pgId = ApexPages.currentPage().getParameters().get('pgId');
      
        List<SelectOption> listReports = new List<SelectOption>();
        
        // Change for defect id : 2400 - Raktim Sarkar - START 
       // listReports.add(new Selectoption('','Novalue'));
       // Change for defect id : 2400 - Raktim Sarkar - END
        //System.debug('\n.......   1 ');
        if( impersonate!=null && impersonate) {
          //System.debug('\n.......   1 impersonate ....... ');
          	if(pgId <> '1'){
            	listReports.add(new SelectOption('/apex/youhome?pgId=1&acctkey=' + impersonatedAcctKey, 'ALM_Home'));
          	}
            listReports.add(new SelectOption('javascript:viewRepDetail("'+impersonatedAcctKey+'");', 'Coaching_Record'));
        }
        //System.debug('\n.......   2  ....... ');
        //System.debug('\n getReportLinks impersonate '+impersonate);
        List<Report_Config__c> listReportConfigs = fetchReportLinks(marketId, profileName, userTitleNumber, impersonate);
        //System.debug('\n.......   3....... listReportConfigs size '+listReportConfigs.size()+' .. listReportConfigs \n '+listReportConfigs);
        if(listReportConfigs != null && listReportConfigs.size()>0) {
          //System.debug('\n.......   4 ');
            for(Report_Config__c rc : listReportConfigs) {
              //System.debug('\n.......   5 ....... ');
                //if(rc.Report_Type__c != currentReportType){
                    String reportURL = rc.Report_URL__c 
                                    + (rc.Report_URL__c !=null && rc.Report_URL__c.contains('?') ? '&' : '?')
                                    + (impersonate!=null && impersonate ? 'acctkey='+impersonatedAcctKey : '');
                   // System.debug('\n.......   6 ....... ');
                    // Change for defect id : 2400 - Raktim Sarkar - START     
                    if(currentReportType != null && !currentReportType.trim().equals('')){           
                      if(currentReportType.equals(ALMConstants.REPORT_TYPE_MYTEAM_REPORT)){   
                        if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_MYTEAM_REPCONFIG)                 
                          listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                          
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_MYTEAM_ORDER)){  
                        if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_MYTEAMORDER_REPCONFIG)                 
                          listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                          
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_G1SALESLEADERS)){  
                        if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_G1SALESLEADERS)                 
                          listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                          
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_G1CANDIDATES)){  
                        if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_G1CANDIDATES)                 
                          listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                          
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_RISINGSTARS)){  
                        if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_RISINGSTARS)                 
                          listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                          
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_G1APPT)){  
                        if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_G1APPT)                 
                          listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                          
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT)){  
                      if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_TITL_ADV_REPCONFIG)                 
                        listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_SL_GENEALOGY)){  
                      if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_SL_GENEALOGY)                 
                        listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                    }else if(currentReportType.equals(ALMConstants.REPORT_TYPE_EXEC_SL_GENEALOGY)){  // Added for My Exec Genealogy - Dropdown for Imprsn - Rajib 
                      if(rc.Report_Type__c != ALMConstants.REPORT_TYPE_EXEC_SL_GENEALOGY)                 
                        listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                    }
                    
                }else{
                  listReports.add(new Selectoption(reportURL, rc.Report_Type__c));
                }  
                    // Change for defect id : 2400 - Raktim Sarkar - END
                    
                //}
            }
        }
        //System.debug('\n.......   AFTER LOOP  ....... ');
        System.debug('listReports: ' + listReports);
        
        return listReports;
    }
    
    private List<Report_Config__c> fetchReportLinks(String mktId, String userProfileName, String userTitleNbr, Boolean isImpersonation){
        String query = 'Select r.TITL_LVL_NBR__c, r.Report_URL__c, r.Report_Type__c, r.Report_Id__c, r.Name, r.Report_Sequence__c,' + 
                       ' r.Market__r.Market_Id__c, r.Market__c, r.Id, r.Applicable_to__c From Report_Config__c r ';
                       
        String whereClause = ' where r.Market__r.Market_Id__c =: mktId AND Applicable_to__c INCLUDES (:userProfileName) AND TITL_LVL_NBR__c INCLUDES (:userTitleNbr) AND r.Report_Sequence__c>-1';//changed by swarnava for Team List
        if(isImpersonation)
            whereClause += ' AND Is_Impersonation_Applicable__c = true ';
        whereClause += ' order by r.Report_Sequence__c asc';
        query += whereClause;
        
        System.debug('\n query : ' + query);
        return (List<Report_Config__c>) Database.query(query);
    }
    
    
    
}