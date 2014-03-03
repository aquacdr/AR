public with sharing class GenealogyWrapper {
	
	public GenealogyWrapper() {
		this.Generation = '0';
		this.Name = '';
		this.BadgeTitleNumber = '';
		this.BadgeTitle = '';
		this.LLOA_LOA = '';
		this.Sponsor = '';
		this.AllDownlineCountTotal = 0;
		this.RowType = 'Merge';
		this.IsPersonalSale = false;	
		this.NullValue = '';
	}
	
	public String Generation { get; set; }
	public SObject Genealogy { get; set; }
	public Decimal levelRelative {get; set;}
	public Branch_Summary__c BranchSummary { get; set; }
	public String Name { get; set; }
	public String BadgeTitleNumber { get; set; }
	public String BadgeTitle { get; set; }
	public String LLOA_LOA { get; set; }
	public String Sponsor { get; set; }
	public Decimal AllDownlineCountTotal { get; set; }
	public String RowType { get; set; }
	public Boolean IsPersonalSale { get; set; }
	public String NullValue { get; set; }
}