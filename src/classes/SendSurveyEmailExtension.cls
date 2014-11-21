/**
    *This is a controller extension class of the SendSurveyEmail page
    *@author Kim Noceda - Proquest IT
    *@version 1.0 Created 10/16/2014
**/
public with sharing class SendSurveyEmailExtension {

	ApexPages.StandardController controller;
    private final Evaluation_Booking__c evaluationBooking;

    public SendSurveyEmailExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        evaluationBooking = [SELECT Id, Contact__c, Survey_Confirmation_Status__c, Survey_Confirmation_Sent_Date__c FROM Evaluation_Booking__c WHERE Id =:controller.getId()];
    }

    public PageReference sendEmail() {
        
        String contactId = evaluationBooking.Contact__c;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTemplateId('00XN0000000MCgP'); //Template in Dev
        message.setTargetObjectId(contactId);
        message.setWhatId(evaluationBooking.Id);
        message.setSaveAsActivity(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        
        evaluationBooking.Survey_Confirmation_Status__c = 'Sent';
        evaluationBooking.Survey_Confirmation_Sent_Date__c = Date.Today();
        evaluationBooking.Survey_to_be_Sent__c = false;
        
        update evaluationBooking;
        
        return controller.view();
       
    }
}