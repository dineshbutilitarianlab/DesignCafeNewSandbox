@isTest
public class GenerateNewInvoice_GRaphQLMockTest_fail1 implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('200');
            res.setStatusCode(200);
            String jsonBody1 = '{"data":{"GenerateInvoicenewflow":{"code":400, "data":null, "message":"Project is not found for this invoice request"}}}';
            res.setBody(jsonBody1);
            return res; 
        }
}