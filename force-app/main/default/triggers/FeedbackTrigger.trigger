trigger FeedbackTrigger on Feedback__c (before insert,after update) {
	TriggerFactory.createTriggerDispatcher(Feedback__c.sObjectType);
    
    /*if(Trigger.isAfter && Trigger.isUpdate){
        FeedbackTriggerHelper.updateActivityStatus(trigger.newMap,Trigger.oldMap);
    }
    //Update by Ranveer
    if(Trigger.isBefore && Trigger.isInsert){
        FeedbackTriggerHelper.insertCustomeOnFeedback(trigger.new);
    }*/
    if(Trigger.isBefore && Trigger.isInsert){
       FeedbackTriggerHelper.updateCHMandDesignerEmail(trigger.new);
    }
    
}