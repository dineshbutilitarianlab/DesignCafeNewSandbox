public class ProjectCreationUtility {
    public static Milestone1_Project__c getTemplateProject() {
        return [SELECT Id, Name, Project_Duration_in_days__c, Offers_and_Discounts__c,Total_Hours_Budget__c,
                Total_Expense_Budget__c, First_Cut_Presentation_Date__c, X3D_Presentation_Date__c, 
                Design_Finalization_Date__c FROM Milestone1_Project__c WHERE Default_Template_Project__c = true AND
                RecordType.DeveloperName='Project_Template' LIMIT 1];        
    }
    
    public static List<Milestone1_Milestone__c> getTemplateMilestones() {
        return [SELECT Id, Name, Type__c, EligibleAmountPercentage__c, Project__c, Assign_To_Role__c, Hours_Budget__c, 
                MilestoneTemplateSFID__c,Predecessor_Milestone__c,Successor_Milestone__c,Expense_Budget__c,Description__c,
                Collectable_Amount_Percent_Before_This__c, Order__c,Complete__c,
                Previous_Payment_Milestone__c,Relative_Deadline_in_days__c,Relative_Kickoff_Date_in_days__c FROM Milestone1_Milestone__c 
                WHERE Project__r.Default_Template_Project__c = true AND
                Project__r.RecordType.DeveloperName='Project_Template'];
    }
    
    public static void deleteProject(ID aProjectID) {
        Milestone1_Project__c [] lProject = [SELECT id FROM Milestone1_Project__c WHERE id=:aProjectID];
        
        if(!lProject.isEmpty()) {
            If(!Test.isRunningTest()) { 
             delete lProject;
            }
           
        }
    }
}