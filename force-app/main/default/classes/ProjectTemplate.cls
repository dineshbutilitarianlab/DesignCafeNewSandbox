public  class ProjectTemplate{
    public Id projectId {get;set;}
    
    public List<Milestone1_Milestone__c> getprojectActivities(){   
        List<Milestone1_Milestone__c> projectActivities;
        projectActivities = [SELECT Name,Assign_To__r.name, Kickoff__c,Deadline__c,Assign_To_Role__c FROM Milestone1_Milestone__c WHERE Assign_To_Role__c='Primary Designer' and Project__c =: projectId];
        return projectActivities;
    }
}