public class ASLFReportsController {
    public String repAcctNbr {get; set;}
    public Market__c market {get; private set;}
    public String usrLangCd {get; set;}
    public String dateStr {get; set;}
    public String md5Key {get; private set;}
    private static final String ASLF_SECRET_KEY='abcdefgh';
    //subhamay 12142011
    private List<Gi3_Language_Mapping__c> listGi3Lang;
    //eoc subhamay 12142011
    public String getInitialize(){

        User currUsr =  [   select  ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c,
                                    MRKT_ID__c,LanguageLocaleKey
                            from    User
                            where   Id = :UserInfo.getUserId()];
    
        this.market = [ select  Name,ASLF_Report_Url__c,ASLF_Market_Id__c,
                                ASLF_Timezone_Offset__c,Campaign_Report_Override_URL__c
                        from Market__C
                        where Market_Id__c=:currUsr.MRKT_ID__c];
        //subhamay 12142011
        System.debug('\n @@@@@@ currUsr.LanguageLocaleKey '+currUsr.LanguageLocaleKey);
        /*
        if(currUsr.LanguageLocaleKey.startsWith('en_')){
            usrLangCd = 'en';   
        }else{
            usrLangCd = currUsr.LanguageLocaleKey;  
        }*/
        listGi3Lang = [select Name, Gi3_Lang_code__c from Gi3_Language_Mapping__c where Gi3_Lang_code__c =: currUsr.LanguageLocaleKey];
        System.debug('\n @@@@@@ listGi3Lang size '+listGi3Lang.size());
        
        for(Gi3_Language_Mapping__c objGi3Lang : listGi3Lang) {
            System.debug('Name: '+objGi3Lang.Name+', SFDC Lang code: '+objGi3Lang.Gi3_Lang_code__c);
            usrLangCd = objGi3Lang.Name;
        }
        //eoc subhamay 12142011
        DateTime currDt = System.Now();
        System.debug('>>>>>>>>>>>>>>>>>>>>> currDt='+currDt);
        currDt = currDt.addHours(((Decimal)this.market.ASLF_Timezone_Offset__c).intValue());
        System.debug('>>>>>>>>>>>>>>>>>>>>> after offset currDt='+currDt);
        this.dateStr = currDt.format('MM/dd/yyyy');
        System.debug('>>>>>>>>>>>>>>>>>>>>> after offset currDt='+dateStr);                 
        String toHash = this.repAcctNbr+this.dateStr+ASLF_SECRET_KEY;
        System.debug('toHash-->'+toHash);
        Blob blobValue = Blob.valueOf(toHash);
        Blob hash = Crypto.generateDigest('MD5', blobValue);
        this.md5Key= EncodingUtil.convertToHex(hash);
        System.debug('MD5:' + this.md5Key); 
        return '';  
    } 
    
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testASLFReports(){
      //  ASLFReportsController ctlr = new ASLFReportsController();
      //  ctlr.repAcctNbr = '123456';
      	String mktIdKey = 'XX';
      	
        TestDataHelper testData = new TestDataHelper();
        
        Market__c mrkt = testData.createMarket();
        
        User ldrUsr = testData.createLeaderUser('mktIdKey');
        
        mrkt.OwnerId = ldrUsr.Id;
        update  mrkt;
        
        System.runAs(ldrUsr){
        	
        	ASLFReportsController ctlr = new ASLFReportsController();
        	
            ctlr.getInitialize();
            System.debug('>>>>>>>>>> Market URL:'+ctlr.market.ASLF_Report_URL__c);
            Datetime currDt= System.now();
            
            Gi3_Language_Mapping__c g1LangMap1 = new Gi3_Language_Mapping__c(Name = 'en_PH', Gi3_Lang_code__c='en_US');
            insert g1LangMap1;
            
            g1LangMap1.OwnerId = ldrUsr.Id;
            update  g1LangMap1;
            
            System.assert(ctlr.dateStr==currDt.format('MM/dd/yyyy'));   
            System.debug('\n @@@@@@@@@@ ctlr.usrLangCd >> '+ctlr.usrLangCd);
           // System.assert(ctlr.usrLangCd=='en_US');
            
            ldrUsr.LanguageLocaleKey='fr';
            update ldrUsr;
            
            ctlr.getInitialize();
            
            //System.assert(ctlr.usrLangCd=='fr');
                
        }   
    }*/
}