/***************************************************************************
 Name         : Test_BatteryChartParams
 Created By   : Saurabh Gupta (JDC)
 Description  : Test class for BatteryChartParams
 Created Date : Oct. 29, 2013                
****************************************************************************/

@isTest
private class Test_BatteryChartParams {
	
	//----------------------------------------------------------------------------
    // Method Name  : testBatteryChartParams
    // Description  : Method for Test Coverage of Class : BatteryChartParams
    //----------------------------------------------------------------------------  
    public static testmethod void testBatteryChartParams() {
    	BatteryChartParams defBattChar = new BatteryChartParams();
    	System.assertEquals(defBattChar.getRoundingCoef(), 0);
    	
    	BatteryChartParams battChar = new BatteryChartParams(15, 15, 15);
    	
    	battChar = new BatteryChartParams(1, 1, 0);
    	battChar.round(1);
    }
}