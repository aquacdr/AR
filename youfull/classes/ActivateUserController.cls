/* 
Date    Who         			Modification
============================================================================================
May-29  Snehashis Ghosh     	Created.
*/

public class ActivateUserController {
    private static String MRKT_ID = 'mktcd';
    private static String ACCT_NR = 'acctnbr';
    private static String LANG_CD = 'langcd';
    private static String KEY = 'key';
    private static String DEBUG = 'debug';
    //added for ALM+ by Snehashis
    private static String PGID = 'pgId';
    private User currUsr;   
    public String stsMsg {get; private set;}
    private static String DATE_FORMAT = 'MM/dd/yyyy';
    private static String AVON_LEADER_SUITE='/SLSuite/SSORequestSubmit.page?vendorname=salesforce';
    private static String AVON_ZM_SUITE='/ZMSuite/SSORequestSubmit.page?vendorname=salesforce';
    private static String AVON_DM_SUITE='/DMSuite/SSORequestSubmit.page?vendorname=salesforce';
    private static String ACTIVATION_SUCCESS='User Activation Success';
    private static String ACTIVATION_FAILED='User Activation Failure';
    private Market__c market;
    private Map<String,String> stsMsgMap;
    public Boolean isFailure {get; set;}
    private static String AES_PRIVATE_KEY='Psfk0yJziqwDGb2Op6J43w==';
    private static String ALGO_NAME='AES128';
	public static Boolean testMode=false;
	private ALM_Global_Settings__c globalConfig;         
    public PageReference activateALMAccess(){
        isFailure=false;
        globalConfig= ALM_Global_Settings__c.getValues('ALM Default');
        
        stsMsgMap = new Map<String,String>();
        String debugFlag = ApexPages.currentPage().getParameters().get(DEBUG);
        if(debugFlag ==null){
            debugFlag='0';
        }
        try{
            String mktId = ApexPages.currentPage().getParameters().get(MRKT_ID);
            String acctNbr = ApexPages.currentPage().getParameters().get(ACCT_NR);
            String md5Param = ApexPages.currentPage().getParameters().get(KEY);
            //Changes by snehashis for ALM+
            String pgidVal; 
            try{
            	pgidVal=ApexPages.currentPage().getParameters().get(PGID);
            }catch(exception ex){}
            ALMLogUtils.log('ActivateUserController','mktId='+mktId);
            ALMLogUtils.log('ActivateUserController','acctNbr='+acctNbr);
            ALMLogUtils.log('ActivateUserController','pgId='+pgidVal);
            ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
            String SHARED_SECRET = globalConfig.Shared_Secret__c;   
            market = [  select Market_Id__c,GI3_Keep_Alive_URL__c,ASLF_Timezone_Offset__c,Name,Is_ALMPLUS_Enabled__c,
                                (select Content__c,Type__c from Market_Contents__r
                                 where Type__c in ('User Activation Success','User Activation Failure')) 
                        from Market__c 
                        where ASLF_Market_ID__c=:mktId];
            String dateStr = System.now().format(DATE_FORMAT);
            ALMLogUtils.log('ActivateUserController','dateStr='+dateStr);
            String toHash = mktId+acctNbr+dateStr+SHARED_SECRET;
            ALMLogUtils.log('ActivateUserController','Before MD5 Hashing='+toHash);
            Blob blobValue = Blob.valueOf(toHash);
            Blob hash = Crypto.generateDigest('MD5', blobValue);
            String expectedMd5 = EncodingUtil.convertToHex(hash);
            dateStr = System.now().addDays(1).format(DATE_FORMAT);
            toHash = mktId+acctNbr+dateStr+SHARED_SECRET;
            ALMLogUtils.log('ActivateUserController','Before MD5 Hashing(+1 day)='+toHash);
            blobValue = Blob.valueOf(toHash);
            hash = Crypto.generateDigest('MD5', blobValue);
            String expectedMd5NextDay = EncodingUtil.convertToHex(hash);
            ALMLogUtils.log('ActivateUserController','MD5 Param:'+md5Param+',Expected Value:'+expectedMd5);
            ALMLogUtils.log('ActivateUserController','MD5 Param:'+md5Param+',Expected Value(+1 day):'+expectedMd5NextDay);
            for(Market_Content__c mktContent : market.Market_Contents__r){
                stsMsgMap.put(mktContent.Type__c,mktContent.Content__c);
            }
            if(expectedMd5.equalsIgnoreCase(md5Param) || expectedMd5NextDay.equalsIgnoreCase(md5Param)){
                //Added logic to strip off any leading/trailing or space characters in the account number
                acctNbr = acctNbr.replace(' ', '');
                Decimal acctNbrInt =-99998777;
                try{
                    acctNbrInt = Decimal.valueOf(acctNbr);
                }catch(Exception ex){
                    
                }
                String mkrtActKey = market.Market_Id__c+acctNbr;
                //Try to find partial match <MRKT_ID><ACCTNBR> e.g. 6200000301
                List<User> matchingUsers;
                matchingUsers = [select     id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                            CDW_STS_CD__c,Profile.Name,FirstName,
                                            LastName,LanguageLocaleKey
                                from    User
                                where   MRKT_ID__c=:market.Market_Id__c
                                and     (MRKT_ID_ACCT_NR_KEY__c = :mkrtActKey or FederationIdentifier = :mkrtActKey)
                                ];
                //Try to find partial match <MRKT_ID>%<ACCTNBR> e.g. 62%00000301
                if(matchingUsers.isEmpty()){
                    ALMLogUtils.log('Activate User','Did not find an exact match for '+mkrtActKey+'. Trying a partial match now !!!');
                    mkrtActKey = market.Market_Id__c+'%'+acctNbr;
                    matchingUsers = [select     id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                                CDW_STS_CD__c,Profile.Name,FirstName,
                                                LastName,LanguageLocaleKey
                                    from    User
                                    where   MRKT_ID__c=:market.Market_Id__c
                                    and     (MRKT_ID_ACCT_NR_KEY__c like :mkrtActKey or FederationIdentifier like :mkrtActKey)
                                    ];
                }
                //Attempt to strip off the leading 0s and try again.
                if(matchingUsers.isEmpty()){
                    //Try to find a partial match
                    ALMLogUtils.log('ActivateUser','Did not find matching users without stripping of leading 0s !!!!');
                    String mkrtActKeyInt = market.Market_Id__c+'%'+acctNbrInt+'%';
                    ALMLogUtils.log('ActivateUser','mkrtActKey='+mkrtActKey);
                    ALMLogUtils.log('ActivateUser','mkrtActKeyInt='+mkrtActKeyInt);
                    matchingUsers = [       select  id, IsActive,Name,GI3_Email__c,ACCT_NR__c,
                                                                CDW_STS_CD__c,Profile.Name,FirstName,
                                                                LastName,LanguageLocaleKey
                                                        from    User
                                                        where   MRKT_ID__c=:market.Market_Id__c
                                                        and     (MRKT_ID_ACCT_NR_KEY__c like :mkrtActKey or 
                                                                MRKT_ID_ACCT_NR_KEY__c like :mkrtActKeyInt or
                                                                FederationIdentifier like :mkrtActKeyInt)
                                                    ];
                }
                
                //If there are still no matching users, then display activation failure message
                if(matchingUsers.isEmpty()){
                    if(debugFlag.equalsIgnoreCase('1')){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No matching users found for account#'+acctNbr +' in '+this.market.Name));
                    }
                    
                    stsMsg=this.stsMsgMap.get(ACTIVATION_FAILED);
                    if(stsMsg==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.User_Activation_Failure));
                    }
                    this.isFailure= true;
                }else if(matchingUsers.size()>1){
                    if(debugFlag.equalsIgnoreCase('1')){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Multiple users found for account#'+acctNbr +' in '+this.market.Name));
                    }
                    //If there are multiple matching users, then display activation failure message
                    stsMsg=this.stsMsgMap.get(ACTIVATION_FAILED);
                    if(stsMsg==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.User_Activation_Failure));
                    }
                    this.isFailure= true;
                }else{
                    this.currUsr= matchingUsers[0];
                    //ALM+ modification by Snehashis
                    if(pgidVal!=null && this.market.Is_ALMPLUS_Enabled__c){
	                        User_Login_Param__c ulp = new User_Login_Param__c(User_Id__c=this.currUsr.Id, 
	    	                                  Page_Id__c=pgidVal, Is_My_Lead__c=true);
	    	                 try{
	    	                 	System.debug('Upsert User Login param!!!!'+ulp);
								upsert ulp User_Id__c;
							}catch(Exception ex){
								System.debug('Not able to insert error record from ActivateUserController!!!!');
							}            
                    }
                    if(!this.currUsr.IsActive && (this.currUsr.CDW_STS_CD__c=='Active' || this.currUsr.CDW_STS_CD__c=='Consented')){
                        //For Argentina, only if they are "Consented" should the be allowed to activate their license
                        //Create activation request if the user is "inactive" and CDW Status is "Active"
                        ALMLogUtils.log('ActivateUserController','Real_time_Activation_Enabled='+globalConfig.Real_Time_Activation_Enabled__c);
                        if(globalConfig.Real_Time_Activation_Enabled__c){
                        	activateUser(this.currUsr.Id);
                        }
                        Request_Handler__c activationReq = new Request_Handler__c(    ALM_User__c=this.currUsr.Id,
                                                                                    Status__c=(globalConfig.Real_Time_Activation_Enabled__c?'Realtime-Activation':'New'),
                                                                                    Type__c='User Activation Request',
                                                                                    First_Name__c=this.currUsr.FirstName,
                                                                                    Last_Name__c=this.currUsr.LastName,
                                                                                    ALM_User_Email__c=this.currUsr.GI3_Email__c,
                                                                                    Language__c=this.currUsr.LanguageLocaleKey);
                        insert activationReq;
                        if(globalConfig.Real_Time_Activation_Enabled__c){
	                        PageReference pageRef = new PageReference(getSSOURL());
	                        return pageRef;
                        }else{
	                        stsMsg = this.stsMsgMap.get(ACTIVATION_SUCCESS);
	                        if(stsMsg==null){
	                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.User_Activation_Success));
	                        }
                        	return null;
                        }
                        
                    }else if(this.currUsr.IsActive && (this.currUsr.CDW_STS_CD__c=='Active' || this.currUsr.CDW_STS_CD__c=='Consented')){
                        //For Argentina, only if they are "Consented" should the be allowed to go through
                        //If the user is already active, re-direct them to the SSO URL.
                        System.debug('>>>>getSSOURL()'+getSSOURL());
                        PageReference pageRef = new PageReference(getSSOURL());
                        return pageRef;
                   }else{
                        if(debugFlag.equalsIgnoreCase('1')){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'CDW Status is '+currUSr.CDW_STS_CD__c+' for account#'+acctNbr +' in '+this.market.Name));
                        }
                        
                        stsMsg=this.stsMsgMap.get(ACTIVATION_FAILED);
                        if(stsMsg==null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.User_Activation_Failure));
                        }
                        this.isFailure= true;
                    }   
                }
            }else{
                if(debugFlag.equalsIgnoreCase('1')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'MD5 key not matching !!!. Key before MD5 encryption:"'+(mktId+acctNbr+System.now().format(DATE_FORMAT))+'[XXXXXXXXXX]" or "'+(mktId+acctNbr+System.now().addDays(1).format(DATE_FORMAT))+'[XXXXXXXXXX]", Received:'+md5Param));
                }
                stsMsg=this.stsMsgMap.get(ACTIVATION_FAILED);
                if(stsMsg==null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.User_Activation_Failure));
                }
                this.isFailure= true;
            }
        }catch(Exception ex){
            this.isFailure= true;
            if(debugFlag.equalsIgnoreCase('1')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Unknown error occurred .Error Message='+ex.getMessage()));
            }
            ALMLogUtils.log('ActivateUser','Exception thrown requesting user license activation:'+ex.getMessage());
            stsMsg=this.stsMsgMap.get(ACTIVATION_FAILED);
            if(stsMsg==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.User_Activation_Failure));
            }
        }
        ALMLogUtils.log('ActivateUserController','stsMsg='+stsMsg);
        return null;
    }
    private String getSSOURL(){
        String retUrl = market.GI3_Keep_Alive_URL__c;
        if(this.currUsr.Profile.Name=='Avon Leader'){
            retUrl+=AVON_LEADER_SUITE;
        }else if(this.currUsr.Profile.Name.contains('Zone')){
            retUrl+=AVON_ZM_SUITE;
        }else if(this.currUsr.Profile.Name.contains('Division')){
            retUrl+=AVON_DM_SUITE;
        }else{
            retUrl+='';
        }
        ALMLogUtils.log('ActivateUserController.getSSOUrl()','Profile:'+this.currUsr.Profile.Name+',retURL='+retUrl);
        return retUrl;
    }
    
    public static testmethod void testActivateAccess(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        globalConfig.Real_Time_Activation_Enabled__c=false;
        update globalconfig;
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        System.assert(ApexPages.getMessages().isEmpty());
		ActivateUserController.testMode=true;
        pageRef = ctlr.activateALMAccess();
        System.assert(ApexPages.getMessages().size()==1);
    }

	public static testmethod void testALMPLusActivateAccess(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.Eligibility_No_Flags__c='ZM_Override__c;Out_of_Office__c';
        market.Eligibility_Yes_Flags__c='Opt_In__c';
        market.Title_Exclusion__c='0;-2';
        market.Is_ALMPLUS_Enabled__c=true;
        market.LeadMandatoryFields__c = 'User_Type__c,FirstName,LastName,Day__c,Month__c,Year__c,Geo_Level_1__c,Geo_Level_2__c,Geo_Level_3__c, Geo_Level_4__c, MobilePhone,PostalCode';
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        globalConfig.Real_Time_Activation_Enabled__c=true;
        update globalconfig;
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        pageRef.getParameters().put(PGID,ALMPLusConstants.HOTLEAD_PGID_VALUE);
        System.debug('>><><>>'+pageRef.getUrl());
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        System.assert(ApexPages.getMessages().isEmpty());
		ActivateUserController.testMode=true;
        pageRef = ctlr.activateALMAccess();
        System.assert(ApexPages.getMessages().size()==0);
        List<User_Login_Param__c> ulpList = [Select id,Is_My_Lead__c,User_Id__c from User_Login_Param__c where User_Id__c=:ldrUsr.Id and Page_Id__c=:ALMPLusConstants.HOTLEAD_PGID_VALUE];
        System.assert(ulpList.size()==1);
        System.assert(ulpList[0].Is_My_Lead__c==true);
    }
    
    public static testmethod void testActivateAccessRealtime(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        globalConfig.Real_Time_Activation_Enabled__c=true;
        update globalConfig;
        system.debug('>>>>>>> globalConfig ~~~'+globalConfig);
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        System.assert(ApexPages.getMessages().isEmpty());
		ActivateUserController.testMode=true;
        pageRef = ctlr.activateALMAccess();
        System.assert(pageRef.getUrl().indexOf(AVON_LEADER_SUITE)>-1);
    }
    
    public static testmethod void testActivateAccessActiveUser(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=true;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        System.assert(ApexPages.getMessages().isEmpty());

        pageRef = ctlr.activateALMAccess();
        System.assert(pageRef.getUrl()==market.GI3_Keep_Alive_URL__c+AVON_LEADER_SUITE);
    }
    
    public static testmethod void testActivateAccessRemovedUser(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=true;
        ldrUsr.CDW_STS_CD__c='Removed';
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(DEBUG,'1');
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        System.assert(ApexPages.getMessages().isEmpty());
        pageRef = ctlr.activateALMAccess();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        ALMLogUtils.log('ActiveUserController.testRemovedUser',''+msgs.size());
        System.assert(msgs.size()==2);
        System.assert(msgs[1].getSummary()==System.Label.User_Activation_Failure);
    }
    
    public static testmethod void testActivateAccessZM(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User testUsr = testData.createZoneUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        testUsr = [Select   Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :testUsr.Id];        
        testUsr.IsActive=true;
        testUsr.CDW_STS_CD__c='Active';
        update testUsr;
        List<Market_Content__c> mktCont2Insrt = new List<Market_Content__c>();
        Market_Content__c mktContent = new Market_Content__c(   Type__c=ACTIVATION_FAILED,Content__c='Failed',
                                                                User_Type__c='All',Title_Levels__c='All',
                                                                Name='Activation-Failed',Market__c=testData.market.Id);
        mktCont2Insrt.add(mktContent);
        mktContent = new Market_Content__c( Type__c=ACTIVATION_SUCCESS,Content__c='Success',
                                            User_Type__c='All',Title_Levels__c='All',       
                                            Name='Activation-Success',Market__c=testData.market.Id);
        mktCont2Insrt.add(mktContent);
        insert mktContent;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();

        pageRef = ctlr.activateALMAccess();
        System.assert(pageRef.getUrl()==market.GI3_Keep_Alive_URL__c+AVON_ZM_SUITE);
    }
    
    public static testmethod void testActivateAccessDM(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User testUsr = testData.createDivUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        market.GI3_Keep_Alive_URL__c='https://www.avon.com';
        update market;
        testUsr = [Select   Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :testUsr.Id];        
        testUsr.IsActive=true;
        testUsr.CDW_STS_CD__c='Active';
        update testUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();

        pageRef = ctlr.activateALMAccess();
        System.assert(pageRef.getUrl()==market.GI3_Keep_Alive_URL__c+AVON_DM_SUITE);
        
    }
    public static testmethod void testActivateAccessInvalidKey(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        ldrUsr.CDW_STS_CD__c='Active';
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(KEY,'123456');
        pageRef.getParameters().put(DEBUG,'1');
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size()==2);
        System.assert(msgs[1].getSummary()==System.Label.User_Activation_Failure);
        
    }

    public static testmethod void testActivateAccessNonNumericAcct(){
        String acctNbr = '123456X';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ldrUsr.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size()==1);
        System.assert(msgs[0].getSummary()==System.Label.User_Activation_Failure);
        
    }
    
            
   public static testmethod void testActivateAccessInvalidAcctNbr(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,'9'+acctNbr);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(DEBUG,'1');
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+'9'+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size()==2);
        System.assert(msgs[1].getSummary()==System.Label.User_Activation_Failure);
    }
    
    public static testmethod void testActivateAccessException(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        Market__c market = testData.market;
        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
        ldrUsr = [Select    Id,Username,FirstName,LastName,Name,MRKT_TAG_1_HDR_TXT__c, MRKT_ID__c,  USER_CNTRY_CD__c,
                                LanguageLocaleKey,MRKT_ID_ACCT_NR_KEY__c,
                                DFALT_ZONE_CD__c, DFALT_DIV_NM__c,Profile.Name
                        From User
                        where Id = :ldrUsr.Id];     
        ldrUsr.IsActive=false;
        update ldrUsr;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(ACCT_NR,'9'+acctNbr);
        pageRef.getParameters().put(MRKT_ID,'YY');
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = 'YY'+'9'+acctNbr+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));
        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size()==1);
        System.assert(msgs[0].getSummary()==System.Label.User_Activation_Failure);
    }

    
    public void activateUser(Id usrToUpdate){
    

        Http h = new Http();
        if(!testMode){
        HttpRequest req = new HttpRequest();
        Blob aesKey = EncodingUtil.base64Decode(AES_PRIVATE_KEY);
        String loginEndpoint =this.globalConfig.Login_Endpoint__c;
        Blob encUsername = EncodingUtil.base64Decode(globalConfig.Activation_Username__c);
        Blob encPassword = EncodingUtil.base64Decode(globalConfig.Activation_Key__c);
		String uName=Crypto.decryptWithManagedIV(ALGO_NAME, aesKey, encUsername).toString();       
		String passwd=Crypto.decryptWithManagedIV(ALGO_NAME, aesKey, encPassword).toString();
        String loginReq = '<?xml version="1.0" encoding="utf-8" ?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"> <env:Body><n1:login xmlns:n1="urn:partner.soap.sforce.com"><n1:username>'+uName+'</n1:username><n1:password>'+passwd+'</n1:password></n1:login></env:Body></env:Envelope>';
        req.setBody(loginReq);
        req.setHeader('Content-Type','text/xml');
        req.setHeader('SOAPAction','login');
        req.setEndpoint(loginEndpoint);
        req.setMethod('POST');
        System.debug('>>>>>>>>>>>>>>>>>Logging In now');
        HttpResponse res; 
        	
       // if(!testMode){
        	res = h.send(req);
	        System.debug('>>>>>>>>>>>>>>>>>Login response');
	        String loginRes = res.getBody();
	        String SESSION_ID='<sessionId>';
	        Integer startIndex = loginRes.indexOf(SESSION_ID);
	        startIndex+=SESSION_ID.length();
	        Integer endIndex= loginRes.indexOf('</',startIndex);
	        String sessionId =loginRes.substring(startindex,endIndex);
	        //String sessionId =Userinfo.getSessionId();
	        System.debug('>>>>>>>>>>>>>>>>>Session Id:'+sessionId);
	        
	        String updateEndpoint=globalConfig.API_Endpoint_Base_URL__c+'/sobjects/User/'+usrToUpdate+'?_HttpMethod=PATCH';
	        req = new HttpRequest();
	        req.setEndpoint(updateEndpoint);
	        req.setMethod('POST');
	        
	        String updateReq = '{"IsActive" : true}';
	        
	        req.setHeader('Authorization','OAuth '+sessionId);
	        req.setHeader('X-PrettyPrint','1');
	        req.setHeader('Content-Type','application/json');
	        req.setBody(updateReq);
	        res = h.send(req);
	        System.debug('>>>>>>>>>>>>>>>>>> User Update Response ='+res.getBody());
        }
        
        
    }
   //@S-144891 : Commented by Blaine Rothrock on Nov 23 
   /*public static testmethod void testActivateAccessMultipleUserAcctNbr(){
        String acctNbr = '123456';
        TestDataHelper testData = new TestDataHelper();
        User ldrUsr = testData.createLeaderUser(acctNbr);
        ldrUsr.FederationIdentifier=testData.market.Market_Id__c+'1234567';
        update ldrUsr;
        User ldrUsr1 = testData.createLeaderUser('1234567');
        Market__c market = testData.market;


        market.ASLF_Market_Id__c=market.Market_Id__c;
        update market;
        PageReference pageRef = Page.ActivateUser;
        pageRef.getParameters().put(LANG_CD,'en_US');
        pageRef.getParameters().put(ACCT_NR,ldrUsr1.ACCT_NR__c);
        pageRef.getParameters().put(MRKT_ID,testData.market.Market_Id__c);
        pageRef.getParameters().put(DEBUG,'1');
        String dateStr = System.now().format(DATE_FORMAT);
        ALM_Global_Settings__c globalConfig = ALM_Global_Settings__c.getValues('ALM Default');
        String SHARED_SECRET = globalConfig.Shared_Secret__c;           
        String toHash = testData.market.Market_Id__c+ldrUsr1.ACCT_NR__c+dateStr+SHARED_SECRET;
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        pageRef.getParameters().put(KEY,EncodingUtil.convertToHex(hash));


        Test.setCurrentPageReference(pageRef);
        ActivateUserController ctlr = new ActivateUserController();
        ctlr.activateALMAccess();
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size()==2);
        System.assert(msgs[1].getSummary()==System.Label.User_Activation_Failure);
    }*/
}