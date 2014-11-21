trigger RetailedVehiclesAfterInsert on Retailed_Vehicles__c (after insert) {
    RetailedVehiclesHelper.calculateClaimedVehicles(trigger.new);
}