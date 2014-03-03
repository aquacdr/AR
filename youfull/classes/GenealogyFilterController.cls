public class GenealogyFilterController {
    
    //Campaign Filter Only
    public Boolean InternalCampaignFilterOnly { get; set; }

    //Account in which the Report is based on
    public String AccountNum { get; set; }
    
    //Report Config criteria used to get Filter Lists
    public Id ReportConfigId { get; set; }
    
    //SFDC Market Id criteria used to get Filter Lists
    public Id SFDC_MarketId { get; set; }
    
    //LangCD criteria used to get Filter Lists
    public String LangCD { get; set; }
    
    //Number of Historical Campaign
    public Integer NumberOfHistoricalCampaigns { get; set; }
    
    //Future Campaign
    public Integer FutureCampaign { get; set; }
    
    //Current Campaign
    public Integer CurrentCampaign { get; set; }
    
    //CampaignId to select in dropdown
    public String InternalSelectedCampaignId { get; set; }
    
    //CampaignNr selected in the dropdown
    public String selectedCmpgnNumber {get;set;}
    
    //Who to select in dropdown
    public String InternalWho { get; set; }
    
    //What to select in dropdown
    public String InternalWhat { get; set; }
    
    //JavaScript method that is launched when Filter is submitted
    public String OnSubmit { get; set; }
    
    //Get options available for Campaign Filter selection
    public List<SelectOption> CampaignList { get; private set; }
    
    //Get options available for Who selection
    public List<SelectOption> WhoList { get; private set; }
    
    //Get options available for What selection
    public List<SelectOption> WhatList { get; private set; }
    
    //JSON result from filter refresh
    public transient String JSONResults { get; set; }
    
    //Internal Future Campaign
    private String InternalFutureCampaign { get; set; }
    
    //Internal Current Campaign
    private String InternalCurrentCampaign { get; set; }
    
    //Addition of new variables on 9th Apr, 2013 by Raktim
    //OmnitureSuit Name
    public String Omniture_Suite_Name { get; set; }
     
    //Report Type Name
    public String ReportType { get; set; }
    //End of Addition
    
    public boolean isMailPlan{get;set;} //added by swarnava
    
    //Substitute class for SelectOption to support JSON
    private class JSONSelectOption {
        
        public JSONSelectOption() {
            
        }
        
        public String Value { get; set; }
        public String Label { get; set; }
    }
    
    //Data Transport Object used to transfer Filter data from server-side to client-side
    private class FilterDTO {
        
        public FilterDTO() {
            
        }
        
        public List<JSONSelectOption> WhoList { get; set; }
        public List<JSONSelectOption> WhatList { get; set; }    
    }
    
    public GenealogyFilterController() {
        
    }
    
    public String getLoadController() {
    
        if(this.InternalCampaignFilterOnly == null) {
            this.InternalCampaignFilterOnly = false;
        }
        
        if(this.InternalSelectedCampaignId == null || this.InternalSelectedCampaignId.length() == 0) {
            this.InternalSelectedCampaignId = String.valueOf(this.CurrentCampaign);
        }
        
        if(this.InternalWho == null || this.InternalWho.length() == 0) {
            this.InternalWho = 'All_Generations';// Change by amartya - old G1_Representatives
        }
        
        if(this.InternalWhat == null || this.InternalWhat.length() == 0) {
            this.InternalWhat = 'all';
        }
        
        this.CampaignList = this.GetCampaignFilters(true);
        this.WhoList = this.GetReportFilters('Who');
        this.WhatList = this.GetReportFilters('What');
        getRefreshcamnparam();
        return '';
    }
    
    private List<SelectOption> RemoveSelectOptionsByLabel(List<SelectOption> selectOptionList, Set<String> labelNameSet) {
        
        List<SelectOption> newSelectOptionList = new List<SelectOption>();
        
        for(Integer n = 0; n <= selectOptionList.size() - 1; n++) {
            
            if(!labelNameSet.contains(selectOptionList[n].getLabel())) {
                newSelectOptionList.add(selectOptionList[n]);
            }
        }
        
        return newSelectOptionList;
    }
    
    //Gets Campaign Filters
    public List<SelectOption> GetCampaignFilters(Boolean fixSelectedCampaignId) {
    
        Market__c market;
        boolean isSelling=false;
        if(isMailPlan){  //MailPlan Campaign Number Change by Swarnava:Start
         market = [SELECT Id, Market_Id__c, NEXT_1_CMPGN_NR__c,Mail_Plan_Enabled__c, CMPGN_NR__c,PREV_1_CMPGN_NR__c, Omniture_Suite_Name__c FROM Market__c
                    WHERE Id=:this.SFDC_MarketId LIMIT 1];
        
        this.FutureCampaign=Integer.valueOf(market.NEXT_1_CMPGN_NR__c);       
        }
        List<SelectOption> selectOptionList = new List<SelectOption>();
       
        
        Integer totalHistoricalCampaigns = this.NumberOfHistoricalCampaigns;
        
        if(this.FutureCampaign != null && this.FutureCampaign > 0) {
            totalHistoricalCampaigns++;
        }
        
        if(this.CurrentCampaign != null && this.CurrentCampaign > 0) {
            totalHistoricalCampaigns++;
        }       
        System.debug('\n ####### totalHistoricalCampaigns '+totalHistoricalCampaigns);
        System.debug('\n ####### this.FutureCampaign '+this.FutureCampaign);
        System.debug('\n ####### this.CurrentCampaign '+this.CurrentCampaign);
        List<Calendar__c> calendarList = [SELECT PRIOR_CMPGN_NR__c, CMPGN_NR__c, CMPGN_NR_TXT__c, CMPGN_NR_FRMTD__c From Calendar__c
                                        WHERE Market__c = :this.SFDC_MarketId
                                        AND (CMPGN_NR__c IN (:this.FutureCampaign, :this.CurrentCampaign) 
                                                OR CMPGN_NR__c < :this.CurrentCampaign) 
                                        ORDER BY CMPGN_NR__c DESC
                                        LIMIT :totalHistoricalCampaigns];
        
        //List<SelectOption> selectOptionList = new List<SelectOption>();
        String campaignValue = '';
        String campaignText = '';
        
        for(Calendar__c calendar: calendarList) {
            
            campaignValue = 'CMPGN' + ((calendar.PRIOR_CMPGN_NR__c != null) ? String.valueOf(calendar.PRIOR_CMPGN_NR__c) : '0')  + '_' + ((calendar.CMPGN_NR__c != null) ? String.valueOf(calendar.CMPGN_NR__c) : '0');
            
            if(fixSelectedCampaignId && this.InternalSelectedCampaignId == calendar.CMPGN_NR_TXT__c) {
                this.InternalSelectedCampaignId = campaignValue;
            }
            
            if(calendar.CMPGN_NR__c == this.FutureCampaign) {
                this.InternalFutureCampaign = campaignValue;
                if(isMailPlan){
                  campaignText = String.valueOf(calendar.CMPGN_NR__c);
                  selectOptionList.add(new SelectOption(campaignValue, campaignText));
                }
            
              }
            else if(calendar.CMPGN_NR__c == this.CurrentCampaign) { 
                this.InternalCurrentCampaign = campaignValue;
                    
            campaignText = String.valueOf(calendar.CMPGN_NR__c);//.substring(0,4)+'_'+System.Label.Current_Camp;//changed by amartya for #2401
            selectOptionList.add(new SelectOption(campaignValue, campaignText));           
            } 
            else if(calendar.CMPGN_NR__c ==(!isMailPlan? getPriorCampaign(this.CurrentCampaign):Integer.valueOf(market.PREV_1_CMPGN_NR__c))) {
            campaignText = String.valueOf(calendar.CMPGN_NR__c);//.substring(0,4)+'_'+System.Label.Prior_Camp;//changed by amartya for #2401
            selectOptionList.add(new SelectOption(campaignValue, campaignText));
            }//campaign Text display changed by swarnava - Defect ID : 2401     
            
        }    //MailPlan Campaign Number Change by Swarnava:End
        
        return selectOptionList;
    }
    
    //Gets Report Filters based on specified Filter Type, along with other parameters
    public List<SelectOption> GetReportFilters(String filterType) {
        if(this.InternalCampaignFilterOnly) {
            return new List<SelectOption>();
        }
        
        List<Report_Filter__c> reportFilterList = [SELECT Id, Name, Filter_Key__c, Report_Config__r.Report_Type__c FROM Report_Filter__c
                                                        WHERE Report_Config__c = :this.ReportConfigId
                                                        AND Filter_Type__c = :filterType
                                                        ORDER BY Filter_Key__c];
                                                        
        Map<String, String> reportFilterNameKeyMap = new Map<String, String>();
        List<Leader_Title__c> leaderTitleList = null;
        List<SelectOption> selectOptionList = new List<SelectOption>();
        List<String> reportFilterNameList = new List<String>();
        Set<String> labelNameSet = new Set<String>();
        MarketLeaderTitleUtils marketLeaderTitleUtils = null;
        String filterValue = '';
        String filterLabel = '';
        Integer foundIndex = -1;
        Boolean isExecutive = MTRConfigUtility.HasExecutiveBadgeTitle(this.SFDC_MarketId, this.AccountNum);
        Boolean isPresentOrFutureCampaign = (this.InternalSelectedCampaignId == this.InternalFutureCampaign || this.InternalSelectedCampaignId == this.InternalCurrentCampaign); 
        Boolean appendToEnd = false;
        
        String reportType = reportFilterList[0].Report_Config__r.Report_Type__c;
        System.debug('\n ######### reportType -- '+reportType);
        
        for(Report_Filter__c reportFilter: reportFilterList) {
            
            filterLabel = ALMReportLabels.getReportFilterLabel(reportFilter.Filter_Key__c);
            
            if(filterLabel == null) {
                throw new ArgumentException('GenealogyFilterController::GetReportFilters Exception Error=Could not find Label: ' + reportFilter.Filter_Key__c + '.');
            }
            
            reportFilterNameList.add(filterLabel);
            reportFilterNameKeyMap.put(filterLabel, reportFilter.Filter_Key__c);
        }
        
        reportFilterNameList.sort();
        
        for(String filterName: reportFilterNameList) {
        	System.debug('\n ###### filterName ###  '+filterName+', reportFilterNameKeyMap.get(filterName) '+reportFilterNameKeyMap.get(filterName));
            selectOptionList.add(new SelectOption(reportFilterNameKeyMap.get(filterName), filterName));
        }
        System.debug('\n ###### selectOptionList 1 ### \n '+selectOptionList);
        System.debug('\n ###### filterType -- '+filterType);
        System.debug('\n ###### isPresentOrFutureCampaign -- '+isPresentOrFutureCampaign);
        if(filterType == 'Who') {
            marketLeaderTitleUtils = new MarketLeaderTitleUtils();
            
            leaderTitleList = marketLeaderTitleUtils.initializeAndRestListSortedByTitleNumber(this.SFDC_MarketId, this.LangCD);
            System.debug('\n ###### GOT IT leaderTitleList --- \n'+leaderTitleList);
            if(isPresentOrFutureCampaign) {
                /*foundIndex = GetItemIndex(selectOptionList, System.Label.All_Badge_Titles);
                foundIndex++;
    
                if(foundIndex >= (selectOptionList.size() - 1)) {
                    appendToEnd = true;
                }*/
                
                if(reportType == ALMConstants.REPORT_TYPE_TITL_ADV_REPCONFIG){
                 System.debug('\n ###### GOT IT ---');
                  Map<String, String> mLeaderTitle = new Map<String, String>();
                  List<String>  lstLdrTitls = new List<String>();
                  for(Leader_Title__c leaderTitle: leaderTitleList) {
                    System.debug('\n ###### GOT IT leaderTitle.LDRSHP_TITL_LVL_NR_NUMBER__c  --- '+leaderTitle.LDRSHP_TITL_LVL_NR_NUMBER__c);
                    if(leaderTitle.LDRSHP_TITL_LVL_NR_NUMBER__c >= 1) {
                          filterValue = 'TITL' + leaderTitle.LDRSHP_TITL_LVL_NR__c;
                          filterLabel = System.Label.Badge_Title_of + ' ' + leaderTitle.LCL_LDRSHP_TITL_CD__c;
                          //System.debug('\n @@@@@ GetReportFilters filterValue --> '+filterValue);
                          //System.debug('\n @@@@@ GetReportFilters filterLabel --> '+filterLabel);
                          
                          /*if(appendToEnd) {
                              selectOptionList.add(new SelectOption(filterValue, filterLabel));
                          }
                          else {
                              selectOptionList.add(foundIndex, new SelectOption(filterValue, filterLabel));
                              foundIndex++;
                          }*/
                          //System.debug('\n ###### GOT IT filterLabel  --- '+filterLabel+', filterValue '+filterValue);
                          if(filterLabel.contains('SEL'))
                          {
                            if(mLeaderTitle.containsKey(System.Label.Badge_Title_of+' SEL+'))
                            {
                              System.debug('\n ###### GOT IT SEL');
                              String filter = mLeaderTitle.get(System.Label.Badge_Title_of+' SEL+')+', \''+leaderTitle.LDRSHP_TITL_LVL_NR__c+'\'';
                              mLeaderTitle.put(System.Label.Badge_Title_of+' SEL+', filter);
                              lstLdrTitls.add(System.Label.Badge_Title_of+' SEL+');
                              System.debug('filter --> '+filter);
                            }
                            else
                            {
                              mLeaderTitle.put(System.Label.Badge_Title_of+' SEL+', 'TITL'+' SELGR '+'\''+leaderTitle.LDRSHP_TITL_LVL_NR__c+'\'');
                              lstLdrTitls.add(System.Label.Badge_Title_of+' SEL+');
                            }
                          }
                          else
                          {
                            mLeaderTitle.put(filterLabel, filterValue);
                            lstLdrTitls.add(filterLabel);
                          }
                      }
                  }
                  System.debug('\n ###### GOT IT mLeaderTitle.keyset  --- \n'+mLeaderTitle.keyset());
                  System.debug('\n ###### GOT IT lstLdrTitls  --- \n'+lstLdrTitls);
                  //for(String leaderTitle : mLeaderTitle.keyset())
                  for(String leaderTitle : lstLdrTitls)
                  {
                    String strFilterValue = mLeaderTitle.get(leaderTitle);
                    String strFilterLabel = leaderTitle;
                    
                    //if(appendToEnd) {
                            selectOptionList.add(new SelectOption(strFilterValue, strFilterLabel));
                        //}
                        //else {
                            //selectOptionList.add(foundIndex, new SelectOption(strFilterValue, strFilterLabel));
                            //foundIndex++;
                        //}
                  }
              }
            }
            else if(!isPresentOrFutureCampaign){
              /*foundIndex = GetItemIndex(selectOptionList, System.Label.All_Paid_Titles);
                foundIndex++;
                
                
                if(foundIndex >= (selectOptionList.size() - 1)) {
                    appendToEnd = true;
                }*/
                
                if(reportType == ALMConstants.REPORT_TYPE_TITL_ADV_REPCONFIG){
                  Map<String, String> mLeaderTitle = new Map<String, String>();
                  List<String>  lstLdrTitls = new List<String>();
                  for(Leader_Title__c leaderTitle: leaderTitleList) {
                    if(leaderTitle.LDRSHP_TITL_LVL_NR_NUMBER__c >= 1) {
          
                          filterValue = 'PTITL' + leaderTitle.LDRSHP_TITL_LVL_NR__c;
                          filterLabel = System.Label.Paid_Title_of + ' ' + leaderTitle.LCL_LDRSHP_TITL_CD__c;
                          
                          /*if(appendToEnd) {
                              selectOptionList.add(new SelectOption(filterValue, filterLabel));
                          }
                          else {
                              selectOptionList.add(foundIndex, new SelectOption(filterValue, filterLabel));
                              foundIndex++;
                          }*/
                            
                          if(filterLabel.contains('SEL'))
                          {
                            if(mLeaderTitle.containsKey(System.Label.Paid_Title_of+' SEL+'))
                            {
                              String filter = mLeaderTitle.get(System.Label.Paid_Title_of+' SEL+')+', \''+leaderTitle.LDRSHP_TITL_LVL_NR__c+'\'';
                              mLeaderTitle.put(System.Label.Paid_Title_of+' SEL+', filter);
                              lstLdrTitls.add(System.Label.Paid_Title_of+' SEL+');
                            }
                            else
                            {
                              mLeaderTitle.put(System.Label.Paid_Title_of+' SEL+', 'PTITL'+' SELGR '+'\''+leaderTitle.LDRSHP_TITL_LVL_NR__c+'\'');
                              lstLdrTitls.add(System.Label.Paid_Title_of+' SEL+');
                            }
                          }
                          else
                          {
                            mLeaderTitle.put(filterLabel, filterValue);
                            lstLdrTitls.add(filterLabel);
                          }
                      }
                  }
                  System.debug('\n ###### GOT IT mLeaderTitle.keyset  --- \n'+mLeaderTitle.keyset());
                  System.debug('\n ###### GOT IT lstLdrTitls  --- \n'+lstLdrTitls);
                  //for(String leaderTitle : mLeaderTitle.keyset())
                  for(String leaderTitle : lstLdrTitls)
                  {
                    String strFilterValue = mLeaderTitle.get(leaderTitle);
                    String strFilterLabel = leaderTitle;
                    
                    //if(appendToEnd) {
                            selectOptionList.add(new SelectOption(strFilterValue, strFilterLabel));
                        //}
                        //else {
                            //selectOptionList.add(foundIndex, new SelectOption(strFilterValue, strFilterLabel));
                            //foundIndex++;
                        //}
                  }
                }
                
            }
        }
        
        if(filterType == 'What') {

            if(selectOptionList.size() == 0) {
                //selectOptionList.add(new SelectOption('all', 'All Data'));
               selectOptionList.add(new SelectOption('all', System.Label.All_Reps));
            }
            else {
               //selectOptionList.add(0, new SelectOption('all', 'All Data'));
               selectOptionList.add(0, new SelectOption('all', System.Label.All_Reps));
            }
        }
        
        //Remove filters based on Campaign Selection    
        labelNameSet.clear();
            
        if(!isPresentOrFutureCampaign) {
            labelNameSet.add(System.Label.All_Badge_Titles);
            labelNameSet.add(System.Label.Open_Mail_Plan);
        }

        if(isPresentOrFutureCampaign) {
            labelNameSet.add(System.Label.All_Paid_Titles);
        }
        
        //Remove filter based on Account's Badge Title
        if(!isExecutive) {
            labelNameSet.add(System.Label.G4_Representatives);
            labelNameSet.add(System.Label.G5_Representatives);
            labelNameSet.add(System.Label.G6_Representatives);
        }
        
        if(labelNameSet.size() > 0) {
            selectOptionList = this.RemoveSelectOptionsByLabel(selectOptionList, labelNameSet);
        }
        System.debug('\n ###### selectOptionList FINAL ### \n '+selectOptionList); 
        return selectOptionList;    
    }
    
    private Integer GetItemIndex(List<SelectOption> selectOptionList, String filterKey) {
        
        Integer itemIndex = -1;
        
        for(Integer n = 0; n <= selectOptionList.size() - 1; n++) {
            
            if(selectOptionList[n].getLabel() == filterKey) {
                itemIndex = n;
                break;
            }
        }
        
        return itemIndex;
    }
    
    private List<JSONSelectOption> ConvertToJSONSelectOption(List<SelectOption> selectOptionList) {
        
        List<JSONSelectOption> jsonSelectOptionList = new List<JSONSelectOption>();
        
        for(SelectOption selectOption: selectOptionList) {
            
            JSONSelectOption jsonSelectOption = new JSONSelectOption();
            
            jsonSelectOption.Value = selectOption.getValue();
            jsonSelectOption.Label = selectOption.getLabel();

            jsonSelectOptionList.add(jsonSelectOption);
        }
        
        return jsonSelectOptionList;
    }
    
    public PageReference RefreshFilters() {
        
        FilterDTO filterDTO = new FilterDTO();
        
        filterDTO.WhoList = ConvertToJSONSelectOption(this.GetReportFilters('Who'));
        filterDTO.WhatList = ConvertToJSONSelectOption(this.GetReportFilters('What'));
        
        String jsonString = JSON.serialize(filterDTO);
        
        this.JSONResults = jsonString;
      
        return null;
    }
    
    public void getRefreshcamnparam()
    {
       ApexPages.currentPage().getParameters().put('CmpgnSeltd',this.InternalSelectedCampaignId); 
    }
    
    public Integer getPriorCampaign(Integer curr)
    {
        String a=String.valueOf(curr);
        System.debug('swar'+a.substring(0,4));
        if(a.substring(a.length()-2)=='01')       
        return Integer.valueOf((String.valueOf(Integer.valueOf(a.substring(0,4))-1)+'12'));
        else
        return curr-1;
    }//campaign Text display method added by swarnava - Defect ID : 2401
}