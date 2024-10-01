public class ProjectTeamMemberBeforeUpdateHandler  extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        ProjectTeamMemberTriggerHandler.updateCHMandDesignerEmailupdate((LIST<Project_Team_Member__c> ) tp.newList, (MAP< ID,Project_Team_Member__c > ) tp.newMap,(MAP< ID,Project_Team_Member__c > ) tp.oldMap);
    }
    
}