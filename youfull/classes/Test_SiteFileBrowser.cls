/***************************************************************************
 Name         : Test_SiteFileBrowser 
 Created By   : Parul Gupta (JDC)
 Description  : Test class for SiteFileBrowser
 Created Date : Oct 29, 2013                
****************************************************************************/
@isTest
private class Test_SiteFileBrowser {

	//---------------------------------------------------------------------------
    // Method Name  : testSiteFileBrowser
    // Description  : Method for Test Coverage of SiteFileBrowser()
    //---------------------------------------------------------------------------
   static testmethod void testSiteFileBrowser() {
		Document doc1 = TestDataHelper.createDocument(true);		
		
		// Instantiate the SFB, and look for the image that we just pushed in...
		SiteFileBrowser sfb = new SiteFileBrowser();
		List<ImageFile> imageList = sfb.files;
		
		for (ImageFile loopImage : imageList) {
			if (loopImage.doc.Name == doc1.Name) {
				System.assert(true);
			}
		}
	}
	
	//---------------------------------------------------------------------------
    // Method Name  : testSiteFileBrowser
    // Description  : Method for Test Coverage of SiteFileBrowser()
    //---------------------------------------------------------------------------
   static testmethod void testSiteFileBrowserWithFolderParameter() {
		Document doc1 = TestDataHelper.createDocument(true);		
		System.currentPageReference().getParameters().put('folder', UserInfo.getUserId());
		
		// Instantiate the SFB, and look for the image that we just pushed in...
		SiteFileBrowser sfb = new SiteFileBrowser();
		List<ImageFile> imageList = sfb.files;
		
		for (ImageFile loopImage : imageList) {
			if (loopImage.doc.Name == doc1.Name) {
				System.assert(true);
			}
		}
	}
}