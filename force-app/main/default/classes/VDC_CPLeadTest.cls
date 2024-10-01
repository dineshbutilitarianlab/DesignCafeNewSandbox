/*
 * Code Modifier : V-Fory Team
 * Modified Date : 11th November 2021
 * Modified By   : Munna Shaik
 */ 
@istest
public class VDC_CPLeadTest {
    @istest
    Public static void cp1(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
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
        
        Lead Leadins = new lead();  
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.Email= 'Awdhesh1214@gmail.com';
        Leadins.Property_Type__c='villa';
        Leadins.Property_Possession_Date__c=System.today();
        Leadins.Project_Name__c='Awdhesh test';
        Leadins.Property_Type__c='0';
        leadins.Messaging_Source__c = '';
        leadins.CMM_Name__c = 'Harsh Gangawal';
        Leadins.Willingness_For_Meeting__c = system.today();
        leadins.Campagin__c = 'google';
        leadins.Home_Type__c= '2 BHK';
        leadins.OTP_Verified__c = 'YES';
        leadins.Wohoo_Card__c ='sevenfourzero';
        leadins.PostalCode = '123456';
        leadins.CMM_Name__c = 'sevenfourzero';
        leadins.Date_When_Meeting_is_Scheduled__c = system.today()+2;
        Leadins.Call_Stage__c='';
        Leadins.DC_Lead_Status__c ='Recontacted';
        leadins.Re_Contact_Date__c = system.today();
        Leadins.Channel__c = 'Offline';
        Leadins.Source__c = 'DSA';
        Leadins.City = 'Mumbai';
        leadins.Property_Usage__c ='Self';
        leadins.DSA_Code__c ='DC005643';
        leadins.Property_Possession_Date__c = system.today();
        leadins.Client_Site_visit__c ='Requested';
        leadins.Call_Stage__c = 'Low Budget';
        Leadins.Meeting_Type__c='EC';
        Leadins.Meeting_Venue__c='MGDC';
        Leadins.How_did_you_hear_about_us__c ='Online';
   //     Leadins.DC_Campaign_Source__c ='Email';
   //     leadins.DC_Lead_Source__c ='Email';
        Leadins.Scope_Of_Work__c='Home interiors';
        Leadins.Interior_work_needed_for__c='Living Room';
        Leadins.Requirement_Details__c='Wardrobes';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        leadins.FirstName = 'testeasy';
        leadins.Email='imtiyaz043@dc.com';
        leadins.City= 'Bengaluru';
        leadins.CMM_Name__c='Harsh Gangwal';
        leadins.Meeting_Type__c = 'EC';
        leadins.Meeting_Venue__c= 'MGDC';
        leadins.Property_Address__c =' Mysore road Bengaluru';
        leadins.Messaging_Source__c= 'WhatsApp';
        leadins.Status= 'Meeting Scheduled';
        leadins.Source__c='Paid';
      //  leadins.LeadSource='Google adwards';
        Leadins.Description='test';
        Leadins.MobilePhone = '+910000000000';
        insert Leadins;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        VDC_CPUpdateLead.CPcallout(leadins.Id);
        VDC_CPInsertLead.CPcallout(leadins.Id);
        Test.stopTest();
    }
}