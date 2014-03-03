public class MarketSellerStsUtils {
	private Map<String,String> sellerSts = new Map<String,String>();

	public void initialize(User currUser){
		sellerSts = new Map<String,String>();

		for(Seller_Status__c sellSts :[	Select	Market__c, 
		 										LCL_TOP_SLR_LVL_LANG_DESC_TXT__c,
		 										LCL_TOP_SLR_LVL_KEY__c, 
		 										LANG_CD__c 
										From 	Seller_Status__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey])
		{
			sellerSts.put(sellSts.LCL_TOP_SLR_LVL_KEY__c,sellSts.LCL_TOP_SLR_LVL_LANG_DESC_TXT__c);
		}
	}		
	public void initialize(User currUser,String stsCd){
		sellerSts = new Map<String,String>();

		for(Seller_Status__c sellSts :[	Select	Market__c, 
		 										LCL_TOP_SLR_LVL_LANG_DESC_TXT__c,
		 										LCL_TOP_SLR_LVL_KEY__c, 
		 										LANG_CD__c 
										From 	Seller_Status__c
										where	Market__r.Market_Id__c=:currUser.MRKT_ID__c
										and		LANG_CD__c=:currUser.LanguageLocaleKey
										and		LCL_TOP_SLR_LVL_KEY__c = :stsCd])
		{
			sellerSts.put(sellSts.LCL_TOP_SLR_LVL_KEY__c,sellSts.LCL_TOP_SLR_LVL_LANG_DESC_TXT__c);
		}
	}		
	
	public String getSellerStatus(String stsCd){
		return this.sellerSts.get(stsCd);
	}
	//subhamay 022012
	public Map<String,String> getSellerStatus(){
		return this.sellerSts;
	}
	//eoc subhamay 022012
	//@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testLeaderTitles(){
		MarketSellerStsUtils ctlr = new MarketSellerStsUtils();
		TestDataHelper testData = new TestDataHelper();
		testData.createSellerStatus();
		User testUsr = testData.createLeaderUser('123456');
		System.runAs(testUsr){
			ctlr.initialize(testUsr);
			System.assert(ctlr.getSellerStatus('SELLSTS1')=='Seller Status 1');
			ctlr.initialize(testUsr,'SELLSTS1');
			System.assert(ctlr.getSellerStatus('SELLSTS1')=='Seller Status 1');
		}
    	
    }*/
	
}