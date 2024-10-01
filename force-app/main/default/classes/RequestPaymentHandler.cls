public with sharing class RequestPaymentHandler {
    
    
    public static list<Request_Payment__c> rp{get;set;}
    @AuraEnabled
    public static Response sendRequestPayment( String Category, Decimal requestAmount,String Description, String ClientID, String Status,Id OpportunityId) {
        
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        
        if(MicroAuthResp.accessToken != null){
            ReqPaymnetDataWrap rpd = new ReqPaymnetDataWrap();
            rpd.category = Category;
            rpd.requestAmount = requestAmount;
            rpd.description = Description;
            rpd.clientID = ClientID;
            rpd.status = Status;
            Date d = Date.today();
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
            rpd.requestDate = dt;
            rpd.appName = 'Salesforce';          
            
            HttpRequest request = new HttpRequest();
            String endpoint = System.label.CreatePaymentRequestAPIURL;
            request.setTimeout(90000);
            request.setEndpoint(endpoint);
            //request.setEndpoint('https://269lxfmc5g.execute-api.ap-south-1.amazonaws.com/dev/createPaymentRequest');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            String jsonBody = JSON.serialize(rpd);
            System.debug('RequestPayment: SendpaymentReq: ---Insert--jsonBody----'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            System.debug('RequestPayment: SendPaymentReq: ---Insert--request----'+request);
            HttpResponse response = http.send(request);
            System.debug('RequestPayment: SendPaymentReq: ---Insert--response----'+response.getBody());
            Response respData = (Response)JSON.deserialize(response.getBody(), Response.class);
            System.debug('respData:: '+respData);
            if((respData != null) && (respData.data != null) && (respData.data.requestId != null)) {            
                //rp.Request_Id__c = respData.data.requestId;
                //insert rp; 
                //  createProjectRequest(rp.Id);
                return respData;
                
            }
            else {
                system.Debug('RequestPayment: SendPaymentReq: Null Response!');
                respData.code='400';
                return respData;
            }
        }
        Response RequestPaymentAuthWrap = new Response();
        if (MicroAuthResp.accessToken == null) {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            RequestPaymentAuthWrap.code = MicroAuthResp.code;
        }
        return RequestPaymentAuthWrap;
    }
    
    
    
    @future(Callout=True)
    public static void updateRequestPayment( String recId) {
        
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        
        if(MicroAuthResp.accessToken != null){
            Request_Payment__c rp = [select id,Category__c,Request_Amount__c,Description__c,Client_ID__c, Status__c,Request_Id__c from Request_Payment__c where id = : recId ];
            System.debug('RP:'+rp);
            if ((rp == null) || (rp.Status__c == 'pending')) {
                system.debug('RP is null OR Status is Pending. Cannot continue Further');
                return;
            }
            
            ReqPaymnetDataWrap rpd = new ReqPaymnetDataWrap();
            rpd.requestID = rp.Request_Id__c;
            
            Date d = Date.today();
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
            rpd.requestDate = dt;
            rpd.category = rp.Category__c;
            rpd.requestAmount = rp.Request_Amount__c.setScale(0);
            rpd.description = rp.Description__c;
            rpd.clientID = rp.Client_ID__c;
            rpd.status = rp.Status__c;
            rpd.appName = 'Salesforce';
            
            HttpRequest request = new HttpRequest();
            String endpoint = System.label.UpdatePaymentRequestAPIURL;
            request.setEndpoint(endpoint);
            //request.setEndpoint('https://269lxfmc5g.execute-api.ap-south-1.amazonaws.com/dev/updatePaymentRequest');
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            
            String jsonBody = JSON.serialize(rpd);
            System.debug('RequestPayment:Update--response: ---Update--jsonBody----'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('RequestPayment:Update--request: ---Update--request----'+request);
            System.debug('hjbh4545'+response);
            System.debug('RequestPayment: ---Update--response----'+response.getBody());
            if(response == null) {
                system.Debug('RequestPayment: Update: Null Response!');
            }
            
        }
        Response RequestPaymentAuthWrap = new Response();
        if (MicroAuthResp.accessToken == null) {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            RequestPaymentAuthWrap.code = MicroAuthResp.code;
        }
        
    }
    
    @future(Callout=True)
    public static void deleteRequestPayment(String recId) {
        
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        
        if(MicroAuthResp.accessToken != null) {
            system.debug('recordId:'+recId);
            ReqPaymnetDataWrap rpd = new ReqPaymnetDataWrap();
            rpd.requestID = recId;
            system.debug('requestID:'+rpd.requestID);
            
            HttpRequest request = new HttpRequest();
            String endpoint = System.label.DeletePaymentRequestAPIURL;
            request.setEndpoint(endpoint);
            //request.setEndpoint('https://269lxfmc5g.execute-api.ap-south-1.amazonaws.com/dev/deletePaymentRequest');
            request.setMethod('DELETE');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            String jsonBody = JSON.serialize(rpd);
            System.debug('RequestPayment:Delete--response: ---Insert--jsonBody----'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            System.debug('RequestPayment: ---Delete---response----'+response.getBody());
            if(response == null) {
                system.Debug('RequestPayment: Delete : Null Response!');
            } 
        }
        Response RequestPaymentAuthWrap = new Response();
        if (MicroAuthResp.accessToken == null) {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            RequestPaymentAuthWrap.code = MicroAuthResp.code;
        }
        
    }
    
    public class ReqPaymnetDataWrap{
        @AuraEnabled
        public String category{get;set;} 
        @AuraEnabled
        public Decimal requestAmount{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled
        public String clientID{get;set;} 
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public String appName{get;set;}
        @AuraEnabled
        public String requestDate{get;set;}
        @AuraEnabled
        public String requestID{get;set;} 
        
    }
    Public class Response{
        @AuraEnabled
        public string statusCode;
        @AuraEnabled
        public string code;
        @AuraEnabled
        public string message;
        @AuraEnabled
        public responsedata data;
        @AuraEnabled
        public string accessToken;
    }
    public class responsedata{
        @AuraEnabled
        public string requestId;
    }
    public class ReqPayAuthwrap{
        @AuraEnabled
        public string clientId {get;set;}   
    }
}