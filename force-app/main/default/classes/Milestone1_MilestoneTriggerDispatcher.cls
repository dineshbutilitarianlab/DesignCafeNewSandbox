public class Milestone1_MilestoneTriggerDispatcher extends TriggerDispatcherBase {
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new Milestone1_MilestoneAfterUpdateTH(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        }
    }
    
    public virtual override void afterInsert(TriggerParameters tp) {
        if(!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
            execute(new Milestone1_MilestoneAfterInsertTH(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        }
    }
}