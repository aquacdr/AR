//Query Genealogy objects in a nice parameterized, object-oriented way.

/*
//GenealogySOQLBuilder Documentation:

GenealogySOQLBuilder gsb = new GenealogySOQLBuilder('62'); //Specify market
Set<String> queryFieldSet = new Set<String>();
List<SObject> genealogyList = null;

queryFieldSet.add('Id');
queryFieldSet.add('ACCT_NR__c');
queryFieldSet.add('ALL_DWNLN_CNT__c');
queryFieldSet.add('UPLN_GEN_INDX__c');
queryFieldSet.add('UPLN_ACCT_NR__c');
queryFieldSet.add('Contact_Key__r.FirstName');
queryFieldSet.add('Contact_Key__r.LastName');

gsb.queryFieldSet = queryFieldSet;

//Where Clause Only
genealogyList = gsb.query('ACCT_NR__c = \'10009\'');

//Where Clause and Order By
genealogyList = gsb.query('ACCT_NR__c = \'10009\'', 'Contract_Ket__r.FirstName');

//Where Clause, Order By, Limit Clause
genealogyList = gsb.query('ACCT_NR__c = \'10009\'', 'Contract_Ket__r.FirstName', '1000');

//Need access to GROUP BY or HAVING use this method?

//Valid options to pass to map:
//'WHERE', 'WITH', 'GROUP BY', 'HAVING', 'ORDER BY', 'LIMIT', 'OFFSET'

Map<String, String> queryOptionsMap = new Map<String, String>();

queryOptionsMap.put('WHERE','ACCT_NR__c = \'10009\'');
queryOptionsMap.put('GROUP BY','UPLN_ACCT_NR__c');
queryOptionsMap.put('ORDER BY','ACCT_NR__c');
queryOptionsMap.put('LIMIT','1000');

genealogyList = gsb.query(queryOptionsMap);

//Treat non-existent zero-generation records as you would regular records with the function
//This function gets an existing genealogy object from the database and clones it and assigns
//the zero-generation's contact, personal performance, and leadership downline to this clone record

//Basically, this function will take the queryFieldSet parameters and parse the fields and group them 
//based on object, and perform a separate queries based on the objects found in the queryFieldSet and
//join them together in a cloned genealogy object.

Set<String> accountNumberSet = new Set<String>();

accountNumberSet.add('10009');
accountNumberSet.add('10010');
accountNumberSet.add('10011');
accountNumberSet.add('10012');

genealogyList = gsb.queryZeroGeneration(accountNumberSet);

*/

public class GenealogySOQLBuilder {

  //Query Options in string format for comparing
  private String m_queryOptionsCompareString = '';
  
  //Query clauses that are expected by this class
  private List<String> queryOptionsSupportedList { get; set; }
  
  //Market whose Genealogy object we want to query
  public String marketId { get; set; }
  
  // Rep Indicator of the Market
  public String marketRepIndicator {get; set;}
  
  //Fields to pull from database
  public Set<String> queryFieldSet { get; set; }
  
  
  private String leaderAccNr;
  private String rootUplineAccNr;
  private Long level;
  private Long leftIndex;
  private Long rightIndex;
  
  public GenealogySOQLBuilder(String marketId) {
    this.intialize(marketId, null);
  }
  
  public GenealogySOQLBuilder(Id userId) {
    this.intialize(userId, null);
  }
  
  public GenealogySOQLBuilder(String marketId, Set<String> queryFieldSet) {
    this.intialize(marketId, queryFieldSet);
  }
  
  public GenealogySOQLBuilder(Id userId, Set<String> queryFieldSet) {
    this.intialize(userId, queryFieldSet);
  }
  
  public GenealogySOQLBuilder(String marketId, String accId, Set<String> queryFieldSet){
  	this.initialize(marketId, accId, queryFieldSet);	
  }
  
