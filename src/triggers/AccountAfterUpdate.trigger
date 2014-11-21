trigger AccountAfterUpdate on Account (after update) {
	AccountHelper.changeOwnerofAssociatedActiveContracts(trigger.old,trigger.new);
	AccountHelper.associateContractsForRetailedVehicles(trigger.old,trigger.new);
}