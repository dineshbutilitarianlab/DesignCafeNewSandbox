/*
*Created By     : 
*Created Date   : 09/12/2019
*Description    : Test Coverage For "ProjectTeamMemberHandler"
*Class Name     : ProjectTeamMemberHandler
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@isTest
public class ProjectTeamMemberHandler_Test {
    
   @isTest
    static void updateManagerAndCustomer(){
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
         Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test1', Project__c = objProject.id, type__c='KYC');
         insert milestone;
           
          Contact con = new Contact();
          con.LastName = 'Team';
          insert con;
          
          Project_Team_Member__c objProjTeam = new Project_Team_Member__c();
           objProjTeam.Project__c = objProject.Id;
           objProjTeam.User__c = u3D.Id;
           objProjTeam.Role__c = 'Customer Happiness Manager';
           objProjTeam.Customer_Contact__c = con.Id;
           insert objProjTeam;
           Case objCase = new Case();
            objCase.AccountId=acc.id;
            objCase.Project__c=objProject.id;
            objCase.Status = 'New';
            objCase.Origin = 'Web'; 
            objCase.Priority = 'Medium'; 
            insert objCase; 
           objProjTeam.User__c = uPM.Id;
           //objProjTeam.Role__c == 'Primary Designer';
          Test.startTest();
            update objProjTeam;
           Test.stopTest();
             
        }   
    }
    @isTest
    static void updateManagerAndCustomerPD(){
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
         Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test1', Project__c = objProject.id, type__c='KYC');
         insert milestone;
           
          Contact con = new Contact();
          con.LastName = 'Team';
          insert con;
          
          Project_Team_Member__c objProjTeam = new Project_Team_Member__c();
           objProjTeam.Project__c = objProject.Id;
           objProjTeam.User__c = u3D.Id;
           objProjTeam.Role__c = 'Primary Designer';
           objProjTeam.Customer_Contact__c = con.Id;
           insert objProjTeam;
        
           objProjTeam.User__c = uPM.Id;
           //objProjTeam.Role__c == 'Primary Designer';
           Test.startTest();
           update objProjTeam; 
         Test.stopTest();
        }   
    }
  @isTest
    static void updateManagerAndCustomer3D(){
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
         Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test1', Project__c = objProject.id, type__c='KYC');
         insert milestone;
           
          Contact con = new Contact();
          con.LastName = 'Team';
          insert con;
          
          Project_Team_Member__c objProjTeam = new Project_Team_Member__c();
           objProjTeam.Project__c = objProject.Id;
           objProjTeam.User__c = u3D.Id;
           objProjTeam.Role__c = '3D Designer';
           objProjTeam.Customer_Contact__c = con.Id;
           insert objProjTeam;
        
           objProjTeam.User__c = uPM.Id;
           //objProjTeam.Role__c == 'Primary Designer';
          Test.startTest();
            update objProjTeam; 
         Test.stopTest();
        }   
    }
  @isTest
    static void updateManagerAndCustomerPM(){
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
         Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test1', Project__c = objProject.id, type__c='KYC');
         insert milestone;
           
          Contact con = new Contact();
          con.LastName = 'Team';
          insert con;
          
          Project_Team_Member__c objProjTeam = new Project_Team_Member__c();
           objProjTeam.Project__c = objProject.Id;
           objProjTeam.User__c = u3D.Id;
           objProjTeam.Role__c = 'Project Manager';
           objProjTeam.Customer_Contact__c = con.Id;
           insert objProjTeam;
        
           objProjTeam.User__c = uPM.Id;
           //objProjTeam.Role__c == 'Primary Designer';
           Test.startTest();
           update objProjTeam; 
            Test.stopTest();
         
        }   
    }
  
}