/***************************************************************************
 Name         : Test_UpdateUserPrefController 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for UpdateUserPrefController
 Created Date : Oct 28, 2013                
****************************************************************************/
@isTest
private class Test_UpdateUserPrefController {

	//---------------------------------------------------------------------------
    // Method Name  : testUpdatePrefController
    // Description  : Method for Test Coverage of Class : UpdatePrefController
    //---------------------------------------------------------------------------
    public static testmethod void testUpdatePrefController(){
        // Create test data
        String acctNbr = '123456';
        User ldrUsr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Leader', true);	                   
        User mktAdmin = TestDataHelper.createUser('MKT_ADMIN', 'XZ1', 'Avon Market Administrator', true);         
        Market__c mrkt = TestDataHelper.createMarket('123456', true);          
        mrkt.Market_Administrator__c = mktAdmin.Id;       
        mrkt.OwnerId = ldrUsr.Id;
     	update mrkt;      
        
        // Test for controller functionality
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
      	ctlr.testMode =true; 
        System.runAs(ldrUsr){
        	ctlr.init();
          	ctlr.userRec.LanguageLocaleKey='fr';
          	ctlr.updatePreferences();
          	System.assert(ctlr.isError==true);
        }      
    } 
    
   /* public static testmethod void testUpdatePrefController(){
        TestDataHelper testData = new TestDataHelper();
        testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr = testData.createZoneUser(acctNbr);
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;
        update testData.market;
        List<User_Sales_Org_Hierarchy__c> usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'XZ1','Z');
        testData.createUsrSlsOrgHrchy(usr,'XZ2','Z');
        List<Sales_Organization__c> slsOrgs = testData.createSalesOrgs();
        
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        System.runAs(usr){
            System.assert(ctlr.getSlsOrgSize()==0);
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==2);
            System.debug('>>>>>>>>>>> SALES ORG DATA ZONE:'+ctlr.allowedSlsOrgs);
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.userRec.LanguageLocaleKey='en_US';
            ctlr.userRec.UserPermissionsMobileUser=true;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==false);
            ctlr.userRec.LanguageLocaleKey='fr';
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==true);
        }
    }

    
    public static testmethod void test2SalesLeader(){
        TestDataHelper testData = new TestDataHelper();
        testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr = testData.createZoneUser(acctNbr);
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;
        update testData.market;
        List<User_Sales_Org_Hierarchy__c> usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'XZ1','Z');
        testData.createUsrSlsOrgHrchy(usr,'XZ2','Z');
        List<Sales_Organization__c> slsOrgs = testData.createSalesOrgs();
        
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        System.runAs(usr){
            System.assert(ctlr.getSlsOrgSize()==0);
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==2);
            System.debug('>>>>>>>>>>> SALES ORG DATA ZONE:'+ctlr.allowedSlsOrgs);
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==false);
            ctlr.userRec.LanguageLocaleKey='fr';
            ctlr.selOrgCdId = usrHierarchy[0].SLS_ORG_CD__c;
            ctlr.updatePreferences();
            System.assert(ctlr.isError==true);
        }
        System.runAs(mktAdmin){
            List<Task> mobileTask = [select Id,Subject from Task where OwnerId=:mktAdmin.Id];
            //System.debug('>>>>>>>>>>>>>> TOTAL TASKS RETURNED: '+mobileTask);
            //system.assert(mobileTask.size()==1);
        }
        usr = testData.createDivUser('D'+acctNbr);
        usr.DFALT_ZONE_CD__c ='All';
        update usr;
        //usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'D1','D');
        ctlr = new UpdateUserPrefController();
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==1);
            System.assert(ctlr.getSlsOrgSize()==1);
            ctlr.selOrgCdId = 'All';
            ctlr.updatePreferences();
            User tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c==null);  
            ctlr.selOrgCdId =   'XZ1';
            ctlr.updatePreferences();
            tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c=='XZ1'); 
        }

        ctlr = new UpdateUserPrefController();
        usr = testData.createLeaderUser('L'+acctNbr);
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs()==null);
        }
        
    }
    
    public static testmethod void testZoneManager(){
        TestDataHelper testData = new TestDataHelper();
        testData.createEmailTemplate();
        String acctNbr = '123456';
        User usr = testData.createZoneUser(acctNbr);
        User mktAdmin = testData.createMarketAdminUser('MKT_ADMIN');
        System.debug('>>>>>>>>>>>>>>>>>>>>>> mktAdmin User:'+mktAdmin);
        testData.market.Market_Administrator__c = mktAdmin.Id;

        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        
        update testData.market;
        List<User_Sales_Org_Hierarchy__c> usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'XZ1','Z');
        testData.createUsrSlsOrgHrchy(usr,'XZ2','Z');
        List<Sales_Organization__c> slsOrgs = testData.createSalesOrgs();
        
        usr = testData.createDivUser('D'+acctNbr);
        usr.DFALT_ZONE_CD__c ='All';
        update usr;
        //usrHierarchy = testData.createUsrSlsOrgHrchy(usr,'D1','D');
        ctlr = new UpdateUserPrefController();
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs().size()==1);
            System.assert(ctlr.getSlsOrgSize()==1);
            ctlr.selOrgCdId = 'All';
            ctlr.updatePreferences();
            User tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c==null);  
            ctlr.selOrgCdId =   'XZ1';
            ctlr.updatePreferences();
            tempUsr = [select DFALT_DIV_NM__c,DFALT_ZONE_CD__c 
                            from User
                            where Id=:usr.Id];
            System.assert(tempUsr.DFALT_ZONE_CD__c=='XZ1'); 
        }

        ctlr = new UpdateUserPrefController();
        usr = testData.createLeaderUser('L'+acctNbr);
        System.runAs(usr){
            ctlr.init();
            System.assert(ctlr.getAllowedSlsOrgs()==null);
        }
        
    }*/
    
