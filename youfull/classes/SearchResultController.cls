/*
** Apex Class/Controller Name           : SearchResultController
** VF Pages associated [Names]          : searchPage
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Controller for searchPage
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** May 1, 2012.  Created
** 
*/

public class SearchResultController { 
    public static Integer numberOfRecordsOnPage = 10; // MODIFY make configurable
    
    public List<LPDownlineWrapper> resultList {get; set;} // serch results
    public Boolean isMarket62 {get; set;} // display Branch Name ?
    public String keyword {get; set;} // keyword for search
    public String defaultKeyword {get; set;} // passed to component as parameter from header search
    public String option {get; set;} // search parameter from SearchPage
    public Integer currentPageNumber {get; set;}
    public Integer numberOfPages ;
    public List<LPDownlineWrapper> currentPageList ;
    public List<LPDownlineWrapper> prevPageList;
    public List<LPDownlineWrapper> nextPageList;
    public List<LPDownlineWrapper> firstPageList;
    public List<LPDownlineWrapper> lastPageList;
    public Boolean showSearchPanel {get;set;}
    public String retUrl {get;set;}
    public boolean searchused{get;set;}
    
    private Map<String, Leader_Title__c> mapLeaderTitle = new Map<String, Leader_Title__c>();
    private Map<String, String> pageAllParams;
    
    private String limitOfSearch = ALMConstants.LIMIT_OF_LANDING_PAGE_SEARCH ;
    public User currUser{get;Private set;}
    private String originalUrl;
    private String currCampignNumber;
    public Market__c currMarket{get;Private set;}
    public ALM_Global_Settings__c globalConfig {get;Private set;}
    //Added by Milon 6/28/2013 for search to work    
    public Decimal leaderGenLevel;
    public Decimal leaderLeftId{get;set;}
    public Decimal leaderRightId{get;set;}
    public String leaderTreeAccNo{get;set;}
    
    public String campaingNbr; // variable added - Mail Plan
    
