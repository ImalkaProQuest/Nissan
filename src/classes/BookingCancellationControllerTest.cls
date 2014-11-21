@isTest(SeeAllData=true)
private class BookingCancellationControllerTest {
	
	static testmethod void cancellationTest1(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
		insert contacts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
		insert evalVehicles;
		
		List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(12,evalVehicles,contacts);
		insert evalBookings;
		
		Test.startTest();
			Test.setCurrentPageReference(new PageReference('Page.BookingCancellation'));
			System.currentPageReference().getParameters().put('bookingId', evalBookings.get(0).Id);
			BookingCancellationController bookingCancellation = new BookingCancellationController();
		Test.stopTest();
	}
	
	static testmethod void cancellationTest2(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
		insert contacts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
		insert evalVehicles;
		
		List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(1,evalVehicles,contacts);
		insert evalBookings;
		
		Test.startTest();
			Test.setCurrentPageReference(new PageReference('Page.BookingCancellation'));
			System.currentPageReference().getParameters().put('bookingId', evalBookings.get(0).Id);
			BookingCancellationController bookingCancellation = new BookingCancellationController();
			bookingCancellation.stillBooked();
			
			System.assertEquals(bookingCancellation.isConfirmationCompleted,false);
			System.assertEquals(bookingCancellation.isForConfirmation,false);
			System.assertEquals(bookingCancellation.isBookingPending,true);
			
		Test.stopTest();
	}
	
	static testmethod void cancellationTest3(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
		insert contacts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
		insert evalVehicles;
		
		List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(1,evalVehicles,contacts);
		insert evalBookings;
		
		Test.startTest();
			Test.setCurrentPageReference(new PageReference('Page.BookingCancellation'));
			System.currentPageReference().getParameters().put('bookingId', evalBookings.get(0).Id);
			BookingCancellationController bookingCancellation = new BookingCancellationController();
			bookingCancellation.confirmationCompleted();
			
			System.assertEquals(bookingCancellation.evaluationBooking.Booking_Status__c,'Pending Cancellation');
			System.assertEquals(bookingCancellation.evaluationBooking.Is_Confirmed_Cancellation__c,true);
			System.assertEquals(bookingCancellation.isConfirmationCompleted,true);
			System.assertEquals(bookingCancellation.isForConfirmation,false);
			
		Test.stopTest();
	}
	
	static testmethod void cancellationTest4(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
		insert contacts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
		insert evalVehicles;
		
		List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking2(12,evalVehicles,contacts);
		evalBookings.get(0).Booking_Status__c = 'Cancelled';
		insert evalBookings;
		
		Test.startTest();
			Test.setCurrentPageReference(new PageReference('Page.BookingCancellation'));
			System.currentPageReference().getParameters().put('bookingId', evalBookings.get(0).Id);
			BookingCancellationController bookingCancellation = new BookingCancellationController();
			
			System.assertEquals(bookingCancellation.isConfirmed,true);
			System.assertEquals(bookingCancellation.isForConfirmation,false);
		Test.stopTest();
	}
}