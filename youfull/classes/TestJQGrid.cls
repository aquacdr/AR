global with sharing class TestJQGrid{
  private static string columns;  
  private static string columnsDataJson; 
    
  //=================================================================//
  // Constructor
  //=================================================================//
  public TestJQGrid() {
     
  }
  
  //=================================================================//
  // Remote Method Returning Column Headers
  //=================================================================//
  @remoteAction
  global static List<WrapperColumns> columnList() {
     // here in columns we need to first put the object Api name and then its label.In case of any data set we can create this type of string and pass it to // // web page.
     
     String sColumns = 'Account Id;Id,Account Name;Name,Description;Description,AccountNumber;AccountNumber,Type;Type,Owner;OwnerId,CurrencyIsoCode;CurrencyIsoCode';     
     string[] sArr = sColumns.split(',');
     system.debug('----------------- sArr --------------------'+sArr);
     list<WrapperColumns> listWrapperColumns = new list<WrapperColumns>();     
     for(String s : sArr){
         system.debug('-----------------s--------------------'+s);
         string[] sColumnSep = s.split(';');               
         WrapperColumns objWrapperColumns = new WrapperColumns();
         objWrapperColumns.ColumnLabel = sColumnSep.get(0);
         objWrapperColumns.ColumnName = sColumnSep.get(1);  
         objWrapperColumns.ColumnWidth = sColumnSep.get(0).length() * 10;   
         listWrapperColumns.add(objWrapperColumns);
     } 
     system.debug('-----------------listWrapperColumns--------------------'+listWrapperColumns);
     return listWrapperColumns;     
  }
  
  //=================================================================//
  //Remote Method returning report data
  //=================================================================//
  @remoteAction
  global static String jsonData() {

        columnsDataJson=columnsDataJson='[{"Name":"Zone 404 Group 8","Description":"Account for Zone 404 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAW"},{"Name":"Zone 405 Group 8","Description":"Account for Zone 405 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAA"},{"Name":"Zone 405 Group 8","Description":"Account for Zone 405 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAB"},{"Name":"Zone 406 Group 8","Description":"Account for Zone 406 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAC"},{"Name":"Zone 407 Group 8","Description":"Account for Zone 407 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAD"},{"Name":"Zone 408 Group 8","Description":"Account for Zone 408 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAE"},{"Name":"Zone 409 Group 8","Description":"Account for Zone 409 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAF"},{"Name":"Zone 408 Group 8","Description":"Account for Zone 408 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAG"},{"Name":"Zone 402 Group 8","Description":"Account for Zone 402 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAH"},{"Name":"Zone 403 Group 8","Description":"Account for Zone 403 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAI"},{"Name":"Zone 401 Group 8","Description":"Account for Zone 401 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAJ"},{"Name":"Zone 405 Group 8","Description":"Account for Zone 405 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAK"},{"Name":"Zone 409 Group 8","Description":"Account for Zone 409 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAL"},{"Name":"Zone 403 Group 8","Description":"Account for Zone 403 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAM"},{"Name":"Zone 402 Group 8","Description":"Account for Zone 402 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAN"},{"Name":"Zone 402 Group 8","Description":"Account for Zone 402 Group 8","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrIIAO"},{"Name":"Zone 401 Group 9","Description":"Account for Zone 401 Group 9","CurrencyIsoCode":"USD","OwnerId":"005F0000002XPMWIA4","Id":"001F000000tSKrJIAP"}]';        return columnsDataJson;
  }
  
    //=================================================================//
  //To create data Json String
  //=================================================================//
  /*
  public static void createJSONDataString(){
    // columns='Name;AccountName,AccountNumber;AccountNumber,AnnualRevenue;AnnualRevenue';
    list<Account> listAccount=[Select Name,AccountNumber,AnnualRevenue from Account limit 100];
        
    Map<String,Object> mpTopLevelParse = (Map<String,Object>)JSON.deserializeUntyped(getReportData());
    Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
    List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns'); 
      
    Integer i = 0;
    columnsJson = '[';
       
    Map<String,Object> mpFactMap = (Map<String,Object>)mpTopLevelParse.get('factMap'); 
    Map<String,Object> mpDataMap = (Map<String,Object>)mpFactMap.get('T!T');
        
    for(Object dataRecord : (List<Object>)mpDataMap.get('rows')) {
      columnsJson += '{';
      Map<String, Object> mpRowObj = (Map<String, Object>)dataRecord;
      List<Object> lstDataCell =  (List<Object>)mpRowObj.get('dataCells');
         
      i = 0;
      for(Object dataCellRow : lstDataCell) {           
        Map<String,Object> dataCell = (Map<String,Object>)dataCellRow;
        columnsJson += '"'+(String)mpReportDetailColumnLst.get(i++)+ '":"' +String.valueOf(dataCell.get('label'))+ '",';
      }
      columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
      columnsJson += '},';
    }       
    columnsJson = columnsJson.substring(0, columnsJson.length() - 1) ;
    columnsJson += ']';
  }*/
  
  //=================================================================//
  //Wrapper Class for table columns
  //=================================================================//
  global class WrapperColumns{
    public String ColumnLabel{get;set;} 
    public String ColumnName{get;set;} 
    public Integer ColumnWidth{get;Set;}   
  }  
  
}