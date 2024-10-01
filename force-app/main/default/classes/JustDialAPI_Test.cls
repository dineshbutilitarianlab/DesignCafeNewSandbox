@isTest
public class JustDialAPI_Test {
    @TestSetup
    static void makeData(){
        
        TriggerControl__c cuset3 = new TriggerControl__c();
        cuset3.Name = 'LeadTrigger';
        cuset3.Run__c = true;
        insert cuset3;

        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
         insert cuset2;
        List<SRR__c> SRRList = new List<SRR__c>();
        
        
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        SRRList.add(SRRmum);
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        SRRList.add(SRRWDC);
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        SRRList.add(SRRHyd);
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        SRRList.add(SRRMGDC);
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        SRRList.add(SRRHSR);
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        SRRList.add(SRRCHE);
        SRR__c SRRjpdc = new SRR__c();
        SRRjpdc.Name = 'JPDC';
        SRRjpdc.index__c = 0;
        SRRList.add(SRRjpdc);
        SRR__c SRRthane = new SRR__c();
        SRRthane.Name = 'Thane DC';
        SRRthane.index__c = 0;
        SRRList.add(SRRthane);
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        SRRList.add(SRRKDRMYS);
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        SRRList.add(SRRYERPUN);
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        SRRList.add(SRRBHHYD);
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        SRRList.add(SRRSJPBLR);
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        SRRList.add(SRRKHMUM);
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        SRRList.add(SRRWLMUM);
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name = 'OMRCH';
        SRROMRCH.index__c = 0;
        SRRList.add(SRROMRCH);
        
        
        
        
        SRR__c SRRHRBRBLR = new SRR__c();
        SRRHRBRBLR.Name = 'HRBRBLR';
        SRRHRBRBLR.index__c = 0;
        SRRList.add(SRRHRBRBLR);
        
        SRR__c SRRHRRSPCO = new SRR__c();
        SRRHRRSPCO.Name = 'RSPCO';
        SRRHRRSPCO.index__c = 0;
        SRRList.add(SRRHRRSPCO);
        SRR__c SRRHRDNVIZ = new SRR__c();
        SRRHRDNVIZ.Name = 'DNVIZ';
        SRRHRDNVIZ.index__c = 0;
        SRRList.add(SRRHRDNVIZ);
        
        if(SRRList.size()> 0){
               Insert SRRList; 
        }

        Lead leadRecord = new Lead();
        leadRecord.Status = 'New';
        leadRecord.DC_Lead_Status__c = 'Undialed';
        leadRecord.Call_Stage__c = 'Undialed';
        leadRecord.Channel__c = 'Online';
        leadRecord.Source__c = 'Paid';
        leadRecord.DC_Lead_Source__c = 'Justdial Ads';
        leadRecord.DC_Campaign_Source__c = 'Justdial';
        leadRecord.Title = 'Mr';
        leadRecord.LastName = 'Test';
        leadRecord.MobilePhone = '9999999999';
        leadRecord.Email = 'test@designcafe.com';
        leadRecord.City = 'Mumbai';
        leadRecord.Company = 'Design Cafe';
        leadRecord.Customer_Pincode__c = '305001';

        insert leadRecord;
       
    }
    @isTest
    static void testDoPostWithInValidRequestBody() {
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        String input = 'Success';

        RestRequest req = new RestRequest();
        req.requestURI = 'https://dc--int.sandbox.my.site.com/services/apexrest/JustDial_API';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(input);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JustDialAPI.doPost();
        Test.stopTest();
        Map<String,Object> respo =  (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());
        System.debug('result => '+respo.get('result').toString());
        System.assertNotEquals('Record Created Successfully', respo.get('result').toString());
    }

    @isTest
    static void testDoPostWithValidInput() {
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        JustDialAPI.JustDialWrapper input = new JustDialAPI.JustDialWrapper();
        input.prefix = 'Mr.';
        input.name = 'John Doe';
        input.mobile = '1234567890';
        input.email = 'john.doe@example.com';
        input.city = 'Mumbai';
        input.company = 'Acme Inc.';
        input.pincode = '12345';

        RestRequest req = new RestRequest();
        req.requestURI = 'https://dc--int.sandbox.my.site.com/services/apexrest/JustDial_API';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(input));
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JustDialAPI.doPost();
        Test.stopTest();
        Map<String,Object> respo =  (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());
        System.debug('result => '+respo.get('result').toString());
        System.assertEquals('Record Created Successfully', respo.get('result').toString());
    }

    @isTest
    static void testDoPostWithBlankRequestBody() {
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        JustDialAPI.JustDialWrapper input = new JustDialAPI.JustDialWrapper();
      

        RestRequest req = new RestRequest();
        req.requestURI = 'https://dc--int.sandbox.my.site.com/services/apexrest/JustDial_API';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JustDialAPI.doPost();
        Test.stopTest();
        Map<String,Object> respo =  (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());
        System.debug('result => '+respo.get('result').toString());
        System.assertEquals('Request Body is Missing', respo.get('result').toString());
    }

    @isTest
    static void testDoPostWithMissingMobileNumber() {
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        JustDialAPI.JustDialWrapper input = new JustDialAPI.JustDialWrapper();
        input.prefix = 'Mr.';
        input.name = 'John Doe';
        input.email = 'john.doe@example.com';
        input.city = 'Mumbai';
        input.company = 'Acme Inc.';
        input.pincode = '12345';

        RestRequest req = new RestRequest();
        req.requestURI = 'https://dc--int.sandbox.my.site.com/services/apexrest/JustDial_API';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(input));
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JustDialAPI.doPost();
        Test.stopTest();
        Map<String,Object> respo =  (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());
        System.debug('result => '+respo.get('result').toString());
        System.assertEquals('Mobile Number Is Required', respo.get('result').toString());
    }

    @isTest
    static void testDoPostWithExistingLead() {
        // Add test data for an existing lead with the mobile number in the request
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        JustDialAPI.JustDialWrapper input = new JustDialAPI.JustDialWrapper();
        input.prefix = 'Mr.';
        input.name = 'John Doe';
        input.mobile = '9999999999';
        input.email = 'john.doe@example.com';
        input.city = 'Mumbai';
        input.company = 'Acme Inc.';
        input.pincode = '12345';

        RestRequest req = new RestRequest();
        req.requestURI = 'https://dc--int.sandbox.my.site.com/services/apexrest/JustDial_API';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(input));
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JustDialAPI.doPost();
        Test.stopTest();
        Map<String,Object> respo =  (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());
        System.debug('result => '+respo.get('result').toString());
        //System.assertEquals('Lead Already Exist In SF', respo.get('result').toString());
    }
}