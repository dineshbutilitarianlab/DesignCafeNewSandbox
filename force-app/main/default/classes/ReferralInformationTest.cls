@isTest
public class ReferralInformationTest {
    
    @isTest
    public static void refereeCodeTest(){
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        Account acc =new Account();   
        acc.FirstName='TestAc';
        acc.LastName='Account';
        acc.PersonEmail='test@gmail.com';
        acc.PersonMobilePhone='9008008765';
        acc.Phone='9876543210';
        acc.PAN__c='ASDFG1234M';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street no 5';
        acc.BillingPostalCode='560001';
        acc.Customer_type__c='B2C';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        acc.Opportunity_Stage__c = 'Closed Won';
        acc.Channel_Marketing_Manager__c = uDesign.Id;
        acc.Phone = '9832988272';
        //acc.Referee_Code_DC__c = 'DCREF-9838972';
        insert acc;
        System.debug('acc.Referee_Code_DC__c ==> ' + acc.Referee_Code_DC__c);
        ReferralInformation.refereeCode(acc.Referee_Code_DC__c, acc.PersonMobilePhone);
        ReferralInformation.refereeCode(acc.Referee_Code_DC__c, acc.PersonMobilePhone);
        ReferralInformation.refereeCode('', '');
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
    }
    
    @isTest
    public static void updateRefereeDetailsTest(){
        TriggerControl__c cuset11 = new TriggerControl__c();
        cuset11.Name = 'LeadTrigger';
        cuset11.Run__c = false;
        insert cuset11; 
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

        INSERT new Design_Cafe_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Working_Hour_Start_Time__c=18,Working_Hour_End_Time__c = 9);
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Account accDSA  = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
        Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Offline';
        ld.Source__c = 'DSA';
        
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Email = 'Bengaluru@gmail.com';
        ld.DSA__c = accDSA.id;
        ld.DSA_Code__c = 'testing';
        ld.Status='Connected';
        ld.Meeting_Venue__c='HSRDC';
        ld.DC_Lead_Status__c = 'Undialed';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.MobilePhone = '9876543210';
        insert ld;
        
        user uDesign1 = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        Account acc =new Account();   
        acc.FirstName='TestAc';
        acc.LastName='Account';
        acc.PersonEmail='test@gmail.com';
        acc.PersonMobilePhone='9008008765';
        acc.Phone='9876543210';
        acc.PAN__c='ASDFG1234M';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street no 5';
        acc.BillingPostalCode='560001';
        acc.Customer_type__c='B2C';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        acc.Opportunity_Stage__c = 'Closed Won';
        acc.Channel_Marketing_Manager__c = uDesign1.Id;
        acc.Phone = '9832988272';
        insert acc;
        List<Account> accList = [SELECT Id, Name, Phone, PersonMobilePhone, PersonEmail, Referee_Code_DC__c FROM Account LIMIT 1];
        System.debug('acc==> ' + acc);
        Opportunity opp = new Opportunity(Name = 'Testoppt',ownerId = uDesign1.Id ,Lead_Id__c = ld.Id, Wohoo_Card__c = '45678', CloseDate = Date.today(), Amount=10000,AccountID = acc.id, StageName = 'Meeting Done', Designer__c= uDesign1.id);
            insert opp;
        ReferralInformation.getLeadInfo(ld.Id); 
        ReferralInformation.getOpportunityInfo(opp.Id); 
        ReferralInformation.updateRefereeDetails(ld.Id, accList[0]); 
        ReferralInformation.updateRefereeDetails(opp.Id, accList[0]);
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
    }

}