@isTest
private class TestAccountTriggers {
	
	static void updateOrganisation(List<Account> Organisation,Id myId) {
		for(Account a : Organisation) {
			a.OwnerId = myId;
		}
		update Organisation;
	}

    static testMethod void TestAccountAfterUpdate() {
    	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    	List<Account> Organisation = new List<Account>(); 
      	User aNewUser = new User(Alias = 'newUser', Email='newuser@testorg.com', 
					       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					       LocaleSidKey='en_US', ProfileId = p.Id, 
					       TimeZoneSidKey='America/Los_Angeles', UserName='nissan2@proquestit.com');
        insert aNewUser;
        system.runAs(aNewUser) {
	        List<Special_Assistance__c> sas = TestDataProvider.createSpecialAssistance(15, Organisation);//Also creates accounts
	        List<Product2> products = new List<Product2>();
	        List<Associated_Product__c> associatedProducts = new List<Associated_Product__c>();
	        List<Contract> contracts = TestDataProvider.createContracts(Organisation, products, associatedProducts); 
			List<Retailed_Vehicles__c> rvs = TestDataProvider.createRetailedVehicles(sas, Organisation, products); 
			for(Integer i=0;i<200;i++){
				rvs[i].Organisation__c = Organisation[Math.mod(i+1,15)].Id; 
			}
			update rvs;
        }
        User anotherUser = new User(Alias = 'new', Email='newuser@testorg.com', 
					       EmailEncodingKey='UTF-8', LastName='proquest', LanguageLocaleKey='en_US', 
					       LocaleSidKey='en_US', ProfileId = p.Id, 
					       TimeZoneSidKey='America/Los_Angeles', UserName='nissan1@proquestit.com');
        insert anotherUser;
        system.runAs(anotherUser) {
        	updateOrganisation(Organisation,anotherUser.Id);
        }
    }
}