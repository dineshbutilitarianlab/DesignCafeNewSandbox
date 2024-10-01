@isTest
public class Getquotelcs_test {
    public static testmethod void testLead(){
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.Email= 'Awdhesh1214@gmail.com';
        Leadins.Property_Type__c='villa';
        Leadins.Property_Possession_Date__c=System.today();
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
       // Leadins.Designer__c='';
        Leadins.Project_Name__c='Awdhesh test';
      //  leadins.Designer_Name__c= '';
        leadins.DC_Lead_Status__c='Meeting Scheduled';
        Leadins.DC_Lead_Status__c='Meeting Done';
        Leadins.Home_Type__c= '2 BHK';
        Leadins.Property_Type__c='0';
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
        Leadins.MobilePhone = '+910000000000';
        insert Leadins;
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new LcsMockup());
        Getquotelcs.LCScallServer(Leadins.id);
        Getquotelcs.showbutton(Leadins.id);
        Test.stopTest();

    }
}