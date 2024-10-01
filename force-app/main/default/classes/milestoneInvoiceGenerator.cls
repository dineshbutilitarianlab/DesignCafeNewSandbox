public class milestoneInvoiceGenerator {
    @AuraEnabled 
    public static String showButton(String recId){
        system.debug(recId); 
        Milestone1_Milestone__c ml = [select id,Name from Milestone1_Milestone__c where id =: recId ];
        List<Invoice__c> invList = [select id,Milestone__c,Invoice_Number__c from invoice__c where Milestone__c =: ml.id];
        system.debug(ml.Name);
        if(invList.size() > 0 && (ml.Name == 'Design Finalization' || ml.Name == 'Complete Design Sign-off' || ml.Name == 'Factory Dispatch')){
            return 'Enabled';
        }
        else{
            return 'Disabled';
        }
    }
    @AuraEnabled
    public static void generateInvoice(String recId){
        Milestone1_Milestone__c ml = [select id,Name,EligibleAmount__c,Actual_Amount_Due__c,Milestone_Order__c,Project__c from Milestone1_Milestone__c where id =: recId ];
        Milestone1_Project__c mp = [select id,Opportunity__c,Customer_ID__c,Name,Amount__c,Status__c
                                    from Milestone1_Project__c where id = :ml.Project__c];
        Opportunity opp = [select id,Account.Name,Meeting_Venue__c,Account.ShippingAddress,Account.BillingAddress,Account.ShippingPostalCode,Account.BillingPostalCode,Account.ShippingCountry,
                           Account.BillingCountry,Account.ShippingCity,Account.BillingCity,Account.ShippingStreet,Account.BillingStreet,
                           Account.ShippingState,Account.BillingState,Account.PersonEmail,Account.PersonMobilePhone
                           from Opportunity Where id=: mp.Opportunity__c limit 1];
        Invoice__c invnumber = [select id,Milestone__c,Invoice_Date__c,Invoice_Number__c from invoice__c where Milestone__c =: ml.id];
        
        invoiceDataWrap invoice = new invoiceDataWrap();
        invoice.customerName = opp.Account.Name;
        invoice.customerEmail = opp.Account.PersonEmail;
        invoice.customerPhone = opp.Account.PersonMobilePhone;
        customerShippingAddressWrap cc = new customerShippingAddressWrap();
        cc.country = opp.Account.ShippingCountry;
        cc.street = opp.Account.ShippingStreet;
        cc.city = opp.Account.ShippingCity;
        cc.zipOrPostalCode = opp.Account.ShippingPostalCode;
        cc.shippingState = opp.Account.ShippingState;
        invoice.customerShippingAddress = cc;
        customerBillingAddressWrap cb = new customerBillingAddressWrap();
        cb.country = opp.Account.BillingCountry;
        cb.street = opp.Account.BillingStreet;
        cb.city = opp.Account.BillingCity;
        cb.zipOrPostalCode = opp.Account.BillingPostalCode;
        cb.shippingState = opp.Account.BillingState;
        invoice.customerBillingAddress = cb;
        invoice.projectID = mp.Customer_ID__c;
        invoice.invoiceNumber = invnumber.Invoice_Number__c;
        invoice.projectName = mp.Name;
        invoice.projectValue = mp.Amount__c;
        invoice.projectStatus = mp.Status__c;
        invoice.requestName = 'REGENERATE_INVOICE';
        if(ml.Name == 'Design Finalization'){
            invoice.paymentName = '15% Supply of works';
        }
        else if( ml.Name == 'Complete Design Sign-off' ){
            invoice.paymentName = '35% Supply of works'; 
        }
         else if(ml.Name == 'Factory Dispatch'){
            invoice.paymentName = '45% Supply of works'; 
        }
        
        if(!Test.isRunningTest()){
            invoice.amount = Double.valueOf(ml.Actual_Amount_Due__c.remove('₹'));
        }
        invoice.applicationId = 'Salesforce';
        Date d = invnumber.Invoice_Date__c;
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
        System.debug('Date :'+dt);
        invoice.invoiceDate = dt;
        System.debug('Datecheck :'+invoice.invoiceDate);
        invoice.experienceCenter = opp.Meeting_Venue__c;
        If(!Test.isRunningTest()){
            invoice.milestonePendingDue = Double.valueOf(ml.Actual_Amount_Due__c.remove('₹'));
        }
        
        invoiceDataListWrap  v = new invoiceDataListWrap();
        v.invoiceData = invoice;
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.designcafe.com/pm/generateInvoice');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(v);
        system.debug(jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug(response.getBody());
        ResponseData rd = (ResponseData)JSON.deserialize(response.getBody(), ResponseData.class);
        system.debug(rd.data.invoice.invoiceNumber);
        List<Invoice__c> invo = [select id from Invoice__c where CustomerId__c = :rd.data.invoice.projectID AND Milestone__c =: ml.id];
        Invoice__c inv = new Invoice__c();
        if(invo.size()>0){
            inv.id = invo[0].id;  
        }
        inv.CustomerId__c = rd.data.invoice.projectID;
        inv.Payment_Name__c = rd.data.invoice.paymentName;
        inv.Base_Amount__c = rd.data.invoice.invoiceBreakUp.baseAmount;
        inv.SGST__c  = rd.data.invoice.invoiceBreakUp.SGST;
        inv.CGST__c  = rd.data.invoice.invoiceBreakUp.CGST;
        inv.IGST18__c  = rd.data.invoice.invoiceBreakUp.IGST;
        inv.Total_Tax_Amount__c  = rd.data.invoice.invoiceBreakUp.totalTaxValue;
        inv.Total_Amount__c  = rd.data.invoice.invoiceBreakUp.totalAmount;
        system.debug('i am date '+rd.data.invoice.invoiceDate);
        if(invo.size() == 0){
            String todate = rd.data.invoice.invoiceDate;
            Date dt1 = Date.parse( todate );  
            system.debug(' Parsed Date is ' + dt1 );  
            inv.Invoice_Date__c = Date.valueOf(dt1);
        }
        //  inv.invoice_Date__c = Date.newInstance(Integer.valueOf(dateData[2]), Integer.valueOf(dateData[1]), Integer.valueOf(dateData[0]));
        if(invo.size() == 0){
            inv.Invoice_Number__c = rd.data.invoice.invoiceNumber;
        }
        inv.InvoicePdfLink1__c = rd.data.invoice.invoicePdf;
        inv.Payment_Link__c = rd.data.invoice.paymentLink;
        system.debug('****** '+rd.data.invoice.paymentLink);
        if(invo.size() == 0){
            inv.Milestone__c = ml.id;
        }
        inv.Customer__c = opp.AccountId;
        inv.Amount__c = rd.data.invoice.invoiceBreakUp.totalAmount;
        inv.Project__c = ml.Project__c;
        upsert inv;
        system.debug('i am invoice '+inv.id);
    }
    public class invoiceDataWrap{
        @AuraEnabled
        public String customerName{get;set;} 
        @AuraEnabled
        public String customerEmail{get;set;} 
        @AuraEnabled
        public String customerPhone{get;set;} 
        @AuraEnabled
        public customerShippingAddressWrap customerShippingAddress{get;set;}
        @AuraEnabled
        public customerBillingAddressWrap customerBillingAddress{get;set;}
        @AuraEnabled
        public String projectID{get;set;} 
        @AuraEnabled
        public String projectName{get;set;} 
        @AuraEnabled
        public Double projectValue{get;set;} 
        @AuraEnabled
        public string invoiceNumber{get;set;}
        @AuraEnabled
        public String projectStatus{get;set;} 
        @AuraEnabled
        public String requestName{get;set;} 
        @AuraEnabled
        public String paymentName{get;set;} 
        @AuraEnabled
        public Double amount{get;set;} 
        @AuraEnabled
        public String applicationId{get;set;} 
        @AuraEnabled
        public String invoiceDate{get;set;} 
        @AuraEnabled
        public String experienceCenter{get;set;} 
        @AuraEnabled
        public Double milestonePendingDue{get;set;}         
        
        
    }
    public class customerShippingAddressWrap{
        @AuraEnabled
        public String country{get;set;} 
        @AuraEnabled
        public String street{get;set;} 
        @AuraEnabled
        public String city{get;set;} 
        @AuraEnabled
        public String zipOrPostalCode{get;set;} 
        @AuraEnabled
        public String shippingState{get;set;} 
    }
    public class customerBillingAddressWrap{
        @AuraEnabled
        public String country{get;set;} 
        @AuraEnabled
        public String street{get;set;} 
        @AuraEnabled
        public String city{get;set;} 
        @AuraEnabled
        public String zipOrPostalCode{get;set;} 
        @AuraEnabled
        public String shippingState{get;set;} 
    }
    public class invoiceDataListWrap{
        public invoiceDataWrap invoiceData{get;set;}
    }
    public class ResponseData {
        public String statusCode;
        public String code;
        public String message;
        public invoicedata data;
    }
    public class invoicedata {
        public invoicewrap invoice;
    }
    public class invoicewrap {
        public string applicationId;
        public string projectID;
        public string paymentName;
        public invoiceBreakUpwrap invoiceBreakUp;
        public String invoiceDate;
        public string invoiceNumber;
        public string invoicePdf;
        public string razorpayInvoiceReceipt;
        public string paymentLink;
    }
    public class invoiceBreakUpwrap {
        public decimal baseAmount;
        public decimal SGST;
        public decimal CGST;
        public decimal IGST;
        public decimal totalTaxValue;
        public decimal totalAmount;
    }
    
}