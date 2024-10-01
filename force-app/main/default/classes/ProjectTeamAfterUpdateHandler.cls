public class ProjectTeamAfterUpdateHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp) {
        ProjectTeamMemberTriggerHandler.onlyPrimaryDesigner((List < Project_Team_Member__c > ) tp.newList);
        
        ProjectTeamMemberTriggerHandler.handlePTMUpsertTrigger((List < Project_Team_Member__c > ) tp.newList);
        ProjectTeamMemberTriggerHandler.UpdateMileStoneOwner((List < Project_Team_Member__c > ) tp.newList);
        ProjectTeamMemberTriggerHandler.updateAssigedDesinerOnproject((MAP< ID,Project_Team_Member__c > ) tp.newMap, (MAP< ID,Project_Team_Member__c > ) tp.oldMap);
        ProjectTeamMemberTriggerHandler.handlePTMUpdateManagerCustomer((List < Project_Team_Member__c > ) tp.newList,(MAP< ID,Project_Team_Member__c > ) tp.oldMap);//add by Jai Kumar.
        ProjectTeamMemberTriggerHandler.handleUpdateCHMonProjectPTMUpdate((List < Project_Team_Member__c > ) tp.newList,(MAP< ID,Project_Team_Member__c > ) tp.oldMap);
        ProjectTeamMemberTriggerHandler.handleshareRecordDefaultProjectGroupUpdate((List < Project_Team_Member__c > ) tp.newList, (MAP< ID,Project_Team_Member__c > ) tp.oldMap);
        
        if(!System.isBatch()) {
            ProjectTeamMemberTriggerHandler.projectSharingMethod(tp.newMap.keyset());
        }
    }
}