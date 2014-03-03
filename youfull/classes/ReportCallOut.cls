/***************************************************************************
 Name          : ReportCallOut 
 Created By    : Parul Gupta 
 Created Date  : 16 Dec, 2013                
****************************************************************************/
global class ReportCallOut implements HttpCalloutMock {
	

	//==============================================================================================//
  	//Call analytics api with argument list, to get report metadata for report and return JSON response string
  	//==============================================================================================//
	public String getJSONFromReportWithArguments(String currentSFDCServerName,String reportID, String[] args){
		String argList = '';
		String arg;
		if (args != null) {
			for (Integer i = 0; i < args.size(); i++) {
				arg = args[i];
				if (String.isNotBlank(arg)) {
					argList += '&pv' + i + '=' + args[i];
				}
			}
		}
		return getJSONFromReport(currentSFDCServerName, reportID, argList);
	}

	//==============================================================================================//
  	//Call analytics api to get report metadata and return JSON response string
  	//==============================================================================================//
	public String getJSONFromReport(String currentSFDCServerName,String reportID, String argList){
	  	//return getReportJSON();	  	
	    String baseURL = 'https://' + currentSFDCServerName +
	                     + '/services/data/v29.0/analytics/reports/' + reportID + '?includeDetails=true' + argList;
	
	    HttpRequest request = new HttpRequest();
	    request.setMethod('GET');
	    request.setEndPoint(baseURL);
	    request.setHeader('Authorization','OAuth ' + UserInfo.getSessionID());
	    request.setHeader('X-PrettyPrint','1');
	      
	    Http http = new Http();
	    HttpResponse response = http.send(request);
	      
	    if(response.getStatusCode() == 200) {
	      return response.getBody();
	    }
	    return null;
	}
  
  	global HttpResponse respond(HttpRequest request) {
	    HttpResponse httpResponse = new HttpResponse();
	    httpResponse.setStatusCode(200);
	    httpResponse.setBody(getReportJSON());	    
	    return httpResponse;
  	}
  
  //=========================================================================================//
  //For Testing 
  //=========================================================================================//
  public String getReportJSON() {
    return ' { ' + 
    '  "hasDetailRows" : true,' +
    '  "attributes" : {' +
    '    "describeUrl" : "/services/data/v29.0/analytics/reports/00Ox0000000fI0eEAE/describe",' +
    '    "instancesUrl" : "/services/data/v29.0/analytics/reports/00Ox0000000fI0eEAE/instances",' +
    '    "type" : "Report",' +
    '    "reportId" : "00Ox0000000fI0eEAE",' +
    '    "reportName" : "Reason"' +
    '  },' +
    '  "reportExtendedMetadata" : {' +
    '    "detailColumnInfo" : {' +
    '      "CUST_NAME" : {' +
    '        "label" : "Reason: Reason Name",' +
    '        "dataType" : "string"' +
    '      },' +
    '      "Reason__c.Description__c" : {' +
    '        "label" : "Description",' +
    '        "dataType" : "textarea"' +
    '      }' +
    '    },' +
    '    "aggregateColumnInfo" : {' +
    '      "RowCount" : {' +
    '        "label" : "Record Count",' +
    '        "dataType" : "int",' +
    '        "acrossGroupingContext" : null,' +
    '        "downGroupingContext" : null' +
    '      }' +
    '    },' +
    '    "groupingColumnInfo" : {' +
    '      "CUST_OWNER_NAME" : {' +
    '        "label" : "Reason: Owner Name",' +
    '        "dataType" : "string",' +
    '        "groupingLevel" : 0' +
    '      }' +
    '    }' +
    '  },' +
    '  "groupingsDown" : {' +
    '    "groupings" : [ {' +
    '      "value" : "005x0000000LhrkAAC",' +
    '      "key" : "0",' +
    '      "label" : "Ritesh Gupta",' +
    '      "groupings" : [ ]' +
    '    } ]' +
    '  },' +
    '  "groupingsAcross" : {' +
    '    "groupings" : [ ]' +
    '  },' +
    '  "reportMetadata" : {' +
    '    "name" : "Reason",' +
    '    "id" : "00Ox0000000fI0eEAE",' +
    '    "currency" : null,' +
    '    "developerName" : "Reason",' +
    '    "reportType" : {' +
    '      "type" : "CustomEntity$Reason__c",' +
    '      "label" : "Custom Object"' +
    '    },' +
    '    "aggregates" : [ "RowCount" ],' +
    '    "groupingsDown" : [ {' +
    '      "name" : "CUST_OWNER_NAME",' +
    '      "sortOrder" : "Asc",' +
    '      "dateGranularity" : "None"' +
    '    } ],' +
    '    "groupingsAcross" : [ ],' +
    '    "reportFormat" : "SUMMARY",' +
    '    "reportBooleanFilter" : null,' +
    '    "reportFilters" : [ ],' +
    '    "detailColumns" : [ "CUST_NAME", "Reason__c.Description__c" ]' +
    '  },' +
    '  "allData" : true,' +
    '  "factMap" : {' +
    '    "0!T" : {' +
    '      "rows" : [ ],' +
    '      "aggregates" : [ {' +
    '        "value" : 2,' +
    '        "label" : "2"' +
    '      } ]' +
    '    },' +
    '    "T!T" : {' +
    '      "rows" : [ {' +
    '        "dataCells" : [ {' +
    '          "value" : "a00x0000001ijucAAA",' +
    '          "label" : "Reason 1"' +
    '        }, {' +
    '          "value" : "Reason 1 Description",' +
    '          "label" : "Reason 1 Description"' +
    '        } ]' +
    '      }, {' +
    '        "dataCells" : [ {' +
    '          "value" : "a00x0000001ijuhAAA",' +
    '          "label" : "Reason 2"' +
    '        }, {' +
    '          "value" : "Reason 2 Description",' +
    '          "label" : "Reason 2 Description"' +
    '        } ]' +
    '      } ],' +
    '      "aggregates" : [ {' +
    '        "value" : 2,' +
    '        "label" : "2"' +
    '      } ]' +
    '    }' +
    '  }' +
    '}';
  }
  
}