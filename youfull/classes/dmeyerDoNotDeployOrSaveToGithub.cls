public class dmeyerDoNotDeployOrSaveToGithub {

    public Long cpuTime { get; set; }


    public void getQryFail(){
        DateTime current = System.now();
        Long t1 = current.getTime();
        for (ALM_Rep_Performance_1__c a: [Select Id from ALM_Rep_Performance_1__c where BRNCH_SCTN_CD__c like '%33%' limit 50000]){
            System.debug(a.Id);
        }
        current = System.now();
        Long t2 = current.getTime();
        cpuTime=t2-t1;
    }
}