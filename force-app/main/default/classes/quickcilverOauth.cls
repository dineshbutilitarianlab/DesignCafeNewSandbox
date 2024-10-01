public class quickcilverOauth {
    public static string AuthCode(){
        string Authcode;
        quickcilver__c  Qc = quickcilver__c.getvalues('quickcilver details');
        authWrapreq Aw = new authWrapreq();
        Aw.clientId = Qc.Consumer_Key__c;
        Aw.username = Qc.UserName__c;
        Aw.password = Qc.Password__c;
        
        string endpoint = Qc.url__c+'verify';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // following header is for identifying the request, given by qc for uat
        // request.setHeader('jriu43a2ravtind804ndj2', 'jes1unrcyaf3');
        // following header is for identifying the request, given by qc for production
        request.setHeader('mysalesforce', 'oishdfcoekjw345ds');
        String jsonBody = JSON.serialize(Aw);
        // system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        //system.debug('response body authorization Oauth: '+response.getBody());
        if(response.getStatusCode() == 200){
            authRes res = (authRes)json.deserialize(response.getBody(), authRes.class);
            authcode = res.authorizationCode;
              //Calling ApiCallLogger class
            ApiCallLogger.method('', request.getEndpoint(), jsonBody, response.getBody(), 'out');
        }
        //system.debug('authcode Oauth: ' + authcode);
        return authcode;
    }
    
    public static string BearerToken(){
        string BearerToken;
        quickcilver__c  Qc = quickcilver__c.getvalues('quickcilver details');
        BearerWrapReq Bw = new BearerWrapReq();
        Bw.clientId = Qc.Consumer_Key__c;
        Bw.clientSecret = Qc.Consumer_secret__c;
        Bw.authorizationCode = Authcode();
        
        string endpoint = Qc.url__c+'token';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // following header is for identifying the request, given by qc for uat
        // request.setHeader('jriu43a2ravtind804ndj2', 'jes1unrcyaf3');
        // following header is for identifying the request, given by qc for production
        request.setHeader('mysalesforce', 'oishdfcoekjw345ds');
        String jsonBody = JSON.serialize(Bw);
    	// system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        //system.debug('response body token Oauth: '+response.getBody());
        if(response.getStatusCode() == 200){
            BearRes res = (BearRes)json.deserialize(response.getBody(), BearRes.class);
            BearerToken = res.token;
           
             //Calling ApiCallLogger class
            ApiCallLogger.method(Null, request.getEndpoint(), jsonBody, response.getBody(), 'out');
            
        }
        // system.debug('BearerToken: ' + BearerToken);
        return BearerToken;
    }
   
 /*   public static void signature(){
        quickcilver__c  Qc = quickcilver__c.getvalues('quickcilver details');
        string secretKeyValue = Qc.Consumer_secret__c;
        string reqMethod = 'POST';
        string url = EncodingUtil.URLEncode(Label.WoohooAPI+'/1000000028/resend','UTF-8');
        string endpoint = reqMethod + '&' + url;
        system.debug('end point url '+endpoint);
        string signature;
        Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(endpoint), Blob.valueOf(secretKeyValue));
        signature = encodingUtil.convertToHex(hmacData);
        system.debug('signature '+signature);
    }   */
    
    public class authWrapreq{
        public string clientId;
        public string username;
        public string password;
    }
    public class authRes{
        public string authorizationCode;
    }
    public class BearerWrapReq{
        public string clientId;
        public string clientSecret;
        public string authorizationCode;
    }
    public class BearRes{
        public string token;
    }
}