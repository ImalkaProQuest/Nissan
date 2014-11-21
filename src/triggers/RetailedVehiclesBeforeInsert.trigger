trigger RetailedVehiclesBeforeInsert on Retailed_Vehicles__c (before insert) {
	RetailedVehiclesHelper.associateContract(trigger.new);
}