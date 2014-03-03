public class GenealogyDownload {
	
	private String m_CampaignId = '';
	private String m_AccountNumber = '-1';
	private MTRSOQLBuilder m_mtrSOQLBuilder = null;
	
	public Map<String, String> GenerationMap { get; private set; }
	
	public GenealogyDownload(String campaignId, String accountNumber, MTRSOQLBuilder mtrSOQLBuilder) {
	
		this.GenerationMap = new Map<String, String>();
		
		this.m_CampaignId = campaignId;
		this.m_AccountNumber = accountNumber;
		this.m_mtrSOQLBuilder = mtrSOQLBuilder;
	}
	
	public List<SObject> download() {
	
		this.GenerationMap.clear();
		
		Map<String, Integer> acctNumToIndex = new Map<String, Integer>();
		Map<Integer, String> indexToAcctNum = new Map<Integer, String>();
		List<SObject> genealogyList = new List<SObject>();	
		List<SObject> zeroGenealogyList = null;
		List<SObject> downlineList = null;
		Set<String> acctNums = new Set<String>();
		MTRSearchOptions.MTRFilterSearch filterSearchType = new MTRSearchOptions.MTRFilterSearch();
		Integer genIndex = 0;
		Boolean isNextGeneration = true;	
		
		filterSearchType = new MTRSearchOptions.MTRFilterSearch();
		
		filterSearchType.CampaignId = this.m_CampaignId;
		filterSearchType.AccountNumber = this.m_AccountNumber;
		
		this.m_mtrSOQLBuilder.SetSearchType(filterSearchType);
		
		zeroGenealogyList = this.m_mtrSOQLBuilder.GetZeroGenerationRecords();
		
		if(zeroGenealogyList.size() == 0) {
    		throw new ArgumentException('GenealogyDownload::download Exception Error=Could not load zero-generation.');
    	}
		
		acctNums.add(this.m_AccountNumber); //add the top of the tree
		acctNumToIndex.put(this.m_AccountNumber, 0);
		indexToAcctNum.put(0, this.m_AccountNumber);
		
		this.GenerationMap.put(this.m_AccountNumber, String.valueOf(genIndex));
		
		genIndex++;
		
		genealogyList.add(zeroGenealogyList[0]);
		
		filterSearchType = new MTRSearchOptions.MTRFilterSearch();
		
		filterSearchType.CampaignId = this.m_CampaignId;
		//filterSearchType.SearchForDownline = true;
		//filterSearchType.SelectIds.add(this.m_AccountNumber);
		
		
		//while(isNextGeneration){
			
			System.debug('acctNums: ' + acctNums);
			
			this.m_mtrSOQLBuilder.SetSearchType(filterSearchType);
			
			downlineList = this.m_mtrSOQLBuilder.GetRecords();

			if(downlineList.size() == 0){
				isNextGeneration = false;
				//break;
			}
				
			System.debug('downlineList: ' + downlineList);
			
			//this.mergeLists(genealogyList, downlineList, acctNumToIndex, indexToAcctNum);
			
			genealogyList.addAll(downlineList);
			
			System.debug('genealogyList: ' + genealogyList);
			System.debug('acctNumToIndex: ' + acctNumToIndex);
			
			filterSearchType.SelectIds.clear();
			
			//addAcctNumsToSet(filterSearchType.SelectIds, downlineList, genIndex);
			
			//genIndex++;
			
			downlineList.clear();
		//}

		return genealogyList;
	}
	
	private void mergeLists(List<SObject> mainList, List<SObject> listToAdd, Map<String,Integer> acctNumToIndex, Map<Integer, String> indexToAcctNum){
		String curUpline;
		String prevUpline;
		Integer uplineIndex = -1;
		
		for(SObject sobj: listToAdd){
			
			System.debug('sobj: ' + sobj);
			curUpline = String.valueOf(sobj.get('UPLN_ACCT_NR__c'));
			String acctNum = String.valueOf(sobj.get('ACCT_NR__c'));
			System.debug('curUpline: ' + curUpline);
			System.debug('uplineIndex: ' + uplineIndex);
			
			if(uplineIndex == -1 || (curUpline != prevUpline))
				uplineIndex = acctNumToIndex.get(curUpline); //get the index of the immediate upline in the list
				
			uplineIndex++;	//put the child right after the parent
			System.debug('uplineIndex: ' + uplineIndex);
			System.debug('mainList: ' + mainList);	
					
			if(uplineIndex >= mainList.size()){
				System.debug('ADDING TO THE END');
				mainList.add(sobj);
			}
			else{
				
				//update indexes for elements after uplineIndex position
				System.debug('ADDING AT POSITION: ' + uplineIndex);
				mainList.add(uplineIndex, sobj);
				
				//acctNumToIndex.put(acctNum, uplineIndex);
				//indexToAcctNum.put(uplineIndex, acctNum);
				
				System.debug('acctNumToIndex: ' + acctNumToIndex);
				System.debug('indexToAcctNum: ' + indexToAcctNum);
				
				Integer size = indexToAcctNum.size();
				Map<Integer, String> tmpIndexToAcctNum = indexToAcctNum.clone();
				Map<String, Integer> tmpAcctNumToIndex = acctNumToIndex.clone();
				
				for(Integer i = uplineIndex; i< size; i++){
					System.debug('i: ' + i);
					Integer prevIndex = tmpAcctNumToIndex.get(tmpIndexToAcctNum.get(i));
					System.debug('acctnum: ' + tmpIndexToAcctNum.get(i));
					System.debug('new index: ' + (++prevIndex));
					acctNumToIndex.put(tmpIndexToAcctNum.get(i), prevIndex);
					indexToAcctNum.put(prevIndex, tmpIndexToAcctNum.get(i));
				}				
			}
			
			System.debug('uplineIndex: ' + uplineIndex);
			System.debug('mainList: ' + mainList);
			acctNumToIndex.put(acctNum, uplineIndex);
			indexToAcctNum.put(uplineIndex, acctNum);
			System.debug('acctNumToIndex: ' + acctNumToIndex);
			System.debug('indexToAcctNum: ' + indexToAcctNum);
			prevUpline = curUpline;
			
		}		
	}
	
	private Set<String> addAcctNumsToSet(Set<String> acctNums, List<SObject> downlineList, Integer genIndex) {
		
		String accountNumber = '-1';
		String genIndexStr = String.valueOf(genIndex);
		
		for(SObject sobj: downlineList){
			
			accountNumber = (String)sobj.get('ACCT_NR__c');
			
			acctNums.add(accountNumber);
			this.GenerationMap.put(accountNumber, genIndexStr);	
		}
		
		return acctNums;
	}

}