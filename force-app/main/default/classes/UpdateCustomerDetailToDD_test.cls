@isTest
public class UpdateCustomerDetailToDD_test {
    public static testmethod void testAcc(){
        Account acc = new Account();
        acc.Name = 'test';
        //  acc.PersonEmail ='test@test.com';
        //  acc.PersonMobilePhone ='9099990099';
        acc.BillingStreet = '5th block';
        acc.BillingCity = 'Bengaluru';
        acc.BillingState ='Karnataka';
        acc.BillingPostalCode ='560096';
        acc.BillingCountry = 'India';
        acc.ShippingStreet = '5th block';
        acc.ShippingCity = 'Bengaluru';
        acc.ShippingState = 'Karnataka';
        acc.ShippingPostalCode = '560096';
        acc.ShippingCountry ='India';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = acc.id;
        opp.StageName = 'Meeting Done';
        opp.CloseDate = system.today();
        insert opp;
        Account acc1 = new Account();
        acc1.id = acc.id;
        acc1.BillingStreet = '5th block';
        acc1.BillingCity = 'Bengaluru';
        acc1.BillingState ='Karnataka';
        acc1.BillingPostalCode ='560096';
        acc1.BillingCountry = 'India';
        acc1.ShippingStreet = '5th block';
        acc1.ShippingCity = 'Bengaluru';
        acc1.ShippingState = 'Karnataka';
        acc1.ShippingPostalCode = '560096';
        acc1.ShippingCountry ='India';
        acc1.Country_Code__c ='+91';
        update acc1;
        UpdateCustomerDetailToDD.callServer(acc.id);
        Test.startTest();
    //    Test.setMock(HttpCalloutMock.class, new UpdateCustomerDetailToDD_Mock());
        Test.stopTest();
    }
}