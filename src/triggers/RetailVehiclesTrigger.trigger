trigger RetailVehiclesTrigger on Retailed_Vehicles__c (after insert, before insert, after update, before update) {
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            RetailedVehiclesHelper.associateContract(trigger.new);
        } else {
            RetailedVehiclesHelper.associateContract(trigger.old, trigger.new);
        }
    } else if(trigger.isAfter) {
        if(trigger.isInsert) {
            RetailedVehiclesHelper.calculateClaimedVehicles(trigger.new);
            RetailedVehiclesHelper.createCampaignSales(trigger.New);
        } else {
            RetailedVehiclesHelper.calculateClaimedVehicles(trigger.old,trigger.new);
        }
    }
}