public with sharing class GenealogyDataWrapper {
    
        public String strKPILabel{get; private set;}
        public String kpiValue{get; private set;}
        public String kpiType{get; private set;}
        
        public GenealogyDataWrapper(String strKPI, String kpiVal,String kpi_Type) {
            strKPILabel = strKPI;
            kpiValue = kpiVal;
            kpiType = kpi_Type;
        }  

}