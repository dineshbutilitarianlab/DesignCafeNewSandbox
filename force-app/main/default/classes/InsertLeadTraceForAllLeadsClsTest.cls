@isTest
private class InsertLeadTraceForAllLeadsClsTest {
  /*  @testSetup static void setup() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        System.runAs (thisUser) { 
            UserRole rD = [SELECT Id FROM UserRole WHERE Name='Designer'];
            UserRole rDP = [SELECT Id FROM UserRole WHERE Name='Design Partner'];
            UserRole rDTL = [SELECT Id FROM UserRole WHERE Name='Design Team Lead']; 
            
            User uDTL = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'test2316@ama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rDTL.id,
                Team__c='Bengaluru-DP-1'
            );
            insert uDTL;     
            
            User uDp = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'test231@ama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rDP.id,
                Team__c='Bengaluru-DP-1'
            );
            insert uDp;   
            
            User uD = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'test123@ama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rD.id,
                Team__c='Bengaluru-DP-1'
            );
            insert uD;
            
            User uDesign = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last3454',
                Email = 'puser000@amamama.com',
                Username = 'pu1234@amamama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rD.id,
                Team__c='Bengaluru-DP-1'
            );
            insert uDesign;       
            
            
            Group grp = new Group();
            grp.name = 'WDC_Designers_Team';
            grp.Type = 'Regular'; 
            insert grp; 
            
            List<GroupMember> newGMList = new List<GroupMember>();
            newGMList.add(new GroupMember(UserOrGroupId = uDTL.id,GroupId = grp.Id));
            newGMList.add(new GroupMember(UserOrGroupId = uD.id,GroupId = grp.Id));
            newGMList.add(new GroupMember(UserOrGroupId = uDp.id,GroupId = grp.Id));
            insert newGMList;        
            
            Design_Cafe_Settings__c dcsetting = New Design_Cafe_Settings__c(Content_Type__c='application/json',Msg91_Auth_Key__c='246302AsvW6lRq5be03212',Msg91_URL__c='https://api.msg91.com/api/v2/sendsms?country=91',Route__c='4',Sender_Name__c='DESNCF',Working_Hour_End_Time__c=18,Working_Hour_Start_Time__c=9);
            insert dcsetting;
            
            List<LastLeadAssignedDesigner__c> cusList = new List<LastLeadAssignedDesigner__c>();
            cusList.add(New LastLeadAssignedDesigner__c(Name = 'WDC_Designer', Number__c = 0));
            cusList.add(New LastLeadAssignedDesigner__c(Name = 'WDC_Design_Partner', Number__c = 0));
            cusList.add(New LastLeadAssignedDesigner__c(Name = 'WDC_Design_Team_Lead', Number__c = 0));
            cusList.add(New LastLeadAssignedDesigner__c(Name = 'WDC_Lead_Assigned_Status', Number__c = 0));
            cusList.add(New LastLeadAssignedDesigner__c(Name = 'WDC_Lead_Count', Number__c = 0));
            
            insert cusList;
            
            LeadTrigger_Handler.todayDateTime = Date.today();
            //------------- Allocation rules data
            Lead_Allocation_Rule__c lRule = new Lead_Allocation_Rule__c(Agency_Group_Name__c='LTC-Bangalore-Online-GoogleAdwords-Team' , Channel__c = 'Online', Source__c = 'Direct',Region__c='Bengaluru',Campaign_Source__c='Direct');
            insert lRule;
            
            //-------------- Lead
            Lead leadA = new Lead(Meeting_Venue__c = 'WDC' ,Meeting_Type__c	='EC' ,LastName='Francis', property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='Direct', Follow_Up_Count__c=0, Status='New', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999',Phone='9999999999',Alternate_Contact_Number__c='9999999999',Designer__c=uD.id,DC_Lead_Status__c='undialed');
            insert leadA;
            
            
            leadA.Designer__c=uDesign.id;
            update leadA;
            Lead leadB = new Lead(Meeting_Venue__c = 'WDC',Meeting_Type__c	='EC' , LastName='Francis', property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='New', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999',Phone='9999999999',Alternate_Contact_Number__c='9999999999',Designer__c=uD.id);
            try{
                insert leadB;         
                
            }catch(Exception e){
            }
            
        } 
    }*/
    
    static testMethod void leadTrace() {
        user u = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        //User u = [select id,name from User where LastName = 'last3454']; 
        Lead lead1 = new Lead(LastName='Francis222', Meeting_Venue__c='MGDC',Meeting_Type__c='EC',Date_When_Meeting_is_Scheduled__c =date.today(), Willingness_For_Meeting__c= date.today().addDays(5), 
                              Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct', Follow_Up_Count__c=0, 
                              Status='Prospect', Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9990078790');
        lead1.Property_Possession_Date__c=date.today();
        lead1.DC_Lead_Status__c='Meeting Scheduled';
        lead1.Designer__c=u.id;
        lead1.Follow_Up_Date_Time__c = system.now();
        insert lead1;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        //InsertLeadTraceForAllLeadsCls.insertLeadTrace();
    }
    
    static testMethod void leadTrace1() {
        Lead lead1 = new Lead(LastName='Francis222',Meeting_Venue__c='MGDC',Meeting_Type__c='EC',Willingness_For_Meeting__c= date.today().addDays(5), Date_When_Meeting_is_Scheduled__c =date.today(), 
                              Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct', Follow_Up_Count__c=0, Status='Prospect', 
                              Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999007879');
        lead1.Property_Possession_Date__c=date.today();
        lead1.DC_Lead_Status__c='Meeting Done';
        lead1.Follow_Up_Date_Time__c = system.now();
        insert lead1;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        //InsertLeadTraceForAllLeadsCls.insertLeadTrace();
    }

}