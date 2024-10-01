public class Project_ArtifactBeforeInsertTH extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
        Set<ID> lMilestoneIDSet = new Set<ID>();
        Project_Artifact__c [] lNew = (List<Project_Artifact__c>)tp.newList;
        
        for(Project_Artifact__c lArtifact : lNew) {
            if(lArtifact.Status__c == 'Draft') {
                lMilestoneIDSet.add(lArtifact.Project_Milestone__c);
            }
        }
        
        ID lOpenRecTypeID = null;
        ID lClosedRecTypeID = null;
        
        for(Schema.RecordTypeInfo lRecType : Project_Artifact__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(lRecType.getDeveloperName() == 'Project_Artifact_Closed') {
                lClosedRecTypeID = lRecType.getRecordTypeId();
            }
            else if(lRecType.getDeveloperName() == 'Artifact_Pending_Designer_Acceptance') {
                lOpenRecTypeID = lRecType.getRecordTypeId();
            }
        }
        
        if(lMilestoneIDSet.size() > 0) {
            Map<ID, Milestone1_Milestone__c> lIDToMilestoneMap = new Map<ID, Milestone1_Milestone__c>(
                [SELECT id, Type__c, (SELECT id, Status__c, Version__c FROM Project_Artifacts__r ORDER BY Version__c DESC) 
                 FROM Milestone1_Milestone__c WHERE id IN:lMilestoneIDSet]
            );
            
            for(Project_Artifact__c lArtifact : lNew) {
                if(lArtifact.Status__c == 'Draft') {
                    Integer lNewVersion = 1;
                    Milestone1_Milestone__c lMilestone = lIDToMilestoneMap.get(lArtifact.Project_Milestone__c);
					
                    if(lMilestone.Type__c == 'Build 3D Designs') {
                        lArtifact.RecordTypeId = lOpenRecTypeID;
                    }
                    else {
                        lArtifact.RecordTypeId = lClosedRecTypeID;
                    }
                    
                    for(Project_Artifact__c lPrevArtifact : lMilestone.Project_Artifacts__r) {
                        if(lNewVersion == 1) {
                            lNewVersion = lPrevArtifact.Version__c.intValue() + 1;
                        }
                        
                        if(lPrevArtifact.Status__c == 'Draft') {
                            lArtifact.addError(Label.Two_Draft_Artifacts_Not_Allowed);
                            break;
                        }
                    }
                    
                    lArtifact.Version__c = lNewVersion;
                }
            }
        }
    }
}