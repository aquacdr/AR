global class ALMAppointmentService {
	//Contact
	//Alm for the current Campaign
	//ALM for the next Campaign
	/*
	ALM Rep Performance Name
	Contact
	Currency  (ISO Code)
	*/
	
	global class Appointment
	{
		webservice string COUNTRY_CD; 
		webservice string ACCOUNT_NR;
		webservice string ACCOUNT_FIRST_NM;
		webservice string ACCOUNT_LAST_NM;
		webservice Date BIRTH_DT;
		webservice Date APPOINTMENT_DT;
		webservice string APPOINTMENT_CAMPAIGN_NR;
		webservice string EMAIL_ADDRESS_TXT;
		webservice string HOME_PHONE_NR;
		webservice string BUSINESS_PHONE_NR;
		webservice string MOBILE_PHONE_NR;
		webservice Integer E_REPRESENTATIVE_IND;
		webservice Integer ONLINE_REPRESENTATIVE_IND;
		webservice Integer OCCUPATION_CD;
		webservice string TIER_CD;
		webservice Integer MAILPLAN_NR;
		webservice Integer BANK_ACCOUNT_NR;
		webservice Integer REPORT_DELIVERY_CD;
		webservice Integer LEADRSHIP_KIT_IND;
		webservice Integer DELIVERY_TYPE;
		webservice string DELIVERY_POINT_CD;
		webservice string PARENT_ACCOUNT_NR;
		webservice string PARENT_ACCOUNT_TYP;
		webservice string MULTIPLE_ORDERS_ALLOWED_IND;
		webservice string MEDIA_TYPE;
		webservice Integer SALES_ORGANIZATION_DELIVERY_ZONE_CD;
		webservice string SALES_ORGANIZATION_DELIVERY_ZONE_LEVEL_NR;
		
	}
	
	webservice static list<Appointment> upsertOrderObject(list<Appointment> Appointments, String SourceSystem)
	{
		return Appointments;
		
	}
	
	webservice static void touchAccount()
	{
		Account acctToTouch = [select Id, Industry from Account where Id = '001Z000000aZL6pIAG'];	
		acctToTouch.Industry = DateTime.now().format();
		update acctToTouch;
	}

}