  private void initialize(String marketId, String campaignId, String accountId, String rootAccountId, Long level,Long leftIndex, Long rightIndex){
  	    this.marketId = marketId;
      	this.leaderAccNr=accountId;
      	this.rootUplineAccNr=rootAccountId;
      	this.level=level;
      	this.leftIndex=leftIndex;
      	this.rightIndex=rightIndex;
  }
  
  private void initialize(String marketId, String accId, Set<String> queryFieldSet){
  		this.marketId = marketId;
    	this.queryFieldSet = queryFieldSet;
    	this.leaderAccNr = accId;
    	this.marketRepIndicator = [select ALM_Rep_Indicator__c from Market__c where Market_Id__c =: marketId limit 1].ALM_Rep_Indicator__c;
    	this.intializeAll();
  }
  
  //Intializes variables
  private void intialize(String marketId, Set<String> queryFieldSet) {
    
    this.marketId = marketId;
    this.queryFieldSet = queryFieldSet;
    
    this.intializeAll();
  }
  
  //Intializes variables, but get MarketId from User object
  private void intialize(Id userId, Set<String> queryFieldSet) {
    
    User user = [SELECT Id, MRKT_ID__c FROM User
            WHERE Id = :userId];
    
    if(user == null) {
      throw new InvalidOperationException('GenealogySOQLBuilder::intialize Exception Error=The specified user account was not found.');
    }
    
    this.marketId = user.MRKT_ID__c;
    this.queryFieldSet = queryFieldSet;
    
    this.intializeAll();
  }
  
  //Initializes variables that do not depend on user input
  private void intializeAll() {
    
    this.queryOptionsSupportedList = new List<String>();
    
    this.queryOptionsSupportedList.add('WHERE');
    this.queryOptionsSupportedList.add('WITH');
    this.queryOptionsSupportedList.add('GROUP BY');
    this.queryOptionsSupportedList.add('HAVING');
    this.queryOptionsSupportedList.add('ORDER BY');
    this.queryOptionsSupportedList.add('LIMIT');
    this.queryOptionsSupportedList.add('OFFSET');
    
    m_queryOptionsCompareString = '|WHERE|WITH|GROUP BY|HAVING|ORDER BY|LIMIT|OFFSET|';
  }
  
  //Validates QueryOptions to ensure that we do not get any invalid or empty options.
  private void validateQueryOptionsSupported(Map<String,String> queryOptionsMap) {
    
    Set<String> optionsSet = new Set<String>();
    String valueData = '';
    
    if(queryOptionsMap == null || queryOptionsMap.size() == 0) {
      throw new ArgumentException('GenealogySOQLBuilder::validateQueryOptionsSupported Exception Error=queryOptionsMap is empty.');
    }
    
    for(String optionKey : queryOptionsMap.keySet()) {
      
      if(m_queryOptionsCompareString.indexOf('|' + optionKey + '|') == -1) {
        throw new ArgumentException('GenealogySOQLBuilder::validateQueryOptionsSupported Exception Error=The Query Option: ' + optionKey + ' is not currently supported.  Please check this option again.  Invalid casing can cause this error also.');
      }
      
      valueData = queryOptionsMap.get(optionKey);
      
      if(valueData == null || valueData.length() == 0) {
        throw new ArgumentException('GenealogySOQLBuilder::validateQueryOptionsSupported Exception Error=The Query Option: ' + optionKey + ' was provided, but no valid data was found.');
      }
    }
  }
  
  //Validates global parameters used by many methods.
  private void validateParameters() {
    
    if(this.marketId == null || this.marketId.length() == 0) {
      throw new ArgumentException('GenealogySOQLBuilder::validateParameters Exception Error=marketId is empty.');
    }
    
    if(this.queryFieldSet == null || this.queryFieldSet.size() == 0) {
      throw new ArgumentException('GenealogySOQLBuilder::validateParameters Exception Error=queryFieldSet is empty.');
    }
  }
  
