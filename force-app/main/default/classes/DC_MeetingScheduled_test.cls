@isTest
public class DC_MeetingScheduled_test{
    @isTest
    static void DC_MeetingScheduled(){
        String myJSON = '{"Mobile": "9912345678","MS_Date_Time": "2020-12-22T2:30"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs72.force.com/services/apexrest/meetingscheduled';
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
        
        SRR__c SRRMysore = new SRR__c();
        SRRMysore.Name = 'KDRMYS';
        SRRMysore.index__c = 0;
        insert SRRMysore;    
        SRR__c SRRPune = new SRR__c();
        SRRPune.Name = 'YERPUN';
        SRRPune.index__c = 0;
		insert SRRPune;
        SRR__c SRRBHHyd = new SRR__c();
        SRRBHHyd.Name = 'BHHYD';
        SRRBHHyd.index__c = 0;
        insert SRRBHHyd;    
        SRR__c SRRSJP = new SRR__c();
        SRRSJP.Name = 'SJPBLR';
        SRRSJP.index__c = 0;
        insert SRRSJP; 
        SRR__c SRRKHM = new SRR__c();
        SRRKHM.Name ='KHMUM';
        SRRKHM.index__c = 0;
        insert SRRKHM;  
        
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='prospect';
        Leadins.Call_Stage__c='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Scheduled';
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
       // Leadins.Whatsapp_Opt_IN__c = 'Accepted';
        update Leadins;
        DC_MeetingScheduled.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);   
    }
}