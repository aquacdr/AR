/***************************************************************************
 Name          : HTTPCalloutMockImpl
 Created By    : Barkha Jain
 Description   : Mock implementation class for HTTP Callouts
 Created Date  : Jan 13, 2014                
****************************************************************************/
@isTest
global class HTTPCalloutMockImpl implements HttpCalloutMock  {
	
	global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(getReportJSON());
        res.setStatusCode(200);
        return res;           	
    }
    
    //=========================================================================================//
  	//Create Report JSON For Testing 
  	//=========================================================================================//
  	public String getReportJSON() {
	    return ' { ' + 
	    '  "hasDetailRows" : true,' +
	    '  "attributes" : {' +
	    '    "describeUrl" : "/services/data/v29.0/analytics/reports/00Ox0000000fI0eEAE/describe",' +
	    '    "instancesUrl" : "/services/data/v29.0/analytics/reports/00Ox0000000fI0eEAE/instances",' +
	    '    "type" : "Report",' +
	    '    "reportId" : "00Ox0000000fI0eEAE",' +
	    '    "reportName" : "Test Report"' +
	    '  },' +
	    '  "reportExtendedMetadata" : {' +
	    '    "detailColumnInfo" : {' +
	    '      "ALM_Rep_Performance_1__c.Id" : {' +
	    '        "label" : "Reason: Reason Name",' +
	    '        "dataType" : "string"' +
	    '      },' +
	    '      "ALM_Rep_Performance_1__c.Name" : {' +
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
	    '    "groupingColumnInfo" : {}' +
	    '  },' +
	    '  "groupingsDown" : {' +	    
	    '      "groupings" : [ ]' +
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
	    '    "groupingsDown" : [ ],' +
	    '    "groupingsAcross" : [ ],' +
	    '    "reportFormat" : "SUMMARY",' +
	    '    "reportBooleanFilter" : "1 AND 2 AND 3",' +
	    '    "reportFilters" : [ {' +
        '        "value": "201313",' +
        '        "column": "ALM_Rep_Performance_1__c.FLD_SLS_CMPGN_NR__c",' +
        '        "operator": "equals"' +
        '    }, {' +
        '        "value": "123456",' +
        '        "column": "ALM_Rep_Performance_1__c.ACCT_NR__c",' +
        '        "operator": "equals"' +
        '	 }, {' +
        '        "value": "1",' +
        '        "column": "ALM_Rep_Performance_1__c.LDRSHP_TITL_LVL_NR_NUMBER__c",' +
        '        "operator": "equals"' +
        '	 }],' +
	    '    "detailColumns" : [ "ALM_Rep_Performance_1__c.Id", "ALM_Rep_Performance_1__c.Name" ]' +
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
	    '          "label" : "Rep 1"' +
	    '        }, {' +
	    '          "value" : "Rep 1 Description",' +
	    '          "label" : "Rep 1 Description"' +
	    '        } ]' +
	    '      }, {' +
	    '        "dataCells" : [ {' +
	    '          "value" : "a00x0000001ijuhAAA",' +
	    '          "label" : "Rep 2"' +
	    '        }, {' +
	    '          "value" : "Rep 2 Description",' +
	    '          "label" : "Rep 2 Description"' +
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