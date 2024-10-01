trigger UserDetailsTrigger on User_Details__c (after insert, after update) {

      if(trigger.isAfter){
        UserDetailsTriggerHandler.handleAfterInsertOrUpdate(trigger.new, trigger.oldMap);
      }
}