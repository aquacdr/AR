/***************************************************************************
 Name          : almAnalyticsAPIImp 
 Description   : Callout Utility 
 Created By    : Parul Gupta 
 updated by    : Lalit Bohra
 updated date  : 04 feb 2014
 Created Date  : 16 Dec, 2013                
****************************************************************************/
global class almAnalyticsAPIImp implements IalmReportService{ 
     private static IalmReportService instance = null;
     
     public static IalmReportService getInstance(){    
        if(instance == null) instance = new almAnalyticsAPIImp();
        return instance;
    }
     
     
    //==============================================================================================//
    // Get Filter Criteria Dynamically from a rest api describe call of the report
    //==============================================================================================//
    public String getAnalyticsReportDescribe(String sfdcServerName, String reportID){
        system.debug('in almAnalyticsAPIImp');
        String baseURL = 'https://' + sfdcServerName +
                         + '/services/data/v29.0/analytics/reports/' + reportID + '?describe';
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndPoint(baseURL);
        request.setTimeOut(20000) ;
        request.setHeader('Authorization','OAuth ' + UserInfo.getSessionID());              
        request.setHeader('Content-Type', 'application/json');      
        request.setHeader('X-PrettyPrint','1');
        
        Http http = new Http();
        system.debug('request = ' + request);
        HttpResponse response = http.send(request);
        system.debug('response = ' + response);
        if(response.getStatusCode() == 200) {          
          return response.getBody();
        }else{
            String logMessage = 'almAnalyticsAPIImp::getAnalyticsReportDescribe::Method Parameters::sfdcServerName = '
                                + sfdcServerName + ', reportID = ' + reportID 
                                + '::HTTP Error Response = '+ response.getBody();
            ALMLogUtils.log(logMessage);
        }
        return null;
    }
    
    //===========================================================================//
    // Call analytics api to get report metadata
    //===========================================================================//
    public String getAnalyticsReportResponse(String currentSFDCServerName, 
                                                            String reportID, 
                                                            String filterLogic, 
                                                            List<ReportFilter> filters){
        if (filterLogic != null && filters.size() > 0){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();     
            gen.writeFieldName('reportMetadata');
            gen.writeStartObject();     
            gen.writeIdField('id', reportID);           
            gen.writeStringField('reportBooleanFilter', filterLogic);           
            gen.writeFieldName('reportFilters');
            gen.writeStartArray(); // start marker for json object ‘[‘
            for (Integer index = 0; index < filters.size(); index++){               
                gen.writeStartObject(); // start marker for json object ‘{‘
                gen.writeStringField('value', filters[index].value);
                gen.writeStringField('column', filters[index].column);
                gen.writeStringField('operator', filters[index].operator);
                gen.writeEndObject();               
            }          
            gen.writeEndArray();            
            gen.writeEndObject();
            gen.writeEndObject(); 
    
            String requestBody = gen.getAsString();
            return executeHttpPostCall(currentSFDCServerName, reportID, requestBody);
        }else {
            return executeHttpGetCall(currentSFDCServerName, reportID);
        }
        return null;
    }
    
    //===========================================================================//
    // Call analytics api to get report metadata (HTTP GET METHOD)
    //===========================================================================//
    public String executeHttpGetCall(String sfdcServerName, String reportID){           
        String baseURL = 'https://' + sfdcServerName +
                         + '/services/data/v29.0/analytics/reports/' + reportID + '?includeDetails=true' ;
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndPoint(baseURL);
        request.setTimeOut(20000) ;
        request.setHeader('Authorization','OAuth ' + UserInfo.getSessionID());
        request.setHeader('X-PrettyPrint','1');
          
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
          return response.getBody();
        }else{
            String logMessage = 'almAnalyticsAPIImp::executeHttpGetCall::Method Parameters::sfdcServerName = '
                                + sfdcServerName + ', reportID = ' + reportID 
                                + '::HTTP Error Response = '+ response.getBody();
            ALMLogUtils.log(logMessage);
        }
        return null;                
    }
    
    //===========================================================================//
    // Call analytics api to get report metadata (HTTP POST METHOD)
    //===========================================================================//
    public String executeHttpPostCall(String sfdcServerName, String reportID, String requestBody){          
        String baseURL = 'https://' + sfdcServerName +
                         + '/services/data/v29.0/analytics/reports/' + reportID + '?includeDetails=true';
        
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndPoint(baseURL);
        request.setHeader('Authorization','OAuth ' + UserInfo.getSessionID());
                
        request.setHeader('Content-Type', 'application/json');      
        request.setBody(requestBody);

        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {          
          return response.getBody();
        }else{
            String logMessage = 'almAnalyticsAPIImp::executeHttpPostCall::Method Parameters::sfdcServerName = '
                                + sfdcServerName + ', reportID = ' + reportID + ', requestBody = ' + requestBody
                                + '::HTTP Error Response = '+ response.getBody();
            ALMLogUtils.log(logMessage);
        }
        return null;
    }
  
}