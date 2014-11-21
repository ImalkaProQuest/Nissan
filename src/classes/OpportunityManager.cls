public class OpportunityManager {
	
	public static void removeDeliverySchedules(List<Opportunity> lstNewOppty,List<Opportunity> lstOldOppty){
		
		//Set Opportunity ids
		set<id> setOpptyIds = new set<id>();
		 
		for(Integer i =0; i < lstNewOppty.size(); i++){
			if((lstNewOppty[i].StageName != lstOldOppty[i].StageName ) && (lstNewOppty[i].StageName == 'Closed Lost' || lstNewOppty[i].StageName == 'Discontinued')){
				setOpptyIds.add(lstNewOppty[i].id);
			}
		}
		if(!setOpptyIds.isempty()){
			OpportunityManager.deleteDeliverySchedules(setOpptyIds);
		}
	}
	
	public static void deleteDeliverySchedules(set<id> setOpptyIds){
		delete([SELECT id FROM Delivery_Schedule__c WHERE Opportunity__c IN:setOpptyIds]);
	}
}