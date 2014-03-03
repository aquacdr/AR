global class RevokeAvonLeaderAccess implements Database.Batchable<sObject>{

   global Database.QueryLocator start(Database.BatchableContext BC){
      PermissionSet ps=[Select Id From PermissionSet where Name='View_All'];
      String query = 'Select Id From PermissionSetAssignment where PermissionSetId=\''+ps.Id+'\'';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		Delete scope;
    }

   global void finish(Database.BatchableContext BC){
   }
}