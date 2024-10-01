/*
*Created By     : 
*Created Date   : 09/12/2019
*Description    : Test Coverage For "ProjectActivityHandler"
*Class Name     : ProjectActivityHandler
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@isTest
public class ProjectActivityHandler_Test {
    
    @isTest
    static void ProjectActivityHandler_Customer(){
       String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        Account acc= new Account(
          RecordTypeID=recordTypeId ,
          FirstName='TesFName',
          LastName='TesLName',
          PersonMailingStreet='test@yahoo.com',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='12345Project67',
          PersonMobilePhone='12345678' 
        );
 
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
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
        Milestone1_Project__c objProject = new Milestone1_Project__c();
        objProject.Name = 'Project';
        objProject.RecordTypeId = projRecordTypeId;
        objProject.Virtual_Account_Number__c = vac.id;
        objProject.Customer__c=acc.id;
        insert objProject;
        
       Milestone1_Milestone__c mStone = new Milestone1_Milestone__c();
        mStone.Name = '';                                    
        mStone.Project__c = objProject.Id;
        mStone.Assign_To_Role__c = 'Customer Happiness Manager';
        mStone.Type__c = 'Default';
        mStone.Relative_Kickoff_Date_in_days__c = 6;
        mStone.Relative_Deadline_in_days__c = 4;
        insert mStone;
        
        
        account objAcct=[select id, personContactId from account where id =:objProject.Customer__c]; 
        Milestone1_Milestone__c mStoneObj=[select id,Customer_Contact__c from Milestone1_Milestone__c where id =:mStone.id] ;
        
      System.AssertEquals(mStoneObj.Customer_Contact__c,objAcct.personContactId);   //                                                    
    }
     @isTest
    static void updateSuccessorMilestonePlannedDate(){
       String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        Account acc= new Account(
          RecordTypeID=recordTypeId ,
          FirstName='TesFName',
          LastName='TesLName',
          PersonMailingStreet='test@yahoo.com',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='12345Project67',
          PersonMobilePhone='12345678' 
        );
 
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
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
        Milestone1_Project__c objProject = new Milestone1_Project__c();
        objProject.Name = 'Project';
        objProject.RecordTypeId = projRecordTypeId;
        objProject.Virtual_Account_Number__c = vac.id;
        objProject.Customer__c=acc.id;
        objProject.Kickoff__c = date.today();
        insert objProject;
        
       Milestone1_Milestone__c mStone = new Milestone1_Milestone__c();
        mStone.Name = 'Test';                                    
        mStone.Project__c = objProject.Id;
        mStone.Assign_To_Role__c = 'Customer Happiness Manager';
        mStone.Type__c = 'KYC'; 
        mStone.Actual_Completion_Date__c= date.today().addDays(7) ;     
        mStone.Deadline__c=date.today().addDays(4);
        mStone.Kickoff__c=date.today();
        mStone.Relative_Deadline_in_days__c = 5;
        mStone.Complete__c=true;
        mStone.Order__c=1;
        insert mStone;
        
        Milestone1_Milestone__c mStonechil = new Milestone1_Milestone__c();
        mStonechil.Name = 'Test';                                    
        mStonechil.Project__c = objProject.Id;
        mStonechil.Assign_To_Role__c = 'Customer Happiness Manager';
        mStonechil.Type__c = 'First Cut Presentation'; 
        mStonechil.Actual_Completion_Date__c= date.today().addDays(7) ;     
        mStonechil.Deadline__c=date.today().addDays(4);
        mStonechil.Kickoff__c=date.today();
        mStonechil.Relative_Deadline_in_days__c = 5;
        mStonechil.Order__c=2;
        insert mStonechil;
       
        
        mStone.Actual_Completion_Date__c= date.today().addDays(9) ;
       // Test.StartTest();
         update mStone;
        // Test.StopTest();
                                                         
    }
}