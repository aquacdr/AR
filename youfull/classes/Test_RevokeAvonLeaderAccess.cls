/***************************************************************************
 Name           : Test_RevokeAvonLeaderAccess
 Madified By    : Barkha Jain (JDC)
 Description    : Test class for RevokeAvonLeaderAccess and ScheduledRevokeALAccess
 Modified Date  : Nov 6, 2013                
****************************************************************************/
@isTest
private class Test_RevokeAvonLeaderAccess{
    
    //----------------------------------------------------------------------------
    // Method Name  : testRevokeAvonLeaderAccess
    // Description  : Method for Test Coverage of Class : RevokeAvonLeaderAccess and ScheduledRevokeALAccess
    //----------------------------------------------------------------------------
    static testMethod void testRevokeAvonLeaderAccess(){
        User usr = TestDataHelper.createUser('1234', 'XZ1', 'Avon Leader', true);
        PermissionSet ps = [Select Id From PermissionSet where Name = 'View_All'];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = usr.Id);
        insert psa;
               
        Test.startTest();
        
        String sch = '0 15 * * * ?';
        String jobId = System.schedule('testScheduledRevokeAccess', sch, new ScheduledRevokeALAccess());
        ID batchprocessid = Database.executeBatch(new RevokeAvonLeaderAccess());
        
        Test.stopTest();
        
        //verify result
        system.assert([select count() from PermissionSetAssignment where Id =:psa.Id] == 0);        
    }
}