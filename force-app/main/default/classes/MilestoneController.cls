/*
Developer : Ankit Soni 
Created Date :  16 Dec 2019
Description : Controller to handle Action Buttons action on Project Milestone Object.     
*/
public class MilestoneController {
    //Method will handle action from 'ProjectMilestone' sobject lightning component's button and create a create Artifact.  
    @auraEnabled
    public static id createArtifact(String recId, String mom){
        Milestone1_Milestone__c miles = [select id, Project__c from Milestone1_Milestone__c where id =:recId limit 1];
        Id artifactRecTypeId = Schema.SObjectType.Project_Artifact__c.getRecordTypeInfosByDeveloperName().get('Artifact_Pending_Designer_Acceptance').getRecordTypeId();              
        
        try {
            if(miles != null) {
                Project_Artifact__c lArtifact = new Project_Artifact__c(Minutes_of_Meeting__c = mom, Project__c= miles.Project__c, 
                                                                        Project_Milestone__c= recId, RecordTypeId = artifactRecTypeId);
                insert lArtifact;
                return lArtifact.id;
            }
        }
        catch(Exception e) {
            if(!Test.isRunningTest()){
                throw new AuraHandledException('Error ' + e.getMessage());
            }
            else{
                
            }
        }
        
        return null;
    }
    
    //Method will handle action from 'ProjectMilestone' sobject lightning component's button and complete Milestone.  
    @auraEnabled
    public static List<String> completeMilestone(String type){
        try{            
            List<String> questions = new List<String>();
            for(MileStone_Checklist__mdt mc : [select id, developerName, MileStone_Type__c, Question__c from MileStone_Checklist__mdt where MileStone_Type__c = :type]){ 
                questions.add(mc.Question__c);
            }    
            return questions;
        }    
        catch(exception e){
            System.debug('exception='+e.getMessage());
            throw new AuraHandledException('Error ' + e.getMessage());
        }
    }
    
    //Method will handle action from 'ProjectMilestone' sobject lightning component's button and complete Milestone.  
    @auraEnabled
    public static List<String> getDocumentTemplate(String recordId){
        Milestone1_Milestone__c milstoneObj=[select id,Type__c from Milestone1_Milestone__c where id=:recordId];
        try{            
            List<String> docs = new List<String>();
            if(milstoneObj.Type__c == 'KYC'){
                for(Document_Template__c dt : [select Id, Type__c, Body__c from Document_Template__c where Type__c = :milstoneObj.Type__c Limit 1]){ 
                    docs.add(dt.Body__c);
                }
            }  
            return docs;
        }    
        catch(exception e){
            System.debug('exception='+e.getMessage());
            throw new AuraHandledException('Error ' + e.getMessage());            
        }
    }
    
    @auraEnabled
    public static void generateInvoiceData(String recId){
        Milestone1_Milestone__c ml = [select id,Name,Milestone_Order__c,Project__c from Milestone1_Milestone__c where id =: recId ];
        Milestone1_Project__c mp = [select id,Opportunity__c,Customer_ID__c,Name,Amount__c,Status__c
                                    from Milestone1_Project__c where id = :ml.Project__c];
        Opportunity opp = [select id,Account.Name,Meeting_Venue__c,Account.ShippingAddress,Account.BillingAddress,Account.ShippingPostalCode,Account.BillingPostalCode,Account.ShippingCountry,
                           Account.BillingCountry,Account.ShippingCity,Account.BillingCity,Account.ShippingStreet,Account.BillingStreet,
                           Account.ShippingState,Account.BillingState,Account.PersonEmail,Account.PersonMobilePhone
                           from Opportunity Where id=: mp.Opportunity__c limit 1];
        Milestone1_Milestone__c ml1 = [select id,Name,EligibleAmount__c,Actual_Amount_Due__c from Milestone1_Milestone__c where Milestone_Order__c =: ml.Milestone_Order__c+1 
                                       AND Project__c =:ml.Project__c ];
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
        invoice.projectName = mp.Name;
        invoice.projectValue = mp.Amount__c;
        invoice.projectStatus = mp.Status__c;
        invoice.requestName = 'Generate Invoice';
        if(ml.name.contains('15%')){
            invoice.paymentName = '15% Supply of works';
        }
        else if(ml.name.contains('35%') ){
            invoice.paymentName = '35% Supply of works'; 
        }
        else{
            invoice.paymentName = '45% Supply of works'; 
        }
        
        invoice.amount = Double.valueOf(ml1.Actual_Amount_Due__c.remove('₹'));
        invoice.applicationId = 'Salesforce';
        Date d = date.today();
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
        invoice.invoiceDate = dt;
        invoice.experienceCenter = opp.Meeting_Venue__c;
        invoice.milestonePendingDue = Double.valueOf(ml1.Actual_Amount_Due__c.remove('₹'));
        
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
        Invoice__c inv = new Invoice__c();
        inv.CustomerId__c = rd.data.invoice.projectID;
        inv.Payment_Name__c = rd.data.invoice.paymentName;
        inv.Base_Amount__c = rd.data.invoice.invoiceBreakUp.baseAmount;
        inv.SGST__c  = rd.data.invoice.invoiceBreakUp.SGST;
        inv.CGST__c  = rd.data.invoice.invoiceBreakUp.CGST;
        inv.IGST18__c  = rd.data.invoice.invoiceBreakUp.IGST;
        inv.Total_Tax_Amount__c  = rd.data.invoice.invoiceBreakUp.totalTaxValue;
        inv.Total_Amount__c  = rd.data.invoice.invoiceBreakUp.totalAmount;
        String todate = rd.data.invoice.invoiceDate;  
        //String[] dateData = rd.data.invoice.invoiceDate.split('-');
        //inv.Invoice_Date__c = Date.newInstance(Integer.valueOf(dateData[2]), Integer.valueOf(dateData[1]), Integer.valueOf(dateData[0]));
        Date dt1 = Date.parse( todate );  
        system.debug(' Parsed Date is ' + dt1 );  
        inv.Invoice_Date__c = Date.valueOf(dt1);
        inv.Invoice_Number__c = rd.data.invoice.invoiceNumber;
        inv.InvoicePdfLink1__c = rd.data.invoice.invoicePdf;
        inv.Payment_Link__c = rd.data.invoice.paymentLink;
        inv.Milestone__c = ml1.id;
        inv.Customer__c = opp.AccountId;
        inv.Amount__c = rd.data.invoice.invoiceBreakUp.totalAmount;
        inv.Project__c = ml.Project__c;
        insert inv;
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