/*
** Apex Class/Controller Name           : ZM_SalesOrgSummaryTriggerHandler
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Helper class for Trigger "ZM_Sales_Org_Summary.trigger". It contains logic separated from trigger body.
** 
** Triggers Spawned                     : N/A
** [Object Name:Trigger Name] 
**
** Change Log (Put the latest entry on top) :
** ~Format: Date | Author | Change description 
**  3/8/ G Created
**  8/14    | Fay  |  Modified to allow for roles that support duplicate zone names in different markets
*/

public class ZM_SalesOrgSummaryTriggerHandler {

    /*
    *  assigns zone manager or division manager as owner of the new record
    */
  public void assignOwnersZoneDivisionManagersBeforeInsert(List<Sales_Org_Summary__c> newList) {
    
  Map<ID, Market__c> marketMap = new Map<ID, Market__c>([select Id, Market_Id__c from Market__c]);
  
    Set<String> rollNames = new Set<String>();
    //collect all roles.
    for(Sales_Org_Summary__c sOS: newList)
    {
        if(sOS.SLS_ORG_LVL_DESC_TXT__c == 'Z' && sOS.SLS_ORG_DESC_TXT__c != null && sOS.SLS_ORG_DESC_TXT__c != '') 
        {
            rollNames.add('Mrkt '+marketMap.get(sOS.MRKT_KEY__c).Market_Id__c+' Z '+sOS.SLS_ORG_DESC_TXT__c+' Owner');
        }
    }
    
    //Retrive all roles with related users
    Map<string, UserRole> rollNameRoleMap = new Map<string, UserRole>();
    
    //Create map of role name to role record.
    for(UserRole role: [select id, name, (select id from Users limit 1) from UserRole where name in : rollNames])
    {
        rollNameRoleMap.put(role.name, role);
        System.debug(':::sOS.rollNameMapEntry::> '+ role.Name + ' -> ' + role);
    }
    
    UserRole tempRole;
    //assign role user as owner of record.
    for(Sales_Org_Summary__c sOS: newList)
    {
        if(sOS.SLS_ORG_LVL_DESC_TXT__c == 'Z')
        {
            tempRole = rollNameRoleMap.get('Mrkt '+marketMap.get(sOS.MRKT_KEY__c).Market_Id__c+' Z '+sOS.SLS_ORG_DESC_TXT__c+' Owner');
            
            if(tempRole !=null && tempRole.Users.size() > 0)
            {
                sOS.OwnerId = tempRole.Users.get(0).id;
                System.debug(':::sOS.OwnerId::>'+sOS.OwnerId);
            }
                
        }else if(sOS.SLS_ORG_LVL_DESC_TXT__c == 'D')
        {
            sOS.OwnerId = sOS.ZONE_MGR__c;
        }
    }           
        
  }


/*-------------------- Test Method --------------------*/

    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*@isTest(SeeAllData=true)
    static void myUnitTest() {
        
        test.startTest();
        Market__c market = [select Id, Market_Id__c from Market__c where Market_Id__c = '55' limit 1];
        UserRole [] usrRoles = [select id, name, (select id from Users limit 1) from UserRole where name = 'Mrkt 55 Z 0200 Owner' limit 1];
        System.Debug(':::usrRoles[0].Users[0].Id:::>'+usrRoles[0].Users[0].Id);
        test.stopTest();
        
        Sales_Org_Summary__c objSalesOrg 
          = New Sales_Org_Summary__c ( NAME = '201211 Sales Org Summary'
                          , MRKT_KEY__c=market.Id
                                      ,SLS_ORG_LVL_DESC_TXT__c='Z'
                                      , SLS_ORG_DESC_TXT__C = '0200'
                                      , ZONE_MGR__c=UserInfo.getUserId()
                                      , OPERTNL_CMPGN_NR__c ='201211'
                                      , FLD_SLS_CMPGN_NR__C = '201211'
                                      , NET_SLS_PLAN_AMT__C = 1322000
                                      , NET_SLS_DIV_RNK__C = 100
                                      , NET_SLS_PLAN_SPPY_AMT__C = 1555000
                                      , NET_SLS_SPPY_AMT__C = 1555000
                                      , ACTV_REP_CNT__C = 1500
                                      , ACTV_REP_DIV_RNK__C = 100
                                      , ACTV_REP_PLAN_CNT__C = 1546
                                      , ACTV_REP_PLAN_SPPY_CNT__C = 1500
                                      , ACTV_REP_SPPY_CNT__C = 1600
                                      , TITLD_STF_PLAN_CNT__C = 9
                                      , UPR_CNT__C = 8
                                      , UPR_DIV_RNK_CNT__C = 100
                                      , UPR_PLAN_CNT__C = 9
                                      , UPR_PLAN_SPPY_CNT__C =     9
                                      , UPR_SPPY_CNT__C = 9
                                      , APPT_CNT__C = 9
                                      , APPT_DIV_RNK__C = 100
                                      , APPT_PLAN_CNT__C = 12
                                      , APPT_PLAN_SPPY_CNT__C = 15
                                      , APPT_SPPY_CNT__C = 15
                                      , RMOVL_CNT__C = 9
                                      , RMOVL_DIV_RNK__C = 100
                                      , RMOVL_PLAN_CNT__C = 6
                                      , RMOVL_PLAN_SPPY_CNT__C = 8
                                      , RMOVL_SPPY_CNT__C = 8
                                      , RNSTMT_CNT__C = 2
                                      , RNSTMT_DIV_RNK__C = 100
                                      , RNSTMT_PLAN_CNT__C = 5
                                      , RNSTMT_PLAN_SPPY_CNT__C = 7
                                      , RNSTMT_SPPY_CNT__C = 7
                                      , RTURN_NET_SLS_AMT__C = 1500
                                      , RTURN_NET_SLS_DIV_RNK__C = 100
                                      , RTURN_NET_SLS_PLAN_AMT__C = 1500
                                      , RTURN_NET_SLS_PLAN_SPPY_AMT__C = 1550
                                      , RTURN_NET_SLS_SPPY_AMT__C = 1550
                                      , TITLD_STF_CNT__C = 8
                                      , TITLD_STF_DIV_RNK__C = 100
                                      , TITLD_STF_PLAN_SPPY_CNT__C = 9
                                      , TITLD_STF_SPPY_CNT__C = 9
                                      , LOA1_NET_SLS_AMT__C = 1000
                                      , LOA1_NET_SLS_DIV_RNK__C = 100
                                      , LOA1_NET_SLS_PLAN_AMT__C = 100000
                                      , LOA1_NET_SLS_PLAN_SPPY_AMT__C = 1000
                                      , LOA1_NET_SLS_SPPY_AMT__C = 1000
                                      , LOA_1_6_NET_SLS_AMT__C = 30000
                                      , LOA_1_6_NET_SLS_DIV_RNK__C = 100
                                      , LOA_1_6_NET_SLS_PLAN_AMT__C = 322000
                                      , LOA_1_6_NET_SLS_PLAN_SPPY_AMT__C = 1000
                                      , LOA_1_6_NET_SLS_SPPY_AMT__C = 1000
                                      , TITL_0_STF_DIV_RNK__C = 100
                                      , TITL_0_STF_PLAN_CNT__C = 9
                                      , TITL_0_STF_PLAN_SPPY_CNT__C = 9
                                      , TITL_0_STF_SPPY_CNT__C = 9
                                      , ANALYSIS_DONE__C = FALSE
                                      , NET_SLS_INVC_AMT__C = 622000
                                      , NET_SLS_SMTB_AMT__C = 722000
                                      , ORD_SUBMTD_CNT__C = 10
            //,Num_Campaign_Stars__c=5 
            ); 
        Sales_Org_Summary__c objSalesOrg1 = New Sales_Org_Summary__c( NAME = '201211 Sales Org Summary1'
                                               , MRKT_KEY__c=market.Id
                                                                     , SLS_ORG_LVL_DESC_TXT__c='D'
                                                                     , SLS_ORG_DESC_TXT__C = 'AGUAMARINA'
                                                                     , ZONE_MGR__c=UserInfo.getUserId()
                                                                     , OPERTNL_CMPGN_NR__c = '201211'
                                                                     , FLD_SLS_CMPGN_NR__C = '201211'
                                                                     , NET_SLS_PLAN_AMT__C = 1322000
                                                                     , NET_SLS_DIV_RNK__C = 100
                                                                     , NET_SLS_PLAN_SPPY_AMT__C = 1555000
                                                                     , NET_SLS_SPPY_AMT__C = 1555000
                                                                     , ACTV_REP_CNT__C = 1500
                                                                     , ACTV_REP_DIV_RNK__C = 100
                                                                     , ACTV_REP_PLAN_CNT__C = 1546
                                                                     , ACTV_REP_PLAN_SPPY_CNT__C = 1500
                                                                     , ACTV_REP_SPPY_CNT__C = 1600
                                                                     , TITLD_STF_PLAN_CNT__C = 9
                                                                     , UPR_CNT__C = 8
                                                                     , UPR_DIV_RNK_CNT__C = 100
                                                                     , UPR_PLAN_CNT__C = 9
                                                                     , UPR_PLAN_SPPY_CNT__C =     9
                                                                     , UPR_SPPY_CNT__C = 9
                                                                     , APPT_CNT__C = 9
                                                                     , APPT_DIV_RNK__C = 100
                                                                     , APPT_PLAN_CNT__C = 12
                                                                     , APPT_PLAN_SPPY_CNT__C = 15
                                                                     , APPT_SPPY_CNT__C = 15
                                                                     , RMOVL_CNT__C = 9
                                                                     , RMOVL_DIV_RNK__C = 100
                                                                     , RMOVL_PLAN_CNT__C = 6
                                                                     , RMOVL_PLAN_SPPY_CNT__C = 8
                                                                     , RMOVL_SPPY_CNT__C = 8
                                                                     , RNSTMT_CNT__C = 2
                                                                     , RNSTMT_DIV_RNK__C = 100
                                                                     , RNSTMT_PLAN_CNT__C = 5
                                                                     , RNSTMT_PLAN_SPPY_CNT__C = 7
                                                                     , RNSTMT_SPPY_CNT__C = 7
                                                                     , RTURN_NET_SLS_AMT__C = 1500
                                                                     , RTURN_NET_SLS_DIV_RNK__C = 100
                                                                     , RTURN_NET_SLS_PLAN_AMT__C = 1500
                                                                     , RTURN_NET_SLS_PLAN_SPPY_AMT__C = 1550
                                                                     , RTURN_NET_SLS_SPPY_AMT__C = 1550
                                                                     , TITLD_STF_CNT__C = 8
                                                                     , TITLD_STF_DIV_RNK__C = 100
                                                                     , TITLD_STF_PLAN_SPPY_CNT__C = 9
                                                                     , TITLD_STF_SPPY_CNT__C = 9
                                                                     , LOA1_NET_SLS_AMT__C = 1000
                                                                     , LOA1_NET_SLS_DIV_RNK__C = 100
                                                                     , LOA1_NET_SLS_PLAN_AMT__C = 100000
                                                                     , LOA1_NET_SLS_PLAN_SPPY_AMT__C = 1000
                                                                     , LOA1_NET_SLS_SPPY_AMT__C = 1000
                                                                     , LOA_1_6_NET_SLS_AMT__C = 30000
                                                                     , LOA_1_6_NET_SLS_DIV_RNK__C = 100
                                                                     , LOA_1_6_NET_SLS_PLAN_AMT__C = 322000
                                                                     , LOA_1_6_NET_SLS_PLAN_SPPY_AMT__C = 1000
                                                                     , LOA_1_6_NET_SLS_SPPY_AMT__C = 1000
                                                                     , TITL_0_STF_DIV_RNK__C = 100
                                                                     , TITL_0_STF_PLAN_CNT__C = 9
                                                                     , TITL_0_STF_PLAN_SPPY_CNT__C = 9
                                                                     , TITL_0_STF_SPPY_CNT__C = 9
                                                                     , ANALYSIS_DONE__C = FALSE
                                                                     , NET_SLS_INVC_AMT__C = 622000
                                                                     , NET_SLS_SMTB_AMT__C = 722000
                                                                     , ORD_SUBMTD_CNT__C = 10
            //, Num_Campaign_Stars__c=5 
            ); 
        
        List<Sales_Org_Summary__c> soss = new List<Sales_Org_Summary__c>{objSalesOrg,objSalesOrg1};
        insert soss;
        
        soss = [select id,ownerid from Sales_Org_Summary__c where id = :objSalesOrg.id];
        //System.assertEquals(usrRoles[0].Users.get(0).id, soss[0].ownerid);
        
        soss = [select id,ownerid,ZONE_MGR__c from Sales_Org_Summary__c where id = :objSalesOrg1.id];
        //System.assertEquals(soss[0].ZONE_MGR__c, soss[0].ownerid);
        // TO DO: implement unit test
    }*/
}