/*
Developer : Jai Kumar 
Created Date :  16 Dec 2019
Description : Test class for MilestoneController class.
*/

@isTest
public class MilestoneControllerTest {
    @isTest static void testMilestoneControllerTest(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
        insert acc;
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project_Accepted').getRecordTypeId();
        Milestone1_Project__c project = new Milestone1_Project__c(Name = 'test',Customer__c = acc.Id,RecordTypeId = projectRecordTypeId );
        insert project;
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id);
        test.startTest();
        insert milestone;
        test.stopTest();
    }
    @isTest static void testMilestoneControllerTestException(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
        insert acc;
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project_Accepted').getRecordTypeId();
        Milestone1_Project__c project = new Milestone1_Project__c(Name = 'test',Customer__c = acc.Id,RecordTypeId = projectRecordTypeId );
        insert project;
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id);
        insert milestone;
        test.startTest();
        MilestoneController.createArtifact(milestone.id, 'Test');
        test.stopTest();
    }
    @isTest static void completeMilestoneTest(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
        insert acc;
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project_Accepted').getRecordTypeId();
        Milestone1_Project__c project = new Milestone1_Project__c(Name = 'test',Customer__c = acc.Id,RecordTypeId = projectRecordTypeId );
        insert project;
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id,Type__c='KYC');
        insert milestone;
        test.startTest();
        MilestoneController.completeMilestone('KYC');
        test.stopTest();
    }
    @isTest static void getDocumentTemplateTest(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
        insert acc;
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project_Accepted').getRecordTypeId();
        Milestone1_Project__c project = new Milestone1_Project__c(Name = 'test',Customer__c = acc.Id,RecordTypeId = projectRecordTypeId );
        insert project;
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id,Type__c='KYC');
        insert milestone;
        test.startTest();
        MilestoneController.getDocumentTemplate(milestone.id);
        test.stopTest();
    }
    @isTest static void getgenerateInvoiceDataTest(){
        Account acc = new Account();
        acc.FirstName = 'test opp';
        acc.LastName ='test opp';
        acc.PersonEmail ='test@test.com';
        acc.PersonMobilePhone ='9000009900';
        acc.ShippingStreet = '7th block kormangala';
        acc.ShippingCity ='Bengaluru';
        acc.ShippingState = 'Karnataka';
        acc.ShippingPostalCode ='560096';
        acc.BillingCountry ='India';
        acc.BillingStreet = '7th block kormangala';
        acc.BillingCity ='Bengaluru';
        acc.BillingState = 'Karnataka';
        acc.BillingPostalCode ='560096';
        acc.BillingCountry ='India';
        insert acc;
        System.debug('Account'+acc);
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.id;
        opp.Name ='test opp';
        opp.StageName ='Meeting Done';
        opp.CloseDate =System.today();
        opp.Project_Name__c ='Test opp';
        opp.Amount =10000;
        opp.Meeting_Type__c = 'EC';
        opp.Meeting_Venue__c='MGDC';
        opp.Source_Customer_ID__c = 'TEST001';
        insert opp;
        Id projectRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project_Accepted').getRecordTypeId();
        Milestone1_Project__c project = new Milestone1_Project__c();
        project.Name = 'test';
        project.Customer__c = acc.Id;
        project.RecordTypeId = projectRecordTypeId;
        project.Opportunity__c = opp.id;
        insert project;
        
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c();
        milestone.name='test';
        milestone.Project__c = project.id;
        milestone.Type__c='KYC';
        milestone.Order__c = 1;
        insert milestone;
        
        Milestone1_Milestone__c ml1 = new Milestone1_Milestone__c();
        ml1.name='test1';
        ml1.Project__c = project.id;
        ml1.Type__c='KYC';
        ml1.EligibleAmountPercentage__c = 30;
        ml1.order__c = 2;
        insert ml1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MilestoneController_Mockup());
        MilestoneController.generateInvoiceData(milestone.id);
        Test.stopTest();
        
    }
    
}