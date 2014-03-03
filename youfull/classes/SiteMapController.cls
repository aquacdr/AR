/**
 * This class will be used to dynamically read the Market Menu Object associated
 * with Current User Market and create the Header Menu.
 *
 *  This class will be called whenever the user page is dynamically created.
 *
 * @name SiteMapController.cls
 * @author Milon
 * @date March 22, 2012
 * @Modify on June 18, 2012 CR#1864
 *
 */
public class SiteMapController {
    
    /**
    * Inner Class used as Value Object to pass data to the UI component 
    * for processing/display
    */
    public class MenuObject  {
        public String ID {get; set;}//SFDC ID
        public String Name{get; set;} //Name of Menu Element
        public String Link{get; set;} // Link Associated with Menu Element
        public Integer sequence{get; set;}//Order of this Menu Element
        public String displayType{get; set;}//Order of this Menu Element
        //List of SubMenu associated with this Menu Element 
        public List<MenuObject> children{get; set;}
        public Boolean isSelected{get; set;} //for bug 1864
    }

    //Variable to-be used in SiteMap Component
    public MenuObject col1 {get; set;}//Store Column1 Object data
    public MenuObject col2 {get; set;}//Store Column2 Object data
    public MenuObject col3 {get; set;}//Store Column3 Object data
    public MenuObject col4 {get; set;}//Store Column4 Object data
    public List<MenuObject> col1Sub {get; set;} //Store Column1 Sub-Menu's
    public List<MenuObject> col2Sub {get; set;} //Store Column2 Sub-Menu's
    public List<MenuObject> col3Sub {get; set;} //Store Column3 Sub-Menu's
    public List<MenuObject> col4Sub {get; set;} //Store Column4 Sub-Menu's
    public String currentUserId {get; set;} //Current User ID used for Overlay 
    String marketId;
    Boolean isSelectedFound;
    String curPageUrl;
    Boolean isParentTrue;

    private List<Market_Menu__c> menuList;

    /**
    * Default Constructor use to initialize all the List variable as well
    * calling the getInitialize function
    */
    public SiteMapController(){
        //this.marketId = 'SM';//Hard coded value need to remove
        col1Sub = new List<MenuObject>();
        col2Sub = new List<MenuObject>();
        col3Sub = new List<MenuObject>();
        col4Sub = new List<MenuObject>();
        this.isSelectedFound = false;
        this.isParentTrue = false;
        getInitialize();
    }

