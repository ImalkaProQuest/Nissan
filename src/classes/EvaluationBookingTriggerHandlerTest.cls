@isTest(SeeAllData=true)
private class EvaluationBookingTriggerHandlerTest {

	static testmethod void errorHandling1(){
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
			
			List<Evaluation_Booking__c> evalBookings2 = TestDataUtility.createEvaluationBooking(1,evalVehicles,contacts);
			evalBookings2.get(0).Start_Date__c = Date.Today().addDays(2);
			evalBookings2.get(0).End_Date__c = Date.Today().addDays(10);
			
			try{
				insert evalBookings2;
			} catch(Exception e){
				System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
				System.Assert(e.getMessage().contains('There is already a booking on these dates for the corresponding Evaluation Vehicle'));
			}	
			
		Test.stopTest();
	}
	
	static testmethod void errorHandling2(){
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
			
			List<Evaluation_Booking__c> evalBookings2 = TestDataUtility.createEvaluationBooking(1,evalVehicles,contacts);
			evalBookings2.get(0).Start_Date__c = Date.Today().addDays(21);
			evalBookings2.get(0).End_Date__c = Date.Today().addDays(40);
			insert evalBookings2;
			
			try{
				evalBookings2.get(0).Start_Date__c = Date.Today().addDays(2);
				evalBookings2.get(0).End_Date__c = Date.Today().addDays(10);
				update evalBookings2;
				
			} catch(Exception e){
				System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
				System.Assert(e.getMessage().contains('There is already a booking on these dates for the corresponding Evaluation Vehicle'));
			}	
			
		Test.stopTest();
	}
}