public class ProjectTeamMemberBeforeInsertHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        ProjectTeamMemberTriggerHandler.updateCHMandDesignerEmail((LIST<Project_Team_Member__c> ) tp.newList);
    }
}