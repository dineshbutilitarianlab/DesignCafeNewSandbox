@Istest
public class Test_LeadAssignmentHandler {
	@isTest
    public static void leadaRR(){
        LeadAssignmentHandler la = new LeadAssignmentHandler();
    }
}
/* @Istest
public class Test_LeadAssignmentHandler {
	@isTest
    public static void MGDC(){
        DDR__c DDRmumm = new DDR__c();
        DDRmumm.Name = 'Mumbai';
        DDRmumm.index__c = 0;
        insert DDRmumm;
        DDR__c DDRmumm1 = new DDR__c();
        DDRmumm1.Name = 'Mumbai';
        DDRmumm1.index__c = 1;
        insert DDRmumm1;
        DDR__c DDRmumm2 = new DDR__c();
        DDRmumm2.Name = 'Mumbai';
        DDRmumm2.index__c = 2;
        insert DDRmumm2;
        LastLeadAssignedDesigner__c MGDCLc = new LastLeadAssignedDesigner__c();
        MGDCLc.Name = 'MGDC_Lead_Count';
        MGDCLc.Number__c = 1;
        insert MGDCLc;
        LastLeadAssignedDesigner__c MGDCLas = new LastLeadAssignedDesigner__c();
        MGDCLas.Name = 'MGDC_Lead_Assigned_Status';
        MGDCLas.Number__c = 2;
        insert MGDCLas;
        LastLeadAssignedDesigner__c MGDCDm = new LastLeadAssignedDesigner__c();
        MGDCDm.Name = 'MGDC_Design_Manager';
        MGDCDm.Number__c = 2;
        insert MGDCDm;
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        CallCenterAPI.basicAuthCallout(lList.id);
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
    }
    @isTest
    public static void MGDC1(){
        DDR__c DDRmumm = new DDR__c();
        DDRmumm.Name = 'Mumbai';
        DDRmumm.index__c = 0;
        insert DDRmumm;
        DDR__c DDRmumm1 = new DDR__c();
        DDRmumm1.Name = 'Mumbai';
        DDRmumm1.index__c = 1;
        insert DDRmumm1;
        DDR__c DDRmumm2 = new DDR__c();
        DDRmumm2.Name = 'Mumbai';
        DDRmumm2.index__c = 2;
        insert DDRmumm2;
        LastLeadAssignedDesigner__c MGDCLc = new LastLeadAssignedDesigner__c();
        MGDCLc.Name = 'MGDC_Lead_Count';
        MGDCLc.Number__c = 2;
        insert MGDCLc;
        LastLeadAssignedDesigner__c MGDCLas = new LastLeadAssignedDesigner__c();
        MGDCLas.Name = 'MGDC_Lead_Assigned_Status';
        MGDCLas.Number__c = 2;
        insert MGDCLas;
        LastLeadAssignedDesigner__c MGDCCm = new LastLeadAssignedDesigner__c();
        MGDCCm.Name = 'MGDC_Community_Manager';
        MGDCCm.Number__c = 2;
        insert MGDCCm;
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        CallCenterAPI.basicAuthCallout(lList.id);
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
    } 
     @isTest
    public static void MUMBAI(){
        DDR__c DDRmumm = new DDR__c();
        DDRmumm.Name = 'Mumbai';
        DDRmumm.index__c = 0;
        insert DDRmumm;
        DDR__c DDRmumm1 = new DDR__c();
        DDRmumm1.Name = 'Mumbai';
        DDRmumm1.index__c = 1;
        insert DDRmumm1;
        DDR__c DDRmumm2 = new DDR__c();
        DDRmumm2.Name = 'Mumbai';
        DDRmumm2.index__c = 2;
        insert DDRmumm2;
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Mumbai';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='Mumbai DC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        CallCenterAPI.basicAuthCallout(lList.id);
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
    } 
}   */