@isTest(SeeAllData=true)
private class SendSurveyEmailExtensionTest {

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
			SendSurveyEmailExtension sendConfirmEmail = new SendSurveyEmailExtension(sc);
			sendConfirmEmail.sendEmail();
			
			Evaluation_Booking__c evalBooking = [Select Id, Survey_Confirmation_Status__c, Survey_Confirmation_Sent_Date__c FROM Evaluation_Booking__c WHERE Id =:evalBookings.get(0).Id];
			
			System.assertEquals(evalBooking.Survey_Confirmation_Status__c, 'Sent');
			System.assertEquals(evalBooking.Survey_Confirmation_Sent_Date__c, Date.Today());
			
		Test.stopTest();
	}
}