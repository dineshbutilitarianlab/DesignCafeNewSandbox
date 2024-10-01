public class TaskBeforeUpdateTriggerHandler extends TriggerHandlerBase {
	  public override void mainEntry(TriggerParameters tp) {
        TaskTrigger_Handler.updateReminderTime((Map <Id,Task > ) tp.newMap, (Map <Id,Task > ) tp.oldMap);
    }
}