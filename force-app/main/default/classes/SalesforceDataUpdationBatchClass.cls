global class SalesforceDataUpdationBatchClass implements Database.Batchable<SObject>, Database.Stateful {
     // Map to store User Detail Ids with Lead OwnerIds
    private Map<Id,Id> ownerToUserDetailMap = new Map<Id, Id>();

    // Start method to define the scope of data to process
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query to retrieve all leads that need to be processed
        return Database.getQueryLocator([
            SELECT Id, OwnerId  FROM Lead WHERE User_Details__c = NULL
        ]);
    }

    // Execute method to process each batch of data
    global void execute(Database.BatchableContext BC, List<Lead> leadList) {
        // Collect OwnerIds from the leads in the current scope
        Set<Id> ownerIds = new Set<Id>();
        for (Lead lead : leadList) {
            ownerIds.add(lead.OwnerId);
        }

        // Query User_Details__c records that match the OwnerIds
        Map<Id, User_Details__c> userDetailMap = new Map<Id, User_Details__c>([
            SELECT Id FROM User_Details__c WHERE Id IN :ownerIds
        ]);

        // Prepare leads for update
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead lead : leadList) {
            if (userDetailMap.containsKey(lead.OwnerId)) {
                lead.User_Details__c = userDetailMap.get(lead.OwnerId).Id;
                leadsToUpdate.add(lead);
            }
        }

        // Update leads
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    // Finish method to perform operations after all batches are processed
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch job completed.');
    }

}