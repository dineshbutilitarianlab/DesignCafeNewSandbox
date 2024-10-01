/*
Created By : Ankit
Description : TODO
*/
trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert ,after insert) {
    
    if(Trigger.isBefore){
        ContentDocumentLinkTriggerHandler.preventFileuploadforFinance(trigger.new);
    }
    if(Trigger.isAfter){
        ContentDocumentLinkTriggerHandler.createCDLforAccount(trigger.new);
    }
    
    
    
}