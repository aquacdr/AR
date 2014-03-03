public class ActionItem {

	public String aicategory {get; set;}
	public Integer recCount1 {get; set;}
	public Boolean isDisplayed {get; set;}
	public Boolean isDefault {get; set;}
	public String reportId {get; set;}
	public String reportType {get; set;}
	public String marketCd {get; set;}
	public String Priority {get; set;}
	public My_Business_Row__c counts {get; private set;}
	public Boolean oddRow {get; set;}
	public String reportUrl {get; set;}
	public String cmpTxt {get;set;}
		
	public ActionItem (String aicategory,Boolean display,Boolean dflt,String rptId,String rptType,String mktCd){
		/*this.aicategory = aicategory;
		this.isDisplayed = display;
		this.isDefault = dflt;
		this.reportId = rptId;
		this.reportType = rptType;
		this.marketCd = mktCd;
		counts = new My_Business_Row__c();
		this.counts.CC_Cnt__c=0;
		this.counts.CC_Amt__c=0;*/
	}
	
	public ActionItem (String aicategory,Boolean display,Boolean dflt,String rptId,String rptType,String mktCd,String rptUrl){
		this.aicategory = aicategory;
		this.isDisplayed = display;
		this.isDefault = dflt;
		this.reportId = rptId;
		this.reportType = rptType;
		this.marketCd = mktCd;
		counts = new My_Business_Row__c();
		this.counts.CC_Cnt__c=0;
		this.counts.CC_Amt__c=0;
		this.reportUrl=rptUrl;
	}
	
	public ActionItem (String aicategory,Boolean display,Boolean dflt,String rptId,String rptType,String mktCd,String rptUrl,String cmpTxt){
		this.aicategory = aicategory;
		this.isDisplayed = display;
		this.isDefault = dflt;
		this.reportId = rptId;
		this.reportType = rptType;
		this.marketCd = mktCd;
		counts = new My_Business_Row__c();
		this.counts.CC_Cnt__c=0;
		this.counts.CC_Amt__c=0;
		this.reportUrl=rptUrl;
		this.cmpTxt=cmpTxt;
	}
	
	public void setRecCountAmt(Decimal cnt){
		this.counts.CC_Amt__c = cnt;
	}
	public void setRecCountCnt(Decimal cnt){
		this.counts.CC_Cnt__c = cnt;
	}
	
	public void incrementCount(){
		//Assumes only "Number" type Action Items will require increment
		/*if(this.counts.CC_Cnt__c==null){
			this.counts.CC_Cnt__c=0;
		}*/
		this.counts.CC_Cnt__c++;
	}
	//@S-144891 : Commented by Blaine Rothrock on Nov 23
	/*public static testmethod void testActionItems(){
		ActionItem item = new ActionItem('cat1',false,true,'1','Order_Not_Submitted','12334');
		//System.assert(item.recCount1==0);
		
		// Blocked by Raktim
		//System.assert(item.counts.CC_Cnt__c==0);
		
		// Added by Raktim
		System.assert(item.counts.CC_Cnt__c==null);
		
		// Blocked by Raktim
		//System.assert(item.counts.CC_Amt__c==0);
		
		// Added by Raktim
		System.assert(item.counts.CC_Amt__c==null);
		
		// This section has been blocked - Raktim
		/*item.setRecCountAmt(10.12);	
		System.assert(item.counts.CC_Amt__c==10.12);	
		item.setRecCountCnt(10.0);	
		System.assert(item.counts.CC_Cnt__c==10);
		// Blocked section End - Raktim
		
		ActionItem newItem = new ActionItem('cat1',false,true,'1','Order_Not_Submitted','12334','/apex/DemoPage');
		//System.assert(item.recCount1==0);
		System.assert(newItem.counts.CC_Cnt__c==0);
		System.assert(newItem.counts.CC_Amt__c==0);
		newItem.setRecCountAmt(10.12);	
		System.assert(newItem.counts.CC_Amt__c==10.12);	
		newItem.setRecCountCnt(10.0);	
		System.assert(newItem.counts.CC_Cnt__c==10);
		ActionItem newItem2 = new ActionItem('cat1',false,true,'1','Order_Not_Submitted','12334','/apex/DemoPage','current');
		//System.assert(item.recCount1==0);
		System.assert(newItem2.counts.CC_Cnt__c==0);
		System.assert(newItem2.counts.CC_Amt__c==0);
		newItem2.setRecCountAmt(10.12);	
		System.assert(newItem2.counts.CC_Amt__c==10.12);	
		newItem2.setRecCountCnt(10.0);	
		System.assert(newItem2.counts.CC_Cnt__c==10);
	} */
}