/***************************************************************************
 Name         : Test_ActionItem 
 Created By   : Barkha Jain (JDC)
 Description  : Test class for ActionItem
 Created Date : Oct. 24, 2013                
****************************************************************************/
@isTest
private class Test_ActionItem {
	
	//----------------------------------------------------------------------------
    // Method Name  : testActionItems
    // Description  : Method for Test Coverage of Class : ActionItem
    //----------------------------------------------------------------------------
	public static testmethod void testActionItems() {
		ActionItem item = new ActionItem('cat1', false, true, '1', 'Order_Not_Submitted', '12334');
		system.assert(item.counts.CC_Cnt__c == null);
		system.assert(item.counts.CC_Amt__c == null);
		
		ActionItem newItem = new ActionItem('cat1', false, true, '1', 'Order_Not_Submitted', '12334', '/apex/DemoPage');
		system.assert(newItem.counts.CC_Cnt__c == 0);
		system.assert(newItem.counts.CC_Amt__c == 0);
		
		newItem.setRecCountAmt(10.12);	
		system.assert(newItem.counts.CC_Amt__c == 10.12);	
		
		newItem.setRecCountCnt(10.0);	
		system.assert(newItem.counts.CC_Cnt__c == 10);
		
		ActionItem newItem2 = new ActionItem('cat1', false, true, '1', 'Order_Not_Submitted', '12334', '/apex/DemoPage', 'current');
		system.assert(newItem2.counts.CC_Cnt__c == 0);
		system.assert(newItem2.counts.CC_Amt__c == 0);
		
		newItem2.setRecCountAmt(10.12);	
		system.assert(newItem2.counts.CC_Amt__c == 10.12);	
		
		newItem2.setRecCountCnt(10.0);	
		system.assert(newItem2.counts.CC_Cnt__c == 10);
	}
}