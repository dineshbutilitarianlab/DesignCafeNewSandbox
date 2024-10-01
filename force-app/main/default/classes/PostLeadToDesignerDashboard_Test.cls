/*
* Code Creator  : Munna Shaik
* Created Date  : 09 DEC 2021
* Code Modifier : V-Fory Team
* Modified Date : 21th December 2021
* Modified By   : Munna Shaik
*/
@isTest
public class PostLeadToDesignerDashboard_Test {
    public static testmethod void testLead(){
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        insert SRRmum;
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        insert SRRWDC;
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        insert SRRHyd;
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        insert SRRMGDC;
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        insert SRRHSR;
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        insert SRRCHE;
        Leadtogenesys__c lts = new Leadtogenesys__c();
        lts.Name = 'genesysapi';
        lts.url__c = 'LeadTrigger';
        insert lts;
        DC_Center_To_Group_Mapping__c Dcgm = new DC_Center_To_Group_Mapping__c();
        Dcgm.Name = 'testing';
        Dcgm.Venue_Name__c = 'MGDC';
        Dcgm.Public_Group_Name__c = 'Sales MGDC_1';
        insert Dcgm; 
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Meeting Scheduled';
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
        Leadins.Civil_Work__c = true;
        Leadins.Site_Service_Needed_for__c = 'False Ceiling';
        Leadins.Property_Usage__c = 'Self';
        Leadins.Where_are_you_currently_located__c = 'Self';
        Leadins.When_would_you_like_to_have_the_home__c = '2 to 3 Months';	
        Leadins.Which_language_are_you_most_comfortable__c = 'Self';
        Leadins.If_other_languages_please_specify__c = 'Self';
        Leadins.Who_will_be_staying_in_the_house__c = 'Parents';
        Leadins.How_many_kids_do_you_have__c = 'Self';
        Leadins.Gender_of_First_kid__c = 'Self';
        Leadins.Gender_of_Second_kid__c = 'Self';
        Leadins.Gender_of_Third_kid__c = 'Self';
        Leadins.Gender_of_Fourth_kid__c = 'Self';
        Leadins.Age_of_First_kid__c = 'Self';
        Leadins.Age_of_Second_kid__c = 'Self';
        Leadins.Age_of_Third_kid__c = 'Self';
        Leadins.Age_of_Fourth_kid__c = 'Self';
        Leadins.Do_you_have_pets__c = 'Self';
        Leadins.Live__c = 'Cooking';
        Leadins.Others_for_Live__c = 'ss';
        Leadins.Work__c = 'No';
        Leadins.Eat__c = 'Self';
        Leadins.Play__c = 'Workout';
        Leadins.Others_for_Live__c = 'ss';
        Leadins.Email = 'ss@b.com';
        Leadins.Willingness_For_Meeting__c = system.today()+15;
        Leadins.Date_When_Meeting_is_Scheduled__c = system.today();
        insert Leadins;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Meetingscheduled_testMockup());
        PostLeadToDesignerDashboard.callServer(Leadins.id);
        Test.stopTest();      
    }
}