public class Milestone1_MilestoneAfterUpdateTH extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        Integer lIndex = 0;
        Set<ID> lMilestoneIDSet = new Set<ID>();
        Set<ID> lCompletedMilestoneIDSet = new Set<ID>();
        List<Milestone1_Milestone__c> listOfCompletedMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c [] lNew = (List<Milestone1_Milestone__c>)tp.newList;
        Milestone1_Milestone__c [] lOld = (List<Milestone1_Milestone__c>)tp.oldList;
        
        for(Milestone1_Milestone__c lMilestone : lNew) {
            lMilestoneIDSet.add(lMilestone.id);
        }
        
        Map<ID, List<Project_Artifact__c>> lMilestoneToDraftArtifactMap = new Map<ID, List<Project_Artifact__c>>();
        for(Project_Artifact__c lArtifact : [SELECT id, Minutes_of_Meeting__c, Status__c, Project_Milestone__c FROM Project_Artifact__c 
                                             WHERE Project_Milestone__c IN:lMilestoneIDSet AND Status__c='Draft']) {
            Project_Artifact__c [] lMilestoneArtifacts = lMilestoneToDraftArtifactMap.get(lArtifact.Project_Milestone__c);
            
            if(lMilestoneArtifacts == null) {
                lMilestoneArtifacts = new List<Project_Artifact__c>();
                lMilestoneToDraftArtifactMap.put(lArtifact.Project_Milestone__c, lMilestoneArtifacts);
            }
            
            lMilestoneArtifacts.add(lArtifact);
        }
        
        Feedback__c [] lFeedbackForInsertion = new List<Feedback__c>();
        Project_Artifact__c [] lArtifactsForUpdation = new List<Project_Artifact__c>();
        Map<ID, Milestone1_Project__c> lIDToProjectMap = new Map<ID, Milestone1_Project__c>();
        Set<String> lMilestoneTypesNeedingCustomerApprovalSet = new Set<String>(Label.Milestones_Needing_Client_Approval.split(','));
        Set<String> lMilestoneTypesNeedingDesignerApprovalSet = new Set<String>(Label.Milestones_Needing_Designer_Approval.split(','));
        Set<String> lMilestoneTypesToSkipCheck = new Set<String>(new List<String>{'Customer Onboarding','Payment Checkpoint'});
        Id lFeedbackRecType = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Customer Feedback Open').getRecordTypeId();  
        
        if(Application_Settings__c.getValues('MILESTONE_TYPE_SKIP_ARTIFACTS') != null) {
            lMilestoneTypesToSkipCheck.clear();
            lMilestoneTypesToSkipCheck.addAll(Application_Settings__c.getValues('MILESTONE_TYPE_SKIP_ARTIFACTS').Value__c.split(','));
        }
        
        for(Milestone1_Milestone__c lMilestone : lNew) {
            Boolean lError = false;
            
            /* For "Complete Customer Onboarding" and "QC Checklist Signoff", 
            *  system should not validate if Artifact record is created at the time when Milestone is marked as Complete. 
            *  @Ranveer
            */
            if(!lMilestoneTypesToSkipCheck.contains(lMilestone.type__c) && lMilestone.Complete__c == true && lOld[lIndex].Complete__c == false) {
                Project_Artifact__c [] lMilestoneDraftArtifacts = lMilestoneToDraftArtifactMap.get(lMilestone.id);
                
                if((lMilestoneDraftArtifacts == null || lMilestoneDraftArtifacts.size() == 0) ) {
                    lMilestone.addError(Label.Milestone_No_Draft_Artifact_Error);
                    lError = true;
                    continue;
                }
                
                if(lMilestoneTypesNeedingCustomerApprovalSet.contains(lMilestone.Type__c)) {
                    for(Project_Artifact__c lArtifact : lMilestoneDraftArtifacts) {
                        /*
                         * There can never be more than one Draft Artifact for a Milestone. System validation stops this from happening.
                         */
                        if(String.isBlank(lArtifact.Minutes_of_Meeting__c)) {
                            lMilestone.addError(Label.Artifact_should_have_MoM);
                            lError = true;
                            break;
                        }
                        
                        lArtifact.Status__c = 'Awaiting Customer Acceptance';
                        lFeedbackForInsertion.add(new Feedback__c(Name='Feedback for ' + lMilestone.Name, Customer__c=lMilestone.Customer__c,
                                                                  RecordTypeId=lFeedbackRecType,
                                                                  Customer_Contact__c=lMilestone.Customer_Contact__c, Project__c=lMilestone.Project__c,
                                                                  Minutes_of_Meeting__c=lArtifact.Minutes_of_Meeting__c, Project_Artifact__c=lArtifact.id));
                    }
                }
                else if(lMilestoneTypesNeedingDesignerApprovalSet.contains(lMilestone.Type__c)) {
                    for(Project_Artifact__c lArtifact : lMilestoneDraftArtifacts) {
                        lArtifact.Status__c = 'Awaiting Designer Acceptance';
                    }
                }
                else {
                    for(Project_Artifact__c lArtifact : lMilestoneDraftArtifacts) {
                        lArtifact.Status__c = 'Published';
                    }
                }
                
                if(lError == false) {
                    Milestone1_Project__c lProject = lIDToProjectMap.get(lMilestone.Project__c);
                    lArtifactsForUpdation.addAll(lMilestoneDraftArtifacts);
                    lCompletedMilestoneIDSet.add(lMilestone.id);
                    
                    
                        if(lMilestone.Complete__c == True){
                            listOfCompletedMilestones.add(lMilestone);
                            
                        }
                    

                    if(lProject == null) {
                        lProject = new Milestone1_Project__c(id=lMilestone.Project__c);
                        lIDToProjectMap.put(lMilestone.Project__c, lProject);
                    }
                    
                    lProject.Status__c='Active';
                    
                    if(lMilestone.Type__c == 'GFC') {
						lProject.Is_Project_Good_for_Construction__c = true;
                    }
                    
                    if(lMilestone.EligibleAmountPercentage__c != null && lMilestone.EligibleAmountPercentage__c > 0) {
                        lProject.Payment_Stage__c=lMilestone.EligibleAmountPercentage__c.intValue() + '%';
                    }
                }
            }
            
            lIndex++;
        }
        
        if(listOfCompletedMilestones.size() > 0) {
            //IncentivesUtility.createProjectIncentives(lCompletedMilestoneIDSet);
            IncentivesUtility.createProjectIncentivesForDesignPartners(listOfCompletedMilestones);
        }
        
        if(lFeedbackForInsertion.size() > 0) {
            insert lFeedbackForInsertion;
        }
        
        if(lArtifactsForUpdation.size() > 0) {
            update lArtifactsForUpdation;
        }
        
        if(lIDToProjectMap.size() > 0) {
            update lIDToProjectMap.values();
        }
    }
}