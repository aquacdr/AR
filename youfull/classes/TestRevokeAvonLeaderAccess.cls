@isTest
public class TestRevokeAvonLeaderAccess{
    public static testMethod void testRevokeAvonLeaderAccess(){
    	try{
    		Profile avonLeader = [SELECT Id
	    						  FROM Profile
	    						  WHERE Name = 'Avon Leader'];
	    	User avonLeaderUser =[SELECT Id, Name
	    					  FROM User
	    					  WHERE isActive = true
	    					  AND profileId = :avonLeader.Id
	    					  LIMIT 1];
	    					  
	    	PermissionSet ps=[Select Id From PermissionSet where Name='View_All'];
	        List<PermissionSetAssignment> psaQuery=new List<PermissionSetAssignment>();
	        psaQuery=[Select Id From PermissionSetAssignment where AssigneeId=:avonLeaderUser.Id and PermissionSetId=:ps.Id ];
	        if(psaQuery.size()==0){
	          	PermissionSetAssignment psa=new PermissionSetAssignment(PermissionSetId=ps.Id,AssigneeId=UserInfo.getUserId());
	          	insert psa;
	        }
	        
	        Test.startTest();
	        
	        String sch = '0 15 * * * ?';
	        
	        /*scheduledRevokeALAccess sral = new scheduledRevokeALAccess();
	        sral.execute();*/
	        String jobId = System.schedule('testScheduledRevokeAccess',
      			sch, 
         		new ScheduledRevokeALAccess());
	        //ID batchprocessid = Database.executeBatch(new RevokeAvonLeaderAccess());
	        
	        Test.stopTest();
    	}
    	catch(Exception e){
    		System.debug('Exception in class TestRevokeAvonLeaderAccess method testRevokeAvonLeaderAccess --> '+e);
    	}
    }
}