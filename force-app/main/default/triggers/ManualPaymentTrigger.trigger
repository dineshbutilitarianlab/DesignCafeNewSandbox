trigger ManualPaymentTrigger on Payment__c (after insert) {
    if(trigger.isAfter &&  Trigger.isInsert && (Trigger.new[0].Mode__c=='Cash' || Trigger.new[0].Mode__c=='Card' || Trigger.new[0].Mode__c=='IMPS/NEFT' ||Trigger.new[0].Mode__c=='Cheque')){
        ManualPayment.Manualpay(Trigger.new[0].id);
    } 
}