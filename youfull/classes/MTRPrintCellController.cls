public class MTRPrintCellController {
  
  public GenealogyWrapper InternalGenealogy { get; set; }
  public String InternalRowType { get; set; }
  public MTRPrintColumn InternalPrintColumn { get; set; }
  public Object InternalColumnData { get; set; }
  public Boolean InternalQuoteString { get; set; }
  
  public MTRPrintCellController() {
    
  }
  
  public String getRuleExceptionOutput() {
    
    if(!this.InternalPrintColumn.IsRuleException) {
      return '';  
    }
    
    String strValue = '';

    if(this.InternalPrintColumn.RuleTypeName == 'Name' || this.InternalPrintColumn.RuleTypeName  == 'LLOALOA') {

      strValue = (String)this.InternalColumnData;        
    }
    
    return strValue;
  }
  
  public String getCurrencyOutput() {
    
    Double tempDouble = 0;
    String output = '';
    
    if(this.InternalPrintColumn.ColumnInfo != null && this.InternalPrintColumn.ColumnInfo.Name.length() > 0 && this.InternalColumnData != null) {     
      //output = Double.valueOf((String)this.InternalColumnData).intValue().format();
      output = Double.valueOf((String)this.InternalColumnData).format();
      /* change for Number Truncation by Swarnava start - Defect id : 2350 */
           // if(output.indexOf('-')>-1)
           // output =output.substring(output.indexOf('-')+1);//changed by swarnava.Again reverted back
             // output = output.substring(0, output.indexOf('.'));
             /* change for Number Truncation by Swarnava end */
        
    }
    else {
      output = MakeValueSafe((String)this.InternalColumnData);
    }
        
    return output;
  }
  
  // New Method Addition - truncation - defect id : 2350
  public String getNumberOutput() {
        
        Double tempDouble = 0;
        String output = '';
        
        if(this.InternalPrintColumn.ColumnInfo != null && this.InternalPrintColumn.ColumnInfo.Name.length() > 0 && this.InternalColumnData != null) {
            output = Double.valueOf((String)this.InternalColumnData).intValue().format();
            /* change for Number Truncation by Swarnava start - Defect id : 2350 */
           // if(output.indexOf('-')>-1)
           // output =output.substring(output.indexOf('-')+1);//changed by swarnava.Again reverted back
            //  output = output.substring(0, output.indexOf('.'));
            /* change for Number Truncation by Swarnava end - Defect id : 2350 */
        }
        else {
            output = MakeValueSafe((String)this.InternalColumnData);
        }
                
        return output;
    }// end of method
  
  
  public String getDateOutput() {
    
    String output = '';
    
    if(this.InternalPrintColumn.ColumnInfo != null && this.InternalPrintColumn.ColumnInfo.Name.length() > 0 && this.InternalColumnData != null) {
      output = MTRConfigUtility.ConvertStringToDate((String)this.InternalColumnData).format();
    }
    else {
      output = MakeValueSafe((String)this.InternalColumnData);
    }
    
    return output;
  }
    
  private String MakeValueSafe(Object objValue) {
    
    String strValue = '';

    if(objValue != null) {
      strValue = String.valueOf(objValue);
    }
    else {
      strValue = '';
    }
    
    return strValue;
  }
  
  private Boolean IsNullCheck(SObject obj, List<String> columnNameList, Integer sizeCheck) {
      
      Boolean isNull = false;
      
      for(Integer n = 0; n <= sizeCheck - 1; n++) {
        
        if(obj.get(columnNameList[n]) == null) {
          isNull = true;
          break;
        }
      }
      
      return isNull;
    }
}