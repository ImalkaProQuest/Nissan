/**
    *This class contains the creation of test data for the test classes
    *@author Kim Noceda - Proquest IT
    *@version 1.0 Created 10/13/2014
**/
public with sharing class TestDataUtility {
    
    //CREATE ACCOUNT
    public static List<Account> createAccounts(integer numberOfAccounts, String recordTypeName){
        Id recordTypeId = [Select Id from RecordType where SObjectType =: 'Account' AND DeveloperName =: recordTypeName LIMIT 1].Id;
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numberOfAccounts; i++){
            Account account = new Account();
            account.RecordTypeId = recordTypeId;
            account.Name = 'TestOrganisationName';
            
            accounts.add(account);
        }
        
        return accounts;
    }
    
    //CREATE CONTACT
    public static List<Contact> createContacts(integer numberOfContact, List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < numberOfContact; i++){
            Contact contact = new Contact();
            contact.AccountId = accounts.get(0).Id;
            contact.FirstName = 'TestFirstName';
            contact.LastName = 'TestLastName';
            contact.Email = 'testemail@test.com';
            contacts.add(contact);
        }
        
        return contacts;
    }
    
    //CREATE EVALUATION VEHICLE
    public static List<Evaluation_Vehicle__c> createEvaluationVehicle(integer numberOfVehicles, Product2 product){
    	List<Evaluation_Vehicle__c> evalVehicles = new List<Evaluation_Vehicle__c>();
    	 for(Integer i = 0; i < numberOfVehicles; i++){
            Evaluation_Vehicle__c evalVehicle = new Evaluation_Vehicle__c();
            evalVehicle.Vehicle__c = product.Id;
            evalVehicle.Status__c = 'Live';
            evalVehicle.SUO__c = '000000';
            evalVehicle.Region__c = 'Northern';
            
            evalVehicles.add(evalVehicle);
        }
        
        return evalVehicles;
    }
    
    //CREATE EVALUATION BOOKING
    public static List<Evaluation_Booking__c> createEvaluationBooking(integer numberOfBookings, List<Evaluation_Vehicle__c> evalVehicles, List<Contact> contact){
    	List<Evaluation_Booking__c> evalBookings = new List<Evaluation_Booking__c>();
    	 for(Integer i = 0; i < numberOfBookings; i++){
            Evaluation_Booking__c evalBooking = new Evaluation_Booking__c();
            evalBooking.Evaluation_Vehicle__c = evalVehicles.get(0).Id;
            evalBooking.Contact__c = contact.get(0).Id;
            evalBooking.Start_Date__c = Date.Today();
            evalBooking.End_Date__c = Date.Today().addDays(20);
            
            evalBookings.add(evalBooking);
        }
        
        return evalBookings;
    }
    
    //CREATE EVALUATION BOOKING2
    public static List<Evaluation_Booking__c> createEvaluationBooking2(integer numberOfBookings, List<Evaluation_Vehicle__c> evalVehicles, List<Contact> contact){
    	List<Evaluation_Booking__c> evalBookings = new List<Evaluation_Booking__c>();
    	 for(Integer i = 1; i <= numberOfBookings; i++){
            Evaluation_Booking__c evalBooking = new Evaluation_Booking__c();
            evalBooking.Evaluation_Vehicle__c = evalVehicles.get(0).Id;
            evalBooking.Contact__c = contact.get(0).Id;
            evalBooking.Start_Date__c = Date.newInstance(Date.Today().year(),i,1);
            evalBooking.End_Date__c = Date.Today().addDays(10);
            
            evalBookings.add(evalBooking);
        }
        
        return evalBookings;
    }
    
    //CREATE SURVEY RESULTS
    public static List<Survey_Result__c> createSurveyResult(integer numberOfSurveys, List<Contact> contacts, List<Evaluation_Booking__c> evalBookings){
    	List<Survey_Result__c> surveyResults = new List<Survey_Result__c>();
    	for(Integer i = 1; i <= numberOfSurveys; i++){
            Survey_Result__c surveyResult = new Survey_Result__c();
            surveyResult.Contact__c = contacts.get(0).Id;
            surveyResult.Evaluation_Booking__c = evalBookings.get(0).Id;
            
            surveyResults.add(surveyResult);
        }
        
        return surveyResults;
    }
    
    //CREATE CAMPAIGN
    public static List<Campaign> createCampaigns(integer numberOfCampaigns){
    	List<Campaign> campaigns = new List<Campaign>();
    	for(integer i = 0; i <= numberOfCampaigns; i++){
    		Campaign campaign = new Campaign();
    		campaign.Name = 'TestCampaign'+i;
    		campaign.StartDate = Date.Today().addDays(-30);
    		campaign.EndDate = Date.Today().addDays(30);
    		
    		campaigns.add(campaign);
    	}
    	
    	return campaigns;
    }
    
    //CREATE RETAILED VEHICLES
    public static List<Retailed_Vehicles__c> createRetailedVehicles(integer numberOfRetailedVehicles, List<Account> organisations, Product2 product){
    	List<Retailed_Vehicles__c> retailedVehicles = new List<Retailed_Vehicles__c>();
    	for(integer i = 0;i < numberOfRetailedVehicles; i++){
    		Retailed_Vehicles__c retailedVehicle = new Retailed_Vehicles__c();
    		retailedVehicle.Organisation__c = organisations.get(0).Id;
    		retailedVehicle.Vehicle__c = product.Id;
    		retailedVehicle.Retailed_Date__c = Date.Today();
    		
    		retailedVehicles.add(retailedVehicle);
    	}
    	
    	return retailedVehicles;
    }
    
    //CREATE CAMPAIGN MODELS
    public static List<Campaign_Model__c> createCampaignModel(integer numberOfCampaignModels, List<Campaign> campaigns, Product2 vehicle){
    	List<Campaign_Model__c> campaignModels = new List<Campaign_Model__c>();
    	for(integer i = 0; i < numberOfCampaignModels;i++){
    		Campaign_Model__c campaignModel = new Campaign_Model__c();
    		campaignModel.Campaign__c = campaigns.get(0).Id;
    		campaignModel.Vehicle__c = vehicle.Id;
    		
    		campaignModels.add(campaignModel);
    	}
    	
    	return campaignModels;
    }
    
    //CREATE FLEET VEHICLES
    public static List<Nissan_Fleet_Vehicles__c> createFleetVehicles(integer numberOfFleetVehicles){
    	List<Nissan_Fleet_Vehicles__c> fleetVehicles = new List<Nissan_Fleet_Vehicles__c>();
    	for(integer i = 0; i < numberOfFleetVehicles;i++){
    		Nissan_Fleet_Vehicles__c fleetVehicle = new Nissan_Fleet_Vehicles__c();
    		fleetVehicle.Name = 'testFleetVehicle'+i;
    		
    		fleetVehicles.add(fleetVehicle);
    	}
    	
    	return fleetVehicles;
    }
}