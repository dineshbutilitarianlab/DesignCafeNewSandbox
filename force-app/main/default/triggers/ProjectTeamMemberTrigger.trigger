//TODO: Comments need to be updated 
trigger ProjectTeamMemberTrigger on Project_Team_Member__c (before insert,before update,after insert, after Update) {
    
    TriggerFactory.createTriggerDispatcher(Project_Team_Member__c.sObjectType);
    
    
    if(Trigger.isBefore && Trigger.isInsert){
        //ProjectTeamMemberTriggerHandler.updateCHMandDesignerEmail(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
       // ProjectTeamMemberTriggerHandler.updateCHMandDesignerEmailupdate(trigger.new ,trigger.newMap,trigger.oldMap);
    }
    
      if( Trigger.isAfter && Trigger.isInsert){
        /*ProjectTeamMemberTriggerHandler.handlePTMInsertTrigger(trigger.new);
        ProjectTeamMemberTriggerHandler.update3dAndPMDesinerOnproject(trigger.newMap);
        ProjectTeamMemberTriggerHandler.UpdateMileStoneOwner(trigger.new);
        ProjectTeamMemberTriggerHandler.handlePTMInsertUpdateManagerCustomer(trigger.new);//add by Jai Kumar.
        ProjectTeamMemberTriggerHandler.handleUpdateCHMonProjectPTMInsert(trigger.new);
        ProjectTeamMemberTriggerHandler.handleShareRecorddefaultProjectGroup(trigger.new);
         */
    }
    else if( Trigger.isAfter && Trigger.isUpdate ) {
       /* ProjectTeamMemberTriggerHandler.handlePTMUpsertTrigger(trigger.new);
        ProjectTeamMemberTriggerHandler.UpdateMileStoneOwner(trigger.new);
        ProjectTeamMemberTriggerHandler.updateAssigedDesinerOnproject(trigger.newMap, trigger.oldMap);
        ProjectTeamMemberTriggerHandler.handlePTMUpdateManagerCustomer(trigger.new,trigger.oldMap);//add by Jai Kumar.
        ProjectTeamMemberTriggerHandler.handleUpdateCHMonProjectPTMUpdate(trigger.new,trigger.oldMap);
        ProjectTeamMemberTriggerHandler.handleshareRecordDefaultProjectGroupUpdate(trigger.new,trigger.oldMap);
        */
    }
}