/***************************************************************************
 Name         : Test_ZM_Batch_JobScheduler 
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ZM_Batch_JobScheduler
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_ZM_Batch_JobScheduler {

	//----------------------------------------------------------------------------
    // Method Name  : testZMBatchScheduler
    // Description  : Method for Test Coverage of Class : ZM_Batch_JobScheduler
    //----------------------------------------------------------------------------
    static testMethod void testZMBatchScheduler() {
	    Database.Batchable<SObject> b;
	    	
		ZM_Batch_JobScheduler bs = new ZM_Batch_JobScheduler(b, 1);
		Datetime sysTime = System.now().addSeconds(10);
	    String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
	    SchedulableContext sc;
	    try{
	        bs.execute(sc);
	        System.schedule('Test_ZM_Batch_JobScheduler - ' + sysTime.getTime(), chron_exp, bs);
	    }
	    catch(Exception e){}
    }
}