    //controller 
    public SearchResultController() 
    {
        //Get current user.  If not a Leader, return
        currUser = [Select Id, LDRSHP_TITL_LVL_NBR__c,Profile.Name, MRKT_ID__c, ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c,  LanguageLocaleKey from User where Id = :UserInfo.getUserId() limit 1];
        System.debug('====================== SearchResultController. Current User : ' + currUser);
        if (currUser.Profile.Name != ALMPlusConstants.AVON_LEADER) {
            return;
        } 
        
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();
        option = '';
        showSearchPanel = true;
        System.debug('====================== SearchResultController. Current User : ' + currUser);
        
        
        
        /*
        if ((keyword = ApexPages.currentPage().getParameters().get(ALMConstants.SEARCH_URL_PARAM) ) == null) {
            keyword = '';
            //throw new InvalidSearchParamatersException();
        } else {
            System.debug('=========== SearchPage Controller. Current Page address : ' + ApexPages.currentPage().getUrl());
            //originalUrl = ApexPages.currentPage().getParameters().get(ALMConstants.IMPERSON_RETURN_PAGE); //this will redirect impersonation to the page, where search was done from
            originalUrl = ALMConstants.LANDING_PAGE_URL; // this will redirect impersonation to the LandingPage
            System.debug('=========== SearchPage Controller. Original URL : ' + originalUrl);
            pageAllParams = new Map<String, String>(); // don't include any params from searchPage except originalUrl
            pageAllParams =  ApexPages.currentPage().getParameters().clone();
            pageAllParams.remove(ALMConstants.IMPERSON_RETURN_PAGE);
            pageAllParams.remove(ALMConstants.SEARCH_URL_PARAM);
        }
        */
        // Getting Selling Campaign - Mail Plan 
        campaingNbr = Apexpages.currentPage().getParameters().get('mpCampaign');        
        
        if (currUser.MRKT_ID__c != null){
            if (currUser.MRKT_ID__c == ALMConstants.PHILIPPINES_MARKET_CODE) {
                isMarket62 = true;
            } else {
                isMarket62 = false;
            }
            //dummyFiller();
        } else {
            throw new InvalidDataException();
        }
        
        currMarket = [SELECT CMPGN_NR__c, Market_Currency_Symbol__c, Id, SPONSOR_QLFYING_ORD_AMT__c,Omniture_Suite_Name__c, ALM_Rep_Indicator__c,
                             CMPGN_END_DT__c, CMPGN_STRT_DT__c, Market_Id__c, PREV_1_CMPGN_NR__c, NEXT_1_CMPGN_NR__c, Allow_Freeform_Email__c, Mail_Plan_Enabled__c,
                             Is_Branch__c,MailPlan_LndingPg_Deflt__c 
                            FROM Market__c 
                            WHERE Market_Id__c = :currUser.MRKT_ID__c LIMIT 1];
        
        //to get badge title
        mapLeaderTitle = (new MarketLeaderTitleUtils()).initializeAndRetMapLT(currUser); 
        
        System.debug('============ Search Page. mapLeaderTitle is : ' + mapLeaderTitle);
        System.debug('============ Search Page. is Philippines: ' + isMarket62);
        
        // Getting Selling Campaign - Mail Plan
        if(currMarket.Mail_Plan_Enabled__c){
            
            String acct_no_imprsn = ApexPages.CurrentPage().getParameters().get('acctkey');
            
            acct_no_imprsn = (acct_no_imprsn == null?currUser.ACCT_NR__c:acct_no_imprsn);  //impersonation logic changed by swarnava
            try
            {
                List<Sobject> lst_CombinedObj = MailPlanUtils.getRepPerf_MailPlan(currMarket.ALM_Rep_Indicator__c, acct_no_imprsn, currMarket.Market_Id__c);
            
                //campaingNbr = ApexPages.CurrentPage().getParameters().get('campaign')=='current'?currMarket.CMPGN_NR__c:getMailPlanCampaign(lst_CombinedObj);  
                if(ApexPages.CurrentPage().getParameters().get('campaign')=='current' || ApexPages.CurrentPage().getParameters().get('campaignId')==currMarket.CMPGN_NR__c){
                    campaingNbr = currMarket.CMPGN_NR__c;
                    System.debug('============ Search Page. Current Link Clicked campaingNbr : ' + campaingNbr);
                }else if(ApexPages.CurrentPage().getParameters().get('campaign')=='prior' || ApexPages.CurrentPage().getParameters().get('campaignId')==currMarket.PREV_1_CMPGN_NR__c){
                    campaingNbr = currMarket.PREV_1_CMPGN_NR__c;
                    System.debug('============ Search Page. Prior Link Clicked campaingNbr : ' + campaingNbr);
                }else if(ApexPages.CurrentPage().getParameters().get('campaign')=='next' || ApexPages.CurrentPage().getParameters().get('campaignId')==currMarket.NEXT_1_CMPGN_NR__c){
                    campaingNbr = currMarket.NEXT_1_CMPGN_NR__c;
                    System.debug('============ Search Page. Next Link Clicked campaingNbr : ' + campaingNbr);
                }else {
                    //campaingNbr = getMailPlanCampaign(lst_CombinedObj);
                    campaingNbr = (currMarket.MailPlan_LndingPg_Deflt__c?getMailPlanCampaign(lst_CombinedObj):currMarket.CMPGN_NR__c);
                    System.debug('============ Search Page. No Link Clicked. By Default campaingNbr : ' + campaingNbr);
                }
                
            }catch(Exception e){
                System.debug('\n Caught Exception in SearchResult for Mail Plan '+e.getMessage());
                campaingNbr = currMarket.CMPGN_NR__c;
            }      
            
        }else{
            campaingNbr = currMarket.CMPGN_NR__c;   
        }
        System.debug('campaingNbr --> '+campaingNbr);
        LandingPageUtils.debugList(mapLeaderTitle.values(), 'LeaderTitle');
        
        ///Initialize global variable like lnode,rnode and LeaderAccount number
        Set<String> queryFieldSet = new Set<String>();
        queryFieldSet.add('ROOT_UPLN_ACCT_NR__c');
        queryFieldSet.add('Genealogy_Level__c');
        queryFieldSet.add('LFT_ND_ID__c');
        queryFieldSet.add('RGT_ND_ID__c');
        GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(currMarket.Market_Id__c, currUser.ACCT_NR__c, queryFieldSet); //Specify market
        
        // Now create Query Options for First Level
        Map<String, String> queryOptionsMap = new Map<String, String>();

        String whereClause = 'ACCT_NR__c = \''+currUser.ACCT_NR__c+'\''+
                            //' AND OPERTNL_CMPGN_NR__c = \''+campaingNbr+'\''+         // currMarket.CMPGN_NR__c replaced by campaingNbr - Mail Plan
                            ' AND FLD_SLS_CMPGN_NR__c = '+Double.valueOf(campaingNbr)+
                            ' AND MRKT_ID__c = \''+currMarket.Market_Id__c+'\'';      
        queryOptionsMap.put('WHERE',whereClause);
        queryOptionsMap.put('LIMIT','1');
        List<SObject> genealogyList = gsb.queryNew(queryOptionsMap);
        SObject topgen = genealogyList[0];

        leaderGenLevel = (Decimal)(topgen.get('Genealogy_Level__c'));
        leaderLeftId = (Decimal)(topgen.get('LFT_ND_ID__c'));
        leaderRightId = (Decimal)(topgen.get('RGT_ND_ID__c')); 
        
        leaderTreeAccNo = (Integer.valueOf(topgen.get('Genealogy_Level__c')) == 0) ? currUser.ACCT_NR__c:String.valueOf(topgen.get('ROOT_UPLN_ACCT_NR__c'));
        //End of initialize
       
        resultList = new List<LPDownlineWrapper>();
        currentPageNumber = 1;
        numberOfPages = 1;
        if(keyword!= '' && keyword != null){
            doSearch();
        }
        
    }
    
