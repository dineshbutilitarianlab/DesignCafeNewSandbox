/*
Developer : Ankit Soni 
Created Date : 14 OCT 2019
Description : Project Management utility funtionalities. 
*/
public class ProjectManagementUtility {
    public static List<Milestone1_Project__c> cloneProject(List<Opportunity> oppts) {
        Decimal [] lProjectValues = new List<Decimal>();
        DateTime [] lSignUpDatesOfProjects = new List<DateTime>();
        List<Opportunity> oppList  = [SELECT id, Amount, CloseDate, Signup_Amount__c FROM Opportunity WHERE Id IN:oppts];
        
        for(Opportunity lOpp : oppList) {
            lProjectValues.add(lOpp.Amount);
            lSignUpDatesOfProjects.add(DateTime.newInstance(lOpp.CloseDate, Time.newInstance(10, 0, 0, 0)));
        }
        
        return cloneProject(oppts, lSignUpDatesOfProjects, lProjectValues);
    }
    
    public static List<Milestone1_Project__c> cloneProject(List<Opportunity> oppts, DateTime [] aSignUpDatesOfProjects, Decimal [] aProjectValues) {
        if(!Test.isRunningTest()) {
            System.enqueueJob(new ProjectCreationStep1Async(oppts[0].id, aSignUpDatesOfProjects[0], aProjectValues[0], oppts[0].Signup_Amount__c));
        }
        
        return new List<Milestone1_Project__c>();
    }
}