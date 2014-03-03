/* 
Date            Who         Line#               Modification
============================================================================================
01-10-2011  Snehashis                       Created to support utility methods for ALM.
*/
global class ALMUtils{
    
    public static final String FWD_SLSH='/';
    public static final String PERCENT='%';
    public static final String COMMA=',';
    public static final String END_LINE='\n'; 
    public static final String SUBTRACT='-';
    
    public static Decimal calcuateSum(String colFlds, String delimiter, SObject sobjPrim, SObject sobjSend){
        // calculate the sum of fields based on delimiter
        Decimal numVal=0.00;
        System.debug('>>>>>>>>>>>>>>> colFlds'+colFlds);
        String tempFld;
        for(String fldName: colFlds.split(delimiter)){
            tempFld = fldName.trim();
            try{  
                numVal+=(sobjPrim.get(tempFld)!=null?(Decimal)sobjPrim.get(tempFld):0.0);
            }catch(Exception ex){
                numVal+=(sobjSend.get(tempFld)!=null?(Decimal)sobjSend.get(tempFld):0.0);
            }
         }
        return numVal;
    }
    
    public static Decimal calcuateSum(String colFld, SObject sobjPrim, SObject sobjSend){
        // calculate the sum of fields based on delimiter
        Decimal numVal=0.00;
        System.debug('>>>>>>>>>>>>>>> colFld'+colFld);
        try{  
            numVal+=(sobjPrim.get(colFld)!=null?(Decimal)sobjPrim.get(colFld):0.0);
        }catch(Exception ex){
            numVal+=(sobjSend.get(colFld)!=null?(Decimal)sobjSend.get(colFld):0.0);
        }
        return numVal;
    }
    
    public static Decimal getFieldValue(String colFlds,SObject sobjPrim, SObject sobjSend){
        
        Decimal totVal = 0.0;
        System.debug('>>>>>>>>>>>>>>> colFlds'+colFlds);
        String tempFld;
        String numFld;
        String denFld;
        Decimal numVal = 0.0;
        Decimal denVal = 0.0;
        String numComaFld;
        String denComaFld;
        if(colFlds.startsWith('(') && colFlds.endsWith(')')){
            if(colFlds !=null && colFlds.contains(FWD_SLSH)){
                ALMLogUtils.log('ALMUtils', 'Inside Division calculation');
                String[] alFldName = new String[]{};
                Integer strIdx = colFlds.indexOf('(');
                Integer endIdx = colFlds.indexOf(')');
                String newColFlds = colFlds.substring(strIdx+1, endIdx);
                alFldName = newColFlds.split(FWD_SLSH);
                ALMLogUtils.log('ALMUtils', 'alFldName value is ::'+alFldName);
                if(alFldName.size()==2){
                    numFld = alFldName[0].trim();
                    denFld = alFldName[1].trim();
                    ALMLogUtils.log('ALMUtils', 'Numerator and Denomitor Value is ::'+numFld+'>>>'+denFld);
                    //Numerator value calculation
                    if(numFld.contains(COMMA))
                        numVal=calcuateSum(numFld,COMMA,sobjPrim,sobjSend);
                    else
                        numVal=calcuateSum(numFld,sobjPrim,sobjSend);
                    ALMLogUtils.log('ALMUtils', 'Numerator total value is ::'+numVal);
                //Denominator value calculation
                    if(denFld.contains(COMMA))
                        denVal=calcuateSum(denFld,COMMA,sobjPrim,sobjSend);
                    else
                        denVal= calcuateSum(denFld,sobjPrim,sobjSend);
                    ALMLogUtils.log('ALMUtils', 'Denominator total value is ::'+denVal);
                    if(denVal != 0.0){
                        totVal = numVal / denVal;
                    }else{
                        totVal = 0.0;
                    }
                    ALMLogUtils.log('ALMUtils', 'Total calculated value for Division is ::'+totVal);
                }
                
            } else if(colFlds.contains(PERCENT)){
                ALMLogUtils.log('ALMUtils', 'Inside Percent calculation');
                String[] alFldName = new String[]{};
                Integer strIdx = colFlds.indexOf('(');
                Integer endIdx = colFlds.indexOf(')');
                String newColFlds = colFlds.substring(strIdx+1, endIdx);
                alFldName = newColFlds.split(PERCENT);
                if(alFldName.size()==2){
                    numFld = alFldName[0].trim();
                    denFld = alFldName[1].trim();
                    ALMLogUtils.log('ALMUtils', 'Numerator and Denomitor Value is ::'+numFld+'>>>'+denFld);
                    //Numerator value calculation
                    if(numFld.contains(COMMA))
                        numVal=calcuateSum(numFld,COMMA,sobjPrim,sobjSend);
                    else
                        numVal=calcuateSum(numFld,sobjPrim,sobjSend);
                    ALMLogUtils.log('ALMUtils', 'Numerator total value is ::'+numVal);
                //Denominator value calculation
                    if(denFld.contains(COMMA))
                        denVal=calcuateSum(denFld,COMMA,sobjPrim,sobjSend);
                    else
                        denVal=calcuateSum(denFld,sobjPrim,sobjSend);
                    ALMLogUtils.log('ALMUtils', 'Denominator total value is ::'+denVal);
                    if(denVal != 0.0){
                        totVal = (numVal / denVal)* 100;
                    }else{
                        totVal = 0.0;
                    }
                    ALMLogUtils.log('ALMUtils', 'Total calculated value for percent is ::'+totVal);
                }
            }else if(colFlds.contains(SUBTRACT)){
                ALMLogUtils.log('ALMUtils', 'Inside subtraction calculation');
                String[] alFldName = new String[]{};
                Integer strIdx = colFlds.indexOf('(');
                Integer endIdx = colFlds.indexOf(')');
                String newColFlds = colFlds.substring(strIdx+1, endIdx);
                alFldName = newColFlds.split(SUBTRACT);
                if(alFldName.size()==2){
                    numFld = alFldName[0].trim();
                    denFld = alFldName[1].trim();
                    ALMLogUtils.log('ALMUtils', 'Left Side and right Side Value is ::'+numFld+'>>>'+denFld);
                    //Numerator value calculation
                    if(numFld.contains(COMMA))
                        numVal=calcuateSum(numFld,COMMA,sobjPrim,sobjSend);
                    else
                        numVal=calcuateSum(numFld,sobjPrim,sobjSend);
                    ALMLogUtils.log('ALMUtils', 'Left side total value is ::'+numVal);
                //Denominator value calculation
                    if(denFld.contains(COMMA))
                        denVal=calcuateSum(denFld,COMMA,sobjPrim,sobjSend);
                    else
                        denVal=calcuateSum(denFld,sobjPrim,sobjSend);
                    ALMLogUtils.log('ALMUtils', 'Right Side total value is ::'+denVal);
                    totVal = numVal - denVal;
                    ALMLogUtils.log('ALMUtils', 'Total calculated value for Subtraction is ::'+totVal);
                }
            }
        }else{
            totVal=calcuateSum(colFlds,END_LINE,sobjPrim,sobjSend);
        }
        return totVal;
    }
    
     //@S-144891 : Commented by Blaine Rothrock on Nov 23
     /*public static testmethod void testALMUtils(){
        ALMUtils ctlr = new ALMUtils();
        String demoMktCode = 'DE';
        String currentCmpgn = '201204';
        String uplineAcctNr = 'upln1';
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket(demoMktCode);
        
        User testUsr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            testUsr = testData.createLeaderUser(uplineAcctNr);
        }
        testData.createListContact(new List<String>{uplineAcctNr}, testUsr.Id);
        testData.createRepPerformance(new List<String>{mkt.Market_Id__c + currentCmpgn + uplineAcctNr}, mkt.Market_Id__c, testUsr.Id);
        String flds1 = '(AVG_GENRTN_3_UNIT_COMM_PCT__c - AVG_GENRTN_3_DISTR_SLS_PCT__c)';
        String flds2 = '(AVG_GENRTN_3_UNIT_COMM_PCT__c % AVG_GENRTN_3_DISTR_SLS_PCT__c)';    
        String flds3 = '(AVG_GENRTN_3_UNIT_COMM_PCT__c / AVG_GENRTN_3_DISTR_SLS_PCT__c,AVG_GENRTN_2_UNIT_COMM_PCT__c)';  
        List<ALM_Rep_Performance_1__c> ppList = [SELECT Id, AVG_GENRTN_3_UNIT_COMM_PCT__c, AVG_GENRTN_3_DISTR_SLS_PCT__c, AVG_GENRTN_2_UNIT_COMM_PCT__c FROM ALM_Rep_Performance_1__c
                                                WHERE ACCT_NR__c IN (:uplineAcctNr)];
        System.runAs(testUsr){
            Decimal d = getFieldValue(flds1,ppList[0],ppList[0]);
            d = getFieldValue(flds2,ppList[0],ppList[0]);
            d = getFieldValue(flds3,ppList[0],ppList[0]);
        }
     
     
     }*/
     /*
     public static testmethod void testZoneALMUtils(){
        ALMUtils ctlr = new ALMUtils();
        TestDataHelper testData = new TestDataHelper();
        User testUsr = testData.createZoneUser('123456');
        List<Sales_Org_Leadership__c> sorgLdr=testData.createSlsLdrActivity(testUsr,'Avon Zone Manager',testUsr.Id);  
        List<Leader_Activity_Config__c> lac=testData.createLdrActvtyConfig();   
        lac[0].Current_Campaign_Fld__c ='(AVG_ORD_AMT__c%AVG_ORD_AMT__c)';
        lac[0].Next_Campaign_Fld__c='(AVG_ORD_AMT__c/AVG_ORD_AMT__c)';
        Decimal finVal, totVal;
        System.runAs(testUsr){
            finVal = ALMUtils.getFieldValue(lac[0].Current_Campaign_Fld__c,sorgLdr[0],sorgLdr[0]);
            totVal = ALMUtils.getFieldValue(lac[0].Next_Campaign_Fld__c,sorgLdr[0],sorgLdr[0]);
            System.assert(finVal==100.00);
            System.assert(totVal==1.00);
        }
     }*/
     
     
    
}