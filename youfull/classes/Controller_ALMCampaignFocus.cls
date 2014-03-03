/***************************************************************************
 Name          : Controller_ALMCampaignFocus 
 Created By    : Parul Gupta
 Created Date  : Dec 12, 2013 
 Description   : Copy of ZM_CampaignFocusController             
****************************************************************************/
public class Controller_ALMCampaignFocus{

    public List<contentversion> contents{get;set;}
    public List<WrapperImageInfo> lstWImageInfo{get;set;}    
    public String strProfileName;
    public String campaignnumber {get;set;}
    private String source;
    

    // Constructor
    public Controller_ALMCampaignFocus(){
    
        try{ 
            // Initialize prerequisites 
            lstWImageInfo= new List<WrapperImageInfo> ();
            system.debug(ApexPages.currentPage().getParameters().get('source') );
            String sourceParam = ApexPages.currentPage().getParameters().get('source');
            if (sourceParam != null) {
                system.debug('Source parameter is: ' + sourceParam);
                source = sourceParam;
            } else {
                source = 'home';
            }
    
            Id IdUserProfile = UserInfo.getProfileId();
    
            Util_ZoneManager objutilityclass= new Util_ZoneManager();
            objutilityclass.SetVariable();
    
            strProfileName = objutilityclass.strProfileName;       
            contents = new List<contentversion>();
    
            system.debug('Campaign Id = '+ objutilityclass.strCurrentCmpgnNR);
            
            // IF User is an Administrator
            if(strProfileName.contains('Admin') && ApexPages.currentPage().getParameters().get('campaign')!=null){
                campaignnumber = ApexPages.currentPage().getParameters().get('campaign');
            }
            // Else User may be Zone Manager, Division Manager
            else{
                // T-210187 - Added by Parul - If a market is a mailplan market,
                // Selling Campaign Focus should be displayed
                if(objutilityclass.isMailPlanEnabled && !objutilityclass.isAccessToMultipleZones
                && objutilityclass.strMailPlanCmpgnNR != null){
                    campaignnumber = objutilityclass.strMailPlanCmpgnNR;                                                
                }else{
                    campaignnumber  = objutilityclass.strCurrentCmpgnNR;
                }
            }
            system.debug('campaignnumber =' + campaignnumber);
                        
            // Populates wrapper records
            populateWrapperImageInfo();
            
        }catch (Exception e){
            system.debug(e.getMessage());
        }
    }
    
     public void setSource(String newSource) {
        source = newSource;
        System.debug('New source = ' + newSource);
        populateWrapperImageInfo();
    }
    
    // Method gets all contents for the CampaignNumber 
    // and populates Wrapper Object List
    private void populateWrapperImageInfo(){
                            
        contents = [select id, versiondata, pathonclient,Page__c, Position__c, url__c
                        from ContentVersion where Page__c = :source 
                        AND FLD_SLS_CMPGN_NR__c = :campaignnumber  
                        AND IsLatest = true order by Position__c];  
           
        System.Debug('contents' + contents.size());
        if(contents.size()>0){
            for(contentversion content:contents){
                system.debug('records only = '+content.pathonclient);
                WrapperImageInfo objWImageInfo=new WrapperImageInfo(EncodingUtil.base64Encode(content.versiondata),content.Url__c);
                lstWImageInfo.add(objWImageInfo);
            }
        }
    }
    
    
    // New Method - Omniture Addition
    public String getOmniturePageName()      
    {  
        return ALMPlusUtils.generateOmniturePageName('ZM_CampaignFocus', null, strProfileName);         
    } //this is for getting page name mapping for omniture

    public class WrapperImageInfo{
        public string imageData{get;set;}
        public string strURL{get;set;}
        public WrapperImageInfo( string imageTempDate, string strTempURL){
            imageData=  imageTempDate;
            strURL=strTempURL;
        }
        
    }
    
    //@T-214186 : Commented by Barkha Jain on Nov 21
   /* @isTest
    static void runTest()
    {
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL = 'http://www.google.com';
        contentVersionObj.title = 'Google';
        
        
        insert contentVersionObj;
        
        PageReference ref = Page.ZM_CampaignFocus;
        ref.getParameters().Put('source', '');
        //ref.getParameters().Put('campaign', '62');
        Test.setCurrentPage(ref);
        
        ZM_CampaignFocusController ctl = new ZM_CampaignFocusController();
        ZM_CampaignFocusController.WrapperImageInfo x = new ZM_CampaignFocusController.WrapperImageInfo('x','y');
        ///*
          XCEPTION_THROWN|[81]|System.DmlException: Insert failed. First exception on row 0; first error: FIELD_INTEGRITY_EXCEPTION, You cannot set custom fields or tags on a document published into a personal library. Fields set: Position,Url,Page: []
          22:25:09.320 (4320468000)|FATAL_ERROR|System.DmlException: Insert failed. First exception on row 0; first error: FIELD_INTEGRITY_EXCEPTION, You cannot set custom fields or tags on a document published into a personal library. Fields set: Position,Url,Page: []
       // 
        
        
    }  */
}