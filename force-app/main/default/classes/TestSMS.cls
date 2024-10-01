@isTest
global class TestSMS implements HttpCalloutMock{
 global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       // System.assertEquals('http://example.com/example/test', req.getEndpoint());
       // System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"message":"sent"}');
        res.setStatusCode(200);
        return res;
    }
}