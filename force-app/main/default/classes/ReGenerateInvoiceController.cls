public class ReGenerateInvoiceController {
    public class invoiceDataWrap{
        @AuraEnabled
        public String customerName{get;set;} 
        @AuraEnabled
        public String customerEmail{get;set;} 
        @AuraEnabled
        public String customerPhone{get;set;} 
      /*  @AuraEnabled
        public String sfId{get;set;}*/
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
        public String invoiceNumber{get;set;}
       /* @AuraEnabled
        public String extraPayments{get;set;}
        @AuraEnabled
        public Boolean isRegenerated{get;set;}*/
        @AuraEnabled
        public Double amount{get;set;} 
        @AuraEnabled
        public String applicationId{get;set;} 
        @AuraEnabled
        public string invoiceDate{get;set;} 
        @AuraEnabled
        public String experienceCenter{get;set;} 
        @AuraEnabled
        public decimal milestonePendingDue{get;set;}  
        @AuraEnabled
        public designerDetailsWrap designerDetails{get;set;}  
        @AuraEnabled
        public salesManagerDetailsWrap salesManagerDetails{get;set;}
        
        
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
    public class designerDetailsWrap{
        @AuraEnabled
        public string designerName{get;set;}
        @AuraEnabled
        public string designerEmail{get;set;}
    }
    public class salesManagerDetailsWrap{
        @AuraEnabled
        public string salesManagerName{get;set;}
        @AuraEnabled
        public string salesManagerEmail{get;set;}
    }
    public class invoiceDataListWrap{
        public invoiceDataWrap invoiceData{get;set;}
    }
    @AuraEnabled
    public static void callServer(String oppId){
        system.debug('oppId '+oppId); 
        Opportunity opp = [select id,name,Amount,Modular_Amount_Dis_Incl_GST__c,Site_Services_Amount_Dis_Incl_GST__c,Decor_Amount_Incl_GST__c,Customer_ID__c,Initial_Payment_Amount__c,Account.Name,Microservice_Project_Name__c,Meeting_Venue__c,Design_User_Name__c,DesignerEmail__c,SalesManagerName__c,SalesManagerEmail__c,Account.ShippingAddress,Account.BillingAddress,Account.ShippingPostalCode,Account.BillingPostalCode,Account.ShippingCountry,Account.BillingCountry,Account.ShippingCity,Account.BillingCity,Account.ShippingStreet,Account.BillingStreet,Account.ShippingState,Account.BillingState,Account.PersonEmail,Account.PersonMobilePhone  from Opportunity Where id=: OppId limit 1];
        Opportunity_Invoice__c oppinv = [Select id,RP_Invoice_Number__c,Invoice_Date__c from Opportunity_Invoice__c where Opportunity__c  =: OppId limit 1];
        System.debug('oppinv id'+oppinv);
        invoiceDataWrap invoice = new invoiceDataWrap();
        invoice.customerName = opp.Account.Name;
        if(opp.Account.PersonEmail !=null){
        invoice.customerEmail = opp.Account.PersonEmail;
            system.debug('customerEmail'+invoice.customerEmail);
        }
        if(opp.Account.PersonMobilePhone !=null){
        invoice.customerPhone = opp.Account.PersonMobilePhone;
            system.debug('customerPhone'+invoice.customerPhone);
        } 
        /* if(opp.Customer_ID__c !=null){
            invoice.sfId = opp.Customer_ID__c;
             system.debug('sfId'+invoice.sfId);
        }*/
        if(opp.Modular_Amount_Dis_Incl_GST__c !=null){
            invoice.projectModularValue = opp.Modular_Amount_Dis_Incl_GST__c;
            system.debug('projectModularValue'+invoice.projectModularValue);
        }
        if(opp.Site_Services_Amount_Dis_Incl_GST__c !=null){
            invoice.projectSiteServicesValue = opp.Site_Services_Amount_Dis_Incl_GST__c;
            system.debug('projectSiteServicesValue'+invoice.projectSiteServicesValue);
        }
        if(opp.Decor_Amount_Incl_GST__c !=null){
            invoice.projectDecorValue = opp.Decor_Amount_Incl_GST__c;
            system.debug('projectDecorValue'+invoice.projectDecorValue);
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
  
        if(opp.Customer_ID__c !=null){
        invoice.projectID = opp.Customer_ID__c;
         system.debug('projectID'+invoice.projectID);   
        }
        if(opp.Microservice_Project_Name__c !=null){
        invoice.projectName = opp.Microservice_Project_Name__c;
            system.debug('projectName'+invoice.projectName);
        }
        if(opp.Amount !=null){
        invoice.projectValue = opp.Amount;
            system.debug('projectValue'+invoice.projectValue);
        }
        designerDetailsWrap dd = new designerDetailsWrap();
        dd.designerName = opp.Design_User_Name__c;
        dd.designerEmail = opp.DesignerEmail__c;
           invoice.designerDetails = dd;
        system.debug('designerDetails'+invoice.designerDetails);
        
        salesManagerDetailsWrap smd = new salesManagerDetailsWrap();
        smd.salesManagerName = opp.SalesManagerName__c;
        smd.salesManagerEmail = opp.SalesManagerEmail__c;
         invoice.salesManagerDetails = smd;
        system.debug('salesManagerDetails'+invoice.salesManagerDetails);
        
        invoice.projectStatus = 'Active';
        invoice.requestName = 'REGENERATE_INVOICE';
        invoice.paymentName = '5% Supply of interior works';
        
        if(oppinv.RP_Invoice_Number__c !=null){
        invoice.invoiceNumber = oppinv.RP_Invoice_Number__c;
        }
       /* if(oppinv.Extra_Payment__c !=null){
        invoice.extraPayments = oppinv.Extra_Payment__c;
            system.debug('extraPayments'+invoice.extraPayments);
        }
        if(oppinv.Is_Regenerated__c !=null){
        invoice.isRegenerated = oppinv.Is_Regenerated__c;
         system.debug('isRegenerated'+invoice.isRegenerated);
        }*/
        if(opp.Initial_Payment_Amount__c !=null){
        invoice.amount = opp.Initial_Payment_Amount__c;
            system.debug('amount'+invoice.amount);
        }
        invoice.applicationId = 'Salesforce';
        Date d = oppinv.Invoice_Date__c;
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
        System.debug('Date :'+dt);
        invoice.invoiceDate = dt;
      //  invoice.invoiceDate = oppinv.Invoice_Date__c;
        if(opp.Meeting_Venue__c !=null){
        invoice.experienceCenter = opp.Meeting_Venue__c;
            system.debug('experienceCenter'+invoice.experienceCenter);
        }
        if(opp.Initial_Payment_Amount__c !=null){
        invoice.milestonePendingDue = opp.Initial_Payment_Amount__c; 
            system.debug('milestonePendingDue'+invoice.milestonePendingDue);
        }
        invoiceDataListWrap  v = new invoiceDataListWrap();
        v.invoiceData = invoice;
        system.debug(JSON.serialize(v));
        String customLabelValue = Label.ReGenerateInvoice;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customLabelValue);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(v);
        system.debug(jsonBody);
        request.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('get response :'+response.getBody());
        system.debug('get responsestatuscode :'+response.getStatusCode());
        ResponseData rd = (ResponseData)JSON.deserialize(response.getBody(), ResponseData.class);
        
        
        List<Opportunity_Invoice__c> checkinvoice = [Select id,Opportunity__c from Opportunity_Invoice__c where Opportunity__c =: opp.id];
        if(checkinvoice.size() != 0){
            Opportunity_Invoice__c inv = new Opportunity_Invoice__c();
            inv.Id = checkinvoice[0].id;
            if(rd.data.invoice.paymentLink !=null){
            inv.Payment_Link__c = rd.data.invoice.paymentLink;
                system.debug('Payment_Link__c'+inv.Payment_Link__c);
            }
            if(rd.data.invoice.paymentName !=null){
            inv.Payment_Name__c = rd.data.invoice.paymentName;
                system.debug('Payment_Name__c'+inv.Payment_Name__c);
            }
            if(rd.data.invoice.invoiceBreakUp.baseAmount !=null){
            inv.Initial_Amount_Incl_GST__c = rd.data.invoice.invoiceBreakUp.baseAmount;
                system.debug('Initial_Amount_Incl_GST__c'+inv.Initial_Amount_Incl_GST__c);
            }
            if(rd.data.invoice.invoiceBreakUp.SGST !=null){
            inv.SGST__c = rd.data.invoice.invoiceBreakUp.SGST;
                system.debug('SGST__c'+inv.SGST__c);
            }
            if(rd.data.invoice.invoiceBreakUp.CGST !=null){
            inv.CGST__c = rd.data.invoice.invoiceBreakUp.CGST;
                system.debug('CGST__c'+inv.CGST__c);
            }
            if(rd.data.invoice.invoiceBreakUp.IGST !=null){
            inv.IGST__c = rd.data.invoice.invoiceBreakUp.IGST;
                system.debug('IGST__c'+inv.IGST__c);
            }
            if(rd.data.invoice.invoiceBreakUp.totalTaxValue !=null){
            inv.Total_Tax_Value__c = rd.data.invoice.invoiceBreakUp.totalTaxValue;
                system.debug('Total_Tax_Value__c'+inv.Total_Tax_Value__c);
            }
            if(rd.data.invoice.invoiceBreakUp.totalAmount !=null){
            inv.Amount_Excl_GST__c = rd.data.invoice.invoiceBreakUp.totalAmount;
                system.debug('Amount_Excl_GST__c'+inv.Amount_Excl_GST__c);
            }
            inv.Invoice_Date__c = System.today();
            String todate = rd.data.invoice.invoiceDate;  
            Date dt1 = Date.parse( todate );  
            system.debug(' Parsed Date is ' + dt1 );  
            inv.Invoice_Date__c = Date.valueOf(dt1);
            if(rd.data.invoice.invoiceNumber !=null){
            inv.RP_Invoice_Number__c = rd.data.invoice.invoiceNumber;
                system.debug('RP_Invoice_Number__c'+inv.RP_Invoice_Number__c);
            }
            if(rd.data.invoice.razorpayInvoiceReceipt !=null){
            inv.RP_Invoice_Receipt__c = rd.data.invoice.razorpayInvoiceReceipt;
                system.debug('RP_Invoice_Receipt__c'+inv.RP_Invoice_Receipt__c);
            }
            if(rd.data.invoice.paymentLink !=null){
            inv.Payment_Link__c = rd.data.invoice.paymentLink;
                system.debug('Payment_Link__c'+inv.Payment_Link__c);
            }
            if(rd.data.invoice.invoicePdf !=null){
            inv.Invoice_PDF_Link__c = rd.data.invoice.invoicePdf;
                system.debug('Invoice_PDF_Link__c'+inv.Invoice_PDF_Link__c);
            }
            update inv;
            System.debug('New Invoice ='+inv.Id);
            System.debug('Response Data'+response.getBody());
            system.debug('request '+request.getBody());
            system.debug('response '+response.getBody());
        }
   
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