    //---------------------------------------------------------------------------
    // Method Name  : testActionAlerts
    // Description  : Method for Test Coverage of Class : UpdatePrefController
    //---------------------------------------------------------------------------
    public static testmethod void testActionAlerts(){
    	String acctNbr = '123456';
        User usr = TestDataHelper.createUser('123456', 'XZ1', 'Avon Leader', true);	                         
        Market__c mrkt = TestDataHelper.createMarket('123456', true);          
       
  
        mrkt.Action_Alert_Enabled__c=true;
        mrkt.Action_Alerts__c='Orders Not submitted;Title Lost;';        
        mrkt.OwnerId = usr.Id;
        update mrkt;
       
        //Create Ineligibility Reason Code
       /* List<Ineligibility_Reason__c> testRnLst= new List<Ineligibility_Reason__c>();
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='OOO',Ineligibility_Reason__c='Out Of Office',Market__c=testData.market.id,Order__c=1));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='ZMO',Ineligibility_Reason__c='Zone Manager Override',Market__c=testData.market.id,Order__c=2));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='SO',Ineligibility_Reason__c='System Override',Market__c=testData.market.id,Order__c=3));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='OI',Ineligibility_Reason__c='Opt In',Market__c=testData.market.id,Order__c=4));
        testRnLst.add(new Ineligibility_Reason__c(LANG_CD__c='en_US',Ineligibility_Code__c='SFA',Ineligibility_Reason__c='Salesforce Active',Market__c=testData.market.id,Order__c=5));
        insert testRnLst;*/
        UpdateUserPrefController ctlr = new UpdateUserPrefController();
        ctlr.testMode =true; 
        System.runAs(usr){
            ctlr.init();
           /* System.assert(usr.Is_Eligible__c==false);
            System.assert(ctlr.getOOOMsg().size()==2);
            System.assert(ctlr.getOIMsg().size()==2);
            System.assert(ctlr.getOOOMsg().size()==2);*/
            System.assert(ctlr.getAllowedActionAlerts().size()==3);
            System.assert(ctlr.getAllowedFrequencies().size()==10);
            ctlr.userRec.LanguageLocaleKey='en_US';
           // ctlr.userRec.Action_Alert_Enabled__c=true;
            ctlr.aAlertEnabled=true;
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==true);
            ctlr.userRec.Action_Alert_1__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_Frequency__c=null;
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==true);
            ctlr.userRec.Action_Alert_1__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_Frequency__c='Daily';
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==false);
            List<Action_Alert__c> usrAlerts = [select Id from Action_Alert__c where OwnerId=:usr.Id];
            System.assert(usrAlerts.size()==1);
            ctlr.userRec.Action_Alert_1__c='Rising Stars';
            ctlr.userRec.Action_Alert_2__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_3__c='Title Lost';
            ctlr.updatePreferences();
            System.assert(ctlr.actionAlertError==false);
            usrAlerts = [select Id from Action_Alert__c where OwnerId=:usr.Id];
            System.assert(usrAlerts.size()==3);
            ctlr.sendTestActionAlert();
            System.assert(ctlr.actionAlertError==false);
           // ctlr.userRec.SMS_Address__c='test@avon.com';
           System.debug('My test User >>>'+ctlr.userRec);
            ctlr.userRec.Action_Alert_1__c='Orders Not submitted';
            ctlr.userRec.Action_Alert_2__c='Orders Not submitted';
            ctlr.updatePreferences();
            ctlr.callRepDetails();
            System.assert(ctlr.bDuplicate==true);
            //Snehashis added for ALM+
           /* ctlr.userRec.Opt_In__c=true;
            ctlr.userRec.Lead_Opt_in_Terms__c=false;
            ctlr.updatePreferences();
            System.assert(ctlr.isLeadOptinError==true);
            System.assert(ctlr.userRec.Out_of_Office__c==false);*/
        }
    }
 
}