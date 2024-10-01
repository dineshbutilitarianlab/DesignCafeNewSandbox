@isTest
private class MeetingHistoryOpp_test {
    @isTest
    static void testOpp(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        Opportunity oppty = new Opportunity();
        oppty.Name = 'test';
        oppty.AccountId = acc.id;
        oppty.Signup_Amount__c =10000;
        oppty.Offer_and_discounts__c ='5% Discount';
        oppty.Proposed_Budget__c=300000;
        oppty.Approx_Budget__c='3L to 5L';
        oppty.Interior_work_needed_for__c ='Modular Kitchen';
        oppty.Meeting_Type__c ='EC';
        oppty.Meeting_Venue__c ='MGDC';
        oppty.Project_Name__c ='test';
        oppty.Requirement_Details__c='Wardrobes';
        oppty.StageName ='Meeting Done';
        oppty.CloseDate = System.today();
        insert oppty;
        Test.startTest();
        MeetingHistoryOpportunity.getDefaultValue(oppty.id);
        Test.stopTest();
    }
    @isTest
    static void testOpp1(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        Opportunity oppty = new Opportunity();
        oppty.Name = 'test';
        oppty.AccountId = acc.id;
        oppty.Signup_Amount__c =10000;
        oppty.Offer_and_discounts__c ='5% Discount';
        oppty.Proposed_Budget__c=300000;
        oppty.Approx_Budget__c='3L to 5L';
        oppty.Interior_work_needed_for__c ='Modular Kitchen';
        oppty.Meeting_Type__c ='EC';
        oppty.Meeting_Venue__c ='MGDC';
        oppty.Project_Name__c ='test';
        oppty.Requirement_Details__c='Wardrobes';
        oppty.StageName ='Meeting Done';
        oppty.CloseDate = System.today();
        insert oppty;
        oppty.Proposed_Budget__c=400000;
        update oppty;
        Test.startTest();
        List<MeetingHistoryOpportunity.OppReturnData> orw = new  List<MeetingHistoryOpportunity.OppReturnData>();
        MeetingHistoryOpportunity.OppReturnData opp = new  MeetingHistoryOpportunity.OppReturnData();
        opp.opportunityId =oppty.id;
        opp.meetingDateTime = oppty.Meeting_Scheduled_Date_Time__c;
        opp.meetingType = oppty.Meeting_Type__c;
        opp.meetingVenue = oppty.Meeting_Venue__c;
        orw.add(opp);
        String obj=JSON.serialize(orw);
        MeetingHistoryOpportunity.saveDataTOLead(obj);
        Test.stopTest();
    }
}