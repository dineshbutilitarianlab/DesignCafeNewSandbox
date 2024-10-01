@istest
public class Test_BookingFormAPI {

     @istest
     static void opptyBookingForm(){
        DCWebengage__c  cuset2= new DCWebengage__c();
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
        BookingFormAPI__c cuset = new BookingFormAPI__c();
        cuset.Name = 'Bookapi';
        cuset.url__c = 'https://fhzcjk7k59.execute-api.ap-south-1.amazonaws.com/test/bookingForm';
        insert cuset;  
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage__c":"Undialed"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
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
        Test.setMock(HttpCalloutMock.class, new CCMockUp()); 
        DC_BookingFormAPI.DC_BookingFormAPIServer(opty.id);
    }
    
   
}