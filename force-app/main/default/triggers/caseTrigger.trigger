trigger caseTrigger on Case (before insert ,before update, after insert,after update) {
   if(Trigger.isBefore){
        if(Trigger.isInsert){
            caseTriggerHandler.updateCHMEmailInsert(Trigger.New);
        }
        if(Trigger.isUpdate){
            caseTriggerHandler.updateCHMEmailupdate(Trigger.New, Trigger.NewMap , Trigger.oldMap);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert  || Trigger.isUpdate){
            caseTriggerHandler.shareCaseWith(Trigger.New);   
        }
        
    }
}