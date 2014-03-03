/***************************************************************************
 Name         : Test_FileUpload
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for FileUpload
 Created Date : Oct. 25, 2013                
****************************************************************************/

@isTest
private class Test_FileUpload {

	//----------------------------------------------------------------------------
    // Method Name  : testFileUpload
    // Description  : Method for Test Coverage of Class : FileUpload
    //----------------------------------------------------------------------------  
    public static testmethod void testFileUpload() {
    	FileUpload fu = new FileUpload();
		
		Test.startTest();
		fu.doUpload();
		
		fu.document.Name = 'test1';
		fu.document.Body = Blob.valueOf('test1');
		fu.doUpload();
		
		List <Document> docList = [Select Id, Name From Document Where Name = 'test1'];
		System.assertEquals(docList.isEmpty(), false);
		Test.stopTest();
    }
}