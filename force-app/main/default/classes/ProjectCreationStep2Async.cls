public without sharing class ProjectCreationStep2Async implements Queueable {
    private ID mProjectID;
    
    public ProjectCreationStep2Async(ID aProjectID) {
        if(aProjectID == null) {
            throw new CustomException('aProjectID cannot be null.');
        }
        
        mProjectID = aProjectID;
    }
    
    public void execute(QueueableContext context) {
        Application_Settings__c recordOwner = Application_Settings__c.getValues('CRASH_RECORD_OWNER');
        try {
            performStep2();
            If(!Test.isRunningTest()) {
                    System.enqueueJob(new ProjectCreationStep3Async(mProjectID));
                }
            
        }
        catch(Exception e) {
            Milestone1_Project__c [] lproj =[SELECT id, opportunity__c FROM Milestone1_Project__c WHERE id=:mProjectID]; 
            ProjectCreationUtility.deleteProject(mProjectID);
            // #2. Send error email
            if(recordOwner != Null){
                Database.insert(new Error_Log__c(Error_Message__c=e.getMessage(),Entity_Info__c =lproj[0].opportunity__c,Error_Type__c='Project Creation', OwnerId=recordOwner.value__c),false);
            }
        }
    }
    
    public void performStep2() {
        List<Milestone1_Milestone__c> lProjectMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c [] lTemplateMilestones = ProjectCreationUtility.getTemplateMilestones();
        Milestone1_Project__c [] lProject = [SELECT id, Signup_Amount__c, Kickoff__c,opportunity__c, Customer__c FROM Milestone1_Project__c WHERE id=:mProjectID];
        
        if(lProject.size() == 0) {
            throw new CustomException('Unable to locate Project with ID - ' + mProjectID);
        }
        
        Milestone1_Milestone__c lSignupMilestone = null;
        Id milesRecordTypeId = Schema.SObjectType.Milestone1_Milestone__c.getRecordTypeInfosByDeveloperName().get('Project_Milestone').getRecordTypeId();
        
        for(Milestone1_Milestone__c lTemplate : lTemplateMilestones) {
            Milestone1_Milestone__c mileCopy = lTemplate.clone(false, true);
            mileCopy.RecordTypeId = milesRecordTypeId;
            mileCopy.Name = mileCopy.Name.replaceAll('TEMPLATE - ', ''); 
            mileCopy.MilestoneTemplateSFID__c = lTemplate.Id;
            mileCopy.Milestone_Template_PredecessorSFID__c = lTemplate.Predecessor_Milestone__c;
            mileCopy.Milestone_Template_SuccessorSFID__c = lTemplate.Successor_Milestone__c;
            mileCopy.Milestone_Template_Prev_Payment_SFID__c = lTemplate.Previous_Payment_Milestone__c;
            mileCopy.Project__c = mProjectID;
            mileCopy.Assign_To_Role__c =  lTemplate.Assign_To_Role__c;
            mileCopy.Type__c = lTemplate.Type__c;
            
            if(mileCopy.Type__c == 'Signup') {
                mileCopy.Actual_Completion_Date__c = lProject[0].Kickoff__c;
               lSignupMilestone = mileCopy;
            }
            
            mileCopy.Kickoff__c = lProject[0].Kickoff__c + Integer.valueOf(mileCopy.Relative_Kickoff_Date_in_days__c);
            mileCopy.Deadline__c = lProject[0].Kickoff__c + Integer.valueOf(mileCopy.Relative_Deadline_in_days__c);
            mileCopy.Customer__c = lProject[0].Customer__c;
            mileCopy.EligibleAmountPercentage__c = lTemplate.EligibleAmountPercentage__c; 
            lProjectMilestones.add(mileCopy);
        }
        
        if(lProjectMilestones.size() > 0) {
            insert lProjectMilestones;
            
            Payment__c pay = new Payment__c(Milestone__c=lSignupMilestone.id, Amount__c=lProject[0].Signup_Amount__c, Mode__c='Cash',
                                            Revenue_Milestone_Category__c='5.00', Payment_Received_Date__c=Date.today());
            insert pay;
        }
    }
}