  //Generates query data in a comma delimited list.  Optionally, can have query data enclosed in single quotes.
  private String generateQueryCommaListClause(Set<String> queryData, Boolean includeQuotes) {
    
    String output = '';
    
    for(String tempData : queryData) {
      
      if(output.length() == 0) {
        
        if(includeQuotes) {
          output = '\'' + String.escapeSingleQuotes(tempData) + '\'';
        }
        else {
          output = String.escapeSingleQuotes(tempData);
        }
      }
      else {
        
        if(includeQuotes) {
          output += ', \'' + String.escapeSingleQuotes(tempData) + '\'';
        }
        else {
          output += ', ' + String.escapeSingleQuotes(tempData);
        }
      }
    }
    
    return output;
  }
  
  //Generates query clause based on Query Options passed from user.
  private String generateQueryClause(Map<String,String> queryOptionsMap) {
    
    String queryClause = '';
    String queryOptionValue = '';
    
    for(String optionKey : this.QueryOptionsSupportedList) {
    
      queryOptionValue = queryOptionsMap.get(optionKey);
      
      if(queryOptionValue != null && queryOptionValue.length() > 0) {
        
        if(optionKey == 'WHERE') {
          if(queryClause == ''){
          	queryClause = ' ' + queryOptionValue;
          }
          else {
          	queryClause += ' AND ' + queryOptionValue;
          }
        }
        else {
          queryClause += ' ' + optionKey + ' ' + queryOptionValue;
        }
      }
    }
    
    return queryClause;
  }
  
  //Takes query fields expected to be pull from the database and sorts them in seperate Sets by related object.
  
  private Map<String, Set<String>> sortColumnsByGroup(Set<String> queryFieldSet) {
    
    Map<String, Set<String>> columnGroupMap = new Map<String, Set<String>>();
    Set<String> newObjectSet = new Set<String>();
    Set<String> columnNameSet = null;
    String[] dataSplit = null;
    String objectName = '';
    String fieldName = '';
    Integer delimiterPos = -1;
    
    
    for(String queryField : queryFieldSet) {
      
      //Prepare to seperate: 'Name' into 'Leadership_Summary_Key__r' and 'Name'.
      delimiterPos = queryField.indexOf('.');
      
      if(delimiterPos > -1) {
        
        objectName = queryField.substring(0, delimiterPos).trim();
        fieldName = queryField.substring(delimiterPos + 1).trim();
      }
      else {
        
        objectName = 'Genealogy'; //Explicitly state Genealogy because its field names will not have its object name as a qualifier.
        fieldName = queryField.trim();
      }
      
      //See if we have a column name set already for this object
      columnNameSet = columnGroupMap.get(objectName);
      
      //Create a column name set for this object because we did not find an existing one
      if(columnNameSet == null) {
        
        columnNameSet = new Set<String>();
        columnGroupMap.put(objectName, columnNameSet);
      }
      
      //Explicity add ACCT_NR__c to sets so we can compare later on
      if(!newObjectSet.contains(objectName)) {
        
        columnNameSet.add('Name');
        columnNameSet.add('ACCT_NR__c');
        
        newObjectSet.add(objectName);
      }
      
      columnNameSet.add(fieldName);
    }
    
    return columnGroupMap;
  }
  
  public List<SObject> query(String whereClause) {
    
    Map<String,String> queryOptionsMap = new Map<String,String>();
    
    queryOptionsMap.put('WHERE', whereClause);
    
    return this.query(queryOptionsMap);
  }
  
  public List<SObject> query(String whereClause, String orderByClause) {
    
    Map<String,String> queryOptionsMap = new Map<String,String>();
    
    queryOptionsMap.put('WHERE', whereClause);
    queryOptionsMap.put('ORDER BY', orderByClause);
    
    return this.query(queryOptionsMap);
  }
  
