@isTest
public class OppFileAttach_Test {
    public static testmethod void testOpp(){
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;        
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        Opportunity oppty = new Opportunity();
        oppty.Name = 'test';
        oppty.AccountId = acc.id;
        oppty.StageName ='Meeting Done';
        oppty.CloseDate = System.today();
        oppty.Lead_Id__c = '00LeadID';
        insert oppty;
        String JSONBODY = '{"id":"Test","documents":[{"fileName": "attachfile.png","Civil_Work_Proposal":true,"Interior_Work_Proposal":false,"PPT_Document":false,"Content_Type": "image/png","data":"JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4+CnN0cmVhbQp4nOx9CWCUxdn/zLv3ld3NbjabbI43bC5IyJ2QAMLmJIGQQA5IEDCb7CZZ2BzsbrgEjIpXRIsWtVpr0Vq1xdoloKK1ipWqtd"}]}';
        JSONBODY = JSONBODY.replace('Test',oppty.id);
        RestRequest request = new RestRequest();
        request.requestUri ='https://dev8-dcafe.cs111.force.com/designerdashboard/services/apexrest/Opptyattach';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSONBODY); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Account a = new Account();
        a.Name = 'test';
        a.Converted_Lead_ID__c = '00LeadID';
        insert a;
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = a.id;
        opp.StageName ='Meeting Done';
        opp.CloseDate = System.today();
        opp.Lead_Id__c = '00LeadID';
        Test.startTest();
        insert opp;
        OppFileAttachFromDD.doPost();
        Test.stopTest();
    }
}