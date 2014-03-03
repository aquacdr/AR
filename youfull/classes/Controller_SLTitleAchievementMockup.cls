/***************************************************************************
 Name          : Controller_SLTitleAchievementMockup 
 Description   : Demo version of Title Achievement dashboard
 Created By    : Fay Salwen 
 Created Date  : Dec 19, 2013                
****************************************************************************/

public with sharing class Controller_SLTitleAchievementMockup {
    
    //Store the image   
    public String image {get;set;}
    
    //===================================================================//
    //Constructor
    //===================================================================//
    public Controller_SLTitleAchievementMockup () {
        try{
            //Select the content from ContentVersion 
            ContentVersion content = [SELECT Id, Title, VersionData, IsLatest
                            FROM ContentVersion where Title = 'TitleAchievementMockup' limit 1];
            System.debug('*****content*****'+content);
    
            //Encode the VersionData for display                        
            image = EncodingUtil.base64Encode(content.VersionData);
            System.debug('*****image*****'+image);
        }catch(Exception ex){
            ALMLogUtils.log(ex);
        }               
    }
    
}