@isTest 
public class GenerateNewInvoiceController_Test {
    
    @testSetup
    public static void dataSetup() {
        
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        insert acc;
       
               
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
        insert opty;
        
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
    }
    
    @isTest public static void newInvoiceGenerationTestClass(){
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        insert acc;
     	acc.Customer_created_on_Odoo__c = true;
        update acc;
               
        Design_User__c Design= new Design_User__c();
        Design.Name='Test Designer568';
        Design.Designer_Dashboard_ID__c='user12345';
        Design.Email__c='design34@yopmail.com';
        Design.Mobile__c='9066218981';
        Design.Region__c='Thane';
        Design.Experience_Center__c='BHHYD';
        Design.Role__c='Associate Studio Manager';
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
        insert opty;
      	opty.Project_Created_On_Odoo__c=true;
        update opty;
        
        Request_Payment__c rp = new Request_Payment__c ();
        rp.Opportunity__c = opty.Id;
        insert rp;
            
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
        
        
        test.startTest(); 
        List<GenerateNewInvoiceController.ResponseToBeSentToAura> resList = new List<GenerateNewInvoiceController.ResponseToBeSentToAura>();
        // GenerateNewInvoiceController.ResponseToBeSentToAura res=new GenerateNewInvoiceController.ResponseToBeSentToAura
        Test.setMock(HttpCalloutMock.class, new GenerateNewInvoiceControllerMockTest());
       //  res=GenerateNewInvoiceController.generateInvoice(opty.id);
        resList = GenerateNewInvoiceController.generateInvoice(opty.id, 0);
        //GenerateNewInvoiceController.List<ResponseToBeSentToAura> generateInvoice(opty.id);
        
       
      /*  GenerateNewInvoiceController.invoiceDataWrap obj2 = new GenerateNewInvoiceController.invoiceDataWrap();
        GenerateNewInvoiceController.invoiceDataListWrap obj1 = new GenerateNewInvoiceController.invoiceDataListWrap();
        
        obj2.additionalCharge = 1;
        obj2.currentModularValue = 100;
        obj2.currentProjectValue = 2000;
        obj1.invoiceData = obj2;
        GenerateNewInvoiceController.callAPI(opty, obj1); */
        
        test.stopTest(); 
    }
    
    /*@isTest static void paymentReceiptTest() {
        
        try {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        acc.Customer_created_on_Odoo__c=true;
       	acc.Converted_Lead_ID__c='ASDFG45676GFD';
        insert acc;
               
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
        opty.IsNewPaymentProject__c= true;
        opty.Project_Created_On_Odoo__c= true;
        opty.Lead_Id__c='ASDF456789HJK';
        insert opty;
        
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
        
        InvPay.Receipt_Amount__c=2008;  
        update InvPay;
                            
        acc.BillingPostalCode = NULL;
        acc.BillingStreet = NULL;
        acc.ShippingState = NULL;
        acc.BillingCountry = NULL;
        acc.BillingState = NULL;
        acc.ShippingPostalCode = NULL;
        acc.ShippingCountry = NULL;
        acc.ShippingState = NULL;
        acc.ShippingStreet = NULL;
        acc.BillingCity = NULL;
        acc.ShippingCity = NULL;
        acc.Customer_type__c = 'B2B';
        acc.PAN__c = NULL;
        acc.GST__c = 11;
        acc.GST_No__c = '06BZAHM6385P6Z2';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        update acc;
        
        InvPay = new Invoice_Payment__c();
        InvPay.Opportunity_Name__c = opty.id;
        InvPay.Mode_of_Receipt__c = 'Online';
        InvPay.Date_of_Payment__c = system.today();
        InvPay.RP_Recipt_ID__c = 'TR456-74';
        InvPay.Modular_value__c=1000;
        InvPay.Site_Service_value__c=1000;
        InvPay.Receipt_Amount__c=2000;    
        InvPay.paymentID__c='';
        insert InvPay; 
            
            InvPay.Receipt_Amount__c=3000;   
        update InvPay;
                    
        Test.stopTest();
        } catch(Exception e) {
            
            system.debug('Excepyion:'+e.getMessage());
        }
    }*/
    
    @isTest static void paymentReceiptTest2() {
        
        try {
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
            List<Invoice_Payment__c> invPaymnt = [SELECT Id FROM Invoice_Payment__c]; 
            
            PaymentReceipt.DeletePaymentReceipt(invPaymnt[0].Id);
            
            delete invPaymnt;
            
            Test.stopTest();
        } catch(Exception e) {
            
        }
    }
    /*
    @isTest public static void newInvoiceGenerationTestClass2(){
        
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        insert acc;
                 
        Design_User__c Design= new Design_User__c();
        Design.Name='Test Designer1';
        Design.Designer_Dashboard_ID__c='QA-1236';
        Design.Email__c='design@yopemail.com';
        Design.Mobile__c='9066078982';
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
        opty.Lead_Id__c='ASDF456789HJK';
        insert opty;  
        
        test.startTest();
        
        List<GenerateNewInvoiceController.ResponseToBeSentToAura> resList = new List<GenerateNewInvoiceController.ResponseToBeSentToAura>();
        resList = GenerateNewInvoiceController.generateInvoice(opty.id, 1);
        
        test.stopTest(); 
    }
    */
     @isTest public static void newInvoiceGenerationTestClass3(){
        
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        insert acc;
                   
        Design_User__c Design= new Design_User__c();
        Design.Name='Test Designer18';
        Design.Designer_Dashboard_ID__c='Test-1236';
        Design.Email__c='design78@yopemail.com';
        Design.Mobile__c='9098078982';
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
        opty.Modular_Amount_Dis_Incl_GST__c=-10;
        opty.Lead_Id__c='ASDF456789HJK';
        insert opty;  
         
        Opportunity_Invoice__c oppInvo = new Opportunity_Invoice__c();
        oppInvo.Opportunity__c =opty.id;
        oppInvo.Invoice_Id__c ='INV-VBJ1B4MBO';
        oppInvo.Invoice_Amount__c=0;
        oppInvo.Category__c = 'Site Services';
        insert oppInvo;
        
        test.startTest();
        
        List<GenerateNewInvoiceController.ResponseToBeSentToAura> resList = new List<GenerateNewInvoiceController.ResponseToBeSentToAura>();
        resList = GenerateNewInvoiceController.generateInvoice(opty.id, 0);
        
        test.stopTest(); 
    }
}