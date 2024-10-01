@isTest
private class ReferralPageOppty_Test {
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
        oppty.ST_Referee_Code__c = '1234';
        oppty.ST_Referee_Name__c ='test';
        oppty.ST_Referee_Number__c ='1234';
        insert oppty;
        Test.startTest();
        ReferralPageOppty.getDefaultValue(oppty.id);
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
         oppty.ST_Referee_Code__c = '1234';
        oppty.ST_Referee_Name__c ='test';
        oppty.ST_Referee_Number__c ='1234';
        insert oppty;
        oppty.Proposed_Budget__c=400000;
        update oppty;
        Test.startTest();
        List<ReferralPageOppty.OpportunityReturnData> orw = new  List<ReferralPageOppty.OpportunityReturnData>();
        ReferralPageOppty.OpportunityReturnData opp = new  ReferralPageOppty.OpportunityReturnData();
        opp.OpportunityId = oppty.Id;
        opp.RefereeName = oppty.ST_Referee_Name__c;
        opp.RefereeNumber = oppty.ST_Referee_Number__c;
        opp.RefereeCode = oppty.ST_Referee_Code__c;
        opp.RefereeEmail = oppty.Referee_Email_ID__c;
        orw.add(opp);
        String obj=JSON.serialize(orw);
        ReferralPageOppty.saveDataTOOpportunity(obj);
        Test.stopTest();
    }
}