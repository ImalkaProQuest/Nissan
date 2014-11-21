trigger SpecialAssistanceAfterInsert on Special_Assistance__c (after insert) {
    
    Map<Id, Account> toUpdateOrgs = new Map<Id, Account>();
    
    for(Special_Assistance__c sa : trigger.new) {
        if(sa.Organisation__c!=null && sa.Status__c == 'Approved') {
            toUpdateOrgs.put(sa.Organisation__c,new Account());
        }
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