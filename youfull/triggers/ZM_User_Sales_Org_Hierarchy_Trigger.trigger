trigger ZM_User_Sales_Org_Hierarchy_Trigger on User_Sales_Org_Hierarchy__c (after insert, before delete) {
	
	ZM_User_Sales_Org_Hierarchy_Handler handler = new ZM_User_Sales_Org_Hierarchy_Handler();
	
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		   handler.onAfterInsert(trigger.oldMap, trigger.newMap);
	}
	else
	{
		if(trigger.isDelete)
		   handler.onBeforeDelete(trigger.oldMap);
	}

}