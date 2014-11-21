/**
    *This is a controller class of the SendConfirmationEmail page
    *@author Kengo Chinen - Proquest IT
    *@version 1.0 Created 10/15/2014
**/
public with sharing class SendConfirmationEmailExtension {

    ApexPages.StandardController controller;
    private final Evaluation_Booking__c evaluationBooking;

    public SendConfirmationEmailExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        evaluationBooking = [SELECT Id, Contact__c, Booking_Confirmation_Status__c, Booking_Confirmation_Sent_Date__c, Created_By_Email__c FROM Evaluation_Booking__c WHERE Id =:controller.getId()];
    }

    public PageReference sendEmail() {
        
        List<String> ccRecipients = new List<String>();
        ccRecipients.add(evaluationBooking.Created_By_Email__c);
        
        String contactId = evaluationBooking.Contact__c;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTemplateId('00XN0000000MCdf'); //Template in Dev
        message.setCCAddresses(ccRecipients);
        message.setTargetObjectId(contactId);
        message.setWhatId(evaluationBooking.Id);
        message.setSaveAsActivity(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        
        evaluationBooking.Booking_Confirmation_Status__c = 'Sent';
        evaluationBooking.Booking_Confirmation_Sent_Date__c = Date.Today();
        evaluationBooking.Booking_Confirmation_to_be_sent__c = false;
        
        update evaluationBooking;
        
        return controller.view();
       
    }

}