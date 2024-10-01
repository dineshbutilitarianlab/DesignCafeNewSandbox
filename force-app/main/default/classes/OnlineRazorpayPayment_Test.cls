@isTest
public class OnlineRazorpayPayment_Test {
    public static testmethod void PayDataTest(){
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

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
        acc.Converted_Lead_ID__c = '00LeadID';
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
        opp.Lead_Id__c = '00LeadID';
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
        
        OnlineRazorpayPayment.Params op = new OnlineRazorpayPayment.Params();
        op.OpportunityId = opp.id;
        op.ReceiptAmount = inv.Amount__c;
        op.InvoiceName = 'Test';
        op.InvoiceNumber = '001';
        op.paymentReceivedDate = STring.valueOf(System.today());
        op.TransactionID = '123456';
        op.PaymentMode = 'Online';
        op.PaymentReceipt = 'test';
        
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSON.serialize(op)); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Test.startTest();
        OnlineRazorpayPayment.PayData();
        Test.stopTest();
    }
    
}