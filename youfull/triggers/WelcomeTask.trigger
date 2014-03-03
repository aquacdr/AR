trigger WelcomeTask on User (before insert, before update) {
if(!Test.isRunningTest()){
    List<Id> usrIds = new List<Id>();
    String mktId = null;
    // TODO: Refactor to custom setting.
    Map<Id,Profile> prfMap = new Map<Id,Profile>([select Id,Name from Profile where Name='Avon Leader' OR Name='Avon Zone Manager' OR Name='Avon Division Manager' OR Name='Avon Standard Leader']);
    for(User usr: Trigger.new){
       if(!usr.Welcome_Message__c){
            usrIds.add(usr.Id);
            mktId= usr.MRKT_ID__c;  
            usr.Welcome_Message__c=true;
        } 
        //check to update the status field of the user
        if(Trigger.isUpdate && (usr.CDW_STS_CD__c == 'Removed' || usr.CDW_STS_CD__c == 'Not Consented'))
             usr.isActive=false;
        // Special Check for Argentina Market
        if(Trigger.isUpdate && usr.CDW_STS_CD__c == 'Consented')
             usr.isActive=true;
        
         // By default isActive should be false
         if (Trigger.isInsert && usr.CDW_STS_CD__c != 'Consented' && prfMap.containsKey(usr.ProfileID))
            usr.isActive=false;
     }
    //System.debug('Users to Create welcome Task:'+usrIds);
   /* if(usrIds.size()>0){
        WelcomeMsg welMsg = new WelcomeMsg();
        WelcomeMsg.createWelcomeTask(usrIds,mktId);
    } */
}
}