     public void getInitialized() {
        resultList = new List<LPDownlineWrapper>();
        
        if ((keyword = defaultKeyword) == null) {
            System.debug('\n=========== 2 SearchPage Controller.keyword : ' + keyword+', defaultKeyword : '+defaultKeyword);
            keyword = '';
        } else {
            System.debug('=========== SearchPage Controller. Current Page address : ' + ApexPages.currentPage().getUrl());
            //originalUrl = ApexPages.currentPage().getParameters().get(ALMConstants.IMPERSON_RETURN_PAGE); //this will redirect impersonation to the page, where search was done from
            originalUrl = ALMConstants.LANDING_PAGE_URL; // this will redirect impersonation to the LandingPage
            System.debug('=========== SearchPage Controller. Original URL : ' + originalUrl);
            pageAllParams = new Map<String, String>(); // don't include any params from searchPage except originalUrl
        }
        
        if(keyword!= '' && keyword != null){
            System.debug('\n=========== 3  SearchPage Controller.keyword ');
            doSearch();
        }
        System.debug('\n=========== 4  SearchPage Controller.keyword ');
        defaultKeyword ='';
    }
    
    // populates resultList with search results
    public void doSearch() {
        if(option==null) option='';//fix for I.E-9 swarnava
        System.debug('============ Search Page. Keyword is : ' + keyword);
        searchused=true;
        //validate search parameters
        if (isValidSearch()) {
            resultList = new List<LPDownlineWrapper>();
            
            
            Set<String> queryFieldSet = new Set<String>();
            List<SObject> genealogyList = null;
            String whereClause = '';
            String orderByClause = '';
            
            //get this fields from genealogy
            queryFieldSet.add('EXEC_GEN_INDX__c');
            //queryFieldSet.add('OPERTNL_CMPGN_NR__c');
            queryFieldSet.add('FLD_SLS_CMPGN_NR__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Name');
            queryFieldSet.add('MRKT_ACCT_KEY__r.REP_EMAIL_ADDR_TXT__c');
            queryFieldSet.add('MRKT_ACCT_KEY__r.Representative_Phone__c');
            
            queryFieldSet.add('PD_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR__c');
            queryFieldSet.add('LDRSHP_TITL_LVL_NR_NUMBER__c');
            queryFieldSet.add('ZONE_MGR_NAME__c');
            queryFieldSet.add('SLS_ZONE_CD__c');
            queryFieldSet.add('TITL_STUS__c');
            queryFieldSet.add('BRNCH_SCTN_CD__c');
            queryFieldSet.add('UPLN_ACCT_NR__c');
            queryFieldSet.add('DWNLN_ONLY_IND__c');
            queryFieldSet.add('ACCT_NR__c');
            
            GenealogySOQLBuilder gsb = new GenealogySOQLBuilder(currUser.MRKT_ID__c, currUser.ACCT_NR__c, queryFieldSet); 
            //gsb.queryFieldSet = queryFieldSet;
            
            //check if keyword is AccountNumber or LastName
            System.debug('====================== Before Search. Option : ' + option);
            
            if (!option.equalsIgnoreCase('name') && !option.equalsIgnoreCase('accountnumber')) {
                if (LandingPageUtils.isNumber(keyword)) {
                    option = 'AccountNumber';
                } else {
                    option = 'Name';
                }
            } 
            
            if (option.equalsIgnoreCase('accountnumber')) {
            System.debug('====================== Before Search. Option : ' + option);
                whereClause = ' ACCT_NR__c LIKE ' + '\'' + keyword + '%\'' ;
                
            } else if (option.equalsIgnoreCase('name')){
                System.debug('====================== Before Search. Option : ' + option);
                /*whereClause = ' (Contact_Key__r.FirstName LIKE ' + '\'' + keyword + '%\'' + 
                ' OR Contact_Key__r.LastName LIKE ' + '\'' + keyword + '%\'' +
                ' OR Contact_Key__r.Name LIKE ' + '\'' + keyword +
                '%\' )' ;*/
                whereClause = ' (MRKT_ACCT_KEY__r.LastName LIKE ' + '\'' + keyword + '%\')' ; // all other components and reports have only LastName search
            }
            
            orderByClause = 'MRKT_ACCT_KEY__r.FirstName';
            
            // filtering clauses for genealogy query
            if(leaderLeftId!= null && leaderRightId != null) {
                whereClause =  whereClause +
                                 ' AND ROOT_UPLN_ACCT_NR__c = \''+leaderTreeAccNo+'\'' +
                                 ' AND LFT_ND_ID__c > '+leaderLeftId +
                                 ' AND RGT_ND_ID__c < '+leaderRightId;
                                 //' AND OPERTNL_CMPGN_NR__c = \'' + campaingNbr + '\'';  // currMarket.CMPGN_NR__c replacecampaingNbrd by campaingNbr - Mail Plan
            }
            whereClause += ' AND FLD_SLS_CMPGN_NR__c = ' + Double.valueOf(campaingNbr);  
            
            Map<String,String> queryOptionsMap = new Map<String,String>();
            queryOptionsMap.put('WHERE', whereClause);
            queryOptionsMap.put('ORDER BY', orderByClause);
            queryOptionsMap.put('LIMIT', limitOfSearch); 
            
            genealogyList = gsb.queryNew(queryOptionsMap);
            System.debug('====================== Search Result. Where Clause = ' + whereClause);
            
            System.debug('============ SearchResult. Genealogy List is : ' + genealogyList);
            LandingPageUtils.debugList(genealogyList, 'Genealogy');
            
            currentPageNumber = 1; //display first page of new search result
            
            populateAttributes(genealogyList);
            //dummyFiller(); // added to test impersonation logic, will be removed later
            calculateNumberOfPages();
            System.debug('============================================ Do Search. IsMarket62 ? :' + isMarket62);
            System.debug('============================================ Do Search. current URL : ' + ApexPages.currentPage().getUrl());
        }
    }
    
