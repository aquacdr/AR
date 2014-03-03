/*
** Apex Class/Controller Name           : BatteryChardParams
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Incapsulate parameters of Battery Chart used in Title Achievement and other components/pages
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** March, 10 Created. comity
** 
*/

public class BatteryChartParams {
	
    public Integer actualPerformance {get; set;} 
    public Integer rightBorder {get; set;} 
    public Integer differenceTargetActual {get; set;}
    public Integer halfTarget {get; set;}
    public Integer invoiced {get; set;}
    public Integer goal {get; set;}
    public Integer submitted {get; set;}
    public String color {get; set;}
    
    private Integer roundingCoef;
    
    
    //input params: invoiced, submitted, goal
    public BatteryChartParams(Integer n1, Integer n2, Integer n3) {
    	if (n1 != null && n2 != null && n3 != null) {
        	setRoundingCoef(n1, n2, n3);
    	}
    }
    
    public BatteryChartParams() {
    	this.roundingCoef = 0;
    }
    
    public Integer getRoundingCoef() {
    	return this.roundingCoef;
    }
    
    //input params: invoiced, submitted, goal
    public void setRoundingCoef(Integer number1, Integer number2, Integer number3 ) {
    	if ((number1 == null || number2 == null) ||
    	         (number3 == null || number3 == 0)) { 
    	            	
            this.roundingCoef = 0;
    		//throw new InvalidBatteryNumberException();
    	}
    	
    	Integer n1 = (number1 <= 0 ? 0 : number1);
    	Integer n2 = number2;
    	Integer n3 = number3;
    	
    	
    	
    	Integer n = 0;
    	
    	
    	//iteratively pick sufficing rouding coef
    	while (suffice(n1, n2, n3, n)) {
    		n++;
    	}
    	
    	if (n > 0) {
    		n--;
    	}
    	
    	System.debug('================================ RESULT n1 : round(' + n1 + ', ' + n + ')=' + round(n1, n));
    	System.debug('================================ RESULT n2 : round(' + n2 + ', ' + n + ')=' + round(n2, n));
    	System.debug('================================ RESULT n3 : round(' + n3 + ', ' + n + ')=' + round(n3, n));
    	this.roundingCoef = n;
    
    }
    
    //some rules chosen rounding_coef must follow
    private Boolean suffice(Integer n1, Integer n2, Integer n3, Integer n) {
    	
    	//helper math substitutions
    	Double a1 = n1 + n2;
    	Double c = n3 / 2;
    	Double a = a1 * (1.1);
    	Double b = 3 * c;
    	Double temp = 0;
    	
    	/*System.debug('================== a1 = ' + a1);
    	System.debug('================== c = ' + c);
    	System.debug('================== a = ' + a);
    	System.debug('================== b = ' + b);
    	System.debug('==================== round(a, n) = ' + round(a, n));
    	System.debug('==================== (round(a, n) / a1)  = ' + (temp = (round(a, n) / a1)));
    	System.debug('==================== (round(b, n) / (2 * c)) = ' + (temp = (round(b, n) / (2 * c))));
    	System.debug('==================== (round(c, n)) = ' + (temp = round(c, n)));
    	System.debug('====================  (round(c, n) / (2 * c)) = ' + (temp = (round(c, n) / (2 * c))) );*/
    	
    	//mathematicaly proven features 
    	if ((temp = round(a, n) ) <= a1 ) {
    		return false;
    	}
    	if ((temp = round(b, n) ) <= (2 * c)) {
    		return false;
    	}
    	if ((temp = round(c, n)) <= 0) {
    		return false;
    	}
    	if ((temp = round(c, n)  ) >= (2 * c)) {
    		return false;
    	}
    	//System.debug('=========== cond 4 Passed');
    	
    	return true;
    }
    
    
    // z = x*10^(n) + y. Round downto x*10^n
    public static Integer round(Double z, Integer n) {
    	if (n < 0 ) {
    		throw new InvalidBatteryNumberException();
    	}
    	Integer result;
    	Integer temp = Integer.valueOf(z);
    	
    	for (Integer i = 0; i < n; i++) {
    		temp = (temp / 10);
    	}
    	//result = Math.round(temp);
    	result = temp;
   		//System.debug('====================== temp result = ' + result);
    	for (Integer i = 0; i < n; i++) {
    		result = result * 10;
    	}
    	
    	return result;
    }
    
    //round Integer downto number (mod(10) = 0) if possible
    //uses predefined rounding coef. Set another rounding coef for number from another "battery" or use static method round(Double, Integer)
    //by default roundingCoef = 0
    public Integer round(Integer numb) {
    	return round(numb, this.roundingCoef);
    }
    
    class InvalidBatteryNumberException extends Exception {
    }
    
}