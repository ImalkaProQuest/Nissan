public with sharing class BookingCancellationController {

	public Evaluation_Booking__c evaluationBooking {get;set;}
	public String bookingId {get;set;}
	public Boolean isForConfirmation {get;set;}
	public Boolean isConfirmationCompleted {get;set;}
	public Boolean isConfirmed {get;set;}
	public Boolean isBookingPending {get;set;}
	public String startDate {get;set;}
	public String endDate {get;set;}
	
	public BookingCancellationController(){
		evaluationBooking = new Evaluation_Booking__c();
		bookingId = ApexPages.currentPage().getParameters().get('bookingId');
		isForConfirmation = true;
		isConfirmed = false;
		isBookingPending = false;
		isConfirmationCompleted = false;
		checkIfConfirmed();
	}
	
	public void checkIfConfirmed(){
		if(bookingId != ''){
			evaluationBooking = [SELECT Id, Booking_Status__c, Is_Confirmed_Cancellation__c, Vehicle_Name__c, Start_Date__c, End_Date__c FROM Evaluation_Booking__c where Id = :bookingId];
			startDate = evaluationBooking.Start_Date__c.format();
			endDate = evaluationBooking.End_Date__c.format();
			if(evaluationBooking.Booking_Status__c == 'Pending Cancellation' || evaluationBooking.Booking_Status__c == 'Cancelled'){
				isForConfirmation = false;
				isConfirmed = true;
			}
		}
	}
	
	public void stillBooked(){
		isForConfirmation = false;
		isConfirmed = false;
		isBookingPending = true;
		
	}
	
	public void confirmationCompleted(){
		isConfirmationCompleted = true;
		isForConfirmation = false;
		evaluationBooking.Booking_Status__c = 'Pending Cancellation';
		evaluationBooking.Is_Confirmed_Cancellation__c = true;
		update evaluationBooking;
	}
}