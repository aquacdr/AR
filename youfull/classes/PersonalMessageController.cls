/*
*       Created By Snehashis :controller for Personal Message
*
*/

public class PersonalMessageController {
    
    public String recpntId {get; set;}
    public String persMsgSubj {get; set;}   
    public String persMsgDetl {get; set;}
    public List<String> pageMsgs {get; set;}
    public ALM_Global_Settings__c globalConfig {get; set;}
    public User currUsr{get;set;}
    public Market__c market{get;set;}
    public Boolean sendSuccess{get;private set;}
    
    
     public PageReference emailSelectedPersonalMsg(){
        try{
            sendSuccess=false;
            
            pageMsgs=new List<String>();
            ALMLogUtils.log('PersonalMessageController.emailSelectedPersonalMsg','recpntId:'+this.recpntId);
            List<String> idLst=new List<String>();
            if(recpntId.contains(',')){
                for(String s:recpntId.split(',')){
                    idLst.add(s.trim());
                }
            }else{
                idLst.add(recpntId.trim());
            }
            ALMLogUtils.log('PersonalMessageController.emailSelectedPersonalMsg','Personal Email Subject:'+this.persMsgSubj);
            ALMLogUtils.log('PersonalMessageController.emailSelectedPersonalMsg','Personal Email Detail:'+this.persMsgDetl);
            ALMLogUtils.log('PersonalMessageController.emailSelectedPersonalMsg','emailRecipent:'+idLst);
            EmailUtils.sendFreeFormEmail(idLst, this.persMsgSubj,this.persMsgDetl);
            
            
            pageMsgs.add(System.Label.Email_Confirmation_Msg);
            sendSuccess=true;
            
            
        }catch(Exception ex){
            ALMLogUtils.log('PersonalMessageController', 'recpntId is null (No Recipient Found) --> '+recpntId+' --- '+ex.getMessage());
        }   
    
        return null;
    }
    public String getOmniturePageName()         
   {
    
    this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
    this.currUsr = [Select  Id,MRKT_ID__c,Name,LastName, LanguageLocaleKey, FirstName,MRKT_ID_ACCT_NR_KEY__c,Profile.Name,LDRSHP_TITL_LVL_NBR__c
            from User
             where   Id = :UserInfo.getUserId()]; 
     
    this.market = [select Id,Market_Id__c,Omniture_Suite_Name__c
            from Market__c
            where Market_Id__c =:currUsr.MRKT_ID__c];
     
    return ALMPlusUtils.generateOmniturePageName('PersonalMessage', null, currUsr.Profile.Name);    
    }
    	//@S-144891 : Commented by Blaine Rothrock on Nov 23
        /*@isTest(SeeAllData=true)
        public static void testPersonalMessageController()
        {
	        String acctNbr = '123456';
	        TestDataHelper testData = new TestDataHelper();
	        User testUsr;
	        Market__c testMrkt;
	        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
	        System.runAs ( thisUser ) {
	            testUsr = testData.createLeaderUser(acctNbr);
	            
	            testMrkt = testData.createMarket(acctNbr);
	            
	            testMrkt.OwnerId = testUsr.Id;
	            update testMrkt;
	            
	        }
	        PersonalMessageController ctlr = new PersonalMessageController();
	        System.runAs(testUsr){
	            ctlr.recpntId='alm@avon.com,myemail@avon.com';
	            ctlr.persMsgSubj='Test Subject';
	            ctlr.persMsgDetl='Test Details';
	            ctlr.emailSelectedPersonalMsg();
	             System.assert(ctlr.getOmniturePageName()=='Sent Message_SL');
	        }   
    	}*/
}