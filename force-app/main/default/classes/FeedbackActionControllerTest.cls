/*
Developer : Jai Kumar 
Created Date :  16 Dec 2019
Description : Test class for FeedbackActionController class.
*/

@isTest
private class FeedbackActionControllerTest {
    
    @testSetup
    private static void feedbackSetup(){
        Id FeedbackRecTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Customer Feedback Closed').getRecordTypeId();  
        
        //Create PersonAccount
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
        insert acc;
          User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name='CHM'];
        System.runAs (thisUser) { 
        User u = new User(
                         ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         Region__c='Bengaluru',
                         userroleid=r.id
                         );
        insert u;
        UserRole rSurvy = [SELECT Id FROM UserRole WHERE Name='Survey Team'];
        User uSurvy = new User(
                         ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         Region__c='Bengaluru',
                         userroleid=rSurvy.id
                         );
         insert uSurvy;
         UserRole r3D = [SELECT Id FROM UserRole WHERE Name='3D Shell Designer'];
         User u3D = new User(
                         ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         Region__c='Bengaluru',
                         userroleid=r3D.id,
                         Team__c='WDC_1'
                         );
         insert u3D;
         UserRole rPM = [SELECT Id FROM UserRole WHERE Name='Project Manager'];
         User uPM = new User(
                         ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         Region__c='Bengaluru',
                         userroleid=rPM.id
                         );
        insert uPM;
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
            Virtual_Account_Number__c vanObj=new Virtual_Account_Number__c();
            vanObj.Status__c='Available';
            vanObj.VAN__c='12345';
            insert vanObj;
          
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
        // Create project
        Milestone1_Project__c project = new Milestone1_Project__c(Name = 'test',Virtual_Account_Number__c=vanObj.id,Customer__c = acc.Id,RecordTypeId = projectRecordTypeId );
        insert project;
        
        // Create Milestone
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id);
        insert milestone;
            
        List<Project_Artifact__c> arlist= [select id from Project_Artifact__c where Status__c = 'Draft' AND Project_Milestone__c = :milestone.id];    
        if(arlist != NULL && arlist.size()>0)
           delete arlist;
            
        Project_Artifact__c  proArtifact = new Project_Artifact__c(Project__c = project.id,Project_Milestone__c = milestone.id ,Status__c = 'Draft');
        insert proArtifact;
        
        Feedback__c feedback = new Feedback__c();          
        feedback.Project__c = project.Id;
        feedback.Project_Artifact__c = proArtifact.Id;
        feedback.RecordTypeId = FeedbackRecTypeId;
        insert feedback;
    }
    }
    
    // positive testing    
    @isTest
    private static void feedbackResponseTest(){        
        Feedback__c fb = [select Id from Feedback__c Limit 1];        
        Test.startTest();
        FeedbackActionController.feedbackResponse(fb.Id, 'testing the positive feedback', 'Yes', '5*');
        
        Feedback__c fbUpdate = [select Id, comments__c from Feedback__c Limit 1];        
        String comments = fbUpdate.Comments__c;
        System.assertEquals(comments, 'testing the positive feedback');        
        Test.stopTest();                 
    }
    
    // negative testing    
    @isTest
    private static void feedbackResponseExceptionTest(){
        Feedback__c fb = [select Id from Feedback__c Limit 1];
        Test.startTest();
        try{
            FeedbackActionController.feedbackResponse(fb.Id, 'testing the exception feedback', 'No', '5*');        
        }catch(Exception e){
            System.debug('Exception Occured --- ' + e.getMessage());
            System.assertEquals(e.getMessage(), 'Script-thrown exception');        
        }        
        Test.stopTest();
    }    
}