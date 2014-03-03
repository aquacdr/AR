/***************************************************************************
 Name           : Test_SOQLMonitoringBatch
 Madified By    : Barkha Jain (JDC)
 Description    : Test class for SOQLMonitoringBatch
 Modified Date  : Nov 8, 2013                
****************************************************************************/
@isTest
private class Test_SOQLMonitoringBatch {
	
	//----------------------------------------------------------------------------
    // Method Name  : testSOQLMonitoringFailure
    // Description  : Method for Test Coverage of Class : SOQLMonitoringBatch
    //----------------------------------------------------------------------------
    static testMethod void testSOQLMonitoringFailure() {
        //creating test data.
        List<SOQLQuery__c> soqlObjLst = new List<SOQLQuery__c>();
        soqlObjLst.add(new SOQLQuery__c(Name = 'TEST', SOQLQuery__c = null));
        soqlObjLst.add(new SOQLQuery__c(Name = 'TEST1', SOQLQuery__c = 'select id from X62_Genealogy__c'));
        insert soqlObjLst;
        
        Test.startTest();
        //testing failure scenario
        try{
			SOQLMonitoringBatch soqlMonitorinBatch = new SOQLMonitoringBatch();
    		Database.executeBatch(soqlMonitorinBatch, 200);
    	}catch(Exception e) {}
    	
    	SOQLMonitoringBatch.startJob();
    	Test.stopTest();
    	
        //verify result
	    system.assert([select count() from SOQLExecutionTime__c] == 0);
    	
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testSOQLMonitoringSuccess
    // Description  : Method for Test Coverage of Class : SOQLMonitoringBatch
    //----------------------------------------------------------------------------
    static testMethod void testSOQLMonitoringSuccess() {
    	//creating test data.
        List<SOQLQuery__c> soqlObjLst = new List<SOQLQuery__c>();
        soqlObjLst.add(new SOQLQuery__c(Name = 'TEST1', SOQLQuery__c = 'select id from X62_Genealogy__c'));
        insert soqlObjLst;
        
    	//testing Success scenario
	    try{
	    	SOQLMonitoringBatch soqlMonitorinBatch = new SOQLMonitoringBatch();
	    	Database.executeBatch(soqlMonitorinBatch, 200);
    	}catch(Exception e) {}
    	
    }
    
}