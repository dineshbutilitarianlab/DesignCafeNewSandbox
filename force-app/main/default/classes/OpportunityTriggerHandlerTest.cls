@isTest
public class OpportunityTriggerHandlerTest {


    @testSetup static void setup() {
        Test.startTest();
        List<SRR__c> SRRList = new List<SRR__c>();
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

        
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        SRRList.add(SRRmum);
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        SRRList.add(SRRWDC);
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        SRRList.add(SRRHyd);
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        SRRList.add(SRRMGDC);
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        SRRList.add(SRRHSR);
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        SRRList.add(SRRCHE);
        SRR__c SRRjpdc = new SRR__c();
        SRRjpdc.Name = 'JPDC';
        SRRjpdc.index__c = 0;
        SRRList.add(SRRjpdc);
        SRR__c SRRthane = new SRR__c();
        SRRthane.Name = 'Thane DC';
        SRRthane.index__c = 0;
        SRRList.add(SRRthane);
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        SRRList.add(SRRKDRMYS);
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        SRRList.add(SRRYERPUN);
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        SRRList.add(SRRBHHYD);
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        SRRList.add(SRRSJPBLR);
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        SRRList.add(SRRKHMUM);
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        SRRList.add(SRRWLMUM);
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name = 'OMRCH';
        SRROMRCH.index__c = 0;
        SRRList.add(SRROMRCH);
        SRR__c SRRHRBRBLR = new SRR__c();
        SRRHRBRBLR.Name = 'HRBRBLR';
        SRRHRBRBLR.index__c = 0;
        SRRList.add(SRRHRBRBLR);
        SRR__c SRRHRRSPCO = new SRR__c();
        SRRHRRSPCO.Name = 'RSPCO';
        SRRHRRSPCO.index__c = 0;
        SRRList.add(SRRHRRSPCO);
        SRR__c SRRHRDNVIZ = new SRR__c();
        SRRHRDNVIZ.Name = 'DNVIZ';
        SRRHRDNVIZ.index__c = 0;
        SRRList.add(SRRHRDNVIZ);
        
        if(SRRList.size()> 0){
               Insert SRRList; 
        }

        //OpportunityTrigger_Test.makeData();
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Designer'];
        //User designer = [SELECT Id FROM User Limit 1];
        User designer = new User(ProfileId = [Select Id from profile where Name='Designer'].Id, LastName = 'last', Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title',
                         Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US', Region__c='Bengaluru', userroleid=r.id);
        
        System.runAs(new User(id=UserInfo.getUserId())) {
            insert designer;
        }

        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        
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
        //Lead leadRecord = [SELECT ID FROM Lead LIMIT 1];
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        Account a = new Account(LastName = 'TestAcct', RecordTypeId  = devRecordTypeId,Converted_Lead_ID__c = leadRecord.Id);  
        insert a;
        
        Milestone1_Project__c mp = new Milestone1_Project__c(Name = 'Template Project', Default_Template_Project__c = true, Project_Duration_in_days__c = 90);
        insert mp; 
        
        List<Milestone1_Milestone__c> milist = new List<Milestone1_Milestone__c>();

        for(Integer i=0;i<2;i++) {
            milist.add( new Milestone1_Milestone__c(name = 'Test Mile'+i, Relative_Kickoff_Date_in_days__c = 0, Relative_Deadline_in_days__c = 10, Project__c = mp.Id)); 
        }

        insert milist;
        
        List<Milestone1_Task__c> tasklist = new List<Milestone1_Task__c>();

        for (Milestone1_Milestone__c m : milist){
            tasklist.add(new Milestone1_Task__c(name = 'test task'+m.name, Relative_Start_Date_in_days__c = 10, Relative_Due_Date_in_days__c = 15, Project_Milestone__c = m.Id));
        }

        insert tasklist;
        
        List<Opportunity> testoppts = new List<Opportunity>();

        for(Integer i=0;i<2;i++) {
            testoppts.add(new Opportunity(Name = 'Testoppt'+i, CloseDate = Date.today(), Amount=10000,AccountID = a.id, StageName = 'Meeting Done', 
                                          Designer__c=designer.id,OwnerId=designer.id, Lead_Id__c = leadRecord.Id));
        }
         
        // insert testoppts;   
        
        // ContentVersion contentVersion = new ContentVersion(
        //     Title = 'Penguins',
        //     PathOnClient = 'Penguins.jpg',
        //     VersionData = Blob.valueOf('Test Content'),
        //     IsMajorVersion = true
        // );
        
        // insert contentVersion; 
        
        // List<ContentDocumentLink> cdllist = new List<ContentDocumentLink>();
        // List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        // for(Opportunity o : testoppts) {
        //     //create ContentDocumentLink  record 
        //     ContentDocumentLink cdl = New ContentDocumentLink();
        //     cdl.LinkedEntityId = o.id;
        //     cdl.ContentDocumentId = documents[0].Id;
        //     cdl.shareType = 'V';
        //     cdllist.add(cdl);
        // }
        
        // insert cdllist;
        //update testoppts;
        Test.stopTest();
    }
    
    @isTest
    static void testOpportunityTriggerHandlerTest() {  
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
       
        Account a = new Account(LastName = 'TestAcct',RecordTypeId  = devRecordTypeId, Converted_Lead_ID__c = lead.Id);  
        insert a;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            // UserRole r = [SELECT Id FROM UserRole WHERE Name='DesignPartner'];
            
            Id p = [select id from profile where name='Designer'].id;
            User user2 = new User(
                ProfileId = [Select Id from profile where Name='Designer'].Id,
                Username = 'TestUserCheckOut12@gmail.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            insert user2; 

           // User user2 = [SELECT Id FROM User LIMIT 1];
            
            Monthly_Target__c mt = new Monthly_Target__c(User__c = user2.Id, Month__c ='January' ,Year__c='2020',Target_Revenue__c=6500000.00,Experience_Center__c='MGDC' );
            insert mt;
            Monthly_Target__c mt2 = new Monthly_Target__c(User__c = user2.Id, Month__c ='December' ,Year__c='2019',Target_Revenue__c=6500000.00,Experience_Center__c='MGDC' );
            insert mt2;
        
            
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'View_All_Opportunities'];
            insert new PermissionSetAssignment(AssigneeId = user2.id, PermissionSetId = ps.Id);  
            
            
            Incentive_Amount__c objIncentive = new Incentive_Amount__c();
            objIncentive.Name = 'Lead Incentive';
            objIncentive.Lead_Incentive__c = 4000;
            insert objIncentive;
            
            Opportunity opp = new Opportunity(Name = 'Testoppt',ownerId = user2.id ,Lead_Id__c = lead.Id, Wohoo_Card__c = '45678', CloseDate = Date.today(), Amount=10000,AccountID = a.id, StageName = 'Meeting Done', Designer__c= user2.id);
            insert opp;
            Opportunity_Invoice__c oppInvo =new Opportunity_Invoice__c();
            oppInvo.Opportunity__c = opp.id;
            oppInvo.Invoice_Amount__c =1000;
            oppInvo.Invoice_Id__c='INV-2Yn9WbzKO';
            oppInvo.CGST__c=20;
            oppInvo.SGST__c=30;
            oppInvo.IGST__c=10;
            Date d = Date.ValueOf(String.ValueOf(system.today()));
            String dateStr = d.year() + '-' + d.month() + '-' + d.day();
            oppInvo.Invoice_Date__c = Date.valueOf(dateStr);
            oppInvo.Status__c = 'posted';
            oppInvo.Odoo_Invoice_Id__c = 4545;
            oppInvo.Total_Tax_Value__c=50;
            oppInvo.Category__c='Site Services';
            insert oppInvo;

            Lead_Trace__c eachLeadTrace = new Lead_Trace__c(Opportunity__c = opp.Id, Status__c = 'Converted - Pending Sign-up', Tmestamp__c = Date.today());
            insert eachLeadTrace;
            Test.startTest();
            opp.StageName = 'Closed Won';
            opp.Region__c= 'Bengaluru';
            opp.X1st_Meeting_Date__c=Date.today();
            opp.Meeting_Type__c = 'EC';
            opp.Client_s_Budget__c =10000;
            opp.Signup_Amount__c=250;
            opp.X1st_Meeting_Person__c=user2.id;
            update opp;
            
            List<user> userstoInsert = new List<user>();
            UserRole r = [SELECT Id FROM UserRole WHERE Name='CHM'];
            Profile profSystAdm = [Select Id from profile where Name='System Administrator'];
            User u = new User(
                ProfileId = profSystAdm.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=r.id
            );
            userstoInsert.add(u);
            UserRole rSurvy = [SELECT Id FROM UserRole WHERE Name='Survey Team'];
            User uSurvy = new User(
                ProfileId = profSystAdm.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rSurvy.id
            );
           
            //Test.startTest();
            userstoInsert.add(uSurvy);
            UserRole r3D = [SELECT Id FROM UserRole WHERE Name='3D Shell Designer'];
            User u3D = new User(
                ProfileId = profSystAdm.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=r3D.id,
                Team__c='WDC_1'
            );
            userstoInsert.add(u3D);
            UserRole rPM = [SELECT Id FROM UserRole WHERE Name='Project Manager'];
            User uPM = new User(
                ProfileId = profSystAdm.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=rPM.id
            );
            userstoInsert.add(uPM);
            
            insert userstoInsert;
            
            LIst<TeamUserAssignmentNumber__c> teamUserAssgn = new List<TeamUserAssignmentNumber__c>();
            TeamUserAssignmentNumber__c teamAssinUser=new TeamUserAssignmentNumber__c();
            teamAssinUser.Name='Customer Happiness Manager Bengaluru';
            teamAssinUser.LastAssignedUserNumber__c=594;
            teamUserAssgn.add(teamAssinUser);
            
            TeamUserAssignmentNumber__c teamAssinUserSurvey=new TeamUserAssignmentNumber__c();
            teamAssinUserSurvey.Name='Survey Manager Bengaluru';
            teamAssinUserSurvey.LastAssignedUserNumber__c=594;
            teamUserAssgn.add(teamAssinUserSurvey);
            
            TeamUserAssignmentNumber__c teamAssinUser3D=new TeamUserAssignmentNumber__c();
            teamAssinUser3D.Name='3D Shell Designer Bengaluru';
            teamAssinUser3D.LastAssignedUserNumber__c=594;
            teamUserAssgn.add(teamAssinUser3D);
            
            TeamUserAssignmentNumber__c teamAssinUserPM=new TeamUserAssignmentNumber__c();
            teamAssinUserPM.Name='Project Manager Bengaluru';
            teamAssinUserPM.LastAssignedUserNumber__c=594;
            teamUserAssgn.add(teamAssinUserPM);
            
            insert teamUserAssgn;

            Virtual_Account_Number__c vAcc =new Virtual_Account_Number__c();
            vAcc.Name = 'test';
            vAcc.Status__c='Available';
            vAcc.VAN__c='12345';
            insert vAcc;
            
            Virtual_Account_Number__c vAcc1 =new Virtual_Account_Number__c();
            vAcc1.Name = 'test1';
            vAcc1.Status__c='Available';
            vAcc1.VAN__c='12345';
            insert vAcc1;
            
            Time myTime = Time.newInstance(10, 0, 0, 0);
            dateTime  lProjectStartDate = DateTime.newInstance(opp.CloseDate,myTime);
            
            Id recordTypeId =Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
            /*Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Test Project');
            project.Region__c='Bengaluru';
            project.recordTypeId=recordTypeId;
            project.Design_Team_Name__c='WDC_1';
            project.Default_Template_Project__c = true;
            project.Project_Duration_in_days__c=10;
            
            //Test.startTest();
            insert project;*/
            
            //List<Opportunity> oppList=[select id from Opportunity where id =:opp.id];
            map<id,Opportunity> OpportunityMap=new map<id,Opportunity>([select id from Opportunity where id =:opp.id]);
            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
            //SMSTriggeringEventsQueableClass smsObj=new SMSTriggeringEventsQueableClass('Opportunity',OpportunityMap.keyset() , false);
            
            // System.enqueueJob(queObj);
            //  Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
            //System.enqueueJob(smsObj);
            Test.stopTest();
        }
        
    }
    
