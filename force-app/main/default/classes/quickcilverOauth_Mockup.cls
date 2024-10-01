global class quickcilverOauth_Mockup implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        quickcilverOauth.authWrapreq authreqwrap = new quickcilverOauth.authWrapreq();
        authreqwrap.clientId = '3423';
        authreqwrap.username = '3423';
        authreqwrap.password = '3423';
        
        quickcilverOauth.authRes ar = new quickcilverOauth.authRes();
        ar.authorizationCode = 'd1c8b95c28ed1460d573'; // authorization code generated
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(ar));
        response.setStatusCode(200);
        return response;
    }
}