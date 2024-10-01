@istest
public class VDC_AccounthandlerTest {
    @istest
    Static void ah1(){
        Id SalesPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id cmmId = [select Id from Profile where Name = 'CMM' limit 1].Id;
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'cmmuser@cmm.com', 
                          Username = 'cmmuser@cmm.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US',
                        //  Team__c = 'CMM Mumbai',
                          ProfileId = cmmId); 
        insert u;
        Account ac = new Account();
        ac.Name = 'munna';
        ac.Channel_Marketing_Manager__c = u.Id;
        ac.Opportunity_Stage__c = 'Closed Won';
        ac.RecordTypeId = SalesPartnerId;
        ac.NoRelationship__c = true;
        ac.TCAgreed__c = true;
        insert ac;
        ac.ApprovalStatus__c = 'Approved';
        update ac;
       Opportunity opp = New Opportunity();
        opp.AccountId = ac.Id;
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
        opp1.AccountId = ac.Id;
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
        update opp1;
    }    
 /*   @istest
    Static void ah2(){
        Id SalesPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id cmmId = [select Id from Profile where Name = 'CMM' limit 1].Id;
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'cmmuser@cmm.com', 
                          Username = 'cmmuser@cmm.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US',
                          Team__c = 'CMM Hyderabad',
                          ProfileId = cmmId); 
        insert u;
        Account ac = new Account();
        ac.Name = 'munna';
        ac.Channel_Marketing_Manager__c = u.Id;
        ac.Opportunity_Stage__c = 'Closed Won';
        ac.RecordTypeId = SalesPartnerId;
        ac.NoRelationship__c = true;
        ac.TCAgreed__c = true;
        insert ac;
        ac.ApprovalStatus__c = 'Approved';
        update ac;
        Opportunity opp = New Opportunity();
        opp.AccountId = ac.Id;
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
        opp1.AccountId = ac.Id;
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
        update opp1;
    }    
    @istest
    Static void ah3(){
        Id SalesPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id cmmId = [select Id from Profile where Name = 'CMM' limit 1].Id;
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'cmmuser@cmm.com', 
                          Username = 'cmmuser@cmm.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US',
                          Team__c = 'CMM Bangalore',
                          ProfileId = cmmId); 
        insert u;
        Account ac = new Account();
        ac.Name = 'munna';
        ac.Channel_Marketing_Manager__c = u.Id;
        ac.Opportunity_Stage__c = 'Closed Won';
        ac.RecordTypeId = SalesPartnerId;
        ac.NoRelationship__c = true;
        ac.TCAgreed__c = true;
        insert ac;
        ac.ApprovalStatus__c = 'Approved';
        update ac;
        Opportunity opp = New Opportunity();
        opp.AccountId = ac.Id;
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
        opp1.AccountId = ac.Id;
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
        update opp1;
    }  */
    Static testmethod void ah4(){
        //insert Custom setting for LeadTrigger
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
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
        update opp1;
    }
}