public class InvoiceTriggerHandler {
    public static void createInvoice(List<Invoice__c> invoiceList){
        for(Invoice__c invObj: invoiceList) {
            if(invObj.Total_Amount__c != null && invObj.Total_Tax_Amount__c != null) {
                Long n = invObj.Total_Amount__c.longValue();
                Long n1 = invObj.Total_Tax_Amount__c.longValue();
                invObj.Amount_s__c = AmountInWords.inWords(n);
                invObj.Tax_Amount__c = AmountInWords.inWords(n1);
            }
        }
    }
    
    public static void updatePaymentLink(Invoice__c [] newRecs) {
        Invoice__c [] lRecsForUpdation = new List<Invoice__c>();
        
        for(Invoice__c invObj : newRecs) {
            lRecsForUpdation.add(new Invoice__c(id=invObj.id, Payment_Link__c = PaymentGatewayUtility.getPaymentLink(invObj.id)));
        }
        
        update lRecsForUpdation;
    }
    
    @Future(Callout=true)
    public static void sendEmailWithAttachment(String listofInvoiceHeader) {
        Invoice__c lInvoice = [SELECT id, Customer__r.PersonEmail, Customer__r.PersonContactId,CHM_Email__c,Designer_Email__c FROM Invoice__c WHERE id =:listofInvoiceHeader];
        String [] ccAddresses = Label.Invoice_Email_CC_List.split(',');
             if(String.isNotEmpty(lInvoice.Designer_Email__c) && String.isNotBlank(lInvoice.Designer_Email__c)  && String.isNotEmpty(lInvoice.CHM_Email__c) && String.isNotBlank(lInvoice.CHM_Email__c) ){
            
            ccAddresses.add(lInvoice.Designer_Email__c);
            ccAddresses.add(lInvoice.CHM_Email__c);
        }
        String [] bccAddresses = Label.Invoice_Email_BCC_List.split(',');
        
        if(String.isNotBlank(lInvoice.Customer__r.PersonEmail)) {
            EmailTemplate tpl = (EmailTemplate)[SELECT Id FROM EmailTemplate WHERE DeveloperName = 'DC_Invoice_Copy_to_Customer_Template' LIMIT 1];
            
            PageReference pref= page.Showing_Invoice_Details;
            pref.getParameters().put('id', listofInvoiceHeader);
            pref.setRedirect(true);
            Blob body = blob.valueOf('Unit.Test');
            
            try {
                if(!Test.isRunningTest()) {
                    body = pref.getContentAsPDF();
                }
            }
            catch(VisualforceException e) {
                return;
            }
            
          //  OrgWideEmailAddress [] lOrgWideAddresses = [SELECT id, Address FROM OrgWideEmailAddress WHERE DisplayName='No Reply']; 
            OrgWideEmailAddress [] lOrgWideAddresses = [SELECT id,DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName='Design cafe'];
            Attachment attachment = new Attachment();
            attachment.Body = body;
            attachment.Name = Datetime.now().format('yyyy-MM-dd HH:mm') + ' ' + 'InvoicePayment' + '.pdf';
            attachment.IsPrivate = false;
            attachment.ParentId = listofInvoiceHeader;
            insert attachment;
            
            Messaging.SingleEmailMessage semail= new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach= new Messaging.EmailFileAttachment();
            attach.setFileName('Invoice.pdf');
            attach.setBody(body);
            semail.setTemplateId(tpl.id);
            semail.setTargetObjectID(lInvoice.Customer__r.PersonContactId);
            semail.setWhatID(lInvoice.id);
            
            if(ccAddresses.size() > 0) {
            	semail.setCCAddresses(ccAddresses);
            }
            
            if(bccAddresses.size() > 0) {
            	semail.setBCCAddresses(bccAddresses);
            }
            
            semail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
            
            if(lOrgWideAddresses.size() > 0) {
                semail.setOrgWideEmailAddressId(lOrgWideAddresses[0].id);
            }
            else {
                semail.setSenderDisplayName('Design Cafe (no-reply)');
            }

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }
    }
    public static void updateCHMandDesignerEmail(List<Invoice__c> listofinvoices){
        system.debug('inside chm insert'+listofinvoices);
        set<Id> Projectids = new set<Id>();
        for(Invoice__c invoice : listofinvoices){
            if(invoice != Null){
                Projectids.add(invoice.Project__c); 
            }
        }
    system.debug('projectids-->>'+Projectids);
        map<Id, Milestone1_project__c> mapofproject = new map<Id, Milestone1_project__c>([select id,CHM__c ,Designer__r.email, CHM__r.email, CHM__r.name from Milestone1_project__c where id IN : Projectids]);
      for(Invoice__c singleinvoice : listofinvoices){
            system.debug('INSIDE FOR');
            if(singleinvoice.Project__c !=Null && mapofproject.containsKey(singleinvoice.Project__c) && mapofproject.get(singleinvoice.Project__c).CHM__r.email != Null && mapofproject.get(singleinvoice.Project__c).Designer__r.email != Null ){
                system.debug('INSIDE IF');
                singleinvoice.CHM_Email__c = mapofproject.get(singleinvoice.Project__c).CHM__r.email;
                singleinvoice.Designer_Email__c  = mapofproject.get(singleinvoice.Project__c).Designer__r.email;
            }
        }
    }
}