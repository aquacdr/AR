public class HomePageController {
  
  public Boolean widgetMode {get; set;}
  public User currUsr {get; set;}  
  public Market__c market {get; set;}
  public User_Login_Param__c usrLogParam {get; set;}
  public Boolean isHotLead {get; set;}
  
  
  public PageReference init(){
    String titleLevelNbr; //Added by Milon to support the title level
    this.widgetMode=false;
    this.isHotLead=false;
    //Added LDRSHP_TITL_LVL_NBR__c By milon
    currUsr = [select Id,MRKT_ID__c,ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c ,Profile.Name,
            LDRSHP_TITL_LVL_NBR__c
            from User 
            where Id=:UserInfo.getUserId()];
    titleLevelNbr = currUsr.LDRSHP_TITL_LVL_NBR__c;//Added by milon
    PageReference landingPage;
    market = [select Id,ALM_Rep_Indicator__c,CMPGN_NR__c,Splash_Page_Enabled__c,Site_Maintenance_Enabled__c,Is_ALMPLUS_Enabled__c
              from Market__c
              where Market_Id__c=:currUsr.MRKT_ID__c];
              
    DownloadAll_GenIndex__c genIndexCustomSetting=DownloadAll_GenIndex__c.getOrgDefaults();  
    genIndexCustomSetting.Market_Id__c= currUsr.MRKT_ID__c;
    genIndexCustomSetting.Data_Object_Name__c= market.ALM_Rep_Indicator__c;
    genIndexCustomSetting.Accnt_Nr__c=currUsr.ACCT_NR__c;
    genIndexCustomSetting.SelectedCampaign__c=market.CMPGN_NR__c;
    //update genIndexCustomSetting;
         
    //if(market.Show_Maintenance_Page__c){
    //ALM+ Change by Snehashis
    System.debug('>>>>>> Inside ALM+ Loop');
    if(market.Is_ALMPLUS_Enabled__c && currUsr.Profile.Name!=ALMPLusConstants.AVON_DM){
      System.debug('>>>>>> Inside ALM+ Loop 2');
      try{
        String myLeadpgId= ALMPLusConstants.HOTLEAD_PGID_VALUE;
        usrLogParam = [select Id, MRKT_ID__c, Report_Id__c,Report_type__c,User_Id__c,LastModifiedDate,Page_Id__c,Is_My_Lead__c,Is_Widget__c
              from User_Login_Param__c
              where User_Id__c=:currUsr.Id and Is_My_Lead__c=true and Page_Id__c=:myLeadpgId];
        System.debug('>>>>>> Inside ALM+ Loop 3'+usrLogParam);
        if(usrLogParam !=null){
          //handle hot links Widget
          if(usrLogParam.Is_Widget__c){
            this.widgetMode=true;
            usrLogParam.Is_Widget__c=false;
            delete usrLogParam;
        }else{
          //handles hot links button click
            this.isHotLead=true;
        }
        }
      }catch(Exception e){
        system.debug(e.getMessage());
        }
    }
    
    /* Code change by Snehashis Ghosh on 19 Apr 2010 */
      if(currUsr.Profile.Name == 'Avon Leader'){
      try{
        Contact usrCont = [select Id,ALM_Last_Login__c, MRKT_ACCT_KEY__c
                from Contact
                where   MRKT_ACCT_KEY__c=:currUsr.MRKT_ID_ACCT_NR_KEY__c];
        usrCont.ALM_Last_Login__c = System.today();
          update usrCont;
          //Configure for WidgetLogin Jan-23-2011
          if(!isHotLead){
            ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
            Integer addMins = (globalConfig.Widget_Lifetime__c).intValue();
            Datetime currTime = Datetime.valueOfGmt(System.now().format('yyyy-MM-dd HH:mm:ss','GMT'));
            Datetime newDate = Datetime.valueOfGmt(System.now().addMinutes(addMins).format('yyyy-MM-dd HH:mm:ss','GMT'));
            ALMLogUtils.log('HomePageController','The Value of Date !!!!'+newDate+'Currtime>>>>>>'+currTime+'><><><>< Current User >>'+currUsr.Id);
            usrLogParam = [select MRKT_ID__c, Report_Id__c,Report_type__c,User_Id__c,LastModifiedDate,Page_Id__c,Is_My_Lead__c
                from User_Login_Param__c
                where User_Id__c=:currUsr.Id and (LastModifiedDate>=:newDate and LastModifiedDate<=:currTime)];
          }
          } catch(Exception e){
          system.debug(e.getMessage());
          }
      }
    
    if(usrLogParam !=null && !isHotLead){
      this.widgetMode=true;
    }
    if(widgetMode){
      if(usrLogParam.Is_My_Lead__c){
        landingPage = Page.MyLeads;
        landingPage.getParameters().put('pgId',ALMPLusConstants.HOTLEAD_PGID_VALUE);
      }else{
         landingPage = new PageReference(this.usrLogParam.Report_Id__c);
       }
      return landingPage;
    }else{
      if(market.Site_Maintenance_Enabled__c){
        landingPage = Page.ShowMarketdocument;
        landingPage.getParameters().put('type','Site Maintenance');
        landingPage.setRedirect(false);
        return landingPage;
      }else if(market.Splash_Page_Enabled__c){
        landingPage = Page.ShowMarketdocument;
        landingPage.getParameters().put('type','Splash Page');
        landingPage.setRedirect(false);
        return landingPage;  
      } else{
        return gotoHomeTab(currUsr.Profile.Name,titleLevelNbr);
      }
    //  return landingPage;
    }
  }
  
  public PageReference gotoHomeTab(String usrProfile, String titleLevelNbr){
    PageReference landingPage;
    if(usrProfile == 'Avon Leader'){
      if(this.isHotLead){
        landingPage = Page.MyLeads;
        landingPage.getParameters().put('pgId',ALMPLusConstants.HOTLEAD_PGID_VALUE);
      }else{
        
        landingPage = Page.YOUHome;
        landingPage.getParameters().put('pgId','1');
      }
    }else if(usrProfile.contains(ALMPlusConstants.AVON_ZM_BASE)){
      if(this.isHotLead){
        landingPage = Page.MyLeads;
        landingPage.getParameters().put('pgId',ALMPLusConstants.HOTLEAD_PGID_VALUE);
      }
      /* Milon Comment start
      else{
      //  landingPage = Page.SalesOrgActivity;
        landingPage.getParameters().put('pgId','8');
      }
    }else if(usrProfile == 'Avon Division Manager'){
     // landingPage = Page.SalesOrgActivity;
      landingPage.getParameters().put('pgId','8');
      Milon comment end*/
    }
    
    return landingPage;
  }
  public static testmethod void testHomePage(){
    HomePageController ctlr = new HomePageController();
    String mktIdKey = 'TEST123456';
    TestDataHelper testData = new TestDataHelper();
    User testUsr = testData.createLeaderUser(mktIdKey);
    Contact ldrContact = testData.createContact(mktIdKey,UserInfo.getUserId());
    User zoneUsr = testData.createZoneUser('Z'+mktIdKey);
    User divUsr = testData.createDivUser('D'+mktIdKey);
    //Added by milon
    testUsr.LDRSHP_TITL_LVL_NBR__c = '1';
    zoneUsr.LDRSHP_TITL_LVL_NBR__c = '1';
    divUsr.LDRSHP_TITL_LVL_NBR__c = '1';
    update testUsr;
    update zoneUsr;
    update divUsr;
    //Milon addition end
    
    //Changed by Raktim on 28Dec, 2012 - Start
    Market__c market = testData.createMarket();
    market.Splash_page_Enabled__c=true;
    market.OwnerId = testUsr.Id;
    update market;
    //Changed by Raktim on 28Dec, 2012 - End
    
    System.runAs(testUsr){
      PageReference pageRef = ctlr.init();
      
      //Changed by Raktim on 28Dec, 2012 - Start
      //System.assert(pageRef.getUrl()=='/apex/YOUHome?pgId=1');   
      System.assert(pageRef.getUrl()=='/apex/showmarketdocument?type=Splash+Page'); 
      //Changed by Raktim on 28Dec, 2012 - End
    }
    /* Milo Comment start
    System.runAs(zoneUsr){
      PageReference pageRef = ctlr.init();
      System.debug('&&&&&&&&&&&&&&&&&& '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');  
    }
    System.runAs(divUsr){
      PageReference pageRef = ctlr.init();
      System.debug('&&&&&&&&&&&&&&&&&& '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');  
    }
    Milon comment end*/
    
    //Changed by Raktim on 28Dec, 2012 - Start
    /*
    testData.market.Splash_page_Enabled__c=true;
    testData.market.OwnerId = testUsr.Id;
    update testData.market;    
    */  
    //Changed by Raktim on 28Dec, 2012 - End
        
    system.runAs(testUsr){
      PageReference pageRef = ctlr.init();
      
      //Changed by Raktim on 28Dec, 2012 - Start
      //System.assert(pageRef.getUrl()=='/apex/ShowMarketDocument?type=Splash+Page');
      System.assert(pageRef.getUrl()=='/apex/showmarketdocument?type=Splash+Page');
      //Changed by Raktim on 28Dec, 2012 - End
    }
    
    /*testData.market.Site_Maintenance_Enabled__c=true;
    update testData.market;*/
    
    market.Site_Maintenance_Enabled__c=true;
    update market;
    
    system.runAs(testUsr){
      PageReference pageRef = ctlr.init();
      
      //Changed by Raktim on 28Dec, 2012 - Start
      //System.assert(pageRef.getUrl()=='/apex/ShowMarketDocument?type=Site+Maintenance');
      System.assert(pageRef.getUrl()=='/apex/showmarketdocument?type=Site+Maintenance');
      //Changed by Raktim on 28Dec, 2012 - End
    }
      
  }
  
  //@S-144891 : Commented by Blaine Rothrock on Nov 23
  /*public static testmethod void testALMPlusHomePage(){
    String mktIdKey = 'TEST123456';
    List<User> usrLst = new List<User>();
    TestDataHelper testData = new TestDataHelper();
    Market__c market = testData.createMarket();
        market.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        market.Eligibility_Yes_Flags__c='Opt_In__c';
        market.Is_ALMPLUS_Enabled__c=true;
        testData.market.Splash_page_Enabled__c=false;
        update market;
        //Creating Test Leader User
    User testLdrUsr = testData.createLeaderUser(mktIdKey);
    testLdrUsr.ZM_Override__c=false;
        testLdrUsr.Opt_In__c=true;
        testLdrUsr.isActive=true;
        usrLst.add(testLdrUsr);
        User zoneUsr = testData.createZoneUser('Z'+mktIdKey);
        zoneUsr.isActive=true;
        usrLst.add(zoneUsr);
    User divUsr = testData.createDivUser('D'+mktIdKey);
    divUsr.isActive=true;
    usrLst.add(divUsr);
    update usrLst;
    
    //Changed by Raktim on 28Dec, 2012 - Start
    market.OwnerId = testLdrUsr.Id;
    update market;
    //Changed by Raktim on 28Dec, 2012 - End
    
    Contact ldrContact = testData.createContact(mktIdKey,testLdrUsr.Id);
    
    //Creating User login param record to be created upon click GI_3 Link
    List<User_Login_Param__c> ulpLst = new List<User_Login_Param__c>();
    User_Login_Param__c testULP1 = new User_Login_Param__c(User_Id__c=testLdrUsr.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=testLdrUsr.Id); 
    User_Login_Param__c testULP2 = new User_Login_Param__c(User_Id__c=zoneUsr.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=zoneUsr.Id); 
    ulpLst.add(testULP1);
    ulpLst.add(testULP2);
        insert ulpLst;
        
    //Added by milon
    testLdrUsr.LDRSHP_TITL_LVL_NBR__c = '1';
    divUsr.LDRSHP_TITL_LVL_NBR__c = '1';
    update testLdrUsr;
    update divUsr;
    //Milon addition end
    
    //testing standard leader login upon clicking HotLead Link on GI_3
    HomePageController ctlrAlmpLdr = new HomePageController();
    System.runAs(testLdrUsr){
      PageReference pageRef = ctlrAlmpLdr.init();
      System.debug('&&&&&&&&&&&&&&&&&& '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/MyLeads?pgId=40');  
    }
    //Testing 2nd time login when clicking on Activate User link on Gi_3
    System.runAs(testLdrUsr){
      PageReference pageRef = ctlrAlmpLdr.init();
      System.debug('&&&&&&&&&&&&&&&&&& '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/MyLeads?pgId=40');  
    }
    /*
    HomePageController ctlrAlmpZM = new HomePageController();
    System.runAs(zoneUsr){
      PageReference pageRef = ctlrAlmpZM.init();
      System.debug('&&&&&&&&&&&&&&&&&& '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/MyLeads?pgId=40');  
    }
 
    //Assuming Division Manager on Gi_3 will not have Hot Lead Links
    HomePageController ctlrAlmpDM = new HomePageController();
    /* Milon comment Start
    System.runAs(divUsr){
      PageReference pageRef = ctlrAlmpDM.init();
      System.debug('&&&&&&&&&&&&&&&&&& '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');  
    }
    Milon comment end
    
    //Testing for Widget login
    HomePageController ctlrAlmpLdrWid = new HomePageController();
    testULP1.Is_Widget__c=true; 
    update testULP1;
    system.runAs(testLdrUsr){
      PageReference pageRef = ctlrAlmpLdrWid.init();
      System.debug('!!!!!!!!!!!!!!!!!!!! '+pageRef.getUrl());
      System.assert(pageRef.getUrl()=='/apex/MyLeads?pgId=40');
    }
    User_Login_Param__c testULPWid2 = new User_Login_Param__c(User_Id__c=testLdrUsr.Id, Report_Id__c='XX20',Page_Id__c='40', Is_My_Lead__c=false,ownerId=testLdrUsr.Id); 
    insert testULPWid2;
    system.runAs(testLdrUsr){
      PageReference pageRef = ctlrAlmpLdrWid.init();
      System.debug('!!!!!!!!!!!!!!!!!!!! '+pageRef.getUrl());
    //  System.assert(pageRef.getUrl()=='/apex/ALMReports?pgId=101&retPgId=1&rptId=XX20');
    }
       
  } */
}