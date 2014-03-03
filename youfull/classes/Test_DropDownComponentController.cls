/***************************************************************************
 Name          : Test_DropDownComponentController 
 Modified By   : Barkha Jain (JDC)
 Description   : Test class for DropDownComponentController
 Modified Date : Nov 21, 2013                
****************************************************************************/
@isTest
private class Test_DropDownComponentController {
    
    //---------------------------------------------------------------------------
    // Method Name  : testDropDownContrlr
    // Description  : Method for Test Coverage for DropDownComponentController
    //---------------------------------------------------------------------------
    public static testMethod void testDropDownContrlr() {
        String mktIdKey = 'TESTDROP';
        
        Market__c mrkt;
        
        //Create ALM_Global_Settings__c
        ALM_Global_Settings__c almGlobal = TestDataHelper.createALMGlobalSetting(true);
        
        //Create and Insert Object : User
        List <User> usrList = new List <User>();
        
        User testUsr = TestDataHelper.createUser(mktIdKey, 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID__c = mktIdKey;
        usrList.add(testUsr);
        
        insert usrList;
        
        System.runAs(testUsr) {
            //Create and Insert Object : Market
            mrkt = TestDataHelper.createMarket(mktIdKey, false);
            mrkt.OwnerId = testUsr.Id;
            insert mrkt;
        }
        
        List <Report_Config__c> reportConfigList = TestDataHelper.createReportConfig(String.valueOf(mrkt.Id), true);
                
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
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_EXEC_SL_GENEALOGY; 
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
        }
        
        System.runAs(testUsr){            
            objDropDown.marketId = testUsr.MRKT_ID__c;
            objDropDown.impersonate = true;
            objDropDown.userTitleNumber = testUsr.LDRSHP_TITL_LVL_NBR__c;
            objDropDown.impersonatedAcctKey = 'XYZ123';
            objDropDown.pgId = '1';
            objDropDown.currentReportType = ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT; 
            objDropDown.profileName = profileName; 
            
            objDropDown.getDropdownSelectOptions();
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