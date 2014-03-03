public class ALMLogUtils {
	
	//Block 1: Added by barkha @T-229707
	public static ApexLogSettings__c logSetting = ApexLogSettings__c.getInstance('Default');
	
	public static void log(String message){
		if(logSetting.Active__c){
			ErrorHandler.handleError(message);
		}
	}
	
	public static void log(Exception ex){
		if(logSetting.Active__c){
			ErrorHandler.handleError(ex.getMessage());
		}
	}
	
	public static void log(String srcPage, Exception ex){
		if(logSetting.Active__c){
			ErrorHandler.handleError(srcPage, ex);
		}
	}
	//Block 1: End
	
	public static void log(String source, String message){
		System.debug('>>>>>>>>>>>>>>>> '+source+'>>>>>>>>>>>'+message);
	}
}