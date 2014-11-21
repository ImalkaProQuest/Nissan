@isTest(SeeAllData=true)
private class SurveyFormControllerTest {

	static testmethod void testScenario1(){
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
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			Test.setCurrentPageReference(new PageReference('Page.SurveyForm'));
			System.currentPageReference().getParameters().put('contactId', contacts.get(0).Id);
			System.currentPageReference().getParameters().put('bookingId', evalBookings.get(0).Id);
			
			/*SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.contactId = contacts.get(0).Id;
			surveyForm.bookingId = evalBookings.get(0).Id;*/
			
		Test.stopTest();
	}
	
	static testmethod void testScenario2(){
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
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			List<Nissan_Fleet_Vehicles__c> fleetVehicles = TestDataUtility.createFleetVehicles(3);
			insert fleetVehicles;
			
			/*Test.setCurrentPageReference(new PageReference('Page.SurveyForm'));
			System.currentPageReference().getParameters().put('contactId', contacts.get(0).Id);
			System.currentPageReference().getParameters().put('bookingId', evalBookings.get(0).Id);*/
			
			SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.contactId = contacts.get(0).Id;
			surveyForm.bookingId = evalBookings.get(0).Id;
			
		Test.stopTest();
	}
	
	static testmethod void testScenario3(){
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
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.contactId = contacts.get(0).Id;
			surveyForm.bookingId = evalBookings.get(0).Id;
			surveyForm.question2Value1 = String.valueOf(10);
			surveyForm.question2Value2 = String.valueOf(10);
			surveyForm.question2Value3 = String.valueOf(10);
			surveyForm.question2Value4 = String.valueOf(10);
			surveyForm.question2Value5 = String.valueOf(10);
			surveyForm.question2Value6 = String.valueOf(10);
			surveyForm.question2Value7 = String.valueOf(10);
			surveyForm.question6Value = String.valueOf(10);
			surveyForm.question7Value = String.valueOf(10);
			surveyForm.saveSurvey();
			
		Test.stopTest();
	}
	
	static testmethod void testScenario4(){
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
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.contactId = contacts.get(0).Id;
			surveyForm.bookingId = evalBookings.get(0).Id;
			surveyForm.surveyResult.Question_3_1__c = true;
			surveyForm.surveyResult.Question_4_1__c = true;
			surveyForm.question2Value1 = String.valueOf(10);
			surveyForm.question2Value2 = String.valueOf(10);
			surveyForm.question2Value3 = String.valueOf(10);
			surveyForm.question2Value4 = String.valueOf(10);
			surveyForm.question2Value5 = String.valueOf(10);
			surveyForm.question2Value6 = String.valueOf(10);
			surveyForm.question2Value7 = String.valueOf(10);
			surveyForm.question6Value = String.valueOf(10);
			surveyForm.question7Value = String.valueOf(10);
			surveyForm.question8Value = 'Yes';
			surveyForm.saveSurvey();
			
		Test.stopTest();
	}
	
	static testmethod void testScenario5(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking(1,evalVehicles,contacts);
			evalBookings.get(0).Survey_Confirmation_Sent_Date__c = Date.Today();
			insert evalBookings;
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.contactId = contacts.get(0).Id;
			surveyForm.bookingId = evalBookings.get(0).Id;
			surveyForm.surveyResult.Question_3_1__c = true;
			surveyForm.surveyResult.Question_4_1__c = true;
			surveyForm.question2Value1 = String.valueOf(10);
			surveyForm.question2Value2 = String.valueOf(10);
			surveyForm.question2Value3 = String.valueOf(10);
			surveyForm.question2Value4 = String.valueOf(10);
			surveyForm.question2Value5 = String.valueOf(10);
			surveyForm.question2Value6 = String.valueOf(10);
			surveyForm.question2Value7 = String.valueOf(10);
			surveyForm.question6Value = String.valueOf(10);
			surveyForm.question7Value = String.valueOf(10);
			surveyForm.question8Value = 'Yes';
			surveyForm.checkExisting();
			surveyForm.saveSurvey();
			
		Test.stopTest();
	}
	
	static testmethod void testScenario6(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking(1,evalVehicles,contacts);
			evalBookings.get(0).Survey_Confirmation_Sent_Date__c = Date.Today();
			insert evalBookings;
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.questionNumber = '2-1';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '2-2';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '2-3';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '2-4';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '2-5';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '2-6';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '2-7';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '6-1';
			surveyForm.populateRadios();
			surveyForm.questionNumber = '7-1';
			surveyForm.populateRadios();
			
		Test.stopTest();
	}
	
	static testmethod void testScenario7(){
		Test.startTest();
		
			List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
			insert accounts;
			
			List<Contact> contacts = TestDataUtility.createContacts(1,accounts);
			insert contacts;
			
			Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
			
			List<Evaluation_Vehicle__c> evalVehicles = TestDataUtility.createEvaluationVehicle(1,vehicle);
			insert evalVehicles;
			
			List<Evaluation_Booking__c> evalBookings = TestDataUtility.createEvaluationBooking(1,evalVehicles,contacts);
			evalBookings.get(0).Survey_Confirmation_Sent_Date__c = Date.Today();
			insert evalBookings;
			
			List<Survey_Result__c> surveyResults = TestDataUtility.createSurveyResult(1, contacts, evalBookings);
			insert SurveyResults;
			
			SurveyFormController surveyForm = new SurveyFormController();
			surveyForm.contactId = contacts.get(0).Id;
			surveyForm.bookingId = evalBookings.get(0).Id;
			surveyForm.question1Value = 'Better than Current';
			surveyForm.surveyResult.Question_3_1__c = true;
			surveyForm.surveyResult.Question_4_1__c = true;
			surveyForm.question2Value1 = String.valueOf(10);
			surveyForm.question2Value2 = String.valueOf(10);
			surveyForm.question2Value3 = String.valueOf(10);
			surveyForm.question2Value4 = String.valueOf(10);
			surveyForm.question2Value5 = String.valueOf(10);
			surveyForm.question2Value6 = String.valueOf(10);
			surveyForm.question2Value7 = String.valueOf(10);
			surveyForm.question6Value = String.valueOf(10);
			surveyForm.question7Value = String.valueOf(10);
			surveyForm.selectedVehicle = 'TESTVEHICLE';
			surveyForm.question8Value = 'Yes';
			surveyForm.saveSurvey();
			
		Test.stopTest();
	}
}