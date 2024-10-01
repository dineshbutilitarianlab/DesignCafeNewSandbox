@IsTest
private class ReferralUpdateAPI_RestResourceTest {

    @isTest
    static void testMobileNumber() {
        // Create a test user
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        // Set the current user to the test user
        System.runAs(testUser) {
            // Setup test data
            Account testAccount = getAccountRecord();
            String phoneNumber = testAccount.PersonMobilePhone; 
            String jsonRequestBody = '{"referralMobileNumber": "' + testAccount.PersonMobilePhone + '"}';
            
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            RestRequest req = new RestRequest();
            req.requestUri = '/services/apexrest/ReferralUpdateAPI';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(jsonRequestBody);
            RestContext.request = req;

            // Setup the mock HTTP response
            RestResponse res = new RestResponse();
            RestContext.response = res;
            String response = ReferralUpdateAPI_RestResource.referralDetails();
            ReferralUpdateAPI_RestResource.ApiResponse apiResponse = 
            (ReferralUpdateAPI_RestResource.ApiResponse) JSON.deserialize(response, ReferralUpdateAPI_RestResource.ApiResponse.class);

            System.assertEquals('Referral Updated Successfully!', apiResponse.message);
           
        }
    }
    
    @isTest
    static void testRefferalDetailsnotfound() {
        // Create a test user
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        // Set the current user to the test user
        System.runAs(testUser) {
            // Setup test data
            String phoneNumber = '9807654321'; 
            String jsonRequestBody = '{"referralMobileNumber": "' +phoneNumber  + '"}';
            
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            RestRequest req = new RestRequest();
            req.requestUri = '/services/apexrest/ReferralUpdateAPI';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(jsonRequestBody);
            RestContext.request = req;

            // Setup the mock HTTP response
            RestResponse res = new RestResponse();
            RestContext.response = res;
            String response = ReferralUpdateAPI_RestResource.referralDetails();
            ReferralUpdateAPI_RestResource.ApiResponse apiResponse = 
            (ReferralUpdateAPI_RestResource.ApiResponse) JSON.deserialize(response, ReferralUpdateAPI_RestResource.ApiResponse.class);

            System.assertEquals('Refferal Details not found', apiResponse.message);
           
        }
    }
    

    @IsTest
    static void testReferralDetailsException() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/ReferralUpdateAPI';
        req.httpMethod = 'POST';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        String response = ReferralUpdateAPI_RestResource.referralDetails();
        ReferralUpdateAPI_RestResource.ApiResponse apiResponse = 
            (ReferralUpdateAPI_RestResource.ApiResponse) JSON.deserialize(response, ReferralUpdateAPI_RestResource.ApiResponse.class);

    }
    
    @IsTest
    static Account getAccountRecord(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;

        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

        CPPortal__c data = new CPPortal__c();
        data.Name = 'cpportalopportunityupdate';
        data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;
        
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
        
        
        Profile systemAdminProfile = [SELECT Id, Name FROM Profile where Name = 'System Administrator'];
        User systemAdminUser = [SELECT Id, Name,ProfileId FROM User WHERE ProfileId =: systemAdminProfile.Id and IsActive = true Limit 1];
        List<Lead> leadList = new List<Lead>();
        System.runAs(systemAdminUser){
            
            for (Integer i = 0; i < 5; i++) {
                    Lead leadRecord = new Lead(
                    FirstName = 'Testing'+i,
                    Lastname = 'test',
                    Email = 'test@example.com',
                    MobilePhone = '9876543291',
                    Source__c = 'Organic',
                    Region__c = 'Hyderabad',
                    Channel__c = 'Online',
                    City = 'Hyderabad',
                    DC_Lead_Source__c = 'Google Search Organic',
                   // LastModifiedDate = DateTime.now(),
                    Follow_Up_Date_Time__c = DateTime.now(),
                    DC_Campaign_Source__c = 'Organic Search',
                    //CreatedById = systemAdminUser.Id,
                   // LastModifiedById = systemAdminUser.Id,
                    DC_Lead_Status__c = 'Organic Search',
                    Status = 'New',
                    Call_Stage__c = 'Undialed',
                    //CreatedDate = Date.valueOf(System.now()),
                    Property_Possession_Date__c = Date.today()
                    
                    );
                leadList.add(leadRecord);
            }  
            insert leadList;
        }
        
        Account acc = new Account();
        acc.RecordTypeId = '0122v000001WY0UAAW';
        acc.BillingStreet = '5th block';
        acc.BillingCity = 'Bengaluru';
        acc.BillingState ='Karnataka';
        acc.BillingPostalCode ='560096';
        acc.BillingCountry = 'India';
        acc.ShippingStreet = '5th block';
        acc.ShippingCity = 'Bengaluru';
        acc.ShippingState = 'Karnataka';
        acc.ShippingPostalCode = '560096';
        acc.ShippingCountry ='India';
        acc.PersonMobilePhone = '9079112856';
        acc.PersonEmail = 'test21@gmail.com';
        acc.Customer_type__c = 'B2B';
        acc.GST_No__c = '06BZAHM6385P6Z2';
        acc.Converted_Lead_ID__c = leadList[0].Id;
        acc.LastName = 'Test';
        insert acc;
        
        opportunity opty=new opportunity();
            opty.Name='TestOpp';
            opty.AccountId=acc.Id;
            opty.stagename = 'Proposal Sent';
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
        return acc;
    }
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }

}