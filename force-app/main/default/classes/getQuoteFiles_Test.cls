@isTest
public class getQuoteFiles_Test {
    public static testmethod void callmethod(){
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        Account acc =new Account();
        acc.FirstName='Test';
        acc.LastName='Account';
        acc.PersonMobilePhone ='9876543211';
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
        opty.Site_Services_Amount_Dis_Incl_GST__c=2000;
        opty.Modular_Amount_Dis_Incl_GST__c=3000;
        opty.Update_Booking_Form__c =True;
        opty.Project_Created_On_Odoo__c= true;
        opty.Lead_Id__c='ASDF456789HJK';
        opty.IsInvoiceGenerated__c= true;
        insert opty;
        opty.IsInvoiceGenerated__c=false;
        update opty;
        Quote qt = new Quote();
        qt.OpportunityId = opty.id;
        qt.Name = 'test';
        insert qt;
        
        ContentVersion attach=new ContentVersion();
        attach.ContentLocation ='S';
        attach.Title = 'fileName';
        attach.PathOnClient = 'fileName';
        attach.VersionData  = EncodingUtil.base64Decode('JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4');
        insert attach;
        string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
        
        ContentDocumentLink DocLink = new ContentDocumentLink();
        DocLink.ContentDocumentId = Versid;
        docLink.ShareType='V';
        DocLink.LinkedEntityId = qt.id;
        DocLink.Visibility='AllUsers';
        insert DocLink;
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        request.addParameter('opportunityId', opty.id);
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Test.startTest();
        getQuoteFiles.retrieve();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Test.stopTest();
        
    }
    
}