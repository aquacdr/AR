/***************************************************************************
 Name         : Test_ZM_Batch_UpdateRoleParentID
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Batch_UpdateRoleParentID
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_ZM_Batch_UpdateRoleParentID {
	
	//----------------------------------------------------------------------------
    // Method Name  : testUpdateRole
    // Description  : Method for Test Coverage of Class : ZM_Batch_UpdateRoleParentID
    //----------------------------------------------------------------------------
    static testMethod void testUpdateRole() {
    	ZM_Batch_UpdateRoleParentID b = new ZM_Batch_UpdateRoleParentID();
    	Test.startTest();
    	Database.executeBatch(b);
    	Test.stopTest();
    }
}