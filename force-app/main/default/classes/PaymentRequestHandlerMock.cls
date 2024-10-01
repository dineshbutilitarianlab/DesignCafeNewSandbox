@isTest global class PaymentRequestHandlerMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req){
        HttpResponse resp = new HttpResponse();
        String json ='{"errors":[], "data":{"code":200, "message":"Successful"}}}';
        //String json ='{"DATA_FIELD":"data", "ERRORS_FIELD":"errors", "errors":[], "responseJson":{"data":{"AddPaymentRequests":{"code":200,"data":{"requestID":"PR-XUnHsezie"},"message":"Payment request added successfully","statusCode":200}}},"errors":[]}';
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(200);
        resp.setBody(json);
        return resp;
    }

}