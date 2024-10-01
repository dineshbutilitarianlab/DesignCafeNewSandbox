/*
 * Code Modifier : V-Fory Team
 * Modified Date : 11th November 2021
 * Modified By   : Munna Shaik
 */ 
@IsTest
public class VDC_OpportunityProcessstoApexTest {
	Static testmethod void frames(){
        //insert Custom setting for LeadTrigger
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
         CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        //Account insertion
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Designer'];
        User designer = new User(ProfileId = [Select Id from profile where Name='Designer'].Id, LastName = 'last', Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title',
                         Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US', Region__c='Bengaluru', userroleid=r.id);
        
        System.runAs(new User(id=UserInfo.getUserId())) {
            insert designer;
        }
        Lead leadRecord = new Lead(
            Meeting_Venue__c = 'WDC' ,
            Meeting_Type__c	='EC' ,
            LastName='Francis', 
            property_possession_date__c=Date.newInstance(2019, 11, 11),
            Call_Stage__c='Meeting Scheduled', 
            Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',
            DC_Lead_Source__c='Direct', Follow_Up_Count__c=0, Status='New', 
            Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999',Phone='9999999999',
            Alternate_Contact_Number__c='9999999999',
            Designer__c=designer.id,DC_Lead_Status__c='undialed');
        insert leadRecord;
        Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account Acc = New Account();
        Acc.RecordTypeId = CustomerRecordTypeId;
        Acc.LastName = 'Test Account';
        Acc.For_Promotion__c = false;
        Acc.Converted_Lead_ID__c = leadRecord.Id;
        insert Acc;
        Opportunity opp = New Opportunity();
        opp.AccountId = Acc.Id;
        opp.Name = 'Test Opp';
        opp.CloseDate = system.today();
        opp.The_Doors_Windows_are_installed_Requir__c = true;
        opp.Flooring_is_completed_Required__c = true;
        opp.Putty_and_1_coat_of_plastering_Required__c = true;
        opp.Proposal_Sent_Date__c = system.today();
        opp.Client_s_Budget__c = 100;
        opp.Lead_Id__c = leadRecord.Id;
        opp.StageName = 'Closed Lost';
        opp.Opportunity_status__c = 'Lost';
        opp.Reason__c = 'Low Budget';
        //opp.Email__c = 'test@gmail.com';
        opp.Home_Type__c = 'Villa';
        //opp.Mobile__c = '9878627322';
        //opp.DesignerEmail__c = 'test@designer.com';
        opp.Project_Name__c = 'Test Project';
        //opp.Design_User_Name__c = 'designer@user.com';
        opp.Region__c = 'Bengaluru';
        
        insert opp;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LcsupdateMockup());
        LcsAPIupdate.LcscallServer(Opp.id);
        LcsAPIupdate.OppdataWrap oppObj = new LcsAPIupdate.OppdataWrap();
        oppObj.emailId = '';
        oppObj.phoneNo = '';
        oppObj.designerEmail = '';
        //oppObj.posessionMonth = '';
        oppObj.designerName = '';
        oppObj.city = '';
        
        Test.stopTest();
    }
}