  public List<SObject> query(String whereClause, String orderByClause, String limitClause) {
    
    Map<String,String> queryOptionsMap = new Map<String,String>();
    
    queryOptionsMap.put('WHERE', whereClause);
    queryOptionsMap.put('ORDER BY', orderByClause);
    queryOptionsMap.put('LIMIT', limitClause);
    
    return this.query(queryOptionsMap);
  }
  
  //Generation zeros were removed from the Genealogy object.  So, we will need a way to represent these missing records
  //polymorphically along with downline Genealogies if needed.  This function clones an existing Genealogy object and assigns
  //the Contact, Leadership Downline, and Personal Performance objects to 
  
  /***** Commenting the method, as its not being used anymore ****/
  
  /*
  public List<SObject> queryZeroGeneration(Integer campaignId, Set<String> accountNumberSet) {
    
    this.validateParameters();
    
    if(accountNumberSet == null || accountNumberSet.size() == 0) {
      throw new ArgumentException('GenealogySOQLBuilder::queryZeroGeneration Exception Error=accountNumberSet is empty.');
    }
    
    Map<String, Set<String>> columnGroupMap = null;
    Map<String, SObject> genealogyMap = new Map<String, SObject>();
    List<Contact> contactList = null;
    List<Leader_Downline_Summary__c> leaderDownlineList = null;
    List<My_Business__c> myBusinessList = null;
    Set<String> columnNameSet = null;
    SObject objTempGenealogy = null;
    SObject objGenealogy = null;
    String fixedMarketId = String.escapeSingleQuotes(this.MarketId);
    String query = '';
    String accountNumbers = '';
    String tempName = '';
    
    System.debug('XXXAccountNumberSet: ' + accountNumberSet);
    
    //Get map that stores column names by object name
    columnGroupMap = sortColumnsByGroup(this.queryFieldSet);
    
    columnNameSet = columnGroupMap.get('Genealogy');
    
    if(columnNameSet == null || columnNameSet.size() == 0) {
      throw new ArgumentException('GenealogySOQLBuilder::queryZeroGeneration Exception Error=The queryFieldSet parameter did NOT have any Genealogy-related fields.');
    }
    
    //Get Genealogy object that we are going to clone
    query = 'SELECT '+ this.generateQueryCommaListClause(this.queryFieldSet, false)  +' FROM X' + fixedMarketId + '_Genealogy__c LIMIT 1';
    System.debug('\n @@@@@@ query ######### \n'+query);
    objGenealogy = Database.query(query);
    
    if(objGenealogy == null) {
      throw new InvalidOperationException('GenealogySOQLBuilder::queryZeroGeneration Exception Error=Could not find Genealogy object to clone for Zero Generation Genealogy.');
    }
    
    //Put account numbers into comma-delimited list so we can use them in our query
    accountNumbers = this.generateQueryCommaListClause(accountNumberSet, true);
    
    //Query Contact list
    columnNameSet = columnGroupMap.get('Contact_Key__r');
    
    if(columnNameSet != null && columnNameSet.size() > 0) {
  
      query = 'SELECT ' + this.generateQueryCommaListClause(columnNameSet, false) + ' FROM Contact';
      query += ' WHERE MRKT_ID__c = \'' + fixedMarketId  + '\' AND ACCT_NR__c IN ('+ accountNumbers +')';

      contactList = Database.query(query);
    }    
    
    //Query Leader Downline list
    columnNameSet = columnGroupMap.get('Leadership_Summary_Key__r');
    
    System.debug('fixedMarketId: ' + fixedMarketId);
    System.debug('campaignId: ' + campaignId);
    System.debug('accountNumbers: ' + accountNumbers);
    if(columnNameSet != null && columnNameSet.size() > 0) {
    
      query = 'SELECT ' + this.generateQueryCommaListClause(columnNameSet, false) + ' FROM Leader_Downline_Summary__c';
      query += ' WHERE MRKT_ID__c = \'' + fixedMarketId  + '\' AND OPERTNL_CMPGN_NR__c = \'' + campaignId + '\' AND ACCT_NR__c IN ('+ accountNumbers +')';

      leaderDownlineList = Database.query(query);
    }

    //Query Personal Performance list
    columnNameSet = columnGroupMap.get('Personal_Performance_Key__r');
    
    if(columnNameSet != null && columnNameSet.size() > 0) {

      query = 'SELECT ' + this.generateQueryCommaListClause(columnNameSet, false) + ' FROM My_Business__c';
      query += ' WHERE MRKT_ID__c = \'' + fixedMarketId  + '\' AND OPERTNL_CMPGN_NR__c = \'' + campaignId + '\' AND ACCT_NR__c IN ('+ accountNumbers +')';

      myBusinessList = Database.query(query);
    }
    

    //Create Genealogy Map so we can iterate by Account Number
    
    for(String accountNumber: accountNumberSet) {
      
      objTempGenealogy = objGenealogy.clone(false, true, false, false);
      
      objTempGenealogy.put('UPLN_GEN_INDX__c', 0);
      objTempGenealogy.put('ACCT_NR__c', accountNumber);
      objTempGenealogy.put('UPLN_ACCT_NR__c', '');
      objTempGenealogy.put('Name', '');
      
      objTempGenealogy.put('Contact_Key__c', null);
      objTempGenealogy.putSObject('Contact_Key__r', null);
      
      objTempGenealogy.put('Leadership_Summary_Key__c', null);
      objTempGenealogy.putSObject('Leadership_Summary_Key__r', null);
      
      objTempGenealogy.put('Personal_Performance_Key__c', null);
      objTempGenealogy.putSObject('Personal_Performance_Key__r', null);
      
      genealogyMap.put(accountNumber, objTempGenealogy);
    }
    
    //Assign Contacts To Genealogy
    
    if(contactList != null) {
      
      for(Contact contact: contactList) {
        
        objTempGenealogy = genealogyMap.get(contact.ACCT_NR__c);
        
        if(objTempGenealogy != null) {
          
          tempName = (String)objTempGenealogy.get('Name');

          if(tempName.length() == 0) {
            objTempGenealogy.put('Name', contact.Name);
          }
          
          objTempGenealogy.put('Contact_Key__c', contact.Id);
          objTempGenealogy.putSObject('Contact_Key__r', contact);
        }
      }
    }
    
    //Assign Leadership To Genealogy
    
    if(leaderDownlineList != null) {
      
      for(Leader_Downline_Summary__c leaderDownline: leaderDownlineList) {
        
        objTempGenealogy = genealogyMap.get(leaderDownline.ACCT_NR__c);
        
        if(objTempGenealogy != null) {
          
          tempName = (String)objTempGenealogy.get('Name');
          
          if(tempName.length() == 0) {
            objTempGenealogy.put('Name', leaderDownline.Name);
          }
          
          objTempGenealogy.put('Leadership_Summary_Key__c', leaderDownline.Id);
          objTempGenealogy.putSObject('Leadership_Summary_Key__r', leaderDownline);
        }
      }
    }
    
    //Assign Leadership To MyBusiness
    
    if(myBusinessList != null) {
      
      for(My_Business__c myBusiness: myBusinessList) {
        
        objTempGenealogy = genealogyMap.get(myBusiness.ACCT_NR__c);
        
        if(objTempGenealogy != null) {
          
          tempName = (String)objTempGenealogy.get('Name');
          
          if(tempName.length() == 0) {
            objTempGenealogy.put('Name', myBusiness.Name);
          }
          
          objTempGenealogy.put('Personal_Performance_Key__c', myBusiness.Id);
          objTempGenealogy.putSObject('Personal_Performance_Key__r', myBusiness);
        }
      }
    }
    
    System.debug('XXXGenealogySOQLBuilderMap: ' + genealogyMap.values());
    
    return genealogyMap.values();
  } 
  
  */
  
