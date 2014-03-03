public class MarketContentController {

    public Boolean isError {get; set;}
    public Market_Content__c mktContent {get; set;}
    private ApexPages.Standardcontroller stdCtlr;
    private static String HELP_TYPE='Help';
    private static String SPLASHPAGE_TYPE='Splash Page';
    public User usr {get; private set;}
    public String usrProfile {get; private set;}
    private Contact usrCont;
    public ALM_Global_Settings__c globalConfig {get; private set;}
    String userTypes = '\'All\'';
    String titleLevels = '\'All\'';
    public String printpageUrl{get;set;}
    public MarketContentController(ApexPages.StandardController ctlr){
        this.globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        
        this.stdCtlr=ctlr;
        this.usr = [ select Id,MRKT_ID__c,MRKT_ID_ACCT_NR_KEY__c,
                     LanguageLocaleKey,Profile.Name,LDRSHP_TITL_LVL_NBR__c
                     from User 
                     where Id=:UserInfo.getUserId()] ; 
        this.usrProfile = usr.Profile.Name;
        userTypes +=',\''+this.usrProfile+'\'';
        titleLevels+=',\''+usr.LDRSHP_TITL_LVL_NBR__c+'\'';
        System.debug('userTypes : '+userTypes);
        System.debug('titleLevels : '+titleLevels);
        System.debug('MRKT_ID__c : '+usr.MRKT_ID__c);
    }

    public PageReference saveContent(){
        Market_Content__c rec = (Market_Content__c)stdCtlr.getRecord(); 
        if((    rec.ALM_Page_Id__c==null || 
                rec.ALM_Page_Id__c=='' ||
                rec.ALM_Page_Id__c.length()==0) &&
            rec.Type__c==HELP_TYPE)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR , 'ALM Page Id is required for Help'));
            return null;            
        }else{
            return stdCtlr.save();  
        }
    }
    
    public PageReference viewContent(){
        String pagetype = System.currentPageReference().getParameters().get('type');
        String pageId = System.currentPageReference().getParameters().get('pgId');
        System.debug('>>>>>>>>>>>>>>pageType='+pageType+',pageId='+pageId+', usrProfile ::: '+usrProfile);
        printpageUrl = '/apex/HelpPrint?type='+pagetype+'&pgId='+pageId;
        isError=false;  
        try{
            if(pagetype == SPLASHPAGE_TYPE){ //Changed by Rupayan from pageType to pagetype
                this.mktContent = getSplashPage();
                if(this.mktContent==null){
                    return gotoHomeTab();
                }           
                return null;
            }else{
            	if(pageType == HELP_TYPE){
                	String soqlToExec = ' select  Name,Type__c,Content_Type__c,Content__c,'+
                                '       Market__r.Name,Market__r.Is_ALMPLUS_Enabled__c'+ 
                                ' from Market_Content__c '+
                                ' where Type__c=\''+pageType+'\''+
                                ' and ALM_Page_Id__c=\''+pageId+'\''+
                                ' and Market__r.Market_Id__c = \''+usr.MRKT_ID__c +'\''+
                                ' and Title_Levels__c includes ('+titleLevels+') ' +
                                ' and User_Type__c includes ('+userTypes+') ';
                    this.mktContent =  Database.query(soqlToExec);
                    
                    SiteHeaderController.strsize=this.mktContent.Content__c.length();
            }else{
            	if(this.usrProfile==ALMPLusConstants.AVON_CS_AGNT || this.usrProfile==ALMPLusConstants.AVON_CS_SUPR
                   || this.usrProfile.containsIgnoreCase(ALMPLusConstants.AVON_SL_BASE)|| this.usrProfile.containsIgnoreCase(ALMConstants.ZONE) 
                   || this.usrProfile.containsIgnoreCase(ALMConstants.DIVISION)){
                    String soqlToExec = ' select  Name, Type__c,Content_Type__c,Content__c,'+
                                '       Market__r.Name,Market__r.Is_ALMPLUS_Enabled__c'+ 
                                ' from Market_Content__c '+
                                ' where Type__c=\''+pageType+'\''+
                                ' and Market__r.Market_Id__c = \''+usr.MRKT_ID__c +'\''+
                                ' and Title_Levels__c includes ('+titleLevels+') ' +
                                ' and User_Type__c includes ('+userTypes+') ';
                    System.debug('\n ### SOQL Query : '+soqlToExec);
                    this.mktContent =  Database.query(soqlToExec);
                 }else{
                 	this.mktContent = [ select  Type__c,Content_Type__c,Content__c,
                                            Market__r.Name,Market__r.Is_ALMPLUS_Enabled__c
                                    from Market_Content__c
                                    where Type__c=:pageType
                                    and User_Type__c includes (:userTypes)
                                    and Title_Levels__c includes (:titleLevels)
                                    and Market__r.ASLF_Market_Id__c = :ApexPages.currentPage().getParameters().get('mktId')];
                 }
            }
            System.debug('>>>>>>>>>>>>>> pageType=  6 mktContent.Content_Type__c '+mktContent.Content_Type__c);
            if(mktContent.Content_Type__c == 'Link'){
                System.debug('>>>>>>>>>>>>>>isError='+isError);
                return new PageReference(mktContent.Content__c).setRedirect(true);  
            }
            else{
                return null;    
            } 
            }
        }catch(Exception ex){
            System.debug('>>>>>>>>>>error fetching record:'+ex);
            isError=true;
            return null;    
        }       
            
    }
    
    private Market_Content__c getSplashPage(){
        //Add the "All" to the user types and title levels so that if nothing else is configured
        //that would be returned.
       // if(this.usrProfile=='Avon Leader' || this.usrProfile.contains('Zone') || this.usrProfile.contains('Division')){
       if(this.usrProfile=='Avon Leader'){
            String userTypes = '\'All\'';
            userTypes +=',\''+this.usrProfile+'\'';
            ALMLogUtils.log('MarketContentController','usrTypes='+userTypes);
            String titleLevels = '\'All\'';
            String soqlToExec = ' select    Name,Type__c,Content_Type__c,Content__c, User_Type__c,'+
                                '       Title_Levels__c, Market__r.Name,Market__r.Is_ALMPLUS_Enabled__c'+ 
                                ' from Market_Content__c '+
                                ' where Type__c=:pageType'+
                                ' and Market__r.Market_Id__c = :mktId '+
                                ' and User_Type__c includes ('+userTypes+') ';
            List<Market_Content__c> mcList;                         
            if(this.usrProfile =='Avon Leader'){
                this.usrCont = [    Select MRKT_ACCT_KEY__c,  
                                    MRKT_ID__c
                                From Contact
                                where MRKT_ACCT_KEY__c=:usr.MRKT_ID_ACCT_NR_KEY__c];
                titleLevels+=',\''+usr.LDRSHP_TITL_LVL_NBR__c+'\'';
                soqlToExec +=' and Title_Levels__c includes('+titleLevels+')';                      
                ALMLogUtils.log('MarketContentController','titleLevels='+titleLevels);
            }
            soqlToExec +=' order by CreatedDate';
            ALMLogUtils.log('MarketContentController','soqlToExec='+soqlToExec);
            Market_Content__c titlSplashPage,usrTypeSplashPage,allUsrSplashPage;
            String pageType=SPLASHPAGE_TYPE;
            String mktId = this.usr.MRKT_ID__c;
            for(Market_Content__c mktContent:Database.query(soqlToExec)){
                /*
                If user's title matches with a configured splash page and the user type contains Avon Leader
                set the title based splash page to the current market content record
                */
                ALMLogUtils.log('MarketContentController','Looking at Market Content:'+mktcontent);
                if(this.usrProfile=='Avon Leader'){
                    if(mktContent.Title_Levels__c.contains(usr.LDRSHP_TITL_LVL_NBR__c) && mktContent.User_Type__c.contains(this.usrProfile)){
                        titlSplashPage = mktContent;
                    }
                }
                /*
                If user profile name is contained in the User_Type__c selection
                set the user type splash page to the current market content record
                */
                ALMLogUtils.log('MarketContentController','mktContent.User_Type__c.contains(this.usrProfile)='+(mktContent.User_Type__c.contains(this.usrProfile)));
                if(mktContent.User_Type__c.contains(this.usrProfile)){
                    usrTypeSplashPage=mktContent;
                }
                /*
                set the "All" User Types splash page
                */
                if(mktContent.User_Type__c=='All'){
                    allUsrSplashPage=mktContent;
                }
            }
            if(titlSplashPage!=null){
                return titlSplashPage;
            }else if(usrTypeSplashPage!=null){
                return usrTypeSplashPage;
            }else{
                return allUsrSplashPage;
            }
        }
        return null;
    }
    public PageReference gotoHomeTab(){
        //ALM+ changes added by Snehashis
        //Commented by Milon
        
        Boolean isHotLead=false;
        PageReference pageRef;
        if(this.mktContent!=null){
            isHotLead=this.mktContent.Market__r.Is_ALMPLUS_Enabled__c;
        }else{
            Market__c mrkt=[Select Id, name, Is_ALMPLUS_Enabled__c from Market__c where Market_Id__c=:this.usr.MRKT_ID__c];
            isHotLead=mrkt.Is_ALMPLUS_Enabled__c;
        }
        String myLeadpgId= ALMPLusConstants.HOTLEAD_PGID_VALUE;
        User_Login_Param__c usrLogParam;
        try{
            usrLogParam = [select Id, MRKT_ID__c, Report_Id__c,Report_type__c,User_Id__c,LastModifiedDate,Page_Id__c,Is_My_Lead__c
                                from User_Login_Param__c
                                where User_Id__c=:this.usr.Id and Is_My_Lead__c=true and Page_Id__c=:myLeadpgId];
        }catch(exception ex){
            isHotLead=false;
        }
        if(this.usr.Profile.Name=='Avon Leader'){
           /* if(isHotLead){
                try{
                    delete usrLogParam;
                }catch(exception ex){}
                pageRef = Page.MyLeads;
                pageRef.getParameters().put('pgId',ALMPLusConstants.HOTLEAD_PGID_VALUE);
                ALMLogUtils.log('MarketContentController','From GotoHomeTab'+pageRef.getUrl());
            }else{
            
            } */
            pageRef = Page.YOUHome;
            pageRef.getParameters().put('pgId','1');
            return pageRef;
        }
      /*  if(this.usr.Profile.Name=='Avon Zone Manager' || this.usr.Profile.Name=='Avon Division Manager'){
            if(this.usr.Profile.Name=='Avon Zone Manager'){
                if(isHotLead){
                    pageRef = Page.MyLeads;
                    pageRef.getParameters().put('pgId',ALMPLusConstants.HOTLEAD_PGID_VALUE);
                    try{
                        delete usrLogParam;
                    }catch(exception ex){}
                }else{
                    pageRef = Page.SalesOrgActivity;
                    pageRef.getParameters().put('pgId','8');
                }
            }else{
                pageRef = Page.SalesOrgActivity;
                pageRef.getParameters().put('pgId','8');
            }
            return pageRef;
        }*/
        
        return new PageReference('/home/home.jsp');
    }
    
   public String getOmniturePageName() {
       if(System.currentPageReference().getParameters().get('type')=='Help')
          return ALMPlusUtils.generateOmniturePageName('HelpPage', null, usrProfile);
        else if(System.currentPageReference().getParameters().get('type')=='Splash Page')
          return ALMPlusUtils.generateOmniturePageName('SplashPage', null, usrProfile);
        else if(System.currentPageReference().getParameters().get('type')=='Site Maintenance')
          return ALMPlusUtils.generateOmniturePageName('SiteMaintenance', null, usrProfile);
        else
          return 'Page Not Found';    
    }
   
   
    public static testmethod void testSaveMarketContent(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        
        Market_Content__c mktContent = new Market_Content__c(   Name='Test',
                                        Market__c=mkt.Id,Type__c='Help',
                                        Title_Levels__c='All',User_Type__c='All',
                                        Content_Type__c='HTML',Content__c='Test data',ALM_Page_Id__c='1');
        insert mktContent;
        ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
        PageReference pageRef = stdCtlr.edit();
        pageRef.getParameters().put('id',mktContent.Id);
        
        MarketContentController ctlr = new MarketContentController(stdCtlr);
        ctlr.saveContent();
        System.assertEquals(ApexPages.getMessages().size(),0);
        mktContent.ALM_Page_Id__c=null;
        pageRef = ctlr.saveContent();
        System.assertEquals(ApexPages.getMessages().size(),1);  
        mktContent.ALM_Page_Id__c='';
        pageRef = ctlr.saveContent();
        System.assertEquals(ApexPages.getMessages().size(),1);  
        ctlr = new MarketContentController(stdCtlr);
        pageRef = stdCtlr.edit();
    }

    public static testmethod void testViewMarketContent(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        mkt.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        mkt.Eligibility_Yes_Flags__c='Opt_In__c';
        mkt.Is_ALMPLUS_Enabled__c=true;
        update mkt;
        User ldrUser = testData.createLeaderUser('test123');
      //  User zoneUsr = testData.createZoneUser('123456');
        Market_Content__c mktContent = new Market_Content__c(   Name='Test',
                                        Market__c=mkt.Id,Type__c='Help',
                                        Title_Levels__c='1',User_Type__c='All',
                                        Content_Type__c='HTML',Content__c='Test data',ALM_Page_Id__c='1');
        insert mktContent;
        //Added by Milon
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Help');
            pageRef.getParameters().put('pgId','1');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Content__c,'Test data');
            pageRef = ctlr.gotoHomeTab();
            //System.assert(pageRef.getUrl()=='/apex/almhome?pgId=1');
        }
        System.debug('Market__c=mkt.Id'+mkt.Id);
        System.debug('Market__c=mkt.Id'+mkt.Market_Id__c);
        mktContent = new Market_Content__c( Name='Test Link',Market__c=mkt.Id,
                        Type__c='Terms and Conditions',Title_Levels__c='All',
                        User_Type__c='All',
                        Content_Type__c='Link',Content__c='http://www.google.com');                                                         
        insert mktContent;
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().clear();
            pageRef.getParameters().put('type','Terms and Conditions');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Content__c,'http://www.google.com');
            System.assertEquals(ctlr.IsError,false);
            pageRef.getParameters().clear();
            pageRef.getParameters().put('type','Terms_and_Conditions');
            Test.setCurrentPageReference(pageRef);
            ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.IsError,true);
        }
        //Added by Milon
      /*  mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        zoneUsr.LDRSHP_TITL_LVL_NBR__c = '1';
        update zoneUsr;
        System.runAs(zoneUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            pageRef = ctlr.gotoHomeTab();
            //System.assert(pageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');
        }*/
    }

    
    public static testmethod void testSplashPage(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        mkt.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        mkt.Eligibility_Yes_Flags__c='Opt_In__c';
        mkt.Is_ALMPLUS_Enabled__c=true;
        update mkt;
        User ldrUser = testData.createLeaderUser('test123');
        Contact ct = testData.createContact('test123', ldrUser.Id);//Changed from Userinfo.getUserId to ldrUser.Id
       // User zoneUsr = testData.createZoneUser('123456');
      //  User divUsr = testData.createDivUser('D123456');
        User mktAdmin = testData.createMarketAdminUser('MKTADMIN');
        
        List<Market_Content__c> toInsrt = new List<Market_Content__c>();
        Market_Content__c mktContent = new Market_Content__c(   Name='All Users',Market__c=mkt.Id,Type__c='Splash Page',
                                                            Content_Type__c='HTML',Content__c='Test data',
                                                            User_Type__c='All');
        toInsrt.add(mktContent);
        mktContent = new Market_Content__c( Name='All Leaders',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Leader',Title_Levels__c='All');      
        toInsrt.add(mktContent);

        mktContent = new Market_Content__c( Name='Title Level 1',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Leader',Title_Levels__c='1');      
        toInsrt.add(mktContent);

        /*mktContent = new Market_Content__c( Name='Zone Manager',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Zone Manager');      
        toInsrt.add(mktContent);*/
        insert toInsrt;
        
        //Added by Milon
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type',SPLASHPAGE_TYPE);
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'Title Level 1');
        }
        
        //Added by Milon
       /* mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        System.runAs(zoneUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'Zone Manager');
        }
        
        //Added by Milon
        mkt.OwnerId = divUsr.Id;
        update  mkt;
        System.runAs(divUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'All Users');
        }*/
        //Added by Milon
       // mkt.OwnerId = mktAdmin.Id;
        //update  mkt;
        System.runAs(mktAdmin){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            PageReference retPageRef = ctlr.viewContent();
            System.assert(ctlr.mktContent==null);
            //System.assert(retPageRef.getUrl()=='/home/home.jsp');
        }
    }
    

    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testALMPlusSplashPage(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        mkt.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        mkt.Eligibility_Yes_Flags__c='Opt_In__c';
        mkt.Is_ALMPLUS_Enabled__c=true;
        update mkt;
        User ldrUser = testData.createLeaderUser('test123');
        Contact ct = testData.createContact('test123', UserInfo.getUserId());
      //  User zoneUsr = testData.createZoneUser('123456');
      //  User divUsr = testData.createDivUser('D123456');
        User mktAdmin = testData.createMarketAdminUser('MKTADMIN');
        
        ldrUser.LDRSHP_TITL_LVL_NBR__c = '1';
        update ldrUser;
        
        List<Market_Content__c> toInsrt = new List<Market_Content__c>();
        Market_Content__c mktContent = new Market_Content__c(   Name='All Users',Market__c=mkt.Id,Type__c='Splash Page',
                                                            Content_Type__c='HTML',Content__c='Test data',
                                                            User_Type__c='All');
        toInsrt.add(mktContent);
        mktContent = new Market_Content__c( Name='All Leaders',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Leader',Title_Levels__c='All');      
        toInsrt.add(mktContent);

        mktContent = new Market_Content__c( Name='Title Level 1',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Leader',Title_Levels__c=ldrUser.LDRSHP_TITL_LVL_NBR__c);      
        toInsrt.add(mktContent);

       /* mktContent = new Market_Content__c( Name='Zone Manager',Market__c=mkt.Id,Type__c='Splash Page',
                                            Content_Type__c='HTML',Content__c='Test data',
                                            User_Type__c='Avon Zone Manager');      
        toInsrt.add(mktContent);//
        insert toInsrt;
        //Creating User login param record to be created
        List<User_Login_Param__c> ulpLst = new List<User_Login_Param__c>();
        User_Login_Param__c testULP1 = new User_Login_Param__c(User_Id__c=ldrUser.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=ldrUser.Id); 
      //  User_Login_Param__c testULP2 = new User_Login_Param__c(User_Id__c=zoneUsr.Id, Page_Id__c='40', Is_My_Lead__c=true,ownerId=zoneUsr.Id); 
        ulpLst.add(testULP1);
      //  ulpLst.add(testULP2);
        insert ulpLst;
         //Added by Milon
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        System.runAs(ldrUser){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            //System.assertEquals(ctlr.mktContent.Name,'Title Level 1');
            PageReference retPageRef = ctlr.gotoHomeTab();
            System.debug('&&&&&&&&&&&&&&&&&& '+retPageRef.getUrl());
            //System.assert(retPageRef.getUrl()=='/apex/MyLeads?pgId=40');    
        }
         //Added by Milon
       /* mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        System.runAs(zoneUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'Zone Manager');
            PageReference retPageRef = ctlr.gotoHomeTab();
            System.debug('&&&&&&&&&&&&&&&&&& '+retPageRef.getUrl());
            //System.assert(retPageRef.getUrl()=='/apex/MyLeads?pgId=40');
        }
        //Added by Milon
        mkt.OwnerId = divUsr.Id;
        update  mkt;
        System.runAs(divUsr){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            ctlr.viewContent();
            System.assertEquals(ctlr.mktContent.Name,'All Users');
            PageReference retPageRef = ctlr.gotoHomeTab();
            System.debug('&&&&&&&&&&&&&&&&&& '+retPageRef.getUrl());
            //System.assert(retPageRef.getUrl()=='/apex/SalesOrgActivity?pgId=8');
        }//
        
        System.runAs(mktAdmin){
            ApexPages.StandardController stdCtlr = new ApexPages.Standardcontroller(mktContent);
            PageReference pageRef = Page.ShowMarketDocument;
            pageRef.getParameters().put('type','Splash Page');
            Test.setCurrentPageReference(pageRef);
            MarketContentController ctlr = new MarketContentController(stdCtlr);
            PageReference retPageRef = ctlr.viewContent();
            System.assert(ctlr.mktContent==null);
            //System.assert(retPageRef.getUrl()=='/home/home.jsp');
        }
    } */

}