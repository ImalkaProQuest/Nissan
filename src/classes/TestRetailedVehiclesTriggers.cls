@isTest
private class TestRetailedVehiclesTriggers {

	static Id orgId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organisation').getRecordTypeId();
   	static Id dealerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();  

    static testMethod void TestRetailedVehiclesBeforeAndAfterInsert() {
    	List<Account> Organisation = new List<Account>();
        List<Special_Assistance__c> sas = TestDataProvider.createSpecialAssistance(50, Organisation);
        List<Product2> products = new List<Product2>();
        List<Associated_Product__c> associatedProducts = new List<Associated_Product__c>();
        List<Contract> contracts = TestDataProvider.createContracts(Organisation, products, associatedProducts);
        Test.startTest();
        TestDataProvider.createRetailedVehicles(sas, Organisation, products);
        Test.stopTest();
        
        for(Special_Assistance__c sa : [Select Vehicles_Claimed__c from Special_Assistance__c]) {
            system.assert(sa.Vehicles_Claimed__c ==15);
        }
        for(Account a : [Select Amount_Claimed_by_Organisation__c, Amount_Remaining_by_Organisation__c, Amount_Requested_by_Organisation__c from Account where Id = :orgId]) {
            system.assertNotEquals(a.Amount_Claimed_by_Organisation__c,0);
            system.assertNotEquals(a.Amount_Remaining_by_Organisation__c,0);
        }
    }
}