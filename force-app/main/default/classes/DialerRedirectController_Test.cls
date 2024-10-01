@isTest
public class DialerRedirectController_Test {
    public static testmethod void testDialerApi(){
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Recontacted';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.Meeting_Type__c='EC';
        Leadins.Meeting_Venue__c='MGDC';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Scope_Of_Work__c='Home interiors';
        Leadins.Interior_work_needed_for__c='Living Room';
        Leadins.Requirement_Details__c='Wardrobes';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.Description='test';
        Leadins.MobilePhone = '919878765678';
        insert Leadins;
        Test.startTest();
        DialerRedirectController.fetchLeadDetails(Leadins.MobilePhone,'1234');
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Test.stopTest();
    }
    
}