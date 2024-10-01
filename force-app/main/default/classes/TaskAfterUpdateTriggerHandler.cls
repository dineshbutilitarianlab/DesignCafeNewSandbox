public class TaskAfterUpdateTriggerHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        TaskHelper.rollUpToLead((List < Task > ) tp.newList);
        //TaskTrigger_Handler.updateLeadfieldUpdateTask((List < Task > ) tp.newList, (Map <Id,Task > ) tp.oldMap);
    }

}