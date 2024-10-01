public without sharing class Project_ArtifactTriggerDispatcher extends TriggerDispatcherBase {
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isAfterUpdateProcessing = false; 
    
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new Project_ArtifactBeforeInsertTH(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
        }
    }
    
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new Project_ArtifactBeforeUpdateTH(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else {
            execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
        }
    }
    
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new Project_ArtifactAfterUpdateTH(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
}