@isTest(SeeAllData=true)
private class SendConfirmationEmailExtensionTest {

	static testmethod void testSendEmail(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking(1,evalVehicles,contacts);
			insert evalBookings;
			
			ApexPages.StandardController sc = new ApexPages.standardController(evalBookings.get(0));
			SendConfirmationEmailExtension sendConfirmEmail = new SendConfirmationEmailExtension(sc);
			sendConfirmEmail.sendEmail();
			
			Evaluation_Booking__c evalBooking = [Select Id, Booking_Confirmation_Status__c, Booking_Confirmation_Sent_Date__c FROM Evaluation_Booking__c WHERE Id =:evalBookings.get(0).Id];
			
			System.assertEquals(evalBooking.Booking_Confirmation_Status__c, 'Sent');
			System.assertEquals(evalBooking.Booking_Confirmation_Sent_Date__c, Date.Today());
			
		Test.stopTest();
	}
}