@isTest
public class projectCreationAsyncTest {
    
    @isTest(SeeAllData=true)
    
    static void Testcreateproject(){
        Account a = new Account();
        a.Name = 'TestAcount';
        a.Acc_Email__c = 'test@gmail.com';
        insert a;
        Opportunity opp = new Opportunity();
        opp.Name='test opp';
        opp.StageName='IsWon';
        opp.AccountId = a.Id;
        opp.Amount= 100000.00;
        opp.Signup_Amount__c = 5000.00;
        opp.CloseDate = system.today();
        opp.Meeting_Venue__c = 'Bengaluru';
        insert opp;
        
        ProjectCreationStep1Async pasync = new ProjectCreationStep1Async(opp.Id, opp.CloseDate, opp.Amount, opp.Signup_Amount__c);
        
        pasync.execute(null);
        
    }
    @isTest(SeeAllData=true)
    
    static void projectCreationAsync2Test(){
        Opportunity opp = new Opportunity();
        opp.Name='test opp1';
        opp.StageName='IsWon';
        
        opp.Amount= 100000.00;
        opp.Signup_Amount__c = 5000.00;
        opp.CloseDate = system.today();
        opp.Meeting_Venue__c = 'Bengaluru';
        insert opp;
        Milestone1_Project__c testProj = new Milestone1_Project__c();
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Project_Template').getRecordTypeId();
        testProj.Opportunity__c = opp.Id;
        testProj.Name = 'test project';
        testProj.Amount__c = opp.Amount;
        testProj.Signup_Amount__c =opp.Signup_Amount__c;
        testProj.Region__c = opp.Region__c;
        testProj.Kickoff__c =system.today();
        testProj.Deadline__c = system.today()+90;
        testProj.Project_Duration_in_days__c = 90;
        testProj.Survey_Date__c = system.today() + 2;
        testProj.KYC_Date__c = system.today() + 7;
        testProj.First_Cut_Presentation_Date__c = system.today() + 12;
        testProj.X3D_Presentation_Date__c = system.today() + 31;
        testProj.Kickoff_Meeting_Date__c = system.today() + 47;
        testProj.Design_Finalization_Date__c = system.today() + 21;
        testProj.RecordTypeId = projRecordTypeId;
        testProj.Default_Template_Project__c = true;
        testproj.Total_Expense_Budget__c = 100000.00;
        testproj.Offers_and_Discounts__c ='5% Discount';
        
        insert testProj;
        
        ProjectCreationStep2Async pasync2= new ProjectCreationStep2Async(testProj.Id);
        pasync2.execute(null);
        
        
    }
    @isTest(SeeAllData=true)
    