    /**
    * Main function responsible for initialize all the variable necessary to 
    * construct the pages. This function will query Market Menu Table based on
    * Market Id fields associated with user and create the necessary Menu.
    */
    public void getInitialize(){
        List<Market__c> market;
        User currUsr ;
        String userProfile;
        String market_id;
        
        //Logic for Impersonate
        String s_DrillDown;
        String s_ImpersonationUser ;
        User orgnUsr;
        String s_UserAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        String s_Impersonate = ApexPages.currentPage().getParameters().get('impersonate');
        try 
        {
        if(s_Impersonate!= null && s_Impersonate.trim()!='' && 
            s_DrillDown!=null && s_DrillDown.trim()!='' && 
            s_Impersonate == '1') {
            for(User u:[select Id,LanguageLocaleKey,MRKT_ID__c,
                MRKT_ID_ACCT_NR_KEY__c from User 
                where MRKT_ID_ACCT_NR_KEY__c =: s_DrillDown 
                OR Id=:UserInfo.getUserId()]){
                if(u.MRKT_ID_ACCT_NR_KEY__c == s_DrillDown){
                    s_ImpersonationUser=u.Id;
                }
                if(u.Id== UserInfo.getUserId()){
                    orgnUsr=u;
                }
            }       
        }else{
            s_ImpersonationUser = UserInfo.getUserId();
        }
        
        
        //Logic to fetch the Logged In or Impersonated User
        currUsr = [Select ACCT_NR__c, MRKT_ID__c,Profile.Name,LDRSHP_TITL_LVL_NBR__c 
                    From User
                    where Id = :s_ImpersonationUser];
                    
        
        userProfile = currUsr.Profile.Name;
        this.marketId = currUsr.MRKT_ID__c;
        this.currentUserId = currUsr.ACCT_NR__c;
        System.debug('this.marketId : '+this.marketId);
        System.debug('currUsr.Profile.Name : '+currUsr.Profile.Name);
        String userTypes = '\'All\'';
        String titleLevels = '\'All\'';
        userTypes +=',\''+userProfile+'\'';
        titleLevels+=',\''+currUsr.LDRSHP_TITL_LVL_NBR__c+'\'';

        market = [select Id from Market__c where Market_Id__c = :currUsr.MRKT_ID__c];
        for (Market__c l: market){
            market_id = l.Id;
        }
        //System.debug('market_id _'+market_id);
        String soqlToExec = ' select ID,Name, Link__c,Sequence_Number__c,'+
                        ' Type__c,Parent_Menu__c'+ 
                        ' from Market_Menu__c '+
                        ' where Market__c = :market_id'+
                        ' and IsActive__c = true '+
                        ' and User_Type__c includes ('+userTypes+') '+
                        ' and Title_Levels__c includes('+titleLevels+') '+
                        ' order by Sequence_Number__c ';
        //System.debug('SQL :'+soqlToExec);
        menuList = Database.query(soqlToExec);
        System.debug('DATA :'+menuList);
        String curFullUrl = ApexPages.currentPage().getUrl();
        if (curFullUrl != null && curFullUrl != ''){
            curPageUrl = curFullUrl.split('\\?')[0];
        }else{
            curPageUrl = '';
        }
        
        
        System.debug('Current Page URL'+curPageUrl  );

        
        //Creating the header Menu
        for (Market_Menu__c l: menuList){
            if (l.Parent_Menu__c == null && l.Sequence_Number__c == '1'){
                col1 = new MenuObject();
                col1.Name = l.Name;
                col1.Link = l.Link__c;
                col1.ID = l.ID;
                col1.displayType = l.Type__c;
                col1.isSelected = false;
                if (!this.isSelectedFound){
                    if (curPageUrl == col1.Link.split('\\?')[0]){
                        this.isSelectedFound = true;
                        col1.isSelected = true;
                    }
                }
            }else if (l.Parent_Menu__c == null && l.Sequence_Number__c == '2'){
                col2 = new MenuObject();
                col2.Name = l.Name;
                col2.Link = l.Link__c;
                col2.ID = l.ID;
                col2.displayType = l.Type__c;
                col2.isSelected = false;
                if (!isSelectedFound){
                    if (curPageUrl == col2.Link.split('\\?')[0]){
                        isSelectedFound = true;
                        col2.isSelected = true;
                    }
                }
            }else if (l.Parent_Menu__c == null && l.Sequence_Number__c == '3'){
                col3 = new MenuObject();
                col3.Name = l.Name;
                col3.Link = l.Link__c;
                col3.ID = l.ID;
                col3.displayType = l.Type__c;
                col3.isSelected = false;
                if (!isSelectedFound){
                    if (curPageUrl == col3.Link.split('\\?')[0]){
                        isSelectedFound = true;
                        col3.isSelected = true;
                    }
                }
            }else if (l.Parent_Menu__c == null && l.Sequence_Number__c == '4'){
                col4 = new MenuObject();
                col4.Name = l.Name;
                col4.Link = l.Link__c;
                col4.ID = l.ID;
                col4.displayType = l.Type__c;
                col4.isSelected = false;
                if (!isSelectedFound){
                    if (curPageUrl == col4.Link.split('\\?')[0]){
                        isSelectedFound = true;
                        col4.isSelected = true;
                    }
                }
            }
        }//end of for
        //Creating the Sub Menu
        if (col1 != null){
            col1.Name = ALMReportLabels.getReportColumnLabel(col1.Name);
            this.isParentTrue = false;
            col1Sub = getSubMenu(col1);
            if (this.isParentTrue){
                col1.isSelected = true;
            }
            if ((col1Sub!= null) && (col1Sub.size() > 0)){
                for (MenuObject sub1 : col1Sub ){
                    System.debug('sub1.Name :'+sub1.Name);
                    sub1.Name = ALMReportLabels.getReportColumnLabel(sub1.Name);
                }
            } 
        }

        if (col2 != null){
            col2.Name = ALMReportLabels.getReportColumnLabel(col2.Name);
            this.isParentTrue = false;
            col2Sub = getSubMenu(col2);
            if (this.isParentTrue){
                col2.isSelected = true;
            }
            if ((col2Sub!= null) && (col2Sub.size() > 0)){
                for (MenuObject sub2 : col2Sub ){
                    System.debug('sub2.Name :'+sub2.Name);
                    sub2.Name = ALMReportLabels.getReportColumnLabel(sub2.Name);
                }
            } 
        }

        if (col3 != null){
            col3.Name = ALMReportLabels.getReportColumnLabel(col3.Name);
            this.isParentTrue = false;
            col3Sub = getSubMenu(col3);
            if (this.isParentTrue){
                col3.isSelected = true;
            }
            if ((col3Sub!= null) && (col3Sub.size() > 0)){
                for (MenuObject sub3 : col3Sub ){
                    System.debug('sub3.Name :'+sub3.Name);
                    sub3.Name = ALMReportLabels.getReportColumnLabel(sub3.Name);
                }
            }
        }
        if (col4 != null){
            col4.Name = ALMReportLabels.getReportColumnLabel(col4.Name);
            this.isParentTrue = false;
            col4Sub = getSubMenu(col4);
            if (this.isParentTrue){
                col4.isSelected = true;
            }
            if ((col4Sub!= null) && (col4Sub.size() > 0)){
                for (MenuObject sub4 : col4Sub ){
                    System.debug('sub4.Name :'+sub4.Name);
                    sub4.Name = ALMReportLabels.getReportColumnLabel(sub4.Name);
                }
            }
        }

        //Finally Change the labels.
        //col1.Name = ALMReportLabels.getReportColumnLabel(col1.Name);
        //col2.Name = ALMReportLabels.getReportColumnLabel(col2.Name);
        //col3.Name = ALMReportLabels.getReportColumnLabel(col3.Name);
        
        //Labels changes end

        }catch (Exception e){
            Error_Message__c err = new Error_Message__c(
                Page_Occurred__c = ApexPages.currentPage().getUrl(),
                Error_Message__c = e.getMessage()); 
            throw (e);      
        }

    }//end of getinitialize

