public class LeadAfterUpdateTriggerHandler extends TriggerHandlerBase {
    public static Boolean isAfterUpdateExecuted = false;
    
    public override void mainEntry(TriggerParameters tp) {
        if(isAfterUpdateExecuted == false){
            LeadTrigger_Handler.completeTasksOnResponse((Map <Id,Lead > ) tp.newMap, (Map <Id,Lead > ) tp.oldMap);
            LeadTrigger_Handler.leadTraceOnLeadUpdate(tp.newList,(Map <Id,Lead > ) tp.oldMap);
            LeadTrigger_Handler.smsIntegrationCallAfterUpdate((Map <Id,Lead > ) tp.newMap, (Map <Id,Lead > ) tp.oldMap); // SMS Integration
            isAfterUpdateExecuted = true;
        }
        
        LeadTrigger_Handler.handleLeadCustomSharing(tp.oldList, tp.newList);
        LeadTrigger_Handler.shareLeadwithDesignerUpdate(tp.newList,(Map <Id,Lead > ) tp.oldMap);
    }
}