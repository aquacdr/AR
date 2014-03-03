/**
    *  This class is used to represent
    *  all the utility methods required
    *  in several developments of YOU
    *
    *  Created on 20 Apr, 2012
    *  Created by Raktim Sarkar
    *  Updated by Milon (added CampaignUtil Functionality)
    *
**/

public class YOUUtil 
{
    
    /**
    * Find Executive Ldr Title number in a market 
    *
    */
    public static Integer getExecutiveLdrNbr(String strMarketId) {
        Integer nLdrNbr = 0;
        Leader_Title__c ldrTitle;
        try {
            ldrTitle = [Select LDRSHP_TITL_LVL_NR__c, EXEC_IND__c, LCL_LDRSHP_TITL_CD__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c from 
                    Leader_Title__c where Market__r.Market_Id__c = :strMarketId and EXEC_IND__c = 'Y'
                    order by LDRSHP_TITL_LVL_NR__c asc limit 1];
            System.debug('Title Description: '+ldrTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
            System.debug('Title Code: '+ldrTitle.LCL_LDRSHP_TITL_CD__c);
            System.debug('Title Indicator: '+ldrTitle.EXEC_IND__c);
            System.debug('Title Nbr: '+ldrTitle.LDRSHP_TITL_LVL_NR__c);
            
            nLdrNbr = Integer.valueOf(ldrTitle.LDRSHP_TITL_LVL_NR__c);
            System.debug('nLdrNbr: '+nLdrNbr);
        } catch(Exception exe) {
            System.debug('Leader Title Exception: '+exe);
        }       
        return nLdrNbr;
    }
    
    /**
        *  This method is used to sum
        *  all the values from a list of decimal
        *  value
        *
        *  Created on 20 Apr, 2012
        *  Created by Raktim Sarkar
        *
        *
    **/
    public static decimal sumDecimalValues(List<decimal> lst_Dec_Values)
    {
        decimal sum = 0.00;
        
        try{
            for(decimal d : lst_Dec_Values){
                sum+= d;    
            }   
        }catch(Exception e){
        //System.debug('\n CAUGHT EXCEPTION in sumDecimalValues . YOUUtil ');
            throw e;
        }
        return sum;
    } // End of method  
    
    
        /**
        * There are two way to fetch the current camapaign.
        * 1) To query the Market Object and fetch the field name CMPGN_NR__c or 
        * CURRENT_CAMPAIGN_NR__c
        * 2) To query the Calender Object check the CURRNT_IND__c field as checked.
        *
        * Since Calender object is still not configure we are using the Market 
        * Object to fetch the current campaign.
        *
        **/
        public static List<String> get3CampaignNumbers(String marketId)
        {
            String[] mrktCampaigns;
            Market__c market;
            try {
                market    = [SELECT CMPGN_NR__c,NEXT_1_CMPGN_NR__c,PREV_1_CMPGN_NR__c 
                             FROM Market__c 
                             WHERE Market_Id__c = :marketId];               
                mrktCampaigns[0] = market.PREV_1_CMPGN_NR__c;
                mrktCampaigns[1] = market.CMPGN_NR__c;
                mrktCampaigns[2] = market.NEXT_1_CMPGN_NR__c;
                
            }catch (Exception e){
                throw e;
            }
            
            return mrktCampaigns;
        }
        
        public static Integer getCurrentCampaignNumber(String marketId){
            Integer currCampaign;
            Market__c market;
            try {
                market    = [SELECT CMPGN_NR__c 
                             FROM Market__c 
                             WHERE Market_Id__c = :marketId];
                /*
                Calendar__c cal  = [SELECT CMPGN_NR__c 
                                    FROM Calendar__c 
                                    WHERE MRKT_ID__c = :marketId 
                                    AND CURRNT_IND__c = true];
                */
                currCampaign = Integer.valueOf(market.CMPGN_NR__c);
            }catch (Exception e){
                throw e;
            }
            

            
            //currCampaign = cal.CMPGN_NR__c;
            return currCampaign;
        }

        /**
        * Function to fetch the privious campaign
        *
        *
        **/
        public static List<Integer> getXPriorCampaignList(String marketId, 
                                                Integer NbrOfCampgn){
            Integer currCampaign = getCurrentCampaignNumber(marketId);
            List<Integer> priorCampgnList = new List<Integer>{};
            for (Calendar__c campgn : [SELECT CMPGN_NR__c FROM Calendar__c 
                                WHERE MRKT_ID__c = :marketId 
                                AND CMPGN_NR__c < :currCampaign 
                                ORDER BY CMPGN_NR__c DESC 
                                LIMIT :NbrOfCampgn] )
            {
                priorCampgnList.add(campgn.CMPGN_NR__c.intValue());
            }
    
            return priorCampgnList;
        }
    
        public static List<Integer> getXFutureCampaignList(String marketId, 
                                                Integer NbrOfCampgn){
            Integer currCampaign = getCurrentCampaignNumber(marketId);
            List<Integer> futureCampgnList = new List<Integer>{};
            for (Calendar__c campgn : [SELECT CMPGN_NR__c FROM Calendar__c 
                                WHERE MRKT_ID__c = :marketId 
                                AND CMPGN_NR__c > :currCampaign 
                                ORDER BY CMPGN_NR__c ASC 
                                LIMIT :NbrOfCampgn] )
            {
                futureCampgnList.add(campgn.CMPGN_NR__c.intValue());
            }
            return futureCampgnList;
        }
    
        public static List<List<String>> sortbycoldesc(List<List<String>> lst_TempOutpt, Integer a,String b)
        {                   
            Integer totalRows=lst_TempOutpt.size();
            if(b.equals('Text')){
                for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a] == '--')
                        lst_TempOutpt[k][a]=null;
                    for(Integer i=0; i < totalRows; i++){
                        integer indx_of_min=i;
                        for(Integer j=i; j < totalRows; j++){
                            if(lst_TempOutpt[indx_of_min][a] < lst_TempOutpt[j][a]){
                                indx_of_min= j;
                            } //for First Name
                        }
                        List<String> temp=lst_TempOutpt[i];
                        lst_TempOutpt[i] = lst_TempOutpt[indx_of_min];
                        lst_TempOutpt[indx_of_min] =temp;
                    }
                    for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a]==null)
                        lst_TempOutpt[k][a]='--';
            }
            
            if(b.equals('Number')){
                for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a] == '--')
                        lst_TempOutpt[k][a]=null;
                    for(Integer i=0; i < totalRows; i++){
                        integer indx_of_min=i;
                        for(Integer j=i; j < totalRows; j++){
                            if(Decimal.valueOf(lst_TempOutpt[indx_of_min][a]) < Decimal.valueOf(lst_TempOutpt[j][a])){
                                indx_of_min= j;
                            } //Swaping
                        }
                        List<String> temp=lst_TempOutpt[i];
                        lst_TempOutpt[i] = lst_TempOutpt[indx_of_min];
                        lst_TempOutpt[indx_of_min] =temp;
                    }
                    for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a]==null)
                        lst_TempOutpt[k][a]='--';
            }
            return lst_TempOutpt;
        }//End of sortbycoldesc
        
        public static List<List<String>>  sortbycolasc(List<List<String>> lst_TempOutpt ,Integer a,String b)
        {   
            System.debug('\n ###### Util sortbycolasc  a'+a);
            System.debug('\n ###### Util sortbycolasc  b'+b);
            Integer totalRows=lst_TempOutpt.size(); 
            if(b.equals('Text'))
            {for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a] == '--')
                        lst_TempOutpt[k][a]=null; 
                    for(Integer i=0; i < totalRows; i++){
                        integer indx_of_min=i;
                        for(Integer j=i; j < totalRows; j++){
                            if(lst_TempOutpt[indx_of_min][a] > lst_TempOutpt[j][a]){
                                indx_of_min= j;
                            } //for First Name
                        }
                        List<String> temp=lst_TempOutpt[i];
                        lst_TempOutpt[i] = lst_TempOutpt[indx_of_min];
                        lst_TempOutpt[indx_of_min] =temp;
                    }
                    for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a]==null)
                        lst_TempOutpt[k][a]='--';
            }
            
            if(b.equals('Number'))
            {for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a] == '--')
                        lst_TempOutpt[k][a]=null;    
                    for(Integer i=0; i < totalRows; i++){
                        integer indx_of_min=i;
                        for(Integer j=i; j < totalRows; j++){
                            if(Decimal.valueOf(lst_TempOutpt[indx_of_min][a]) > Decimal.valueOf(lst_TempOutpt[j][a])){
                                indx_of_min= j;
                            } //Swaping
                        }
                        List<String> temp=lst_TempOutpt[i];
                        lst_TempOutpt[i] = lst_TempOutpt[indx_of_min];
                        lst_TempOutpt[indx_of_min] =temp;
                    }
                    for(Integer k=0;k<totalRows;k++)
                    if(lst_TempOutpt[k][a]==null)
                        lst_TempOutpt[k][a]='--';
            }
            
            System.debug('\n ###### Util sortbycolasc  lst_TempOutpt \n'+lst_TempOutpt);
            
            return lst_TempOutpt;
        }  
        
        public static String getCampaignNumbrMailPlan(String campaign)
       {
       		String campaignNumbrMailPlan = '';
       		
       		String monthMailPlan = getMonthMailPlan(campaign);
       		
       		Date currDate = System.today();
       		//Added by Milon on 12/5/2013
       		Integer currMonth = currDate.month();
       		Integer currentCampaign = Integer.valueOf(monthMailPlan);
       		       		   		
       		Integer currYear = currDate.year();
       		
       		If(currMonth == 12 && (currentCampaign == 1 || currentCampaign == 2)){
       			currYear = currYear + 1;
       		}else{
       			currYear = currYear;
       		}
       		campaignNumbrMailPlan = String.valueOf(currYear) + monthMailPlan;
       		
       		System.debug('\n campaignNumbr MailPlan -->> '+campaignNumbrMailPlan);
       		return campaignNumbrMailPlan;
       			
       }   
        
        
       public static String getMonthMailPlan(String campaign)
       {
       		String campaignNumbr = '';
       		
       		if(campaign != null && !campaign.trim().equals('') && campaign.length() == 1)
       		{
       			campaignNumbr = '0' + campaign;	// '01'
       			
       		}else{
       			campaignNumbr = campaign;	//10
       		}
       		
       		System.debug('\n campaign Numbr -->> '+campaignNumbr);
       		return campaignNumbr;
       			
       } 
       
       
       // Genealogy Custom data retrieved - added by Rajib, START
               public static Map<String, List<Genealogy_Field_Detail__c>> getGenealogyMapFields( ID mrkt_ID){
               	Map<String, List<Genealogy_Field_Detail__c>> map_GenFlds = new Map<String, List<Genealogy_Field_Detail__c>>();
       	 		List<Genealogy_Field_Detail__c> listGenFld = new List<Genealogy_Field_Detail__c>();
       	 		List<Genealogy_Field_Detail__c> listOverlayFld = new List<Genealogy_Field_Detail__c>();
               	
               	Market__c gen_market = [ Select  Id,Genealogy_Root_Node_Section__c,Genealogy_Overlay_Section__c 
                                       From    
                                               Market__c
                                       Where   
                                               ID =:mrkt_ID];                                        
                   
           	for(Genealogy_Field_Detail__c repfld : [select Name, Type__c, Fields_To_Map__c, Group__c, Column__c from Genealogy_Field_Detail__c  order by Column__c, Order__c]) {
           		 if(repfld.Group__c == 'Root') {
           		 	if(gen_market.Genealogy_Root_Node_Section__c != null && gen_market.Genealogy_Root_Node_Section__c.indexOf(repfld.Name)>-1) {
           		 		if(repfld.Fields_To_Map__c != null) {
           		 			listGenFld.add(repfld);
           		 		}
           		 	}
           		 }else if(repfld.Group__c == 'Overlay')
           		 {  
           		 	if(gen_market.Genealogy_Overlay_Section__c != null && gen_market.Genealogy_Overlay_Section__c.indexOf(repfld.Name)>-1) {    		 		
           		 		if(repfld.Fields_To_Map__c != null) {
           		 			listOverlayFld.add(repfld);
           		 		}
           		 	}
           		 
           		 	
           		 }
           	}
           	map_GenFlds.put('Root',listGenFld);
           	map_GenFlds.put('Overlay',listOverlayFld); 
           	System.debug('map_GenFlds at YouUtil'+map_GenFlds);                           
                
            return map_GenFlds;
               
        }// Genealogy Custom data retrieved - added by Rajib, END
        
       
       
       public static String getDateFormat(String userLocale)
       {
       		String dateFormat = 'MM/dd/yyyy';
       		Locale_Date_Format__c localDateFormat;
            try {
                localDateFormat   = [SELECT Name,DateFormat__c 
                             FROM Locale_Date_Format__c 
                             WHERE Name = :userLocale];
                              
                dateFormat = localDateFormat.DateFormat__c;
                
            }catch(Exception ex){
            	System.debug('Date Format Error :'+ex);
            }
            
       		return dateFormat;	
       } 
       
       // Comma Separator Change - added by Raktim on 6th Sept, 2013 START
       public static List<String> getLocaleSeparator(String userLocale)
       {
       		List<String> lstSepartr = new List<String>();
       		Locale_Separator__c localeSeparator;
       		
            try {
                localeSeparator   = [SELECT Name, Comma_seprtr__c, Deciml_seprtr__c  
                             		FROM Locale_Separator__c  
                             		WHERE Name = :userLocale LIMIT 1];
                              
                lstSepartr.add(localeSeparator.Comma_seprtr__c);
                lstSepartr.add(localeSeparator.Deciml_seprtr__c);
                
            }catch(Exception ex){
            	System.debug('\n Locale Separation Error : '+ex);
            	
            	lstSepartr.add(',');
                lstSepartr.add('.');
            }
            
       		return lstSepartr;	
       		
       }// Comma Separator Change - added by Raktim on 6th Sept, 2013 END     
     
     
     //@T-214186 : Commented by Barkha Jain on Nov 21
     /*   public static testmethod void testCampaignUtil(){
            TestDataHelper testData = new TestDataHelper();
            Market__c mkt = testData.createMarket();
            mkt.Mail_Plan_Enabled__c=false;
            mkt.CMPGN_NR__c = '201202';
            update mkt;
            User ldrUser;
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                ldrUser = testData.createLeaderUser('test123');
            }
    
            //Change the owner to Curent user.
            mkt.OwnerId = ldrUser.Id;
            update  mkt;
            
            //Creating the current Campaign Data
            List<Calendar__c> toInsrtSub = new List<Calendar__c>();
    
            Calendar__c mktCampaign = new Calendar__c(Name='201202',
                CMPGN_NR__c=201202, MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
    
            //Creating the privious Campaign Data
            mktCampaign = new Calendar__c(Name='201201',CMPGN_NR__c=201201,
                            MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
            mktCampaign = new Calendar__c(Name='201112',CMPGN_NR__c=201112,
                            MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
            mktCampaign = new Calendar__c(Name='201111',CMPGN_NR__c=201111,
                            MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
    
    
            //Creating the future Campaign Data
            mktCampaign = new Calendar__c(Name='201203',CMPGN_NR__c=201203,
                            MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
            mktCampaign = new Calendar__c(Name='201204',CMPGN_NR__c=201204,
                            MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
            mktCampaign = new Calendar__c(Name='201205',CMPGN_NR__c=201205,
                            MRKT_ID__c=mkt.Market_Id__c ,Market__c=mkt.Id);
            toInsrtSub.add(mktCampaign);
            
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
                
                List<Integer> actualPriorCmpg = 
                YOUUtil.getXPriorCampaignList(marketId,4);
                List<Integer> actualFutureCmpg = 
                YOUUtil.getXFutureCampaignList(marketId,4);
                System.assertEquals(201201,actualPriorCmpg[0]);
                System.assertEquals(201203,actualFutureCmpg[0]);     
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
            TestDataHelper testData = new TestDataHelper();
            Market__c mkt = testData.createMarket();
            mkt.Mail_Plan_Enabled__c=false;
            update mkt;
            User ldrUser;
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            List<String> teststr= new List<String>{'test1','test2','test3'};
            List<String> teststr1= new List<String>{'test4','test5','test6'};
            List<List<String>> lls=new List<List<String>>{teststr,teststr1};
            sortbycoldesc(lls,1,'Text');
            sortbycolasc(lls,1,'Text');
            System.runAs ( thisUser ) {
                ldrUser = testData.createLeaderUser('test123');
            }
            
            System.runAs(ldrUser){
                //CampaignUtil util = new CampaignUtil();
                String marketId = mkt.Market_Id__c;
                try {
                List<Integer> actualPriorCmpg = 
                YOUUtil.getXPriorCampaignList(marketId,4);
                }Catch(Exception e){
                    System.debug('DEBUG MESSAGE '+e.getMessage());
                }
            }

        }*/
    
}