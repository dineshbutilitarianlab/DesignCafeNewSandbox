@isTest
public class ManualPaymentTest {
    public static testmethod void manualpaytest(){
        
        Account acc = new Account();
        acc.FirstName ='test';
        acc.LastName ='test';
        acc.PersonEmail='abc@g.com';
        acc.PersonMobilePhone ='0000000000';
        acc.ShippingCity ='Bengaluru';
        acc.ShippingStreet ='Jayanagar';
        acc.ShippingState ='Karnataka';
        acc.ShippingCountry ='India';
        acc.ShippingPostalCode ='560000';
        acc.BillingCity ='Bengaluru';
        acc.BillingStreet ='Jayanagar';
        acc.BillingState ='Karnataka';
        acc.BillingCountry ='India';
        acc.BillingPostalCode ='560000';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.id;
        opp.Name = 'test';
        opp.StageName ='Meeting Done';
        opp.CloseDate = system.today();
        opp.Project_Name__c = 'test';
        opp.Amount = 1000000;
        opp.Meeting_Type__c ='EC';
        opp.Meeting_Venue__c ='MGDC';
        insert opp;
        
        Milestone1_Project__c project = new Milestone1_Project__c();
        project.Name = 'test';
        project.Customer__c = acc.Id;
        project.Amount__c =1000000;
        insert project;
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c();
        milestone.name='test';
        milestone.Project__c = project.id;
        milestone.Type__c='KYC';
        insert milestone;
        
        Invoice__c inv = new Invoice__c();
        inv.Project__c = project.id;
        inv.Amount__c = 150000;
        inv.Milestone__c = milestone.Id;
        inv.Customer__c = acc.Id;
        inv.CHM_Email__c = 'test@gmail.com';
        inv.Designer_Email__c='test1@gmail.com';
        inv.Invoice_Number__c = '001';
        insert inv;
        
        Payment__c payment = new Payment__c();
        payment.paymentId__c ='test';
        payment.Invoice__c = inv.id;
        payment.Amount__c =150000;
        payment.Milestone__c = milestone.id;
        payment.Payment_Date__c =system.today();
        payment.amountPaid__c =5000;
        payment.paymentReceivedDate__c= System.today();
        payment.Transaction_Reference_Number__c ='wertyui';
        payment.Mode__c = 'Cash';
        payment.Payment_Receipt__c ='qwert';
        payment.Revenue_Milestone_Category__c ='100';
        payment.Customer__c = acc.id;
        Test.startTest();
        insert payment;
        Test.stopTest();    
    }
}