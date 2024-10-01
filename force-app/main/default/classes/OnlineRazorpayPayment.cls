@RestResource(urlMapping='/razorpayment')
global without sharing class OnlineRazorpayPayment {
    
    @HttpPost
    global static ResponseBody PayData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        ResponseBody response = new ResponseBody();
        Params razorpayment = (Params)JSON.deserialize(req.requestBody.toString(),Params.class);
        Invoice__c i = [Select id,Milestone__c from Invoice__c where Invoice_Number__c =:razorpayment.InvoiceNumber];
        Payment__c P = new Payment__c();
		p.amountPaid__c = razorpayment.ReceiptAmount;
		p.InvoiceName__c = razorpayment.InvoiceName;
		p.paymentReceivedDate__c = system.today();
		p.TransactionID__c = razorpayment.TransactionID;
		p.Mode__c = razorpayment.PaymentMode;
        p.InvoiceName__c = razorpayment.InvoiceName;
        p.Invoice__c = i.id;
        p.Milestone__c = i.Milestone__c;
        p.Amount__c = razorpayment.ReceiptAmount;
		
        insert p;      
        response.StatusCode = '200';
        response.status = 'Success';
        response.message = 'Payment Done';
        response.recordId = p.id;
    
       //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(),'/razorpayment', req.requestBody.toString(), Response.message, 'in');
        return response;
    }
	global class ResponseBody {
        String StatusCode;
        String status;
        String message;
        String recordId;
    } 
    
    
    global class Params {
        public string OpportunityId;
        public Double ReceiptAmount;
        public String InvoiceName;
        public string InvoiceNumber;
        public string paymentReceivedDate;
        public string TransactionID;
        public string PaymentMode;
        public string PaymentReceipt;
    }
    
}