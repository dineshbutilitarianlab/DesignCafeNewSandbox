public class PaymentTriggerHandler {
	public static Boolean SKIP_VALIDATIONS = false;
    //Payment Update Method
    public static void handlePaymentBeforeInsert( List<Payment__c> payment) {
        SET<String> mileStoneRecIds = new SET<String>();
        for(Payment__c pymt: payment) {
            mileStoneRecIds.add(pymt.Milestone__c);
            
        }
        MAP<Id,Milestone1_Milestone__c> mapMileStoneRec = new MAP<Id,Milestone1_Milestone__c>([Select id,name,Type__c,EligibleAmountPercentage__c from Milestone1_Milestone__c where id IN: mileStoneRecIds]);
        for( Payment__c objPay : payment){
            if(mapMileStoneRec.containsKey(objPay.Milestone__c) && mapMileStoneRec.get(objPay.Milestone__c).Type__c == 'Customer Onboarding') {
                objPay.Revenue_Milestone_Category__c = '5.00';
            }
            else{
                objPay.Revenue_Milestone_Category__c = string.valueOF( mapMileStoneRec.get(objPay.Milestone__c).EligibleAmountPercentage__c);
                system.debug(objPay);
            }
        }
    }
    
    
    //Payment Update Method
    public static void handlePaymentUpdate( List<Payment__c> payment) {
        for(Payment__c objPay : [SELECT id, Milestone__r.Complete__c FROM Payment__c WHERE id IN:payment]) {
            if(objPay.Milestone__r.Complete__c == true && SKIP_VALIDATIONS == false) {
                objPay.addError('Payment records related to completed Milestones cannot be modified.');
            }
        }
    }
    
    //Payment Delete Method  
    /*public static void handlePaymentDelete( List<Payment__c> payment) {         
        for(Payment__c objPay : payment) {
            if(objPay.Milestone__r.Complete__c == true && SKIP_VALIDATIONS == false) {
                objPay.addError('Payments related to completed Milestones cannot be deleted.');
            }
        }
    }*/
    
    public static void linkpaymentandInvoice( List<Payment__c> payment) {    
        
        Set<Id> milestoneIds = new Set<id>();
        for(Payment__c objPay : payment) {
            milestoneIds.add(objPay.Milestone__c);
        }
        List<Invoice__c> listofinvoices = new List<Invoice__c>([SELECT Id, Milestone__c FROM Invoice__c where Milestone__c IN : milestoneIds]);
        Map<String,String> milestoneVsInvoice= new Map<String,String>();
        
        for(Invoice__c singleInv:listofinvoices){
            milestoneVsInvoice.put(singleInv.Milestone__c,singleInv.Id );
        }
        
        for(Payment__c objPay : payment) {
            if(String.isNotEmpty(objPay.Milestone__c) &&   milestoneVsInvoice.containsKey(objPay.Milestone__c)){
                objPay.Invoice__c=milestoneVsInvoice.get(objPay.Milestone__c);
            }
            
        }
    }
}