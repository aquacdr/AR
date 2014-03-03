/***************************************************************************
 Name         : Test_DocumentUtil
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for DocumentUtil
 Created Date : Oct. 30, 2013                
****************************************************************************/

@isTest
private class Test_DocumentUtil {

	//----------------------------------------------------------------------------
    // Method Name  : testDocumentUtil
    // Description  : Method for Test Coverage of Class : DocumentUtil
    //----------------------------------------------------------------------------  
    public static testmethod void testDocumentUtil() {
    	DocumentUtil docUtil = new DocumentUtil();
    	docUtil = DocumentUtil.getInstance();
    	System.assertEquals(docUtil.doc != null, true);
    	docUtil.getURL();
    }
}