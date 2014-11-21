@isTest
public class TestDataProvider {
	
	public static Id orgId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organisation').getRecordTypeId();
   	public static Id dealerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();    
   	
	public static List<Contract> createContracts(List<Account> Organisation, List<Product2> products, List<Associated_Product__c> associatedProducts) {
    	List<Contract> contracts = new List<Contract>();
    	for(Integer i = 0; i<15; i++) {
    		contracts.add(new Contract(AccountId = Organisation[i].Id));
    	}
    	for(Integer i=0; i<15; i++) {
    		if(i<10) {
        		Organisation[i].Has_a_Contract__c = true;
        	} else {
        		Organisation[i].ParentId = Organisation[i-1].Id;
        	}
        }
        update Organisation;
        insert contracts;
        for(Contract c : contracts) {
        	c.Status='Active';
        }
        update contracts;
        for(Integer i = 0; i<15; i++) {
    		products.add(new Product2(Name = 'Test a Product'));
    	}
		insert products;
		for(Integer i = 0; i<15; i++) {
    		associatedProducts.add(new Associated_Product__c(Product__c = products[i].Id, Contract__c = contracts[i].Id));
    	}
        insert associatedProducts;
		
		for(Integer i=1; i<15; i++) {
			Organisation[i].ParentId = Organisation[i-1].Id;
        }
        
        update Organisation;
        return contracts;
    }
    
    public static List<Special_Assistance__c> createSpecialAssistance(Integer n, List<Account> Organisation) {
        List<Account> dealers = new List<Account>();
        
        List<Special_Assistance__c> sas = new List<Special_Assistance__c>();
        for(Integer i=0; i<n; i++) {
            dealers.add(new Account(Name='Dealer'+i, RecordTypeId = dealerId));
        }
        insert dealers;
        for(Integer i=0; i<n; i++) {
            Organisation.add(new Account(Name='Org'+i, RecordTypeId = orgId));
        }
        insert Organisation;
        for(Integer i=0; i<n; i++) {
            Special_Assistance__c sa = new Special_Assistance__c(Effective_From_Date__c = system.today(), 
                                                                 Effective_To_Date__c = system.today().addDays(20), 
                                                                 Amount_Requested_Per_Vehicle__c = 100,
                                                                 Approved_Amount_per_Vehicle__c = 100,
                                                                 Approved_Date__c = system.today(),
                                                                 Vehicles_Requested__c = 100,
                                                                 Dealer__c = dealers[i].Id,
                                                                 Status__c = 'Approved',
                                                                 Organisation__c = Organisation[i].Id);
            sas.add(sa);
        }
        insert sas;
        return sas;
    }
    
    public static List<Retailed_Vehicles__c> createRetailedVehicles(List<Special_Assistance__c> sas, List<Account> Organisation, List<Product2> products) {
        List<Retailed_Vehicles__c> rvs = new List<Retailed_Vehicles__c>();
        for(Special_Assistance__c sa : sas) {
            for(Integer i=0; i<15;i++) {
                Retailed_Vehicles__c rv = new Retailed_Vehicles__c(Special_Assistance_Number__c = sa.Id, Quantity__c = 1);
                rvs.add(rv);
            }
        }
        Special_Assistance__c sa = sas[0];
        for(Integer i=0;i<200;i++){
        	Retailed_Vehicles__c rv;
        	if(Math.mod(i,2)==0)
        		rv = new Retailed_Vehicles__c(Special_Assistance_Number__c = sa.Id, Quantity__c = 1, Organisation__c = Organisation[Math.mod(i,15)].Id, Level_3_Vehicle_Variant__c = products[Math.mod(i,15)].Id, Vehicle__c = products[Math.mod(i,15)].Id);
        	else
        		rv = new Retailed_Vehicles__c(Special_Assistance_Number__c = sa.Id, Quantity__c = -1, Organisation__c = Organisation[Math.mod(i,15)].Id, Level_3_Vehicle_Variant__c = products[Math.mod(i,15)].Id, Vehicle__c = products[Math.mod(i,15)].Id);
    		rvs.add(rv);
        }
        if(rvs.size()>0) {
            insert rvs;
        }
		return rvs;
    }
    
    public static List<Account> createAccounts(String name, integer count){
		List<Account> lstAccount = new List<Account>();
		 
		for(integer i =0; i < count; i++){
			Account acct = new Account();
			acct.Name = name;
			lstAccount.add(acct);
		}
		return lstAccount;
    }

    public static List<Opportunity> createOpportunities(String name, String stageName, List<Account> lstAccount, integer count){
		
		List<Opportunity> lstOpportunity = new List<Opportunity>();
		 
		for(integer i =0; i < count; i++){
			Opportunity oppty = new Opportunity();
			oppty.Name = name;
			oppty.CloseDate =  system.today();
			oppty.StageName = stageName;
			oppty.AccountId = lstAccount[Math.mod(i,testOpportunity.accountCount)].id;
			lstOpportunity.add(oppty);
		}
		return lstOpportunity;
    }
    
    public static List<Reporting_Month__c> createReportingMonths(String name , integer count){
		
		List<Reporting_Month__c> lstReportingMonth = new List<Reporting_Month__c>();
		 
		for(integer i =0; i < count; i++){
			Reporting_Month__c reportingMonth = new Reporting_Month__c();
			reportingMonth.Name = name + i;
			lstReportingMonth.add(reportingMonth);
		}
		return lstReportingMonth;
    }
	
	public static List<Delivery_Schedule__c> createDeliverySchedules(List<Reporting_Month__c> reportingMonths, List<Opportunity> lstOpporty , integer count){
		
		List<Delivery_Schedule__c> lstDeliverySchedules = new List<Delivery_Schedule__c>();
		 
		for(integer i =0; i < count; i++){
			Delivery_Schedule__c deliverySchedules = new Delivery_Schedule__c();
			deliverySchedules.Opportunity__c = lstOpporty[Math.mod(i,testOpportunity.opportunityCount)].id;
			deliverySchedules.Report_Month__c = reportingMonths[Math.mod(i,testOpportunity.deliveryScheduleCount)].id;
			lstDeliverySchedules.add(deliverySchedules);
		}
		return lstDeliverySchedules;
    }       
}