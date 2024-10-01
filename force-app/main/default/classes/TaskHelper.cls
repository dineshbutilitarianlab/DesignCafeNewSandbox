public class TaskHelper {
    
    public static void rollUptoLead(List<Task> newtaskList){
        set < Id > leadIdSet = New Set < Id > ();
        List<Lead> listOfLeadToBeUpdated = New List<Lead>();
        For(Task taskObj: newtaskList) {
            If(taskObj.CallType != Null && (taskObj.CallType.equalsIgnoreCase('Outbound')||taskObj.CallType.equalsIgnoreCase('Inbound')) && taskObj.WhoId != Null &&
                taskObj.WhoId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Lead')) {
                leadIdSet.add(taskObj.WhoId);   
            }
        }

        For(Lead leadObj:[Select id,Total_Call_Duration__c,Call_Count__c,(SELECT Id,CallType,CallDurationInSeconds,TaskSubtype,Subject FROM Tasks) from Lead where Id in :leadIdset]){
            If(leadObj.Tasks.size()>0){
                Decimal callDuration = 0.0;
                Integer callcount = 0;
                if(leadObj.Tasks.size() > 0){
                    For(task tObj:leadObj.Tasks){
                        if(tObj.CallDurationInSeconds!=Null){
                            callDuration = callDuration + tObj.CallDurationInSeconds;
                        }
                        if(tObj != null && tObj.CallType != null && (tObj.CallType.equalsignoreCase('Inbound')||tObj.CallType.equalsignoreCase('Outbound'))){
                            callcount = callcount+1;
                        }
                    }
                }
                leadObj.Total_Call_Duration__c = callDuration/60;
                leadObj.Call_Count__c = callcount;
                listOfLeadToBeUpdated.add(leadObj);
            }                           
        }
        If(listOfLeadToBeUpdated.size()>0){
            update listOfLeadToBeUpdated;
        }
    }
}