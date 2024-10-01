trigger InvoiceTrigger on Invoice__c (before insert, after insert) {
    if(Trigger.isinsert) {
        if(trigger.isbefore) {
            InvoiceTriggerHandler.createInvoice(trigger.new); 
            InvoiceTriggerHandler.updateCHMandDesignerEmail(trigger.new);
           // InvoiceTriggerHandler.generateVenueWiseInvNum(trigger.new);
        }
        
        if(trigger.isAfter && !System.isBatch()) {
            InvoiceTriggerHandler.updatePaymentLink(trigger.new);            
            InvoiceTriggerHandler.sendEmailWithAttachment(trigger.new[0].id);
        }
    } 
}