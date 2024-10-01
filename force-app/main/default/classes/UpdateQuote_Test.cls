@isTest
public class UpdateQuote_Test {
    /*
    @testSetup
    public static void testSetup(){
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
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street no 5';
        acc.BillingPostalCode='560001';
        acc.Customer_type__c='B2C';
        acc.IsInvoiceGenerated__c=true;
        acc.Converted_Lead_ID__c='ASDFG5678JHG';
        insert acc;
        acc.IsInvoiceGenerated__c=true;
        acc.Customer_created_on_Odoo__c  =true;
        acc.IsInvoiceGenerated__c=false;
        acc.PersonMobilePhone ='9876543266';
        update acc;
        
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
        DateTime expected = DateTime.newInstance(2029, 2, 11, 8, 13, 16);
        Offer__c offObj = new Offer__c();
        offObj.Allow_merging_with_other_offers__c = true;
        offObj.Discount_Applicable_on__c = 'Total Calculated Value';
        offObj.Start_Date__c = expected;
        offObj.End_Date__c = expected;
        offObj.Allowed_ECs__c = 'MGDC';
        offObj.Description__c ='adasdasfasfasass';
        offObj.Business_Type__c = 'COCO';
        insert offObj;
        Quote quote = new Quote();
        quote.OpportunityId = opty.id;
        quote.Status='Needs Review';
        quote.name = 'Quotetest1';
        quote.Modular_Discount__c = 5;
        quote.Site_Services_Discount__c = 10;
        quote.Modular_Amount__c = 45000;
        quote.Site_Services_Amount__c = 55000;
        quote.Latest_Quote__c=false;
        quote.Offer_1__c = offObj.Id;
        insert quote;
        
        Quote quote2 = new Quote();
        quote2.OpportunityId = opty.id;
        quote2.name = 'Quotetest2';
        quote2.Modular_Discount__c = 170;
        quote2.Site_Services_Discount__c = 120;
        quote2.Modular_Amount__c = 5000;
        quote2.Site_Services_Amount__c = 5000;
        quote2.Latest_Quote__c=true;
        quote2.Offer_1__c = offObj.Id;
        insert quote2;
        
        UpdateQuote.quoteDataWrap QuoteDataWrap = new UpdateQuote.quoteDataWrap();
        
        QuoteDataWrap.quoteId =quote.Id;       
        QuoteDataWrap.opportunityId = quote.OpportunityId;
        QuoteDataWrap.name = quote.Name;
        QuoteDataWrap.modularDiscount = quote.Modular_Discount__c;
        QuoteDataWrap.updateModular = true;
        QuoteDataWrap.siteServiceDiscount=quote.Site_Services_Discount__c;
        QuoteDataWrap.updateSiteService = true;        
    }*/
    
    @isTest
    public static void UpdateQuote(){  
        
        /*DCWebengage__c cuset2= new DCWebengage__c();
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
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street no 5';
        acc.BillingPostalCode='560001';
        acc.Customer_type__c='B2C';
        acc.IsInvoiceGenerated__c=true;
        acc.Converted_Lead_ID__c='ASDFG5678JHG';
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
        opty.Modular_Milestone_Type__c = '4 Stage';
        opty.Modular_Amount_Dis_Incl_GST__c = 23;
        INSERT opty;
        
        Quote quote = new Quote();
        quote.OpportunityId = opty.id;
        quote.Status='Approved';
        quote.name = 'Quotetest1';
        quote.Oppty_Customer_email__c= 'test@salesforce.com';
        quote.oppty_Designer_Email_add__c= 'test@salesforce.com';
        quote.Modular_Discount__c = 5;
        quote.Site_Services_Discount__c = 10;
        quote.Modular_Amount__c = 45000;
        quote.Site_Services_Amount__c = 55000;
        quote.Latest_Quote__c=true;
        quote.OpportunityId = opty.id;
        INSERT quote;*/
        
        UpdateQuote uqObj = new UpdateQuote(); 
		UpdateQuote.quoteDataWrap wrapObj = new UpdateQuote.quoteDataWrap();  
        wrapObj.modularDiscount = 10;
        wrapObj.name = 'Test';
        wrapObj.opportunityId = ''; 
        wrapObj.quoteId = '';
        wrapObj.siteServiceDiscount = 10;
        wrapObj.updateModular = false;
        wrapObj.updateSiteService = false;
        
        UpdateQuote.UpdatedQuoteResponse uqrObj = new UpdateQuote.UpdatedQuoteResponse();
        uqrObj.code = '';
        uqrObj.data = '';
        uqrObj.message = '';
        uqrObj.statusCode = '';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
        UpdateQuote.insertResponse(null, 'Test Response', 'Test JsonBody', 201);
        UpdateQuote.testCover();
        //UpdateQuote.QuoteUpdate(null,100.10,190.90);
        Test.stopTest();
        
        
        /*Quote quoteObj = [select id,Latest_Quote__c, name, Modular_Discount__c from Quote limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
        UpdateQuote.QuoteUpdate(quoteObj.Id,100.10,190.90);
        Test.stopTest();*/
    }
}