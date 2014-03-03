/*
** Trigger Name                 : ZM_Sales_Org_Summary
** Context Variables            : before insert
** 
** Triggers Spawned             : N/A
** [Object Name:Trigger Name] 
** 
** Purpose [short summary]      : This is general trigger for Sales_Org_Summary object
** 
** Change Log (Put the latest entry on top) :
** ~Format: Date | Author | Change description 
**
**  3/5/2013 G created
** 
*/

trigger ZM_Sales_Org_Summary on Sales_Org_Summary__c (before insert, before update) {
    ZM_SalesOrgSummaryTriggerHandler handler = new ZM_SalesOrgSummaryTriggerHandler();
    if ((Trigger.isInsert) || (Trigger.isUpdate)) {
        handler.assignOwnersZoneDivisionManagersBeforeInsert(Trigger.new);
    }
}