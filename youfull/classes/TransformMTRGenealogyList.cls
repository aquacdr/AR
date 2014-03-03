public class TransformMTRGenealogyList {
  
  public Set<String> ExpandedAccountNums { get; set; }
  public Boolean ExpandAll { get; set; }
  public Boolean IsTList { get; set; }
  public Boolean IncludeExtraInfo { get; set; }

	public List<GenealogyWrapper> GenealogyList { get; set; }
	public Map<String, MTRSOQLBuilder.ColumnInfo> ColumnInfoMap { get; set; }
	public Map<String, MTRSOQLBuilder.ColumnInfo> ColumnInfoMap2 { get; set; }
	public List<String> ColumnOrderList { get; set; }
	public List<String> ColumnOrderList2 { get; set; }
	public Set<String> FullyQualifiedColumnNameSet { get; set; }
	public Set<String> IncludedMergeColumnNameSet { get; set; }
	
	public Boolean PrintReportMode { get; set; }
	public Boolean IncludeRemovedReps { get; set; }
	public Boolean IncludeBranchSummary { get; set; }
	public Branch_Summary__c BranchSummary { get; set; }
	public Boolean SearchForDownline { get; set;}
	
	public class PrintColumnDTO {
			
		public PrintColumnDTO() {
			
			this.RuleTypeColumnInfoMap = new Map<String, MTRSOQLBuilder.ColumnInfo>();
			this.PrintColumnList = new List<MTRPrintColumn>();
		}
		
		public Map<String, MTRSOQLBuilder.ColumnInfo> RuleTypeColumnInfoMap { get; set; }
		public List<MTRPrintColumn> PrintColumnList { get; set; }
	}
	
   //*******
  
  public List<MTRPrintColumn> TeamPrintColumnList { get; private set; }
  public List<MTRPrintColumn> MergePrintColumnList { get; private set; }
  public List<MTRPrintColumn> PersonalPrintColumnList { get; private set; }
  public List<MTRPrintColumn> BranchPrintColumnList { get; private set; }
  public List<String> ReturnColumnOrderList { get; private set; }
  public List<GenealogyWrapper> ReturnGenealogyList  { get; private set; }  
  
  //*******
  
  public TransformMTRGenealogyList() {
    
    this.Initialize(null, null, null, null, null, null);    
  }
  
  public TransformMTRGenealogyList(List<GenealogyWrapper> genealogyList, 
                  Map<String, MTRSOQLBuilder.ColumnInfo> columnInfoMap, Map<String, MTRSOQLBuilder.ColumnInfo> columnInfoMap2,
                  List<String> columnOrderList, List<String> columnOrderList2, Set<String> fullyQualifiedColumnNameSet) {
    this.Initialize(genealogyList, columnInfoMap, columnInfoMap2, columnOrderList, columnOrderList2, fullyQualifiedColumnNameSet);
    //this.Initialize(genealogyList, columnInfoMap, columnInfoMap, columnOrderList, columnOrderList, fullyQualifiedColumnNameSet);
  }
  
  private void Initialize(List<GenealogyWrapper> genealogyList, 
                  Map<String, MTRSOQLBuilder.ColumnInfo> columnInfoMap, Map<String, MTRSOQLBuilder.ColumnInfo> columnInfoMap2,
                  List<String> columnOrderList, List<String> columnOrderList2, Set<String> fullyQualifiedColumnNameSet) {
    
    this.ExpandedAccountNums = new Set<String>();
    this.ExpandAll = false;
    this.IsTList = false;
    this.IncludeExtraInfo = true;
    
    this.GenealogyList = genealogyList;
    this.ColumnInfoMap = columnInfoMap;
    this.ColumnInfoMap2 = columnInfoMap2;
    this.ColumnOrderList = columnOrderList;
    this.ColumnOrderList2 = columnOrderList2;
    this.FullyQualifiedColumnNameSet = fullyQualifiedColumnNameSet;
    this.IncludedMergeColumnNameSet = new Set<String>();
    
    this.PrintReportMode = false;
    this.IncludeRemovedReps = false;
    this.IncludeBranchSummary = false;
    this.BranchSummary = null;
    
    this.TeamPrintColumnList = new List<MTRPrintColumn>();
    this.MergePrintColumnList = new List<MTRPrintColumn>();
    this.PersonalPrintColumnList = new List<MTRPrintColumn>();
    this.BranchPrintColumnList = new List<MTRPrintColumn>();
    this.ReturnColumnOrderList = new List<String>();
    this.ReturnGenealogyList = new List<GenealogyWrapper>();
  }
  
  public void DoTransformation() {
    
    Map<String, MTRSOQLBuilder.ColumnInfo> ruleTypeColumnInfoMap = null;
    PrintColumnDTO printColumnDTO = null;
    
    this.ReturnColumnOrderList = this.ColumnOrderList.clone();
    
    if(this.IncludeExtraInfo) {
      this.IncludeExtraInfo();  
    }
    
    printColumnDTO = this.GeneratePrintColumns('Team');
    this.TeamPrintColumnList = printColumnDTO.PrintColumnList;
    ruleTypeColumnInfoMap = printColumnDTO.RuleTypeColumnInfoMap;
    
    printColumnDTO = this.GeneratePrintColumns('Merge');
    this.MergePrintColumnList = printColumnDTO.PrintColumnList;
    
    printColumnDTO = this.GeneratePrintColumns('Personal');
    this.PersonalPrintColumnList = printColumnDTO.PrintColumnList;
    
    printColumnDTO = this.GeneratePrintColumns('Branch');
    this.BranchPrintColumnList = printColumnDTO.PrintColumnList;
    
    this.ReturnGenealogyList = this.AmendGenealogyWrapper(this.GenealogyList, ruleTypeColumnInfoMap);
  }
  
  private void IncludeExtraInfo() {

    Set<String> columnOrderSet = new Set<String>();
    
    columnOrderSet.addAll(this.ReturnColumnOrderList);
    
    if(!columnOrderSet.contains('Id')) {
      this.ReturnColumnOrderList.add('Id');
    }
    if(!columnOrderSet.contains('ACCT_NR__c')) {
      this.ReturnColumnOrderList.add('ACCT_NR__c');
    }
    if(!columnOrderSet.contains('MRKT_ACCT_KEY__c')) {
      this.ReturnColumnOrderList.add('MRKT_ACCT_KEY__c');
    }
    if(!columnOrderSet.contains('BadgeTitleNumber')) {
      this.ReturnColumnOrderList.add('BadgeTitleNumber');
    }
    if(!columnOrderSet.contains('AllDownlineCountTotal')) {
      this.ReturnColumnOrderList.add('AllDownlineCountTotal');
    }    
    if(!columnOrderSet.contains('ALL_DWNLN_CNT__c')) {
      this.ReturnColumnOrderList.add('ALL_DWNLN_CNT__c');
    }
    if(!columnOrderSet.contains('ALL_DOWNLN_CNT_WITH_REMV__c')) {
      this.ReturnColumnOrderList.add('ALL_DOWNLN_CNT_WITH_REMV__c');
    }
    if(!columnOrderSet.contains('GENRTN_1_TITL_STF_CNT__c') && this.FullyQualifiedColumnNameSet.contains('GENRTN_1_TITL_STF_CNT__c')) {
      this.ReturnColumnOrderList.add('GENRTN_1_TITL_STF_CNT__c');
    }
    if(!columnOrderSet.contains('Genealogy_Level__c')) {
      this.ReturnColumnOrderList.add('Genealogy_Level__c');
    }
    if(!columnOrderSet.contains('UPLN_ACCT_NR__c')) {
      this.ReturnColumnOrderList.add('UPLN_ACCT_NR__c');
    }
    if(!columnOrderSet.contains('IsPersonalSale')) {
      this.ReturnColumnOrderList.add('IsPersonalSale');
    }
    if(!columnOrderSet.contains('Gen_1_Total_Titled_Leader_Candidates__c')) {
		this.ReturnColumnOrderList.add('Gen_1_Total_Titled_Leader_Candidates__c');
	}
  }
  
  private PrintColumnDTO GeneratePrintColumns(String printType) {
    
    List<MTRPrintColumn> printColumnList = new List<MTRPrintColumn>();
    Map<String, MTRSOQLBuilder.ColumnInfo> ruleTypeColumnInfoMap = new Map<String, MTRSOQLBuilder.ColumnInfo>();
    PrintColumnDTO printColumnDTO = new PrintColumnDTO();
    MTRSOQLBuilder.ColumnInfo columnInfo = null;
    MTRPrintColumn printColumn = null;
    String generationLabel = MTRConfigUtility.getJSFixedGenerationLabel();
    String ruleType = '';
    String branchColumnName = '';
    //System.debug('\n ##### printType -- '+printType);
    
    for(String columnOrder: this.ReturnColumnOrderList) {
      //System.debug('\n ##### columnOrder -- '+columnOrder);
      ruleType = '';
      branchColumnName = '';
      
      printColumn = new MTRPrintColumn();
      
      printColumn.ColumnName = columnOrder;
      
      if(printType == 'Team') {
        
        columnInfo = this.ColumnInfoMap.get(columnOrder);
        //System.debug('\n ##### columnInfo for Team -- \n'+columnInfo);
      }
      else if(printType == 'Merge'){
        
        columnInfo = this.ColumnInfoMap2.get(columnOrder); 
        //System.debug('\n ##### columnInfo for Merge -- \n'+columnInfo);
        if(columnInfo == null && this.IncludedMergeColumnNameSet.contains(columnOrder)) {
          columnInfo = columnInfoMap.get(columnOrder);
          //System.debug('\n ##### columnInfo 111 for Merge -- \n'+columnInfo);
        }
      }
      else if(printType == 'Personal') {
        
        columnInfo = this.ColumnInfoMap2.get(columnOrder);
        //System.debug('\n ##### columnInfo Personal -- \n'+columnInfo);
      }
      else if(printType == 'Branch') {
        
        columnInfo = this.ColumnInfoMap.get(columnOrder);
        //System.debug('\n ##### columnInfo Branch -- \n'+columnInfo);
        if(columnInfo != null) {
          
          branchColumnName = this.GetMappedFieldNameForBranchSummary(columnInfo.FullyQualifiedName);  
          //System.debug('\n ##### columnInfo Branch branchColumnName -- \n'+branchColumnName);      
          columnInfo = null;  
        }
      }
      
      if(columnInfo != null) {
        
        ruleType = MTRConfigUtility.GetExceptionRule(columnInfo.FullyQualifiedName);
        printColumn.ColumnInfo = columnInfo;
      }
      else {
      
        printColumn.ColumnInfo = new MTRSOQLBuilder.ColumnInfo();
      }
      
      if(ruleType != null && ruleType.length() > 0) {
        
        if(ruleType == 'Name') {
          printColumn.ColumnValue = 'Name';
          printColumn.IsRuleException = true;
        }
        else if(ruleType == 'BadgeTitle') {
          printColumn.ColumnValue = 'BadgeTitle';
          printColumn.IsRuleException = false;
          ruleType = '';
        }
        else if(ruleType == 'LLOALOA') {
          printColumn.ColumnValue = 'LLOA_LOA';
          printColumn.IsRuleException = true;
        }
        else if(ruleType == 'Sponsor') {
          printColumn.ColumnValue = 'Sponsor';
          printColumn.IsRuleException = false;
          ruleType = '';          
        }
      }
      else if(columnInfo != null && columnInfo.FullyQualifiedName.indexOf(',') == -1) {
        printColumn.ColumnValue = 'Genealogy.' + columnInfo.FullyQualifiedName;
      }
      else if(columnInfo == null) {
      
        if(branchColumnName != null && branchColumnName.length() > 0) {
          printColumn.ColumnValue = this.GetBranchColumnValue(branchColumnName);
        }
        else if((printType == 'Team' || printType == 'Merge') && columnOrder == generationLabel) {
          printColumn.ColumnValue = 'Generation';
        }
        else if(columnOrder == 'Id') {
          printColumn.ColumnValue = 'Genealogy.Id';
        }
        else if(columnOrder == 'ACCT_NR__c') {
          printColumn.ColumnValue = 'Genealogy.ACCT_NR__c';
        }
        else if(columnOrder == 'MRKT_ACCT_KEY__c') {
          printColumn.ColumnValue = 'Genealogy.MRKT_ACCT_KEY__c';
        }
        else if(columnOrder == 'BadgeTitleNumber') {
          printColumn.ColumnValue = 'BadgeTitleNumber';
        }
        else if(columnOrder == 'AllDownlineCountTotal') {
          printColumn.ColumnValue = 'AllDownlineCountTotal';
        }
        else if(printType == 'Team' && columnOrder == 'ALL_DWNLN_CNT__c') {
          printColumn.ColumnValue = 'Genealogy.ALL_DWNLN_CNT__c';
        }
        else if(printType == 'Team' && columnOrder == 'GENRTN_1_TITL_STF_CNT__c') {
          printColumn.ColumnValue = 'Genealogy.GENRTN_1_TITL_STF_CNT__c';
        }
        else if(printType == 'Team' && columnOrder == 'Gen_1_Total_Titled_Leader_Candidates__c') {
			printColumn.ColumnValue = 'Genealogy.Gen_1_Total_Titled_Leader_Candidates__c';
		}
        else if(columnOrder == 'Genealogy_Level__c') {
          printColumn.ColumnValue = 'Genealogy.Genealogy_Level__c';
        }
        else if(columnOrder == 'UPLN_ACCT_NR__c') {
          printColumn.ColumnValue = 'Genealogy.UPLN_ACCT_NR__c';
        }
          else if(columnOrder == 'IsPersonalSale') {
          printColumn.ColumnValue = 'IsPersonalSale';
        }
        else {
          printColumn.ColumnValue = 'NullValue';
        }
      }
      else {
        printColumn.ColumnValue = 'NullValue';
      }

      printColumn.RuleTypeName = ruleType;
      
      if(printColumn.IsRuleException) {
        ruleTypeColumnInfoMap.put(printColumn.RuleTypeName, printColumn.ColumnInfo);
      }
      
      printColumnList.add(printColumn);
    }
    
    printColumnDTO.RuleTypeColumnInfoMap = ruleTypeColumnInfoMap;
    printColumnDTO.PrintColumnList = printColumnList;
    
    return printColumnDTO;
  } 
  
  private List<GenealogyWrapper> AmendGenealogyWrapper(List<GenealogyWrapper> genealogyList, Map<String, MTRSOQLBuilder.ColumnInfo> ruleTypeColumnInfoMap) {
      
      List<GenealogyWrapper> newGenealogyList = new List<GenealogyWrapper>();
      GenealogyWrapper tempGenealogy = null;
      String personalLabel = System.Label.Personal;
      String accountNumber = '';
      Boolean canPrintFirstRow = false;
        System.debug('\n ###### AmendGenealogyWrapper genealogyList.size() '+genealogyList.size());
        
    	for(Integer n = 0; n <= genealogyList.size() - 1; n++) {
    		
    		system.debug('\n #######################' + genealogyList[n]);
    		system.debug('\n #######################' + ruleTypeColumnInfoMap);
    		//system.debug('\n #######################' + ruleTypeColumnInfoMap.get('LLOALOA').FullyQualifiedName);
    		
    		if(ruleTypeColumnInfoMap.containsKey('Name')) {
    			/*System.debug('\n ###### AmendGenealogyWrapper NAME ---1');
    			System.debug('\n ###### AmendGenealogyWrapper Fully Qlfd Name ---1'+ruleTypeColumnInfoMap.get('Name').FullyQualifiedName);
    			System.debug('\n ###### AmendGenealogyWrapper genealogyList[n] ---1'+genealogyList[n]);
    			*/
    			genealogyList[n].Name = MTRConfigUtility.ParseExceptionRuleField('Name', ruleTypeColumnInfoMap.get('Name').FullyQualifiedName, genealogyList[n]);
    			//System.debug('\n ###### AmendGenealogyWrapper NAME ---2 '+genealogyList[n].Name);
    			//System.debug('\n ###### AmendGenealogyWrapper NAME ---2 genealogyList[n] \n'+genealogyList[n]);
    		}
    		
    		if(ruleTypeColumnInfoMap.containsKey('LLOALOA')) {
    			genealogyList[n].LLOA_LOA =  MTRConfigUtility.ParseExceptionRuleField('LLOALOA', ruleTypeColumnInfoMap.get('LLOALOA').FullyQualifiedName, genealogyList[n]);
    		}
    		
    		genealogyList[n].AllDownlineCountTotal = MTRConfigUtility.GetAllDownlineCount(genealogyList[n], this.IncludeRemovedReps);
    		/*System.debug('\n #### genealogyList[n].BadgeTitleNumber >>> '+genealogyList[n].BadgeTitleNumber);
    		System.debug('\n #### genealogyList[n].AllDownlineCountTotal >>> '+genealogyList[n].AllDownlineCountTotal);*/
    		canPrintFirstRow = (!this.PrintReportMode || !(this.PrintReportMode && this.IncludeBranchSummary));
    		System.debug('canPrintFirstRow --> '+canPrintFirstRow);
    		
    		//canPrintFirstRow=true;
    		if(this.IsTList) {
    			
    			if(n == 0 && canPrintFirstRow) {
    				
    				tempGenealogy = genealogyList[n];
    				tempGenealogy.RowType = 'Team';
    				tempGenealogy.IsPersonalSale = false;
    				
    				newGenealogyList.add(tempGenealogy);
    				
    				tempGenealogy = genealogyList[n].clone();
    				tempGenealogy.RowType = 'Personal';
    				tempGenealogy.IsPersonalSale = true;
    				//tempGenealogy.IsPersonalSale = false;
    				
    				if(ruleTypeColumnInfoMap.containsKey('Name')) {
    					tempGenealogy.Name = personalLabel.toUpperCase() + ' -->';
    				}
    				
    				//newGenealogyList.add(tempGenealogy);
    			}
    			else if(n > 0) {
    				
    				tempGenealogy = genealogyList[n];
	    			tempGenealogy.RowType = 'Merge';
	    			tempGenealogy.IsPersonalSale = false;
	    				
	    			newGenealogyList.add(tempGenealogy);
    			}
    		}
    		else {
    			
    			if(
    				((n == 0 && canPrintFirstRow) || n > 0) 
    					&& genealogyList[n].Genealogy.get('DWNLN_ONLY_IND__c') == 'N') {		
    				
    			    tempGenealogy = genealogyList[n];
    				tempGenealogy.RowType = 'Team';
    				tempGenealogy.IsPersonalSale = false;
    				
    				newGenealogyList.add(tempGenealogy);
    				
    				accountNumber = (String)tempGenealogy.Genealogy.get('ACCT_NR__c');
    				
    				if(this.ExpandAll || (this.ExpandedAccountNums != null && this.ExpandedAccountNums.contains(accountNumber))) {
    					System.debug('checking >>> '+SearchForDownline+' '+this.ExpandAll+' '+this.ExpandedAccountNums.contains(accountNumber)+' '+newGenealogyList.size());
	    				tempGenealogy = genealogyList[n].clone();
	    				tempGenealogy.RowType = 'Personal';
	    				//tempGenealogy.IsPersonalSale = true;
	    				tempGenealogy.IsPersonalSale = true;
	    				
	    				if(ruleTypeColumnInfoMap.containsKey('Name')) {
	    					tempGenealogy.Name = personalLabel.toUpperCase() + ' -->';
	    				}
	    				if(SearchForDownline == true || newGenealogyList.size() > 1)
	    					newGenealogyList.add(tempGenealogy);
    				}
    			}
    			else if(genealogyList[n].Genealogy.get('DWNLN_ONLY_IND__c')== 'Y') {
 
               tempGenealogy = genealogyList[n];
            tempGenealogy.RowType = 'Merge';
            tempGenealogy.IsPersonalSale = false;
            
            newGenealogyList.add(tempGenealogy);           
          }
        }
        
        if(n == 0 && this.IncludeBranchSummary) {

     			tempGenealogy = genealogyList[n].clone();
    			tempGenealogy.RowType = 'Branch';
    			tempGenealogy.IsPersonalSale = true;
    			tempGenealogy.BranchSummary = this.BranchSummary;
    				
				//newGenealogyList.add(tempGenealogy);
			}
    	}
    	for(Integer i=0; i< newGenealogyList.size(); i++){
    		System.debug('newGenealogyList --> '+newGenealogyList.size()+' -- '+newGenealogyList[i].RowType);
    	}
    	
    	return newGenealogyList;
    }
  
  private String GetMappedFieldNameForBranchSummary(String fullyQualifiedName) {
    
    String fieldName = '';
    
    if(fullyQualifiedName.indexOf('MRKT_ACCT_KEY__r.FirstName') > -1) {
      fieldName = 'Branch Name';
    }
    else if(fullyQualifiedName.indexOf('BOOK1_GRP_UNIT_SLS_AMT__c') > -1) {
      fieldName = 'Book1 Team Volume';
    }
    else if(fullyQualifiedName.indexOf('BOOK2_GRP_UNIT_SLS_AMT__c') > -1) {
      fieldName = 'Book2 Team Volume';
    }
    else if(fullyQualifiedName.indexOf('GRP_UNIT_SLS_AMT__c') > -1) {
      fieldName = 'Total Team Volume';
    }
    else if(fullyQualifiedName.indexOf('GRP_FAP_CNT__c') > -1) {
      fieldName = 'Team Super Hits';
    }
    else if(fullyQualifiedName.indexOf('GRP_BRCHR_CNT__c') > -1) {
      fieldName = 'Team Brochures';
    }
    else if(fullyQualifiedName.indexOf('GRP_BAL_AMT__c') > -1) {
      fieldName = 'Current Due Amount';
    }
    else if(fullyQualifiedName.indexOf('GRP_PAST_DUE_AMT__c') > -1) {
      fieldName = 'Amount Overdue';
    }
    else if(fullyQualifiedName.indexOf('SPPY_GRP_UNIT_SLS_AMT__c') > -1) {
      fieldName = 'Prior Year Team Volume';
    }
    else if(fullyQualifiedName.indexOf('YTD_GRP_UNIT_SLS_AMT__c') > -1) {
      fieldName = 'YTD Volume';  
    }
    
    return fieldName;
  }
  
  private String GetBranchColumnValue(String columnName) {
    
    String columnValue = '';
    
    if(columnName == 'Branch Name') {
      columnValue = 'BranchSummary.BRNCH_SCTN_CD__c';
    }
    else if(columnName == 'Book1 Team Volume') {
      columnValue = 'BranchSummary.BOOK1_GRP_UNIT_SLS_AMT__c';
    }
    else if(columnName == 'Book2 Team Volume') {
      columnValue = 'BranchSummary.BOOK2_GRP_UNIT_SLS_AMT__c';
    }
    else if(columnName == 'Total Team Volume') {
      columnValue = 'BranchSummary.GRP_UNIT_SLS_AMT__c';
    }
    else if(columnName == 'Team Super Hits') {
      columnValue = 'BranchSummary.GRP_FAP_CNT__c';
    }
    else if(columnName == 'Team Brochures') {
      columnValue = 'BranchSummary.GRP_BRCHR_CNT__c';
    }
    else if(columnName == 'Current Due Amount') {
      columnValue = 'BranchSummary.GRP_BAL_AMT__c';
    }
    else if(columnName == 'Amount Overdue') {
      columnValue = 'BranchSummary.GRP_PAST_DUE_AMT__c';
    }
    else if(columnName == 'Prior Year Team Volume') {
      columnValue = 'BranchSummary.SPPY_GRP_UNIT_SLS_AMT__c';
    }
    else if(columnName == 'YTD Volume') {
      columnValue = 'BranchSummary.YTD_GRP_UNIT_SLS_AMT__c';
    }
    else {
      columnValue = 'NullValue';
    }
  
    return columnValue;
  }
  
}