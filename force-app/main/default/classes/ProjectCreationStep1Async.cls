public without sharing class ProjectCreationStep1Async implements Queueable {
    private ID mOppID;
    private DateTime mSignupDate;
    private Decimal mProjectValue;
    private Decimal mSignupAmount;
    
    public ProjectCreationStep1Async(ID aOppID, DateTime aSignupDate, Decimal aProjectValue, Decimal aSignupAmount) {
        if(aOppID == null) {
            throw new CustomException('aOppID cannot be null.');
        }
        
        mOppID = aOppID;
        mSignupDate = aSignupDate;
        mProjectValue = aProjectValue;
        mSignupAmount = aSignupAmount;
    }
    
    public void execute(QueueableContext context) {
        Application_Settings__c recordOwner = Application_Settings__c.getValues('CRASH_RECORD_OWNER');
        try {
            Milestone1_Project__c lProject = performStep1();
            
            if(lProject != null) {
                if(!Test.isRunningTest()) {
                    System.enqueueJob(new ProjectCreationStep2Async(lProject.Id));
                }
            }
        }
        catch(Exception e) {
            // Send error email here.
            if(recordOwner != Null){
                Database.insert(new Error_Log__c(Error_Message__c=e.getMessage(),Entity_Info__c = mOppID,Error_Type__c='Project Creation', OwnerId=recordOwner.value__c),false);
            }
        }
    }
    
    private Milestone1_Project__c performStep1() {
        Opportunity lOpp  = [SELECT id, name, Account.Name, AccountId,Region__c, Amount, Designer__c, Offer_and_Discounts__c, CloseDate, Meeting_Venue__c, 
                             Customer_ID__c, Enquiry_ID__c, OwnerId, Signup_Amount__c, (SELECT ContentDocumentId, Visibility, ShareType FROM ContentDocumentLinks),
                             (SELECT id FROM Projects__r) FROM Opportunity WHERE Id=:mOppID];
        
        if(lOpp.Projects__r.size() > 0) {
            return null;
        }
        
        mSignupDate = (mSignupDate == null ? DateTime.newInstance(lOpp.CloseDate, Time.newInstance(10, 0, 0, 0)) : mSignupDate);
        mProjectValue = (mProjectValue == null ? lOpp.Amount : mProjectValue);
        mSignupAmount = (mSignupAmount == null ? lOpp.Signup_Amount__c : mSignupAmount);
        system.debug('lTemplateProject');
        system.debug('lTemplateProject'+ProjectCreationUtility.getTemplateProject());
        Milestone1_Project__c lTemplateProject = ProjectCreationUtility.getTemplateProject();
        
        
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
        
        Milestone1_Project__c lNewProject = lTemplateProject.clone(false, true);
        lNewProject.RecordTypeId = projRecordTypeId;
        lNewProject.Name = 'DC - ' + lOpp.Account.Name + ' - ' + lOpp.Customer_ID__c;
        
        if(String.isNotBlank(lOpp.Meeting_Venue__c)) {
            lNewProject.Name += ' - ' + lOpp.Meeting_Venue__c;
        }
        
        lNewProject.Customer__c = lOpp.AccountId;
        lNewProject.Amount__c = mProjectValue;
        lNewProject.Opportunity__c = lOpp.id;
        lNewProject.Enquiry_ID__c = lOpp.Enquiry_ID__c;
        lNewProject.Signup_Amount__c = lOpp.Signup_Amount__c;
        lNewProject.REGION__c = lOpp.Region__c;
        lNewProject.Offers_and_Discounts__c = lOpp.Offer_and_Discounts__c;
        lNewProject.Kickoff__c = mSignupDate.Date();
        lNewProject.Deadline__c = mSignupDate.Date() + Integer.valueOf(lNewProject.Project_Duration_in_days__c);
        lNewProject.Survey_Date__c = mSignupDate + 2;
        lNewProject.KYC_Date__c = mSignupDate + 7;
        lNewProject.First_Cut_Presentation_Date__c = mSignupDate + 12;
        lNewProject.X3D_Presentation_Date__c = mSignupDate + 31;
        lNewProject.Kickoff_Meeting_Date__c = mSignupDate + 47;
        lNewProject.Design_Finalization_Date__c = mSignupDate + 21;
        insert lNewProject;
        
        return lNewProject;
    }
}