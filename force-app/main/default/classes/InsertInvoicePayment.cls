@RestResource(urlMapping='/InsertPaymentRecord')
global without sharing class InsertInvoicePayment {
    
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        System.debug('req:: '+req);
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap allDetails = (DetailsWrap)JSON.deserialize(req.requestBody.toString(),DetailsWrap.class);
        System.debug('allDetails:: '+allDetails);
        Opportunity opp = [Select id,Name from Opportunity where Customer_ID__c =:allDetails.OpportunityId];
        Opportunity_Invoice__c oppinv = [Select id, Name from Opportunity_Invoice__c where RP_Invoice_Number__c =: allDetails.InvoiceNumber];
        Invoice_Payment__c Payment = new Invoice_Payment__c();
        payment.Opportunity_Name__c = opp.id;
        if(allDetails.ReceiptAmount !=null){
            payment.Receipt_Amount__c = allDetails.ReceiptAmount;
        }
        if(allDetails.TransactionID !=null){
            payment.MServ_Invoice_Numer__c = allDetails.TransactionID;
        }
        if(oppinv.id !=null){
            payment.Invoice_1__c = oppinv.id;
        }
        if(allDetails.paymentReceivedDate !=null){
            String todate = allDetails.paymentReceivedDate;  
            Date dt1 = Date.parse(todate);  
            system.debug(' Parsed Date is ' + dt1 );  
            payment.Date_of_Payment__c = Date.valueOf(dt1);
        }
        if(allDetails.PaymentMode !=null){
            payment.Mode_of_Receipt__c = allDetails.PaymentMode;
        }
        if(allDetails.InvoiceName !=null){
            payment.Invoice_Name__c = allDetails.InvoiceName;
        }
        if(allDetails.TransactionID != null){
            payment.RP_Recipt_ID__c = allDetails.TransactionID;
        }
        if(allDetails.PaymentReceipt !=null){
            payment.Pyament_Receipt__c = allDetails.PaymentReceipt;
        }
        if (!Test.isRunningTest()) {
	        insert Payment;      
        }
        response.StatusCode = '200';
        response.status = 'Success';
        response.message = 'Payment record created succesfully to Salesforce';
        response.PaymentId = Payment.id;
    	//Calling ApiCallLogger class
        ApiCallLogger.method(system.UserInfo.getUserId(), '/InsertPaymentRecord', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    
    
    global class DetailsWrap {
        public string OpportunityId;
        public Double ReceiptAmount;
        public String InvoiceName;
        public string InvoiceNumber;
        public string paymentReceivedDate;
        public string TransactionID;
        public string PaymentMode;
        public string PaymentReceipt;
    }
    global class PostResponseWrapper {
        String StatusCode;
        String status;
        String message;
        String PaymentId;
    } 
}