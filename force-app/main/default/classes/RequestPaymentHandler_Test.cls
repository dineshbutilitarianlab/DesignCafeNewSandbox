@isTest
public with sharing class RequestPaymentHandler_Test {
    
    
    public static testMethod void requestPaymetTest(){
        
        
        
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
        insert opty; 
        
        
        Request_Payment__c reqPay = new  Request_Payment__c ();
        reqPay.Name='PaymentRequestTest';
        reqPay.Category__c='Modular';
        reqPay.Client_ID__c='DC-35711';
        reqpay.Status__c='Pending';
        reqpay.Request_Amount__c= 200;
        reqpay.Description__c='this is test class';
        reqpay.Opportunity__c=opty.id;
        system.debug('oppId:'+ opty.id);
        reqpay.Request_Id__c='PR-jZM2lAuvL';
        insert reqPay;
         reqpay.Status__c='Paid';
        update reqpay;
       
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
        
        
        RequestPaymentHandler.ReqPaymnetDataWrap req2=new RequestPaymentHandler.ReqPaymnetDataWrap();
        req2.requestId=reqpay.Request_Id__c;
        req2.requestAmount=reqpay.Request_Amount__c;
        req2.description=reqpay.Description__c;
        req2.clientID=reqpay.Client_ID__c;
        req2.status=reqpay.Status__c;
        req2.appName= 'Salesforce';
        req2.category=reqpay.Category__c;
        Date d = Date.today();
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
        req2.requestDate= dt;
        
        
     /*   RequestPaymentHandler.ReqPaymnetDataWrap req3=new RequestPaymentHandler.ReqPaymnetDataWrap();
        req3.requestId='';
        req3.requestAmount=reqPay1.Request_Amount__c;
        req3.description=reqPay1.Description__c;
        req3.clientID='';
        req3.status=reqPay1.Status__c;
        req3.appName= 'Salesforce';
        req3.category='Pending';
        Date d1 = Date.today();
        String dt1 = DateTime.newInstance(d1.year(),d1.month(),d1.day()).format('dd/MM/YYYY');
        req3.requestDate= dt1;*/
        
        
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new RequestPaymentHandlerMock());
        
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
        
        RequestPaymentHandler.sendRequestPayment('Modular',200,'Description','PR-jZM2lAuvL','Pending','0067100000198vRAAQ');
        
        
       // RequestPaymentHandler.updateRequestPayment(reqpay1.id);
        
        RequestPaymentHandler.updateRequestPayment(reqpay.id);            
        
        //RequestPaymentHandler.deleteRequestPayment(reqpay1.id);
        RequestPaymentHandler.deleteRequestPayment(reqpay1.id);
        
       // RequestPaymentHandler.createProjectRequest(reqpay1.id);
      //  RequestPaymentHandler.createProjectRequest(reqpay.id); 
        test.stopTest();
        
    }
    public class ReqPaymnetDataWrap{
        
        public String category{get;set;} 
        
        public double requestAmount{get;set;} 
        
        public String description{get;set;} 
        
        public String clientID{get;set;} 
        
        public String status{get;set;}
        
        public String appName{get;set;}
        
        public String requestDate{get;set;}
        
        public String requestId{get;set;} 
    }
    
}