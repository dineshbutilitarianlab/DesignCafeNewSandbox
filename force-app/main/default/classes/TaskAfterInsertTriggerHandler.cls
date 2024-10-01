public class TaskAfterInsertTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp) {
        TaskHelper.rollUpToLead((List < Task > ) tp.newList);
        TaskTrigger_Handler.timeStampsOfCallUpadteOnLead((List < Task > ) tp.newList);
        //TaskTrigger_Handler.updateLeadfieldInsertTask((List < Task > ) tp.newList);
    }
}