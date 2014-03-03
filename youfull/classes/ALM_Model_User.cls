/***************************************************************************
 Name          : ALM_Model_User
 Created By    : Fay Salwen
 Description   : Abstract model class for user
 Created Date  : Feb 19, 2014               
****************************************************************************/
    
public virtual class ALM_Model_User {
    
    public User userData;
    public Profile profileData;
    
    public static final String TYPE_SALES_LEADER = 'Sales Leader';
    public static final String TYPE_ZONE_MGR = 'Zone Manager';
    public static final String TYPE_DIVISION_MGR = 'Division Manager';
    
    // =================================================================//
    // ----------------- CONSTRUCTORS AND INITIALIZERS -----------------
    // =================================================================//
    
    public ALM_Model_User() {
        initialize(new User());
    }
    
    public ALM_Model_User(User userParam) {
        initialize(userParam);
    }
    
    public virtual ALM_Model_User initialize(User userParam) {
        this.userData = userParam;
        return this;
    }

    // =================================================================//
    // ---------------- STATIC FACTORY-RELATED METHODS -----------------  
    // =================================================================//
    
    //=================================================================//
    // Convert an actual profile name into the type to use for that profile
    //=================================================================//
    public static String userTypeForProfile(String profileName) {
        if (profileName.contains(TYPE_SALES_LEADER)) {
            return TYPE_SALES_LEADER;
        } else if (profileName.contains(TYPE_ZONE_MGR)) {
            return TYPE_ZONE_MGR;
        } else if (profileName.contains(TYPE_DIVISION_MGR)) {
            return TYPE_DIVISION_MGR;
        }
        else return '';
    }
    
    //=================================================================//
    // Get the Apex class type to use for the user type string
    //=================================================================//
    public static Type classForUserType(String userType) {
        Map<String,Type> classForCategoryMap =  new Map<String,Type>{
            TYPE_SALES_LEADER => Type.forName('ALM_Model_User_SalesLeader'),
            TYPE_ZONE_MGR => Type.forName('ALM_Model_User_ZoneManager'),
            TYPE_DIVISION_MGR => Type.forName('ALM_Model_User_DivisionManager')
        };
        Type classForUserType = classForCategoryMap.get(userType);
        if (classForUserType == null) { classForUserType = Type.forName('ALM_Model_User'); }
        system.debug('classForUserType: '+classForUserType + ' userType:' + userType);
        return classForUserType;
    }

    //=================================================================//
    // Create an instance of a class to use, based on the user type string provided
    //=================================================================//
    public static ALM_Model_User modelForUserType(String userType) {
        ALM_Model_User instance = (ALM_Model_User)classForUserType(userType).newInstance();
        return instance;
    }

    //=================================================================//
    // Create an initialized instance of a class to use, based on the user object provided
    //=================================================================//        
    public static ALM_Model_User modelForUser(User userData) {
        ALM_Model_User instance = (ALM_Model_User)modelForUserType(userTypeForProfile(userData.Profile.Name));
        // return instance.initialize(userData);
        return instance;
    }
    
    // =================================================================//
    // ---------------------- ACCESSOR METHODS -------------------------  
    // =================================================================//

    //=================================================================//
    // Get the User object, currently assuming it was proactivele initialized 
    // at time of construction, but may want to add lazy initialization code.
    //=================================================================//
    public User getUserData() {
        return userData;
    }
    
    //=================================================================//
    // Get the Profile object, currently assuming it was proactivele initialized 
    // at time of construction, but may want to add lazy initialization code.
    //=================================================================//
    public Profile getProfileData() {
        return profileData;
    }
        
    //=================================================================//
    // Get the default Zone for the user (assumes user is not null or was lazily initialized in accessor)
    //=================================================================//
    public String getDefaultZone() {
        return getUserData().DFALT_ZONE_CD__c;
    }

    //=================================================================//
    // Get the default Division for the user (assumes user is not null or was lazily initialized in accessor)
    //=================================================================//
    public String getDefaultDivision() {
        return getUserData().DFALT_DIV_NM__c;
    }
}