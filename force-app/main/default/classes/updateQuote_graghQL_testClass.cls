@isTest
public class updateQuote_graghQL_testClass {
    private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            //String fullJson = 'your Json Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            //res.setBody(fullJson);
            res.setStatusCode(200);
            string jsonBody ='{"data":{"AuthenticationToken":{"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6Ijc3MTAxNTgyLWV2OGs5ODg3cnl0dWlramhnYm5lcnQ0MyIsImlhdCI6MTY1NzE5NDA2OCwiZXhwIjoxNjU3MTk0MjQ4fQ.mr3GHUDfDdzYbmY5eyLkkO7B51PQQFh8931mRw5QLFs","message":"success","code":200}},"error":[]}';
            //String jsonRes ='{"responseJson":{"data":{"AddPaymentRequests":{"code":200,"data":{"requestID":"PR-XUnHsezie"},"message":"Payment request added successfully","statusCode":200}}},"errors":[]}';
            res.setBody(jsonBody); 
            return res;
            
            
           
        }
    }

    @TestSetup
    static void makeData(){
        Test.setMock(HttpCalloutMock.class, new RestMock());
        test.startTest();
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://www.testing.com';
        //cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
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
        // try {
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
        
            insert opty; 
        // }catch(){

        // }
        test.stopTest();
    }
    


    @isTest
    public static void updateQuote_graphQLTest(){
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        User contextuser = [select id from user where id = '0052u000001DOdc'];  // For Production
        //User contextuser = [select id from user where id = '0059H000000trKE']; // For SandBox
        System.runAs(contextuser){
            opportunity opty= [SELECT Id FROM Opportunity LIMIT 1];

        
            Quote quote = new Quote();
            
            
            quote.OpportunityId = opty.id;
            quote.Status='Approved';
            quote.name = 'Quotetest1';
            quote.Modular_Discount__c = 5;
            quote.Site_Services_Discount__c = 10;
            quote.Modular_Amount__c = 45000;
            quote.Site_Services_Amount__c = 55000;
            quote.Latest_Quote__c=false;
            RecursiveTriggerHandler.isFirstTime = true;
            quote.oppty_Designer_Email_add__c= 'test1@gmail.com';
            quote.Oppty_Customer_email__c = 'test1@gmail.com';
            
            insert quote;
            quote.Latest_Quote__c=true;
            quote.Modular_Discount__c = 15;
            quote.Site_Services_Discount__c = 5;
            //quote.Site_Service_Fixed_Discount__c = 5;
            //quote.Modular_Fixed_Discount__c = 5;
            update quote;
         
            UpdateQuote.quoteDataWrap QuoteDataWrap = new UpdateQuote.quoteDataWrap();
            
            QuoteDataWrap.quoteId =quote.Id;       
            QuoteDataWrap.opportunityId = quote.OpportunityId;
            QuoteDataWrap.name = quote.Name;
            QuoteDataWrap.modularDiscount = quote.Modular_Discount__c;
            QuoteDataWrap.updateModular = true;
            QuoteDataWrap.siteServiceDiscount=quote.Site_Services_Discount__c;
            QuoteDataWrap.updateSiteService = true;
            
            

            
        }
        Quote quote = [SELECT Id FROM Quote LIMIT 1];
        //Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
         updateQuote_graphQL.ActionRequest request = new updateQuote_graphQL.ActionRequest();
        request.modular_discount_changed = true;
        request.site_Service_Discount_changed = true;
        request.recId = quote.Id;
        Test.stopTest();
        updateQuote_graphQL.UpdateQuote(new List<updateQuote_graphQL.ActionRequest>{request});
        quote.Latest_Quote__c=false;
        update quote;
    }
    
}