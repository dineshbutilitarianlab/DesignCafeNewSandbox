public with sharing class MicroservicesAuthentication {
    public static ResponseDataOfAuth AuthApi(){
        Authwrap WrpAuth = new Authwrap();  
        WrpAuth.clientId = System.label.Paymi_Authentication_clientId;
        // Call the Authentication API
        HttpRequest request = new HttpRequest();
        String endpoint = System.label.PayMi_Authentication_APIURL;
        request.setEndpoint(endpoint);
        request.setTimeout(90000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(WrpAuth);
        System.debug('Authentication: ---JsonBody-----'+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        System.debug('Authentication: ---Insert--request----'+request);
        HttpResponse response = http.send(request);
        System.debug('Authentication: response.getBody----'+response.getBody());
        ResponseDataOfAuth respData = (ResponseDataOfAuth)JSON.deserialize(response.getBody(), ResponseDataOfAuth.class);
        system.debug('respData:'+respData.accessToken);
        String AccessToken = respData.accessToken;
        System.debug('AccessToken5 '+AccessToken);
        return respData;
    }
    
    Public class Authwrap{
        @AuraEnabled
        Public string clientId {get;set;}   
    }
    public class ResponseDataOfAuth {
        public String statusCode;
        public String code;
        public String message;
        public string accessToken;        
    }
    
}