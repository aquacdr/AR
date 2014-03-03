/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TEST_GENTREEDATA {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        TestDataHelper dataHelper=new TestDataHelper();
        String acctNbr='12345';
        String ownrId=Userinfo.getUserId();
        dataHelper.createGenealogyData(acctNbr, ownrId, 5);
        //query the ALM Rep Performance to validate the records
        List<ALM_Rep_Performance_1__c> repPerfList=[select ACCT_NR__c, lft_nd_id__c, rgt_nd_id__c, Genealogy_Level__c,MRKT_ACCT_KEY__r.ACCT_NR__c from ALM_Rep_Performance_1__c]; 
       
       for(ALM_Rep_Performance_1__c repInstance:repPerfList){
       	  System.debug('=====*************************========');
       	  System.debug('=====repPerfList.ACCT_NR__c====' + repInstance.ACCT_NR__c);
       	  System.debug('=====repPerfList.lft_nd_id__c====' + repInstance.lft_nd_id__c);
       	  System.debug('=====repPerfList.rgt_nd_id__c====' + repInstance.rgt_nd_id__c);
       	  System.debug('=====repPerfList.Genealogy_Level__c====' + repInstance.Genealogy_Level__c);
       	  System.debug('=====repPerfList.MRKT_ACCT_KEY__r.ACCT_NR__c====' + repInstance.MRKT_ACCT_KEY__r.ACCT_NR__c);
       	  System.debug('=====*************************========');
       }
    }
}