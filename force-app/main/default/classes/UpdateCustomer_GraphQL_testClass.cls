@isTest
public class UpdateCustomer_GraphQL_testClass {
    @isTest
    public static void UpdateCustomer() {
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        
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
        
        Test.startTest();
      Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
      //Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
        UpdateCustomer_GraphQL.UpdateCustomer(acc.Id);
        Test.stopTest();
    }
    

}