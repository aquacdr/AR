/***************************************************************************
 Name          : SL_DTO_Metric 
 Description   : Data transfer class to hold metric data
 Created By    : Fay Salwen 
 Created Date  : Dec 26, 2013                
****************************************************************************/

public with sharing class SL_DTO_Metric{
    
    public String label {get;set;} 
    public String plan {get;set;}
    public String actual {get;set;}
    public String percent {get;set;}
        
    public Boolean isGoalToMaximize {get;set;}
    public String barColor {get;set;}
        
    //===================================================================//
    //Constructor
    //===================================================================//
    public SL_DTO_Metric(String labelValue, Double planValue, Double actualValue, Boolean goalToMaximizeValue) {
        label = labelValue;
        isGoalToMaximize = goalToMaximizeValue;
        plan = (planValue == null) ? '' : planValue.format();
        actual = (actualValue == null) ? '' : actualValue.format();
        Double percentValue = (actualValue != null && planValue != null && planValue != 0) ? ((actualValue / planValue) * 100).round() : null;
        if (percentValue != null) {
            percent = percentValue.format();
            setBarColor(percentValue);          
        } else {
            percent = '';
            barColor = '';
        }
        System.debug('POC_DTO_Metric: ' + this);
    }

    //===================================================================//
    //Set the color of the bar based on the value of the percent
    //===================================================================//    
    private void setBarColor(Double percent) {
      if (isGoalToMaximize){
        if(percent >= ALMConstants.GOALTOMAX_ACTUAL_UPPER_RANGE){
            barColor = ALMConstants.BAR_COLOR_GREEN;
          }else if(percent < ALMConstants.GOALTOMAX_ACTUAL_UPPER_RANGE 
          && percent >= ALMConstants.GOALTOMAX_ACTUAL_LOWER_RANGE){
               barColor = ALMConstants.BAR_COLOR_YELLOW;
          }else if(percent < ALMConstants.GOALTOMAX_ACTUAL_LOWER_RANGE){
              barColor = ALMConstants.BAR_COLOR_RED;
          }
      }else{
        if(percent >= ALMConstants.NOT_GOALTOMAX_UPPER_RANGE){
            barColor = ALMConstants.BAR_COLOR_RED;
          }else if(percent < ALMConstants.NOT_GOALTOMAX_UPPER_RANGE 
          && percent >= ALMConstants.NOT_GOALTOMAX_LOWER_RANGE){
              barColor = ALMConstants.BAR_COLOR_YELLOW;
          }else if(percent < ALMConstants.NOT_GOALTOMAX_LOWER_RANGE){
              barColor = ALMConstants.BAR_COLOR_GREEN;
          }
      } 
    }
}