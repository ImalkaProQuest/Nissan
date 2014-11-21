@isTest(SeeAllData=true)
private class CreateCampaignSalesTest {

	static testmethod void testInsertCampaignModels1(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Campaign> campaigns = TestDataUtility.createCampaigns(1);
		insert campaigns;
		
		List<Campaign_Model__c> campaignModels = TestDataUtility.createCampaignModel(1, campaigns, vehicle);
		insert campaignModels;
		
		Test.startTest();	
			List<Retailed_Vehicles__c> retailedVehicles = TestDataUtility.createRetailedVehicles(1,accounts,vehicle);
			insert retailedVehicles;
		Test.stopTest();
	}
	
	static testmethod void testInsertCampaignModels2(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Campaign> campaigns = TestDataUtility.createCampaigns(1);
		campaigns.get(0).StartDate = Date.Today().addDays(-90);
		campaigns.get(0).EndDate = Date.Today().addDays(-60);
		insert campaigns;
		
		List<Campaign_Model__c> campaignModels = TestDataUtility.createCampaignModel(1, campaigns, vehicle);
		insert campaignModels;
		
		Test.startTest();	
			List<Retailed_Vehicles__c> retailedVehicles = TestDataUtility.createRetailedVehicles(2,accounts,vehicle);
			retailedVehicles.get(0).Retailed_Date__c = Date.Today().addDays(-360);
			insert retailedVehicles;
		Test.stopTest();
	}
	
	static testmethod void testInsertCampaignModels3(){
		
		List<Account> accounts = TestDataUtility.createAccounts(1,'Organisation');
		insert accounts;
		
		Product2 vehicle = [Select Id from Product2 where SFDC_Product_Level__c = 1 LIMIT 1];
		
		List<Campaign> campaigns = TestDataUtility.createCampaigns(1);
		insert campaigns;
		
		List<Campaign_Model__c> campaignModels = TestDataUtility.createCampaignModel(1, campaigns, vehicle);
		insert campaignModels;
		
		List<Retailed_Vehicles__c> retailedVehicles = TestDataUtility.createRetailedVehicles(2,accounts,vehicle);
		retailedVehicles.get(0).Retailed_Date__c = Date.Today().addDays(-100);
		insert retailedVehicles;
		
		Test.startTest();	
			List<Retailed_Vehicles__c> retailedVehicles2 = TestDataUtility.createRetailedVehicles(1,accounts,vehicle);
			retailedVehicles2.get(0).Retailed_Date__c = Date.Today().addDays(-45);
			insert retailedVehicles2;
		Test.stopTest();
	}
}