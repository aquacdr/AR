/***************************************************************************
 Name          : IalmReportService 
 Description   : Interface for alm reporting 
 Created By    : Lalit Bohra
 Created Date  : 04 feb 2014               
****************************************************************************/
public interface IalmReportService { 
    String getAnalyticsReportDescribe(String sfdcServerName, String reportID);
    String getAnalyticsReportResponse(String currentSFDCServerName,String reportID,String filterLogic,List<ReportFilter> filters);
    String executeHttpGetCall(String sfdcServerName, String reportID);
    String executeHttpPostCall(String sfdcServerName, String reportID, String requestBody); 
}