    /*
    @isTest
    static void testmonthlyTarget() {
        User user2 = new User(
                ProfileId = [Select Id from profile where Name='Designer'].Id,
                Username = 'TestUserCheckOut@gmail.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
        insert user2;
        
        Incentive_Amount__c objIncentive = new Incentive_Amount__c();
            objIncentive.Name = 'Lead Incentive';
            objIncentive.Lead_Incentive__c = 4000;
            insert objIncentive;        
        Monthly_Target__c mt = new Monthly_Target__c(User__c = user2.Id, Month__c ='January' ,Year__c='2020',Target_Revenue__c=6500000.00,Experience_Center__c='MGDC' );
        insert mt;
        Monthly_Target__c mt2 = new Monthly_Target__c(User__c = user2.Id, Month__c ='December' ,Year__c='2019',Target_Revenue__c=6500000.00,Experience_Center__c='MGDC' );
        insert mt2;
        Opportunity opp = new Opportunity (Name ='testOpty' ,Designer__c= user2.Id,Signup_Amount__c=250,Meeting_Type__c='EC', stageName = 'Closed Won',Region__c='Bengaluru' ,X1st_Meeting_Date__c = system.today() , X1st_Meeting_Person__c = user2.Id,Wohoo_Card__c = '5678', closeDate = system.today() , Amount = 60000 , OwnerId = user2.Id);
        insert opp;              
        
    }
    
    @isTest
    static void testLeadTrace() {
        User user2 = new User(
                ProfileId = [Select Id from profile where Name='Designer'].Id,
                Username = 'TestUserCheckOut1@gmail.com',
                Alias = 'batman1',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
        Incentive_Amount__c objIncentive = new Incentive_Amount__c();
            objIncentive.Name = 'Lead Incentive';
            objIncentive.Lead_Incentive__c = 4000;
            insert objIncentive;
        insert user2;
        
        Opportunity opp2 = new Opportunity (Name ='testOpty' ,Designer__c= user2.Id, stageName = 'New' ,Meeting_Type__c='EC',Region__c='Bengaluru',X1st_Meeting_Date__c = system.today() , X1st_Meeting_Person__c = user2.Id,Wohoo_Card__c = '5678', closeDate = system.today().addDays(5) , Amount = 60000 , OwnerId = user2.Id);
        insert opp2;
        
        
        
        opp2.stageName = 'Closed Won';
        opp2.Wohoo_Card__c = '45678';
        opp2.Signup_Amount__c=250;
        update opp2;
        
        
    }*/
}