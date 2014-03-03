public class MyTeamReportPageController {
    
    public String repDetailAcctNbr {get; set;} 
    
    public String searchText {get;set;}    
    
    public Boolean isLeader {get; set;}
    
    public MyTeamReportPageController() {  
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');  //Added By Swarnava for IE9 Print Issue
        User loggedInUser = [   SELECT Profile.Name, Name, Id, ACCT_NR__c, MRKT_ID__c, LanguageLocaleKey,LocaleSidKey, LDRSHP_TITL_LVL_NBR__c ,MRKT_ID_ACCT_NR_KEY__c
                                FROM User
                                WHERE Id=:UserInfo.getUserId() LIMIT 1];    
        this.isLeader = (loggedInUser.Profile.Name == ALMPlusConstants.AVON_LEADER);
    }
    
    //added by Snehashis
    public PageReference callRepDetails(){ 
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr'); 
        return null; 
    } 
    

    // ADDED BY Vijay Mittal FOR SEARCH COMPONENT POPUP WINODOW
    public Pagereference saveSearchText() {
        searchText = Apexpages.currentPage().getParameters().get(ALMConstants.SEARCH_URL_PARAM);
        return null;
    }
    // CHNAGES BY Vijay Mittal ENDS HERE

    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*private static testMethod void testMTRPageController(){
        PageReference mtrPage = Page.MyTeamReport;
        Test.setCurrentPageReference(mtrPage);
        ApexPages.currentPage().getParameters().put('repDetailAcctNbr', 'value');
        MyTeamReportPageController mtrpc = new MyTeamReportPageController();
        System.assertEquals(mtrpc.callRepDetails(), null);      
        System.assertEquals(mtrpc.repDetailAcctNbr, 'value');
    }*/

}