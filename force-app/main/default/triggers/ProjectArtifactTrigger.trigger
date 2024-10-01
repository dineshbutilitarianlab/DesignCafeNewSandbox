trigger ProjectArtifactTrigger on Project_Artifact__c (before insert, before update, after update) {
    TriggerFactory.createTriggerDispatcher(Project_Artifact__c.sObjectType);
}