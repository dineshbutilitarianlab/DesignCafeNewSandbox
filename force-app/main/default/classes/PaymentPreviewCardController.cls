public class PaymentPreviewCardController {
    public class Payload {
        @AuraEnabled public String status_code = '200';
        @AuraEnabled public String status_message = 'Success';
        @AuraEnabled public String order_id = '';
        @AuraEnabled public PaymentGatewayUtility.InfoForVerification payment_info;
    }
    
    @AuraEnabled
    public static Payload getPaymentInfo(String aStrKey) {
        Payload lPayload = new Payload();
        
        try {
        	lPayload.payment_info = PaymentGatewayUtility.getDetailsForVerification(aStrKey);
        }
        catch(Exception e) {
            lPayload.status_code = '500';
            lPayload.status_message = 'Unable to complete the operation. ' + e.getMessage();
        }
        
        return lPayload;
    }
        
	@AuraEnabled
    public static Payload generateOrderID(String aStrKey) {
        Payload lPayload = new Payload();
        
        try {
        	lPayload.order_id = PaymentGatewayUtility.generateOrderID(aStrKey);
        }
        catch(Exception e) {
            lPayload.status_code = '500';
            lPayload.status_message = 'Unable to complete the operation. ' + e.getMessage();
        }
        
        return lPayload;
    }
    
	@AuraEnabled
    public static Payload saveOrderID(String aStrKey, String aOrderID) {
        Payload lPayload = new Payload();
        
        try {
        	PaymentGatewayUtility.storeOrderID(aStrKey, aOrderID);
        }
        catch(Exception e) {
            lPayload.status_code = '500';
            lPayload.status_message = 'Unable to complete the operation. ' + e.getMessage();
        }
        
        return lPayload;
    }
}