    // populate sections with numbers and strings
    //return true if required params exist
    private Boolean populateAttributes(List<SObject> listSObject) {
        resultList = new List<LPDownlineWrapper>();
        LPDownlineWrapper record;
        Decimal levelNumber;
        
        //dynamically retrieve values, because exact object is picked dynamically
        if (listSObject != null && listSObject.size() > 0 ) {
            sObject contactObject;
            sObject personalPerformanceObject;
            
            // loop creating list of apponintments 
            for (SObject sObjectRecord : listSObject) {
                record = new LPDownlineWrapper();
                contactObject = sObjectRecord.getSObject('MRKT_ACCT_KEY__r');
                //personalPerformanceObject = sObjectRecord.getSObject('Personal_Performance_Key__r');
                
                record.accountNumber = (String)sObjectRecord.get('ACCT_NR__c');
                
                // contact information
                if (contactObject != null) {
                    record.name = (String)contactObject.get('Name');
                    record.phoneNumber = (String)contactObject.get('Representative_Phone__c');
                    
                }
                
                // My_Business information 
                    String tempString = (String)sObjectRecord.get('DWNLN_ONLY_IND__c');
                    LandingPageUtils.makeCoachOrImperson(tempString, record.accountNumber, originalUrl, pageAllParams, record);
                    
                    System.debug('=========== Populate Attributes. View Link : ' + record.viewLink);
                    // badge Title
                    levelNumber = (Decimal)sObjectRecord.get('LDRSHP_TITL_LVL_NR_NUMBER__c');
                    System.debug('====================== SearchResultController. levelNumber is : ' + levelNumber);
                    if (levelNumber != null) { // && levelNumber != -2
                        
                        record.badgeTitle = LandingPageUtils.determineBadgeTitle(mapLeaderTitle, (String)(sObjectRecord.get('LDRSHP_TITL_LVL_NR__c')));
                        /*if (record.badgeTitle == null || record.badgeTitle.length() == 0) {
                            record.badgeTitle = sObjectRecord.get('CMPGN_NR__c');
                        }*/
                        
                    }
                    
                    //Branch or Zone - ZoneManager
                    record.branchName = (String)sObjectRecord.get('BRNCH_SCTN_CD__c');
                    
                    record.zoneNumber = (String)sObjectRecord.get('SLS_ZONE_CD__c');
                
                resultList.add(record);
                
            }
            
        } else {
            return false;
        }
        
        return true;
    }
    
