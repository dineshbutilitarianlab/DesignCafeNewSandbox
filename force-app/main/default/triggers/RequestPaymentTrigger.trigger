trigger RequestPaymentTrigger on Request_Payment__c (after insert,after update,Before delete) {
    
    if(Trigger.isInsert && trigger.isAfter) {
        System.debug('---1--');
        //RequestPaymentHandler.sendRequestPayment(trigger.new[0].id);
        System.debug('---2--');
        //RequestPaymentCreateProject.createProjectRequest(trigger.new[0].id);
        //Cutomer update
        Request_Payment__c rp = [select id,Opportunity__c from Request_Payment__c where id = : trigger.new[0].id ];
        Opportunity opp = [select id,Account.Name from Opportunity Where id=: rp.Opportunity__c limit 1];
        updateaccounttodesignerdashboard.callServer(opp.Account.ID);
    }
    
    if(Trigger.isAfter && trigger.isUpdate) {
        
        if (trigger.new != null && trigger.new[0].Updated_Request__c!=true && trigger.old[0].Status__c == trigger.new[0].Status__c) {
            for(Request_Payment__c reqPay: trigger.new){
                if(reqPay.Request_Id__c != null){
                    //RequestPaymentHandler.updateRequestPayment(reqPay.id);
                     //PaymentRequestsHandler_GraphQL.updatepaymentRequest(reqPay.id);
                   
                }
            }
            
            
        }
        
        
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        if(trigger.old != null){                
            for (Request_Payment__c reqPayOld : trigger.old) {
                if (reqPayOld.Request_Id__c != null  && reqPayOld.Status__c != 'Paid'){
                   //RequestPaymentHandler.deleteRequestPayment(reqPayOld.Request_Id__c);
                    PaymentRequestsHandler_GraphQL.deletepaymentRequest(reqPayOld.Request_Id__c);
                    system.debug('reqPayOld:'+reqPayOld.Request_Id__c);
                  
                }
                else if(reqPayOld.Status__c == 'Paid'){
                    reqPayOld.adderror('Cannot delete a payment request which is paid');
                }
                
            }
        }   
    }
    
}