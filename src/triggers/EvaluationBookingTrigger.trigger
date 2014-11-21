/**
    *This trigger will fire during an insert or update on Evaluation_Booking__c object
    *@author Kim Noceda - Proquest IT
    *@version 1.0 Created 10/13/2014
**/
trigger EvaluationBookingTrigger on Evaluation_Booking__c (before insert, before update) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            EvaluationBookingTriggerHandler.validateBookingDates(Trigger.New);
        }
        if(Trigger.isUpdate){
            EvaluationBookingTriggerHandler.validateBookingDates(Trigger.New);
        }
    }
}