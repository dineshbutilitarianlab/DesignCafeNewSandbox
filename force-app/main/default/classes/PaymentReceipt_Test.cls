@isTest
public class PaymentReceipt_Test {
    @TestSetup 
    public static void paymentreceipttest(){
        
        
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
        opty.Modular_Amount_Dis_Incl_GST__c = 2;
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
        Test.stopTest();
        
    }
    
    @IsTest
    static void testCreatePaymentReceiptBody() {
        // Setup the mock response
        
        Invoice_Payment__c InvPay = [SELECT Id, Opportunity_Name__r.Id, paymentID__c FROM Invoice_Payment__c Limit 1];
        String recId = InvPay.Opportunity_Name__r.Id;
        String oldId = InvPay.paymentID__c;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutmock.class, new AuthorizationTokenMock());
        PaymentReceipt.createPaymentReceiptBody(recId);
        PaymentReceipt.updatePaymentReceiptBody(recId); 
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        PaymentReceipt.UpdatePaymentReceipt(recId, oldId);
        
        Test.stopTest();
    }
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
        opty.Modular_Amount_Dis_Incl_GST__c = 2;
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
        
        Invoice_Payment__c InvPay = [SELECT Id, Opportunity_Name__r.Id, paymentID__c FROM Invoice_Payment__c Limit 1];
        String recId = InvPay.Opportunity_Name__r.Id;
        PaymentReceipt.addPaymentReceipt(recId);
        Invoice_Payment__c InvPay2 = [SELECT Id, Opportunity_Name__r.Id, paymentID__c FROM Invoice_Payment__c Limit 1];
        String oldId = InvPay2.paymentID__c;
        PaymentReceipt.UpdatePaymentReceipt(recId, oldId);
        PaymentReceipt.DeletePaymentReceipt(recId);
        Test.stopTest();
        
    }
    
    @IsTest
    static void testInsertAttachDetails() {
        Test.startTest();
        
        Invoice_Payment__c InvPay = [SELECT Id, Opportunity_Name__r.Id, paymentID__c FROM Invoice_Payment__c Limit 1];
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient ='/' + content.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob; 
        //content.LinkedEntityId = sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = InvPay.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        
        List<String> docIdsToDelete = new List<String>();
        docIdsToDelete.add(contentlink.contentdocumentid);
        
        List<ContentDocumentLink>  listOfContDoc = new List<ContentDocumentLink>();
        ContentDocumentLinkTriggerHandler contDocsTrigg = New ContentDocumentLinkTriggerHandler();
        ContentDocumentLinkTriggerHandler.createCDLforAccount(listOfContDoc);
        List<String> docIdsToInsert = new List<String>();
        docIdsToInsert.add(content.Id);
        PaymentReceipt.insertAttachDetails(InvPay.Id,docIdsToDelete,docIdsToInsert);  
        List<String>idsToBeDeleted = new List<String>();
        ContentDocument contentDoc = [SELECT Id FROM ContentDocument Limit 1];
        idsToBeDeleted.add(contentDoc.Id);
        PaymentReceipt.deleteFileRecords(idsToBeDeleted);
        Test.stopTest();
    }
    
}