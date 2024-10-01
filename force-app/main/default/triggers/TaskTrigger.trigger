trigger TaskTrigger on Task (after insert, after update,before update) {
    TriggerFactory.createTriggerDispatcher(Task.sObjectType);
    
    if(Trigger.isafter && (Trigger.isInsert || Trigger.isUpdate)){
        Set<id> taskIds = new Set<id>();
        for(Task taskRec : Trigger.new){
            if(taskRec.disposition_code__c != null 
            && taskRec.disposition_code__c == 'RNR-Comms' 
            && taskRec.whoid != null
            && ((Trigger.isUpdate && ((taskRec.disposition_code__c != Trigger.oldMap.get(taskRec.Id).disposition_code__c) || (taskRec.whoid != Trigger.oldMap.get(taskRec.Id).whoid))) || (Trigger.isInsert))){
                taskIds.add(taskRec.Id);
            }
        }
        if(taskIds.size() > 0){
                system.debug('caling callout');
                DC_WebnengageTask.callout(taskIds);
        }
    }
}