    /**
    * Method responsible for return the HTML Content of Menu Element
    * @return outText The html version of Sub menu Column 1
    */
    public Component.Apex.OutputText getcol1SubString(){
        Component.Apex.OutputText outText = new Component.Apex.OutputText();
        outText.escape = false;
        if (col1Sub != null){
            outText.value = createSubMenu(col1Sub);
        }
        return outText;
    }

    /**
    * Method responsible for return the HTML Content of Menu Element
    * @return outText The html version of Sub menu Column 2
    */
    public Component.Apex.OutputText getcol2SubString(){
        Component.Apex.OutputText outText = new Component.Apex.OutputText();
        outText.escape = false;
        if (col2Sub != null){
            outText.value = createSubMenu(col2Sub);
        }
        return outText;
    }

    /**
    * Method responsible for return the HTML Content of Menu Element
    * @return outText The html version of Sub menu Column 3
    */
    public Component.Apex.OutputText getcol3SubString(){
        Component.Apex.OutputText outText = new Component.Apex.OutputText();
        outText.escape = false;
        if (col3Sub != null){
            outText.value = createSubMenu(col3Sub);
        }
        return outText;
    }
    
    /**
    * Method responsible for return the HTML Content of Menu Element
    * @return outText The html version of Sub menu Column 4
    */
    public Component.Apex.OutputText getcol4SubString(){
        Component.Apex.OutputText outText = new Component.Apex.OutputText();
        outText.escape = false;
        if (col4Sub != null){
            outText.value = createSubMenu(this.col4Sub);
        }
        return outText;
    }

