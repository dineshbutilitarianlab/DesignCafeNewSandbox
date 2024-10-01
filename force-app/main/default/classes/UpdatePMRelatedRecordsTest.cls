@isTest
private class UpdatePMRelatedRecordsTest {
    @testSetup static void setup() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        System.runAs (thisUser) { 
            UserRole r = [SELECT Id FROM UserRole WHERE Name='Designer'];
            User designer = new User(ProfileId = [Select Id from profile where Name='Designer'].Id, LastName = 'last', Email = 'puser000@amamama.com',
                                     Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title',
                                     Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                                     LocaleSidKey = 'en_US', Region__c='Bengaluru', userroleid=r.id);
            
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Designer'];
            
            System.runAs(new User(id=UserInfo.getUserId())) {
                insert designer;
                insert new PermissionSetAssignment(AssigneeId = designer.id, PermissionSetId = ps.Id);
                
            }
            
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            
            Account a = new Account(LastName = 'TestAcct', PersonEmail = 'test@gmail.com', RecordTypeId  = devRecordTypeId);  
            insert a;
            
            Account a1 = new Account(LastName = 'TestAcct1', PersonEmail = 'test1@gmail.com', RecordTypeId  = devRecordTypeId);  
            insert a1;    
            
            List<Opportunity> testoppts = new List<Opportunity>();       
            testoppts.add(new Opportunity(Name = 'Testoppt', X1st_Meeting_Date__c= Date.today(),X1st_Meeting_Person__c= designer.Id, CloseDate = Date.today(), Amount=10000, AccountID = a.id, StageName = 'Closed Won', 
                                          Designer__c=designer.id));
            testoppts.add(new Opportunity(Name = 'Testoppt1', X1st_Meeting_Date__c= Date.today(),X1st_Meeting_Person__c= designer.Id, CloseDate = Date.today(), Amount=10000, AccountID = a1.id, StageName = 'Closed Won', 
                                          Designer__c=designer.id));    
            insert testoppts; 
            
            Id recordTypeId =Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Project_Template').getRecordTypeId();
            Milestone1_Project__c project = Milestone1_Test_Utility.sampleProjectActive('My Test Project');
            project.Region__c='Bengaluru';
            project.recordTypeId=recordTypeId;
            project.Design_Team_Name__c='WDC_1';
            project.Default_Template_Project__c = true;
            project.Project_Duration_in_days__c = 90;
            insert project;
            
            Id MileRTId =Schema.SObjectType.Milestone1_Milestone__c.getRecordTypeInfosByDeveloperName().get('Milestone_Template').getRecordTypeId();
            
            List<Milestone1_Milestone__c> miles = New List<Milestone1_Milestone__c>();
            Milestone1_Milestone__c m = Milestone1_Test_Utility.sampleMilestone(project);
            m.Name = 'Complete Customer Onboarding';
            m.recordTypeId=MileRTId;
            m.Relative_Kickoff_Date_in_days__c = 2;
            m.Relative_Deadline_in_days__c =  2;        
            miles.add(m);
            
            Milestone1_Milestone__c m1 = Milestone1_Test_Utility.sampleMilestone(project);
            m1.Name = 'Customer Site Survey';
            m1.recordTypeId=MileRTId;
            m1.Relative_Kickoff_Date_in_days__c = 2;
            m1.Relative_Deadline_in_days__c =  2; 
            miles.add(m1); 
            
            Milestone1_Milestone__c m2 = Milestone1_Test_Utility.sampleMilestone(project.Id , m1.Id, 'Create 3D Shell');
            m2.recordTypeId=MileRTId;
            m2.Relative_Kickoff_Date_in_days__c = 2;
            m2.Relative_Deadline_in_days__c =  2; 
            miles.add(m2);
            
            Milestone1_Milestone__c m3 = Milestone1_Test_Utility.sampleMilestone(project.Id , m.Id, 'Know Your Client (KYC)');        
            m3.recordTypeId=MileRTId;
            m3.Relative_Kickoff_Date_in_days__c = 2;
            m3.Relative_Deadline_in_days__c =  2;
            
            miles.add(m3);  
            
            Milestone1_Milestone__c m4 = Milestone1_Test_Utility.sampleMilestone(project.Id , m3.Id, 'First Cut Presentation');        
            m4.recordTypeId=MileRTId;
            m4.Relative_Kickoff_Date_in_days__c = 2;
            m4.Relative_Deadline_in_days__c =  2; 
            miles.add(m4);
            
            Milestone1_Milestone__c m5 = Milestone1_Test_Utility.sampleMilestone(project.Id , m4.Id, 'Second Cut Presentation');        
            m5.recordTypeId=MileRTId;
            m5.Relative_Kickoff_Date_in_days__c = 2;
            m5.Relative_Deadline_in_days__c =  2; 
            miles.add(m5);        
            
            Milestone1_Milestone__c m6 = Milestone1_Test_Utility.sampleMilestone(project.Id , m5.Id, 'Design Finalization - Payment Checkpoint');        
            m6.recordTypeId=MileRTId;
            m6.Relative_Kickoff_Date_in_days__c = 2;
            m6.Relative_Deadline_in_days__c =  2; 
            miles.add(m6);
            
            Milestone1_Milestone__c m7 = Milestone1_Test_Utility.sampleMilestone(project.Id , m6.Id, 'Design Finalization');        
            m7.recordTypeId=MileRTId;
            m7.Relative_Kickoff_Date_in_days__c = 2;
            m7.Relative_Deadline_in_days__c =  2;
            miles.add(m7);
            
            insert miles;
            
            List<CSVDataToUpdate__c> csvlist = new List<CSVDataToUpdate__c>();
            CSVDataToUpdate__c data1 = new CSVDataToUpdate__c();
            data1.Fifteen_percent_amount_paid__c = 15000; 
            data1.Fifteen_Percent_amount_paid_date_if_done__c = Date.today(); 
            data1.Three_d_presentation_date_if_done__c = Date.today(); 
            data1.Five_Percent_Amount_paid__c = 5000;              
            data1.Customer_email__c = 'test@gmail.com'; 
            data1.Customer_Name__c = 'test';            
            data1.Design_sign_off_date__c = Date.today();            
            data1.Designer_email_ID__c = 'puser000@amamama.com';            
            data1.First_cut_presentation_date_if_done__c = Date.today(); 
            data1.Person_Account_ID__c = a.Id;              
            data1.Sign_up_date__c = Date.today(); 
            data1.Sign_up_project_value__c = 100000;
            data1.Designer__c = designer.id;
            data1.City__c = 'Bengaluru';       
            csvlist.add(data1); 
            /*
CSVDataToUpdate__c data2 = new CSVDataToUpdate__c();
//data1.Fifteen_percent_amount_paid__c = 15000; 
//data1.Fifteen_Percent_amount_paid_date_if_done__c = Date.today(); 
data2.Three_d_presentation_date_if_done__c = Date.today(); 
data2.Five_Percent_Amount_paid__c = 5000;              
data2.Customer_email__c = 'test@gmail.com'; 
data2.Customer_Name__c = 'test';            
data2.Design_sign_off_date__c = Date.today();            
data2.Designer_email_ID__c = 'puser000@amamama.com';            
data2.First_cut_presentation_date_if_done__c = Date.today(); 
data2.Person_Account_ID__c = a.Id;              
data2.Sign_up_date__c = Date.today(); 
data2.Sign_up_project_value__c = 100000;

csvlist.add(data2); */   
            insert csvlist;
        }
    }
    
    static testMethod void testMethod1() {  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        System.runAs (thisUser) { 
            Test.StartTest();            
            ID batchprocessid = Database.executeBatch(new UpdatePMRelatedRecords(), 1);           
            Test.StopTest();
            new UpdatePMRelatedRecords(false, false, false);
        }
    }
    
    
    
}