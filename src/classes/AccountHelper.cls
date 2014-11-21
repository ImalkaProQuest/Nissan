public class AccountHelper {
	
	public static void changeOwnerofAssociatedActiveContracts(List<Account> oldAccounts, List<Account> newAccounts) {
		Map<Id, Id> accountOwnerIdMap = new Map<Id,Id>();
		for(Integer i=0; i<oldAccounts.size(); i++) {
			if(newAccounts[i].OwnerId != oldAccounts[i].OwnerId) {
				accountOwnerIdMap.put(newAccounts[i].Id,newAccounts[i].OwnerId);
			}
		}
		if(accountOwnerIdMap.size()>0) {
			List<Contract> toUpdateContracts = new List<Contract>();
			for(Contract c : [Select AccountId,OwnerId from Contract where AccountId in :accountOwnerIdMap.keyset() and Status = 'Active']) {
				c.OwnerId = accountOwnerIdMap.get(c.AccountId);
				toUpdateContracts.add(c);
			}
			if(toUpdateContracts.size()>0) {
				update toUpdateContracts;
			}
		}
	}
	
	public static void associateContractsForRetailedVehicles(List<Account> oldAccounts, List<Account> newAccounts) {
		Set<Id> accountIds = new Set<Id>();
		Map<Id,Id> accountWithContractIds = new Map<Id, Id>();
		for(Integer i=0; i<oldAccounts.size(); i++) {
			if(newAccounts[i].ParentId != oldAccounts[i].ParentId) {
				accountIds.add(newAccounts[i].Id);
			}
		}
		accountWithContractIds = RetailedVehiclesHelper.getParentAccounts(accountIds);
		Map<Id,Id> ProductAndContractIds = new Map<Id,Id>();
		for(Associated_Product__c ap : [Select Id, Product__c, Contract__r.Id, Contract__c, Contract__r.AccountId from Associated_Product__c where Contract__r.AccountId in :accountWithContractIds.keyset() and Contract__r.Status = 'Active']) {
			ProductAndContractIds.put(ap.Product__c,ap.Contract__r.Id);
    	}
    	system.debug('--PRODUCT WITH CONTRACTS'+ProductAndContractIds);
    	List<Retailed_Vehicles__c> toUpdate = new List<Retailed_Vehicles__c>();
    	for(Retailed_Vehicles__c rv : [Select Id, Level_3_Vehicle_Variant__c from Retailed_Vehicles__c where Organisation__c in :accountIds and Level_3_Vehicle_Variant__c in :ProductAndContractIds.keyset()]) {
            rv.Contract__c = ProductAndContractIds.get(rv.Level_3_Vehicle_Variant__c);
            toUpdate.add(rv);
	    }
	    if(toUpdate.size()>0) {
	    	update toUpdate;
	    }
	}

}