    /**
    * Recusive function to create SubMenu and populate the List<MenuObject>
    * @param parent The parent object or the root node of this tree
    * @return submenu The complete tree in list format
    */
    private List<MenuObject> getSubMenu(MenuObject parent){
        List<MenuObject> submenu = new List<MenuObject>{};
        Boolean haschildren = false;
        if (getSubList(parent) != null)
        {
            List<MenuObject> menu = getSubList(parent);
            for (MenuObject sub : menu ){
                MenuObject mo = new MenuObject();
                mo.Name = sub.Name;
                mo.Link = sub.Link;
                mo.ID = sub.ID;
                mo.displayType = sub.displayType;
                mo.children = getSubMenu(mo);
                submenu.add(mo);
                haschildren = true;
                if (!this.isSelectedFound)
                {
                    if (curPageUrl == mo.Link.split('\\?')[0])
                    {
                        this.isParentTrue = true;
                        this.isSelectedFound = true;
                    }
                }
            }
        }
        if (haschildren){
            return submenu;
        }else {
            return null;
        }
        return null;
    }//end of getSubMenu

    /**
    * Recusive function to create SubMenu(1st Level List) in html format 
    * @param firstLevel The list of Level1 List Object
    * @return htmlContent The html format of the Level 1 Sub Menu
    */
    private String createSubMenu(List<MenuObject> firstLevel){
        String htmlContent;
        Boolean hasChildren = false;
        htmlContent = '<div class="border_adj">';
        htmlContent += '<ul class="submenu">';
        for (MenuObject mo: firstLevel ){
            hasChildren = true;
            htmlContent +=  '<li><a href="'+mo.Link+'">'+mo.Name+'</a>';
            if (mo.children != null){
                htmlContent += createSubSubMenu(mo.children);
            }
            htmlContent += '</li>'; 
        }
        htmlContent += '</ul>';
        htmlContent += '</div>';
        if (haschildren){
            return htmlContent;
        }else {
            return null;
        }
        return null;
    }

    /**
    * Recusive function to create SubMenu(Nth Level List) in html format 
    * @param firstLevel The list of Level List Object
    * @return htmlContent The html format of the nth Level Sub Menu
    */
    private String createSubSubMenu(List<MenuObject> firstLevel){
        String htmlContent;
        Boolean hasChildren = false;
        htmlContent = '<ul class="nav">';
        for (MenuObject mo: firstLevel ){
            hasChildren = true;
            htmlContent +=  '<li><a href="'+mo.Link+'">'+mo.Name+'</a>';
            if (mo.children != null){
                htmlContent += createSubSubMenu(mo.children);
            }
            htmlContent += '</li>'; 
        }
        htmlContent += '</ul>';
        if (haschildren){
            return htmlContent;
        }else {
            return null;
        }
        return null;
    }

    /**
    * Method to Fetch a part of List  based on condition and return the sublist.
    * @param parent The parent object or the root node of this tree
    * @return submenu The immidiate children in the list
    */
    private List<MenuObject> getSubList(MenuObject parent){
        List<MenuObject> submenu = new List<MenuObject>{};
        Boolean hasElement =  false;
        for (Market_Menu__c sub: this.menuList ){
            if (sub.Parent_Menu__c == parent.ID){
                MenuObject menu = new MenuObject();
                menu.Name = sub.Name;
                menu.Link = sub.Link__c;
                menu.ID = sub.ID;
                menu.displayType = sub.Type__c;
                hasElement = true;
                submenu.add(menu);
            }
        }
        if (hasElement){
            return submenu;
        }else {
            return null;
        }
        return null;
    }//End of getSubList


