trigger SpecialAssistanceTrigger on Special_Assistance__c (after insert, after update) {
	
	if(trigger.isInsert) {
		SpecialAssistanceHelper.UpdateOrgs(trigger.new);
	} else {
		SpecialAssistanceHelper.UpdateOrgs(trigger.old,trigger.new);
	}
    
}