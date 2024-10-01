@isTest
public class PaymentRequestsHandler_GraphQL_Test {
    
    @isTest public static void addrequestPaymetTest(){
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        
        Account acc =new Account();
        acc.Name='TestAccount';
        acc.PAN__c='ASDFG1234M';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='06BZAHM6385P6Z2';
        acc.BillingPostalCode='430056';
        acc.BillingStreet='Mahatma Gandhi Road';
        acc.ShippingState='Karnataka';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.ShippingPostalCode='430056';
        acc.ShippingCountry='India';
        acc.ShippingState='Karnataka';
        acc.ShippingStreet='Mahatma Gandhi Road';
        acc.BillingCity='Bengaluru';
        acc.ShippingCity='Bengaluru';
        acc.Customer_type__c='B2C';
        acc.Converted_Lead_ID__c='ASDF45678ASD';
        insert acc;
        
        
        
        Design_User__c Design= new Design_User__c();
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        
        opportunity opty=new opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();
        opty.Amount=3124;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = design.Id;
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Lead_Id__c='ASD45678HHH';
        insert opty;         
        
        Request_Payment__c reqPay = new  Request_Payment__c ();
        reqPay.Name='PaymentRequestTest';
        reqPay.Category__c='Modular';
        reqPay.Client_ID__c='DC-35711';
        reqpay.Status__c='Pending';
        reqpay.Request_Amount__c= 200;
        reqpay.Description__c='this is test class';
        reqpay.Opportunity__c=opty.id;
        reqpay.Request_Id__c='PR-jZM2lAuvL';
        insert reqPay;
        List<Request_Payment__c> reqPayList = new List<Request_Payment__c>();
        reqPayList.add(reqpay);
        
        Request_Payment__c reqPay1 = new  Request_Payment__c ();
        reqPay1.Name='PaymentRequestTest';
        reqPay1.Category__c='Modular';
        reqPay1.Client_ID__c='DC-35711';
        reqPay1.Status__c='Pending';
        reqPay1.Request_Amount__c= 200;
        reqPay1.Description__c='this is test class';
        reqPay1.Opportunity__c=opty.id;
        reqPay1.Request_Id__c='PR-jMM2lAuvL';
        insert reqPay1;
        reqPay1.Request_Amount__c= 500;
        reqPay1.Status__c='Paid';
       update reqPay1;
        
        Request_Payment__c reqPay2 = new  Request_Payment__c ();
        reqPay2.Name='PaymentRequestTest';
        reqPay2.Category__c='Modular';
        reqPay2.Client_ID__c='DC-35711';
        reqPay2.Status__c='Pending';
        reqPay2.Request_Amount__c= 200;
        reqPay2.Description__c='this is test class';
        reqPay2.Opportunity__c=opty.id;
        reqPay2.Request_Id__c='PR-jEM2lAuvL';
        insert reqPay2;
        
        Request_Payment__c reqPay3 = new  Request_Payment__c ();
        reqPay3.Name='PaymentRequestTest';
        reqPay3.Category__c='Modular';
        reqPay3.Client_ID__c='DC-35713';
        reqPay3.Status__c='Pending';
        reqPay3.Request_Amount__c= 200;
        reqPay3.Description__c='this is test class';
        reqPay3.Opportunity__c=opty.id;
        reqPay3.Request_Id__c='PR-jEM2lKuvL';
        upsert reqPay3;
        
        Quote q = new Quote();
        q.Name = 'TestName';
        q.opportunityId = opty.Id;     
        q.Latest_Quote__c = true;
        insert q;
        q.OwnerId = opty.OwnerId;
        //update q;
        PaymentRequestsHandler_GraphQL.getPaymentRequest(opty.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        PaymentRequestsHandler_GraphQL.addPaymentRequest(reqPayList);
       	PaymentRequestsHandler_GraphQL.updatepaymentRequest(reqPay1.id);
        delete reqPay2;
        PaymentRequestsHandler_GraphQL.deletepaymentRequest(reqPay2.Request_Id__c);
        upsert reqPay3;
        PaymentRequestsHandler_GraphQL.getQuotes(opty.Id);
        PaymentRequestsHandler_GraphQL.getQuoteDetails(q.Id);
        Test.stopTest();
    } 
}