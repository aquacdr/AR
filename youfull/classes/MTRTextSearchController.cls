public class MTRTextSearchController {

    //Account in which the Report is based on
    public String AccountNum { get; set; }
    
    //MarketId
    public String MarketId { get; set; }
    
    //InternalCampaignId
    public String InternalCampaignId { get; set; }
    
    //BranchSearchCampaignId
    public String BranchSearchCampaignId { get; set; }

    //TextSearch
    public String TextSearch { get; set; }
    
    //TSCriteria
    public String TSCriteria { get; set; }

    //JavaScript method that is launched when Text Search is submitted
    public String OnSubmit { get; set; }
    
    //JavaScript method that is launched when a Server-Side Request begins
    public String OnRequestBegin { get; set; }
    
    //JavaScript method that is launched when a Server-Side Request ends
    public String OnRequestEnd { get; set; }
    
    //JSON result from filter refresh
    public transient String JSONResults { get; set; }
    
    //Substitute class for SelectOption to support JSON
    private class JSONSelectOption {
        
        public JSONSelectOption() {
            
        }
        
        public String Value { get; set; }
        public String Label { get; set; }
    }
    
    public boolean Is_branch{get;set;}
    
    public MTRTextSearchController() {
    System.debug('\n ####### this.MarketId -- '+this.MarketId); 
    }
    
    public List<SelectOption> GetBranches(Integer selectedCampaignId) {
    
        List<Branch_Summary__c> branchList = [SELECT Id, BRNCH_SCTN_CD__c FROM Branch_Summary__c
                                                WHERE CMPGN_NR__c = :selectedCampaignId
                                                AND ACCT_NR__c = :this.AccountNum
                                                AND MRKT_ID__c = :this.MarketId
                                                ORDER BY BRNCH_SCTN_CD__c];
        List<SelectOption> selectOptionList = new List<SelectOption>();
        
        for(Branch_Summary__c branch: branchList) {
            
            selectOptionList.add(new SelectOption(branch.BRNCH_SCTN_CD__c, branch.BRNCH_SCTN_CD__c));
        }
        
        return selectOptionList;
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
    
    public PageReference RefreshBranches() {
        
        Integer selectedCampaignId = 0;
        
        if(this.BranchSearchCampaignId != null && this.BranchSearchCampaignId.length() > 0) {

            if(this.BranchSearchCampaignId.indexOf('CMPGN') > -1 && this.BranchSearchCampaignId.indexOf('_') > -1) {
                
                MTRSOQLBuilder.CampaignDTO campaignDTO = MTRSOQLBuilder.ParseCampaignValues(this.BranchSearchCampaignId);
                
                selectedCampaignId = campaignDTO.CurrentCampaign;
            }
            else {
                selectedCampaignId = Integer.valueOf(this.BranchSearchCampaignId);
            }
        }
        else {
            
            if(this.InternalCampaignId != null && this.InternalCampaignId.indexOf('CMPGN') > -1 && this.InternalCampaignId.indexOf('_') > -1) {
                
                MTRSOQLBuilder.CampaignDTO campaignDTO = MTRSOQLBuilder.ParseCampaignValues(this.InternalCampaignId);
                
                selectedCampaignId = campaignDTO.CurrentCampaign;
            }
            else {
                selectedCampaignId = Integer.valueOf(this.InternalCampaignId);
            }
        }
        
        String jsonString = JSON.serialize(ConvertToJSONSelectOption(GetBranches(selectedCampaignId)));
        
        this.JSONResults = jsonString;
        
        return null;
    }
    
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*@isTest
    static void testMTRTextSearchController () {
        MTRTextSearchController cont = new MTRTextSearchController();
        testDataHelper testData = new testDataHelper();
        Market__c mkt = testData.createMarket('99');
        Branch_Summary__c branch = new Branch_Summary__c(CMPGN_NR__c=201306, 
                    ACCT_NR__c='1234567890', MRKT_ID__c=mkt.Market_Id__c, BRNCH_SCTN_CD__c='test',
                    Branch_Summary_Key__c = '992013061234567890');
        insert branch;
        
        cont.AccountNum = '1234567890';
        cont.InternalCampaignId= '201306';
        cont.MarketId = mkt.Market_Id__c;
        cont.GetBranches(201306);
        cont.RefreshBranches();
        cont.InternalCampaignId= 'CMPGN201305_201306';
        cont.RefreshBranches();
        cont.BranchSearchCampaignId = '201306';
        cont.RefreshBranches();
        cont.BranchSearchCampaignId= 'CMPGN201305_201306';
        cont.RefreshBranches();
    }*/
}