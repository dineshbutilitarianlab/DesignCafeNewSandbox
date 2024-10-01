@isTest
public class InvoicePdfController_Test {
    @TestSetup
    static void dataSetup() {
        Application_Settings__c [] lSettings = new List<Application_Settings__c> {
            new Application_Settings__c(Name='AES_KEY', Value__c='psD7pwTIAAvhEx2jy0CtBg=='),
			new Application_Settings__c(Name='PAYMENT_URL', Value__c='https://uat-designcafe.cs112.force.com/Customer/s/checkout?'),
			new Application_Settings__c(Name='RZRPAY_KEY', Value__c='rzp_test_bG19kIRBdiCipf'),
			new Application_Settings__c(Name='RZRPAY_TOKEN', Value__c='gMdBglrZZfqn8AEzHY2lTNwE')
        };
		
		insert lSettings;
    }
    
    @isTest
    static void InvoicePdfController_UnitTest() {
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();  
        Account acc = new Account();
        acc.LastName = 'DemoTest';
        acc.PersonEmail = 'test@gmail.com';
        acc.BillingStreet = 'A76New Ashok Nagar';
        acc.BillingCity = 'Noida';
        acc.BillingState = 'Delhi';
        acc.BillingPostalCode = '123123';
        acc.GST_No__c = 'ABC123';
        acc.recordTypeId = RecordTypeIdAccount;
        insert acc;
        
        Virtual_Account_Number__c vanObj=new Virtual_Account_Number__c();
        vanObj.Status__c='Available';
        vanObj.VAN__c='12345';
        insert vanObj;
        
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
            
            Id recordTypeId =Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
            Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Test Project');
            project.Region__c='Bengaluru';
            project.recordTypeId=recordTypeId;
            project.Design_Team_Name__c='WDC_1';
            Test.StartTest(); 
            insert project;
            
            Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id);
            insert milestone;
            
            Invoice__c inv = new Invoice__c();
            inv.Project__c = project.id;
            inv.Amount__c = 5;
            inv.Milestone__c = milestone.Id;
            inv.Customer__c = acc.Id;
            inv.CHM_Email__c = 'test@gmail.com';
            inv.Designer_Email__c='test1@gmail.com';
            insert inv;

            //ApexPages.currentPage().getParameters().put('id',inv.id);
            PageReference myVfPage = Page.Showing_Invoice_Details;
            myVfPage.getParameters().put('id',inv.id);
            Test.setCurrentPage(myVfPage);
            ApexPages.StandardController sc = new ApexPages.StandardController(inv);
            InvoicePdfController objInvPdf = new InvoicePdfController(sc);
            Test.StopTest();
        }
    }
}