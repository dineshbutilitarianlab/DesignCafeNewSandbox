@isTest
public class RevisitSharingOnProjectClsTest {
     
    @testSetup static void setup() {
      
        //User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        
        //System.runAs (thisUser) { 
        UserRole r3D = [SELECT Id FROM UserRole WHERE Name='Designer'];
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
                         Team__c='Bengaluru-DP-1'
                         );
         insert u3D;
                     
         
             
        //}  
    }
    @isTest static void testMethod1() {
        User u3D = [select id,name from user where LastName = 'last' limit 1];
        // Create PersonAccount
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
        insert acc;
        
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
          Milestone1_Project__c objProject = new Milestone1_Project__c();
          objProject.Name = 'Project';
          objProject.RecordTypeId = projRecordTypeId;
          //objProject.Virtual_Account_Number__c = vanObj.id;
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
        
        //Milestone1_Project__c prj = [select id,name,Designer__c, Designer_Team__c,Design_Team_Name__c from Milestone1_Project__c where Name = 'Project' limit 1];
        Test.startTest();
            RevisitSharingOnProjectCls.deleteOldTLGroup(objProject.Id);
            RevisitSharingOnProjectCls.sharingOnProjectforDesigner(objProject.Id);
        Test.stopTest();
    }
 
}