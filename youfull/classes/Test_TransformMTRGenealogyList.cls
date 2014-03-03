/***************************************************************************
 Name         : Test_TransformMTRGenealogyList
 Created By   : Barkha Jain (JDC)
 Description  : Test class for TransformMTRGenealogyList
 Created Date : Nov 8, 2013                
****************************************************************************/
@isTest
private class Test_TransformMTRGenealogyList {
    private static List<ALM_Rep_Performance_1__c> repLst;
    
    //----------------------------------------------------------------------------
    // Method Name  : testZMImpersonationCoaching
    // Description  : Method for Test Coverage of Class : TransformMTRGenealogyList
    //----------------------------------------------------------------------------
    static testMethod void testTransformation() {
        createTestData();
        
        //creating set of qualified column names
        Set<String> fullyQualifiedColumnNameSet = new Set<String>();
        fullyQualifiedColumnNameSet.add('GENRTN_1_TITL_STF_CNT__c');
        
        //creating ColumnInfo records
        MTRSOQLBuilder.ColumnInfo columnInfo = new MTRSOQLBuilder.ColumnInfo();
        columnInfo.Name = 'CNT';
        columnInfo.FullyQualifiedName = 'GRP_FAP_CNT__c';
        MTRSOQLBuilder.ColumnInfo columnInfo1 = new MTRSOQLBuilder.ColumnInfo();
        columnInfo1.Name = 'YTD';
        columnInfo1.FullyQualifiedName = 'YTD_GRP_UNIT_SLS_AMT__c';
        MTRSOQLBuilder.ColumnInfo columnInfo2 = new MTRSOQLBuilder.ColumnInfo();
        columnInfo2.Name = 'GRP';
        columnInfo2.FullyQualifiedName = 'GRP_PAST_DUE_AMT__c';
        MTRSOQLBuilder.ColumnInfo columnInfo3 = new MTRSOQLBuilder.ColumnInfo();
        columnInfo3.Name = 'AMT';
        columnInfo3.FullyQualifiedName = 'GRP_UNIT_SLS_AMT__c';
        
        //creating columnInfo Map
        Map<String, MTRSOQLBuilder.ColumnInfo> columnInfoMap = new Map<String, MTRSOQLBuilder.ColumnInfo>();
        columnInfoMap.put('Name', null);
        columnInfoMap.put('CNT', columnInfo);
        columnInfoMap.put('YTD', columnInfo1);
        columnInfoMap.put('GRP', columnInfo2);
        columnInfoMap.put('AMT', columnInfo3);
        
        //creating columnOrderList
        List<String> columnOrderList = new List<String>{'Name', 'CNT', 'YTD', 'GRP', 'AMT'};
        
        //Creating Genealogy List
        GenealogyWrapper genealogy = new GenealogyWrapper();
        genealogy.Genealogy = repLst[0];
        GenealogyWrapper genealogy1 = new GenealogyWrapper();
        genealogy1.Genealogy = repLst[1];
        List<GenealogyWrapper> genealogyList = new List<GenealogyWrapper>{genealogy, genealogy1};
        
        Test.startTest();
        //Calling default constructor
        TransformMTRGenealogyList tmg = new TransformMTRGenealogyList();
        
        //calling parametric constructor
        tmg = new TransformMTRGenealogyList(genealogyList, columnInfoMap, new Map<String, MTRSOQLBuilder.ColumnInfo>(), 
                                            columnOrderList, new List<String>(), fullyQualifiedColumnNameSet);
        tmg.PrintReportMode = false;
        tmg.IncludeBranchSummary = true;
        tmg.IncludeExtraInfo = true;
        tmg.ExpandAll = true;
        tmg.DoTransformation();
        //verify result
        system.assert(tmg.TeamPrintColumnList.size() > 0);
        
        tmg.IsTList = true;
        tmg.DoTransformation();
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    //Method to create Test Data
    //----------------------------------------------------------------------------
    static void createTestData(){
        TestDataHelper.createALMGlobalSetting(true);
        //creating test user
        User usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', false);
        usr.MRKT_ID__c = '62';
        usr.MRKT_ID_ACCT_NR_KEY__c = '62' + '1234';
        insert usr;
        
        Market__c mkt;             
        System.runAs(usr){
            mkt = TestDataHelper.createMarket('62', true);
        }
        
        Account acc = TestDataHelper.createAccount('Test Account', 'USD', true);
        Contact c = TestDataHelper.createContact('1234', acc.Id, false);
        c.MRKT_ACCT_KEY__c = '62' + '1234';
        insert c;
        
        //creating test Genealogy records
        repLst = new List<ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep = TestDataHelper.createRepPerformance(c.Id, mkt, '1234', false);   
        rep.LFT_ND_ID__c = 0;
        rep.RGT_ND_ID__c = 5;
        rep.Genealogy_Level__c = 1;
        rep.DWNLN_ONLY_IND__c = 'Y';
        repLst.add(rep);
        
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(c.Id, mkt, '1235', false);   
        rep1.LFT_ND_ID__c = 1;
        rep1.RGT_ND_ID__c = 4;
        rep1.Genealogy_Level__c = 2;
        rep1.DWNLN_ONLY_IND__c = 'N';
        repLst.add(rep1);
        insert repLst;
    }
}