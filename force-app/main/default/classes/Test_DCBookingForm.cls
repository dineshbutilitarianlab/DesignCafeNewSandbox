@istest
public class Test_DCBookingForm {
    
    
    
    @istest Static void DCBookForm(){
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
	//
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;   
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Designer'];
        User user = new User(
            ProfileId = pf.Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert User;
        User u = new User();
        u.Alias = 'standt';
        u.Email='standarduser1@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing20';
        u.firstName='test';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;//------------------------// profile of Designer for user(u)//
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='testing1762021@testing.com';
        insert u;
        User u1 = new User();
        u1.Alias = 'standt';
        u1.Email='standarduser1@testorg.com';
        u1.EmailEncodingKey='UTF-8';
        u1.LastName='Testing20';
        u1.firstName='test';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.ProfileId = pf.Id;
        u1.TimeZoneSidKey='America/Los_Angeles';
        u1.UserName='testing1762020@testing.com';
        u1.ManagerId = u.Id;
        insert u1;
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        
        /*Account a = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', PersonEmail='kim.president@korea.com', RecordTypeId = recordType.id );
        insert a;*/
        Account acc =new Account();
        acc.FirstName='Test';
        acc.Salutation = 'Mr.';
        acc.LastName='Account';
        acc.PersonEmail='kim.president@korea.com';
        acc.PersonMobilePhone ='9876543211';
        acc.BillingPostalCode='430056';
        acc.RecordTypeId = recordType.id;
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
        acc.Converted_Lead_ID__c='ASDFG5678JHG';
        acc.IsInvoiceGenerated__c=true;
        acc.Customer_created_on_Odoo__c  =true;
        insert acc;
        acc.IsInvoiceGenerated__c=false;
        acc.PersonMobilePhone ='9876543266';
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
        opty.closedate=system.today();
        opty.X1st_Meeting_Date__c = system.today();
        opty.X1st_Meeting_Person__c = User.Id;
        opty.X2nd_Meeting_Date__c = system.today()+1;
        opty.X2nd_Meeting_Person__c = u1.Id;
        opty.X3rd_Meeting_Date__c = system.today()+2;
        opty.Proposed_Budget__c = 500000;
        opty.Client_s_Budget__c = 500000;
        opty.Designer__c=u.id;
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Proposal Sent';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Followup_Date_Time__c =system.now();
        opty.All_walls_are_completed_Required__c= true;
        opty.Floors_are_levelled_out_prepped_Basic__c=true;
        opty.Frames_for_all_external_Doors_Windows__c =true;
        opty.The_Doors_Windows_are_installed_Requir__c =true;
        opty.Flooring_is_completed_Required__c=true;
        opty.Putty_and_1_coat_of_plastering_Required__c=true;
        opty.Probability = 100;
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
        opty.Site_Services_Amount_Dis_Incl_GST__c=2000;
        opty.Modular_Amount_Dis_Incl_GST__c=3000;
        opty.Update_Booking_Form__c =True;
        opty.Project_Created_On_Odoo__c= true;
        opty.Lead_Id__c='ASDF456789HJK';
        opty.IsInvoiceGenerated__c= true;
        insert opty;
        opty.IsInvoiceGenerated__c=false;
        update opty;
        
        
        
        
        string rec;
        pageReference pdfPage = Page.DCBookingFormSendPDF;
        pdfPage.getParameters().put('id',rec);
        
        ApexPages.currentPage().getParameters().put('id',opty.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opty);
        DCBookingForm bform=new DCBookingForm (sc);
        bform.SaveFile();
        // bform.SendFile();
        String myJSON = '{"OpportunityId":"'+opty.Id+'","PAN_Number": "AAAAA0000A","GST_Number": "","Property_Address":"","Bookingform_Signed":true}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs72.force.com/services/apexrest/DC_BookingForm';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;  
        test.startTest();
        DC_BookingForm.doPost();
          Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        test.stopTest();
    }
}