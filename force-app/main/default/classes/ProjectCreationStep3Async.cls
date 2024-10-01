public without sharing class ProjectCreationStep3Async implements Queueable{
    private ID mProjectID;
    
    public ProjectCreationStep3Async(ID aProjectID) {
        mProjectID = aProjectID;
    }
    
    public void execute(QueueableContext context) {
        Application_Settings__c recordOwner = Application_Settings__c.getValues('CRASH_RECORD_OWNER');
        try {
            Milestone1_Project__c lProject = performStep3();
            
            if(lProject != null) {
                If(!Test.isRunningTest()) {System.enqueueJob(new ProjectCreationStep4Async(lProject.Opportunity__c));
                }
            }
        }
        catch(Exception e) {
            Milestone1_Project__c [] lproj =[SELECT id, opportunity__c FROM Milestone1_Project__c WHERE id=:mProjectID]; 
            ProjectCreationUtility.deleteProject(mProjectID);
            if(recordOwner != Null){
                Database.insert(new Error_Log__c(Error_Message__c=e.getMessage(),Entity_Info__c =lproj[0].opportunity__c,Error_Type__c='Project Creation', OwnerId=recordOwner.value__c),false);
            }
        }
    }
    private Milestone1_Project__c performStep3() {
        Milestone1_Project__c [] lProject = [SELECT id, Opportunity__c, (SELECT id, Predecessor_Milestone__c, Milestone_Template_PredecessorSFID__c,
                                                                         Milestone_Template_SuccessorSFID__c, Successor_Milestone__c, Milestone_Template_Prev_Payment_SFID__c,
                                                                         Previous_Payment_Milestone__c, MilestoneTemplateSFID__c FROM Project_Milestones__r) 
                                             FROM Milestone1_Project__c WHERE id=:mProjectID];
        
        if(lProject.isEmpty()) { throw new CustomException('Unable to locate Project with ID - ' + mProjectID);
        }
        if(lProject[0].Opportunity__c == null) {   throw new CustomException('Fatal Error: Project not linked with any Opportunity - Project ID: ' + mProjectID);
        }
        
        Map<ID, ID> lMilestoneTemplateIDToMilestoneIDMap = new Map<ID, ID>();
        
        for(Milestone1_Milestone__c lMilestone : lProject[0].Project_Milestones__r) {
            lMilestoneTemplateIDToMilestoneIDMap.put(lMilestone.MilestoneTemplateSFID__c, lMilestone.Id);
        }
        
        for(Milestone1_Milestone__c lMilestone : lProject[0].Project_Milestones__r) {
            if(lMilestone.Milestone_Template_PredecessorSFID__c != null) {
                lMilestone.Predecessor_Milestone__c = lMilestoneTemplateIDToMilestoneIDMap.get(lMilestone.Milestone_Template_PredecessorSFID__c);
            }
            
            if(lMilestone.Milestone_Template_SuccessorSFID__c != null) {
                lMilestone.Successor_Milestone__c = lMilestoneTemplateIDToMilestoneIDMap.get(lMilestone.Milestone_Template_SuccessorSFID__c);
            }
            
            if(lMilestone.Milestone_Template_Prev_Payment_SFID__c != null) {           
                lMilestone.Previous_Payment_Milestone__c = lMilestoneTemplateIDToMilestoneIDMap.get(lMilestone.Milestone_Template_Prev_Payment_SFID__c);
            }
        }
        update lProject[0].Project_Milestones__r;
        return lProject[0];
    }
}