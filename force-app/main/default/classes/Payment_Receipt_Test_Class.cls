@isTest 
public class Payment_Receipt_Test_Class {
    
    @isTest static void createData(){
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
        
        Invoice_Payment__c InvPay = new Invoice_Payment__c();
        InvPay.Opportunity_Name__c = opty.id;
        InvPay.Mode_of_Receipt__c = 'Cash';
        InvPay.Date_of_Payment__c = system.today();
        InvPay.RP_Recipt_ID__c = 'TR456-73';
        InvPay.Modular_value__c=1000;
        InvPay.Site_Service_value__c=1000;
        InvPay.Receipt_Amount__c=2000;    
        InvPay.paymentID__c = null;
        InvPay.Request_Payment_Modular__c = reqPay.Id;
        InvPay.Request_Payment_SiteService__c = reqPay.Id;
        InvPay.Payment_confirmation_status__c = 'rejected';
        insert InvPay;
        Test.startTest();
        InvPay.Modular_value__c=2502;
        InvPay.Site_Service_value__c =3000;
         Test.setMock(HttpCalloutmock.class, new AuthorizationTokenMock());
        update InvPay;
        delete InvPay;
        Test.stopTest();
        
    }
 
    
}