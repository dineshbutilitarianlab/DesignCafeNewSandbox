@isTest
public class LeadTriggerTestClass {

    @testSetup static void setup() {
        UserRole TestRole = [SELECT Id FROM UserRole WHERE Name='Call Center Agent']; 
        UserRole TestRole1 = [SELECT Id FROM UserRole WHERE Name='Call Center Team Lead'];
        
        User TestUser = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'TestingUser5493',
                Email = 'puser000@amamama.com',
                Username = 'test5493@ama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=TestRole.id,
                Team__c='Sales MGDC_1'
            );
            insert TestUser;     
            
        //thisUser.UserRole 
        System.runAs (TestUser) { 
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
                Team__c='Sales MGDC_1'
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
                Team__c='Sales MGDC_1'
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
                Team__c='Sales MGDC_1'
            );
            insert uD;
            
            User uDesign = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last',
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
                Team__c='Sales MGDC_1'
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
            Lead leadA = new Lead(DC_Lead_Status__c='Undialed', Meeting_Venue__c = 'WDC' ,Meeting_Type__c   ='EC' ,LastName='Francis', property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='Direct', Follow_Up_Count__c=0, Status='New', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999',Phone='9999999999',Alternate_Contact_Number__c='9999999999',Designer__c = null);
            insert leadA;
            
            Lead leadB = new Lead(DC_Lead_Status__c='Undialed', Meeting_Venue__c = 'WDC',Meeting_Type__c    ='EC' , LastName='Francis', property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='New', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999',Phone='9999999999',Alternate_Contact_Number__c='9999999999',Designer__c=null);
            try{
                insert leadB;         
                
            }catch(Exception e){
            }
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
            
        } 
    }
    
    static testMethod void testMethodUser() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        Test.StartTest();
        //----------- User Roles and users
        UserRole roleCallAgent = [select id,name from UserRole where DeveloperName='Call_Center_Agent' limit 1];
        UserRole roleSalesAgent = [select id,name from UserRole where DeveloperName='Internal_Sales_Agent' limit 1];
        
        User u1 = [select id,name from User where UserRoleId=: roleSalesAgent.id and Region__c != null limit 1];
        User u2 = [select id,name from User where UserRoleId=: roleCallAgent.id  and Region__c != null  limit 1];
        
