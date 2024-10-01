public class ProjectTeamAfterInsertHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp) {
        ProjectTeamMemberTriggerHandler.onlyPrimaryDesigner((List < Project_Team_Member__c > ) tp.newList);
        
        
        ProjectTeamMemberTriggerHandler.handlePTMInsertTrigger((List < Project_Team_Member__c > ) tp.newList);
        ProjectTeamMemberTriggerHandler.update3dAndPMDesinerOnproject((MAP<ID, Project_Team_Member__c > ) tp.newMap);
        ProjectTeamMemberTriggerHandler.UpdateMileStoneOwner((List < Project_Team_Member__c > ) tp.newList);
        ProjectTeamMemberTriggerHandler.handlePTMInsertUpdateManagerCustomer((List < Project_Team_Member__c > ) tp.newList);//add by Jai Kumar.
        ProjectTeamMemberTriggerHandler.handleUpdateCHMonProjectPTMInsert((List < Project_Team_Member__c > ) tp.newList);
        ProjectTeamMemberTriggerHandler.handleShareRecorddefaultProjectGroup((List < Project_Team_Member__c > ) tp.newList);
        
        if(!System.isBatch()) {
            ProjectTeamMemberTriggerHandler.projectSharingMethod(tp.newMap.keyset());
        }
    }
}