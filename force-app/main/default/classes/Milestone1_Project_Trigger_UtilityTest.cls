@IsTest
public class Milestone1_Project_Trigger_UtilityTest {
    @IsTest
    private static void testhandleProjectUpdateTriggerCHM(){
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
         
        Id recordTypeId =Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
          Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Test Project');
          project.Region__c='Bengaluru';
          project.recordTypeId=recordTypeId;
            project.Survey_Date__c=System.today();
            project.KYC_Date__c=system.today();
            project.Survey_Date__c=system.today();
          project.Design_Team_Name__c='WDC_1';
          insert project;
            
            List<Milestone1_Milestone__c> mileStonesList = new List<Milestone1_Milestone__c>();
        
      
            Milestone1_Milestone__c mileStone = new Milestone1_Milestone__c();
            mileStone = Milestone1_Test_Utility.sampleMilestone(project.Id, null, 'My Parent Milestone ' ) ; 
            mileStone.Kickoff__c = System.today();
            mileStone.Deadline__c = System.today()+10;          
            mileStone.Actual_Completion_Date__c = System.today()+28;
            //mileStonesList.add(mileStone);
            mileStone.Type__c='Site Survey';
            insert mileStone;
        
			//insert mileStonesList;    
          	project.OwnerId=u3D.id;
            project.Survey_Date__c=System.today()+20;  
            project.KYC_Date__c=system.today()+20;
          	Update project;
          
           project.Survey_Date__c=System.today()+25;  
           project.KYC_Date__c=system.today()+20;
           Update project;
            
                      
        }   
    }
    /**
    * Test milestone delete
    */
  /*    @IsTest
    private static void testHandleProjectDeleteTrigger(){
        // Create project
        Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Test Project');
        insert project;
       
        Milestone1_Project__c projecttest = Milestone1_Test_Utility.sampleProject('My Test Project');
        insert projecttest;
       
        // Create milestones
       Milestone1_Milestone__c mList =Milestone1_Test_Utility.sampleMilestone(project.Id, null, 'My Test Milestone ');
       insert mList;
       mList.Deadline__c=date.today().addDays(+5);
       update mList;
 
        List<Milestone1_Project__c> recs = new List<Milestone1_Project__c>();
        recs.add(project);
        recs.add(projecttest);
         
      
        try{
         // Delete and check if it was successful
         delete project;
           
            Test.startTest();
            Milestone1_Project_Trigger_Utility.handleProjectDeleteTrigger(recs);
            Test.stopTest();
            
        //    system.assertEquals(0, [SELECT count() FROM Milestone1_Milestone__c WHERE Project__c = :project.Id]);
        }
        catch(Exception e){
        //    undelete project;
            system.assert( true, e.getMessage() );
        }
    }*/
  
   
}