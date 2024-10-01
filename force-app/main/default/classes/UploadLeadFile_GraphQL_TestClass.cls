@isTest public class UploadLeadFile_GraphQL_TestClass {
    
    public static void testSetup() {
        
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        insert SRRmum;
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        insert SRRWDC;
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        insert SRRHyd;
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        insert SRRMGDC;
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        insert SRRHSR;
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        insert SRRCHE;
        SRR__c SRRjpdc = new SRR__c();
        SRRjpdc.Name = 'JPDC';
        SRRjpdc.index__c = 0;
        insert SRRjpdc;
        SRR__c SRRthane = new SRR__c();
        SRRthane.Name = 'Thane DC';
        SRRthane.index__c = 0;
        insert SRRthane;
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name = 'OMRCH';
        SRROMRCH.index__c = 0;
        insert SRROMRCH;
        
        SRR__c SRRHRBR = new SRR__c();
        SRRHRBR.Name = 'HRBRBLR';
        SRRHRBR.index__c = 0;
        insert SRRHRBR;
        
        SRR__c SRRRSPCO = new SRR__c();
        SRRRSPCO.Name = 'RSPCO';
        SRRRSPCO.index__c = 0;
        insert SRRRSPCO;
        
        DCWebengage__c cuset2= new DCWebengage__c();
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
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        
        Design_User__c Design = new Design_User__c();
        Design.Name = 'Test Designer';
        Design.Designer_Dashboard_ID__c = 'QA-1234';
        Design.Email__c = 'design@yopmail.com';
        Design.Mobile__c = '9066078981';
        Design.Region__c = 'Bengaluru';
        Design.Experience_Center__c = 'Mumbai Dc';
        Design.Role__c = 'Inhouse Designer';
        Design.Active__c = True;
        insert Design;
       
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='JPDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Account';
        acc.BillingPostalCode = '430056';
        acc.BillingStreet = 'Mahatma Gandhi Road';
        acc.ShippingState = 'Karnataka';
        acc.BillingCountry = 'India';
        acc.BillingState = 'Karnataka';
        acc.ShippingPostalCode = '430056';
        acc.ShippingCountry = 'India';
        acc.ShippingState = 'Karnataka';
        acc.ShippingStreet = 'Mahatma Gandhi Road';
        acc.BillingCity = 'Bengaluru';
        acc.ShippingCity = 'Bengaluru';
        acc.PAN__c = 'AAAAA1234W';
        acc.Customer_type__c = 'B2C';
        acc.Converted_Lead_ID__c = 'ASDFG45676GFD';
        acc.IsInvoiceGenerated__c = true;
        insert acc;
                
        opportunity opty = new opportunity();
        opty.Name = 'TestOpp';
        opty.AccountId = acc.Id;
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
        opty.Amount = 3124;
        opty.OwnerId = userinfo.getUserId();
        opty.Design_User__c = design.Id;
        opty.Is_Pm_Site__c = true;
        opty.Meeting_Venue__c = 'Mumbai Dc';
        opty.Modular_Milestone_Type__c = '3 Stage';
        opty.Client_s_Budget__c = 200;
        opty.Requirement_Details__c = 'Wardrobes';
        opty.Flooring_is_completed_Required__c = true;
        opty.Site_Services_Amount_Dis_Incl_GST__c = 2000;
        opty.Modular_Amount_Dis_Incl_GST__c = 3000;
        opty.IsNewPaymentProject__c = true;
        opty.Lead_Id__c = 'ASDF456789HJK';
        opty.IsInvoiceGenerated__c = true;
        insert opty;
        
        contentversion cv = new contentversion();
        cv.Title = 'Interior proposal';
        cv.WhatsApp_Int_Proposal__c = true;
        cv.WhatsApp_Civil_Proposal__c = false;
        cv.Whatsapp_PPT__c = false;
        cv.PathOnClient = '/' + cv.Title + '.pdf';
        Blob bodyBlob = Blob.valueOf('VersionData');
        cv.VersionData = bodyBlob;
        cv.origin = 'H';
        insert cv;
        ContentDocumentLink cdl1 = new ContentDocumentLink();
        cdl1.LinkedEntityId = ld.id;
        cdl1.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl1.ShareType = 'V';
        insert cdl1;
        
        ContentDocumentLink cdl2 = new ContentDocumentLink();
        cdl2.LinkedEntityId = opty.id;
        cdl2.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl2.ShareType = 'V';
        insert cdl2;
    }
    @isTest 
    public static void UploadoppFileTestClass(){
        testSetup();
        Id LeadId = [select id from Lead LIMIT 1].id;
        Id optyId = [select id from opportunity LIMIT 1].id;
        test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new GenerateNewInvoice_GRaphQLMockTest());
        UploadLeadFile_GraphQL.uploadFile(LeadId,optyId,'opportunity');
        test.stopTest(); 
    }
    @isTest 
    public static void UploadLeadFileTestClass(){
        testSetup();
        Id LeadId = [select id from Lead LIMIT 1].id;
        Id optyId = [select id from opportunity LIMIT 1].id;
        test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new GenerateNewInvoice_GRaphQLMockTest());
        UploadLeadFile_GraphQL.uploadFile(LeadId,null,'lead');
        test.stopTest(); 
    }
}