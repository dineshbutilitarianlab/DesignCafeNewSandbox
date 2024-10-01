public without sharing class FeedbackAfterUpdateTH extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
        Feedback__c [] lNew = (List<Feedback__c>)tp.newList;
        Feedback__c [] lOld = (List<Feedback__c>)tp.oldList;
        
        Integer lIndex = 0;
        Project_Artifact__c [] lArtifactsForUpdation = new List<Project_Artifact__c>();
        
        for(Feedback__c lFeedback : lNew) {
            if(lFeedback.Is_Accepted_by_Customer__c == 'Yes' && lOld[lIndex].Is_Accepted_by_Customer__c != 'Yes') {
                lArtifactsForUpdation.add(new Project_Artifact__c(id=lFeedback.Project_Artifact__c, Status__c='Published', Review_Feedback__c=lFeedback.Comments__c));
            }
            else if(lFeedback.Is_Accepted_by_Customer__c == 'No' && lOld[lIndex].Is_Accepted_by_Customer__c != 'No') {
                lArtifactsForUpdation.add(new Project_Artifact__c(id=lFeedback.Project_Artifact__c, Status__c='Rejected by Customer', Review_Feedback__c=lFeedback.Comments__c));
            }
            
            lIndex++;
        }
        
        if(lArtifactsForUpdation.size() > 0) {
            update lArtifactsForUpdation;
        }
    }
}