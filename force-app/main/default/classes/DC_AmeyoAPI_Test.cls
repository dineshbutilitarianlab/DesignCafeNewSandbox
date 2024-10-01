@isTest
public class  DC_AmeyoAPI_Test {

    @isTest
    static void ameyoapi(){
        
      //  user u = [Select id, name, profile from user WHERE profile.name = 'Designer']; 
       String myJSON = '{"Mobile":"0000000000","recordId": "0052v00000fa26SAAQ","Lead_Owner_Name": "test", "Lead_owner_Email":"test@gmail.com","Alternate_Contact_Number":9066050687 }';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        //Added
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
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
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;
        SRR__c SRRChennai = new SRR__c();
        SRRChennai.Name = 'Chennai';
        SRRChennai.index__c = 0;
        insert SRRChennai;
        SRR__c SRRJPDC = new SRR__c();
        SRRJPDC.Name = 'JPDC';
        SRRJPDC.index__c = 0;
        insert SRRJPDC;
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRThane = new SRR__c();
        SRRThane.Name = 'Thane DC';
        SRRThane.index__c = 0;
        insert SRRThane;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRKHM = new SRR__c();
        SRRKHM.Name ='KHMUM';
        SRRKHM.index__c = 0;
        insert SRRKHM;  
        
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        leadins.LastName='test';
        leadins.Alternate_Contact_Number__c ='9000010000';
        //leadins.Lead_Owner_Name__c ='test';
        //leadins.UserID__c='0052v00000fa26SAAQ';
        Leadins.Status ='prospect';
        Leadins.Call_Stage__c='Meeting Scheduled';
       // Leadins.DC_Lead_Status__c ='Meeting Scheduled';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Meeting_Venue__c = 'Mumbai DC';
        Leadins.Willingness_For_Meeting__c = system.today();
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='Direct';
        Leadins.Source_Journey__c='Online';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        //Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
      //  Leadins.Designer__c = u.Id;
        insert Leadins;
      //  Leadins.Status = 'converted';
      //  Leadins.DC_Lead_Status__c = 'Meeting Done';
      //  Leadins.Whatsapp_Opt_IN__c = 'Accepted';
        update Leadins;
        DC_AmeyoAPI.doPost1();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);        
    }
}