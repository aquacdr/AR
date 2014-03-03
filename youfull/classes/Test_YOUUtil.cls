/***************************************************************************
 Name          : Test_YOUUtil 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for YOUUtil
 Created Date  : Nov 16, 2013                
****************************************************************************/
@isTest
private class Test_YOUUtil {
   
    public static testmethod void testCampaignUtil(){
        Market__c mkt = TestDataHelper.createMarket('XX', false);
        mkt.PREV_1_CMPGN_NR__c = '201201'; 
        mkt.CMPGN_NR__c = '201202'; 
        mkt.NEXT_1_CMPGN_NR__c = '201203';   
        insert mkt;   
        User ldrUser = TestDataHelper.createUser('test123', 'XZ1', 'Avon Leader', false);
        ldrUser.MRKT_ID__c = mkt.Market_Id__c;
        insert ldrUser;
        
        //Creating the current Campaign Data
        List<Calendar__c> toInsrtSub = new List<Calendar__c>();
        toInsrtSub.add(TestDataHelper.createCalendar(201202, mkt.Market_Id__c, 2012, mkt.Id, false));
    
        //Creating the privious Campaign Data
        toInsrtSub.add(TestDataHelper.createCalendar(201201, mkt.Market_Id__c, 2012, mkt.Id, false));
        toInsrtSub.add(TestDataHelper.createCalendar(201112, mkt.Market_Id__c, 2011, mkt.Id, false));
        toInsrtSub.add(TestDataHelper.createCalendar(201111, mkt.Market_Id__c, 2011, mkt.Id, false));
    
        //Creating the future Campaign Data
        toInsrtSub.add(TestDataHelper.createCalendar(201203, mkt.Market_Id__c, 2012, mkt.Id, false));
        toInsrtSub.add(TestDataHelper.createCalendar(201204, mkt.Market_Id__c, 2012, mkt.Id, false));
        toInsrtSub.add(TestDataHelper.createCalendar(201205, mkt.Market_Id__c, 2012, mkt.Id, false));
        
        insert toInsrtSub;
    
        System.runAs(ldrUser){
                //CampaignUtil util = new CampaignUtil();
                String marketId = mkt.Market_Id__c;
                List<Integer> expectedPriorCampaign = new List<Integer>{};
                //expectedPriorCampaign.add(201202);
                expectedPriorCampaign.add(201201);
                expectedPriorCampaign.add(201112);
                expectedPriorCampaign.add(201111);
    
                List<Integer> expectedFutureCampaign = new List<Integer>{};
                //expectedFutureCampaign.add(201202);
                expectedFutureCampaign.add(201203);
                expectedFutureCampaign.add(201204);
                expectedFutureCampaign.add(201205);
                
                List<Integer> actualPriorCmpg = YOUUtil.getXPriorCampaignList(marketId,4);
                List<Integer> actualFutureCmpg = YOUUtil.getXFutureCampaignList(marketId,4);
                System.assertEquals(201201, actualPriorCmpg[0]);
                System.assertEquals(201203, actualFutureCmpg[0]); 
                YOUUtil.getMonthMailPlan('201201');
                
                try{
                    YOUUtil.get3CampaignNumbers(marketId);   
                }catch(Exception e){
                    System.debug('DEBUG MESSAGE '+e.getMessage());
                } 
        }
    }//end of test Class
        
    public static testmethod void testSumFunction(){
        List<decimal> myDecimalList = new List<decimal>{};
        myDecimalList.add(10.11);
        myDecimalList.add(24.21);
        YOUUtil.sumDecimalValues(myDecimalList);
        System.assertEquals(YOUUtil.sumDecimalValues(myDecimalList),34.32);
    }
        
    public static testmethod void testNoCurrentCampaign(){
        Market__c mkt = TestDataHelper.createMarket('XX', false);
        mkt.CMPGN_NR__c = '201202';   
        insert mkt;   
        User ldrUser = TestDataHelper.createUser('test123', 'XZ1', 'Avon Leader', false);
        ldrUser.MRKT_ID__c = mkt.Market_Id__c;
        insert ldrUser;
          
        List<String> teststr= new List<String>{'test1','test2','test3'};
        List<String> teststr1= new List<String>{'test4','test5','test6'};
        List<List<String>> lls=new List<List<String>>{teststr,teststr1};
        YOUUtil.sortbycoldesc(lls,1,'Text');
        YOUUtil.sortbycolasc(lls,1,'Text');
        
        List<String> test = new List<String>{'1','2','3'};
        List<String> test1 = new List<String>{'5','6','7'};
        List<List<String>> lls1 = new List<List<String>>{test, test1};
        YOUUtil.sortbycoldesc(lls1, 1, 'Number');
        YOUUtil.sortbycolasc(lls1, 1, 'Number');
            
        System.runAs(ldrUser){
            String marketId = mkt.Market_Id__c;
            try {
                List<Integer> actualPriorCmpg = YOUUtil.getXPriorCampaignList(marketId,4);
                }Catch(Exception e){
                    System.debug('DEBUG MESSAGE '+e.getMessage());
            }
        }
    }
    
    public static testmethod void testExecutiveLdrNbr(){
        Market__c mkt = TestDataHelper.createMarket('XX', false);
        mkt.CMPGN_NR__c = '201202';   
        insert mkt;   
        User ldrUser = TestDataHelper.createUser('test123', 'XZ1', 'Avon Leader', false);
        ldrUser.MRKT_ID__c = mkt.Market_Id__c;
        insert ldrUser;         
        List <Leader_Title__c> leaderTitleList = TestDataHelper.createLeaderTitlesList(String.valueOf(mkt.Id), mkt.Market_Id__c, true);
        System.runAs(ldrUser){
            system.assert(YOUUtil.getExecutiveLdrNbr(mkt.Market_Id__c) != null);
        }
    }
}