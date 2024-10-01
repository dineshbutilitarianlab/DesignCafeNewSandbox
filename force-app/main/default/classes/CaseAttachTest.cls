@isTest
public class CaseAttachTest {
    @isTest
    static void attach(){
        case c = new Case();
        c.Subject = 'Test Subject';
        insert c;
        String JSONBODY = '{"id":"Test","documents":[{"fileName": "attachfile.png","Content_Type": "image/png","data":"JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4+CnN0cmVhbQp4nOx9CWCUxdn/zLv3ld3NbjabbI43bC5IyJ2QAMLmJIGQQA5IEDCb7CZZ2BzsbrgEjIpXRIsWtVpr0Vq1xdoloKK1ipWqtd"}]}';
        JSONBODY = JSONBODY.replace('Test',c.id);
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/caseattach';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSONBODY); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Case cs = new Case();
        Test.startTest();
        insert cs;
        CaseAttach.doPost();
        Test.stopTest();
    }
}