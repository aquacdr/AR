global with sharing class TestBatch implements Database.Batchable<sObject>,Database.Stateful{
  global Database.QueryLocator start(Database.BatchableContext BC){
        String query='';
        query +=' select Id, MRKT_ID__c, SLS_ZONE_CD__c, FLD_SLS_CMPGN_NR__c, ROOT_UPLN_ACCT_NR__c, MRKT_CMPGN_SLS_ZONE_CD__c, MRKT_CMPGN_ROOT_UPLN_ACCT__c from ALM_Rep_Performance_1__c where MRKT_CMPGN_SLS_ZONE_CD__c=null or MRKT_CMPGN_ROOT_UPLN_ACCT__c=null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<ALM_Rep_Performance_1__c> almRecords=new List<ALM_Rep_Performance_1__c>();
        for(Sobject sobj:scope){
        	ALM_Rep_Performance_1__c almInstance=(ALM_Rep_Performance_1__c)sobj;
        	if(almInstance.MRKT_CMPGN_ROOT_UPLN_ACCT__c==null){
        		almInstance.MRKT_CMPGN_ROOT_UPLN_ACCT__c=almInstance.MRKT_ID__c + almInstance.FLD_SLS_CMPGN_NR__c + almInstance.ROOT_UPLN_ACCT_NR__c;
        	}
        	else if (almInstance.MRKT_CMPGN_SLS_ZONE_CD__c ==null){
        	   almInstance.MRKT_CMPGN_SLS_ZONE_CD__c=almInstance.MRKT_ID__c + almInstance.FLD_SLS_CMPGN_NR__c + almInstance.SLS_ZONE_CD__c;
        	}
        	else if(almInstance.MRKT_ID__c==null || almInstance.FLD_SLS_CMPGN_NR__c==null || almInstance.SLS_ZONE_CD__c==null || almInstance.ROOT_UPLN_ACCT_NR__c==null){
        		almInstance.MRKT_CMPGN_SLS_ZONE_CD__c='ERROR';
        		almInstance.MRKT_CMPGN_ROOT_UPLN_ACCT__c='ERROR';
        	}
        	almRecords.add(almInstance);
        }
        
        update almRecords;
    }
    
    global void finish(Database.BatchableContext BC){

    }
}