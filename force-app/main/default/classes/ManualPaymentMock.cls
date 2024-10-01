@isTest global class ManualPaymentMock implements HttpCalloutMock{
 global HttpResponse respond(HttpRequest req){
        HttpResponse resp = new HttpResponse();
     	String json = '{"errors":[], "data":{"code":200, "message":"Successful"}}}';
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(200);
        resp.setBody(json);
        return resp;
    }
}