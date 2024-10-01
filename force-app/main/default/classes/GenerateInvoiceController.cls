public class GenerateInvoiceController {
    public class invoiceDataWrap{
        @AuraEnabled
        public String customerName{get;set;} 
        @AuraEnabled
        public String customerEmail{get;set;} 
        @AuraEnabled
        public String customerPhone{get;set;} 
        @AuraEnabled
        public String sfId{get;set;}
        @AuraEnabled
        public double projectModularValue{get;set;}
        @AuraEnabled
        public double projectSiteServicesValue{get;set;}
        @AuraEnabled
        public double projectDecorValue{get;set;}
        @AuraEnabled
        public customerShippingAddressWrap customerShippingAddress{get;set;}
        @AuraEnabled
        public customerBillingAddressWrap customerBillingAddress{get;set;}
        @AuraEnabled
        public designerDetailsWrap designerDetails{get;set;}
        @AuraEnabled
        public salesManagerDetailsWrap salesManagerDetails{get;set;}
        @AuraEnabled
        public String projectID{get;set;} 
        @AuraEnabled
        public String projectName{get;set;} 
        @AuraEnabled
        public Double projectValue{get;set;} 
        @AuraEnabled
        public String projectStatus{get;set;} 
        @AuraEnabled
        public String requestName{get;set;} 
        @AuraEnabled
        public String paymentName{get;set;} 
        @AuraEnabled
        public double amount{get;set;} 
        @AuraEnabled
        public String applicationId{get;set;} 
        @AuraEnabled
        public string invoiceDate{get;set;} 
        @AuraEnabled
        public String experienceCenter{get;set;} 
        @AuraEnabled
        public double milestonePendingDue{get;set;}         
        
        
    }
    public class designerDetailsWrap{
        @AuraEnabled
        public String designerName{get;set;} 
        @AuraEnabled
        public String designerEmail{get;set;} 
    }
    public class salesManagerDetailsWrap{
        @AuraEnabled
        public String salesManagerName{get;set;} 
        @AuraEnabled
        public String salesManagerEmail{get;set;} 
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
    @AuraEnabled
    public static string showbutton(String oppId){
        List<Opportunity_Invoice__c> invList = [select id from Opportunity_Invoice__c where Opportunity__c =: oppId]; 
        if(invList.size() == 0){
            return 'Enabled';
        }
        else{
            return 'Disabled';
        }
    }
    
    @AuraEnabled
    public static void callServer(String oppId){
        system.debug('oppId '+oppId); 
        Opportunity opp = [select id,name,Amount,Modular_Amount_Dis_Incl_GST__c,Site_Services_Amount_Dis_Incl_GST__c,Decor_Amount_Incl_GST__c,Customer_ID__c,Initial_Payment_Amount__c,Account.Name,Microservice_Project_Name__c,Meeting_Venue__c,Design_User_Name__c,DesignerEmail__c,SalesManagerName__c,SalesManagerEmail__c,Account.ShippingAddress,Account.BillingAddress,Account.ShippingPostalCode,Account.BillingPostalCode,Account.ShippingCountry,Account.BillingCountry,Account.ShippingCity,Account.BillingCity,Account.ShippingStreet,Account.BillingStreet,Account.ShippingState,Account.BillingState,Account.PersonEmail,Account.PersonMobilePhone  from Opportunity Where id=: OppId limit 1];
        invoiceDataWrap invoice = new invoiceDataWrap();
        if(opp.Account.Name !=null){
            invoice.customerName = opp.Account.Name;
        }
        if(opp.Account.PersonEmail !=null){
            invoice.customerEmail = opp.Account.PersonEmail;
        }
        if(opp.Account.PersonMobilePhone !=null){
            invoice.customerPhone = opp.Account.PersonMobilePhone;
        }
        if(opp.Customer_ID__c !=null){
            invoice.sfId = opp.Customer_ID__c;
        }
        if(opp.Modular_Amount_Dis_Incl_GST__c !=null){
            invoice.projectModularValue = opp.Modular_Amount_Dis_Incl_GST__c;
        }
        if(opp.Site_Services_Amount_Dis_Incl_GST__c !=null){
            invoice.projectSiteServicesValue = opp.Site_Services_Amount_Dis_Incl_GST__c;
        }
        if(opp.Decor_Amount_Incl_GST__c !=null){
            invoice.projectDecorValue = opp.Decor_Amount_Incl_GST__c;
        }
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
        
        designerDetailsWrap dd = new designerDetailsWrap();
        dd.designerName = opp.Design_User_Name__c;
        dd.designerEmail = opp.DesignerEmail__c;
		invoice.designerDetails = dd;
        
        salesManagerDetailsWrap smd = new salesManagerDetailsWrap();
        smd.salesManagerName = opp.SalesManagerName__c;
        smd.salesManagerEmail = opp.SalesManagerEmail__c;
		invoice.salesManagerDetails = smd;
		
        if(opp.Customer_ID__c !=null){
            invoice.projectID = opp.Customer_ID__c;
        }
        if(opp.Microservice_Project_Name__c !=null){
            invoice.projectName = opp.Microservice_Project_Name__c;
        }
        if(opp.Amount !=null){
            invoice.projectValue = opp.Amount;
        }
        invoice.projectStatus = 'Active';
        invoice.requestName = 'Generate Invoice';
        invoice.paymentName = '5% Supply of interior works';
        if(opp.Initial_Payment_Amount__c !=null){
            invoice.amount = opp.Initial_Payment_Amount__c;
        }
        invoice.applicationId = 'Salesforce';
        Date d = date.today();
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
        System.debug('Date :'+dt);
        invoice.invoiceDate = dt;
        
        
        
        system.debug('invoicedate :'+invoice.invoiceDate);
        if(opp.Meeting_Venue__c !=null){
            invoice.experienceCenter = opp.Meeting_Venue__c;
        }
        if(opp.Initial_Payment_Amount__c !=null){
            invoice.milestonePendingDue = opp.Initial_Payment_Amount__c;
        }
        invoiceDataListWrap  v = new invoiceDataListWrap();
        v.invoiceData = invoice;
        system.debug('Json Serialize : '+JSON.serialize(v));
        String customLabelValue = Label.GenerateInvoice;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customLabelValue);
        request.setTimeout(20000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(v);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('get response :'+response.getBody());
        ResponseData rd = (ResponseData)JSON.deserialize(response.getBody(), ResponseData.class);
        System.debug('Response Data :'+rd);
        //  Opportunity o = [Select id,Name from Opportunity where Customer_ID__c =: rd.data.invoice.projectID];
        Opportunity_Invoice__c inv = new Opportunity_Invoice__c();
        inv.Opportunity__c = opp.id;
        if(rd.data.invoice.paymentLink !=null){
            inv.Payment_Link__c = rd.data.invoice.paymentLink;
        }
        if(rd.data.invoice.paymentName !=null){
            inv.Payment_Name__c = rd.data.invoice.paymentName;
        }
        if(rd.data.invoice.invoiceBreakUp.baseAmount !=null){
            inv.Initial_Amount_Incl_GST__c = rd.data.invoice.invoiceBreakUp.baseAmount;
        }
        if(rd.data.invoice.invoiceBreakUp.SGST !=null){
            inv.SGST__c = double.valueOf(rd.data.invoice.invoiceBreakUp.SGST);
        }
        if(rd.data.invoice.invoiceBreakUp.CGST !=null){
            inv.CGST__c = double.valueOf(rd.data.invoice.invoiceBreakUp.CGST);
        }
        if(rd.data.invoice.invoiceBreakUp.IGST !=null){
            inv.IGST__c = double.valueOf(rd.data.invoice.invoiceBreakUp.IGST);
        }
        if(rd.data.invoice.invoiceBreakUp.totalTaxValue !=null){
            inv.Total_Tax_Value__c = rd.data.invoice.invoiceBreakUp.totalTaxValue;
        }
        if(rd.data.invoice.invoiceBreakUp.totalAmount !=null){
            inv.Amount_Excl_GST__c = rd.data.invoice.invoiceBreakUp.totalAmount;
        }
        if(rd.data.invoice.invoiceDate !=null){
            String todate = rd.data.invoice.invoiceDate;  
            Date dt1 = Date.parse( todate );  
            inv.Invoice_Date__c = Date.valueOf(dt1);
            
        }
        if(rd.data.invoice.invoiceNumber !=null){
            inv.RP_Invoice_Number__c = rd.data.invoice.invoiceNumber;
        }
        if(rd.data.invoice.razorpayInvoiceReceipt !=null){
            inv.RP_Invoice_Receipt__c = rd.data.invoice.razorpayInvoiceReceipt;
        }
        if(rd.data.invoice.paymentLink !=null){
            inv.Payment_Link__c = rd.data.invoice.paymentLink;
        }
        if(rd.data.invoice.invoicePdf !=null){
            inv.Invoice_PDF_Link__c = rd.data.invoice.invoicePdf;
        }
        insert inv;
        System.debug('New Invoice ='+inv.Id);
        System.debug('Response Data'+response.getBody());
        system.debug('request '+request.getBody());
        system.debug('response '+response.getBody());
    }
    
    public class ResponseData {
        public String statusCode;
        public String code;
        public String message;
        public invoicedata data;
    }
    public class invoicedata
    {
        public invoicewrap invoice;
    }
    
    public class invoicewrap {
        public string applicationId;
        public string projectID;
        public string paymentName;
        public invoiceBreakUpwrap invoiceBreakUp;
        public string invoiceDate;
        public string invoiceNumber;
        public string invoicePdf;
        public string razorpayInvoiceReceipt;
        public string paymentLink;
    }
    public class invoiceBreakUpwrap {
        public decimal baseAmount;
        public double SGST;
        public double CGST;
        public double IGST;
        public double totalTaxValue;
        public double totalAmount;
    }
}