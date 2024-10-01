@isTest
public class Proposalsent_Test {
    @istest
    static void ProposalSent(){
        //insert Custom setting for LeadTrigger
       	Proposal_Sent_Date.DetailsWrap wrap = new Proposal_Sent_Date.DetailsWrap();
       	wrap.Proposal_Date = System.today();
        quickcilver__c  cusSet1 = new quickcilver__c();
        cusSet1.Name = 'quickcilver details';
        cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
        cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
        cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
        cusSet1.Token_Date__c = System.today();
        insert cusSet1;
        
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityupdate';
        cuset3.url__c= 'https://oh0u9k2g6f.execute-api.ap-south-1.amazonaws.com/prod/updateOpportunity';
        insert cuset3; 
       
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
       
        
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
        
        
        opportunity opty = new opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Follow Up';
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
        opty.Proposal_Sent_Date__c=system.today();
        insert opty;
        opty.StageName='Proposal Sent';
        opty.IsInvoiceGenerated__c=false;
        update opty;
        
 
        List<Opportunity> o = [SELECT id,Proposal_Sent_Date__c,Mobile__c,StageName from Opportunity WHERE id = :opty.id];
        if(o.size() !=0){
            Opportunity op = new Opportunity();
            op.Id = o[0].id;
            op.Name = 'test';
            op.AccountId = acc.id;
            op.StageName ='Meeting Done';
            op.CloseDate = System.today();
            op.Proposal_Sent_Date__c =System.today();
            op.The_Doors_Windows_are_installed_Requir__c = true;
            op.Flooring_is_completed_Required__c = true;
            op.Putty_and_1_coat_of_plastering_Required__c = true;
            op.Client_s_Budget__c = 100;
            op.Proposed_Budget__c = 100;
            op.DSA_Email__c = 'test@test.com';
            update op;
            
        } 
        String myJSON = '{"Mobile":"9876543266","Proposal_Date":"2020-11-09"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dev8-designcafe.cs111.force.com/services/apexrest/ProposalDate';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        test.startTest();
       Proposal_Sent_Date.doPost();
      Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        test.stopTest();
    }  
}