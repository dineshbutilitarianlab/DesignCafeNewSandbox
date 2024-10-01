public class PaymentPageRedirectionController {
    public String paymentPageURL {get;set;}
    
    public PaymentPageRedirectionController() {
        try {
        	paymentPageURL = PaymentGatewayUtility.getPaymentLink(ApexPages.CurrentPage().getparameters().get('id'));
        }
        catch(Exception e) {
            System.debug('^^^ e=' + e);
        }
    }
}