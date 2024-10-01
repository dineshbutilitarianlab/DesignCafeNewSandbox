@IsTest
public class PaymentTriggerHandlerTest {
    @isTest
    static void testPaymentTriggerHandlerTest() {
        // Create PersonAccount
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com');
        insert acc;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Design Partner'];
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
            teamAssinUser.Name='Design Partner Bengaluru';
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
            
            // Create project
            Id recordTypeId =Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
            /*NEW COMMENT
            Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Test Project');
            project.Region__c='Bengaluru';
            project.Customer__c=acc.id;
            project.Designer__c=u.Id;
            project.Amount__c = 100000;
            project.Signup_Amount__c = 5000;
            project.recordTypeId=recordTypeId;
            project.Design_Team_Name__c='WDC_1';
            insert project;
            // Create milestone
            Test.startTest();
            
            Milestone1_Milestone__c milestone = Milestone1_Test_Utility.sampleMilestone(project);
            milestone.EligibleAmountPercentage__c = 15;
            milestone.Type__c='Signup';
            insert milestone;
           NEW COMMENT */
            //Creat Custom Setting
            Incentive_Amount__c objIncentive = new Incentive_Amount__c();
            objIncentive.Name = 'Project Incentive';
            objIncentive.Project_Incentive__c = 6;
            insert objIncentive;
            
            Incentive_Amount__c objIncCG = new Incentive_Amount__c();
            objIncCG.Name = 'CGST';
            objIncCG.CGST__c = 6;
            insert objIncCG;
            
            Incentive_Amount__c objIncSG = new Incentive_Amount__c();
            objIncSG.Name = 'SGST';
            objIncSG.SGST__c = 10;
            insert objIncSG;
            
            // Create payment 
         //NEW COMMENT   System.debug('^^^ ' + [SELECT id, Name, Actual_Amount_Due__c FROM Milestone1_Milestone__c WHERE id=:milestone.id]);
            Payment__c objPayment = new Payment__c();
            objPayment.Mode__c='Cash';
          //NEW COMMENT   objPayment.Milestone__c=milestone.id;
            objPayment.Amount__c=15000;
            /*insert objPayment;
            
            objPayment.Mode__c='Card';
            try{
                update objPayment;
            }catch(Exception e){
                System.debug('update Exception occured');
            }
            
            try{
                delete objPayment;
            }catch(Exception e){
                System.debug('delete Exception occured');
            }*/
            
            
            Test.stopTest();
        }
    }
}