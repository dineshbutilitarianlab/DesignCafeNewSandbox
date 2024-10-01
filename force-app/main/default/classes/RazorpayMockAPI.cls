@IsTest
global class RazorpayMockAPI implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id":"order_DBJOWzybf0sJbb","entity":"order","amount":50000,"amount_paid":0,' +
                    '"amount_due":50000,"currency":"INR","receipt":"rcptid_11","status":"created",' +
                    '"attempts":0,"notes":[],"created_at":1566986570}');
        res.setStatusCode(200);
        return res;
    }
}