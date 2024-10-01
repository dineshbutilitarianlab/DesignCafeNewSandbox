@isTest public class GenerateInvoicenewflow_GraphQL_Test {
    
    //@testSetup
    public static void testSetup() {
                
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        
        Account acc =new Account();
        acc.FirstName='Test';
        acc.LastName='Account';
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
        acc.PAN__c = 'AAAAA1234W';
        acc.Customer_type__c = 'B2C';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        acc.IsInvoiceGenerated__c = true;
        insert acc;
        acc.IsInvoiceGenerated__c = true;
        update acc;
        
        Design_User__c Design= new Design_User__c();
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
        opty.Is_Pm_Site__c=true;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Site_Services_Amount_Dis_Incl_GST__c=2000;
        opty.Modular_Amount_Dis_Incl_GST__c=3000;
        opty.IsNewPaymentProject__c =true;
        opty.Lead_Id__c='ASDF456789HJK';
        opty.IsInvoiceGenerated__c = true;
        insert opty;
        opty.IsInvoiceGenerated__c = true;
        update opty;
        
        Request_Payment__c rp = new Request_Payment__c ();
        rp.Opportunity__c = opty.Id;
        insert rp;
        
        system.debug('TestrecId::'+opty.id);
        Invoice_Payment__c InvPay = new Invoice_Payment__c();
        InvPay.Opportunity_Name__c = opty.id;
        InvPay.Mode_of_Receipt__c = 'Cash';
        InvPay.Date_of_Payment__c = system.today();
        InvPay.RP_Recipt_ID__c = 'TR456-73';
        InvPay.Modular_value__c=1000;
        InvPay.Site_Service_value__c=1000;
        InvPay.Receipt_Amount__c=2000;    
        InvPay.paymentID__c = null;
        InvPay.Request_Payment_Modular__c = rp.Id;
        InvPay.Request_Payment_SiteService__c = rp.Id;
        insert InvPay; 
        
        List<Opportunity_Invoice__c> oppInvList =new List<Opportunity_Invoice__c>();
        Opportunity_Invoice__c oppInvo =new Opportunity_Invoice__c();
        oppInvo.Opportunity__c = opty.id;
        oppInvo.Invoice_Amount__c =1000;
        oppInvo.Invoice_Id__c='INV-2Yn9WbzKO';
        oppInvo.Opportunity__c=opty.id;
        oppInvo.CGST__c=20;
        oppInvo.SGST__c=30;
        oppInvo.IGST__c=10;
        Date d = Date.ValueOf(String.ValueOf(system.today()));
        String dateStr = d.year() + '-' + d.month() + '-' + d.day();
        oppInvo.Invoice_Date__c = Date.valueOf(dateStr);
        oppInvo.Status__c = 'posted';
        oppInvo.Odoo_Invoice_Id__c = 4545;
        oppInvo.Total_Tax_Value__c=50;
        oppInvo.Category__c='Site Services';
        oppInvList.add(oppInvo);

        Opportunity_Invoice__c oppInvo1 =new Opportunity_Invoice__c();
        oppInvo1.Opportunity__c = opty.id;
        oppInvo1.Invoice_Amount__c =1000;
        oppInvo1.Invoice_Id__c='INV-3Yn4WbzKO';
        oppInvo1.Opportunity__c=opty.id;
        oppInvo1.CGST__c=20;
        oppInvo1.SGST__c=30;
        oppInvo1.IGST__c=10;
        oppInvo1.Invoice_Date__c = Date.valueOf(dateStr);
        oppInvo1.Total_Tax_Value__c=50;
        oppInvo1.Category__c='Modular';
        oppInvo1.Status__c = 'posted';
        oppInvo1.Odoo_Invoice_Id__c = 4545;
        oppInvList.add(oppInvo1);
        insert oppInvList;
    }
    @isTest 
    public static void newInvoiceGenerationTestClass(){
        testSetup();
        test.startTest(); 
        Id optyId = [select id from opportunity LIMIT 1].id;
        //Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        GenerateInvoicenewflow_GraphQL.showbutton(optyId);
        Test.setMock(HttpCalloutMock.class, new GenerateNewInvoice_GRaphQLMockTest());
        GenerateInvoicenewflow_GraphQL.generateNewInvoice(optyId);
        test.stopTest(); 
    }
    @isTest 
    public static void newInvoiceGenerationTestClassError(){
        testSetup();
        Id optyId = [select id from opportunity LIMIT 1].id;
        system.debug('Opportunity ID' +optyId);
        GenerateInvoicenewflow_GraphQL.showbutton(optyId);
        test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new GenerateNewInvoice_GRaphQLMockTest_fail1());
        //Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        GenerateInvoicenewflow_GraphQL.generateNewInvoice(optyId);
        test.stopTest(); 
    }
}