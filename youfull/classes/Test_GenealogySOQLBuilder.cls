/***************************************************************************
 Name          : Test_GenealogySOQLBuilder
 Created By    : Barkha Jain (JDC)
 Description   : Test class for GenealogySOQLBuilder
 Created Date  : Nov 1, 2013                
****************************************************************************/
@isTest
private class Test_GenealogySOQLBuilder {
    static User usr;
    static String mrktId = '62';
    static Set<String> queryFieldSet;
    static Map<String, String> queryOptionsMap;
    
    //----------------------------------------------------------------------------
    // Method Name  : testGenealogySOQLBuilder
    // Description  : Method for Test Coverage of Class : GenealogySOQLBuilder
    //----------------------------------------------------------------------------
    static testMethod void testGenealogySOQLBuilder() {
        createTestData();
        
        Test.startTest();        
        GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId);
        builder = new GenealogySOQLBuilder(usr.Id);
        builder = new GenealogySOQLBuilder(usr.Id, queryFieldSet);
        builder = new GenealogySOQLBuilder(mrktId, queryFieldSet);
        builder = new GenealogySOQLBuilder(mrktId, '1234', queryFieldSet);
        
        builder.query('CMPGN_NR__c = \'201304\'');
        builder.query('CMPGN_NR__c = \'201304\'', 'Name');
        builder.query('CMPGN_NR__c = \'201304\'', 'Name', '1');
        
        //verify results
        system.assert(GenealogySOQLBuilder.isAcctNrInDownline('12341', '1234', '201304', mrktId));
        system.assert(GenealogySOQLBuilder.isAcctNrInDownline('1234', '1234', '201304', mrktId));
        system.assert(!(GenealogySOQLBuilder.isAcctNrInDownline('12341', '12342', '201304', mrktId)));
        
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : testGenerateQuerySelect
    // Description  : Method for Test Coverage GenerateQuerySelect Method
    //----------------------------------------------------------------------------
    static testMethod void testGenerateQuerySelect() {
        createTestData();
        
        try{
            GenealogySOQLBuilder builder = new GenealogySOQLBuilder('', queryFieldSet);
            builder.generateQuerySelect(queryOptionsMap);
        }catch(Exception e){ 
        	//verify exception   
            system.assert(e.getMessage().contains('marketId is empty.'));       
        }
        try{
            GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId, null);
            builder.generateQuerySelect(queryOptionsMap);
        }catch(Exception e){  
        	//verify exception  
            system.assert(e.getMessage().contains('queryFieldSet is empty.'));          
        }
        try{
            GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId, queryFieldSet);
            builder.generateQuerySelect(queryOptionsMap);
        }catch(Exception e){  
        	//verify exception  
            system.assert(e.getMessage().contains('queryOptionsMap is empty.'));        
        }
        try{
            GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId, queryFieldSet);
            builder.generateQuerySelect(queryOptionsMap);
        }catch(Exception e){  
        	//verify exception  
            system.assert(e.getMessage().contains('queryOptionsMap is empty.'));        
        }
        queryOptionsMap.put('abc', 'abc');
        try{
            GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId, queryFieldSet);
            builder.generateQuerySelect(queryOptionsMap);
        }catch(Exception e){ 
        	//verify exception   
            system.assert(e.getMessage().contains('Please check this option again.  Invalid casing can cause this error also.'));       
        }
        queryOptionsMap.remove('abc');
        queryOptionsMap.put('WITH', '');
        try{
            GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId, queryFieldSet);
            builder.generateQuerySelect(queryOptionsMap);
        }catch(Exception e){
        	//verify exception  
            system.assert(e.getMessage().contains('no valid data was found.'));         
        }
        queryOptionsMap.remove('WITH');
        GenealogySOQLBuilder builder = new GenealogySOQLBuilder(mrktId, queryFieldSet);
        builder.generateQuerySelect(queryOptionsMap);
        //verify result 
        system.assertEquals(1, builder.query(queryOptionsMap).size());
        
    }
    
    //----------------------------------------------------------------------------
    // Method Name  : createTestData
    // Description  : Method for creating dummy test data
    //----------------------------------------------------------------------------
    static void createTestData(){
        TestDataHelper.createALMGlobalSetting(true);
        usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = mrktId;
        insert usr;
        
        system.runAs(usr){
            Market__c mrkt = TestDataHelper.createMarket(mrktId, true);
        }
        
        Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
	    Contact c = TestDataHelper.createContact('1234', acc.Id, false);
	    c.MRKT_ACCT_KEY__c = mrktId + '1234';
	    insert c;
	    
        X62_Genealogy__c x = new X62_Genealogy__c();        
        x.UPLN_ACCT_NR__c = '12341'; 
        x.Name = 'test';
        x.Market_ID__c = mrktId;
        x.Genealogy_Key__c = '12';
        x.CMPGN_NR__c = '201304';
        x.ACCT_NR__c = '1234';
        x.Contact_Key__c = c.Id;
        insert x;
        
        queryFieldSet = new Set<String>();
        queryFieldSet.add('Contact_Key__r.Name');
        queryFieldSet.add('Contact_Key__r.FirstName');
        queryFieldSet.add('CMPGN_NR__c');
        queryFieldSet.add('ACCT_NR__c');
        
        queryOptionsMap = new Map<String, String>();
        queryOptionsMap.put('WHERE', 'CMPGN_NR__c = \'201304\'');
        queryOptionsMap.put('ORDER BY', 'Name');        
    }
}