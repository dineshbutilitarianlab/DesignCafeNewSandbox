global class ProjectTeamMemberShareBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    global List<Id> projectList;
    
    global  ProjectTeamMemberShareBatch(List<Id> projectList){
        This.projectList = projectList;
    } 
    
    global Database.querylocator start(Database.BatchableContext BC){
        String query ='SELECT id, (select id,Project__c from Project_Team_Members__r) FROM Milestone1_Project__c where Id IN :projectList';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
       
        for(sObject s : scope){
            Milestone1_Project__c data = (Milestone1_Project__c)s;
            ProjectTeamMemberHandler.shareRecordDefaultProjectGroup(data.Project_Team_Members__r);
        }
        
    }
    global void finish(Database.BatchableContext BC){     
    }
}