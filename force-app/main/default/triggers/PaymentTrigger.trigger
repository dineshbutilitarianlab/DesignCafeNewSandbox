trigger PaymentTrigger on Payment__c (after insert ,before insert, before update, before delete) {

    if(trigger.isbefore && Trigger.isInsert) {
        PaymentTriggerHandler.handlePaymentBeforeInsert(trigger.new);
       PaymentTriggerHandler.linkpaymentandInvoice(Trigger.new);
    }
    if(trigger.isbefore && Trigger.isUpdate) {
        PaymentTriggerHandler.handlePaymentUpdate(trigger.new);
    }
    else if(trigger.isbefore && Trigger.isDelete) {
       // PaymentTriggerHandler.handlePaymentDelete(trigger.old);
    }
}