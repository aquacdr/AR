/***************************************************************************
 Name          : SchedulerDeleteOldErrorRecords 
 Description   : Scheduler class for JobDeleteOldErrorRecords 
 Created By    : Barkha Jain 
 Created Date  : Jan 7, 2014                
****************************************************************************/
global class SchedulerDeleteOldErrorRecords implements Schedulable{
    
    global SchedulerDeleteOldErrorRecords() {}
    
    global void execute(SchedulableContext sc) {
        JobDeleteOldErrorRecords deleteBatch = new JobDeleteOldErrorRecords(); 
        database.executebatch(deleteBatch);
    }
}