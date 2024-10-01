@IsTest
private class MeetingHistoryLead_Test
{
    @isTest
    static void test1(){
        TriggerControl__c tc = new TriggerControl__c();
        tc.run__c = true;
        tc.Name = 'LeadTrigger';
        insert tc;
        
        
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.DC_Lead_Status__c ='Recontacted';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.Meeting_Type__c='EC';
        Leadins.Meeting_Venue__c='MGDC';
        Leadins.Willingness_For_Meeting__c=system.today();
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
        Leadins.Email ='test@test.com';
        insert Leadins;
        Test.startTest();
        MeetingHistoryLead.getDefaultValue(Leadins.id);
        Test.stopTest();
    }
    @isTest
    static void test2(){
        TriggerControl__c tc = new TriggerControl__c();
        tc.run__c = true;
        tc.Name = 'LeadTrigger';
        insert tc;
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
        
        Lead Leadins1 = new lead();
        Leadins1.Approx_Budget__c = '2L to 3L';
        Leadins1.Status ='Junk';
        Leadins1.DC_Lead_Status__c ='Recontacted';
        Leadins1.Channel__c = 'Online';
        Leadins1.Source__c = '';
        Leadins1.City = 'Mumbai';
        Leadins1.Meeting_Type__c='EC';
        Leadins1.Meeting_Venue__c='MGDC';
        Leadins1.Willingness_For_Meeting__c=system.today();
        Leadins1.How_did_you_hear_about_us__c ='Online';
        Leadins1.Campagin__c ='';
        Leadins1.Knew_about_Design_Cafe_Because__c ='';
        Leadins1.Source_Journey__c='';
        Leadins1.LastName = 'test';
        Leadins1.MobilePhone = '+911290567890';
        Leadins1.Email ='test12@test.com';
        insert Leadins1;
       /* Leadins1.Email='test123@test.com';
        update Leadins1;*/
        
        Test.startTest();
        List< MeetingHistoryLead.leadReturnData> lrw = new List<MeetingHistoryLead.leadReturnData>();
        MeetingHistoryLead.leadReturnData lr = new MeetingHistoryLead.leadReturnData();
        lr.leadId =Leadins1.id;
        lr.meetingDateTime = Leadins1.Willingness_For_Meeting__c;
        lr.meetingType = Leadins1.Meeting_Type__c;
        lr.meetingVenue = Leadins1.Meeting_Venue__c;
        lrw.add(lr);
        
        String obj=JSON.serialize(lrw);
        
        MeetingHistoryLead.saveDataTOLead(obj);
        Test.stopTest();
    }
}