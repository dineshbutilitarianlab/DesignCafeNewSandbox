@IsTest
private class ReferralPage_Test
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
        Leadins.Referee_Name__c='test';
        Leadins.Referee_Number__c='123';
        Leadins.Referee_Code__c ='123';
        insert Leadins;
        Test.startTest();
        ReferralPage.getDefaultValue(Leadins.id);
        Test.stopTest();
    }
    @isTest
    static void test2(){
        TriggerControl__c tc = new TriggerControl__c();
        tc.run__c = true;
        tc.Name = 'LeadTrigger';
        insert tc;
        
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
        Leadins1.Referee_Name__c='test';
        Leadins1.Referee_Number__c='123';
        Leadins1.Referee_Code__c ='123';
        Leadins1.Willingness_For_Meeting__c=system.today();
        Leadins1.Meeting_Type__c ='EC';
        Leadins1.Meeting_Venue__c='MGDC';
        insert Leadins1;
        Leadins1.Email='test123@test.com';
        update Leadins1;
        
        Test.startTest();
        List< ReferralPage.leadReturnData> lrw = new List<ReferralPage.leadReturnData>();
        ReferralPage.leadReturnData lr = new ReferralPage.leadReturnData();
        lr.leadId =Leadins1.id;
        lr.RefereeName = Leadins1.Referee_Name__c;
        lr.RefereeCode = Leadins1.Referee_Code__c;
        lr.RefereeNumber = Leadins1.Referee_Number__c;
        lr.RefereeEmail = Leadins1.Referee_Email_ID__c;
        lrw.add(lr);
        
        String obj=JSON.serialize(lrw);
        ReferralPage.saveDataTOLead(obj);
        Test.stopTest();
    }
}