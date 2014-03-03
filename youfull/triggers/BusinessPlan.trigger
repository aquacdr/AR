trigger BusinessPlan on Business_Plan__c (before insert) {
    if(trigger.isInsert){
        System.debug('trigger.new[0].Mrkt_Id_Acct_Nr_Key__c--'+trigger.new[0].Mrkt_Id_Acct_Nr_Key__c);
        User currUser = [Select Id, LDRSHP_TITL_LVL_NBR__c, MRKT_ID_ACCT_NR_KEY__c from User where Id=: UserInfo.getUserId()];
        System.debug(' currUser.LDRSHP_TITL_LVL_NBR__c --'+currUser.LDRSHP_TITL_LVL_NBR__c);
        if(Integer.valueOf(currUser.LDRSHP_TITL_LVL_NBR__c)>0 && Integer.valueOf(currUser.LDRSHP_TITL_LVL_NBR__c)<=15){
            String field1Name = 'AVG_LVL_'+currUser.LDRSHP_TITL_LVL_NBR__c+'_G1_UNIT_COMMSN_PCT__c';
            String field2Name = 'AVG_LVL_'+currUser.LDRSHP_TITL_LVL_NBR__c+'_G1_DSTRBTN_PCT__c';
            String field3Name = 'AVG_LVL_'+currUser.LDRSHP_TITL_LVL_NBR__c+'_G2_UNIT_COMMSN_PCT__c';
            String field4Name = 'AVG_LVL_'+currUser.LDRSHP_TITL_LVL_NBR__c+'_G2_DSTRBTN_PCT__c';
            String field5Name = 'AVG_LVL_'+currUser.LDRSHP_TITL_LVL_NBR__c+'_G3_UNIT_COMMSN_PCT__c';
            String field6Name = 'AVG_LVL_'+currUser.LDRSHP_TITL_LVL_NBR__c+'_G3_DSTRBTN_PCT__c';
            String baseSOQL = 'Select Id, '+field1Name+', '+field2Name+', '+field3Name+', '+field4Name+', '+field5Name+', '+field6Name+' from Business_Plan_Parameter__c where Id=\''+String.valueOf(trigger.new[0].Business_Plan_Parameter__c)+'\' order by CreatedDate desc limit 1 ';
            System.debug('baseSOQL--'+baseSOQL);
            Business_Plan_Parameter__c currBPPar = Database.query(baseSOQL);
            if(currBPPar.get(field2Name) != null && currBPPar.get(field2Name) !=''){
                trigger.new[0].BPar_AVG_GENRTN_1_DISTR_SLS_PCT__c = Decimal.valueOf(String.valueOf(currBPPar.get(field2Name)));
            }
            if(currBPPar.get(field1Name) != null && currBPPar.get(field1Name) !=''){
                trigger.new[0].BPar_AVG_GENRTN_1_UNIT_COMM_PCT__c = Decimal.valueOf(String.valueOf(currBPPar.get(field1Name))); 
            }
            if(currBPPar.get(field4Name) != null && currBPPar.get(field4Name) !=''){
                trigger.new[0].BPar_AVG_GENRTN_2_DISTR_SLS_PCT__c = Decimal.valueOf(String.valueOf(currBPPar.get(field4Name))); 
            }
            if(currBPPar.get(field3Name) != null && currBPPar.get(field3Name) !=''){
                trigger.new[0].BPar_AVG_GENRTN_2_UNIT_COMM_PCT__c = Decimal.valueOf(String.valueOf(currBPPar.get(field3Name)));
            }
            if(currBPPar.get(field6Name) != null && currBPPar.get(field6Name) !=''){
                trigger.new[0].BPar_AVG_GENRTN_3_DISTR_SLS_PCT__c = Decimal.valueOf(String.valueOf(currBPPar.get(field6Name))); 
            }
            if(currBPPar.get(field5Name) != null && currBPPar.get(field5Name) !=''){
                trigger.new[0].BPar_AVG_GENRTN_3_UNIT_COMM_PCT__c = Decimal.valueOf(String.valueOf(currBPPar.get(field5Name))); 
            }
        }
    }
}