    // gets records for specific page
    private List<LPDownlineWrapper> getCurrentPage() {
        if (currUser.Profile.Name != ALMPlusConstants.AVON_LEADER) {
            return new List<LPDownlineWrapper>();
        }
        List<LPDownlineWrapper> result = new List<LPDownlineWrapper>();
        Integer firstNumber = 0;
        Integer lastNumber = 0;
        if (!isValidPaginationParams() || !isValidLPDownlineWrapperList(resultList)) {
            throw new InvalidPaginationParamsException();
        }
        
        System.debug('====================== SearchPage Result. Current Page Number : ' + currentPageNumber+', resultList.size() '+resultList.size());
        
        //determine order numbers for the first and last elements
        //and get corresponding subList
        if (resultList.size() == 0) {
            return result;
        }
        
        if (currentPageNumber != 0 && currentPageNumber <= numberOfPages) {
            
            firstNumber = numberOfRecordsOnPage * (currentPageNumber - 1);
            
            System.debug('====================== getCurrentPage. SpecificPageNumber = ' + currentPageNumber);
            System.debug('====================== getCurrentPage. Number Of Pages = ' + numberOfPages);
            if (currentPageNumber == numberOfPages) {
                lastNumber = resultList.size() - 1;
            } else {
                lastNumber = firstNumber + numberOfRecordsOnPage - 1;
            }
            result = subList(resultList, firstNumber, lastNumber);
            System.debug('====================== Current Page size : ' + result.size());
            System.debug('====================== Current Page records: ' + result);
            
            return result;
        } 
        
        return null;
    }
    
    //returns list of records on the first page
    public void FirstPageList() {
        currentPageNumber = 1;
        getCurrentPage();
    }
    
    //returns list of records on the last page
    public void LastPageList() {
        currentPageNumber = numberOfPages;
        getCurrentPage();
    }
    
    //returns list of records on the current page
    public List<LPDownlineWrapper> getCurrentPageList() {
        return getCurrentPage();
    }
    
    //return next page
    public void NextPageList() {
        currentPageNumber++;
        if (currentPageNumber > numberOfPages) {
            currentPageNumber = numberOfPages;
        }
        getCurrentPage();
    }
    
    //return previous page
    public void PrevPageList() {
        currentPageNumber--;
        if (currentPageNumber <= 0 ) {
            currentPageNumber = 1;
        }
        getCurrentPage();
    }
    //getter for Number of pages
    public Integer getNumberOfPages() {
        return numberOfPages;
    }
    public Boolean getFirst(){
        if(currentPageNumber == 1){
            return false;
        }
        return true;
        
    }
    public Boolean getLast(){
        if(currentPageNumber == numberOfPages){
            return false;
        }
        return true;
        
    }
    public Boolean getPrevious(){
        if(currentPageNumber <= 1){
            return false;
        }
        return true;
        
    }
    
    public Boolean getNext(){
        if(currentPageNumber < numberOfPages){
            return true;
        }
        return false;
        
    }
    //calculates how many pages required to display result 
    private void calculateNumberOfPages() {
        numberOfPages = 1;
        if (numberOfRecordsOnPage >= resultList.size()) {
            numberOfPages = 1;
        } else {
            System.debug('====================== calculatePages. proportion: ' + (Double)((Double)resultList.size() / (Double)numberOfRecordsOnPage));
            numberOfPages = (resultList.size() / numberOfRecordsOnPage) ;
            if (numberOfPages < (Double)((Double)resultList.size() / (Double)numberOfRecordsOnPage)) {
                numberOfPages++;
            }
        }
        
        System.debug('====================== number of records on Page: ' + numberOfRecordsOnPage);
        System.debug('====================== Total Number Of Records : ' + resultList.size());
        System.debug('====================== Number Of Pages : ' + numberOfPages);
    }
    
    //validate list or records got at query result
    private Boolean isValidLPDownlineWrapperList(List<LPDownlineWrapper> inputList) {
        if (currUser.Profile.Name != ALMPlusConstants.AVON_LEADER) {
            return false;
        }
        System.debug('====================== Validation of LPDownlineWrapper List. Input List : ' + inputList);
        System.debug('====================== Validation of LPDownlineWrapper List. Input List Size : ' + inputList.size());
        //if (inputList != null && inputList.size() > 0) {
        if (inputList != null ) {
            return true;
        } else {
            return false;
        }
    }
    
