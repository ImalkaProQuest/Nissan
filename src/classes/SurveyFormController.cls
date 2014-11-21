/**
    *This is a controller class of the SurveyForm page
    *@author Kim Noceda - Proquest IT
    *@version 1.0 Created 10/16/2014
**/
public with sharing class SurveyFormController {
	
	//LABELS
	public String question_1 {get;set;}
	public String question_1Comment {get;set;}
	public String question_2 {get;set;}
	public String question_2_1 {get;set;}
	public String question_2_2 {get;set;}
	public String question_2_3 {get;set;}
	public String question_2_4 {get;set;}
	public String question_2_5 {get;set;}
	public String question_2_6 {get;set;}
	public String question_2_7 {get;set;}
	public String question_3 {get;set;}
	public String question_3_1 {get;set;}
	public String question_3_2 {get;set;}
	public String question_3_3 {get;set;}
	public String question_3_4 {get;set;}
	public String question_3_5 {get;set;}
	public String question_3_6 {get;set;}
	public String question_3_7 {get;set;}
	public String question_3_8 {get;set;}
	public String question_3Comment {get;set;}
	public String question_4 {get;set;}
	public String question_4_1 {get;set;}
	public String question_4_2 {get;set;}
	public String question_4_3 {get;set;}
	public String question_4_4 {get;set;}
	public String question_4_5 {get;set;}
	public String question_4_6 {get;set;}
	public String question_4Comment {get;set;}
	public String question_5 {get;set;}
	public String question_6 {get;set;}
	public String question_7 {get;set;}
	public String question_8 {get;set;}
	
	//VARIABLES
	public Survey_Result__c surveyResult {get;set;}
	public Evaluation_Booking__c evaluationBooking {get;set;}
	public String contactId {get;set;}
	public String bookingId {get;set;}
	public String question1Value {get;set;}
	public String question1CommentValue {get;set;}
	public String question2Value1 {get;set;}
	public String question2Value2 {get;set;}
	public String question2Value3 {get;set;}
	public String question2Value4 {get;set;}
	public String question2Value5 {get;set;}
	public String question2Value6 {get;set;}
	public String question2Value7 {get;set;}
	public String selectedVehicle {get;set;}
	public String question6Value {get;set;}
	public String question7Value {get;set;}
	public String question8Value {get;set;}
	public List<SelectOption> q1Picklist {get; set;}
	public List<SelectOption> q2Picklist {get; set;}
	public List<SelectOption> q5Picklist {get; set;}
	public List<SelectOption> q8Picklist {get; set;}
	public Boolean isValidSurvey {get;set;}
	public Boolean isCompleted {get;set;}
	public Boolean isExisting {get;set;}
	public List<Survey_Result__c> surveyResultList = new List<Survey_Result__c>();
	public String formattedSurveyDate {get;set;}
	public String questionNumber {get;set;}
	public String answerValue {get;set;}

	public SurveyFormController(){
		surveyResult = new Survey_Result__c();
		evaluationBooking = new Evaluation_Booking__c();
		surveyResultList = new List<Survey_Result__c>();
		formattedSurveyDate = '';
		questionNumber = '';
		answerValue = '';
		isValidSurvey = true;
		isCompleted = false;
		isExisting = false;
		contactId = ApexPages.currentPage().getParameters().get('contactId');
		bookingId = ApexPages.currentPage().getParameters().get('bookingId');
		checkExisting();
		initialiseQuestionLabels();
		question1Value = '';
		question2Value1 = '';
		question2Value2 = '';
		question2Value3 = '';
		question2Value4 = '';
		question2Value5 = '';
		question2Value6 = '';
		question2Value7 = '';
		selectedVehicle = '';
		question6Value = '';
		question7Value = '';
		question8Value = '';
		q1Picklist = getQuestion1Items();
		q2Picklist = getQuestion2Items();
		q5Picklist = getQuestion5Items();
		q8Picklist = getQuestion8Items();
		question1CommentValue = '';
	}
	
	public void populateRadios(){
		if(questionNumber == '2-1'){
			question2Value1 = answerValue;
		}
		if(questionNumber == '2-2'){
			question2Value2 = answerValue;
		}
		if(questionNumber == '2-3'){
			question2Value3 = answerValue;
		}
		if(questionNumber == '2-4'){
			question2Value4 = answerValue;
		}
		if(questionNumber == '2-5'){
			question2Value5 = answerValue;
		}
		if(questionNumber == '2-6'){
			question2Value6 = answerValue;
		}
		if(questionNumber == '2-7'){
			question2Value7 = answerValue;
		}
		if(questionNumber == '6-1'){
			question6Value = answerValue;
		}
		if(questionNumber == '7-1'){
			question7Value = answerValue;
		}
		system.debug('@@QUESTION1: '+question1Value);
		system.debug('@@QUESTION2-1: '+question2Value1);
		system.debug('@@QUESTION2-2: '+question2Value2);
		system.debug('@@QUESTION2-3: '+question2Value3);
		system.debug('@@QUESTION2-4: '+question2Value4);
		system.debug('@@QUESTION2-5: '+question2Value5);
		system.debug('@@QUESTION2-6: '+question2Value6);
		system.debug('@@QUESTION2-7: '+question2Value7);
		system.debug('@@QUESTION6-1: '+question6Value);
		system.debug('@@QUESTION7-1: '+question7Value);
		system.debug('@@QUESTION8: '+question8Value);
	}
	
	public void checkExisting(){
		if(bookingId != null && contactId != null){
			evaluationBooking = [SELECT Id, Model_Name__c, Organisation__c, Created_By_Name__c, Created_By_Email__c, Created_By_Phone__c, Survey_Confirmation_Sent_Date__c, Contact__r.Name, Evaluation_Vehicle__r.Vehicle__c, Survey_Form_Completed__c, Vehicle_Name__c FROM Evaluation_Booking__c WHERE Contact__c =:contactId AND Id =: bookingId LIMIT 1];
			formattedSurveyDate = evaluationBooking.Survey_Confirmation_Sent_Date__c.format();
			if(evaluationBooking != null){
				surveyResultList = [SELECT Id, Contact__c, Evaluation_Booking__c from Survey_Result__c WHERE Contact__c =:contactId AND Evaluation_Booking__c =: bookingId];
				if(surveyResultList.size() > 0){
					isValidSurvey = false;
					isExisting = true;
				}
			}
		}
	}
	
	public list<SelectOption> getQuestion1Items(){
	    List<SelectOption> q1Picklist = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Survey_Result__c.Question_1__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
	    for( Schema.PicklistEntry f : ple){
	      q1Picklist.add(new SelectOption(f.getLabel(), f.getValue()));
	   	}   
	   	return q1Picklist; 
	}
	
	public list<SelectOption> getQuestion2Items(){
		List<SelectOption> q2Picklist = new List<SelectOption>();
		for(integer i=1;i<=10;i++){
			q2Picklist.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
		}
		return q2Picklist;
	}
	
	public list<SelectOption> getQuestion8Items(){
	    List<SelectOption> q8Picklist = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Survey_Result__c.Question_8__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
	    for( Schema.PicklistEntry f : ple){
	      q8Picklist.add(new SelectOption(f.getLabel(), f.getValue()));
	   	}   
	   	return q8Picklist; 
	}
	
	public list<SelectOption> getQuestion5Items(){
		List<SelectOption> q5Picklist = new List<SelectOption>();
		/*List<Product2> vehicles = [SELECT Id, Name, Model_Series__c FROM Product2 WHERE SFDC_Product_Level__c = 1];
		for(Product2 product : vehicles){
			String modelName = product.Model_Series__c+' - '+product.Name;
			q5Picklist.add(new SelectOption(modelName,modelName));
		}
		List<Evaluation_Vehicle__c> vehicles = [SELECT Id, Name, Model_Name__c FROM Evaluation_Vehicle__c Where Status__c <> 'Grounded'];
		for(Evaluation_Vehicle__c vehicle : vehicles){
			q5Picklist.add(new SelectOption(vehicle.Model_Name__c,vehicle.Model_Name__c));
		}*/
		List<Nissan_Fleet_Vehicles__c> fleetVehicles = [SELECT Name FROM Nissan_Fleet_Vehicles__c ORDER BY Name ASC];
		for(Nissan_Fleet_Vehicles__c fleetVehicle : fleetVehicles){
			q5Picklist.add(new SelectOption(fleetVehicle.Name,fleetVehicle.Name));
		}
		return q5Picklist;
	}
	
	public void initialiseQuestionLabels(){
		question_1 = 'How would you rate this vehicle compared to your current like for like fleet/drive vehicle?';  
	    question_1Comment = 'Comments';  
	    question_2 = 'Please rate the vehicle from 0-10 in the following key areas';  
	    question_2_1 = 'Performance (engine options and fuel economy)';  
	    question_2_2 = 'Safety (safety technology)';  
	    question_2_3 = 'Comfort and Handling (seat position/adjustability, visibility, road handling)';  
	    question_2_4 = 'Styling (interior and exterior)';  
	    question_2_5 = 'Innovation (vehicle features and specification)';  
	    question_2_6 = 'Fit for Purpose (specific needs e.g. storage, flexibility)';  
	    question_2_7 = 'Value for Money (includes price of vehicle, servicing costs and Whole of Life calculation)';
	    question_3 = 'How would you rate your overall vehicle evaluation experience? (Tick applicable)';
	    question_3_1 = 'The vehicle was available when I needed it';  
	    question_3_2 = 'The vehicle was available for as long as I needed it';  
	    question_3_3 = 'The vehicle was vehicle delivered by a Nissan representative';  
	    question_3_4 = 'The vehicle was delivered by a transport supplier';  
	    question_3_5 = 'The vehicle was vehicle delivered clean';  
	    question_3_6 = 'The vehicle was delivered with suitable fuel';  
	    question_3_7 = 'I was advised of the insurance and tolls policy for driving this vehicle';  
	    question_3_8 = 'I signed the Indemnity Form';  
	    question_3Comment = 'Comments';  
	    question_4 = 'Would there be any barriers to purchasing this vehicle? (Tick applicable)';
	    question_4_1 = 'Price';  
	    question_4_2 = 'Fit for Purpose';  
	    question_4_3 = 'Whole of Life costs';  
	    question_4_4 = 'Accessories';  
	    question_4_5 = 'Warranty';  
	    question_4_6 = 'Other';  
	    question_4Comment = 'Comments';  
	    question_5 = 'What Nissan vehicle would you like to drive next?';  
	    question_6 = 'Based on your experience with Nissan Fleet, how likely are you to recommend Nissan to a friend or colleague?';  
	    question_7 = 'Based on your experience with driving the '+evaluationBooking.Model_Name__c+', how likely are you to recommend this vehicle to a friend or colleague?';  
	    question_8 = 'Would you like to stay updated with Nissan Fleet news?'; 
	}
	
	public void saveSurvey(){
		Boolean isError = false;
		if(question1Value == ''){
			system.debug('^^1');
			isError = true;
		}
		if(question2Value1 == '' || question2Value2 == '' || question2Value3 == '' || question2Value4 == '' ||
			question2Value5 == '' || question2Value6 == '' || question2Value7 == ''){
			system.debug('^^2');
			isError = true;
		}
		if(surveyResult.Question_3_1__c == false && surveyResult.Question_3_2__c == false && surveyResult.Question_3_3__c == false &&
			surveyResult.Question_3_4__c == false && surveyResult.Question_3_5__c == false && surveyResult.Question_3_6__c == false &&
			surveyResult.Question_3_7__c == false && surveyResult.Question_3_8__c == false){
			system.debug('^^3');
			isError = true;
		}
		if(surveyResult.Question_4_1__c == false && surveyResult.Question_4_2__c == false && surveyResult.Question_4_3__c == false &&
			surveyResult.Question_4_4__c == false && surveyResult.Question_4_5__c == false && surveyResult.Question_4_6__c == false){
			system.debug('^^4');
			isError = true;
		}
		if(selectedVehicle == ''){
			system.debug('^^5');
			isError = true;
		}
		if(question6Value == ''){
			system.debug('^^6');
			isError = true;
		}
		if(question7Value == ''){
			system.debug('^^7');
			isError = true;
		}
		if(question8Value == ''){
			system.debug('^^8');
			isError = true;
		}
		
		if(isError == true){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'All questions are mandatory. Please answer all questions before submitting the survey form.');
    		ApexPages.addMessage(myMsg);
		} else {
			surveyResult.Question_1__c = question1Value;
			system.debug('$$'+question2Value1);
			if(question2Value1 != ''){
				surveyResult.Question_2_1__c = Integer.valueOf(question2Value1);
			}
			if(question2Value2 != ''){
				surveyResult.Question_2_2__c = Integer.valueOf(question2Value2);
			}
			if(question2Value3 != ''){
				surveyResult.Question_2_3__c = Integer.valueOf(question2Value3);
			}
			if(question2Value4 != ''){
				surveyResult.Question_2_4__c = Integer.valueOf(question2Value4);
			}
			if(question2Value5 != ''){
				surveyResult.Question_2_5__c = Integer.valueOf(question2Value5);
			}
			if(question2Value6 != ''){
				surveyResult.Question_2_6__c = Integer.valueOf(question2Value6);
			}
			if(question2Value7 != ''){
				surveyResult.Question_2_7__c = Integer.valueOf(question2Value7);
			}
			surveyResult.Question_5__c = selectedVehicle;
			if(question6Value != ''){
				surveyResult.Question_6__c = Integer.valueOf(question6Value);
			}
			if(question7Value != ''){
				surveyResult.Question_7__c = Integer.valueOf(question7Value);
			}
			surveyResult.Question_8__c = question8Value;
			surveyResult.Contact__c = contactId;
			surveyResult.Evaluation_Booking__c = bookingId;
			surveyResult.Vehicle__c = evaluationBooking.Evaluation_Vehicle__r.Vehicle__c;
			
			insert surveyResult;
			
			evaluationBooking.Survey_Form_Completed__c = true;
			update evaluationBooking;
			
			isValidSurvey = false;
			isCompleted = true;
		}
	}
}