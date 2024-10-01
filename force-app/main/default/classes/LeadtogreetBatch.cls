global class LeadtogreetBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Status, DC_Lead_Status__c, Call_Stage__c, Channel__c, LARR__c FROM Lead WHERE ';
        query += 'Status = ' + '\'New\' AND DC_Lead_Status__c = ' + '\'Undialed\' AND ';
        query += 'Call_Stage__c = ' + '\'Undialed\' AND Channel__c = ' + '\'Offline\' AND ';
        query += 'LARR__c = false';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Lead> leads){
    
        for(Lead ld: leads){
            ld.OwnerId = '0052u000001DE1sAAG';
        }
        try{
            System.debug('leads ==> ' + leads);
            UPDATE leads;
        }catch(Exception ex){
            System.debug('exception ==> ' + ex.getMessage());
        }
         
    } 
    
    global void finish(Database.BatchableContext BC){
        System.debug('finish call');
    } 
    
}