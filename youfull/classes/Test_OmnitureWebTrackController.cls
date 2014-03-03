/***************************************************************************
 Name         : Test_OmnitureWebTrackController
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for OmnitureWebTrackController
 Created Date : Oct. 28, 2013                
****************************************************************************/

@isTest
private class Test_OmnitureWebTrackController { 

    //----------------------------------------------------------------------------
    // Method Name  : testOmnitureWebTrackController
    // Description  : Method for Test Coverage of Class : OmnitureWebTrackController
    //----------------------------------------------------------------------------  
    public static testmethod void testOmnitureWebTrackController() {
        OmnitureWebTrackController contr = new OmnitureWebTrackController();
        contr.userTitleInput = '0';
        
        //Test for SL
        contr.userTypeInput = ALMPlusConstants.AVON_LEADER;
        System.assertEquals(contr.userTypeOutput, ALMPlusConstants.AVON_LEADER_PROFILE_ALIAS);
        System.assertEquals(contr.userTitleOutput, contr.userTitleInput);
        
        //Test for ZM
        contr.userTypeInput = ALMPlusConstants.AVON_ZM;
        System.assertEquals(contr.userTypeOutput, ALMPlusConstants.AVON_ZONE_MANAGER_PROFILE_ALIAS);
        System.assertEquals(contr.userTitleOutput, contr.userTypeOutput);
        
    }
}