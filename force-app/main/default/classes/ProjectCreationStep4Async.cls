public without sharing class ProjectCreationStep4Async implements Queueable {
    private ID mOppID;
    
    public ProjectCreationStep4Async(ID aOppId) {
        mOppID = aOppId;
    }
    
    public void execute(QueueableContext context) {
        Application_Settings__c recordOwner = Application_Settings__c.getValues('CRASH_RECORD_OWNER');
        try {
            Opportunity lOpportunity = performStep4();
            invokeStep5(lOpportunity.Projects__r[0]);
        }
        catch(Exception e) {
            Opportunity [] lOpp = [SELECT id, (SELECT id FROM Projects__r) FROM Opportunity WHERE id=:mOppID];
           if(!lOpp.isEmpty() && !lOpp[0].Projects__r.isEmpty()) {
            	ProjectCreationUtility.deleteProject(lOpp[0].Projects__r[0].id);
            } if(recordOwner != Null){
                Database.insert(new Error_Log__c(Error_Message__c=e.getMessage(),Entity_Info__c = lOpp[0].id,Error_Type__c='Project Creation', OwnerId=recordOwner.value__c),false);
            }
        }
    }
    
    private Opportunity performStep4() {
        ContentDocumentLink [] cdls = new List<ContentDocumentLink>();
        Project_Team_Member__c [] ptms = new List<Project_Team_Member__c>();
        Opportunity [] lOpportunity = [SELECT id, Name, Designer__c, OwnerId, (SELECT ContentDocumentId, Visibility, ShareType FROM ContentDocumentLinks),
                                   		(SELECT id, Opportunity__c, Region__c FROM Projects__r) FROM Opportunity WHERE Id=:mOppID];
        
        if(lOpportunity.isEmpty()) { throw new CustomException('Unable to locate Opportunity with ID - ' + mOppID);
        }
        
		if(lOpportunity[0].Projects__r.isEmpty()) { throw new CustomException('Unable to locate Project on the Opportunity with ID - ' + mOppID);
        }
        
        Opportunity lOpp = lOpportunity[0];
        Milestone1_Project__c lProject = lOpportunity[0].Projects__r[0];
        
        ptms.add(new Project_Team_Member__c(Role__c='Primary Designer', User__c=lOpp.Designer__c, Project__c=lProject.Id));
        ptms.add(new Project_Team_Member__c(Role__c='Sales Executive', User__c=lOpp.OwnerId, Project__c=lProject.Id));
		
        for(ContentDocumentLink cdl : lOpp.ContentDocumentLinks) { ContentDocumentLink contDocLink =  cdl.clone();
            contDocLink.LinkedEntityId = lProject.Id;
            cdls.add(contDocLink);
        }
        
        if(!ptms.isEmpty()) {
            insert ptms;
        }
        
        if(!cdls.isEmpty()) {
            insert cdls;
        }
        
        return lOpp;
    }
    
    private void invokeStep5(Milestone1_Project__c aProject) {
        If(!Test.isRunningTest()) {System.enqueueJob(new ProjectMemberRoundRobinAsync(new Map<ID, Milestone1_Project__c> {aProject.id => aProject}, null));
                }
    }
}