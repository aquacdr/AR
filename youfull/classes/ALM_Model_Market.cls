/***************************************************************************
 Name          : ALM_Model_Market
 Created By    : Parul Gupta
 Description   : Concrete model class for Market
 Created Date  : Feb 21, 2014               
****************************************************************************/

public virtual class ALM_Model_Market {
	
	public Market__c market;
	
	// =================================================================//
    // ----------------- CONSTRUCTORS AND INITIALIZERS -----------------
	// =================================================================//
	
    public ALM_Model_Market() {
        initialize(new Market__c());
    }
    
    public ALM_Model_Market(Market__c marketParam) {
        initialize(marketParam);
    }
    
    public virtual ALM_Model_Market initialize(Market__c marketParam) {
        this.market = marketParam;
        return this;
    }
    
    //=================================================================//
    // Get the Market object, currently assuming it was proactivele initialized 
    // at time of construction, but may want to add lazy initialization code.
    //=================================================================//
    public Market__c getMarketData() {
        return market;
    }
	
    
	public Boolean isNRTEnabled(){
		return false;
	}
	
	//=================================================================//
    // Get Prior Operational Campaign
    //=================================================================//
	public String getPriorOperationalCampaign(){
		return market.PREV_1_CMPGN_NR__c;
	}
	
	//=================================================================//
    // Get Prior Selling Campaign
    //=================================================================//
	public String getPriorSellingCampaign(){
		return market.PREV_1_CMPGN_NR__c;
	}
	
	//=================================================================//
    // Get Current Operational Campaign
    //=================================================================//
	public String getCurrentOperationalCampaign(){
		return market.CMPGN_NR__c;
	}
	
	//=================================================================//
    // Get Current Selling Campaign
    //=================================================================//
	public String getCurrentSellingCampaign(){
		return market.CMPGN_NR__c;
	}
	
	//=================================================================//
    // Get Next Operational Campaign
    //=================================================================//
	public String getNextOperationalCampaign(){
		return market.NEXT_1_CMPGN_NR__c;
	}
	
    // Get Next Selling Campaign
    //=================================================================//
	public String getNextSellingCampaign(){
		return market.NEXT_1_CMPGN_NR__c;
	}
	
	//=================================================================//
    // Get List of Operational Campaigns
    //=================================================================//
	public List<String> getOperationalCampaigns(){
		return new List<String>();
	}
	
	//=================================================================//
    // Get List of Selling Campaigns
    //=================================================================//
	public List<String> getSellingCampaigns(){
		return new List<String>();
	}
	
	//=================================================================//
    // Get List of Selling Campaigns
    //=================================================================//
	public Boolean supportsEmail(String profileName){
		return false;
	}

}