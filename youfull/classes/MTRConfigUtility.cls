public class MTRConfigUtility {

     private static Map<String, String> GetLeaderTitle() {
    
        Map<String, Leader_Title__c>  bigLeaderTitleMap = null;
        Map<String, String> littleLeaderTitleMap = null;
        MarketLeaderTitleUtils mltu = new MarketLeaderTitleUtils();
        User currUser = [SELECT Id, LDRSHP_TITL_LVL_NBR__c, MRKT_ID__c, ACCT_NR__c, LanguageLocaleKey FROM User
                            WHERE Id = :UserInfo.getUserId() LIMIT 1]; 
        
        bigLeaderTitleMap = mltu.initializeAndRetMapLT(currUser);
        
        littleLeaderTitleMap = new Map<String, String>();
                        
        for(Leader_Title__c leaderTitle: bigLeaderTitleMap.values()) {
            
            littleLeaderTitleMap.put(leaderTitle.LDRSHP_TITL_LVL_NR__c, leaderTitle.LCL_LDRSHP_TITL_CD__c);
        }
        
        return littleLeaderTitleMap;
    }
    
    public static String GetUserBadgeTitle(Id marketId, String accountNumber) {
        
        List<Leader_Title__c> leaderList = null;
        List<User> userList = null;
        Market__c market = null;
        MarketLeaderTitleUtils mltu = new MarketLeaderTitleUtils();
        String marketAccountNum = '';
        String leaderType = '';
        
        market = [SELECT Id, Market_Id__c FROM Market__c
                            WHERE Id = :marketId];
                                
        if(market == null) {
            throw new ArgumentException('MTRConfigUtility::GetUserBadgeTitle Exception Error=Could not find Market Id.');
        }
        
        marketAccountNum = market.Market_Id__c + accountNumber;
        
        userList = [SELECT Id, LDRSHP_TITL_LVL_NBR__c, MRKT_ID__c, ACCT_NR__c, LanguageLocaleKey FROM User
                            WHERE MRKT_ID_ACCT_NR_KEY__c = :marketAccountNum LIMIT 1];
        
        if(userList.size() > 0) {
            leaderList = mltu.initializeAndRestListSortedByTitleNumber(marketId, userList[0].LanguageLocaleKey);
            leaderType = LandingPageUtils.determineLeaderType(leaderList, userList[0].LDRSHP_TITL_LVL_NBR__c) ;
        }
        
        return leaderType;          
    }
    
    public static Boolean HasExecutiveBadgeTitle(Id marketId, String accountNumber) {
 
        List<Leader_Title__c> leaderList = null;
        List<User> userList = null;
        Market__c market = null;
        String marketAccountNum = '';
        Boolean isExecutive = false;
        
        market = [SELECT Id, Market_Id__c FROM Market__c
                            WHERE Id = :marketId];
                                
        if(market == null) {
            throw new ArgumentException('MTRConfigUtility::HasExecutiveBadgeTitle Exception Error=Could not find Market Id.');
        }
        
        marketAccountNum = market.Market_Id__c + accountNumber;
        
        userList = [SELECT Id, LDRSHP_TITL_LVL_NBR__c, MRKT_ID__c, ACCT_NR__c, LanguageLocaleKey FROM User
                            WHERE MRKT_ID_ACCT_NR_KEY__c = :marketAccountNum LIMIT 1];
        
        if(userList.size() > 0) {
            
            leaderList = [SELECT Id FROM Leader_Title__c
                                        WHERE Market__c = :marketId
                                        AND LDRSHP_TITL_LVL_NR__c = :userList[0].LDRSHP_TITL_LVL_NBR__c
                                        AND LANG_CD__c = :userList[0].LanguageLocaleKey
                                        AND EXEC_IND__c = 'Y'];
            
            if(leaderList.size() > 0) {
                isExecutive = true;
            }
        }
        
        return isExecutive;
    }
    
    public static Date ConvertStringToDate(String strDate) {
        
        //Tue Jun 05 00:00:00 GMT 2012 
        
        Map<String,String> monthMap = new Map<String,String>();
        List<String> dateParts = strDate.split(' ');
        String year = '';
        String month = '';
        String day = '';
        
        if(dateParts.size() != 6) {
            throw new ArgumentException('MTRConfigUtility::ConvertStringToDate Exception Error=Invalid data provided.');
        }
        
        monthMap.put('Jan','1');
        monthMap.put('Feb','2');
        monthMap.put('Mar','3');
        monthMap.put('Apr','4');
        monthMap.put('May','5');
        monthMap.put('Jun','6');
        monthMap.put('Jul','7');
        monthMap.put('Aug','8');
        monthMap.put('Sep','9');
        monthMap.put('Oct','10');
        monthMap.put('Nov','11');
        monthMap.put('Dec','12');
        
        year = dateParts.get(5);
        month = monthMap.get(dateParts.get(1));
        day = dateParts.get(2);
        
        if(month == null) {
            throw new ArgumentException('MTRConfigUtility::ConvertStringToDate Exception Error=Could not find the specified month.');
        }
        
        if(day.startsWith('0')) {
            day = day.substring(1).trim();
        }
        
        return Date.valueOf(year + '-' + month + '-' + day + ' 00:00:00');
    }
    
    public static String CreateLeadershipKey(String marketId, Integer campaignId, String accountId) {
        
        return marketId + campaignId + accountId;
    }
    
    public static String CreatePersonalKey(String marketId, Integer campaignId, String accountId) {
        
        return marketId + campaignId + accountId;
    }

    public static String CreateBranchSummaryKey(String marketId, Integer campaignId, String accountId, String branchCode) {
        
        return marketId + campaignId + accountId + branchCode;
    }
    
    public static Map<String, Contact> GetContacts(String marketId, Set<String> sponsorAcctNumSet) {
        //System.debug('\n ################# GetContacts - 1');
        Map<String, Contact> acctNumContactMap = new Map<String, Contact>();
        List<Contact> contactList = [SELECT Id, ACCT_NR__c , FirstName, LastName FROM Contact
                                        WHERE MRKT_ID__c = :marketId
                                        AND ACCT_NR__c IN :sponsorAcctNumSet];
        //System.debug('\n ################# GetContacts - 1 contactList size '+contactList.size());
        for(Contact contact: contactList) {
            //System.debug('\n ################# GetContacts - 1 contact name '+contact.FirstName+' -- '+contact.LastName);
            acctNumContactMap.put(contact.ACCT_NR__c, contact);
        }
        //System.debug('\n ################# GetContacts - 1 acctNumContactMap '+acctNumContactMap);
        return acctNumContactMap;
    }  
    
    public static List<GenealogyWrapper> ConvertToWrapper(List<SObject> genealogyList, Set<String> columnNameSet, String marketId, String nameLabel, Boolean isFutureOrPresentCampaign) {
        //System.debug('\n ################# ConvertToWrapper - 1');
        
        /*for(SObject obj : genealogyList){
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper ');
        	if (obj.getSObject('Personal_Performance_Key__r') != null) {
        	//System.debug('\n @@@@@@@@@ LOOP get Personal_Performance_Key__r ConvertToWrapper ');	
        		
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper get Personal_Performance_Key__r DATA LDRSHP_TITL_LVL_NR__c '+(String)obj.getSObject('Personal_Performance_Key__r').get('LDRSHP_TITL_LVL_NR__c'));	
        	}
        	if (obj.getSObject('Contact_Key__r') != null) {
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper get Contact_Key__r ');		
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper get Contact_Key__r DATA Firstname '+(String)obj.getSObject('Contact_Key__r').get('FirstName'));
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper get Contact_Key__r DATA Lastname '+(String)obj.getSObject('Contact_Key__r').get('LastName'));	
        	}
        	if (obj.getSObject('Leadership_Summary_Key__r') != null) {
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper get Leadership_Summary_Key__r ');		
        	//System.debug('\n @@@@@@@@@ LOOP ConvertToWrapper get Leadership_Summary_Key__r DATA ALL_DOWNLN_CNT_WITH_REMV__c '+obj.getSObject('Leadership_Summary_Key__r').get('ALL_DOWNLN_CNT_WITH_REMV__c'));
        		
        	}
        }*/
        
        Map<String, Contact> acctNumContactMap = new Map<String, Contact>();
        Map<String, String> leaderTitleMap = MTRConfigUtility.GetLeaderTitle();
        List<GenealogyWrapper> genealogyWrapperList = new List<GenealogyWrapper>();
        Set<String> sponsorAcctNumSet = new Set<String>();
        Contact contact = null;
        String firstLastNameLabel = MTRConfigUtility.getJSFixedFirstLastNameLabel();
        String lastFirstNameLabel = MTRConfigUtility.getJSFixedLastFirstNameLabel();
        String temp = '';
        Boolean validContact = false;
        
        for(SObject genealogy: genealogyList) {
            //System.debug('\n ################# ConvertToWrapper - 1 INSIDE LOOP ');
            //System.debug('\n ################# ConvertToWrapper - 1 UPLN_ACCT_NR__c '  +(String)genealogy.getSObject('Personal_Performance_Key__r').get('UPLN_ACCT_NR__c'));
            if(columnNameSet.contains('UPLN_ACCT_NR__c') && genealogy.get('UPLN_ACCT_NR__c') != null) {
                sponsorAcctNumSet.add((String)genealogy.get('UPLN_ACCT_NR__c'));
            }
        }
        //System.debug('\n ################# ConvertToWrapper - 2 sponsorAcctNumSet.size() '+sponsorAcctNumSet.size());
        if(sponsorAcctNumSet.size() > 0) {
           // System.debug('\n ################# ConvertToWrapper - INSIDE CONTACT LOOP ');
            acctNumContactMap = MTRConfigUtility.GetContacts(marketId, sponsorAcctNumSet);
        }
        //System.debug('\n ################# ConvertToWrapper - 3');
        for(SObject genealogy: genealogyList) {
            
            GenealogyWrapper genealogyWrapper = new GenealogyWrapper();
            
            genealogyWrapper.Genealogy = genealogy;
            
            genealogyWrapper.BadgeTitle = '';
            genealogyWrapper.Sponsor = '';
            
            if(isFutureOrPresentCampaign && columnNameSet.contains('LDRSHP_TITL_LVL_NR__c') && genealogy.get('LDRSHP_TITL_LVL_NR__c') != null) {
                
                temp = (String)genealogy.get('LDRSHP_TITL_LVL_NR__c');
                
                genealogyWrapper.BadgeTitleNumber = temp;
                genealogyWrapper.BadgeTitle = leaderTitleMap.get(temp);
                genealogyWrapper.BadgeTitle = (genealogyWrapper.BadgeTitle != null) ? genealogyWrapper.BadgeTitle : '';
            }
            else if(!isFutureOrPresentCampaign && columnNameSet.contains('PD_TITL_LVL_NR__c') && genealogy.get('PD_TITL_LVL_NR__c') != null) {
                
                temp = (String)genealogy.get('PD_TITL_LVL_NR__c');
                
                genealogyWrapper.BadgeTitleNumber = temp;
                genealogyWrapper.BadgeTitle = leaderTitleMap.get(temp);
                genealogyWrapper.BadgeTitle = (genealogyWrapper.BadgeTitle != null) ? genealogyWrapper.BadgeTitle : ''; 
            }
           
            if(acctNumContactMap.size() > 0 && genealogy.get('UPLN_ACCT_NR__c') != null) {
                
                temp = (String)genealogy.get('UPLN_ACCT_NR__c');
                contact = acctNumContactMap.get(temp);
                
                validContact = (contact != null && contact.FirstName != null && contact.LastName != null);
                
                if(validContact && nameLabel == firstLastNameLabel) {
                   
                    genealogyWrapper.Sponsor = contact.FirstName + ' ' + contact.LastName;
                }
                else if(validContact && nameLabel == lastFirstNameLabel) {
                    
                    genealogyWrapper.Sponsor = contact.LastName + ' ' + contact.FirstName;
                }
                else {
                    genealogyWrapper.Sponsor = temp;
                }
            }
            
            genealogyWrapperList.add(genealogyWrapper);
        }
        
        return genealogyWrapperList;
    }
    
    public static List<GenealogyWrapper> ConvertToWrapperNew(List<SObject> genealogyList, Set<String> columnNameSet, String marketId, String nameLabel, Boolean isFutureOrPresentCampaign, Decimal leaderLevel) {
        Map<String, Contact> acctNumContactMap = new Map<String, Contact>();
        Map<String, String> leaderTitleMap = MTRConfigUtility.GetLeaderTitle();
        List<GenealogyWrapper> genealogyWrapperList = new List<GenealogyWrapper>();
        Set<String> sponsorAcctNumSet = new Set<String>();
        Contact contact = null;
        String firstLastNameLabel = MTRConfigUtility.getJSFixedFirstLastNameLabel();
        String lastFirstNameLabel = MTRConfigUtility.getJSFixedLastFirstNameLabel();
        String temp = '';
        Boolean validContact = false;
        
        for(SObject genealogy: genealogyList) {
            if(columnNameSet.contains('UPLN_ACCT_NR__c') && genealogy.get('UPLN_ACCT_NR__c') != null) {
                sponsorAcctNumSet.add((String)genealogy.get('UPLN_ACCT_NR__c'));
            }
        }
        if(sponsorAcctNumSet.size() > 0) {
            acctNumContactMap = MTRConfigUtility.GetContacts(marketId, sponsorAcctNumSet);
        }
        for(SObject genealogy: genealogyList) {
            
            GenealogyWrapper genealogyWrapper = new GenealogyWrapper();
            genealogyWrapper.Genealogy = genealogy;
            // Based on the new structure, the Genealogy Level in the Data Object is relative only to the root. To display the level realtive to the
            // leader logged in, making this change in the value
            // Only for display purpose. The database still will retain the genealogy level with respect to root
            genealogyWrapper.levelRelative = (Decimal)genealogy.get('Genealogy_Level__c') - leaderLevel;
            //genealogyWrapper.Genealogy.put('Genealogy_Level__c', );
            genealogyWrapper.BadgeTitle = '';
            genealogyWrapper.Sponsor = '';
            
            if(isFutureOrPresentCampaign && columnNameSet.contains('LDRSHP_TITL_LVL_NR__c') && genealogy.get('LDRSHP_TITL_LVL_NR__c') != null) {
                
                temp = (String)genealogy.get('LDRSHP_TITL_LVL_NR__c');
                
                genealogyWrapper.BadgeTitleNumber = temp;
                genealogyWrapper.BadgeTitle = leaderTitleMap.get(temp);
                genealogyWrapper.BadgeTitle = (genealogyWrapper.BadgeTitle != null) ? genealogyWrapper.BadgeTitle : '';
            }
            else if(!isFutureOrPresentCampaign && columnNameSet.contains('PD_TITL_LVL_NR__c') && genealogy.get('PD_TITL_LVL_NR__c') != null) {
                
                temp = (String)genealogy.get('PD_TITL_LVL_NR__c');
                
                genealogyWrapper.BadgeTitleNumber = temp;
                genealogyWrapper.BadgeTitle = leaderTitleMap.get(temp);
                genealogyWrapper.BadgeTitle = (genealogyWrapper.BadgeTitle != null) ? genealogyWrapper.BadgeTitle : ''; 
            }
           
            if(acctNumContactMap.size() > 0 && genealogy.get('UPLN_ACCT_NR__c') != null) {
                
                temp = (String)genealogy.get('UPLN_ACCT_NR__c');
                contact = acctNumContactMap.get(temp);
                
                validContact = (contact != null && contact.FirstName != null && contact.LastName != null);
                
                if(validContact && nameLabel == firstLastNameLabel) {
                   
                    genealogyWrapper.Sponsor = contact.FirstName + ' ' + contact.LastName;
                }
                else if(validContact && nameLabel == lastFirstNameLabel) {
                    
                    genealogyWrapper.Sponsor = contact.LastName + ' ' + contact.FirstName;
                }
                else {
                    genealogyWrapper.Sponsor = temp;
                }
            }
            
            genealogyWrapperList.add(genealogyWrapper);
        }
        
        return genealogyWrapperList;
    }
    
    public static String GetExceptionRule(String fullyQualifiedName) {
        
        String ruleType = '';
        
        if(fullyQualifiedName.indexOf('MRKT_ACCT_KEY__r.FirstName') > -1 || fullyQualifiedName.indexOf('MRKT_ACCT_KEY__r.LastName') > -1) {
            ruleType = 'Name';
        }
        else if(fullyQualifiedName.indexOf('LDRSHP_TITL_LVL_NR__c') > -1 || fullyQualifiedName.indexOf('PD_TITL_LVL_NR__c') > -1) {
            ruleType = 'BadgeTitle';
        }
        else if(fullyQualifiedName.indexOf('LDRSHP_LOA_NR__c') > -1 || fullyQualifiedName.indexOf('LOA_NR__c') > -1) {
            ruleType = 'LLOALOA';
        }
        else if(fullyQualifiedName.indexOf('UPLN_ACCT_NR__c') > -1) {
            ruleType = 'Sponsor';
        }
        
        return ruleType;
    }
    
    public static String ParseExceptionRuleField(String ruleType, String fullyQualifiedName, GenealogyWrapper genealogyWrapper) {
        
        List<String> columnNameList = new List<String>();
        String[] fieldSplit = null;
        String[] qualifierSplit = null;
        String objectName = '';
        String strValue = '';
        Object objValue = null;
        Boolean hasContactObj = false;
        Boolean hasPersonalObj = false;
    
        hasContactObj = (genealogyWrapper.Genealogy.getSObject('MRKT_ACCT_KEY__r') != null);
        //hasPersonalObj = (genealogyWrapper.Genealogy.getSObject('Personal_Performance_Key__r') != null);
        
        if(hasContactObj && ruleType == 'Name') {
            objectName = 'MRKT_ACCT_KEY__r';
        }
        /*
        else if(hasPersonalObj && (ruleType == 'LLOALOA')) {
            objectName = 'Personal_Performance_Key__r';
        }
        */
        fieldSplit = fullyQualifiedName.split(',');
        system.debug(fieldSplit);
        for(String tempField: fieldSplit) { 
        
            qualifierSplit = tempField.split('\\.');
        	system.debug(qualifierSplit);    
            if(qualifierSplit.size() > 1) {
                columnNameList.add(qualifierSplit[1].trim());
            }
            else{
            	columnNameList.add(qualifierSplit[0].trim());
            }
        }
        
        if(ruleType == 'Name') {
            
            if(genealogyWrapper.RowType == 'Personal') {
                String personalLabel = System.Label.Personal;
                strValue = personalLabel.toUpperCase() + ' -->';
            }
            else if(columnNameList.size() > 1  && !MTRConfigUtility.IsNullCheck(genealogyWrapper.Genealogy.getSObject(objectName), columnNameList, 2)) {
                strValue = (String)genealogyWrapper.Genealogy.getSObject(objectName).get(columnNameList[0]) + ' ' + (String)genealogyWrapper.Genealogy.getSObject(objectName).get(columnNameList[1]) ;
            }
            else if(!MTRConfigUtility.IsNullCheck(genealogyWrapper.Genealogy.getSObject(objectName), columnNameList, 1)){
                strValue = (String)genealogyWrapper.Genealogy.getSObject(objectName).get(columnNameList[0]);
            }
            else {
                strValue = '';
            }
            
        }
        else if(ruleType == 'LLOALOA') {

            if(columnNameList.size() > 1 && !MTRConfigUtility.IsNullCheck(genealogyWrapper.Genealogy, columnNameList, 2)) {
                strValue = String.valueOf(genealogyWrapper.Genealogy.get(columnNameList[0])) + '/' + String.valueOf(genealogyWrapper.Genealogy.get(columnNameList[1]));
            }
            else if(!MTRConfigUtility.IsNullCheck(genealogyWrapper.Genealogy, columnNameList, 1)){
                strValue = String.valueOf(genealogyWrapper.Genealogy.get(columnNameList[0]));
            }
            else {
                strValue = '';
            }
                            
        }
        
        return strValue;
    }
    
    public static Decimal GetAllDownlineCount(GenealogyWrapper genealogyWrapper, Boolean includeRemovedReps) {
        
        SObject objLeadership = null;
        Decimal allDownlineCount = 0;
        
        if(genealogyWrapper != null && genealogyWrapper.Genealogy != null) {
            
            //objLeadership = genealogyWrapper.Genealogy.getSObject('Leadership_Summary_Key__r');
            
            if(includeRemovedReps && genealogyWrapper.Genealogy.get('ALL_DOWNLN_CNT_WITH_REMV__c') != null) {
                allDownlineCount = (Decimal)genealogyWrapper.Genealogy.get('ALL_DOWNLN_CNT_WITH_REMV__c');       
            }
            else if(genealogyWrapper.Genealogy.get('ALL_DWNLN_CNT__c') != null) {
                 allDownlineCount = (Decimal)genealogyWrapper.Genealogy.get('ALL_DWNLN_CNT__c');
            }
        }
        //System.debug('\n ## GetAllDownlineCount allDownlineCount --- '+allDownlineCount);
        return allDownlineCount;
    }
    
    private static String MakeValueSafe(Object objValue) {
        
        String strValue = '';

        if(objValue != null) {
            strValue = String.valueOf(objValue);
        }
        else {
            strValue = '';
        }
        
        return strValue;
    }
    
    private static Boolean IsNullCheck(SObject obj, List<String> columnNameList, Integer sizeCheck) {
        
        Boolean isNull = false;
        
        for(Integer n = 0; n <= sizeCheck - 1; n++) {
            
            if(obj.get(columnNameList[n]) == null) {
                isNull = true;
                break;
            }
        }
        
        return isNull;
    }
    
    public static Boolean IsReportTypeSupported(String reportType) {
        
        Boolean isSupported = false;
        
        if(reportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT) {
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_G1APPT) {
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_RISINGSTARS) {
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_TLIST) {  //added by swarnava for Team List
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_TLISTORDER) {  //added by swarnava for Team List
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT) {  //added by raktim for Title Adv
            isSupported = true;
        }
        
        return isSupported;
    }
    
    public static Boolean IsMyTeamReportCompatible(String reportType) {

        Boolean isSupported = false;
        
        if(reportType == ALMConstants.REPORT_TYPE_MYTEAM_REPORT) {
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_MYTEAM_ORDER) {
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_TLIST) {  //added by swarnava for Team List
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_TLISTORDER) {  //added by swarnava for Team List
            isSupported = true;
        }
        else if(reportType == ALMConstants.REPORT_TYPE_TITLE_ADV_REPORT) {  //added by raktim for Title Advancement
            isSupported = true;
        }
        
        return isSupported;         
    }
    
    public static String EscapeBadJavascriptChars(String data) {
        
        if(data != null) {
            data = data.replace('"','\"').replace('\'','\\\'');
        }
        
        return data;
    }
    
    public static String getHTTPBaseSalesforceUrl() {
    
        return URL.getSalesforceBaseUrl().toExternalForm().replace('https://', 'http://');  
    }
    
    public static String getJSFixedAllLabel() {
                    
       //String s = '<img id="pic" src="'+System.Label.YOU_NEWREP_ALL_CHKBX+'" alt="Email" />'; TEST_IMG
       
       String s = '<div><td class="cellText" style="white-space: normal; width: 35px;">'+System.Label.Email+'</td></div>';
       
       return s;
    }
    
    public static String getJSFixedGenerationLabel() {
        
        return EscapeBadJavascriptChars(System.Label.Gen); 
    }
    
    public static String getJSFixedFirstLastNameLabel() {
        
        return EscapeBadJavascriptChars(System.Label.First_Last_Name);
    }
    
    public static String getJSFixedLastFirstNameLabel() {
        
        return EscapeBadJavascriptChars(System.Label.Last_First_Name);
    }
    
    public static String getJSFixedTListLabel() {
        
        return EscapeBadJavascriptChars(System.Label.T_List);
    }
    
    public static String GetMTRLanguageCode(Boolean isTList) {
        
        List<User> userList = null;
        String url = ApexPages.currentPage().getUrl().toLowerCase();
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        String accountKey = ApexPages.currentPage().getParameters().get('acctKey');
        String tmpMarketAccountKey = '-1';
        String languageCode = '';
        
        if((isTList || (!isTList  && (url.indexOf('/apex/tlist') > -1 || url.indexOf('/apex/tlistorders') > -1))) && accountId != null) {
            
            userList = [SELECT Id, LanguageLocaleKey FROM User
                            WHERE MRKT_ID_ACCT_NR_KEY__c=:accountId LIMIT 1];
        }
        else if(accountKey != null) {
            
            User loggedInUser = [SELECT Id, MRKT_ID__c FROM User
                        WHERE Id=:UserInfo.getUserId() LIMIT 1];
            
            tmpMarketAccountKey = loggedInUser.MRKT_ID__c + accountKey;
            
            userList = [SELECT Id, LanguageLocaleKey FROM User
                            WHERE MRKT_ID_ACCT_NR_KEY__c=:tmpMarketAccountKey LIMIT 1];
        }
        else {
            
            userList = [SELECT Id, LanguageLocaleKey FROM User
                            WHERE Id=:UserInfo.getUserId() LIMIT 1];
        }
        
        if(userList.size() > 0) {
            languageCode = userList[0].LanguageLocaleKey;
        }
        
        return languageCode;
    }
    
    public static Boolean MTRUserAccountExists(Boolean isTList) {
 
        List<User> userList = null;
        String url = ApexPages.currentPage().getUrl().toLowerCase();
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        String accountKey = ApexPages.currentPage().getParameters().get('acctKey');
        String tmpMarketAccountKey = '-1';
        Boolean accountExists = false;
        System.debug('\n ##### accountKey --- '+accountKey+', accountId --- '+accountId);
        if((isTList || (!isTList  && (url.indexOf('/apex/tlist') > -1 || url.indexOf('/apex/tlistorders') > -1))) && accountId != null) {
            System.debug('\n ##### 1');
            userList = [SELECT Id, LanguageLocaleKey FROM User
                            WHERE MRKT_ID_ACCT_NR_KEY__c=:accountId LIMIT 1];
        }
        else if(accountKey != null) {
            System.debug('\n ##### 2 UserInfo.getUserId() '+UserInfo.getUserId());
            User loggedInUser = [SELECT Id, MRKT_ID__c FROM User
                        WHERE Id=:UserInfo.getUserId() LIMIT 1];
            System.debug('\n ##### 2 loggedInUser  '+loggedInUser.MRKT_ID__c);
            tmpMarketAccountKey = loggedInUser.MRKT_ID__c + accountKey;
            System.debug('\n ##### 2 loggedInUser   tmpMarketAccountKey '+tmpMarketAccountKey);
            userList = [SELECT Id, LanguageLocaleKey FROM User
                            WHERE MRKT_ID_ACCT_NR_KEY__c=:tmpMarketAccountKey LIMIT 1];
            System.debug('\n ##### 2 userList   '+userList);
        }
        else {
            System.debug('\n ##### 3');
            accountExists = true;
        }
        
        if(userList != null && userList.size() > 0) {
        	System.debug('\n ##### 4');
            accountExists = true;
        }
        
        return accountExists;       
    }

    public static Boolean MultiPicklistContains(String pickListField, String value) {
        
        Set<String> multiValues = new Set<String>();
        Boolean found = false;
        
        multiValues.addAll(pickListField.split(';'));
 
        found = multiValues.contains(value);
        
        return found;
    }
    
    public static Object ReadProperty(SObject genealogy, String fieldName) {

        String[] qualifierSplit = fieldName.split('\\.');
        Object value = null;
        
        if(qualifierSplit.size() == 1) {
            
            value = genealogy.get(qualifierSplit[0].trim());
        }
        else if(qualifierSplit.size() == 2 && genealogy.getSObject(qualifierSplit[0].trim()) != null) {
            
            value = genealogy.getSObject(qualifierSplit[0].trim()).get(qualifierSplit[1].trim());
        }
        else if(qualifierSplit.size() == 3 && genealogy.getSObject(qualifierSplit[0].trim()) != null 
                    && genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()) != null) {
                        
            value = genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()).get(qualifierSplit[2].trim());
        }
        else if(qualifierSplit.size() == 4 && genealogy.getSObject(qualifierSplit[0].trim()) != null
                    && genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()) != null
                    && genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()).getSObject(qualifierSplit[2].trim()) != null) {
                        
            value = genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()).getSObject(qualifierSplit[2].trim()).get(qualifierSplit[3].trim());
        }
        
        return value;
    }
    
    public static void WriteProperty(SObject genealogy, String fieldName, Object value) {
    
        String[] qualifierSplit = fieldName.split('\\.');
                    
        if(qualifierSplit.size() == 1) {
            genealogy.put(qualifierSplit[0].trim(), value);
        }
        else if(qualifierSplit.size() == 2) {
            genealogy.getSObject(qualifierSplit[0].trim()).put(qualifierSplit[1].trim(), value);
        }
        else if(qualifierSplit.size() == 3) {
            genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()).put(qualifierSplit[2].trim(), value);
        }
        else if(qualifierSplit.size() == 4) {
            genealogy.getSObject(qualifierSplit[0].trim()).getSObject(qualifierSplit[1].trim()).getSObject(qualifierSplit[2].trim()).put(qualifierSplit[3].trim(), value);
        }   
    }
    
}