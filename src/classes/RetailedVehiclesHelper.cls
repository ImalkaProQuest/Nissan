public class RetailedVehiclesHelper {
//Sum of all RetailedVehicles' Quantity against Special Assistance
    public static void calculateClaimedVehicles(List<Retailed_Vehicles__c> newRetailedVehicles) {
        Set<Id> specialAssistanceIds = new Set<Id>();
        
        Map<Id,Id> contractVehicleIds = new Map<Id,Id>(); // A map which contains a map of contracts and vehicles
        List<Associated_Product__c> productsAgainstContract  = new List<Associated_Product__c>();
        
        for(Retailed_Vehicles__c rv : newRetailedVehicles) {
            if(rv.Special_Assistance_Number__c != null) {
                specialAssistanceIds.add(rv.Special_Assistance_Number__c);
            } 
            if(rv.Contract__c != null && rv.Level_3_Vehicle_Variant__c != null) {
                contractVehicleIds.put(rv.Contract__c,rv.Level_3_Vehicle_Variant__c);
            }
        }
        updateSAAndOrg(specialAssistanceIds);
        updateAssociateProducts(contractVehicleIds);
    }
    
    public static void calculateClaimedVehicles(List<Retailed_Vehicles__c> oldRetailedVehicles, List<Retailed_Vehicles__c> newRetailedVehicles) {
        Set<Id> specialAssistanceIds = new Set<Id>();

        Map<Id,Id> contractVehicleIds = new Map<Id,Id>(); // A map which contains a map of contracts and vehicles
        List<Associated_Product__c> productsAgainstContract  = new List<Associated_Product__c>();
        
        for(Integer i=0; i<newRetailedVehicles.size(); i++) {
            if(newRetailedVehicles[i].Special_Assistance_Number__c != null &&
               newRetailedVehicles[i].Special_Assistance_Number__c != oldRetailedVehicles[i].Special_Assistance_Number__c) {
                specialAssistanceIds.add(newRetailedVehicles[i].Special_Assistance_Number__c);
            } 
            if(newRetailedVehicles[i].Contract__c != oldRetailedVehicles[i].Contract__c) {
                if(newRetailedVehicles[i].Contract__c !=null) {
                    contractVehicleIds.put(newRetailedVehicles[i].Contract__c,newRetailedVehicles[i].Level_3_Vehicle_Variant__c);
                }
                if(oldRetailedVehicles[i].Contract__c !=null) {
                    contractVehicleIds.put(oldRetailedVehicles[i].Contract__c,oldRetailedVehicles[i].Level_3_Vehicle_Variant__c);
                }
            }
        }
        updateSAAndOrg(specialAssistanceIds);
        updateAssociateProducts(contractVehicleIds);
    }
    
    public static void updateAssociateProducts(Map<Id,Id> contractVehicleIds) {
        if(contractVehicleIds.size()>0) {
            Map<String,Associated_Product__c> toUpdateAssociatedProducts = new Map<String,Associated_Product__c>();
            for(Associated_Product__c ap : [Select Id, Contract_Vehicle_Unique__c, Number_of_Vehicles_Purchased__c from Associated_Product__c where Contract__c in :contractVehicleIds.keyset() and Product__c in :contractVehicleIds.values()]){
                toUpdateAssociatedProducts.put(ap.Contract_Vehicle_Unique__c,ap);
            }
            for(AggregateResult ar : [Select SUM(Quantity__c) quantity, Contract__c, Level_3_Vehicle_Variant__c from Retailed_Vehicles__c where Contract__c in :contractVehicleIds.keyset() and Level_3_Vehicle_Variant__c in :contractVehicleIds.values() group by Contract__c, Level_3_Vehicle_Variant__c]) {
                if(toUpdateAssociatedProducts.get(String.valueOf(ar.get('Contract__c'))+String.valueOf(ar.get('Level_3_Vehicle_Variant__c')))!=null) {
                    toUpdateAssociatedProducts.get(String.valueOf(ar.get('Contract__c'))+String.valueOf(ar.get('Level_3_Vehicle_Variant__c'))).Number_of_Vehicles_Purchased__c = Integer.valueOf(ar.get('quantity'));
                }
            }
            update toUpdateAssociatedProducts.values();
        }
    }
    
    public static void updateSAAndOrg(Set<Id> specialAssistanceIds) {
        Map<Id, Integer> numberOfRetailedVehiclesPerSpecialAssistance = new Map<Id, Integer>(); 
        List<Special_Assistance__c> specialAssistanceRecords = new List<Special_Assistance__c>();
        Map<Id, Account> toUpdateOrgs = new Map<Id, Account>();
        if(specialAssistanceIds.size()>0) {
            for (AggregateResult ar : [Select Special_Assistance_Number__c, SUM(Quantity__c) quantity from Retailed_Vehicles__c where Special_Assistance_Number__c in :specialAssistanceIds group by Special_Assistance_Number__c])  {
                numberOfRetailedVehiclesPerSpecialAssistance.put(Id.valueOf(String.valueOf(ar.get('Special_Assistance_Number__c'))),Integer.valueOf(ar.get('quantity')));
            }
        
            for(Special_Assistance__c sa : [Select Id, Status__c, Organisation__c, Vehicles_Claimed__c from Special_Assistance__c where Id in :numberOfRetailedVehiclesPerSpecialAssistance.keyset()]) {
                sa.Vehicles_Claimed__c = numberOfRetailedVehiclesPerSpecialAssistance.get(sa.Id);
                specialAssistanceRecords.add(sa);
                if(sa.Status__c == 'Approved') {
                    toUpdateOrgs.put(sa.Organisation__c,new Account());
                }
            }
            if(specialAssistanceRecords.size()>0)
                update specialAssistanceRecords;
        }
        
        if(toUpdateOrgs.size()>0) {
            for (AggregateResult ar : [Select Organisation__c, SUM(Amount_Claimed__c) amtClaimed, SUM(Amount_Requested__c) amtRequested, SUM(Amount_Remaining__c) amtRemaining,
                                        SUM(Vehicles_Requested__c) vehiclesApproved, SUM(Vehicles_Claimed__c) vehiclesClaimed, 
                                        SUM(Vehicles_Remaining__c) vehiclesRemaining from Special_Assistance__c where 
                                        Status__c = 'Approved' and Organisation__c in :toUpdateOrgs.keyset() group by Organisation__c])  {
                Account a = new Account(Id = Id.valueOf(String.valueOf(ar.get('Organisation__c'))),
                                        Amount_Remaining_by_Organisation__c = Integer.valueOf(ar.get('amtRemaining')), 
                                        Amount_Claimed_by_Organisation__c = Integer.valueOf(ar.get('amtClaimed')),
                                        Amount_Requested_by_Organisation__c = Integer.valueOf(ar.get('amtRequested')),
                                        Vehicles_Approved_for_Organisation__c = Integer.valueOf(ar.get('vehiclesApproved')), 
                                        Vehicles_Claimed_by_Organisation__c = Integer.valueOf(ar.get('vehiclesClaimed')),
                                        Vehicles_Remaining_by_Organisation__c = Integer.valueOf(ar.get('vehiclesRemaining')));
                system.debug('ACCOUNT**'+a);
                toUpdateOrgs.put(Id.valueOf(String.valueOf(ar.get('Organisation__c'))),a);
            }
            Update toUpdateOrgs.values();
        }
    }
    
    public static void associateContract(List<Retailed_Vehicles__c> newRetailedVehicles) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Id> vehicleWithAccountIds = new Map<Id,Id>();
        for(Retailed_Vehicles__c rv : newRetailedVehicles) {
            if(rv.Organisation__c != null) {
                accountIds.add(rv.Organisation__c);
                if(rv.Level_3_Vehicle_Variant__c != null) {
                    vehicleWithAccountIds.put(rv.Organisation__c,rv.Level_3_Vehicle_Variant__c);
                }
            } else if(rv.Organisation__c == null && 
            		(rv.Sales_Type__c == 'L' || rv.Sales_Type__c == 'C' || rv.Sales_Type__c == 'S')) {
            	rv.Organisation__c  = Label.ContractualGovernmentAccount;
            }
        }
        updateContractFromAccounts(accountIds,newRetailedVehicles, vehicleWithAccountIds);
    }
    
    public static void updateContractFromAccounts(Set<Id> accountIds, List<Retailed_Vehicles__c> newRetailedVehicles, Map<Id,Id> vehicleWithAccountIds) {
        Map<Id,Id> accountWithContractIds = new Map<Id, Id>(); // This is a map which contains account Id which has a contract and the child account which was referenced in retail vehicle
        if(accountIds.size()>0) {
            accountWithContractIds = getParentAccounts(accountIds);
            Map<Id,Id> OrgAndContractIds = new Map<Id,Id>();
            for(Associated_Product__c ap : [Select Id, Product__c, Contract__r.Id, Contract__c, Contract__r.AccountId from Associated_Product__c where Contract__r.AccountId in :accountWithContractIds.keyset() and Contract__r.Status = 'Active']) {
                if(accountWithContractIds.keyset().contains(ap.Contract__r.AccountId) && vehicleWithAccountIds.get(accountWithContractIds.get(ap.Contract__r.AccountId)) == ap.Product__c) {
                    OrgAndContractIds.put(accountWithContractIds.get(ap.Contract__r.AccountId),ap.Contract__r.Id);
                }
            }
            system.debug('--ORG WITH CONTRACTS'+OrgAndContractIds);
            for(Retailed_Vehicles__c rv : newRetailedVehicles) {
                if(rv.Organisation__c != null) {
                    if(OrgAndContractIds.keyset().contains(rv.Organisation__c)) {
                        rv.Contract__c = OrgAndContractIds.get(rv.Organisation__c);
                    } else {
                        rv.Contract__c = null;
                    }
                } 
            }
        }
    }
    
    public static void associateContract(List<Retailed_Vehicles__c> oldRetailedVehicles, List<Retailed_Vehicles__c> newRetailedVehicles) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Id> vehicleWithAccountIds = new Map<Id,Id>();
        for(Integer i = 0; i<oldRetailedVehicles.size(); i++) {
            if(newRetailedVehicles[i].Organisation__c != null &&
               (newRetailedVehicles[i].Organisation__c != oldRetailedVehicles[i].Organisation__c)) {
                accountIds.add(newRetailedVehicles[i].Organisation__c);
                if(newRetailedVehicles[i].Level_3_Vehicle_Variant__c != null) {
                    vehicleWithAccountIds.put(newRetailedVehicles[i].Organisation__c,newRetailedVehicles[i].Level_3_Vehicle_Variant__c);
                }
            }
        }
        updateContractFromAccounts(accountIds,newRetailedVehicles, vehicleWithAccountIds);
    }
    
    public static Map<Id,Id> getParentAccounts(Set<Id> accountIds) {
        Map<Id,Id> highLevelParentAccountIds = new Map<Id,Id>();
        Map<Id,Id> accountWithContractIds = new Map<Id, Id>(); // This is a map which contains account Id which has a contract, and the child account which was referenced in Retail vehicle
        for(Account a : [Select Id, Has_a_Contract__c, Parent.Id, Parent.Has_a_Contract__c, Parent.Parent.Id, Parent.Parent.Has_a_Contract__c,
                         Parent.Parent.Parent.Id, Parent.Parent.Parent.Has_a_Contract__c, Parent.Parent.Parent.Parent.Id, Parent.Parent.Parent.Parent.Has_a_Contract__c,
                         Parent.Parent.Parent.Parent.Parent.Id, Parent.Parent.Parent.Parent.Parent.Has_a_Contract__c from Account where Id in :accountIds]) {
            
            if(a.Parent.Parent.Parent.Parent.Parent.Id != null && !a.Parent.Parent.Parent.Parent.Parent.Has_a_Contract__c &&
               !a.Parent.Parent.Parent.Parent.Has_a_Contract__c && !a.Parent.Parent.Parent.Has_a_Contract__c && 
               !a.Parent.Parent.Has_a_Contract__c && !a.Parent.Has_a_Contract__c && !a.Has_a_Contract__c) {
                highLevelParentAccountIds.put(a.Parent.Parent.Parent.Parent.Parent.Id, a.Id);
            }
            if(a.Has_a_Contract__c) {
                accountWithContractIds.put(a.Id, a.Id);
            } else if(a.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Id, a.Id);
            } else if(a.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Id, a.Id);
            } else if(a.Parent.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Parent.Id, a.Id);
            } else if(a.Parent.Parent.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Parent.Parent.Id, a.Id);
            } else if(a.Parent.Parent.Parent.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Parent.Parent.Parent.Id, a.Id);
            }
            system.debug('--ACCOUNT WITH CONTRACTIDS'+accountWithContractIds);
        }
        if(highLevelParentAccountIds.size()>0) {
            accountWithContractIds.putAll(associateParentAccounts(highLevelParentAccountIds));
        }
        return accountWithContractIds;
    }
    
    public static Map<Id,Id> associateParentAccounts(Map<Id,Id> highLevelParentAccountIds) {
        Map<Id,Id> higherLevelParentAccountIds = new Map<Id,Id>();
        Map<Id,Id> accountWithContractIds = new Map<Id, Id>(); // This is a map which contains account Id which has a contract, and the child account which was referenced in Retail vehicle
        for(Account a : [Select Id, Has_a_Contract__c, Parent.Id, Parent.Has_a_Contract__c, Parent.Parent.Id, Parent.Parent.Has_a_Contract__c,
                         Parent.Parent.Parent.Id, Parent.Parent.Parent.Has_a_Contract__c, Parent.Parent.Parent.Parent.Id, Parent.Parent.Parent.Parent.Has_a_Contract__c,
                         Parent.Parent.Parent.Parent.Parent.Id, Parent.Parent.Parent.Parent.Parent.Has_a_Contract__c from Account where Id in :highLevelParentAccountIds.keyset()]) {
            
            if(a.Parent.Parent.Parent.Parent.Parent.Id != null && !a.Parent.Parent.Parent.Parent.Parent.Has_a_Contract__c &&
               !a.Parent.Parent.Parent.Parent.Has_a_Contract__c && !a.Parent.Parent.Parent.Has_a_Contract__c && 
               !a.Parent.Parent.Has_a_Contract__c && !a.Parent.Has_a_Contract__c && !a.Has_a_Contract__c) {
                higherLevelParentAccountIds.put(a.Parent.Parent.Parent.Parent.Parent.Id,highLevelParentAccountIds.get(a.Id));
            }
            if(a.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Id, highLevelParentAccountIds.get(a.Id));
            } else if(a.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Id, highLevelParentAccountIds.get(a.Id));
            } else if(a.Parent.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Parent.Id, highLevelParentAccountIds.get(a.Id));
            } else if(a.Parent.Parent.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Parent.Parent.Id, highLevelParentAccountIds.get(a.Id));
            } else if(a.Parent.Parent.Parent.Parent.Parent.Has_a_Contract__c) {
                accountWithContractIds.put(a.Parent.Parent.Parent.Parent.Parent.Id, highLevelParentAccountIds.get(a.Id));
            }
        }
        if(higherLevelParentAccountIds.size()>0) {
            accountWithContractIds.putAll(associateParentAccounts(higherLevelParentAccountIds));
        }
        return accountWithContractIds;
    }
    
    public static void createCampaignSales(List<Retailed_Vehicles__c> newRetailedVehicles){
    	
    	Set<Id> accountIds = new Set<Id>();
    	Set<Id> newRetailedVehicleIds = new Set<Id>();
    	Set<Id> newVehicleIds = new Set<Id>();
    	Set<Id> campaignIds = new Set<Id>();
    	Map<Id, Id> vehicleToCampaignMap = new Map<Id, Id>();
    	for(Retailed_Vehicles__c retailedVehicle : newRetailedVehicles){
    		if(retailedVehicle.TECH_Organisation_RecordtypeName__c == 'Organisation'){
    			accountIds.add(retailedVehicle.Organisation__c);
    			newRetailedVehicleIds.add(retailedVehicle.Id);
    			newVehicleIds.add(retailedVehicle.Vehicle__c);
    		}
    	}
    	List<Retailed_Vehicles__c> existingRetailedVehicles = [SELECT Id, Organisation__c, Retailed_Date__c FROM Retailed_Vehicles__c WHERE Organisation__c IN :accountIds AND Id NOT IN :newRetailedVehicleIds ORDER BY Organisation__c DESC];
    	List<Campaign_Model__c> campaignModels = [SELECT Id, Campaign__c, Vehicle__c FROM Campaign_Model__c WHERE Vehicle__c IN: newVehicleIds];
    	System.debug('@@MODELS: '+campaignModels);
    	for(Campaign_Model__c campaignModel : campaignModels){
    		campaignIds.add(campaignModel.Campaign__c);
    		vehicleToCampaignMap.put(campaignModel.Vehicle__c, campaignModel.Campaign__c);
    	}
    	
    	List<Campaign> existingCampaigns = [SELECT Id, StartDate FROM Campaign where Id IN :campaignIds];
    	System.debug('@@EXISTCAMP: '+existingCampaigns);
    	Map<Id, Date> accountRetailVehicleHistoryByIds = new Map<Id, Date>();
    	for(Retailed_Vehicles__c retailedVehicles : existingRetailedVehicles){
    		if(accountRetailVehicleHistoryByIds.containskey(retailedVehicles.Organisation__c)){
    			System.debug('##COMPAREDATE: '+accountRetailVehicleHistoryByIds.get(retailedVehicles.Organisation__c)+' : '+retailedVehicles.Retailed_Date__c);
    			if(accountRetailVehicleHistoryByIds.get(retailedVehicles.Organisation__c) < retailedVehicles.Retailed_Date__c){
    				accountRetailVehicleHistoryByIds.remove(retailedVehicles.Organisation__c);
    				accountRetailVehicleHistoryByIds.put(retailedVehicles.Organisation__c, retailedVehicles.Retailed_Date__c);
    			}
    		} else {
    			accountRetailVehicleHistoryByIds.put(retailedVehicles.Organisation__c, retailedVehicles.Retailed_Date__c);
    		}
    	}
    	List<Campaign_Sales__c> newCampaignSales = new List<Campaign_Sales__c>();
    	for(Campaign campaign : existingCampaigns){
    		for(Retailed_Vehicles__c retailVehicle : newRetailedVehicles){
    			System.debug('##CAMP: '+vehicleToCampaignMap.get(retailVehicle.Vehicle__c) + ' :: '+campaign.Id);
    			if(vehicleToCampaignMap.get(retailVehicle.Vehicle__c) == campaign.Id){
    				if(retailVehicle.TECH_Organisation_RecordtypeName__c == 'Organisation'){
	    				Campaign_Sales__c campaignSales = new Campaign_Sales__c();
		    			campaignSales.Campaign__c = campaign.Id;
		    			campaignSales.Retailed_Vehicle__c = retailVehicle.Id;
		    			campaignSales.Dealer__c = retailVehicle.Dealer__c;
		    			System.debug('@@COMPARESTARTDATE '+accountRetailVehicleHistoryByIds.get(retailVehicle.Organisation__c) + ' -- '+campaign.StartDate.addDays(-670));
		    			if(accountRetailVehicleHistoryByIds.get(retailVehicle.Organisation__c) < campaign.StartDate && 
		    				accountRetailVehicleHistoryByIds.get(retailVehicle.Organisation__c) > campaign.StartDate.addDays(-670)){
		    				campaignSales.Customer_Type__c = 'Existing';
		    			} else if(accountRetailVehicleHistoryByIds.get(retailVehicle.Organisation__c) < campaign.StartDate.addDays(-670)){
		    				campaignSales.Customer_Type__c = 'Re-activated';
		    			} else {
		    				campaignSales.Customer_Type__c = 'New';
		    			}
		    			newCampaignSales.add(campaignSales);
	    			}
    			}
    		}
    	}
    	if(newCampaignSales.size() > 0){
    		insert newCampaignSales;
    	}
    }
}