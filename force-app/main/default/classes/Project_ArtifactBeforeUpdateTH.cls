public class Project_ArtifactBeforeUpdateTH extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        Integer lIndex = 0;
        Project_Artifact__c [] lNew = (List<Project_Artifact__c>)tp.newList;
        Project_Artifact__c [] lOld = (List<Project_Artifact__c>)tp.oldList;
        
        ID lOpenRecTypeID = null;
        ID lClosedRecTypeID = null;
        
        for(Schema.RecordTypeInfo lRecType : Project_Artifact__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(lRecType.getDeveloperName() == 'Artifact_Pending_Designer_Acceptance') {
                lOpenRecTypeID = lRecType.getRecordTypeId();
            }
            else if(lRecType.getDeveloperName() == 'Project_Artifact_Closed') {
                lClosedRecTypeID = lRecType.getRecordTypeId();
            }
        }
        
        for(Project_Artifact__c lArtifact : lNew) {
            if(lOld[lIndex].Status__c != 'Draft' && lOld[lIndex].Status__c != 'Awaiting Designer Acceptance' && lOld[lIndex].Status__c != 'Awaiting Customer Acceptance') {
                lArtifact.addError(Label.Published_Artifacts_Cannot_be_Edited);
            }
            
            if((lArtifact.Status__c == 'Awaiting Designer Acceptance' || lArtifact.Status__c == 'Awaiting Customer Acceptance') && 
                   lOld[lIndex].Minutes_of_Meeting__c != lArtifact.Minutes_of_Meeting__c) {
                lArtifact.addError(Label.Published_Artifacts_Cannot_be_Edited);
            }
            
            if(lOld[lIndex].Status__c == 'Awaiting Designer Acceptance' && lArtifact.Status__c == 'Published') {
                lArtifact.RecordTypeId = lClosedRecTypeID;
			}
            
            if(lArtifact.Status__c == 'Awaiting Designer Acceptance') {
                lArtifact.RecordTypeId = lOpenRecTypeID;
            }
            
            lIndex++;
        }
    }
}