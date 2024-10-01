trigger PaymentReceipt on Invoice_Payment__c (After Update, Before Delete, Before Update) {
    
    Boolean control = Boolean.valueOf(System.Label.IP_Trigger_Control);
    System.debug('PaymentReceipt Trigger');
    System.debug('control ==> ' + control);
    if(control || Test.isRunningTest()){
        //Updating payment confirmation status to draft from rejected on an update of API related field. 
        system.debug('payment trigger');
        if (Trigger.isBefore && Trigger.isUpdate) {
            if (trigger.new != null) {
                for (Invoice_Payment__c IPS : trigger.new) {
                    Invoice_Payment__c oldIP = trigger.OldMap.get(IPS.id);
                    if (((IPS.Payment_confirmation_status__c == 'rejected') && (oldIP.Payment_confirmation_status__c == 'rejected')) && ((IPS.Mode_of_Receipt__c != oldIP.Mode_of_Receipt__c) || (IPS.Date_of_Payment__c != oldIP.Date_of_Payment__c) || (IPS.Modular_value__c != oldIP.Modular_value__c) || (IPS.Site_Service_value__c != oldIP.Site_Service_value__c))) {
                        IPS.Payment_confirmation_status__c = 'draft';
                    }
                }
            }
        }
        //Calling UpdatePaymentReceipt API on invoice payment API related field update.
        if (Trigger.isAfter && Trigger.isUpdate) {
            if (trigger.new != null) {
                for (Invoice_Payment__c IP : trigger.new) {
                    /* Call the Payment reciept API before payment insert*/
                    
                    Invoice_Payment__c oldIP = trigger.OldMap.get(IP.id);
                    System.debug('paymentID__c old =>'+oldIP.paymentID__c);
                    System.debug('paymentID__c new =>'+IP.paymentID__c);
                    if ((IP.paymentID__c == oldIP.paymentID__c) && 
                        ((IP.Mode_of_Receipt__c != oldIP.Mode_of_Receipt__c) || (IP.Date_of_Payment__c != oldIP.Date_of_Payment__c) ||
                         (IP.Modular_value__c != oldIP.Modular_value__c) || (IP.Site_Service_value__c != oldIP.Site_Service_value__c))) {
                             //PaymentReceipt.UpdatePaymentReceipt(IP.Opportunity_Name__c,oldIP.paymentID__c);
                            system.debug('Update paymnt recipt');
                             ManualPaymentHandler_GraphQL.UpdatePaymentReceipts(IP.Opportunity_Name__c,oldIP.paymentID__c);
                         } 
                }   
            }
        }
        //Calling DeletePaymentReceipt API before delete.
        if(Trigger.isbefore && Trigger.isDelete) {
            if(trigger.old != null) {
                System.debug('triggerOld:'+trigger.old);
                for (Invoice_Payment__c IP : trigger.old) {
                    System.debug('paymentID__c =>'+IP.paymentID__c);
                    if (IP.paymentID__c != null) {
                        PaymentReceipt.DeletePaymentReceipt(IP.paymentID__c);
                    }
                }   
            }
        }     
    }
}