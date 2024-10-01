/*
*Created By     : 
*Created Date   : 09/12/2019
*Description    : Test Coverage For "TaskHandler"
*Class Name     : TaskHandler
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@isTest
public class TaskHandler_Test {
    
    @isTest
    static void TaskHandlerCreateTask(){
       // Create PersonAccount
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
      Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
       Milestone1_Project__c objProject = new Milestone1_Project__c();
       objProject.Name = 'Project';
       objProject.RecordTypeId = projRecordTypeId;
       objProject.Virtual_Account_Number__c = vanObj.id;
       objProject.Customer__c=acc.id;
       insert objProject; 
       
       Id mStoneRecordTypeId = Schema.SObjectType.Milestone1_Milestone__c.getRecordTypeInfosByName().get('Project Milestone Template').getRecordTypeId(); 
       Milestone1_Milestone__c objMStone = new Milestone1_Milestone__c();
         objMStone.recordTypeId = mStoneRecordTypeId;
         objMStone.Name = 'Project M_Stone';
         objMStone.Assign_To_Role__c = 'Customer Happiness Manager';
         objMStone.Type__c = 'KYC';
         objMStone.Assign_To__c=UserInfo.getUserId();
         objMStone.Relative_Kickoff_Date_in_days__c = 6;
         objMStone.Relative_Deadline_in_days__c = 4;
         objMStone.Project__c = objProject.Id;
         objMStone.Deadline__c=date.today();
         insert objMStone;
    }
    }
    @isTest
    static void TaskHandlerUpdateTask(){
      // Create PersonAccount
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
      Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
       Milestone1_Project__c objProject = new Milestone1_Project__c();
       objProject.Name = 'Project';
       objProject.RecordTypeId = projRecordTypeId;
       objProject.Virtual_Account_Number__c = vanObj.id;
       objProject.Customer__c=acc.id;
       insert objProject; 
       
       Id mStoneRecordTypeId = Schema.SObjectType.Milestone1_Milestone__c.getRecordTypeInfosByName().get('Project Milestone Template').getRecordTypeId(); 
       Milestone1_Milestone__c objMStone = new Milestone1_Milestone__c();
         objMStone.recordTypeId = mStoneRecordTypeId;
         objMStone.Name = 'Project M_Stone';
         objMStone.Assign_To_Role__c = 'Customer Happiness Manager';
         objMStone.Type__c = 'KYC';
         objMStone.Assign_To__c=UserInfo.getUserId();
         objMStone.Relative_Kickoff_Date_in_days__c = 6;
         objMStone.Relative_Deadline_in_days__c = 4;
         objMStone.Project__c = objProject.Id;
         objMStone.Deadline__c=date.today();
         insert objMStone;
         
         objMStone.Deadline__c=date.today().addDays(+2);
         update objMStone;
         system.assertNotEquals(date.today(),objMStone.Deadline__c);
         
         
    }
   } 
}