        //---------- Group and Group member
        Group grp = new Group();
        grp.name = 'LTC-Bangalore-Online-GoogleAdwords-Team';
        grp.Type = 'Regular'; 
        Insert grp; 
        
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = u1.id;
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
       Test.stopTest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
  
    }
    
    static testMethod void leadTraceOnLeadUpdate() {
        user u = [select id from user where Username = 'pu1234@amamama.com'];
        Lead lead1 = new Lead(LastName='Francis222',Meeting_Venue__c='MGDC',Meeting_Type__c='EC',Willingness_For_Meeting__c= date.today().addDays(5), 
                              Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct', Follow_Up_Count__c=0, Status='Prospect', 
                              Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999007879',Follow_Up_Date_Time__c=System.today() + 5);
        lead1.Property_Possession_Date__c=date.today();
        lead1.DC_Lead_Status__c='Qualified';
        lead1.isconverted=false;
        insert lead1;
        lead leadObj=[select DC_Lead_Status__c from lead where id=:lead1.id];
        system.debug('@@@----@@@'+leadObj);
        lead1.Designer__c = u.id;
        lead1.DC_Lead_Status__c='Meeting Scheduled';
        Update lead1;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    
    static testMethod void testMethod1() {
        UserRole rD = [SELECT Id FROM UserRole WHERE Name='Designer'];
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        System.runAs (thisUser) { 
            User uDesign = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last23',
                Email = 'puser444000@amamama.com',
                Username = 'pu1344234@amamama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rD.id,
                IsActive=true,
                Team__c='CMM Name'
            );
            insert uDesign;
            User uDesign1 = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last23',
                Email = 'puser44400@amamama.com',
                Username = 'pu134234@amamama.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rD.id,
                IsActive=true,
                Team__c='Sales MGDC_1'
            );
            insert uDesign1;        
            DC_Center_To_Group_Mapping__c dcObj= new DC_Center_To_Group_Mapping__c();
            dcObj.name='Sales MGDC';
            dcObj.Public_Group_Name__c='Sales MGDC';
            dcObj.UserNumberLastAssigned__c=57;
            dcObj.Venue_Name__c='MGDC';
            insert dcObj;
            
            //Create Parent Group
            Group grp = new Group();
            grp.name = 'MGDC';
            grp.Type = 'Regular'; 
            Insert grp; 
            
            //Create Group Member
            GroupMember grpMem1 = new GroupMember();
            grpMem1.UserOrGroupId = uDesign1.id;
            grpMem1.GroupId = grp.Id;
            Insert grpMem1;
            
            LeadTrigger_Handler.todayDateTime = Date.today();
            UserRole roleCallAgent = [select id,name from UserRole where DeveloperName='Call_Center_Agent' limit 1];
            User u2 = [select id,name from User where UserRoleId=: roleCallAgent.id  and Region__c != null  limit 1];
            
            Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
            Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
            
            Account accDSA  = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
            insert accDSA;
            Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
            insert accRef;
            account acc=[select Referee_Code_DC__c from account where id=:accRef.id];
            Lead lead1 = new Lead(LastName='Francis222',Meeting_Venue__c='MGDC' , Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',
                                  DC_Lead_Source__c ='Direct', Follow_Up_Count__c=0, Status='New', Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999997879');
            lead1.DSA__c=accDSA.id;
            lead1.DSA_Code__c='DCREF-0113512';
            lead1.Referee_Code__c='DCREF-0113513';
            insert lead1;
        }
    }
    
    static testMethod void testMethod2() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        Lead leadB = [select id,name,Status,DC_Lead_Status__c,Meeting_Venue__c from Lead where LastName='Francis'];        
        leadB.Status = 'Followup';
        leadB.DC_Lead_Status__c = 'No Response';
        leadB.Call_Stage__c = 'RNR';
        leadB.Meeting_Venue__c = 'WDC';
       Test.startTest();
        update leadB;
       Test.stopTest();
    }
    
    static testMethod void testMethod22() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        Lead leadB = new Lead(LastName='Francis222',Property_Possession_Date__c = system.today(), Meeting_Venue__c='MGDC',Meeting_Type__c='EC',
                              Willingness_For_Meeting__c= date.today().addDays(5), Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', 
                              Source__c = 'Direct', Follow_Up_Count__c=0, Status='Prospect', Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999007879');     
        leadB.Status = 'Followup';
        leadB.City = 'Bengaluru';
        leadB.Region__c = 'Bengaluru';        
        leadB.DC_Lead_Status__c = 'No Response';
        leadB.Call_Stage__c = 'RNR';
        leadB.Follow_Up_Date_Time__c = System.today() + 5;
        
        
       Test.startTest();
        insert leadB;
        leadB.Status = 'Prospect';
        leadB.DC_Lead_Status__c = 'Pre-qualified';
        update leadB;
       Test.stopTest();
    }
    
    static testMethod void testMethod3() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        Lead leadB = [select id,name,Status,DC_Lead_Status__c,Meeting_Venue__c from Lead where LastName='Francis'];
        
        leadB.Status = 'Prospect';
        leadB.DC_Lead_Status__c = 'Pre-qualified';
        leadB.Follow_Up_Date_Time__c = System.today() + 5;
       Test.startTest();
        update leadB;
       Test.stopTest();
    }
    
    static testMethod void testMethod4() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        UserRole roleCallAgent = [select id,name from UserRole where DeveloperName='Call_Center_Agent' limit 1];
        User u3 = [select id,name from User where UserRoleId=: roleCallAgent.id  and Region__c != null  order by LastName ASC limit 1];
        Lead leadB = [select id,name,Status,DC_Lead_Status__c from Lead where LastName='Francis'];
        leadB.ownerId = u3.id;
        leadB.Call_Center_Agent__c = leadB.OwnerId;
        leadB.Status = 'Prospect';
        leadB.DC_Lead_Status__c = 'Qualified';
         leadB.Follow_Up_Date_Time__c = System.today() + 5;
        
        Test.startTest();
        update leadB;
       Test.stopTest();
    }
    
    static testMethod void testMethod5() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        Lead leadB = [select id,name,Status,DC_Lead_Status__c,Designer__c,Lead_Owner_Role__c from Lead where LastName='francis' and Designer__c = null];
        
        leadB.Status = 'Prospect';
        leadB.DC_Lead_Status__c = 'Meeting Scheduled';
        leadB.Meeting_Venue__c = 'WDC';
        leadB.Willingness_For_Meeting__c = Date.today();
        Test.startTest();
        try{
            update leadB;
         }catch(Exception e){
        }
        Test.stopTest();
    }    
    
    public static testMethod void testMethod6() {
        LeadTrigger_Handler.todayDateTime = Date.today();        
        user u = [select id from user where LastName = 'TestingUser5493'];
        system.runAs(u){
        Lead l1 = new Lead(Willingness_For_Meeting__c = Date.today()+1, DC_Lead_Status__c = 'Meeting Scheduled', Meeting_Venue__c = 'WDC', LastName='Francis11', 
                           property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,
                           Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', 
                           Email='sjaiswal11@huronconsultinggroup.com',MobilePhone='9999999989',Phone='9999999989',Alternate_Contact_Number__c='9999999989');
        
        Lead l2 = new Lead(Willingness_For_Meeting__c = Date.today()+1, DC_Lead_Status__c = 'Meeting Scheduled', Meeting_Venue__c = 'WDC', LastName='Francis12', 
                           property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,
                           Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', 
                           Email='sjaiswal1101@huronconsultinggroup.com',MobilePhone='9999999901',Phone='9999999901',Alternate_Contact_Number__c='9999999901');
        
        Lead l3 = new Lead(Willingness_For_Meeting__c = Date.today()+1, DC_Lead_Status__c = 'Meeting Scheduled', Meeting_Venue__c = 'WDC', LastName='Francis13', 
                           property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,
                           Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', 
                           Email='sjaiswal119999999902@huronconsultinggroup.com',MobilePhone='9999999902',Phone='9999999902',Alternate_Contact_Number__c='9999999902');
        
        Lead l4 = new Lead(Willingness_For_Meeting__c = Date.today()+1, DC_Lead_Status__c = 'Meeting Scheduled', Meeting_Venue__c = 'WDC', LastName='Francis14', 
                           property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,
                           Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', 
                           Email='sjaiswal199999999041@huronconsultinggroup.com',MobilePhone='9999999904',Phone='9999999904',Alternate_Contact_Number__c='9999999904');
        
        Lead l5 = new Lead(Willingness_For_Meeting__c = Date.today()+1, DC_Lead_Status__c = 'Meeting Scheduled', Meeting_Venue__c = 'WDC', LastName='Francis15', 
                           property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,
                           Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', 
                           Email='sjaiswal119999999905@huronconsultinggroup.com',MobilePhone='9999999905',Phone='9999999905',Alternate_Contact_Number__c='9999999905');
        
        Lead l6 = new Lead(Willingness_For_Meeting__c = Date.today()+1, DC_Lead_Status__c = 'Meeting Scheduled', Meeting_Venue__c = 'WDC', LastName='Francis16', 
                           property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,
                           Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', 
                           Email='sjaiswal119999999906@huronconsultinggroup.com',MobilePhone='9999999906',Phone='9999999906',Alternate_Contact_Number__c='9999999906');
        
        Test.startTest();
        try{   
            insert l1;
            insert l2;
            insert l3;
            insert l4;
            insert l5;
            insert l6;        
        }catch(Exception e){
        }
        Test.stopTest();
        }
    }
    
    static testMethod void testMethodTask() {
        LeadTrigger_Handler.todayDateTime = Date.today();
        
        Lead leadA = new Lead(LastName='Francis', property_possession_date__c=Date.newInstance(2019, 11, 11),Call_Stage__c='Meeting Scheduled', Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='No Response', Follow_Up_Count__c=0, Status='Prospect', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999900',Phone='9999999900',Alternate_Contact_Number__c='9999999900');
        insert leadA; 
        Lead leadB = [select id,name,Status,DC_Lead_Status__c from Lead where LastName='Francis' limit 1];
        leadB.Status = 'Prospect';
        leadB.DC_Lead_Status__c = 'Qualified';
        update leadA;  
        Task t = new Task(IsReminderSet = true, whoId = leadA.Id, status='Open');              
        
        Test.startTest();
        insert t; 
        
        Test.stopTest();
    }
     
}