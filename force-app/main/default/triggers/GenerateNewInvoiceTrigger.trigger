trigger GenerateNewInvoiceTrigger on Opportunity_Invoice__c (After delete) {
    
    Set<String> oppId = new Set<String>();
    for (Opportunity_Invoice__c OppInv : Trigger.old) {
        oppId.add(OppInv.Opportunity__c );  
    }
    
    opportunity opp = [SELECT Id, AccountId, IsInvoiceGenerated__c FROM Opportunity WHERE id = :oppId];
    list<Opportunity_Invoice__c> oppInvList = [SELECT id, Opportunity__c  FROM Opportunity_Invoice__c WHERE Opportunity__c = :oppId];
    
        System.debug('oppInvoice list size on generateNewInvoice Trigger' + oppInvList.size());
    //Checking if Opportunity Invoice is present or not.
        if (oppInvList.size() == 0) {
            opp.IsInvoiceGenerated__c = false;
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.IsInvoiceGenerated__c = false;
            update acc;
            update opp;
    }
}