trigger Opportunity on Opportunity (after update) {
	
	//Delete all delivery schedules if opportunity is clost lost or disconnected.
	if(trigger.isUpdate){
		OpportunityManager.removeDeliverySchedules(trigger.new, trigger.old);
	}
}