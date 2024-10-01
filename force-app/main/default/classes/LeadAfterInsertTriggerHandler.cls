public class LeadAfterInsertTriggerHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        LeadTrigger_Handler.leadTraceOnLeadInsert((List < Lead > ) tp.newList);
        LeadTrigger_Handler.smsIntegrationCallAfterInsert((Map <Id,Lead > ) tp.newMap);
        LeadTrigger_Handler.shareLeadwithDesigner((List < Lead > ) tp.newList);
    }
}