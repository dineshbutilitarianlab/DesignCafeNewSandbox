/*
*Created By     : 
*Created Date   : 09/12/2019
*Description    : Test Coverage For "FeedbackTrigger"
*Class Name     : FeedbackTriggerHelper
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@IsTest
public class FeedbackTrigger_Test{
 @IsTest
    static void testFeedbackTriggerHelper() {
             Id FeedbackRecTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Customer Feedback Closed').getRecordTypeId();  
        
            // Create a account 
            String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeID=recordTypeId);
            insert acc;
        TeamUserAssignmentNumber__c teamAssinUser=new TeamUserAssignmentNumber__c();
        teamAssinUser.Name='Customer Happiness Manager Bengaluru';
        teamAssinUser.LastAssignedUserNumber__c=594;
        insert teamAssinUser;
        
        TeamUserAssignmentNumber__c teamAssinUserSurvey=new TeamUserAssignmentNumber__c();
        teamAssinUserSurvey.Name='Survey Manager Bengaluru';
        teamAssinUserSurvey.LastAssignedUserNumber__c=594;
        insert teamAssinUserSurvey;
        
        TeamUserAssignmentNumber__c teamAssinUser3D=new TeamUserAssignmentNumber__c();
        teamAssinUser3D.Name='3D Shell Designer Bengaluru';
        teamAssinUser3D.LastAssignedUserNumber__c=594;
        insert teamAssinUser3D;
        
        TeamUserAssignmentNumber__c teamAssinUserPM=new TeamUserAssignmentNumber__c();
        teamAssinUserPM.Name='Project Manager Bengaluru';
        teamAssinUserPM.LastAssignedUserNumber__c=594;
        insert teamAssinUserPM;
        
         Virtual_Account_Number__c vac = new Virtual_Account_Number__c();
        vac.Name = 'VAN5';
        vac.Status__c = 'Available';
        vac.VAN__c = '2628';
        Insert vac;
           // Create a poject
            Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
            Milestone1_Project__c objProject = new Milestone1_Project__c();
            objProject.Name = 'Project';
            objProject.Customer__c=acc.id;
            objProject.RecordTypeId = projRecordTypeId;
            objProject.Virtual_Account_Number__c = vac.id;
            insert objProject;
        
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = objProject.id,Type__c='KYC');
        insert milestone;
        
        Project_Artifact__c  proArtifact = new Project_Artifact__c(Project__c = objProject.id,Project_Milestone__c = milestone.id ,Status__c = 'Published');
        insert proArtifact;
        
        Feedback__c feedback = new Feedback__c();          
        feedback.Project__c = objProject.Id;
        feedback.Project_Artifact__c = proArtifact.Id;
        feedback.RecordTypeId = FeedbackRecTypeId;
        insert feedback;
     } 
 }