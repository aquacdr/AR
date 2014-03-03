public class DropDownComponentControllerTest 
{
	@isTest
     public static  void testDropDownContrlr()
    {
    	TestDataHelper testData =   new TestDataHelper();
    	
        //Creating Market
        Market__c mrkt = testData.createMarket();
        update  mrkt;
    
        //Create Leader User
        User testUsr = testData.createLeaderUser('U123456');
        
        testUsr.LDRSHP_TITL_LVL_NBR__c='1';
        update testUsr;
        
        testData.createReportConfig();
                
        String profileName = [Select Name from Profile where  Id=:testUsr.ProfileId].Name;
        
        PageReference pageRef = Page.MyTeamReport;
        pageRef.getParameters().put('pgId', '1'); 
        pageRef.getParameters().put(ALMConstants.IMPERSON_PARAM_NAME, 'XYZ123');
         
        DropdownComponentController objDropDown = new DropdownComponentController();
        
        System.runAs(testUsr){
            objDropDown.getDropdownSelectOptions();
            objDropDown.getReportLinks(testUsr.MRKT_ID__c, profileName, testUsr.LDRSHP_TITL_LVL_NBR__c, true, '', 'MyTeamReport');
            
            System.assert(objDropDown.impersonatedAcctKey == null);
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_MYTEAM_ORDER;
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
            
            System.assert(objDropDown.userTitleNumber == '1');
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_G1SALESLEADERS;
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
            
            System.assert(objDropDown.currentReportType == 'G1_Sales_Leaders');
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_G1CANDIDATES; 
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
            
            System.assert(objDropDown.userTitleNumber == '1');
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_RISINGSTARS; 
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
            
            System.assert(objDropDown.profileName == 'Avon Leader');
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_G1APPT; 
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
            
            System.assert(objDropDown.impersonate == true);
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_SL_GENEALOGY; 
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
        }
        
        System.runAs(testUsr){
            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = '';  
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
            
            System.assert(objDropDown.currentReportType == '');
        }
    
    }
}