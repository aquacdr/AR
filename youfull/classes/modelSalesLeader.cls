/*******************************************************************************
 Name          : modelSalesLeader 
 Description   : Modelling SalesLeader
 Created By    : Parul Gupta 
 Created Date  : 4 Feb, 2014               
*******************************************************************************/
public class modelSalesLeader extends modelPerson{
	
	public Market__c market {get;set;} 
	
	//========================================================================//
  	// Method returns current campaign
  	//========================================================================//
	Public override String getCurrentCampaign(){
		return market.CMPGN_NR__c;
	}
	
	//========================================================================//
  	// Method returns previous campaign
  	//========================================================================//
	Public override String getPreviousCampaign(){
		return market.PREV_1_CMPGN_NR__c;
	}
	
	//========================================================================//
  	// Method returns mail plan
  	//========================================================================//
	Public override MailPlan_Order_Oppty__c getMailPlan(){
		MailPlan_Order_Oppty__c mailPlan = [SELECT SLS_ZONE_CD__c, 
											NEXT_MLPLN_TO_CLOS_CD__c, MRKT_ID__c, 
                                            MLPLN_CD__c, CURRNT_NEXT_CMPGN_PRFX_CD__c, 
                                            CURRNT_CMPGN_ONLN_RMN_DAY_CNT__c, CURRNT_CMPGN_MAIL_RMN_DAY_CNT__c, 
                                            CMPGN_NR__c ,MLPLN_END_DT__c
                                            FROM MailPlan_Order_Oppty__c 
                                            WHERE Market__c = :market.Id
                                            AND MLPLN_END_DT__c >= today
                                            AND MLPLN_CLOSD_IND__c != 'Y'
                                            ORDER BY MLPLN_END_DT__c];
		return mailPlan;
	}
}