global class NRT_Utils {
    /*
    @future
    global static void setAlmGroupSalesINdicator(set<String> genealogyKeys)
    {
         //collect the Ids for the parent records
         list<Id> parentAlmList2 = new list<Id>();
         list<Id> parentAlmList3 = new list<Id>();
         list<ALM_Rep_Performance_1__c> ggpAlmList = new list<ALM_Rep_Performance_1__c>();
         
         //get the first level parents
         for(ALM_Rep_Performance_1__c alm : [Select Id, UPLN_ACCT_KEY__c 
                                               from ALM_Rep_Performance_1__c
                                              where Genealogy_Key__c in :genealogyKeys])
              parentAlmList2.add(alm.UPLN_ACCT_KEY__c);
              
         //get the grand parents
         for(ALM_Rep_Performance_1__c alm : [Select Id, Group_Sales_Indicator__c, UPLN_ACCT_KEY__c 
                                               from ALM_Rep_Performance_1__c
                                              where Id in :parentAlmList2])
         {
              alm.Group_Sales_Indicator__c = true;
              parentAlmList3.add(alm.UPLN_ACCT_KEY__c);  
              
         } 
         
          //get the great-grand parents
         for(ALM_Rep_Performance_1__c alm : [Select Id, Group_Sales_Indicator__c, UPLN_ACCT_KEY__c 
                                               from ALM_Rep_Performance_1__c
                                              where Group_Sales_Indicator__c = false
                                                and Id in :parentAlmList3])
         {
              alm.Group_Sales_Indicator__c = true;
              ggpAlmList.add(alm);  
              
         }   
         
         if(ggpAlmList.size() > 0)
            update ggpAlmList;                           
    }
    
    global static void executeBatchOrderProcess(String caller)
    {
        Integer jobCount = 0;
        for(AsyncApexJob aj : [Select a.Status, a.CompletedDate, a.ApexClass.Name, a.ApexClassId 
                                 From AsyncApexJob a
                                where a.ApexClass.Name = 'ALM_BatchOrderProcessor'
                                  and Status != 'Completed'
                                  and Status != 'Aborted'])
           jobCount++;
           
        if(jobCount == 0)
        {
            for(Order_Stage__c os : [select Id from Order_Stage__c limit 1])
            {
                ALM_BatchOrderProcessor abp = new ALM_BatchOrderProcessor(caller);
                Database.executeBatch(abp,2000);
            }
        }
            
    }
    */
    global static Id logTransactionStart( String    calledFrom
                                          ,String   componentName
                                          ,String   componentType
                                          ,DateTime startTime)
    {
        Code_Execution_Time__c c = new Code_Execution_Time__c(Called_From__c = calledFrom
                                                             ,Component_Name__c = componentName
                                                             ,Component_Type__c = componentType
                                                             ,Start_Time__c = startTime);
        insert c;
        
        return c.Id;
            
    }
    
    global static void logTransactionEnd(Id codeExecutionTimeId
                                        ,DateTime   endTime)
    {
        Code_Execution_Time__c c = new Code_Execution_Time__c(Id = codeExecutionTimeId
                                                             ,End_Time__c = endTime);
        update c;
            
    }
    
    global static boolean isBatchLoadInProcess()
    {
        User u = [select Id, MRKT_ID__c from User where Id = :UserInfo.getUserId()];
        
        for(Market__c m : [Select Batch_Load_In_Process__c from Market__c where Market_Id__c = :u.MRKT_ID__c])
           return m.Batch_Load_In_Process__c;
           
        return null;
    }
    
    global static DateTime getBatchLoadStarted()
    {
        User u = [select Id, MRKT_ID__c from User where Id = :UserInfo.getUserId()];
        
        for(Market__c m : [Select Batch_Load_Strt_Dt__c from Market__c where Market_Id__c = :u.MRKT_ID__c])
           return m.Batch_Load_Strt_Dt__c;
           
        return null;
    }
    
    global static boolean isNrtEnabled()
    {
        User u = [select Id, MRKT_ID__c from User where Id = :UserInfo.getUserId()];
        
        for(Market__c m : [Select NRT_Enabled__c from Market__c where Market_Id__c = :u.MRKT_ID__c])
           return m.NRT_Enabled__c;
           
        return null;
    }
    
    /**
        * This method will return current campaign for MP/non MP market
        * This method accepts 2 parameters:
        * Market - it needs to have Mail_Plan_Enabled__c, CMPGN_NR__c, Market_Id__c field
        * User - It needs to have DFALT_ZONE_CD__c field
    **/
    global static string getCurrentCampaign(Market__c mkt, User usr)
    {
        String cmpgn = '';
        if(mkt.Mail_Plan_Enabled__c)       
        {
            try
            {
                //Date currDate = System.today();
                DateTime d = datetime.now();
                String timeStr = d.format('yyyy-MM-dd');
                
                String query_str = 'SELECT Id, CMPGN_NR__c, MRKT_ID__c, MLPLN_END_DT__c';
                
                query_str+=' FROM MailPlan_Order_Oppty__c';
                
                String whereClause = ' WHERE SLS_ZONE_CD__c=\''+usr.DFALT_ZONE_CD__c+'\' AND MRKT_ID__c=\''+mkt.Market_Id__c+'\' and CURRNT_NEXT_CMPGN_PRFX_CD__c=\'C\'';               
                whereClause+=' AND MLPLN_END_DT__c >= '+timeStr+' ORDER BY MLPLN_END_DT__c ';
                
                String limitClause = 'Limit 1';
                
                query_str = query_str+whereClause+limitClause;
                
                System.debug('\n ======= MailPlanUtil.query_str SL ======= \n'+query_str);
                List<MailPlan_Order_Oppty__c> lst_mpoo= Database.query(query_str);
                
                if (!lst_mpoo.isEmpty()) {
                    cmpgn = YOUUtil.getCampaignNumbrMailPlan((String)lst_mpoo[0].get('CMPGN_NR__c'));
                }
                else {
                    cmpgn = mkt.CMPGN_NR__c;
                }
            }
            catch(exception e)
            {
                System.debug('exception in class NRT_Utils method getCurrentCampaign --> '+e);
            }
        }
        else
        {
            cmpgn = mkt.CMPGN_NR__c;
        }
        
        return cmpgn;
    }
    
    /**
        * This method will return next campaign for MP/non MP market
        * This method accepts 2 parameters:
        * Market - it needs to have Mail_Plan_Enabled__c, NEXT_1_CMPGN_NR__c, Market_Id__c field
        * User - It needs to have DFALT_ZONE_CD__c field
    **/
    global static string getNextCampaign(Market__c mkt, User usr)
    {
        String cmpgn = '';
        if(mkt.Mail_Plan_Enabled__c)       
        {
            try
            {
                //Date currDate = System.today();
                DateTime d = datetime.now();
                String timeStr = d.format('yyyy-MM-dd');
                
                String query_str = 'SELECT Id, CMPGN_NR__c, MRKT_ID__c, MLPLN_END_DT__c';
                
                query_str+=' FROM MailPlan_Order_Oppty__c';
                
                String whereClause = ' WHERE SLS_ZONE_CD__c=\''+usr.DFALT_ZONE_CD__c+'\' AND MRKT_ID__c=\''+mkt.Market_Id__c+'\' and CURRNT_NEXT_CMPGN_PRFX_CD__c=\'N\'';               
                whereClause+=' AND MLPLN_END_DT__c >= '+timeStr+' ORDER BY MLPLN_END_DT__c ';
                
                String limitClause = 'Limit 1';
                
                query_str = query_str+whereClause+limitClause;
                
                System.debug('\n ======= MailPlanUtil.query_str SL ======= \n'+query_str);
                List<MailPlan_Order_Oppty__c> lst_mpoo= Database.query(query_str);
                
                if (!lst_mpoo.isEmpty()) {
                    cmpgn = YOUUtil.getCampaignNumbrMailPlan((String)lst_mpoo[0].get('CMPGN_NR__c'));
                }
                else {
                    cmpgn = mkt.NEXT_1_CMPGN_NR__c;
                }
            }
            catch(exception e)
            {
                System.debug('exception in class NRT_Utils method getCurrentCampaign --> '+e);
                cmpgn = mkt.NEXT_1_CMPGN_NR__c;
            }
        }
        else
        {
            cmpgn = mkt.NEXT_1_CMPGN_NR__c;
        }
        
        return cmpgn;
    }
    
    public static String getLastUpdatedTimeStamp(String marketId)
    {
        DateTime lastModifiedTs = System.now().addMinutes(-20);
        
        for(Market__c m : [select Batch_Load_Strt_Dt__c ,NRT_Enabled__c
                             from Market__c 
                            where Market_Id__c = :marketId 
                              and Batch_Load_In_Process__c = true
                              and Batch_Load_Strt_Dt__c < :lastModifiedTs])
        {
            lastModifiedTs = m.Batch_Load_Strt_Dt__c;
            if(!m.NRT_Enabled__c)
              return '';
        }
        
        return Label.NRT_Last_Updated_Label+' '+lastModifiedTs.format();
    }
    
    public static String getLastUpdatedTimeStampBatch(String marketId)
    {
        for(Market__c m : [select Batch_Load_Strt_Dt__c, LAST_UPDT_DT__c
                             from Market__c 
                            where Market_Id__c = :marketId ])
        {
            return Label.NRT_Last_Updated_Label+' '+m.LAST_UPDT_DT__c.format();
        }
        
        return marketId;
        //NRT_New_Order_Message
    }
}