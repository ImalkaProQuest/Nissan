/**
    *This is a trigger handler class for the EvaluationVehicleTrigger
    *@author Kim Noceda - Proquest IT
    *@version 1.0 Created 10/13/2014
**/
public with sharing class EvaluationBookingTriggerHandler {

    public static void validateBookingDates(List<Evaluation_Booking__c> evaluationBookings){
        
        Set<Id> evalVehiclesIds = new Set<Id>();
        Set<Id> newBookingIds = new Set<Id>();
        for(Evaluation_Booking__c bookings : evaluationBookings){
            evalVehiclesIds.add(bookings.Evaluation_Vehicle__c);
            newBookingIds.add(bookings.Id);
        }
        
        List<Evaluation_Booking__c> evalBookings = [
                                    SELECT
                                        Id,
                                        Evaluation_Vehicle__c,
                                        Start_Date__c,
                                        End_Date__c
                                    FROM
                                        Evaluation_Booking__c
                                    WHERE
                                        Evaluation_Vehicle__c
                                    IN
                                        :evalVehiclesIds
                                    AND
                                        Id
                                    NOT IN
                                        :newBookingIds
                                    ];
                                    
        for(Evaluation_Booking__c bookings : evaluationBookings){
            for(Evaluation_Booking__c evalBooking : evalBookings){
                if(((bookings.Start_Date__c >= evalBooking.Start_Date__c && bookings.Start_Date__c <= evalBooking.End_Date__c) || (bookings.End_Date__c >= evalBooking.Start_Date__c && bookings.Start_Date__c <= evalBooking.Start_Date__c)) && bookings.Evaluation_Vehicle__c == evalBooking.Evaluation_Vehicle__c){
                   bookings.addError('There is already a booking on these dates for the corresponding Evaluation Vehicle');
                }
            }
        }
    }
}