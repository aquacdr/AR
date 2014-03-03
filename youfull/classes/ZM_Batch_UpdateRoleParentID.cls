global class ZM_Batch_UpdateRoleParentID implements Database.Batchable < sObject > {

   global final String Query;


    global ZM_Batch_UpdateRoleParentID() {
        Query = 'SELECT ID, Name, ParentRoleId, RollupDescription From UserRole where ParentRoleID = null';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < UserRole > scope) {
        List < UserRole > userList = new List < UserRole > ();
        
        Map<String, ID> parentMap = new Map<String, ID> ();
        
        for (UserRole userMap: scope) {
            parentMap.put(userMap.name, userMap.id);
        }
                
        for (UserRole userData1: scope) {
            userData1.ParentRoleId = parentMap.get(userData1.RollupDescription);
            userList.add(userData1);
        }        

        update userList;
    }

    global void finish(Database.BatchableContext BC) {}
    
 	//@S-144891 : Commented by Blaine Rothrock on Nov 23  
    /*@isTest(SeeAllData=true)
    static void runTest()
    {
    	ZM_Batch_UpdateRoleParentID b = new ZM_Batch_UpdateRoleParentID();
    	Test.startTest();
    		Database.executeBatch(b);
    	Test.stopTest();
    }*/
}