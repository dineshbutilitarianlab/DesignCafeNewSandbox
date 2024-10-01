global class IntergrationRequestBulkDelete implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, format(CreatedDate), LastModifiedDate FROM Intergration_Request__c ORDER BY CreatedDate ASC LIMIT 5';
        System.debug('query ==> ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Intergration_Request__c> irList) {
        try {
            System.debug('irList in execute ==> ' + irList);
            DELETE irList;
        } catch(Exception e) {
            System.debug('Exception ==> ' + e);
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('finish call');
    }
}