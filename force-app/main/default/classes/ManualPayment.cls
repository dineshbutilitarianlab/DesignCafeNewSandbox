public class ManualPayment {
    @future(callout=true)
    public static void Manualpay(String paymentId){
        system.debug('PaymentId '+paymentId); 
        Payment__c payment = [Select id,Project_Id__c,Project_Name__c,Invoice_Number__c,Payment_Receipt__c,Customer_Phone__c,paymentId__c,amountPaid__c,paymentReceivedDate__c,Transaction_Reference_Number__c,Mode__c from Payment__c where id =: paymentId limit 1];
        PaymentWrapper manualpayment = new PaymentWrapper();
        manualpayment.projectId = payment.Project_Id__c;
        manualpayment.projectName = payment.Project_Name__c;
        manualpayment.invoiceNumber = payment.Invoice_Number__c;
        manualpayment.paymentId = payment.paymentId__c;
        manualpayment.amountPaid = payment.amountPaid__c;
        String inputDate = payment.paymentReceivedDate__c.format();
        manualpayment.paymentReceivedDate = inputDate;
        manualpayment.transactionId = payment.Transaction_Reference_Number__c;
        manualpayment.paymentMode = payment.Mode__c;
        manualpayment.customerPhone = payment.Customer_Phone__c;
        if(payment.Payment_Receipt__c !=null){
            manualpayment.paymentReceipt = payment.Payment_Receipt__c;
        }
        system.debug('Json Serialize : '+JSON.serialize(manualpayment));
        HttpRequest request = new HttpRequest();
        HttpResponse res = new HttpResponse();
        request.setEndpoint('https://api.designcafe.com/pm/captureManualPayment');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(manualpayment);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        if(!Test.isRunningTest()){
            Http http = new Http();
            HttpResponse response = http.send(request);
            Response rd = (response)JSON.deserialize(response.getBody(), response.class);
            System.debug('Response paylink :'+rd);
            Invoice__c inv =[Select id,Name,Invoice_Number__c from Invoice__c where Invoice_Number__c =:manualpayment.invoiceNumber];
            Invoice__c invoice = new Invoice__c();
            inv.id = inv.id;
            inv.Payment_Link__c = rd.data.updatedPaymentLink;
            update inv;
        }
    }
    public class PaymentWrapper{
        @AuraEnabled
        public String projectId{get;set;} 
        @AuraEnabled
        public String projectName{get;set;} 
        @AuraEnabled
        public String invoiceNumber{get;set;} 
        @AuraEnabled
        public String paymentId{get;set;} 
        @AuraEnabled
        public Decimal amountPaid{get;set;} 
        @AuraEnabled
        public String paymentReceivedDate{get;set;}
        @AuraEnabled
        public String transactionId{get;set;} 
        @AuraEnabled
        public String paymentMode{get;set;} 
        @AuraEnabled
        public String customerPhone{get;set;} 
        @AuraEnabled
        public String paymentReceipt{get;set;} 
    }
    Public class response{
        public string statusCode;
        public string code;
        public string message;
        public responsedata data;
    }
    public class responsedata{
        public string updatedPaymentLink;
    }
}