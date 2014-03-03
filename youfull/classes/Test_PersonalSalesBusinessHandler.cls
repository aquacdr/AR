/***************************************************************************
 Name           : Test_PersonalSalesBusinessHandler
 Created By     : Barkha Jain (JDC)
 Description    : Test class for PersonalSalesBusinessHandler
 Modified Date  : Nov 11, 2013                
****************************************************************************/
@isTest
private class Test_PersonalSalesBusinessHandler {
	static Map<String, List<Rep_Detail_Field__c>> mapFlds;
	static String mktId = 'DE';
    static String acctNbr = '100001';
    static String acctNbr1 = '100002';
        
	//----------------------------------------------------------------------------
    // Method Name  : testPersonalSalesBusinessHandler
    // Description  : Method for Test Coverage of Class : PersonalSalesBusinessHandller
    //----------------------------------------------------------------------------
    static testMethod void testPersonalSalesBusinessHandler() {
    	//creating test data
    	TestDataHelper.createALMGlobalSetting(true);
    	User testUsr = TestDataHelper.createUser(acctNbr, 'XZ1', 'Avon Leader', false);
        testUsr.MRKT_ID__c = mktId;
        testUsr.LDRSHP_TITL_LVL_NBR__c = '2';
        insert testUsr;
        
    	//Create Object: Account
        Account acct = TestDataHelper.createAccount('Test Acct Coach', 'USD', true);
        
        //Create Contact
        List <Contact> conList = new List <Contact>();
        conList.add(TestDataHelper.createContact(acctNbr, String.valueOf(acct.Id), false));
        conList[0].MRKT_ACCT_KEY__c = mktId + acctNbr;
        conList.add(TestDataHelper.createContact(acctNbr1, String.valueOf(acct.Id), false));
        conList[1].MRKT_ACCT_KEY__c = mktId + acctNbr1;
        insert conList;
        
        //creating Sales_Leader_History__c record
        Sales_Leader_History__c salesLeader1 = TestDataHelper.createSalesLeaderHistory(conList[0].Id, true);
        
        //Create and Insert Object : Market
        Market__c mrkt = TestDataHelper.createMarket(mktId, false);
        mrkt.Section_Ldrship__c = 'Current President Club Status';
        mrkt.Rep_Detail_Columns__c = 'Badge Title';
        mrkt.Section_PSB__c = 'Badge_Title';
        
        system.runAs(testUsr){
        	insert mrkt;
        }
        
        Contact con = [select Id, MRKT_ACCT_KEY__c, (Select PD_TITL_LVL_NR__c, SPPY_EXEC_UNIT_SLS__c From Sales_Leader_Histories__r) 
        			  from Contact where Id =:conList[0].Id limit 1];
        
        //creating Rep Detail Fields			  
        createMapOfRepDetailField();
        //creating calendar records
        createCalendarRecords(mrkt);
        
        Test.startTest();
        PersonalSalesBusinessHandller handler = new PersonalSalesBusinessHandller();
        handler = new PersonalSalesBusinessHandller(con, conList[1], 
											        mrkt, acctNbr, mapFlds, 
											        new List<Integer>{201303, 201304, 201305, 201306}, 
											        new MarketLeaderTitleUtils(),
											        new MarketTagUtils());
        Test.stopTest();
    }
    
    //----------------------------------------------------------------------------
    // Method to create Rep_Detail_Field__c field and preparing map with Group field
    //----------------------------------------------------------------------------
    static void createMapOfRepDetailField(){
    	list<Rep_Detail_Field__c> repDetailList = new list<Rep_Detail_Field__c>();
    	repDetailList.add(TestDataHelper.createRepDetailField('Badge Title', false));
        repDetailList[0].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Badge_Title', false));
        repDetailList[1].Group__c = 'PSB';
        repDetailList[1].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        repDetailList[1].Type__c = 'Count';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Current President Club Status', false));
        repDetailList[2].Group__c = 'LDR_TUS';
        repDetailList[2].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        repDetailList[2].Type__c = 'Text';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Test Rep Detail 4', false));
        repDetailList[3].Group__c = 'LDR_UI_G1';
        repDetailList[3].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        repDetailList[0].Type__c = 'Percent';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Paid Title', false));
        repDetailList[4].Group__c = 'LDR_UI_G2';
        repDetailList[4].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        repDetailList[0].Type__c = ALMConstants.DATE_DDMM;
        
        repDetailList.add(TestDataHelper.createRepDetailField('Test Rep Detail 6', false));
        repDetailList[5].Group__c = 'LDR_UI_G3';
        repDetailList[5].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        
        repDetailList.add(TestDataHelper.createRepDetailField('Test Rep Detail 7', false));
        repDetailList[6].Group__c = 'EUP';
        repDetailList[6].Fields_To_Map__c = 'Sales_Leader_Histories:PD_TITL_LVL_NR__c,SPPY_EXEC_UNIT_SLS__c';
        insert repDetailList;
        
        mapFlds = new Map<String, List<Rep_Detail_Field__c>>();
        mapFlds.put(repDetailList[0].Group__c, new List<Rep_Detail_Field__c>{repDetailList[0]});
    	mapFlds.put(repDetailList[1].Group__c, new List<Rep_Detail_Field__c>{repDetailList[1]});
    	mapFlds.put(repDetailList[2].Group__c, new List<Rep_Detail_Field__c>{repDetailList[2]});
    	mapFlds.put(repDetailList[3].Group__c, new List<Rep_Detail_Field__c>{repDetailList[3]});
    	mapFlds.put(repDetailList[4].Group__c, new List<Rep_Detail_Field__c>{repDetailList[4]});
    	mapFlds.put(repDetailList[5].Group__c, new List<Rep_Detail_Field__c>{repDetailList[5]});
    	mapFlds.put(repDetailList[6].Group__c, new List<Rep_Detail_Field__c>{repDetailList[6]});
    }
    
    //----------------------------------------------------------------------------
    // Method to create test calendar records
    //----------------------------------------------------------------------------
    static void createCalendarRecords(Market__c mrkt){
    	//Create Object: Calender__c
        List <Calendar__c> calendarList = new List <Calendar__c>();
        Calendar__c c1 = TestDataHelper.createCalendar(201306, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c1);
        
        Calendar__c c2 = TestDataHelper.createCalendar(201305, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c2);
        
        Calendar__c c3 = TestDataHelper.createCalendar(201304, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c3);
        
        Calendar__c c4 = TestDataHelper.createCalendar(201303, mrkt.Market_Id__c, 2013, String.valueOf(mrkt.Id), false);
        calendarList.add(c4);
        
        insert calendarList;
    }
}