public class UserTriggerDispatcher extends TriggerDispatcherBase {
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    
    public virtual override void afterInsert(TriggerParameters tp) {
        if(!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
            execute(new UserAfterInsert(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new UserAfterUpdate(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
    }
    
}