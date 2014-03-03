/***************************************************************************
 Name          : Test_ALMOrderObjectServiceSoap 
 Modified By   : Parul Gupta (JDC)
 Description   : Test class for ALMOrderObjectServiceSoap
 Modified Date : Oct 29, 2013                
****************************************************************************/
@isTest
private class Test_ALMOrderObjectServiceSoap {
	public static String mktIdKey = 'XX';
	
	//---------------------------------------------------------------------------
    // Method Name  : testALMOrderObjectService
    // Description  : Method for Test Coverage for ALMOrderObjectServiceSoap
    //---------------------------------------------------------------------------
	static testMethod void testALMOrderObjectService() {
    	    
	    // Create test data      
        User ldrUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', true);     
        Market__c mrkt = TestDataHelper.createMarket(mktIdKey, false); 
        mrkt.Market_Currency_Symbol__c = '₱';
    	mrkt.Batch_Load_In_Process__c = false;    	
        mrkt.OwnerId = ldrUsr.Id;
        mrkt.Is_ALMPLUS_Enabled__c = true;
        insert mrkt;
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true); 
       	Account testAcct = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact con1 = TestDataHelper.createContact(mktIdKey, testAcct.Id, false);       
        con1.MRKT_ACCT_KEY__c=mrkt.Market_Id__c+mktIdKey;
        insert con1;
        
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(con1.Id, mrkt, mktIdKey, false);
        rep1.Genealogy_Level__c = 0;
        rep1.MRKT_KEY__c = mrkt.id;
        rep1.AVON_LOA_1_6_IND__c = 'Y';
        rep1.ROOT_UPLN_ACCT_NR__c = mktIdKey;
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 8;
        rep1.Genealogy_Key__c = '77777';
        rep1.SLS_ZONE_CD__c = 'ttt';
        insert rep1;
      
        String salesOrgSummaryKey = rep1.MRKT_ID__c + rep1.OPERTNL_CMPGN_NR__c + 'Z' + rep1.SLS_ZONE_CD__c;
      
      	Sales_Org_Summary__c sos = TestDataHelper.createSalesOrSummaries('test', null, 
      								mrkt.Id, salesOrgSummaryKey, '201303', true);
         
	         
       Order_1__c  o = TestDataHelper.createOrder(mktIdKey, mrkt, rep1.Id, sos.Id, true);
      
        //create the request objects
		list<ALMOrderObjectServiceSoap.OrderObject> almList = new list<ALMOrderObjectServiceSoap.OrderObject>();
		ALMOrderObjectServiceSoap.OrderObject oo = new ALMOrderObjectServiceSoap.OrderObject();
		
		oo.ACCT_NR	= mktIdKey;
		oo.AWRD_SLS_AMT	=	100;
		oo.FLD_SLS_CMPGN_NR=	mrkt.CMPGN_NR__c;
		oo.HOLD_REASON_CD	=	'N';
		oo.INVC_NR			=	'111';
		oo.MLPLN_CD		=	'YY';
		oo.MRKT_ID			=	mrkt.Market_ID__c;
		oo.OPERTNL_CMPGN_NR=	mrkt.CMPGN_NR__c;
		oo.SLS_AMT			=	100;
		oo.ORD_KEY			=	'1111';
		oo.ORD_NR			=	'1111';
		oo.OPPTY_NR		=	'11';
		oo.STUS_CD			=	'2';
		oo.SUBMTD_DT		=	System.Today();
		oo.ORD_TYP			=	'1';
		oo.SRC_SYS			=	'TEST';
		oo.TRNSCTN_SRC		=	'!!!';
		oo.TRNSCTN_TIME    =   DateTime.now();
	    oo.Genealogy_Key = '77777';
	    //oo.SLS_ORG_SUMRY_KEY = '11111';
		
		almList.add(oo);
				
		ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		
		System.assert(oo.MLPLN_CD == [Select MLPLN_CD__c from Order_1__c where ORD_KEY__c = :oo.ORD_KEY].MLPLN_CD__c);
		
		//System.assert([Select Id from Order__c where Order_Key__c = :oo.Order_key].size() > 0);
		System.Debug(':::::::::::::::Error_Message::::::::::::> '+oo.Error_Message);
		//oo.TRNSCTN_TIME = system.now() - 1000;
		oo.MLPLN_CD = 'XX';
		
		//no change in timestamp. Values should remain unchanged in the database
		ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		
		System.assertEquals('YY',[Select MLPLN_CD__c from Order_1__c where ORD_KEY__c = :oo.ORD_KEY].MLPLN_CD__c);
		
		oo.TRNSCTN_TIME    =   oo.TRNSCTN_TIME.addMinutes(10);
		
		ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		System.Debug('XXXXXError_MessageXXXXX>>'+oo.Error_Message);
		System.assertEquals('XX', [Select MLPLN_CD__c from Order_1__c where ORD_KEY__c = :oo.ORD_KEY].MLPLN_CD__c);
		
		//test Error Handling
		list<ALMOrderObjectServiceSoap.OrderObject> resp = new list<ALMOrderObjectServiceSoap.OrderObject>();
		
		//test missing required field
		oo.ACCT_NR = null;	
		oo.TRNSCTN_TIME    =   System.now().addDays(1);	
		System.debug('::::::MISSING REQUIRED FIELD::::::');
		resp = ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		System.assert('REQUIRED_FIELD_MISSING' == oo.Error_Type);
		
		//Bad Relationship
		oo.Genealogy_Key = '9999';	
		oo.TRNSCTN_TIME    =   System.now().addDays(1);	
		System.debug('::::::BAD RELATIONSHIP::::::');
		resp = ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		System.assert('GENEOLOGY_KEY_NOT_FOUND' == oo.Error_Type);
				
		//test required external key field missing
		oo.TRNSCTN_TIME    =   System.now().addDays(3);
		oo.ORD_KEY = '';
		System.debug('::::::MISSING EXTERNAL KEY FIELD::::::');
		resp = ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		System.assert('GENEOLOGY_KEY_NOT_FOUND' == oo.Error_Type);
			
		//test market update
		mrkt.Batch_Load_In_Process__c = true;
    	update  mrkt;
    	
    	resp = ALMOrderObjectServiceSoap.upsertOrderObject(almList, 'TEST');
		System.debug('::::::MARKET IN PROCESS::::::'+mrkt.Batch_Load_In_Process__c);
		System.assert('CDW_BATCH_IN_PROCESS' == oo.Error_Type);		
			
    }
}