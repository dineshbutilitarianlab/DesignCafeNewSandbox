@isTest
public class SendPaymentDetails_Test {
    public static testmethod void callServer(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User();
        usr.FirstName = 'Name';
        usr.LastName = 'test';
        usr.Email = 'test3@test.com';
        usr.ProfileId = p.id;
        usr.Username = 'testuser1@name.com';
        usr.Alias = 'Name';
        usr.TimeZoneSidKey ='America/Los_Angeles';
        usr.LocaleSidKey = 'en_US';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';  
        insert usr;
        Design_User__c ds = new Design_User__c();
        ds.Name = 'Test1';
        ds.Email__c = 'test1@test.com';
        ds.Role__c = 'Inhouse Designer';
        ds.Designer_Dashboard_ID__c = 'id';
        insert ds;
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
        opp.Meeting_Type__c ='EC';
        opp.Meeting_Venue__c='MGDC';
        insert opp;
        
        Opportunity_Invoice__c inv = new Opportunity_Invoice__c();
        inv.Opportunity__c = opp.id;
        inv.Payment_Link__c = 'qwertyui.qwert';
        inv.Payment_Name__c = 'test';
        inv.Initial_Amount_Incl_GST__c = 5000;
        inv.SGST__c = 8;
        inv.CGST__c = 8;
        inv.IGST__c = 8;
        inv.Total_Tax_Value__c = 2000;
        inv.Amount_Excl_GST__c = 2000;
        inv.Invoice_Date__c = System.today();
        inv.RP_Invoice_Number__c = '1234567';
        inv.RP_Invoice_Receipt__c = 'qwertyui';
        inv.Payment_Link__c = 'qwertyui.zxcvbn';
        inv.Invoice_PDF_Link__c = 'qwertyui.asdfghjkcvbn';
        insert inv;
        
        Invoice_Payment__c pay = new Invoice_Payment__c();
        pay.Opportunity_Name__c = opp.id;
        pay.Invoice_1__c = inv.id;
        pay.Date_of_Payment__c = system.today();
        pay.Pyament_Receipt__c ='test';
        pay.Receipt_Amount__c =5000;
        pay.Mode_of_Receipt__c ='Cash';
        pay.RP_Recipt_ID__c = '12345234234';
        insert pay;
        
        Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new SendPaymentDetailsMockUp());
        SendPaymentDetails.callServer(pay.id);
        Test.stopTest();   
    }
}