    public static testmethod void testSiteMapController(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        mkt.Mail_Plan_Enabled__c=false;
        update mkt;
        User ldrUser;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            ldrUser = testData.createLeaderUser('test123');
        }
        //ldrUsr.IsActive=true;
        //update ldrUsr;
        User zoneUsr;
        User divUsr;
        Contact ct = testData.createContact('test123', UserInfo.getUserId());
        System.runAs ( thisUser ) {
            zoneUsr = testData.createZoneUser('123456');
            divUsr = testData.createDivUser('D123456');
        }
        //User mktAdmin = testData.createMarketAdminUser('MKTADMIN');
        
        List<Market_Menu__c> toInsrt = new List<Market_Menu__c>();
        Market_Menu__c mktMenu = new Market_Menu__c(Name='MY DASHBOARD',Link__c='\\AU',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='1',
                        Title_Levels__c='All', User_Type__c='All');
        toInsrt.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='MY BUSINESS',Link__c='\\AL',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='2',
                        Title_Levels__c='All', User_Type__c='Avon Leader');
        toInsrt.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='MY BUSINESS',Link__c='\\AZM',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='2',
                        Title_Levels__c='All', User_Type__c='Avon Mkt 62 Zone Manager');
        toInsrt.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='MY BUSINESS',Link__c='\\ADM',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='2',
                        Title_Levels__c='All', User_Type__c='Avon Mkt 62 Division Manager');
        toInsrt.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='MY DOWNLINE',Link__c='\\AU3',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='3',
                        Title_Levels__c='All', User_Type__c='All');
        toInsrt.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='eTOOLS',Link__c='\\AU4',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='4',
                        Title_Levels__c='All', User_Type__c='All');
        toInsrt.add(mktMenu);
        
        insert toInsrt;
        
        //Creating the Sub Menu
        List<Market_Menu__c> toInsrtSub = new List<Market_Menu__c>();
        List<Market_Menu__c> parentMenu = [select ID from Market_Menu__c where 
                        Name='MY DASHBOARD' and Market__c = :mkt.Id];
                        
        mktMenu = new Market_Menu__c(Name='My Coaching Record',Link__c='\\AUS1',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='1',
                        Title_Levels__c='All', User_Type__c='All',
                        Parent_Menu__c=parentMenu[0].ID);
        toInsrtSub.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='My Business Plan',Link__c='\\AUS2',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='2',
                        Title_Levels__c='All', User_Type__c='All',
                        Parent_Menu__c=parentMenu[0].ID);
        toInsrtSub.add(mktMenu);
        mktMenu = new Market_Menu__c(Name='My Earnings Statement',Link__c='\\AUS3',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='3',
                        Title_Levels__c='All', User_Type__c='All',
                        Parent_Menu__c=parentMenu[0].ID);
        toInsrtSub.add(mktMenu);
        insert toInsrtSub;  
        
         //Creating the Sub-Sub Menu    
        List<Market_Menu__c> parentSubMenu = [select ID from Market_Menu__c where 
                        Name='My Earnings Statement' and Market__c = :mkt.Id];
                        
        List<Market_Menu__c> toInsrtSubSub = new List<Market_Menu__c>();
        mktMenu = new Market_Menu__c(Name='My New Representatives',Link__c='\\AUSS1',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='1',
                        Title_Levels__c='All', User_Type__c='All',
                        Parent_Menu__c=parentSubMenu[0].ID);
        toInsrtSubSub.add(mktMenu);
        insert toInsrtSubSub;     
        
         //Creating the Sub-Menu for eTool   
        List<Market_Menu__c> etSubMenu = [select ID from Market_Menu__c where 
                        Name='eTOOLS' and Market__c = :mkt.Id];
                        
        List<Market_Menu__c> etSubSub = new List<Market_Menu__c>();
        mktMenu = new Market_Menu__c(Name='Earning Illustrator',Link__c='\\EL1',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='1',
                        Title_Levels__c='All', User_Type__c='All',
                        Parent_Menu__c=etSubMenu[0].ID);
        etSubSub.add(mktMenu);
        insert etSubSub;   
        
         //Creating the Sub-Menu for MY DOWNLINE   
        List<Market_Menu__c> mdSubMenu = [select ID from Market_Menu__c where 
                        Name='MY DOWNLINE' and Market__c = :mkt.Id];
                        
        List<Market_Menu__c> mdSubSub = new List<Market_Menu__c>();
        mktMenu = new Market_Menu__c(Name='My Reports',Link__c='\\MR1',
                        Market__c=mkt.Id,Type__c='1',Sequence_Number__c='1',
                        Title_Levels__c='All', User_Type__c='All',
                        Parent_Menu__c=mdSubMenu[0].ID);
        mdSubSub.add(mktMenu);
        insert mdSubSub;                                                               
                                
        mkt.OwnerId = ldrUser.Id;
        update  mkt;
        System.runAs(ldrUser){
            String subMenu = '<div class="border_adj"><ul class="submenu">'+
            '<li><a href="\\AUS1">My Coaching Record</a></li><li>'+
            '<a href="\\AUS2">My Business Plan</a></li><li>'+
            '<a href="\\AUS3">My Earnings Statement</a><ul class="nav">'+
            '<li><a href="\\AUSS1">My New Representatives</a>'+
            '</li></ul></li></ul></div>';
            PageReference pageRef = new PageReference('\\AU');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.Name,'MY DASHBOARD');
            System.assertEquals(ctlr.col2.Name,'MY BUSINESS');
            System.assertEquals(ctlr.col3.Name,'MY DOWNLINE');
            System.assertEquals(ctlr.col4.Name,'eTOOLS');
            if (ctlr.col1Sub != null){
                System.assertNotEquals(ctlr.getcol1SubString().value, null);
            }
            System.assertEquals(ctlr.getcol2SubString().value,null);
            System.assertNotEquals(ctlr.getcol3SubString().value,null);
            System.assertNotEquals(ctlr.getcol4SubString().value,null);
            //ctlr.getInitialize();
        }
        
        mkt.OwnerId = zoneUsr.Id;
        update  mkt;
        System.runAs(zoneUsr){
            PageReference pageRef = new PageReference('\\AU3');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.Name,'MY DASHBOARD');
            System.assertEquals(ctlr.col2.Name,'MY BUSINESS');
            System.assertEquals(ctlr.col3.Name,'MY DOWNLINE');
            System.assertEquals(ctlr.col4.Name,'eTOOLS');
        }
        
        mkt.OwnerId = divUsr.Id;
        update  mkt;
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\AU4');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.Name,'MY DASHBOARD');
            System.assertEquals(ctlr.col2.Name,'MY BUSINESS');
            System.assertEquals(ctlr.col3.Name,'MY DOWNLINE');
            System.assertEquals(ctlr.col4.Name,'eTOOLS');
        }
        
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\ADM');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col2.isSelected,true);
        }
        
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\AUS1');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.col1.isSelected,true);
        }
        
        //Testing impersonate
        System.runAs(divUsr){
            PageReference pageRef = new PageReference('\\AUS1');
            pageRef.getParameters().put('impersonate','1');
            Test.setCurrentPage(pageRef);
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.currentUserId,divUsr.ACCT_NR__c);
        }
    }
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testImpersonate(){
        TestDataHelper testData = new TestDataHelper();
        Market__c mkt = testData.createMarket();
        mkt.Mail_Plan_Enabled__c=false;
        update mkt;
        User ldrUser;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            ldrUser = testData.createLeaderUser('test123');
        }
        //ldrUsr.IsActive=true;
        //update ldrUsr;
        Contact ct = testData.createContact('test123', UserInfo.getUserId());
        
        ApexPages.currentPage().getParameters().put('impersonate','1');
        System.runAs(ldrUser){
            SiteMapController ctlr = new  SiteMapController();
            System.assertEquals(ctlr.currentUserId,ldrUser.ACCT_NR__c);
        }
    
    }*/ // End of test impersonate

}//end of class