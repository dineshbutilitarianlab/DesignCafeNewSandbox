/*
*Created By     : 
*Created Date   : 10/12/2019
*Description    : Test Coverage For "Milestone1_GettingStartedController"
*Class Name     : Milestone1_GettingStartedController
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@isTest
public class Milestone1_GettingStartedController_Test {
    
    
    @isTest
    private static void testSetupStandardSettings() {        
        Test.startTest();
        Milestone1_GettingStartedController cont = new Milestone1_GettingStartedController();        
        cont.setupStandardSettings();
        Test.stopTest();        
    }    
    
    
    @isTest
    private static void testHandleGettingStartedProjectInitialization() {
        
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
       
        Milestone1_Milestone__c ms1 = new Milestone1_Milestone__c();
        ms1.Alias__c ='DEMO_1';
        ms1.type__c='KYC';
        ms1.Project__c = objProject.id;
        ms1.Kickoff__c = System.today();
        ms1.Deadline__c=Date.today().addDays(+5);
        insert ms1;
        ms1.Deadline__c=Date.today().addDays(+28);
        update ms1;
        
        Milestone1_Task__c task = new Milestone1_Task__c(); 
        task.Project_Milestone__c = ms1.Id;
        task.Start_Date__c = System.today().addDays(-5);
        task.Due_Date__c = System.today();
        task.Complete__c = true;
        
        
        insert task; 
                     
       
        Document doc = new Document();
        //MilestonShared Documentse1_XML_Import_Utility importObj = new Milestone1_XML_Import_Utility();
        Milestone1_XML_Export_Utility exportObj = new Milestone1_XML_Export_Utility();
        String ret = exportObj.buildProjectXmlString(objProject.id);
        //String ret = importObj.importProject(xmlString); 
        doc.Body = Blob.valueOf(ret);
        doc.ContentType = 'application/xml';
        doc.DeveloperName = 'Starter_Project_LPM1';
        doc.IsPublic = true;
        doc.Name = 'Starter Project (LPM1)';
        doc.FolderId = [select id from folder where name = 'Shared Documents'].id;
        insert doc;
        
        
        
        List<Milestone1_Milestone__c> objListMil = [Select id,(Select Id from Project_Tasks__r) from Milestone1_Milestone__c limit 1];
        System.debug('######objListMil####3 '+objListMil);
        System.debug('######objListMil####3 '+objListMil[0].Project_Tasks__r);
        Milestone1_GettingStartedController cont = new Milestone1_GettingStartedController();
        test.startTest();
        cont.handleGettingStartedProjectInitialization();
        test.stopTest();
        //System.assert(project != null);
        
    } 
    } 
}