    static void projectCreationAsync3Test(){
        Opportunity opp = new Opportunity();
        opp.Name='test opp1';
        opp.StageName='IsWon';
        opp.Amount= 100000.00;
        opp.Signup_Amount__c = 5000.00;
        opp.CloseDate = system.today();
        opp.Meeting_Venue__c = 'Bengaluru';
        insert opp;
        Milestone1_Project__c testProj = new Milestone1_Project__c();
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Project_Template').getRecordTypeId();
        testProj.Opportunity__c = opp.Id;
        testProj.Name = 'test project';
        testProj.Amount__c = opp.Amount;
        testProj.Signup_Amount__c =opp.Signup_Amount__c;
        testProj.Region__c = opp.Region__c;
        testProj.Kickoff__c =system.today();
        testProj.Deadline__c = system.today()+90;
        testProj.Project_Duration_in_days__c = 90;
        testProj.Survey_Date__c = system.today() + 2;
        testProj.KYC_Date__c = system.today() + 7;
        testProj.First_Cut_Presentation_Date__c = system.today() + 12;
        testProj.X3D_Presentation_Date__c = system.today() + 31;
        testProj.Kickoff_Meeting_Date__c = system.today() + 47;
        testProj.Design_Finalization_Date__c = system.today() + 21;
        testProj.RecordTypeId = projRecordTypeId;
        testProj.Default_Template_Project__c = true;
        testproj.Total_Expense_Budget__c = 100000.00;
        testproj.Offers_and_Discounts__c ='5% Discount';
        
        insert testProj;
        
        Id milesRecordTypeId = Schema.SObjectType.Milestone1_Milestone__c.getRecordTypeInfosByDeveloperName().get('Project_Milestone').getRecordTypeId();
        Milestone1_Milestone__c mStone = new Milestone1_Milestone__c();
        mStone.Name = 'Test';                                    
        mStone.Project__c = testProj.Id;
        mStone.Assign_To_Role__c = 'Customer Happiness Manager';
        mStone.Type__c = 'Customer Onboarding'; 
        mStone.Actual_Completion_Date__c= date.today().addDays(7) ;     
        mStone.Deadline__c=date.today().addDays(2);
        mStone.Kickoff__c=date.today();
        mStone.Relative_Deadline_in_days__c = 5;
        mStone.Complete__c=true;
        mStone.Order__c=1;
        
        mStone.RecordTypeId = milesRecordTypeId;
        insert mStone;
        
        
        Milestone1_Milestone__c mStone1 = new Milestone1_Milestone__c();
        mStone1.Name = 'Test1';                                    
        mStone1.Project__c = testProj.Id;
        mStone1.Assign_To_Role__c = 'Customer Happiness Manager';
        mStone1.Type__c = 'KYC'; 
        mStone1.Actual_Completion_Date__c= date.today().addDays(7) ;     
        mStone1.Deadline__c=date.today().addDays(4);
        mStone1.Kickoff__c=date.today();
        mStone1.Relative_Deadline_in_days__c = 5;
        mStone1.Complete__c=true;
        mStone1.Order__c=2;
        mStone1.Previous_Payment_Milestone__c = mStone.Id;
        mStone1.EligibleAmountPercentage__c =2.2;
        mStone1.RecordTypeId = milesRecordTypeId;
        
        insert mStone1;
        
        Milestone1_Milestone__c mStonechil = new Milestone1_Milestone__c();
        mStonechil.Name = 'Test2';                                    
        mStonechil.Project__c = testProj.Id;
        mStonechil.Assign_To_Role__c = 'Customer Happiness Manager';
        mStonechil.Type__c = 'First Cut Presentation'; 
        mStonechil.Actual_Completion_Date__c= date.today().addDays(9) ;     
        mStonechil.Deadline__c=date.today().addDays(4);
        mStonechil.Kickoff__c=date.today();
        mStonechil.Relative_Deadline_in_days__c = 5;
        mStonechil.Order__c=3;
        
        
        mStonechil.RecordTypeId =  milesRecordTypeId;
        insert mStonechil;
        
        ProjectCreationStep3Async pasync3= new ProjectCreationStep3Async(testProj.Id);
        pasync3.execute(null);
        
    }
    @isTest(SeeAllData=true)
    static void projectCreationAsync4Test(){
        Opportunity opp = new Opportunity();
        opp.Name='test opp1';
        opp.StageName='IsWon';
        opp.Amount= 100000.00;
        opp.Signup_Amount__c = 5000.00;
        opp.CloseDate = system.today();
        opp.Meeting_Venue__c = 'Bengaluru';
        insert opp;
        Milestone1_Project__c testProj = new Milestone1_Project__c();
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Project_Template').getRecordTypeId();
        testProj.Opportunity__c = opp.Id;
        testProj.Name = 'test project';
        testProj.Amount__c = opp.Amount;
        testProj.Signup_Amount__c =opp.Signup_Amount__c;
        testProj.Region__c = opp.Region__c;
        testProj.Kickoff__c =system.today();
        testProj.Deadline__c = system.today()+90;
        testProj.Project_Duration_in_days__c = 90;
        testProj.Survey_Date__c = system.today() + 2;
        testProj.KYC_Date__c = system.today() + 7;
        testProj.First_Cut_Presentation_Date__c = system.today() + 12;
        testProj.X3D_Presentation_Date__c = system.today() + 31;
        testProj.Kickoff_Meeting_Date__c = system.today() + 47;
        testProj.Design_Finalization_Date__c = system.today() + 21;
        testProj.RecordTypeId = projRecordTypeId;
        testProj.Default_Template_Project__c = true;
        testproj.Total_Expense_Budget__c = 100000.00;
        testproj.Offers_and_Discounts__c ='5% Discount';
        
        insert testProj;
        ProjectCreationStep4Async pasync4 = new ProjectCreationStep4Async(opp.Id);
        pasync4.execute(null);
        
    }
    
}