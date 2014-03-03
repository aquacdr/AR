/***************************************************************************
 Name          : Test_MTRPrintCellController 
 Created By    : Parul Gupta (JDC)
 Description   : Test class for MTRPrintCellController
 Created  Date : Nov 1, 2013                
****************************************************************************/
@isTest
private class Test_MTRPrintCellController {

	 //---------------------------------------------------------------------------
    // Method Name  : testMTRPrintCellController
    // Description  : Method for Test Coverage for MTRPrintCellController
    //---------------------------------------------------------------------------
    static testMethod void testMTRPrintCellController() {
       
        // Create ColumnInfo
        MTRSOQLBuilder.ColumnInfo colInfo = new MTRSOQLBuilder.ColumnInfo('Name', 
        						'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', 
        									'Text', 'Always Displayed', 'Test Grp', 
         									'MRKT_ACCT_KEY__r.FirstName, MRKT_ACCT_KEY__r.LastName', 
        									'Always Displayed', 102.0, true);
        
        String str = '45';
        
        // Create MTRPrintColumn        
        MTRPrintColumn printColumn = new MTRPrintColumn();
        
        // Create Controller object   
        MTRPrintCellController controller =  new MTRPrintCellController();
        
        // Set initial variables and assert for functionality
        controller.InternalPrintColumn = printColumn;
        controller.InternalColumnData = str;   
        System.assertEquals('', controller.getRuleExceptionOutput());  
        System.assertEquals('45', controller.getCurrencyOutput());          
        System.assertEquals('45', controller.getNumberOutput());  
        System.assertEquals('45', controller.getDateOutput());  
      
        controller.InternalColumnData = null;
        System.assertEquals('', controller.getDateOutput());  
         
        printColumn.IsRuleException = true;
        printColumn.RuleTypeName = 'Name';
        printColumn.ColumnInfo = colInfo;
        
        controller =  new MTRPrintCellController();
        controller.InternalPrintColumn = printColumn;
        controller.InternalColumnData = str;
        controller.getRuleExceptionOutput();
        controller.getCurrencyOutput();
        controller.getNumberOutput();
        str = '05 Mar 1 2 3 1984';
        controller.InternalColumnData = str;
        System.assertEquals('3/1/1984', controller.getDateOutput());       
    }
}