@isTest
public class ArchivedLeadBatchTest {
    
    @isTest
    public static void test_ArchivedLeadBatch(){
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Nex',
            Email = 'test@nex.com',
            Username = 'nexus@own.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id,
            IsActive = true
        );
        insert usr;   
        System.runAs(usr){
            
            TriggerControl__c tc1 = new TriggerControl__c();
            tc1.Name = 'LeadTrigger';
            tc1.Run__c = false;
            insert tc1; 
            
            DCWebengage__c cuset2= new DCWebengage__c();
            cuset2.Name = 'Dcwebengage';
            cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
            cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cuset2;
            
            Leadtogenesys__c cuset1 = new Leadtogenesys__c();
            cuset1.Name = 'genesysapi';
            cuset1.url__c = 'http://dctest.greettech.com:8081/leadsTogreetTest.php';
            insert cuset1; 
            Lead l = new Lead();
            
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
            SRR__c SRRjpdc = new SRR__c();
            SRRjpdc.Name = 'JPDC';
            SRRjpdc.index__c = 0;
            insert SRRjpdc;
            SRR__c SRRthane = new SRR__c();
            SRRthane.Name = 'Thane DC';
            SRRthane.index__c = 0;
            insert SRRthane;
            SRR__c SRRKDRMYS = new SRR__c();
            SRRKDRMYS.Name = 'KDRMYS';
            SRRKDRMYS.index__c = 0;
            insert SRRKDRMYS;
            SRR__c SRRYERPUN = new SRR__c();
            SRRYERPUN.Name = 'YERPUN';
            SRRYERPUN.index__c = 0;
            insert SRRYERPUN;
            SRR__c SRRBHHYD = new SRR__c();
            SRRBHHYD.Name = 'BHHYD';
            SRRBHHYD.index__c = 0;
            insert SRRBHHYD;
            SRR__c SRRSJPBLR = new SRR__c();
            SRRSJPBLR.Name = 'SJPBLR';
            SRRSJPBLR.index__c = 0;
            insert SRRSJPBLR;
            SRR__c SRRKHMUM = new SRR__c();
            SRRKHMUM.Name = 'KHMUM';
            SRRKHMUM.index__c = 0;
            insert SRRKHMUM;
            SRR__c SRRWLMUM = new SRR__c();
            SRRWLMUM.Name = 'WLMUM';
            SRRWLMUM.index__c = 0;
            insert SRRWLMUM;
            SRR__c SRROMRCH = new SRR__c();
            SRROMRCH.Name = 'OMRCH';
            SRROMRCH.index__c = 0;
            insert SRROMRCH;
            
            SRR__c SRRHRBRBLR = new SRR__c();
            SRRHRBRBLR.Name = 'HRBRBLR';
            SRRHRBRBLR.index__c = 0;
            insert SRRHRBRBLR; 
            
            SRR__c Coimb = new SRR__C();
            Coimb.Name = 'Coimbatore';
            Coimb.index__c = 0;
            insert Coimb;
            
            SRR__c rsp = new SRR__C();
            rsp.Name = 'RSPCO';
            rsp.index__c = 0;
            insert rsp;
            
            Lead_Number__c lnumbCust =new Lead_Number__c();
            lnumbCust.Chennai_User_Count__c =3;  
            lnumbCust.Lead_Number_Chennai__c=52;
            lnumbCust.Lead_Number_Pune__c=16;
            lnumbCust.Pune_User_Count__c=2;
            lnumbCust.Lead_Number_Bangalore__c  =2;
            lnumbCust.Bangalore_User_Count__c=11;
            lnumbCust.Lead_Number_Hyderabad__c=3;  
            lnumbCust.Hyderabad_User_Count__c=6;
            lnumbCust.Lead_Number_Mumbai_Thane__c=7;  
            lnumbCust.Mumbai_Thane_User_Count__c  =5;
            lnumbCust.Lead_Number_Navi_Mumbai__c = 4;
            lnumbCust.Navi_Mumbai_User_Count__c = 2;
            insert lnumbCust; 
            
            Date createdDate = Date.newInstance(2022, 01, 01);
            
            
            
            user uDesign = [select id, name, IsActive from user where profile.name = 'System Administrator' AND IsActive = true limit 1];
            System.debug('uDesign ==> ' + uDesign);
            Id salesRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
            Id empRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
            Account accDSA = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
            insert accDSA;
            
            /*Opportunity opp = New Opportunity();
            opp.AccountId = accDSA.Id;
            opp.Name = 'Test Opp';
            opp.StageName = 'Discussion';
            opp.CloseDate = system.today();
            //opp.Reason__c = 'Sign-up with Qarpentri';
            opp.Meeting_Venue__c = 'YERPUN';
            opp.Meeting_Type__c = 'EC';
            opp.Region__c = 'Thane';
            opp.Oppy_Qualified_for__c = 'Design Cafe';
            //opp.Opportunity_status__c = 'Need Site Visit';
            opp.The_Doors_Windows_are_installed_Requir__c = true;
            opp.Flooring_is_completed_Required__c = true;
            opp.Putty_and_1_coat_of_plastering_Required__c = true;
            opp.Proposal_Sent_Date__c = system.today();
            opp.Lead_Id__c = 'test';
            opp.Client_s_Budget__c = 100;
            insert opp;
            System.debug('opp>> '+opp);*/
            
            Lead Leadins = new Lead();
            Leadins.Approx_Budget__c = '2L to 3L';
            Leadins.Client_s_Budget__c = 89000;
            Leadins.IsConverted = false;
            Leadins.DSA__c = accDSA.Id;
            Leadins.DSA_Code__c = 'DSA 121';
            Leadins.Status ='New';
            Leadins.Call_Stage__c ='Possession Delayed';
            Leadins.Follow_Up_Date_Time__c = system.today().addDays(10);
            Leadins.DC_Lead_Status__c='Prospect';
            Leadins.Project_Name__c = 'TestProject';
            Leadins.Channel__c = 'Offline';
            //Leadins.Referee_Account__c = accDSA.Id;
            Leadins.Referee_Code__c = 'DSA 232';
            //Leadins.ConvertedOpportunityId = opp.Id;
            //Leadins.MS_Date_Time__c = date.today().addDays(+15);
            Leadins.Source__c = 'Direct';
            Leadins.City = 'Mumbai';
            Leadins.How_did_you_hear_about_us__c =null;
            Leadins.Campagin__c ='';
            Leadins.Knew_about_Design_Cafe_Because__c ='';
            Leadins.Source_Journey__c='';
            Leadins.FirstName = 'Pankaj';
            Leadins.LastName = 'Pawar';
            Leadins.MobilePhone = '7897889123';
            Leadins.Email = 'test@test.com';
            Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
            Leadins.Meeting_Venue__c = 'Hyderabad DC';
            Leadins.Meeting_Type__c = 'EC';
            Leadins.Civil_Work__c = true;
            //newcomment//Leadins.CreatedDate = createdDate;
            Leadins.Re_Contact_Date__c = date.today().addDays(-10);
            Leadins.Property_Possession_Date__c = createdDate;
            Leadins.Follow_Up_Date_Time__c = createdDate;
            Leadins.OwnerId = usr.Id;
            //Leadins.MS_Date_Time__c = createdDate;
            insert Leadins;
            System.debug('Leadins >> '+Leadins);
            
            System.debug('Query ==> ' + [SELECT Id, Name, OwnerId, Owner.Name, Owner.IsActive FROM Lead]);
            
            Date createdDate1 = Date.newInstance(2023, 01, 01);
            Date followupDatetime = Date.newInstance(2023, 01, 01);
            Date meetingScheduledDatetime = Date.newInstance(2023, 01, 01);
            Date propertyPossesionDate = Date.newInstance(2023, 01, 01);
            List<String> listOfStageName = new List<String>{'Awaiting Closure', 'Closed Lost', 'Discussion', 'Follow Up', 'Meeting Done', 'Proposal Sent', ''};
                
                Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
            Database.executeBatch(new ArchivedLeadBatch());  
            Test.stopTest();
        }
        
        
    }
}