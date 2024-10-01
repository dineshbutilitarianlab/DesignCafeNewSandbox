public class Milestone1_MilestoneAfterInsertTH extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
        Milestone1_Milestone__c [] lNew = (List<Milestone1_Milestone__c>)tp.newList;
        MilestoneTriggerHandler.createArtifact(lNew);
    }
}