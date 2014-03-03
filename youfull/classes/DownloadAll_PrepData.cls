/**
 * Primary purpose of this class is set to gen index of the logged in user or the impersonating user on the
 * hierarchical custom settings, so that the formula to compute the relative gen index would be updated.
 * 
 */
public without sharing class DownloadAll_PrepData {
	 
	public PageReference updateUserGenIndex(){
	    
	    System.debug('===STARTED CONSTRUCTOR===');
	    
		String acctKey = Apexpages.currentPage().getParameters().get('acctKey');
        String accountNumber='';
        System.debug('===AFTER acctKey===' + acctKey);
	    
      
	    
        List<SObject> repRecords;
         
        //read the logged in user's information from hierarchical custom setting
          DownloadAll_GenIndex__c genIndexCustomSetting=DownloadAll_GenIndex__c.getOrgDefaults();  
          
        String selectedCampaign=genIndexCustomSetting.SelectedCampaign__c;
        System.debug('===AFTER selectedcampaign===' + selectedCampaign);
        
        if(acctKey!=null && acctKey.length()>0){
        	//set the impersonation user's account number as the account number
        	accountNumber=acctKey;
        }
        else{
        	accountNumber=genIndexCustomSetting.Accnt_Nr__c;
        }
        System.debug('===AFTER accountNumber===' + accountNumber);
        //query the alm rep performance record to get the genealogy level
        String repPerfQuery='select Genealogy_Level__c from ' + genIndexCustomSetting.Data_Object_Name__c + ' where OPERTNL_CMPGN_NR__c =\'' + selectedCampaign + '\' and MRKT_ID__c =\'' + genIndexCustomSetting.Market_Id__c + '\' and ACCT_NR__c=\'' + accountNumber + '\' limit 1'; 
	    
	    System.debug('===REP PERFORMANCE QUERY IS=====' +repPerfQuery);
	    
	    try{
	    	repRecords=Database.query(repPerfQuery);
	    }
	    
	    catch(Exception e){
	    	System.debug('====Download All Gen Index Query Exception====' + e);
	    }
	    
	    if(repRecords!=null && repRecords.size()==1){
	    	  Decimal genLevel=(Decimal)repRecords.get(0).get('Genealogy_Level__c');
	          genIndexCustomSetting.Gen_Index__c=genLevel;
	          update genIndexCustomSetting;
	    }
	  return null;
	}

}