@isTest
public class UpdateBookingFormStatusGraphQLTestClass {
    @isTest
    public static void UpdateBookingFormStatus() {
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        //
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        
        Account acc =new Account();   
        acc.FirstName='TestAc';
        acc.LastName='Account';
        acc.PersonEmail='test@gmail.com';
        acc.PersonMobilePhone='9008008765';
        acc.Phone='9876543210';
        acc.PAN__c='ASDFG1234M';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street no 5';
        acc.BillingPostalCode='560001';
        acc.Customer_type__c='B2C';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        insert acc;
        
        
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
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Lead_Id__c='ASDF456789HJK';
        insert opty; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        //Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
        UpdateBookingFormStatus_GraphQL.UpdateBookingFormStatus(opty.Id);
        //updateCustomerSFID_GraphQL.UpdateCustomer(acc.id);
        Test.stopTest();
    }

}