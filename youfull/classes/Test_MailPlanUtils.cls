/***************************************************************************
 Name         : Test_MTRTextSearchController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for MTRTextSearchController
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_MailPlanUtils {

	//---------------------------------------------------------------------------
    // Method Name  : testNext3MailPlansToClose
    // Description  : Method for Test Coverage of getNextMailPlansToClose()
    //---------------------------------------------------------------------------
    public static testmethod void testNext3MailPlansToClose(){
        
        // Create Market
        Market__c mkt = TestDataHelper.createMarket('XX', false);
        mkt.Mail_Plan_Enabled__c = true;
        mkt.Action_Item_Mail_Plans__c=3;
        insert mkt;
        
        // Create MailPlan_Order_Oppty__c records
        List<MailPlan_Order_Oppty__c> mplans = new List<MailPlan_Order_Oppty__c>();
        Date currDate = System.today().addDays(1);
        Date nextCDate= currDate.addDays(10);
        MailPlan_Order_Oppty__c mplan;
        for (Integer i=0;i<5;i++) {
        	mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', currDate.addDays(1+10), 
        											'M'+(i+1), 'XZ1', 'M'+i, false);        	
            mplans.add(mplan);           
            mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', nextCDate.addDays(1+10), 
            										'M'+(i+1), 'XZ1', 'M'+i, false);
            mplans.add(mplan);  
        }
        insert mplans;
        
        MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
        mplnUtils.setMarket(mkt);
        String expectedMplans = '\'M0\',\'M1\',\'M2\',\'M3\',\'M4\'';
        //System.assert(expectedMplans.equals(mplnUtils.getMailPlansClosingNextNDays()));
        System.assert(mplnUtils.getNextMailPlansToClose() != null);
    }   
    
    //---------------------------------------------------------------------------
    // Method Name  : testMailPlanForZoneManager
    // Description  : Method for Test Coverage for Zone Manager
    //---------------------------------------------------------------------------
    public static testmethod void testMailPlanForZoneManager(){
        
        // Create Market
        Market__c mkt = TestDataHelper.createMarket('XX', false);
        mkt.Mail_Plan_Enabled__c = true;
        mkt.Action_Item_Mail_Plans__c=3;
        insert mkt;
        
        // Create test user
        User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Mkt 62 Zone Manager', true);
        
        // Create MailPlan_Order_Oppty__c records
        List<MailPlan_Order_Oppty__c> mplans = new List<MailPlan_Order_Oppty__c>();
        Date currDate = System.today().addDays(1);
        Date nextCDate= currDate.addDays(10);
        MailPlan_Order_Oppty__c mplan;
        for (Integer i=0;i<5;i++) {
        	mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', currDate.addDays(1+10), 
        											'M'+(i+1), 'XZ1', 'M'+i, false);        	
            mplans.add(mplan);           
            mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', nextCDate.addDays(1+10), 
            										'M'+(i+1), 'XZ1', 'M'+i, false);
            mplans.add(mplan);  
        }
        insert mplans;
       
        MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
        mplan = mplnUtils.getMailPlanForDivManager(testUsr);
        System.assert(mplan != null);        
    }
    
    
    //---------------------------------------------------------------------------
    // Method Name  : testMailPlanForZoneManager2
    // Description  : Method for Test Coverage for getMailPlanCampaignZMDM()
    //---------------------------------------------------------------------------
    public static testmethod void testMailPlanForZoneManager2(){
        
        User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Mkt 62 Zone Manager', true);     
        Market__c mkt = TestDataHelper.createMarket('123456', false);
        mkt.Mail_Plan_Enabled__c = true;
        insert mkt;
        
        MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
        
         // Create MailPlan_Order_Oppty__c records
        List<MailPlan_Order_Oppty__c> mplans = new List<MailPlan_Order_Oppty__c>();
        Date currDate = System.today().addDays(1);
        Date nextCDate= currDate.addDays(10);
        MailPlan_Order_Oppty__c mplan;
        for (Integer i=0;i<5;i++) {
        	mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', currDate.addDays(1+10), 
        											'M'+(i+1), 'XZ1', 'M'+i, false);        	
            mplan.MRKT_ID__c = '123456';
            mplans.add(mplan);           
            mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', nextCDate.addDays(1+10), 
            										'M'+(i+1), 'XZ1', 'M'+i, false);
            mplans.add(mplan);  
        }
        insert mplans;
        
        System.assert(MailPlanUtils.getMailPlanCampaignZMDM('\'' + mplans[0].SLS_ZONE_CD__c + '\'', 
        											mplans[0].MRKT_ID__c) != null);       
    }
        
    //---------------------------------------------------------------------------
    // Method Name  : testMailPlanForSalesLeader
    // Description  : Method for Test Coverage for SalesLeader
    //---------------------------------------------------------------------------
    public static testmethod void testMailPlanForSalesLeader(){
    	User testUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Leader', true);     
        Market__c mkt = TestDataHelper.createMarket('123456', false);
        mkt.Mail_Plan_Enabled__c = true;
        insert mkt;
              
        ALM_Global_Settings__c setting = TestDataHelper.createALMGlobalSetting(true);
       	Account account = TestDataHelper.createAccount('Test Account', 'USD', true);   
	    Contact ct = TestDataHelper.createContact('123456', account.Id, true);
	             
        MailPlanUtils mplnUtils = new MailPlanUtils(mkt);
        mplnUtils.repDetail = ct;
        MailPlan_Order_Oppty__c mplan = TestDataHelper.createMPOrderOpp(mkt.Id, '4', 'N', System.today().addDays(1+10), 
        											'M'+1, 'XZ1', 'M'+1, true); 
        // Insert ALM Rep Performance records for each contact for each campaign
        List <ALM_Rep_Performance_1__c> lstRepPerf = new List <ALM_Rep_Performance_1__c>();
        ALM_Rep_Performance_1__c rep1 = TestDataHelper.createRepPerformance(ct.Id, mkt, '123456', false);
        rep1.MailPlan_Order_Oppty__c =  mPlan.Id;
        lstRepPerf.add(rep1);
        insert lstRepPerf;
        
        List <ALM_Rep_Performance_1__c> almRepPerformance = MailPlanUtils.getRepPerf_MailPlan(mkt.ALM_Rep_Indicator__c , '123456' , mkt.Market_Id__c );
        System.assert(almRepPerformance[0].MailPlan_Order_Oppty__r.MLPLN_CD__c == mPlan.MLPLN_CD__c);
        //System.assert(mplan[0].MailPlan_Order_Oppty__r.CURRNT_NEXT_CMPGN_PRFX_CD__c=='C');
        
    }
    
   
}