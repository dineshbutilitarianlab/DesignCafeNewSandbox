@isTest
public class Floorplan_test {
    @isTest
    static void attach(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
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
        TriggerControl__c tc = new TriggerControl__c();
        tc.Run__c = true;
        tc.name = 'LeadTrigger';
        insert tc;
        Lead l = new Lead();
        l.Approx_Budget__c = '2L to 3L';
        l.LastName = 'test';
        l.City = 'Mumbai';
        l.MobilePhone='9090909090';
        insert l;
        String JSONBODY = '{"id":"Test","documents":[{"fileName": "attachfile.png","Content_Type": "image/png","data":"JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4+CnN0cmVhbQp4nOx9CWCUxdn/zLv3ld3NbjabbI43bC5IyJ2QAMLmJIGQQA5IEDCb7CZZ2BzsbrgEjIpXRIsWtVpr0Vq1xdoloKK1ipWqtd"}]}';
        JSONBODY = JSONBODY.replace('Test',l.id);
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/Floorplan';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSONBODY);
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Lead ld = new Lead();
        ld.Approx_Budget__c = '2L to 3L';
        ld.LastName = 'test';
        ld.City = 'Mumbai';
        ld.MobilePhone='9090909099';
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new FloorplanMockup());
        insert ld;
        Floorplan.doPost();
        Test.stopTest();
    }
}