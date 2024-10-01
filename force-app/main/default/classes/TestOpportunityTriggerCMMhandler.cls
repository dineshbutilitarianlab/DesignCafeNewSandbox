@istest
public class TestOpportunityTriggerCMMhandler {
    
    @istest static void getTargetRevenueOfCMMs(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        
        SRR__c SRRHRBR = new SRR__c();
        SRRHRBR.Name = 'HRBRBLR';
        SRRHRBR.index__c = 0;
        insert SRRHRBR;
        
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        
        
        
        TriggerControl__c tc = new TriggerControl__c(Name = 'LeadTrigger', Run__c = true);
        insert tc;
        
        Design_User__c designUsers = new Design_User__c(
            Name = 'Test Design User 1',
            Designer_Dashboard_ID__c = '355',
            Role__c= 'Inhouse Designer',
            Email__c = 'test@gmail.com',
            Mobile__c = '7834764321',
            Region__c = 'Bengaluru',
            Experience_Center__c = 'HSRDC'   
        );
        
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'New',
            LARR__c = false,
            bypassSMleadOwnervalidation__c = true,
            Design_User__c = designUsers.id,
            city = 'Bengaluru'
        );
        
        Lead testLead2 = new Lead(
            FirstName = 'Test2',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'New',
            LARR__c = false,
            bypassSMleadOwnervalidation__c = false,
            Design_User__c = designUsers.id,
            city = 'Mumbai'
        );
        
        insert testLead2;
        insert testLead;
        Incentive_Amount__c objAmount = new Incentive_Amount__c();
        objAmount.Name = 'Lead Incentive';
        objAmount.CGST__c = 10;
        objAmount.IGST__c = 10;
        objAmount.Lead_Incentive__c = 100;
        insert objAmount;
        

        Virtual_Account_Number__c vanObj=new Virtual_Account_Number__c();
        vanObj.Status__c='Available';
        vanObj.VAN__c='12345';
        insert vanObj;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId,Converted_Lead_ID__c =testLead2.Id);
        insert acc;
        
        Id projRecordTypeId = Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByName().get('Interior Works Project').getRecordTypeId(); 
        Milestone1_Project__c objProject = new Milestone1_Project__c();
        objProject.Name = 'Project';
        objProject.RecordTypeId = projRecordTypeId;
        objProject.Virtual_Account_Number__c = vanObj.id;
        objProject.Customer__c=acc.id;
        objProject.Default_Template_Project__c = true;
        ObjProject.Project_Duration_in_days__c = 5;
        insert objProject; 
        
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test1', Project__c = objProject.id, type__c='KYC',Relative_Kickoff_Date_in_days__c = 0,Relative_Deadline_in_days__c = 10);
        insert milestone;
        
        Contact con = new Contact();
        con.LastName = 'Team';
        insert con;
        
        UserRole r3D = [SELECT Id FROM UserRole WHERE Name='3D Shell Designer'];
        User u3D = new User(
            ProfileId = [Select Id from profile where Name='System Administrator'].Id,
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
        
        
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Designer'];
        User CmmUser = new User(ProfileId = [Select Id from profile where Name='System Administrator'].Id, LastName = 'krishna', FirstName = 'Goutham',Email = 'puser000@amamama.com',
                                Username = 'puser001@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title',
                                Alias = 'alias1', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', Region__c='Bengaluru', userroleid=r.id);
        
        System.runAs(new User(id=UserInfo.getUserId())) {
            insert u3D;
            insert CmmUser;
        }
        
        Project_Team_Member__c objProjTeam = new Project_Team_Member__c();
        objProjTeam.Project__c = objProject.Id;
        objProjTeam.User__c = u3D.Id;
        objProjTeam.Role__c = 'Primary Designer';
        objProjTeam.Customer_Contact__c = con.Id;
        insert objProjTeam;
        
        
        account ac = new account();
        ac.Name = 'testing';
        ac.CMM_Name__c = 'Goutham krishna';
        ac.BillingStreet = 'Jubliee Hills';
        ac.BillingCity = 'Bangalore';
        ac.BillingState = 'Karnataka';
        ac.BillingCountry = 'India';
        ac.BillingPostalCode = '560095';
        ac.ShippingStreet = 'Jubliee Hills';
        ac.ShippingCity = 'Bangalore';
        ac.ShippingState = 'Karnataka';
        ac.ShippingCountry = 'India';
        ac.ShippingPostalCode = '560095';
        ac.Converted_Lead_ID__c   = testLead2.id;
        insert ac;
        
        opportunity opp = new opportunity();
        opp.Name = 'testing';
        opp.AccountId = ac.Id;
        opp.StageName = 'working';
        opp.Amount = 500000;
        opp.CloseDate = system.today(); 
        opp.Designer__c = CmmUser.id;
        opp.Lead_Id__c = testLead2.Id;
        insert opp;
        
        
        CMM_Monthly_Target__c CMMMonth = new CMM_Monthly_Target__c();
        CMMMonth.user__c = CmmUser.Id;
        CMMMonth.Month__c = 'April';
        CMMMonth.Year__c = '2020';
        CMMMonth.Target_Revenue__c = 600000;
        insert CMMMonth;
        
        
        opp.CMM_Name__c = 'Goutham krishna';
        opp.StageName = 'closed Won';
        opp.Wohoo_Card__c = 'testing';
        opp.X1st_Meeting_Date__c = system.today();
        opp.X1st_Meeting_Person__c = CmmUser.Id;
        opp.Region__c = 'Hyderabad';
        opp.Signup_Amount__c = 100;
        test.startTest();
            update opp;
        test.stopTest();
        
    }      
}