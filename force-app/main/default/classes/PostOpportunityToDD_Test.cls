@isTest
public class PostOpportunityToDD_Test {
    public static testmethod void testOpp(){
         DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
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
        PostOpportunityToDesignerDashboard.callServer(oppty.id);
        Test.startTest();
      //  Test.setMock(HttpCalloutMock.class, new PostOpportunityToDD_MockUp());
        Test.stopTest();
    }
}