  //Query Genealogy by Query Options
  /****
  New Query method, to query the ALM Performance Object, based on the query options.
  The Field list must have already been set on the object level at this point
  Provide all Where condition clauses in the query Options
  ****/
  public List<SObject> queryNew(Map<String, String> queryOptionsMap){
  		String query = generateQueryNew(queryOptionsMap);
  		System.debug('\n ### query :: \n '+query);
    	return Database.query(query);
  }
  
  public String getWhereClauseForGenerations(Integer numberOfLevels, Boolean upLine) {
  	 //upline 
  	 String query='';
     Long newLevel;
  	 if(upline){
  	 	newLevel=level-numberOfLevels;
  	 	query+='where lft_nd_Id__c < '+ leftIndex + ' and rgt_nd_Id__c > ' + leftIndex;
  	 	query+='and Genealogy_Level__c < '+ level + ' and Genealogy_Level__c >= ' + newLevel;
  	 }
  	 else{
  	 	newLevel=level+numberOfLevels;
  	    query+='where lft_nd_Id__c < '+ rightIndex;
  	    query+='and Genealogy_Level__c > '+ level + ' and Genealogy_Level__c <= ' + newLevel;
  	 }
  	 
  	 return query;
  	 
  }
  
  public String generateQueryNew(Map<String, String> queryOptionsMap){
  		
  		this.validateParameters();
    	this.validateQueryOptionsSupported(queryOptionsMap);
  		String query = 'SELECT '+ this.generateQueryCommaListClause(queryFieldSet, false) +
  				' FROM ' + this.marketRepIndicator +
    	 		' WHERE ' + generateQueryClause(queryOptionsMap);
    
    	System.debug('====================== QUERY : ' + query);
    	return query;
  	
  }
  
  
  public List<SObject> query(Map<String,String> queryOptionsMap) {
    
    this.validateParameters();
    this.validateQueryOptionsSupported(queryOptionsMap);
    
    String query = '';
    System.debug('testing-->'+queryOptionsMap);
    query = 'SELECT '+ this.generateQueryCommaListClause(queryFieldSet, false) +' FROM X' + String.escapeSingleQuotes(this.MarketId) + '_Genealogy__c';
    query += ' WHERE Market_Id__c = ' +'\''+String.escapeSingleQuotes(this.MarketId)+'\'' + generateQueryClause(queryOptionsMap);
    //query +=' WHERE ' +generateQueryClause(queryOptionsMap); 
    
    System.debug('====================== QUERY : ' + query);

    return Database.query(query);
  }  
  
  //String " Select From " statement without "Where" clause
  public String generateQuerySelect(Map<String,String> queryOptionsMap) {
    this.validateParameters();
    this.validateQueryOptionsSupported(queryOptionsMap);
    
    
    return 'SELECT '+ this.generateQueryCommaListClause(queryFieldSet, false) +' FROM X' + String.escapeSingleQuotes(this.MarketId) + '_Genealogy__c';
    
  }
  
  /*
  * Validates if an account number is in given person's downline in the given campaign (campaign must be current campaign number)
  *   
  */
  public static Boolean isAcctNrInDownline(String leaderAcctKey, String downlineAcctKey, String currentCmpgnNr, String mktId){
    
    String query = 'SELECT id' + ' FROM X' + mktId + '_Genealogy__c' + 
             + ' WHERE CMPGN_NR__c = :currentCmpgnNr AND UPLN_ACCT_NR__c = :leaderAcctKey AND ACCT_NR__c = :downlineAcctKey LIMIT 1';
    Boolean isInDownline = false;

    if(leaderAcctKey == downlineAcctKey) {
      isInDownline = true;
    }
    else if(Database.query(query).size() != 0) {
      isInDownline = true;
    }
    
    return isInDownline;
  }
}