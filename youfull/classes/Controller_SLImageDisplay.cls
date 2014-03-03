/***************************************************************************
 Name          : Controller_SLImageDisplay 
 Description   : Controller used by pages/components that display images
 Created By    : Fay Salwen 
 Created Date  : Dec 19, 2013                
****************************************************************************/

public with sharing class Controller_SLImageDisplay {
    
    //Store the image   
    public String image {get;set;}
    
    //===================================================================//
    //Constructor
    //===================================================================//
    public Controller_SLImageDisplay () { }
    
    //===================================================================//
    //Set the title of the image content from the component
    //===================================================================//     
    public void setContentTitle(String contentTitle) {
        try{
            //Select the content from ContentVersion, using the title parameter
            ContentVersion content = [SELECT Id, Title, VersionData, IsLatest
                            FROM ContentVersion where Title = :contentTitle limit 1];
                            
            System.debug('*****content*****'+content);
    
            //Encode the VersionData for display                        
            image = EncodingUtil.base64Encode(content.VersionData);
            System.debug('*****image*****'+image);
        }catch(Exception ex){
            ALMLogUtils.log(ex);
        }
    }
    
}