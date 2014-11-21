@isTest(SeeAllData=true)
private class BookingCalendarControllerTest {

	static testmethod void testController1(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(12,evalVehicles,contacts);
			insert evalBookings;
			
			BookingCalendarController bookingCalendar = new BookingCalendarController();
			bookingCalendar.showBookings();
			
		Test.stopTest();
	}
	
	static testmethod void testController2(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(12,evalVehicles,contacts);
			insert evalBookings;
			
			BookingCalendarController bookingCalendar = new BookingCalendarController();
			bookingCalendar.showBookings();
			
		Test.stopTest();
	}
	
	static testmethod void testController3(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(12,evalVehicles,contacts);
			insert evalBookings;
			
			BookingCalendarController bookingCalendar = new BookingCalendarController();
			/*bookingCalendar.getunSelectedRegionValues();
			bookingCalendar.getSelectedRegionValues();
			bookingCalendar.selectRegionClick();
			bookingCalendar.unselectRegionClick();
			bookingCalendar.getunSelectedModelValues();
			bookingCalendar.getSelectedModelValues();
			bookingCalendar.selectModelClick();
			bookingCalendar.unselectModelClick();
			bookingCalendar.getunSelectedStatusValues();
			bookingCalendar.getSelectedStatusValues();
			bookingCalendar.selectStatusClick();
			bookingCalendar.unselectStatusClick();*/
			bookingCalendar.showBookings();
			
		Test.stopTest();
	}
}