/***************************************************************************
 Name          : Controller_SLCoachingRecord
 Created By    : Barkha Jain 
 Description   : Controller for CoachingRecord page
 Created Date  : 20 Dec, 2013                
****************************************************************************/
public class Controller_SLCoachingRecord{
    public User currentUser {get; set;}
    public Contact contactUser {get; set;}
    public ALM_Rep_Performance_1__c almRep {get; set;}
    
    public Controller_SLCoachingRecord(){
        init();
    }
    
    private void init(){
     currentUser = [Select Name, MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c, MLPLN_CD__c, USER_CNTRY_CD__c, 
                    LastName, LanguageLocaleKey, FirstName, MRKT_ID_ACCT_NR_KEY__c, DFALT_ZONE_CD__c, 
                    DFALT_DIV_NM__c, ACCT_NR__c, Profile.Name, LDRSHP_TITL_LVL_NBR__c 
                    From User where Id = :UserInfo.getUserId()]; 
     
     for(Contact con : [Select Name, MRKT_ID__c,LDR_TYP__c, MLPLN_CD__c, MRKT_ACCT_KEY__c, LOA_NR__c, LDRSHP_TITL_LVL_DESC__c,
                        SLS_ZONE_CD__c, ACCT_NR__c, REP_APPT_CMPGN_NR__c, REP_EMAIL_ADDR_TXT__c, REP_LANG_CD__c
                        From Contact where MRKT_ACCT_KEY__c =:currentUser.MRKT_ID_ACCT_NR_KEY__c]){
        contactUser = con;  
     }
     
     for(ALM_Rep_Performance_1__c rep : [Select RSNG_STR_IND__c, ACCT_NR__c, ZONE_MGR_NAME__c, G1_ACTV_BASE_CNT__c, UPLN_SLS_ZONE_CD__c 
                                         From ALM_Rep_Performance_1__c
                                         where ACCT_NR__c =:currentUser.ACCT_NR__c limit 1]){
        almRep = rep;
     }                  
    } 
    
    public PageReference doNothing(){return null;}  
    
    
}