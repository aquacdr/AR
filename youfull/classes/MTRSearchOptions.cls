public class MTRSearchOptions {

	//Search Options used with MTSOQLBuilder classes
	
	public abstract class MTRBaseSearch {
		
		protected virtual void Initialize() {
			
			this.AccountNumber = '';
			this.SelectIds = new Set<String>();
			this.SearchForDownline = false;
			this.IsTList = false;
			this.SortBy = '';
			this.IsAscending = true;
			this.ReverseNameSortColumnName = '';
		}
		
		public String AccountNumber { get; set; }
		public Set<String> SelectIds { get; set; }
		public Boolean SearchForDownline { get; set; }
		public Boolean IsTList { get; set; }
		public String SortBy { get; set; }
		public Boolean IsAscending { get; set; }
		public String ReverseNameSortColumnName { get; set; }
		
	}
	
	public class MTRRegularSearch extends MTRBaseSearch {
		
		public MTRRegularSearch() {
			
			this.Initialize();	
		}
		
	}
	
	public class MTRTextSearch extends MTRBaseSearch {
		
		public MTRTextSearch() {
			
			this.Initialize();	
		}
		
		protected override void Initialize() {
			
			this.TSCriteria = '';
			this.TextSearch = '';
			
			super.Initialize();
		}
		
		public String TSCriteria { get; set; }
		public String TextSearch { get; set; }
	}

	public class MTRFilterSearch extends MTRBaseSearch {
		
		public MTRFilterSearch() {
			
			this.Initialize();	
		}
		
		protected override void Initialize() {
			
			this.CampaignId = '';
			this.Who = '';
			this.What = '';
			
			super.Initialize();
		}
		
		public String CampaignId { get; set; }
		public String Who { get; set; }
		public String What { get; set; }
	}
	
}