@isTest
public class RequestPayment_Test {
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
    
    @isTest
    static void testOpp(){
        
        
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://www.testing.com';
        insert dc;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Test.setMock(HttpCalloutMock.class, new RestMock());
       
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
        //opty.Design_User__c = design.Id;
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Lead_Id__c='ASD45678HHH';
        insert opty;
        
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
        update reqPay2;
        
               
        Request_Payment__c reqPay1 = new  Request_Payment__c ();
        reqPay1.Opportunity__c=opty.id;
        reqPay1.Name='PaymentRequestTest';
        reqPay1.Category__c='Site Services';
        reqPay1.Client_ID__c='DC-35711';
        reqpay1.Status__c='Pending';
        reqpay1.Request_Amount__c= 200;
        reqpay1.Description__c='this is test class';
        reqpay1.Request_Id__c='PR-jZM2lAuvR';
        insert reqPay1;
        delete reqpay1;
        
        Quote qt = new Quote();
        qt.Name ='test';
        qt.OpportunityId = opty.id;
        qt.Latest_Quote__c=true;
        insert qt;
        RecursiveTriggerHandler.isFirstTime = True; 
        qt.Name = 'Updated Test';
        update qt;
         
       
    }
}