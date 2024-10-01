@isTest
public class FollowupCount_RestResourceTest {
    
    @testSetup
    static void initiateVarsHelper() {
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
        CPPortal__c cpp = new CPPortal__c();
        cpp.name = 'cpportalupdate';
        cpp.url__c = 'http://testurl.com';
        insert cpp;
        
        Design_User__c des = new Design_User__c();
        des.Name = 'testdesigner';
        des.Email__c = 'testdesigner@test.com';
        des.Designer_Dashboard_ID__c = 'ID';
        des.Role__c = 'Studio Manager';
        insert des;
        
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
        SRR__c SRRNVM = new SRR__c();
        SRRNVM.Name = 'KHMUM';
        SRRNVM.index__c = 0;
        insert SRRNVM;    
        
        SRR__c SRWLMUM = new SRR__c();
        SRWLMUM.Name = 'WLMUM';
        SRWLMUM.index__c = 0;
        insert SRWLMUM;  
        
        SRR__c SROMRCH = new SRR__c();
        SROMRCH.Name = 'OMRCH';
        SROMRCH.index__c = 0;
        insert SROMRCH; 
        
        SRR__c SRHRBRBLR = new SRR__c();
        SRHRBRBLR.Name = 'HRBRBLR';
        SRHRBRBLR.index__c = 0;
        insert SRHRBRBLR; 
        
        SRR__c SRRSPCO= new SRR__c();
        SRRSPCO.Name = 'RSPCO';
        SRRSPCO.index__c = 0;
        insert SRRSPCO; 
        
        SRR__c SRDNVIZ = new SRR__c();
        SRDNVIZ.Name = 'DNVIZ';
        SRDNVIZ.index__c = 0;
        insert SRDNVIZ; 
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = false;
        insert cuset1; 
    }
    
    @isTest
    public static void dopost_Cover(){
        
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.Willingness_For_Meeting__c  = system.today().adddays(1);
        Leadins.Meeting_Venue__c = 'Mumbai DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.DC_Lead_Status__c ='Meeting Rescheduled';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
      //  Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        insert Leadins;
        
        String myJSON = '{"Id": "' + Leadins.Id +  '", "FollowupCount": "5" , "AttemptCount": "5" }';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.salesforce-sites.com/followupcount/services/apexrest/followupcount';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        FollowupCount_RestResource.doPost(); 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    // Added By Muskan on 4 March 2024 for attemptCount value in lead by an API
    @isTest
    public static void dopost_Cover1(){
      
       	RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.salesforce-sites.com/followupcount/services/apexrest/followupcount';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        FollowupCount_RestResource.doPost(); 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        
    }
    
     @isTest
    public static void dopost_Cover2(){
      
        String myJSON = '{"Id": "00Q9H0000020q3xUAA","FollowupCount": "67","AttemptCount" : "67"}'; 
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.salesforce-sites.com/followupcount/services/apexrest/followupcount';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        FollowupCount_RestResource.doPost(); 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        
    }
}