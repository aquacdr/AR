public class MTRPrintColumn {

	public MTRPrintColumn() {
		
		this.ColumnName = '';
		this.ColumnInfo = null;
		this.ColumnValue = '';
		this.RuleTypeName = '';
		this.IsRuleException = false;
	}
	
	public String ColumnName { get; set; }
	public MTRSOQLBuilder.ColumnInfo ColumnInfo { get; set; }
	public String ColumnValue { get; set; }
	public String RuleTypeName { get; set; }
	public Boolean IsRuleException { get; set; }
}