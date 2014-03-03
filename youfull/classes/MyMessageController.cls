public class MyMessageController {

  private Integer NBR_OF_DAYS = -90;
  public ALM_Global_Settings__c globalConfig {get; set;}    
  public User currUsr{get;set;}    
  public Market__c market{get;set;}
  public String repDetailAcctNbr {get; set;}//subhamay 17092013 to display coaching record page
  public MyMessageController(){
  this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting(); 
  currUsr = [Select  Id,MRKT_ID__c,Name,LastName, LanguageLocaleKey, FirstName,MRKT_ID_ACCT_NR_KEY__c,Profile.Name,LDRSHP_TITL_LVL_NBR__c    
      from User             
      where   Id = :UserInfo.getUserId()];                 
  market = [select Id,Market_Id__c,Omniture_Suite_Name__c           
      from Market__c            
      where Market_Id__c =:currUsr.MRKT_ID__c];
  }
  public List<ECardWrapper> getECardHistories(){
    Boolean oddRow=true;
    List<ECardWrapper> ecardHistories  =new List<EcardWrapper>();
    Date last90Days = System.today().addDays(NBR_OF_DAYS);
    for(Ecard_History__c eCard: [  select Id,CreatedDate,Name,Success__c,Failed__c,No_Email__c,No_Email_Count__c,Success_Count__c,Failed_Count__c
                    from Ecard_History__c
                    where OwnerId=:UserInfo.getUserId()
                    and  Status__c!='Closed'
                    and CreatedDate >=:last90Days
                    order by CreatedDate desc])
    {
      eCardHistories.add(new EcardWrapper(eCard,oddRow));
      oddRow=!oddRow;      
    }
    return eCardHistories;
  }
	//subhamay 17092013_to display coaching record page from Ecards History
	public PageReference callRepDetails() {
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
    }
    //eoc subhamay 17092013_to display coaching record page from Ecards History
    
   public class ECardWrapper{
     public ECard_History__c eCard {get; private set;}
     public Boolean oddRow {get; set;}
     public ECardWrapper(Ecard_History__c hist,Boolean oddRow){
       this.eCard=hist;
       this.oddRow=oddRow;
     }
   }
   public String getOmniturePageName()            
   {return ALMPlusUtils.generateOmniturePageName('MyMessage', null, currUsr.Profile.Name); }
   
   //@S-144891 : Commented by Blaine Rothrock on Nov 23
   /*@isTest(SeeAllData=true)
    public static  void testmyMessage(){
      TestDataHelper testdata = new TestDataHelper();
      testData.createMarket();
      Market__c mkt = testData.market;

    User ldrUsr = testData.createLeaderUser('123456789z');
    
    // Added by Raktim on 28Dec, 2012 - Start
    mkt.OwnerId = ldrUsr.Id;
    update mkt;
    // Added by Raktim on 28Dec, 2012 - End
    
    Ecard_History__c ecardHist = new ECard_History__c(OwnerId=ldrUsr.Id,Name='Test eCard');
    insert ecardHist;
        Test.setCurrentPage(Page.MyMessage);

    System.runAs(ldrUsr){        
          MyMessageController controller = new MyMessageController();
          system.assert(controller.getECardHistories().size()==1);
    }    
    }*/


}