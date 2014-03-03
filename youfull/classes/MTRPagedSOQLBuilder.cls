public class MTRPagedSOQLBuilder extends MTRSOQLBuilder {

  public Integer TotalRecords{ get; private set; }

  public Integer PageTotal {
    get {
      return Integer.valueOf(Math.ceil(this.TotalRecords / Double.valueOf(this.PageSize)));
    }
  }

  private Boolean IsModified { get; set; }
  
  private ApexPages.StandardSetController m_SetCon = null;
  private Integer m_PageNumber = 1;
  
  public  MTRPagedSOQLBuilder() {
    Initialize(null, '', '', '', '', null);
  }
  
  public MTRPagedSOQLBuilder(Id marketId, String reportType, String profileName, String userTitleLevelNbr, String langCD) {
    Initialize(marketId, reportType, profileName, userTitleLevelNbr, langCD, null);
  }
  
  public  MTRPagedSOQLBuilder(Id marketId, String reportType, String profileName, String userTitleLevelNbr, String langCD, MTRSearchOptions.MTRBaseSearch searchType) {
    
    Initialize(marketId, reportType, profileName, userTitleLevelNbr, langCD, searchType);
  }

  protected override void Initialize(Id marketId,
              String reportType,
              String profileName,
              String userTitleLevelNbr,
              String langCD,
              MTRSearchOptions.MTRBaseSearch searchType) {
                
    super.Initialize(marketId, reportType, profileName, userTitleLevelNbr, langCD, searchType);
  
    this.TotalRecords = 0;
    this.PageNumber = 1;
    this.IsModified = false;
    
    this.OVERALL_QUERYSET_LIMIT = 10000;
  }
  
  //Overridable method that will tells us when Market Id is changed and that we should reset our StandardSetController
  protected override void SFDCMarketIdChanging(Id newMarketId) {
    
    super.SFDCMarketIdChanging(newMarketId);
    
    if(newMarketId != this.SFDCMarketId) {
      this.Reset();
    }
  }
  
  //Checks to see if Search Type object has been changed
  private Boolean IsSearchTypeModified(MTRSearchOptions.MTRBaseSearch searchType) {
    
    MTRSearchOptions.MTRBaseSearch oldSearchType = this.SearchType;
    MTRSearchOptions.MTRTextSearch oldTextSearchType = null;
    MTRSearchOptions.MTRFilterSearch oldFilterSearchType = null;
    MTRSearchOptions.MTRTextSearch textSearchType = null;
    MTRSearchOptions.MTRFilterSearch filterSearchType = null;
    Boolean isModified = false;
    

    if(GetSupportedSearchClassName(searchType) != GetSupportedSearchClassName(oldSearchType)) {
      
      isModified = true;
    }
    else if(searchType.AccountNumber != oldSearchType.AccountNumber
      || searchType.SortBy != oldSearchType.SortBy
      || searchType.IsAscending != oldSearchType.IsAscending) {
      
      isModified = true;
    }
    else if(oldSearchType instanceof MTRSearchOptions.MTRTextSearch) {
      
      oldTextSearchType = (MTRSearchOptions.MTRTextSearch)oldSearchType;
      textSearchType = (MTRSearchOptions.MTRTextSearch)searchType;

      if(textSearchType.TextSearch != oldTextSearchType.TextSearch
        || textSearchType.TSCriteria != oldTextSearchType.TSCriteria) {
        isModified = true;
      }
    }
    else if(oldSearchType instanceof MTRSearchOptions.MTRFilterSearch) {
      
      oldFilterSearchType = (MTRSearchOptions.MTRFilterSearch)oldSearchType;
      filterSearchType = (MTRSearchOptions.MTRFilterSearch)searchType;
      
      if(filterSearchType.CampaignId != oldFilterSearchType.CampaignId
        || filterSearchType.Who != oldFilterSearchType.Who
        || filterSearchType.What != oldFilterSearchType.What) {
        isModified = true;
      }
    }
        
    
    return isModified;
  }
  
  public override void SetSearchType(MTRSearchOptions.MTRBaseSearch searchType) {
  
    Boolean isModified = false;

    if(this.SearchType != null) {
      isModified = IsSearchTypeModified(searchType);
    }
        
    super.SetSearchType(searchType);
    
    if(isModified) {
      this.Reset();
    }
  }
  
  public override List<SObject> GetRecords() {
     System.debug('\n @@@@@@@@@ FIRST QGetRecords ');
    List<SObject> objList = null;
    if(m_SetCon == null) {
      System.debug('\n @@@@@@@@@ 111111 QGetRecords ');
      Long lStart = System.now().getTime() ;
      
      // Verify leader details populated
      if(this.leaderInfo == null){
    	  //String query = 'select Id, LFT_ND_ID__c, RGT_ND_ID__c, Genealogy_Level__c from ' + this.marketRepIndicator + ' where ACCT_NR__c = '
    	  List<Sobject> leader = GetZeroGenerationRecords();
    	  this.leaderInfo = new LeaderInfo(this.SearchType.AccountNumber, (String)leader[0].get('ROOT_UPLN_ACCT_NR__c'), (Decimal)leader[0].get('LFT_ND_ID__c'), (Decimal)leader[0].get('RGT_ND_ID__c'), (Decimal)leader[0].get('Genealogy_Level__c'));
      }
        
      String query = GenerateSOQLQuery();
      System.debug(Logginglevel.ERROR, 'XXXQuery: ' + query);
      System.debug('\n @@@@@@@@@ QUERY -- \n'+query);
      //objList = Database.query(query);
        
      
      //System.debug('\n @@@@@@@@@ QUERY RESULT objList size '+objList.size());
       /* for(SObject obj : objList){
        	System.debug('\n @@@@@@@@@ LOOP  ');
        	if (obj.getSObject('Personal_Performance_Key__r') != null) {
        	System.debug('\n @@@@@@@@@ LOOP get Personal_Performance_Key__r ');	
        		
        	System.debug('\n @@@@@@@@@ LOOP get Personal_Performance_Key__r DATA LDRSHP_TITL_LVL_NR__c '+(String)obj.getSObject('Personal_Performance_Key__r').get('LDRSHP_TITL_LVL_NR__c'));	
        	}
        	if (obj.getSObject('Contact_Key__r') != null) {
        	System.debug('\n @@@@@@@@@ LOOP get Contact_Key__r ');		
        	System.debug('\n @@@@@@@@@ LOOP get Contact_Key__r DATA Firstname '+(String)obj.getSObject('Contact_Key__r').get('FirstName'));
        	System.debug('\n @@@@@@@@@ LOOP get Contact_Key__r DATA Lastname '+(String)obj.getSObject('Contact_Key__r').get('LastName'));	
        	}
        	if (obj.getSObject('Leadership_Summary_Key__r') != null) {
        	System.debug('\n @@@@@@@@@ LOOP get Leadership_Summary_Key__r ');		
        	System.debug('\n @@@@@@@@@ LOOP get Leadership_Summary_Key__r DATA ALL_DOWNLN_CNT_WITH_REMV__c '+obj.getSObject('Leadership_Summary_Key__r').get('ALL_DOWNLN_CNT_WITH_REMV__c'));
        		
        	}
        }*/
      
      m_SetCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
      Long lEnd = System.now().getTime();
            
      Long diff = lEnd - lStart;
      
      m_SetCon.setPageSize(this.PageSize);
      m_SetCon.setPageNumber(m_PageNumber);
      
      this.TotalRecords = m_SetCon.getResultSize();
       System.debug('\n ####### Total Record :::: '+this.TotalRecords);
           
    }
    //System.debug('\n @@@@@@@@@ LAST QGetRecords ');
    return m_SetCon.getRecords();
  }
  
  public void Reset() {
    
    this.ReportConfigIsModified = true;
    m_SetCon = null;
    m_PageNumber = 1;
  }
  
  private void CanThrowPropertyException(String propertyName) {
    
     if(m_SetCon == null) {
        throw new InvalidOperationException('MTRPagedSOQLBuilder::'+ propertyName +' Exception Error=Please query at least one record before accessing this property.');  
      }
  }
  
  private void CanThrowMethodException(String methodName) {
    
    if(m_SetCon == null) {
      throw new InvalidOperationException('MTRPagedSOQLBuilder::'+ methodName  +' Exception Error=Please query at least one record before calling this method.');  
      }
  }
  
  public Integer PageNumber {
  
        get {

          if(m_SetCon == null) {
            return m_PageNumber;
          }
          else {
            return m_SetCon.getPageNumber();
          }
        }
        set {
          
          if(m_SetCon == null) {
            m_PageNumber = value;
          }
          else {
            m_SetCon.setPageNumber(value);
          }
        }

    }
        
  public Boolean HasNext {

        get {
          
       CanThrowPropertyException('HasNext');
                
            return m_SetCon.getHasNext();
        }
    }

    public Boolean HasPrevious {

        get {

          CanThrowPropertyException('HasPrevious');
          
            return m_SetCon.getHasPrevious();
        }
    }

    public void First() {

    CanThrowMethodException('First');
          
        m_SetCon.first();
    }

    public void Last() {

    CanThrowMethodException('Last');
      
       m_SetCon.last();
    }

    public void Previous() {

    CanThrowMethodException('Previous');
    
        m_SetCon.previous();
    }

    public void Next() {

    CanThrowMethodException('Next');
    
        m_SetCon.next();
    }
    
    //added by Supriyo March 19, 2013 for TA/MTO pagination change
    public void setpageNumber(Integer pageNumber) {

		//CanThrowMethodException('Next');
		
        m_SetCon.setpageNumber(pageNumber);
    }
}