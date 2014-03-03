global class scheduledRevokeALAccess implements Schedulable{
   global void execute(SchedulableContext SC) {
      DataBAse.executeBatch(new RevokeAvonLeaderAccess());
   }
}