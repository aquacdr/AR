/***************************************************************************
 Name         : Test_ImageFile 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for ImageFile
 Created Date : Oct 25, 2013                
****************************************************************************/
@isTest
private class Test_ImageFile {

	//---------------------------------------------------------------------------
    // Method Name  : testImageFile
    // Description  : Method for Test Coverage of Class : ImageFile
    //---------------------------------------------------------------------------
    static testMethod void testImageFile() {
        
        // Test the getters and setters.
		Document doc = new Document();
		String url = 'url';
		
		ImageFile iFF = new ImageFile(doc, url);
		Document doc2 = iFF.doc;
		System.assert(doc2 == doc);

		String url2 = iFF.url;
		System.assert(url2 == url);
    }
}