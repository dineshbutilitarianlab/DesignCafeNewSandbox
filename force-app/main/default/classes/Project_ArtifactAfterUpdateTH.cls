public without sharing class Project_ArtifactAfterUpdateTH extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        Integer lIndex = 0;
        Project_Artifact__c [] lNew = (List<Project_Artifact__c>)tp.newList;
        Project_Artifact__c [] lOld = (List<Project_Artifact__c>)tp.oldList;       
        
        List<Milestone1_Milestone__c> activityList = new List<Milestone1_Milestone__c>();
        
        for(Project_Artifact__c lArtifact : lNew){            
            Milestone1_Milestone__c mRec = new Milestone1_Milestone__c();
            if(lArtifact.Status__c == 'Rejected by Customer' && lArtifact.Project_Milestone__c != NULL){         		
                mRec.id=lArtifact.Project_Milestone__c;
                mRec.Is_Accepted_by_Customer__c ='No';
                mRec.Complete__c = false;
                activityList.add(mRec);
            }
            lIndex++;
        }
        
        if(activityList.size()>0){
            update activityList;
        }
    }
}