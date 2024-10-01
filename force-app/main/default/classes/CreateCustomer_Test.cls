@isTest 
public class CreateCustomer_Test {
    
    @isTest public static void addCustomer(){
        
        
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        id RecordTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Account acc =new Account();
        acc.RecordTypeId=RecordTypeAcc;   
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
        acc.BillingStreet='MG Road Street';
        acc.BillingPostalCode='560001';
        acc.Converted_Lead_ID__c='ASDF45678ASD';
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
        opty.Lead_Id__c='ASD45678HHH';
        insert opty; 
        
        
        
        CreateCustomer.CreateCustomerDataWrap custWrp= new  CreateCustomer.CreateCustomerDataWrap();
        custWrp.customerName=acc.Name;
        custWrp.customerEmail=acc.PersonEmail;
        custWrp.customerPhone=acc.PersonMobilePhone;
        custWrp.billingAddressCountry=acc.BillingCountry;
        custWrp.billingAddressShippingState=acc.BillingState;
        custWrp.billingAddressCity=acc.BillingCity;
        custWrp.billingAddressStreet=acc.BillingStreet;
        custWrp.billingAddressZipOrPostalCode=acc.BillingPostalCode;
        custWrp.SF_Account_ID=acc.id;
        custWrp.l10n_in_gst_treatment=acc.l10n_in_gst_treatment__c;
        custWrp.GST=acc.GST_No__c;
        custWrp.PAN=acc.PAN__c;
        
        CreateCustomer.UpdateCustomerDataWrap updWrp = new  CreateCustomer.UpdateCustomerDataWrap();
        CreateCustomer.CustomerBillingAddress cuAddwrp = new  CreateCustomer.CustomerBillingAddress();
      
     
        updWrp.customerName=acc.Name;
        updWrp.customerEmail=acc.PersonEmail;
        updWrp.customerPhone=acc.PersonMobilePhone;
        updWrp.l10n_in_gst_treatment=acc.l10n_in_gst_treatment__c;
        updWrp.GST=acc.GST_No__c;
        updWrp.PAN=acc.PAN__c;

        cuAddwrp.country = acc.BillingCountry;
        cuAddwrp.state = acc.BillingState;
        cuAddwrp.city = acc.BillingCity;
        cuAddwrp.street = acc.BillingStreet;
        cuAddwrp.zipOrPostalCode = acc.BillingPostalCode; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
        CreateCustomer.createCustomerOnOdooBody(opty.id);
        CreateCustomer.addCustomer(opty.id);
        CreateCustomer.updateCustomerOnOddo(opty.id);
        //Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());CreateCustomer.addCustomer(opty.id);
        Test.stopTest();
        
    }
    
}