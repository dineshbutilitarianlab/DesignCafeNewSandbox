@isTest
public class ReGenerateInvoiceController_Test
{
    public static testmethod void callServer()
    {
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
        System.debug('Opportunity : '+opp);
     //   Opportunity o = [Select id,Name,Customer_ID__c from Opportunity where id =: opp.id];
     //   System.debug('opp id :'+o);
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
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ReGenerateInvoiceMockUp());
        ReGenerateInvoiceController.callServer(opp.id);
        Test.stopTest();
    }
}