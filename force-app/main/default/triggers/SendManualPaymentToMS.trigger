trigger SendManualPaymentToMS on Invoice_Payment__c (after insert) {
    if((Trigger.new[0].Mode_of_Receipt__c =='Cash' || Trigger.new[0].Mode_of_Receipt__c =='IMPS/NEFT' || Trigger.new[0].Mode_of_Receipt__c =='Cheque' || Trigger.new[0].Mode_of_Receipt__c =='Credit Card' || Trigger.new[0].Mode_of_Receipt__c =='Debit Card'))
       {
           //SendPaymentDetails.callServer(Trigger.New[0].id);
       }
}