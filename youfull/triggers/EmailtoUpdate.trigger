trigger EmailtoUpdate on User (before insert, before update) {
    List<String> profileNames = new List<String>();
/*  profileNames.add('Avon Leader');
    profileNames.add('Avon Zone Manager');
    profileNames.add('Avon Division Manager');
    Map<Id,Profile> profilesToLook = new Map<Id,Profile>([select Id,Name from Profile where Name in :profileNames]);*/
    Map<Id,Profile> profilesToLook = new Map<Id,Profile>([select Id,Name from Profile where Name='Avon Leader' OR Name Like '%Zone%' OR Name Like '%Division%' OR Name like '%Sales Leader%']);
    if(Trigger.isInsert){
        for(User u: trigger.new){
            if(profilesToLook.keySet().contains(u.ProfileID) && profilesToLook.containsKey(u.ProfileId)){
                u.Email = u.GI3_Email__c;
            }
        } 
    }
    if(Trigger.isUpdate){
        for (User newUsr: trigger.new) {
            if(profilesToLook.keySet().contains(newUsr.ProfileID) && profilesToLook.get(newUsr.ProfileID).Name!='Avon Leader'){
                User oldUsr = Trigger.oldMap.get(newUsr.Id);
                if (newUsr.GI3_EMAIL__c!=null && oldUsr.GI3_EMAIL__c != newUsr.GI3_EMAIL__c) {
                    newUsr.Email = newUsr.GI3_Email__c;
                }
            }
        }
    }
}