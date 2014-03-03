/***************************************************************************
 Name          : ALM_ServiceInt_ReportAnalyticsAPI 
 Description   : Callout Utility 
 Created By    : Parul Gupta 
 updated by    : Lalit Bohra
 updated date  : 04 feb 2014
 Created Date  : 16 Dec, 2013                
****************************************************************************/
global class ALM_ServiceInt_ReportAnalyticsAPI implements ALM_ServiceInt_Report { 
     private static ALM_ServiceInt_Report instance = null;
     
     public static ALM_ServiceInt_Report getInstance(){    
        if(instance == null) instance = new ALM_ServiceInt_ReportAnalyticsAPI();
        return instance;
    }     
     
    //==============================================================================================//
    // Get Filter Criteria Dynamically from a rest api describe call of the report
    //==============================================================================================//
    public String getAnalyticsReportDescribe(String sfdcServerName, String reportID){
      //  ALMLogUtils.log('ALM_ServiceInt_ReportAnalyticsAPI::getAnalyticsReportDescribe::Method Parameters::sfdcServerName = '
       //                 + sfdcServerName + ', reportID = ' + reportID );
                        
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
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {          
          return response.getBody();
        }else{
            String logMessage = 'ALM_ServiceInt_ReportAnalyticsAPI::getAnalyticsReportDescribe::Method Parameters::sfdcServerName = '
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
                                                                
        ALMLogUtils.log('ALM_ServiceInt_ReportAnalyticsAPI::getAnalyticsReportResponse::Method Parameters::sfdcServerName = '
                        + currentSFDCServerName + ', reportID = ' + reportID 
                        + ',filterLogic = '+ filterLogic +', filters = '+ filters);
                        
        // Temporary workaround to deal with DML issues for ALMLogUtils              
        System.debug('ALM_ServiceInt_ReportAnalyticsAPI::getAnalyticsReportResponse::Method Parameters::sfdcServerName = '
                        + currentSFDCServerName + ', reportID = ' + reportID 
                        + ',filterLogic = '+ filterLogic +', filters = '+ filters);
                        
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
                if(filters[index].value == null){
                    filters[index].value = '';
                }
                gen.writeStringField('value', filters[index].value);
                gen.writeStringField('column', filters[index].column);
                gen.writeStringField('operator', filters[index].operator);
                gen.writeEndObject();               
            }          
            gen.writeEndArray();            
            gen.writeEndObject();
            gen.writeEndObject(); 
    
            String requestBody = gen.getAsString();
            
            ALMLogUtils.log('ALM_ServiceInt_ReportAnalyticsAPI::getAnalyticsReportResponse::Request Body = '+ requestBody);

            // Temporary workaround to deal with DML issues for ALMLogUtils            
            System.debug('ALM_ServiceInt_ReportAnalyticsAPI::getAnalyticsReportResponse::Request Body = '+ requestBody);
            
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
            String logMessage = 'ALM_ServiceInt_ReportAnalyticsAPI::executeHttpGetCall::Method Parameters::sfdcServerName = '
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
        }
         // lets log the request...PLEASE NOTE:  Must take place after the callout due to apex limits on callouts
        String logMessage = 'ALM_ServiceInt_ReportAnalyticsAPI::executeHttpPostCall::Method Parameters::sfdcServerName = '
              + sfdcServerName + ', reportID = ' + reportID + ', requestBody = ' + requestBody
              + '::HTTP Response = '+ response.getBody();
            ALMLogUtils.log(logMessage);
            
        return null;
    }
  
}