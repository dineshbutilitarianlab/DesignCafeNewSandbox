@isTest
public class VDC_CPOpportunityTest {
    @isTest
    static void cpopp(){
        //insert Custom setting for LeadTrigger
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        //Account insertion
        Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account Acc = New Account();
        Acc.RecordTypeId = CustomerRecordTypeId;
        Acc.LastName = 'Test Account';
        Acc.For_Promotion__c = false;
        insert Acc;
        Opportunity opp = New Opportunity();
        opp.AccountId = Acc.Id;
        opp.Name = 'Test Opp';
        opp.StageName = 'Closed Lost';
        opp.CloseDate = system.today();
        opp.The_Doors_Windows_are_installed_Requir__c = true;
        opp.Flooring_is_completed_Required__c = true;
        opp.Putty_and_1_coat_of_plastering_Required__c = true;
        opp.Proposal_Sent_Date__c = system.today();
        opp.Client_s_Budget__c = 100;
        insert opp;
        Opportunity opp1 = New Opportunity();
        opp1.AccountId = Acc.Id;
        opp1.Name = 'Test Opp';
        opp1.StageName = 'Discussion';
        opp1.CloseDate = system.today();
        opp1.The_Doors_Windows_are_installed_Requir__c = true;
        opp1.Flooring_is_completed_Required__c = true;
        opp1.Putty_and_1_coat_of_plastering_Required__c = true;
        opp1.DSA_Email__c = 'test@test.com';
        insert opp1;
        opp1.Proposal_Sent_Date__c = system.today();
        Opp1.DSA_Email__c = '';
        opp1.StageName = 'Closed Lost';
        opp1.CloseDate = system.today();
        opp1.Client_s_Budget__c = 100;
        opp1.Proposed_Budget__c = 100;
        opp1.Reason_for_Loss__c = 'Overpriced';
        opp1.DSA__c = Acc.id;
        update opp1;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LcsupdateMockup());
        VDC_CPInsertOpportunity.CPcallout(opp1.Id);
        VDC_CPUpdateOpportunity.CPcallout(opp1.Id);
        Test.stopTest();
    }
}