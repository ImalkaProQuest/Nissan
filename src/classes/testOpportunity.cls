@isTest
public class testOpportunity {
	public STATIC FINAL integer accountCount = 200;
	public STATIC FINAL integer opportunityCount = 200;
	public STATIC FINAL integer reportingMonthCount = 200;
	public STATIC FINAL integer deliveryScheduleCount = 200;
			
    static testMethod void testLostOpportunities() {
        
        List<Account> lstAccount = TestDataProvider.createAccounts('Test Accounts', accountCount);
        insert lstAccount;
        
		List<Opportunity> lstOpportunity = TestDataProvider.createOpportunities('Test Opportunities', 'Promote' , lstAccount, opportunityCount);
		insert lstOpportunity;
		
		List<Reporting_Month__c> lstReportingMonth = TestDataProvider.createReportingMonths('Test Month', reportingMonthCount);
		insert lstReportingMonth;
		
		List<Delivery_Schedule__c> lstDeliverySchedule = TestDataProvider.createDeliverySchedules(lstReportingMonth, lstOpportunity, deliveryScheduleCount);
		insert lstDeliverySchedule;
		
		Test.startTest();
		
			for(Opportunity oppty : lstOpportunity){
				oppty.StageName = 'Closed Lost';
			} 
			update (lstOpportunity);
			
			lstDeliverySchedule = [SELECT id from Delivery_Schedule__c];
			system.assertEquals(0,lstDeliverySchedule.size());
		Test.stopTest();
    }
}