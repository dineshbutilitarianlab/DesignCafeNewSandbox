global class AuthorizationTokenMock implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        String hadj = String.valueOf(req.getBody());
        System.debug('my request 1 '+ hadj);
        System.debug('my request token '+ hadj.contains('AuthenticationToken'));
        Boolean bsha = hadj.contains('AuthenticationToken');
		System.debug('bsha '+ bsha);
        // Optionally, only send a mock response for a specific endpoint
        AuthenticationToken_GraphQL.ResponseDataOfAuth respData = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
        respData.accessToken='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6Ijc3MTAxNTgyLWV2OGs5ODg3cnl0dWlramhnYm5lcnQ0MyIsImlhdCI6MTY1NzI4MTQ3NSwiZXhwIjoxNjU3MjgxNjU1fQ.VMZrogLXx1XEuVv4Y6GcOfIbiPQUZcwpnbP2RxxcRmE';
        respData.statusCode=200;
        respData.code=200;
        respData.message='Success';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setHeader('Authorization', respData.accessToken);
        
        res.setStatusCode(200);
        //string jsonString = '[DATA_FIELD=data, ERRORS_FIELD=errors, errors=(), responseJson={data={addCustomers={code=200, data={customeremail=null, customerid=1368, customerphone=8989123447, firstname=null, generatedotptimestamp=null, gstno=null, lastname=tessssssttt, odoocontactid=null, otp=null, pancardno=null}, message=null}}}]';
		string jsonString = '{"data":{"addCustomers":{"code":200,"message":null,"data":{"customerid":1371,"otp":null,"generatedotptimestamp":null,"firstname":null,"customeremail":null,"lastname":"test lead abhikeabhi","customerphone":"7893691592","salesforceid":null,"pancardno":null,"gstno":null,"odoocontactid":null}}}}';
        //String jsonBody = 'ResponseDataOfAuth:[accessToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6Ijc3MTAxNTgyLWV2OGs5ODg3cnl0dWlramhnYm5lcnQ0MyIsImlhdCI6MTY1NzI4NTM2MCwiZXhwIjoxNjU3Mjg1NTQwfQ.TFIYDZS2MtMGUfx6gxixrZtR2l2iLNQVjorpZxr-ZtI, code=200, message=success, statusCode=null]';
        string jsonBody ='{"data":{"AuthenticationToken":{"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6Ijc3MTAxNTgyLWV2OGs5ODg3cnl0dWlramhnYm5lcnQ0MyIsImlhdCI6MTY1NzE5NDA2OCwiZXhwIjoxNjU3MTk0MjQ4fQ.mr3GHUDfDdzYbmY5eyLkkO7B51PQQFh8931mRw5QLFs","message":"success","code":200}},"error":[]}';
        //String jsonRes ='{"responseJson":{"data":{"AddPaymentRequests":{"code":200,"data":{"requestID":"PR-XUnHsezie"},"message":"Payment request added successfully","statusCode":200}}}}';
        jsonString = '{"data":{"AddPaymentReceipts":{"code":500, "data":{"customerid":1371,"otp":null, "paymentID":12345}, "message":"Hostname/IP does not match certificate", "statusCode":200, "paymentID":"12345"}}}';
        res.setBody(bsha ? jsonBody: jsonString);	
        
        return res;
    }
   
}