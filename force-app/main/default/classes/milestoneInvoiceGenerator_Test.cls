@isTest
public class milestoneInvoiceGenerator_Test {
    @isTest static void getgenerateInvoiceDataTest(){
        Account acc = new Account();
        acc.FirstName = 'test opp';
        acc.LastName ='test opp';
        acc.PersonEmail ='test@test.com';
        acc.PersonMobilePhone ='9000009900';
        acc.ShippingStreet = '7th block kormangala';
        acc.ShippingCity ='Bengaluru';
        acc.ShippingState = 'Karnataka';
        acc.ShippingPostalCode ='560096';
        acc.BillingCountry ='India';
        acc.BillingStreet = '7th block kormangala';
        acc.BillingCity ='Bengaluru';
        acc.BillingState = 'Karnataka';
        acc.BillingPostalCode ='560096';
        acc.BillingCountry ='India';
        insert acc;
        System.debug('Account'+acc);
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.id;
        opp.Name ='test opp';
        opp.StageName ='Meeting Done';
        opp.CloseDate =System.today();
        opp.Project_Name__c ='Test opp';
        opp.Amount =10000;
        opp.Meeting_Type__c = 'EC';
        opp.Meeting_Venue__c='MGDC';
        opp.Source_Customer_ID__c = 'TEST001';
        insert opp;
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project_Accepted').getRecordTypeId();
        Milestone1_Project__c project = new Milestone1_Project__c();
        project.Name = 'test';
        project.Customer__c = acc.Id;
        project.RecordTypeId = projectRecordTypeId;
        project.Opportunity__c = opp.id;
        insert project;
        
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c();
        milestone.name='test';
        milestone.Project__c = project.id;
        milestone.Type__c='KYC';
        milestone.Order__c = 1;
        insert milestone;
        
        Milestone1_Milestone__c ml1 = new Milestone1_Milestone__c();
        ml1.name='test1';
        ml1.Project__c = project.id;
        ml1.Type__c='KYC';
        ml1.EligibleAmountPercentage__c = 30;
        ml1.order__c = 2;
        insert ml1;
        
        Invoice__c inv = new Invoice__c();
        inv.CustomerId__c = 'DC-001';
        inv.Payment_Name__c = 'Test';
        inv.Base_Amount__c = 1000;
        inv.SGST__c  = 1000;
        inv.CGST__c  = 1000;
        inv.IGST18__c  = 1000;
        inv.Total_Tax_Amount__c  = 2000;
        inv.Total_Amount__c  = 3000; 
        inv.Invoice_Date__c = System.today();
        inv.Invoice_Number__c = 'INV-001';
        inv.InvoicePdfLink1__c = 'Test';
        inv.Payment_Link__c = 'Test';
        inv.Milestone__c = milestone.id;
        inv.Customer__c = opp.AccountId;
        inv.Amount__c = 1000;
        inv.Project__c = milestone.Project__c;
        insert inv;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MilestoneController_Mockup());
        milestoneInvoiceGenerator.generateInvoice(milestone.id);
        milestoneInvoiceGenerator.showButton(milestone.id);
        Test.stopTest();
        
    }
    
}