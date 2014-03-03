public class GenerateMTRExcelController {
  
  //*******
  
  public String DownloadStatus { get; set; }
  
  public List<MTRPrintColumn> TeamPrintColumnList { get; set; }
  public List<MTRPrintColumn> MergePrintColumnList { get; set; }
  public List<MTRPrintColumn> PersonalPrintColumnList { get; set; }
  public List<MTRPrintColumn> BranchPrintColumnList { get; set; }
  public List<String> ColumnOrderList { get; set; }
  //public transient List<GenealogyWrapper> GenealogyWrapperList  { get; set; }  
  public List<GenealogyWrapper> GenealogyWrapperList  { get; set; }
  
  //*******

    public String ReportDownloadName { get; set; }
    public String ReportDownloadFileName { get; set; }//added by swarnava for Download file name issue
    public String DownloadInfo { get; set; }
    
    public String ReportHeight {get; set;}
    public String ReportWidth {get; set;}
    public String NoOfColumns {get; set;}
    
    public GenerateMTRExcelController() {
        
        this.DownloadStatus = '';
    }
    
    public string doCharacterEncoding {
		get {
			return EncodingUtil.base64decode('77u/').tostring();
		}
	}
    
    public PageReference DownloadWYSIWYGExcel() {

    Map<String, MyTeamReportCmpController.MiniGenealogy> miniGenealogyMap = new Map<String, MyTeamReportCmpController.MiniGenealogy>();
    List<GenealogyWrapper> genealogyWList = null;
    List<SObject> zeroGenealogyList = null;
    List<SObject> genealogyList = null;
    MTRSOQLBuilder mtrSOQLBuilder = null;
    TransformMTRGenealogyList transformMTRGenealogyList = new TransformMTRGenealogyList();
    MyTeamReportCmpController.DownloadDTO downloadDTO = null;
    MyTeamReportCmpController.MiniGenealogy miniGenealogy = null;
    MTRSearchOptions.MTRFilterSearch filterSearchType = new MTRSearchOptions.MTRFilterSearch();
    MTRSOQLBuilder.CampaignRetrievalDTO campaignRetrievalDTO = null;
    String accountNumber = '';
    
      downloadDTO = (MyTeamReportCmpController.DownloadDTO) JSON.deserialize(this.DownloadInfo, MyTeamReportCmpController.DownloadDTO.class);
    
    mtrSOQLBuilder = new MTRSOQLBuilder(downloadDTO.SFDCMarketId, downloadDTO.ReportType, downloadDTO.profileName, downloadDTO.userTitleLevelNbr, downloadDTO.LangCD);
    
    filterSearchType.CampaignId = downloadDTO.CampaignId;
    filterSearchType.AccountNumber = downloadDTO.ZGenAccountId;
  
    if(downloadDTO.VisibleColumnNames != null &&  downloadDTO.VisibleColumnNames.size() > 0) {
      
      mtrSOQLBuilder.VisibleColumnNameSet.addAll(downloadDTO.VisibleColumnNames);
    }
    
    this.AddToVisibleColumnNameSet(mtrSOQLBuilder.VisibleColumnNameSet);
    
    mtrSOQLBuilder.SetSearchType(filterSearchType);
      
      zeroGenealogyList = mtrSOQLBuilder.GetZeroGenerationRecords();
      
      if(zeroGenealogyList.size() == 0) {
        throw new ArgumentException('GenerateMTRExcelController::DownloadExcel Exception Error=Could not load zero-generation.');
      }
    
    //Important: ALL_DWNLN_CNT__c for zero-generation
    
    if(zeroGenealogyList[0] != null) {
      
       if(zeroGenealogyList[0].get('ALL_DWNLN_CNT__c') == null || (Decimal)zeroGenealogyList[0].get('ALL_DWNLN_CNT__c') <= 0) {
        zeroGenealogyList[0].put('ALL_DWNLN_CNT__c', 1);
      }
      if(zeroGenealogyList[0].get('ALL_DOWNLN_CNT_WITH_REMV__c') == null || (Decimal)zeroGenealogyList[0].get('ALL_DOWNLN_CNT_WITH_REMV__c') <= 0) {
        zeroGenealogyList[0].put('ALL_DOWNLN_CNT_WITH_REMV__c', 1);
      }
    }
    
    transformMTRGenealogyList.ExpandedAccountNums.add(downloadDTO.ZGenAccountId);
    
      if(downloadDTO.MiniGenealogyList != null &&  downloadDTO.MiniGenealogyList.size() > 0) {
      
      for(MyTeamReportCmpController.MiniGenealogy tmpMiniGenealogy: downloadDTO.MiniGenealogyList) {
        
        filterSearchType.SelectIds.add(tmpMiniGenealogy.AccountId);
      
        if(tmpMiniGenealogy.IsExpanded) {
          transformMTRGenealogyList.ExpandedAccountNums.add(tmpMiniGenealogy.AccountId);
        }
        
        miniGenealogyMap.put(tmpMiniGenealogy.AccountId, tmpMiniGenealogy);
      }
    }

    genealogyList = mtrSOQLBuilder.GetRecords();
    
    if(genealogyList.size() == 0) {
      genealogyList.add(zeroGenealogyList[0]);
    }
    else {
      genealogyList.add(0, zeroGenealogyList[0]);
    }
    
    System.debug(LoggingLevel.Error,'======genealogyList=======' + genealogyList);
     System.debug('\n ===== mtrSOQLBuilder.AvonMarketId ======' +  mtrSOQLBuilder.AvonMarketId);
    transformMTRGenealogyList.GenealogyList = MTRConfigUtility.ConvertToWrapperNew(genealogyList, mtrSOQLBuilder.FullyQualifiedColumnNameSet, mtrSOQLBuilder.AvonMarketId, mtrSOQLBuilder.SelectedNameLabel, mtrSOQLBuilder.IsFutureOrPresentCampaign, mtrSOQLBuilder.leaderInfo.genLevel);
    transformMTRGenealogyList.ColumnInfoMap = mtrSOQLBuilder.ColumnInfoMap;
    transformMTRGenealogyList.ColumnInfoMap2 = mtrSOQLBuilder.ColumnInfoMap2;
    transformMTRGenealogyList.ColumnOrderList = mtrSOQLBuilder.ColumnOrderList;
    transformMTRGenealogyList.ColumnOrderList2 = mtrSOQLBuilder.ColumnOrderList2;
    transformMTRGenealogyList.FullyQualifiedColumnNameSet = mtrSOQLBuilder.FullyQualifiedColumnNameSet;

        transformMTRGenealogyList.IncludedMergeColumnNameSet.addAll(mtrSOQLBuilder.PersonalMergeColumnNameSet);
    
        transformMTRGenealogyList.PrintReportMode = true;
        transformMTRGenealogyList.IncludeExtraInfo = false; 
        
        if(downloadDTO.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
            
            if(downloadDTO.BranchCode != null && downloadDTO.BranchCode.length() > 0) {
                
                transformMTRGenealogyList.IncludeBranchSummary = true;
                
                campaignRetrievalDTO = mtrSOQLBuilder.GetCampaignValues();
                transformMTRGenealogyList.BranchSummary = this.GetBranchSummary(this.GetAvonMarketId(downloadDTO.SFDCMarketId), campaignRetrievalDTO.CampaignValues.CurrentCampaign, downloadDTO.ZGenAccountId, downloadDTO.BranchCode);
            }       
        }
        
        transformMTRGenealogyList.DoTransformation();
        
        genealogyWList = transformMTRGenealogyList.ReturnGenealogyList;
        
        for(GenealogyWrapper genealogyW: genealogyWList) {
            
            if(genealogyW.Genealogy.get('ACCT_NR__c') != null) {
                
                accountNumber = (String)genealogyW.Genealogy.get('ACCT_NR__c');
                
                miniGenealogy = miniGenealogyMap.get(accountNumber);
                
                if(miniGenealogy != null && genealogyW.RowType != 'Personal') {
                    genealogyW.Generation = miniGenealogy.Generation;
                }
                else if(accountNumber != downloadDTO.ZGenAccountId || genealogyW.RowType == 'Personal'){
                    genealogyW.Generation = '';
                }
            }
        }
        
        this.TeamPrintColumnList = transformMTRGenealogyList.TeamPrintColumnList;
        this.MergePrintColumnList = transformMTRGenealogyList.MergePrintColumnList;
        this.PersonalPrintColumnList = transformMTRGenealogyList.PersonalPrintColumnList;
        this.BranchPrintColumnList = transformMTRGenealogyList.BranchPrintColumnList;
        this.ColumnOrderList = transformMTRGenealogyList.ReturnColumnOrderList;
        this.GenealogyWrapperList = genealogyWList; 
        
        System.debug(LoggingLevel.Error,'=====genealogyWList======' + genealogyWList);
        System.debug(LoggingLevel.Error,'=====downloadDTO.ReportDownloadName======' + downloadDTO.ReportDownloadName);
        this.ReportDownloadName = downloadDTO.ReportDownloadName;
        System.debug(LoggingLevel.Error,'===== this.ReportDownloadName======' +  this.ReportDownloadName);
        
       
       
        ReportDownloadFileName=this.ReportDownloadName.replace(' ','');//added by swarnava for Download file name issue
        this.DownloadStatus = 'Ready';
        
        Report_Print__c reportPrint = [Select Fixed_columns__c, Height__c, Width__c
                                       From Report_Print__c
                                       Where Name=:mtrSOQLBuilder.AvonMarketId];
                                       
        if(reportPrint <> null)
        {
            //added by amartya
            System.debug('@@@@@@@@@@@@@ reportPrint ='+reportPrint );
            //added by amartya
            NoOfColumns = String.valueOf(reportPrint.Fixed_columns__c);
            ReportHeight = String.valueOf(reportPrint.Height__c);
            ReportWidth = String.valueOf(reportPrint.Width__c);
        }

        return null;
    }
    
    /*public PageReference DownloadAllExcel()  {
        
        List<GenealogyWrapper> genealogyWList = null;
        List<SObject> genealogyList = null;
        MTRSOQLBuilder mtrSOQLBuilder = null;
        GenealogyDownload genealogyDownload = null;
        TransformMTRGenealogyList transformMTRGenealogyList = new TransformMTRGenealogyList();
        MyTeamReportCmpController.DownloadDTO downloadDTO = null;
        MTRSOQLBuilder.CampaignRetrievalDTO campaignRetrievalDTO = null;
        String accountNumber = '';
        String generationValue = '';
        
        downloadDTO = (MyTeamReportCmpController.DownloadDTO)JSON.deserialize(this.DownloadInfo, MyTeamReportCmpController.DownloadDTO.class);
        
        mtrSOQLBuilder = new MTRSOQLBuilder(downloadDTO.SFDCMarketId, downloadDTO.ReportType, downloadDTO.profileName, downloadDTO.userTitleLevelNbr, downloadDTO.LangCD);
        
        if(downloadDTO.VisibleColumnNames != null &&  downloadDTO.VisibleColumnNames.size() > 0) {
            
            mtrSOQLBuilder.VisibleColumnNameSet.addAll(downloadDTO.VisibleColumnNames);
        }
        
        this.AddToVisibleColumnNameSet(mtrSOQLBuilder.VisibleColumnNameSet);
        
        genealogyDownload = new GenealogyDownload(downloadDTO.CampaignId, downloadDTO.ZGenAccountId, mtrSOQLBuilder);
        
        genealogyList = genealogyDownload.download();   
    
        transformMTRGenealogyList.GenealogyList = MTRConfigUtility.ConvertToWrapperNew(genealogyList, mtrSOQLBuilder.FullyQualifiedColumnNameSet, mtrSOQLBuilder.AvonMarketId, mtrSOQLBuilder.SelectedNameLabel, mtrSOQLBuilder.IsFutureOrPresentCampaign, mtrSOQLBuilder.leaderInfo.genLevel);
        transformMTRGenealogyList.ColumnInfoMap = mtrSOQLBuilder.ColumnInfoMap;
        transformMTRGenealogyList.ColumnInfoMap2 = mtrSOQLBuilder.ColumnInfoMap2;
        transformMTRGenealogyList.ColumnOrderList = mtrSOQLBuilder.ColumnOrderList;
        transformMTRGenealogyList.ColumnOrderList2 = mtrSOQLBuilder.ColumnOrderList2;
        transformMTRGenealogyList.FullyQualifiedColumnNameSet = mtrSOQLBuilder.FullyQualifiedColumnNameSet;
        
        transformMTRGenealogyList.IncludedMergeColumnNameSet.addAll(mtrSOQLBuilder.PersonalMergeColumnNameSet);
    
        transformMTRGenealogyList.PrintReportMode = true;
        transformMTRGenealogyList.IncludeExtraInfo = false; 
        
        if(downloadDTO.ReportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
            
            if(downloadDTO.BranchCode != null && downloadDTO.BranchCode.length() > 0) {
                
                transformMTRGenealogyList.IncludeBranchSummary = true;
                
                campaignRetrievalDTO = mtrSOQLBuilder.GetCampaignValues();
                transformMTRGenealogyList.BranchSummary = this.GetBranchSummary(this.GetAvonMarketId(downloadDTO.SFDCMarketId), campaignRetrievalDTO.CampaignValues.CurrentCampaign, downloadDTO.ZGenAccountId, downloadDTO.BranchCode);
            }
        }
        
        transformMTRGenealogyList.ExpandAll = true;
        
        transformMTRGenealogyList.DoTransformation();
        
        genealogyWList = transformMTRGenealogyList.ReturnGenealogyList;

    for(GenealogyWrapper genealogyW: genealogyWList) {
      
      if(genealogyW.Genealogy.get('ACCT_NR__c') != null) {
        
        accountNumber = (String)genealogyW.Genealogy.get('ACCT_NR__c');
        generationValue = genealogyDownload.GenerationMap.get(accountNumber);
        
        if(generationValue != null && genealogyW.RowType != 'Personal') {
          genealogyW.Generation = generationValue;
        }
        else if(accountNumber != downloadDTO.ZGenAccountId || genealogyW.RowType == 'Personal'){
          genealogyW.Generation = '';
        }
      }
    }

        this.TeamPrintColumnList = transformMTRGenealogyList.TeamPrintColumnList;
        this.MergePrintColumnList = transformMTRGenealogyList.MergePrintColumnList;
        this.PersonalPrintColumnList = transformMTRGenealogyList.PersonalPrintColumnList;
        this.BranchPrintColumnList = transformMTRGenealogyList.BranchPrintColumnList;
        this.ColumnOrderList = transformMTRGenealogyList.ReturnColumnOrderList;
        this.GenealogyWrapperList = genealogyWList; 
        
        this.ReportDownloadName = downloadDTO.ReportDownloadName;
        ReportDownloadFileName=this.ReportDownloadName.replace(' ','');//added by swarnava for Download file name issue
        
        this.DownloadStatus = 'Ready';
        
        return null;
    }*/
    
    public PageReference CompleteExcelDownload() {
        system.debug('::::::::: Complete Excel Download ::::::::::');
        if(ApexPages.currentPage().getParameters().get('print')!='1') //changed by swarnava for Download look and feel
        return Page.DownloadMTRExcel;
        else
        return Page.PrintMTRExcel;
    }
    
    public String GetAvonMarketId(Id marketId) {
        
        Market__c market = [SELECT Id, Market_Id__c FROM Market__c
                                    WHERE Id = :marketId];
        
        return market.Market_Id__c;
    }
    
    public Branch_Summary__c GetBranchSummary(String marketId, Integer campaignId, String accountNumber, String branchCode) {
    
        List<Branch_Summary__c> branchSummaryList = null;
        Branch_Summary__c branchSummary = null; 
        String branchSummaryKey = MTRConfigUtility.CreateBranchSummaryKey(marketId, campaignId, accountNumber, branchCode);

    branchSummaryList = [SELECT Id, BRNCH_SCTN_CD__c, BOOK1_GRP_UNIT_SLS_AMT__c, BOOK2_GRP_UNIT_SLS_AMT__c, GRP_UNIT_SLS_AMT__c, GRP_FAP_CNT__c, GRP_BRCHR_CNT__c, GRP_BAL_AMT__c, GRP_PAST_DUE_AMT__c, SPPY_GRP_UNIT_SLS_AMT__c, YTD_GRP_UNIT_SLS_AMT__c FROM Branch_Summary__c
                WHERE Branch_Summary_Key__c = :branchSummaryKey];
    
    if(branchSummaryList.size() > 0) {
      branchSummary = branchSummaryList[0];
    }
    
    return branchSummary;
  }
  
  public void AddToVisibleColumnNameSet(Set<String> visibleColumnNameSet) {
    
    String tmpColumnName = '';
    
    tmpColumnName = MTRConfigUtility.getJSFixedFirstLastNameLabel();
    
    if(!visibleColumnNameSet.contains(tmpColumnName)) {
      visibleColumnNameSet.add(tmpColumnName);
    }
    
    tmpColumnName = MTRConfigUtility.getJSFixedLastFirstNameLabel();
    
    if(!visibleColumnNameSet.contains(tmpColumnName)) {
      visibleColumnNameSet.add(tmpColumnName);
    }
    
    tmpColumnName = MTRConfigUtility.EscapeBadJavascriptChars(System.Label.Badge_Title_Short);
    
    if(!visibleColumnNameSet.contains(tmpColumnName)) {
      visibleColumnNameSet.add(tmpColumnName);
    }
    
    tmpColumnName = MTRConfigUtility.EscapeBadJavascriptChars(System.Label.Paid_Title);
    
    if(!visibleColumnNameSet.contains(tmpColumnName)) {
      visibleColumnNameSet.add(tmpColumnName);
    }
        
  }
}