/*
** Apex Class/Controller Name           : LPDownlineWrapper 
** VF Pages associated [Names]          : N/A
** 
** Is Extension                         : No
** Is Test Class                        : No
**
** Purpose [short summary]              : Wrapper for downline records. Used in Landing Page component like RisingStars, G1Candidates, G1Appointments, G1SalesLeaders 
** 
** Triggers Spawned                     : N/A
**
** Change Log (Put the latest entry on top) :
** May 18: Created
** 
*/

public class LPDownlineWrapper {
        
        public Boolean showCoachingLink {get;set;}
        public String accountNumber {get; set;}
        public String actualOrderDate {get; set;}
        public String badgeTitle {get; set;}
        public String blockedUnitSales {get; set;}
        public String branchName {get; set;}
        public String color {get; set;}
        public String conversionDate {get; set;}
        public String executiveGen {get; set;}
        public String g1Actives {get; set;}
        public String g1Leaders {get; set;}
        public String generation {get; set;}
        public String myTeamOrdersURL {get; set;}
        public String myTeamReportURL {get; set;}
        public String name {get; set;}
        public String nameLink {get; set;}
        public String orderByDate {get; set;}
        public String payByDate {get; set;}
        public String personalAppts {get; set;}
        public String phoneNumber {get; set;} // replace in pages with preferred phoneNumber
        public String preferredEmail {get; set;}
        public String preferredPhone {get; set;}
        public String qualifiedOrder {get; set;}
        public String qualifiedPersAppts {get; set;}
        public String salesVolume {get; set;}
        public String sponsor {get; set;}
        public String status {get; set;}
        public String teamAppts {get; set;}
        public String teamSales {get; set;}
        public String titleValue {get; set;}
        public String titledLegs {get; set;}
        public String training {get; set;}
        public String unitSales {get; set;}
        public String viewLink {get; set;}
        public String zoneManager {get; set;}
        public String zoneNumber {get; set;}
        
        // New variables <Appointment Date, QPA> added , CR : 2413 on 08Mar, 2013 by Raktim
        public String appntmntDate {get; set;}
        public String qpaStatus {get; set;} 
       // End of Addition
       
       // Mail Plan Addition - by Raktim on 7th Aug 2013 Start
       public String mailPlanCode {get; set;}
       // Mail Plan Addition - by Raktim on 7th Aug 2013 END
       
       // New variables <Appointment Campaign> added On 23Sept, 2013 by Milon
        public String appntmntCampaign {get; set;}

        
}