    //check if attributes required for 
    //pagination are valid
    private Boolean isValidPaginationParams() {
        if (currUser.Profile.Name != ALMPlusConstants.AVON_LEADER) {
            return false;
        }
        System.debug('====================== Validation of Pagination Attributes. Number Of Records per Page : ' + numberOfRecordsOnPage);
        System.debug('====================== Validation of Pagination Attributes. currentPageNumber : ' + currentPageNumber);
        System.debug('====================== Validation of Pagination Attributes. Is resultList Valid : ' + isValidLPDownlineWrapperList(resultList));
        if (numberOfRecordsOnPage == null || numberOfRecordsOnPage <=0 ||
            currentPageNumber == null || currentPageNumber <= 0 ||
            !isValidLPDownlineWrapperList(resultList)) {
                
            return false;
        }
        
        return true;
    }
    
    //get subList from List<LPDownlineWrapper>
    //firstNumber is beggining number of subList resultList
    //lastNumber is ending number of subList resultList
    private List<LPDownlineWrapper> subList(List<LPDownlineWrapper> inputList, Integer firstNumber, Integer lastNumber) {
        System.debug('====================== Sublist. First Number: ' + firstNumber + ' ; Last Number :' + lastNumber);
        List<LPDownlineWrapper> result = new List<LPDownlineWrapper>();
        //check input validity first
        if (firstNumber < 0 || lastNumber < 0 ||
                firstNumber > lastNumber || !isValidLPDownlineWrapperList(inputList) ||
                inputList.size() < firstNumber || inputList.size() < lastNumber) {
                    
            throw new InvalidPaginationParamsException();
        }
        
            
        if (firstNumber == lastNumber) {
            result.add(inputList.get(firstNumber));
        } else {
            for (Integer i = firstNumber; i <= lastNumber; i++) {
                result.add(inputList.get(i));
            }
        }
            
        System.debug('====================== SubList result size : ' + result.size());
        System.debug('====================== SubList result : ' + result);
        return result;
        
        System.debug('====================== SubList result. something is wrong with params! ' );
        
        return null;
    }
    
    //validate serach params
    private Boolean isValidSearch() {
        Boolean result = false;
        if (keyword != null || option != null) {
            if (keyword.length() >= 2) {
                result = true;
            }
        }
        
        return result;
    }
    
    // New addition of method to retrieve Mail Plan Campaign - Mail Plan
    public String getMailPlanCampaign(List<Sobject> lstSObj) {
        String campaignNumbr = '';
        
        campaignNumbr = YOUUtil.getCampaignNumbrMailPlan((String)lstSObj[0].getsObject('MailPlan_Order_Oppty__r').get('CMPGN_NR__c'));
        System.debug('\n #### campaignNumbr ---- >>> '+campaignNumbr);
        
        return campaignNumbr;
        
    }//End
    
    /*public void dummyFiller() {
        if(resultList == null)
            resultList = new List<LPDownlineWrapper>();
        LPDownlineWrapper w ;
        
        currentPageNumber = 1;
        for (Integer i = 0; i < 3; i++) {
            w = new LPDownlineWrapper();
            w.name = 'FirstName_' + i + ' LastName_'+i;
            w.zoneNumber = 'Z'+i;
            w.accountNumber = String.valueOf(i + i*2 + i * 3 + i * 4 + i * 5);
            if (isMarket62) {
                w.branchName = 'BR_NM_' + i;
            }
            w.badgeTitle = i + 'L';
            w.phoneNumber = '1' + i + '3' + 'i' + '5' + 'i' + 7 + 'i';
            w.viewLink = '/apex/demopagenew?acctkey=TestAccount1';
            
            resultList.add(w);
        }
        
        System.debug('====================== Search Result Size: ' + resultList.size());
    }*/
    
    public void viewLink() {
        showSearchPanel = false;
    }
    // used in controller. helper method to initialize attributes
    
    class InvalidDataException extends Exception {
    }
    
    class InvalidSearchParamatersException extends Exception {
    }
    
    class InvalidPaginationParamsException extends Exception {
    }
    public String getOmniturePageName()         
   {return ALMPlusUtils.generateOmniturePageName('SearchResult', null, currUser.Profile.Name);    }
}