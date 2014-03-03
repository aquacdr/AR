public class OmnitureWebTrackController {
  public String userTypeInput {get; set;}   //parameter is passed as an attribute to the component
  public String userTitleInput {get; set;}  //parameter is passed as an attribute to the component
  public String mktNameInput {get; set;} //added by comity 3/14/2013 resolving issue with "Insufficient privileges"
  public String mktAcctKeyInput {get; set;} //added by comity 3/14/2013 resolving issue with "Insufficient privileges"
  //map of profile name -> user type
  public Map<String,String> profileNameToUserType {
    get{
      if(profileNameToUserType == null){
        profileNameToUserType = new Map<String,String>();
        profileNameToUserType.put(ALMPlusConstants.AVON_LEADER, ALMPlusConstants.AVON_LEADER_PROFILE_ALIAS);
        profileNameToUserType.put(ALMPlusConstants.AVON_ZM, ALMPlusConstants.AVON_ZONE_MANAGER_PROFILE_ALIAS);
        profileNameToUserType.put(ALMPlusConstants.AVON_DM, ALMPlusConstants.AVON_DIVISION_MANAGER_PROFILE_ALIAS);
        profileNameToUserType.put(ALMPlusConstants.AVON_CS_AGNT, 'CSA');
        profileNameToUserType.put(ALMPlusConstants.AVON_CS_SUPR, 'CSS');
        profileNameToUserType.put(ALMPlusConstants.AVON_SYS_ADM,'SA');
      }
      return profileNameToUserType;
    }
    set;
  }
  //user type used by omniture
  public String userTypeOutput{
    get{
      if(profileNameToUserType.get(userTypeInput) != null)
        userTypeOutput = profileNameToUserType.get(userTypeInput);
      else
        userTypeOutput = '';
      return userTypeOutput; 
    }
    set;
  }
  //user title used by omniture
  public String userTitleOutput{
    get{
      if(userTypeInput == ALMPlusConstants.AVON_LEADER)   //if user is SL title is LDRSHP_TITL_LVL_NBR__c
        userTitleOutput = userTitleInput;        
      else
        userTitleOutput = userTypeOutput;        //otherwise same as user type
      
      return userTitleOutput; 
    }
    set;
  } 
  //testmethod  
  //@S-144891 : Commented by Blaine Rothrock on Nov 23 
/*static testMethod void testOmnitureWebTrackController() {
        OmnitureWebTrackController contr = new OmnitureWebTrackController();
        contr.userTitleInput = '0';
        //test for SL
        contr.userTypeInput = ALMPlusConstants.AVON_LEADER;
        System.assertEquals(contr.userTypeOutput, ALMPlusConstants.AVON_LEADER_PROFILE_ALIAS);
        System.assertEquals(contr.userTitleOutput, contr.userTitleInput);
        //test for ZM
        contr.userTypeInput = ALMPlusConstants.AVON_ZM;
        System.assertEquals(contr.userTypeOutput, ALMPlusConstants.AVON_ZONE_MANAGER_PROFILE_ALIAS);
        System.assertEquals(contr.userTitleOutput, contr.userTypeOutput);
    }*/

}