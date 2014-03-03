/**
    Prepares SOQL statements for varous purposes.
    
    Activity History:  
    Snehashis Ghosh - 6/18 - Added aisoqlForRepPerf() methods.
    
*/
public class SOQLUtils {
    
     public static String aisoqlForRepPerf(String objName){
     	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType obj = gd.get(objName);
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select CurrencyIsoCode, Id, Name, ';
        for(String fldName: fldMap.keySet()){
            if(fldName.endsWith('__c')){
                tempSoql+=fldName+', ';
            }
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' from '+objName.replace('__c','__r ');
        tempSoql += ' where MRKT_ID__c=:mktId and FLD_SLS_CMPGN_NR__c=:cmpnNbr';
        ALMLogUtils.log('SOQLUtils','aisoqlForRepPerf:soql=['+tempSoql+']');
        return tempSoql;
    }
    
    // newly added by Snehashis on Dec-20-2010
   /* public static String soqlForLeaderDownlineMktTag(){
        String tempSoql = soqlForSObject(Leader_Downline_Summary_MktTags__c.sObjectType);
        tempSoql += ' where MRKT_ID__c=:mktId and MRKT_ACCT_KEY__c=:repMktAcctNbr';
        ALMLogUtils.log('SOQLUtils','soqlForLeaderDownlineMktTag:soql=['+tempSoql+']');
        return tempSoql;
    }
    
    public static String soqlForLead(){
        Schema.SObjectType obj = Lead.sObjectType;
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select ';
        for(String fldName: fldMap.keySet()){
            tempSoql+=fldName+',';
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-1);
        tempSoql += ' from '+descResult.getLocalName();
        tempSoql += ' where MRKT_ID__c=:mktId and Lead_Owner__c =:usrID and Status IN :stsLead';
        ALMLogUtils.log('SOQLUtils :mktId','soqlForLead:soql=['+tempSoql+']');
        return tempSoql;
    }*/
    
    public static String soqlForMarket(String marketId) {
        String soql = soqlForSObject(Market__c.sObjectType);
        soql += ' where Market_Id__c=\'' + marketId + '\'';
        return soql;
    }
    
    private static String soqlForSObject(Schema.SObjectType obj){
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select CurrencyIsoCode, Id, Name, ';
        for(String fldName: fldMap.keySet()){
            if(fldName.endsWith('__c')){
                tempSoql+=fldName+', ';
            }
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' from '+descResult.getLocalName();
        return tempSoql;
    }

    public static String soqlForSObject(Schema.SObjectType obj, Set<Id> recordIds){
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql = 'select ';
        for(String fldName: fldMap.keySet()){
            tempSoql+=fldName+', ';
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' from '+descResult.getLocalName();
        if (recordIds != null && recordIds.size() > 0) {
            tempSoql += ' where Id in (\'' +   ALMPlusUtils.concatenate(recordIds, '\', \'') + '\')';
        }
        System.debug('soql prepared: ' + tempSoql);
        return tempSoql;
    }
    
    /**
    *   additionalFields - cross-object fields and others not automatically selected via the describe
    *   sample value: ' field1, field2, '
    *   WARNING: additionalFields must not contain fields that are automatically obtain via describe
    */ 
    public static String soqlForSObject(Schema.SObjectType obj, Set<Id> recordIds, String additionalFields){
        Schema.DescribeSObjectResult descResult= obj.getDescribe();
        Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
        String tempSoql;
        if(additionalFields != null)
            tempSoql = 'select ' + additionalFields;
        else
            tempSoql = 'select ';
        for(String fldName: fldMap.keySet()){
            tempSoql+=fldName+', ';
        }
        tempSoql = tempSoql.substring(0,tempSoql.length()-2);
        tempSoql += ' from '+descResult.getLocalName();
        if (recordIds != null && recordIds.size() > 0) {
            tempSoql += ' where Id in (\'' +   ALMPlusUtils.concatenate(recordIds, '\', \'') + '\')';
        }
        System.debug('soql: ' + tempSoql);
        return tempSoql;
    }
    
}