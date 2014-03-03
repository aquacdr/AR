@RestResource(urlMapping='/Account/*')
global with sharing class TempAccountUpdateService {

	@HttpGet
	global static void doGet()
	{
		RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id, Industry FROM Account WHERE Id = :accountId];	
		account.Industry = DateTime.now().format();
		update account;
	}
	
}