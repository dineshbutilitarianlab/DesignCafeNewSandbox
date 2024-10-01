public without sharing class InvoicePdfController{
    public List<WrapperInvoice> wrapInvoicetList {get; set;}
    public string customLabelValue{get;set;}
    
    public InvoicePdfController( ApexPages.StandardController controller) {
        String invid = ApexPages.currentPage().getParameters().get('id');
        wrapInvoicetList=new List<WrapperInvoice>();
        
		Invoice__c inv = [SELECT Id, Project__r.Region__c, Name, Amount__c, CGST__c, Customer__c, Due_Date__c, Customer__r.name, 
                          Customer__r.PersonEmail, Customer__r.GST_No__c, Customer__r.BillingStreet, Customer__r.BillingCity, 
                          Customer__r.BillingState, Customer__r.BillingPostalCode, Customer__r.BillingCountry, Invoice_Date__c,
                          Milestone__c, Opportunity__c, Project__c, Project_Name__c, SGST__c, Shipping_Charges__c, Terms__c, Total_Amount__c,
                          Amount_s__c, Total_Tax_Amount__c, Tax_Amount__c, Milestone__r.EligibleAmountPercentage__c 
                          FROM Invoice__c WHERE id=:invid];
        InvoicePDF__c invPdfCustomSetting = InvoicePDF__c.getValues(inv.Project__r.Region__c);
        wrapInvoicetList.add(new WrapperInvoice(inv, invPdfCustomSetting));
    }
    
    public class WrapperInvoice {
        public Invoice__c inv {get; set;}
        public InvoicePDF__c invPdfCustomSettingObj {get; set;}
        public String milestonePercentage {get;set;}
        
        public WrapperInvoice(Invoice__c invObj,InvoicePDF__c invPdfCustomSetting) {
            inv = invObj;
            milestonePercentage = String.valueOf(inv.Milestone__r.EligibleAmountPercentage__c);
            invPdfCustomSettingObj = invPdfCustomSetting;
        }
    }
}