@isTest
public class QuoteTriggerTest {

    public class RestMock implements HttpCalloutMock {

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
        Test.startTest();
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://www.testing.com';
        //cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        
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
            List<opportunity> oppList = new List<opportunity>();
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
            
            opportunity opty2=new opportunity();
            opty2.Name='TestOpp 2';
            opty2.AccountId=acc.Id;
            opty2.stagename = 'Meeting Done';
            opty2.Amount = 999;
            opty2.Wohoo_Card__c = '567';
            opty2.Signup_Amount__c = 88788;
            opty2.Client_s_Budget__c = 8989;
            opty2.Probability = 100;
            opty2.X1st_Meeting_Person__c = '0052v00000bZuLL';
            opty2.X1st_Meeting_Date__c = system.today();
            opty2.Meeting_Type__c = 'EC';
            opty2.region__C = 'Bengaluru';
            opty2.CloseDate = system.today();
            opty2.Amount=3124;
            opty2.OwnerId =userinfo.getUserId();
            opty2.Is_Pm_Site__c=True;
            opty2.Meeting_Venue__c='Mumbai Dc';
            opty2.Modular_Milestone_Type__c='3 Stage';
            opty2.Client_s_Budget__c=200;
            opty2.Requirement_Details__c='Wardrobes';
            opty2.Flooring_is_completed_Required__c=true;
            opty2.Lead_Id__c='ASDF456789HJK';
            opty2.Modular_Milestone_Type__c = '4 Stage';
            opty2.Modular_Amount_Dis_Incl_GST__c = 23;

            oppList.add(opty);
            oppList.add(opty2);
            insert oppList; 
            Request_Payment__c reqPay2 = new  Request_Payment__c ();	
            reqPay2.Name='PaymentRequestTest';	
            reqPay2.Category__c='Modular';	
            reqPay2.Client_ID__c='DC-35711';	
            reqPay2.Status__c='Pending';	
            reqPay2.Request_Amount__c= 200;	
            reqPay2.Description__c='this is test class';	
            reqPay2.Opportunity__c=opty.id;	
            reqPay2.Request_Id__c='PR-jEM2lAuvL';	
            insert reqPay2;
            Quote quote = new Quote();
            //quote.Id ='0Q071000000006TCAQ';
            quote.OpportunityId = opty.id;
            quote.Status='Approved';
            quote.name = 'Quotetest1';
            quote.Oppty_Customer_email__c= 'test@salesforce.com';
            quote.oppty_Designer_Email_add__c= 'test@salesforce.com';
            quote.Modular_Discount__c = 5;
            quote.Site_Services_Discount__c = 1;
            quote.Modular_Amount__c = 45000;
            quote.Site_Services_Amount__c = 55000;
            quote.Latest_Quote__c=true;
            quote.OpportunityId = opty.id;
            RecursiveTriggerHandler.isFirstTime = true;
            User contextuser = [select id from user where id = '0052u000001DOdc'];  // For Production
            //User contextuser = [select id from user where id = '0059H000000trKE']; // For SandBox
        System.runAs(contextuser){
            insert quote;
        }
            Test.stopTest();
    }

    @isTest
    public static void testApprovedQuotes() {
        User contextuser = [select id from user where id = '0052u000001DOdc'];  // For Production
        //User contextuser = [select id from user where id = '0059H000000trKE']; // For SandBox
        System.runAs(contextuser){
            Test.setMock(HttpCalloutMock.class, new RestMock());
     
                Test.startTest();
                Opportunity opty = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'LIMIT 1];

                Quote quote = [SELECT Id FROM Quote LIMIT 1];
                quote.Latest_Quote__c=true;
                quote.Modular_Discount__c = 1;
                quote.Site_Services_Discount__c = 2;
                quote.Site_Service_Fixed_Discount__c = 3;
                quote.Modular_Fixed_Discount__c = 4;
                update quote;
                
                Test.stopTest();
                
            // } catch (Exception e) {
            //     System.debug('Error Message => '+e.getMessage());
            // }
        }
        /*  quote.Latest_Quote__c=true;
        quote.Modular_Discount__c = 15;
            quote.Site_Services_Discount__c = 15;
            update quote; */


        /*  quote2.Modular_Discount__c = 15;
            quote2.Site_Services_Discount__c = 15;
            update quote2; */
        /*  List<Quote> quoteList =new List<Quote>();
        quoteList.add(quote);
        // 	insert quoteList;
        quoteList.add(quote2);
        // insert quoteList; */
        

        
        // Test.startTest();
        
        // Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
        // //UpdateQuote.QuoteUpdate(quote.Id,quote.Modular_Discount__c,quote.Site_Services_Discount__c);
        // Test.stopTest();
    }

    @isTest
    public static void testApprovedQuotes2() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock());
      
           
            opportunity opty= [SELECT Id FROM Opportunity WHERE Name='TestOpp 2' LIMIT 1];
            Quote quote = new Quote();
            //quote.Id ='0Q071000000006TCAQ';
            quote.OpportunityId = opty.id;
            quote.Status='Approved';
            quote.name = 'Quotetest1';
            quote.Oppty_Customer_email__c= 'test@salesforce.com';
            quote.oppty_Designer_Email_add__c= 'test@salesforce.com';
            quote.Modular_Discount__c = 3;
            quote.Site_Services_Discount__c = 2;
            quote.Modular_Amount__c = 45000;
            quote.Site_Services_Amount__c = 55000;
            quote.Latest_Quote__c=true;
            quote.OpportunityId = opty.id;
            RecursiveTriggerHandler.isFirstTime = true;
            User contextuser = [select id from user where id = '0052u000001DOdc'];  // For Production
            //User contextuser = [select id from user where id = '0059H000000trKE']; // For SandBox
            System.runAs(contextuser){
                insert quote;
            }

           
    //    VDC_CPUpdateOpportunity.codeCoverage();
            

          
            Test.stopTest();

        
    }
    
}