public class ProjectAfterUpdateHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        ProjectTriggerHandler.createPublicGroup((List<Milestone1_Project__c > ) tp.newList);
    }

}