public class SpecialAssistanceHelper {

    public static void UpdateOrgs(List<Special_Assistance__c> newSA){
        Set<Id> organisationIds = new Set<Id>();
        Map<Id, Account> toUpdateOrgs = new Map<Id, Account>();
        Map<Id, String> primaryDealerByIds = new Map<Id, String>();
    
        for(Special_Assistance__c sa : newSA) {
            if(sa.Organisation__c!=null && sa.Status__c == 'Approved') {
                organisationIds.add(sa.Organisation__c);
            }
        }
        
        List<Account> dealerAccounts = new List<Account>();
        dealerAccounts = [
                SELECT
                    Id,
                    Primary_Dealer__c,
                    Primary_Dealer__r.RecordType.DeveloperName
                FROM
                    Account
                WHERE
                    Id
                IN
                    :organisationIds
                ];
                
        for(Account account : dealerAccounts){
            System.debug('##RECORDTYPE: '+account.Primary_Dealer__r.RecordType.DeveloperName);
            primaryDealerByIds.put(account.Id, account.Primary_Dealer__r.RecordType.DeveloperName);
        }
    
        for(Special_Assistance__c sa : newSA) {
            if(sa.Organisation__c!=null && sa.Status__c == 'Approved') {
                if(primaryDealerByIds.get(sa.Organisation__c) == 'Dealer'){
                    toUpdateOrgs.put(sa.Organisation__c,new Account());
                }
            }
        }
        
        if(toUpdateOrgs.size()>0) {
            updateAllOrgs(toUpdateOrgs);
        }
    }
    
    public static void UpdateOrgs(List<Special_Assistance__c> oldSA, List<Special_Assistance__c> newSA){
        Set<Id> organisationIds = new Set<Id>();
        Map<Id, Account> toUpdateOrgs = new Map<Id, Account>();
        Map<Id, String> primaryDealerByIds = new Map<Id, String>();
        
        for(Special_Assistance__c sa : newSA) {
            if(sa.Organisation__c!=null && sa.Status__c == 'Approved') {
                organisationIds.add(sa.Organisation__c);
            }
        }
        
        List<Account> dealerAccounts = new List<Account>();
        dealerAccounts = [
                SELECT
                    Id,
                    Primary_Dealer__c,
                    Primary_Dealer__r.RecordType.DeveloperName
                FROM
                    Account
                WHERE
                    Id
                IN
                    :organisationIds
                ];
                
        for(Account account : dealerAccounts){
            System.debug('##RECORDTYPE: '+account.Primary_Dealer__r.RecordType.DeveloperName);
            primaryDealerByIds.put(account.Id, account.Primary_Dealer__r.RecordType.DeveloperName);
        }
    
        for(Integer i=0; i<oldSA.size(); i++) {
            if(primaryDealerByIds.get(newSA[i].Organisation__c) == 'Dealer'){
                if((newSA[i].Status__c != oldSA[i].Status__c) &&
                    ((newSA[i].Organisation__c!=null && newSA[i].Status__c == 'Approved') ||
                    (newSA[i].Organisation__c!=null && oldSA[i].Status__c == 'Approved'))) {
                     toUpdateOrgs.put(newSA[i].Organisation__c,new Account(
                                                                        id=newSA[i].Organisation__c,
                                                                        Amount_Remaining_by_Organisation__c = 0, 
                                                                        Amount_Claimed_by_Organisation__c = 0,
                                                                        Amount_Requested_by_Organisation__c = 0,
                                                                        Vehicles_Approved_for_Organisation__c = 0, 
                                                                        Vehicles_Claimed_by_Organisation__c = 0,
                                                                        Vehicles_Remaining_by_Organisation__c = 0
                                                                    ));
                 }
            }
            
        }
        
        if(toUpdateOrgs.size()>0) {
            updateAllOrgs(toUpdateOrgs);
        }
    }
    
    public static void updateAllOrgs(Map<Id, Account> toUpdateOrgs) {
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
        if(!toUpdateOrgs.isempty()){
            Update toUpdateOrgs.values();   
        }
    }
}