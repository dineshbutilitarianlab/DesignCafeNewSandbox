public class RazorpayAPI {
    public class Request {
        public Integer mAmount;
        public String mReceipt;
        Integer mPaymentCapture;
        
        public Request(Integer aAmount, String aReceipt, Integer aPaymentCapture) {
            mAmount = aAmount;
            mReceipt = aReceipt;
         	mPaymentCapture = aPaymentCapture;
        }
        
        public String getJSON() {
            return 	'{"amount":' + (mAmount == null ? 0 : mAmount) + ',"currency":"INR","receipt":"' + (mReceipt == null ? '' : mReceipt) + '"' + 
                	',"payment_capture":' + (mPaymentCapture == null ? 0 : mPaymentCapture) + '}';
                	
        }
    }
    
    public class Response {
    	public String id;
    	public String entity;
    	public Decimal amount;
    	public Decimal amount_paid;
    	public Decimal amount_due;
    	public String receipt;
    	public String status;
    	public Integer attempts;
    	public List<String> notes;
    	public Integer created_at;
        public String status_code;
        public String status_message;
        public Error error;
    }
    
    public class Error {
        String code;
        String description;
        String field;
    }
    
    public static Response generateOrderID(Request aRequest) {
        Response lResponse = new Response();
        Application_Settings__c lRZRKey = Application_Settings__c.getValues('RZRPAY_KEY');
        Application_Settings__c lRZRToken = Application_Settings__c.getValues('RZRPAY_TOKEN');
        
        HTTPRequest r = new HTTPRequest();
        r.setHeader('Content-Type', 'application/json');
        r.setEndpoint('https://api.razorpay.com/v1/orders/');
        Blob headerValue = Blob.valueOf(lRZRKey.value__c + ':' + lRZRToken.value__c);
        r.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
        r.setMethod('POST'); 
        r.setTimeout(120000);
        System.debug('^^^ RAW=' + aRequest.getJSON());
        r.setBody(aRequest.getJSON());
        
        try {
            HTTPResponse lHTTPResponse = null;
			
            if(Test.isRunningTest()) {
                lHTTPResponse = new RazorpayMockAPI().respond(null);
            }
            else {
            	lHTTPResponse = new HTTP().send(r);
            }
            
        	lResponse = (Response)JSON.deserialize(lHTTPResponse.getBody(), Response.class);
            System.debug('^^^ RESPONSE=' + lHTTPResponse.getBody());

            lResponse.status_code = '200';
            lResponse.status_message = 'Success';

            if(lResponse.error != null) {
                lResponse.status_code = '401';
                lResponse.status_message = lResponse.error.description;
            }
        }
        catch(Exception e) {
            lResponse.status_code = '500';
            lResponse.status_message = e.getMessage();
        }
        
        return lResponse;
    }
}