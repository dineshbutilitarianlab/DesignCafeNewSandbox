public class QuoteTriggerHelper {
    
    //Quote Create Only When Payment Receipt is Pending
    public static void CheCkPRStatusIsPending(List<Quote> newList) {
        List<Id> opportunityIds = new List<Id>();
        List<Request_Payment__c> requestPaymentList= new List<Request_Payment__c>();
        Map<Id, Boolean> opprtunityAllowQueteCreation = new Map<Id, Boolean>();
        for (Quote quoteRec : newList) {
            opportunityIds.add(quoteRec.OpportunityId);
        }
        
        for (Request_Payment__c rp : [SELECT Id, Opportunity__c, Status__c FROM Request_Payment__c WHERE Opportunity__c IN :opportunityIds ORDER BY CREATEDDATE DESC]) {
            
            if (!opprtunityAllowQueteCreation.containsKey(rp.Opportunity__c)) {
                Boolean isStatusPending = rp.Status__c == 'Pending' ? true: false;
                opprtunityAllowQueteCreation.put(rp.Opportunity__c, isStatusPending);
            }
        }
        for (Quote quoteRec : newList) {
            if (opprtunityAllowQueteCreation.containsKey(quoteRec.OpportunityId)) {
                if (!opprtunityAllowQueteCreation.get(quoteRec.OpportunityId) && !Test.isRunningTest()) {
                    quoteRec.addError('You can not create a new Quote because the request payment not in pending status for the corresponding opportunity.');  
                }
            }
        }
        
    }
    public static void updatePaymentRequest(List<Quote> quoteList, String triggerContext) {
        system.debug('triggerContext => '+triggerContext);
        List<Id> opportunityIds = new List<Id>();
        List<Id> accountIds = new List<Id>();
        List<Request_Payment__c> paymReqList = new List<Request_Payment__c>();
        System.debug('Enter Into updatePaymentRequest');
        for (Quote quoteRecord : quoteList) {
            if(quoteRecord.Status == 'Approved')
            	opportunityIds.add(quoteRecord.OpportunityId);
        }
        
        List<Request_Payment__c> paymReqSIze = new List<Request_Payment__c>();
        paymReqSIze = [SELECT Id FROM Request_Payment__c WHERE Opportunity__c = :quoteList[0].OpportunityId];
        List<opportunity> updateOpportunity = new List<opportunity>();
        System.debug('paymReqSIze ' + paymReqSIze.size());
        if (paymReqSIze.size() == 0) {
            Map<id,Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Id, Name, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Customer_ID__c, AccountId, StageName,
                                                                          Email__c, Quote_Id__c,Designer_Team_Name__c,EC_Name__c,UserId__c, Modular_Milestone_Type__c 
                                                                          FROM Opportunity
                                                                          WHERE Id IN :opportunityIds]);
            
            for (Opportunity opportunityRecord : opportunityMap.values()) {
                if (opportunityRecord.AccountId!= null) {
                    accountIds.add(opportunityRecord.AccountId);
                }
            }
            
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, PersonMobilePhone, ShippingCity, ShippingCountry, ShippingStreet, ShippingState, ShippingPostalCode,
                                                              BillingCity, BillingCountry, BillingStreet, BillingState, BillingPostalCode, PAN__c, Customer_type__c, GST_No__c,
                                                              FirstName, LastName, Phone   
                                                              FROM Account 
                                                              WHERE Id IN :accountIds ]);
            
            
            Decimal modularCost, siteServiceCost = 0;
            for (Quote quoteRecord : quoteList) {
                 Opportunity opportunity = new Opportunity();
                 Account account = new Account();
                if(!(opportunityMap.isEmpty()) && opportunityMap.containsKey(quoteRecord.OpportunityId)){
                    	 opportunity =opportunityMap.get(quoteRecord.OpportunityId);
                    if(!(accountMap.isEmpty()) && accountMap.containsKey(opportunity.AccountId)){
                		 account = accountMap.get(opportunity.AccountId);
               		 }
                }
                
                
                // Decimal requestAmount = getRequestAmount(opportunity);
                //System.debug('requestAmount = > '+requestAmount);
                //if(modularCost > 0){
                String phone = account.phone;
                if (String.isBlank(phone)) {
                    phone = account.PersonMobilePhone;
                }
                Request_Payment__c requestPayment = new Request_Payment__c(
                    //Request_Amount__c = requestAmount,
                    //Description__c = getDescription(opportunity),
                    Opportunity__c = opportunity.Id,
                    Client_ID__c = opportunity.Customer_ID__c,
                    //Category__c = getCategory(opportunity),
                    First_Name__c = account.FirstName,
                    Last_Name__c = account.LastName,
                    Customer_Phone__c = phone,
                    PAN_Card_No__c = account.PAN__c,
                    GST_No__c = account.GST_No__c,
                    Customer_Type__c = account.Customer_type__c,
                    Billing_Street__c = account.BillingStreet,
                    Billing_City__c = account.BillingCity,
                    Billing_Country__c = account.BillingCountry,
                    Billing_State__c = account.BillingState,
                    Billing_zip__c = account.BillingPostalCode,
                    Shipping_Street__c = account.ShippingStreet,
                    Shipping_City__c = account.ShippingCity,
                    Shipping_Country__c = account.ShippingCountry,
                    Shipping_State__c = account.ShippingState,
                    Shipping_Zip__c = account.ShippingPostalCode,
                    //Email__c = opportunity.Email__c,
                    Oppo_Id__c = opportunity.Id,
                    Quote_Id__c = quoteRecord.Id,
                    User_Id__c = opportunity.UserId__c,
                    Team_Name__c = opportunity.Designer_Team_Name__c,
                    EC_Name__c = opportunity.EC_Name__c,
                    Account_ID__c = account.Id
                    
                );
                //}
                paymReqList.add(requestPayment);
            }
            if (paymReqList.size() > 0) {
                System.debug('Entered into queue');
                System.debug('paymReqList => '+paymReqList);
                System.debug('opportunityMap.keySet() => '+opportunityMap.keySet());
                // instantiate a new instance of the Queueable class
                //Commented by muskan jain 14 June for payment request , requested by DD team
                //PaymentRequestQueueable paymentRequest = new PaymentRequestQueueable(paymReqList, opportunityMap.keySet());
                
                for (Opportunity opportunityRecord : opportunityMap.values()) {
                    opportunityRecord.StageName = 'Proposal Sent';
                    opportunityRecord.Proposal_Sent_Date__c = system.today();
                    updateOpportunity.add(opportunityRecord);
                }
                // enqueue the job for processing
                 //Commented by muskan jain 14 June for payment request , requested by DD team
                //ID jobID = System.enqueueJob(paymentRequest);
            }
        }else if(paymReqSIze.size() > 0 && triggerContext == 'afterUpdate'){
            list<id> quoteIds = new list<Id>();
            for (Quote variable : quoteList) {
                quoteIds.add(variable.id);
            }
            //LatestQuoteTriggerController.LatestQuoteUpdateByApex(quoteIds);
        }
        if(updateOpportunity.size() > 0){
            system.debug('updateOpportunity proposal sent');
            	update updateOpportunity;
        }
        
        
    }
    
}