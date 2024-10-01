trigger QuoteTrigger on Quote (before Insert, before Update, after insert, after update) {
    Set<String> oppIds = new Set<String>();
    for (Quote q : Trigger.New) {
        oppIds.add(q.opportunityId);  
    }

   
    
    Set<String> OppIdsWithError = new Set<String>();

    // Don't allow add/edit quote if invoice is already generated
    if ((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore)) {
        List<Opportunity_Invoice__c> invList = [Select Id,Name,Opportunity__c From Opportunity_Invoice__c Where Opportunity__c IN : oppIds];
        // To Bypass the validation.
        List<Opportunity> oppList = [Select Id, Bypass_Validation_Rules__c  From Opportunity Where Id IN : oppIds];
        map<String,Boolean> ValidationBypassMap = new map<String,Boolean>();
        for (Opportunity opp : oppList) {
            ValidationBypassMap.put(opp.Id, opp.Bypass_Validation_Rules__c);
        }
        // Create the list of "erroneous" Opportunity IDs (those with invoices)
        for (Integer i = 0; i < invList.size(); i++) { 
            OppIdsWithError.add(invList[i].Opportunity__c);
        }
                
        for (Quote qt:Trigger.New) {
            if ((OppIdsWithError.contains(qt.opportunityId)) && (ValidationBypassMap.get(qt.opportunityId) == false)) {
                qt.addError('You can not Add/Edit a new Quote once the Invoice is generated for the corresponding opportunity.');                
            }
        }
    }
    
    // To mark the newly inserted quote as latest and unmark any previous quote if any
    
  /*  if (Trigger.isInsert && Trigger.isAfter) {
        List<Quote> invList = [SELECT Id, OpportunityId, Latest_quote__c 
                                 FROM Quote WHERE OpportunityId IN :oppIds ORDER BY CreatedDate DESC];
        
        for (Integer i=1; i < invList.size(); i++) { 
            invList[i].Latest_quote__c = false; // uncheck all from being latest
        }
        invList[0].Latest_quote__c = true; // check only the newly inserted quote as latest
        update invList;
        
        // Latest Quote update ---> Start
        LatestQuoteTriggerController.LatestQuoteUpdate(Trigger.New[0].Id);
        // Latest Quote update ---> End

    }  */
    

    
            //Once invoice is generated, can not Create the Quote 
            /*if(Trigger.isBefore && Trigger.isInsert){
        QuoteUpdateHandler.quoteCreateError(Trigger.New);
        } 

        //Once quote is generated can not edit the Quote 
        if(Trigger.isBefore && Trigger.isUpdate){
        QuoteUpdateHandler.dispErrorForInv(Trigger.New);
        } */
    
    if(Trigger.isBefore && Trigger.isUpdate){
         for (quote qt:trigger.new) {
                   
                    quote oldQuote = trigger.OldMap.get(qt.id);
                    /* Call the updateQuote API when Discounts and P&M Fee are updated. */
                 
                    if((qt.Modular_Discount__c != oldQuote.Modular_Discount__c) && (qt.Site_Services_Discount__c != oldQuote.Site_Services_Discount__c)){
                        qt.Modular_Or_Site_Service_Changes__c = 'Both';
                    }else if(qt.Modular_Discount__c != oldQuote.Modular_Discount__c){
                        qt.Modular_Or_Site_Service_Changes__c = 'Modular';
                    }else if(qt.Site_Services_Discount__c != oldQuote.Site_Services_Discount__c){
                        qt.Modular_Or_Site_Service_Changes__c = 'Site Services';
                    }
                    //updateQuote_graphQL call
                    /*if ((qt.Modular_Discount__c != oldQuote.Modular_Discount__c) ||
                        (qt.Site_Services_Discount__c != oldQuote.Site_Services_Discount__c) 
                        || (qt.Modular_Fixed_Discount_New__c != oldQuote.Modular_Fixed_Discount_New__c) 
                        || (qt.Site_Service_Fixed_Discount_New__c != oldQuote.Site_Service_Fixed_Discount_New__c)
                        || ((qt.PM_Fee__c != oldQuote.PM_Fee__c) && (qt.Latest_Quote__c == true))) {
                       // updateQuote_graphQL.UpdateQuote(qt.id, modularDiscChanged, siteDiscChanged);
                       //qt.Update_Quote__c = true;
                       
                    }
             		// Commented the above code and added the new condition on 18 June 2024 for SF to LSQ
             		if((qt.PM_Fee__c != oldQuote.PM_Fee__c) && (qt.Latest_Quote__c == true)){
                 		qt.Update_Quote__c = true;
             		}*/
         }
    }
    
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        if (RecursiveTriggerHandler.isFirstTime) {
            RecursiveTriggerHandler.isFirstTime = false;
            callPaymentAPI();
            if (trigger.new != null) {
                for (quote qt:trigger.new) {
                    Boolean modularDiscChanged = false;
                    Boolean siteDiscChanged = false;
                    quote oldQuote = trigger.OldMap.get(qt.id);
                    /* Call the updateQuote API when Discounts are updated. */
                    if ((qt.Modular_Fixed_Discount__c != oldQuote.Modular_Fixed_Discount__c) ||
                        (qt.Modular_Discount__c != oldQuote.Modular_Discount__c)) {
                            modularDiscChanged = true;
                        }
                    if ((qt.Site_Service_Fixed_Discount__c != oldQuote.Site_Service_Fixed_Discount__c) ||
                        (qt.Site_Services_Discount__c != oldQuote.Site_Services_Discount__c)) {
                            siteDiscChanged = true;
                        }
                    //updateQuote_graphQL call
                    if ((qt.Modular_Discount__c != oldQuote.Modular_Discount__c) || (qt.Site_Services_Discount__c != oldQuote.Site_Services_Discount__c)) {
                       // updateQuote_graphQL.UpdateQuote(qt.id, modularDiscChanged, siteDiscChanged);
                       //qt.Update_Quote__c = true;
                       
                    }
                    if(Trigger.new[0].Status == 'Approved' && qt.Quote_Link__c == Null && qt.Proposal_PDF__c == Null && qt.Site_Services_PDF__c == Null){                
                        Quote_Lcs.sendemailtemplate(qt.id);
                    }   
                }   
            }
            List<Quote> invList = [select id, opportunityId, Latest_quote__c, Oppty_Owner__c, LastModifiedDate,
                                     status from quote where opportunityId IN :oppIds ORDER BY LastModifiedDate DESC];
            
            if (Test.isRunningTest() || (invList[0].status == 'Approved' && (trigger.oldMap.get(invList[0].Id).status != trigger.newMap.get(invList[0].Id).status) )){
                for(Integer i=1; i < invList.size(); i++){ 
                    //invList[i].Latest_quote__c = false; // uncheck all from being latest
                }
                
                //invList[0].Latest_quote__c = true; // check only the newly updated quote as latest
                update invList;
            }
        }
        // Latest Quote update ---> Start
        //LatestQuoteTriggerController.LatestQuoteUpdate(Trigger.New[0].Id);
        // Latest Quote update ---> End
    }

    //
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            QuoteTriggerHelper.CheCkPRStatusIsPending(trigger.new);
        }
    }

     // When quote is approved
    if (Trigger.isAfter) {

        if (Trigger.isInsert) {
            List<Quote> approvedQuoteList = new List<Quote>();
            for (Quote quoteRecord : Trigger.new) {
                if (quoteRecord.status == 'Approved' && quoteRecord.Latest_Quote__c) {
                    approvedQuoteList.add(quoteRecord);
                }
            }
            if (approvedQuoteList.size() > 0) {
                QuoteTriggerHelper.updatePaymentRequest(approvedQuoteList, 'afterInsert');
            }
        }
        
      /*  if (Trigger.isUpdate) {
            List<Quote> approvedQuoteList = new List<Quote>();
            system.debug('in after update');
            for (Quote quoteRecord : Trigger.new) {
                System.debug('quoteRecord.status =>'+quoteRecord.status);
                System.debug('quoteRecord.Latest_Quote__c =>'+ quoteRecord.Latest_Quote__c);
                Boolean isStatusChanged = quoteRecord.status != Trigger.oldMap.get(quoteRecord.Id).status? true: false;
                Boolean isTotalAmmountChanged = quoteRecord.Opportunity_Amount__c != Trigger.oldMap.get(quoteRecord.Id).Opportunity_Amount__c? true: false;
                Boolean isModularDiscountChanged = quoteRecord.Modular_Discount__c != Trigger.oldMap.get(quoteRecord.Id).Modular_Discount__c? true: false;
                Boolean isSiteServiceDiscountChanged = quoteRecord.Site_Services_Discount__c != Trigger.oldMap.get(quoteRecord.Id).Site_Services_Discount__c? true: false;
                Boolean isLatestQuoteChanged = quoteRecord.Latest_Quote__c != Trigger.oldMap.get(quoteRecord.Id).Latest_Quote__c? true: false;
                if (quoteRecord.status == 'Approved' && quoteRecord.Latest_Quote__c || (isStatusChanged || isTotalAmmountChanged || isModularDiscountChanged || isSiteServiceDiscountChanged)) {
                    approvedQuoteList.add(quoteRecord);
                }
            }
            
            if (approvedQuoteList.size() > 0) {
                System.debug('enter in after update approvedQuoteList');
                QuoteTriggerHelper.updatePaymentRequest(approvedQuoteList, 'afterUpdate');
            }
        }*/
    }
    
    void callPaymentAPI(){
                    List<Quote> approvedQuoteList = new List<Quote>();
            system.debug('in after update');
            for (Quote quoteRecord : Trigger.new) {
                System.debug('quoteRecord.status =>'+quoteRecord.status);
                System.debug('quoteRecord.Latest_Quote__c =>'+ quoteRecord.Latest_Quote__c);
                Boolean isStatusChanged = quoteRecord.status != Trigger.oldMap.get(quoteRecord.Id).status? true: false;
                Boolean isTotalAmmountChanged = quoteRecord.Opportunity_Amount__c != Trigger.oldMap.get(quoteRecord.Id).Opportunity_Amount__c? true: false;
                Boolean isModularDiscountChanged = quoteRecord.Modular_Discount__c != Trigger.oldMap.get(quoteRecord.Id).Modular_Discount__c? true: false;
                Boolean isSiteServiceDiscountChanged = quoteRecord.Site_Services_Discount__c != Trigger.oldMap.get(quoteRecord.Id).Site_Services_Discount__c? true: false;
                Boolean isLatestQuoteChanged = quoteRecord.Latest_Quote__c != Trigger.oldMap.get(quoteRecord.Id).Latest_Quote__c? true: false;
                system.debug('quoteRecord 1: '+quoteRecord);
                    system.debug('status 1: '+quoteRecord.status);
                    system.debug('Latest_Quote__c 1: '+quoteRecord.Latest_Quote__c);
                if (quoteRecord.status == 'Approved' && quoteRecord.Latest_Quote__c && (isLatestQuoteChanged || isStatusChanged || isTotalAmmountChanged || isModularDiscountChanged || isSiteServiceDiscountChanged)) {
                    approvedQuoteList.add(quoteRecord);
                    system.debug('quoteRecord : '+quoteRecord);
                    system.debug('status : '+quoteRecord.status);
                    system.debug('Latest_Quote__c : '+quoteRecord.Latest_Quote__c);
                }
            }
            
            if (approvedQuoteList.size() > 0) {
                System.debug('enter in after update approvedQuoteList');
                QuoteTriggerHelper.updatePaymentRequest(approvedQuoteList, 'afterUpdate');
            }
    }
    
}