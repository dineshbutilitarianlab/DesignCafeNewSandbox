@isTest
public class DC_RestResourceCls_Test {

    static void initiateVarsHelper() {
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
        CPPortal__c cpp = new CPPortal__c();
		cpp.name = 'cpportalupdate';
        cpp.url__c = 'http://testurl.com';
        insert cpp;
    
        Design_User__c des = new Design_User__c();
        des.Name = 'testdesigner';
        des.Email__c = 'testdesigner@test.com';
        des.Designer_Dashboard_ID__c = 'ID';
        des.Role__c = 'Studio Manager';
        insert des;
        
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
        
        SRR__c SRRMysore = new SRR__c();
        SRRMysore.Name = 'KDRMYS';
        SRRMysore.index__c = 0;
        insert SRRMysore;    
        SRR__c SRRPune = new SRR__c();
        SRRPune.Name = 'YERPUN';
        SRRPune.index__c = 0;
		insert SRRPune;
        SRR__c SRRBHHyd = new SRR__c();
        SRRBHHyd.Name = 'BHHYD';
        SRRBHHyd.index__c = 0;
        insert SRRBHHyd;    
        SRR__c SRRSJP = new SRR__c();
        SRRSJP.Name = 'SJPBLR';
        SRRSJP.index__c = 0;
        insert SRRSJP;    
		SRR__c SRRNVM = new SRR__c();
        SRRNVM.Name = 'KHMUM';
        SRRNVM.index__c = 0;
        insert SRRNVM;    
        
       	SRR__c SRWLMUM = new SRR__c();
        SRWLMUM.Name = 'WLMUM';
        SRWLMUM.index__c = 0;
        insert SRWLMUM;  

        SRR__c SROMRCH = new SRR__c();
        SROMRCH.Name = 'OMRCH';
        SROMRCH.index__c = 0;
        insert SROMRCH; 
        
        SRR__c SRHRBRBLR = new SRR__c();
        SRHRBRBLR.Name = 'HRBRBLR';
        SRHRBRBLR.index__c = 0;
        insert SRHRBRBLR; 
        
        SRR__c SRRSPCO= new SRR__c();
        SRRSPCO.Name = 'RSPCO';
        SRRSPCO.index__c = 0;
        insert SRRSPCO; 
        
        SRR__c SRDNVIZ = new SRR__c();
        SRDNVIZ.Name = 'DNVIZ';
        SRDNVIZ.index__c = 0;
        insert SRDNVIZ; 
    }

    @isTest
    static void MSReschedule(){  
        initiateVarsHelper();

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
            grp.name = 'Mumbai DC_SalesRR';
            grp.Type = 'Regular'; 
            insert grp; 
            
            List<GroupMember> newGMList = new List<GroupMember>();
            newGMList.add(new GroupMember(UserOrGroupId = uDTL.id,GroupId = grp.Id));
            newGMList.add(new GroupMember(UserOrGroupId = uD.id,GroupId = grp.Id));
            newGMList.add(new GroupMember(UserOrGroupId = uDp.id,GroupId = grp.Id));
            insert newGMList; 
        }
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Meeting Scheduled","Property_Possession_Date":"2020/08/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.Willingness_For_Meeting__c  = system.today().adddays(1);
        Leadins.Meeting_Venue__c = 'Mumbai DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.DC_Lead_Status__c ='Meeting Rescheduled';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        insert Leadins;
        Leadins.DC_Lead_Status__c = 'Recontacted';
        Leadins.Whatsapp_Opt_IN__c = true;
        Leadins.Civil_Work__c = false;
        Leadins.Page_URL__c = 'rtyuiufd5678jfdxcvb';
        update Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void dsaidJ(){
		initiateVarsHelper();
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Property_Possession_Date":"2020/08/05","dsaid":"DCREF-0014568"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
       //Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Recontacted';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void dsaidATTR1(){
		initiateVarsHelper();
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Property_Possession_Date":"2020/08/05","dsaid":"DCREF-0014568"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Connected';
       //Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Recontacted';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-40);
        Leadins.Civil_Work__c = true;
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void dsaidFU(){
        initiateVarsHelper();
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Prospect","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05","dsaid":"test"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Followup';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
     //   Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Willingness_For_Meeting__c= system.today();
   //    	Leadins.MS_Date_Time__c = ((5 * 60) + 30)/1440;
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-40);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void dsaidNJFU(){
        initiateVarsHelper();
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Prospect","Call_Stage":"Undialed","MS_Date_Time":"2022-05-05T14:48:54.000Z","Property_Possession_Date":"2020/11/05","dsaid":"test"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Prospect';
        Leadins.Call_Stage__c='Pre-qualified';
        Leadins.DC_Lead_Status__c ='Pre-qualified';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
      //  Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Willingness_For_Meeting__c= system.today();
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-3);
        Leadins.Property_Possession_Date__c = system.today();
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void MSDateTImeNUll(){
		initiateVarsHelper();
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
            grp.name = 'Mumbai DC_SalesRR';
            grp.Type = 'Regular'; 
            insert grp; 
            
            List<GroupMember> newGMList = new List<GroupMember>();
            newGMList.add(new GroupMember(UserOrGroupId = uDTL.id,GroupId = grp.Id));
            newGMList.add(new GroupMember(UserOrGroupId = uD.id,GroupId = grp.Id));
            newGMList.add(new GroupMember(UserOrGroupId = uDp.id,GroupId = grp.Id));
            insert newGMList; 
        }  

        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Approx_Budget__c":"2L to 3L","Status":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05","Meeting_Type":"EC","Meeting_Venue":"MGDC","First_Name":"test","Last_Name":"testing","Email":"test@test.com","Property_Possession_Status":"Property in possession","Region":"Bangalore","AdGroup":"test"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.Call_Stage__c='Undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
		Leadins.Meeting_Venue__c = 'Mumbai DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.DC_Lead_Status__c ='Meeting Rescheduled';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-3);
   //     Leadins.MS_Date_Time__c= system.today();
        Leadins.Willingness_For_Meeting__c= system.today();
        insert Leadins;
        Leadins.Project_Name__c = 'test';
        update Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    /*
    @isTest
    static void MSDateTImeNoNUll(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Approx_Budget__c":"2L to 3L","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2022-05-05T14:48:54.000Z","Property_Possession_Date":"2020/11/05","Meeting_Type":"EC","Meeting_Venue":"MGDC","First_Name":"test","Last_Name":"testing","Email":"test@test.com","Property_Possession_Status":"Property in possession","Region":"Bangalore","AdGroup":"test"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Connected';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Junk';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
        Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-3);
   //     Leadins.MS_Date_Time__c= system.today();
        Leadins.Willingness_For_Meeting__c= system.today();
        insert Leadins;
        Leadins.Project_Name__c = 'test';
        update Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
*/
    @isTest
    static void MSDateTImeNoNUll5(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Approx_Budget__c":"2L to 3L","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2022-05-05T14:48:54.000Z","Property_Possession_Date":"2020/11/05","Meeting_Type":"EC","Meeting_Venue":"MGDC","First_Name":"test","Last_Name":"testing","Email":"test@test.com","Property_Possession_Status":"Property in possession","Region":"Bangalore","AdGroup":"test"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='New';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
      //  Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-55);
   //     Leadins.MS_Date_Time__c= system.today();
        Leadins.Willingness_For_Meeting__c= system.today();
        insert Leadins;
        Leadins.Project_Name__c = 'test';
        update Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void MSDateTImeNoNUll1(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Meeting Scheduled';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-60);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void MSDateTImeNoNUllAttr5L7(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Connected';
        Leadins.Call_Stage__c='Dialed';
        Leadins.DC_Lead_Status__c ='Undefined';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
      //  Leadins.LastModifiedDate = system.today().adddays(-40);
     //   Leadins.CreatedDate = system.today().adddays(-40);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = date.today().addDays(-50);
        //Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
      //  Leadins.LastModifiedDate = system.today().adddays(-40);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void MSDateTImeNoNUll2(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Confirmed';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Meeting Rescheduled';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
     //   Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-60);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void MSDateTImeNoNUll3(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Confirmed';
        Leadins.Call_Stage__c='Undialed';
       // Leadins.DC_Lead_Status__c ='Meeting Rescheduled';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
     //   Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-60);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void Newfollowup(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","DC_Lead_Status__c":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
        //Leadins.DC_Lead_Status__c ='Junk';
        //Leadins.Call_Stage__c='Undialed';  
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
      //  Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-28);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void junkonline(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","DC_Lead_Status__c":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
        Leadins.DC_Lead_Status__c ='Junk';
        Leadins.Call_Stage__c='Undialed';  
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
      //  Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-28);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void junkonline2(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","DC_Lead_Status__c":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
        Leadins.DC_Lead_Status__c ='Junk';
        Leadins.Call_Stage__c='Undialed';  
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-1);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-28);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void JunkReferral(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Referral","DC_Lead_Status__c":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05","EmpCode":"testing"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
        Leadins.DC_Lead_Status__c ='Junk';
        Leadins.Call_Stage__c='Undialed';  
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-10);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-28);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void JunkNull(){
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Referral","DC_Lead_Status__c":"Junk","Call_Stage":"Undialed","Property_Possession_Date":"2020/11/05","EmpCode":"testing"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='New';
        Leadins.DC_Lead_Status__c ='Junk';
        Leadins.Call_Stage__c='Undialed';  
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+911234567890';
       // Leadins.CreatedDate = system.today().adddays(-1);
        Leadins.Civil_Work__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-28);
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void RRCallout4() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        

        Design_User__c des = [SELECT Id FROM  Design_User__c WHERE Name = 'testdesigner' LIMIT 1];
        String gsRecordTypeID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('DC Call Center').getRecordTypeId();

        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = true;
        Leadins.Status ='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        //Leadins.ConvertedAccountId = Acc.Id;
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = system.today();
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Design_User__c = des.Id;
        Leadins.Designer__c = UserInfo.getUserId();
        Leadins.Client_s_Budget__c = 1000;
        Leadins.Civil_Work__c = true;
        insert Leadins;
        Leadins.Status = 'Converted';
        Leadins.Whatsapp_Opt_IN__c = true;
        Leadins.recordtypeId = gsRecordTypeID;
        //update Leadins;
        Acc.Whatsapp_Opt_IN__c = true;
        update Acc;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void RRCallout4NoCon() {
        initiateVarsHelper();
        Account ac = new Account();
        ac.Name = 'test';
        //  acc.PersonEmail ='test@test.com';
        //  acc.PersonMobilePhone ='9099990099';
        ac.BillingStreet = '5th block';
        ac.BillingCity = 'Bengaluru';
        ac.BillingState ='Karnataka';
        ac.BillingPostalCode ='560096';
        ac.BillingCountry = 'India';
        ac.ShippingStreet = '5th block';
        ac.ShippingCity = 'Bengaluru';
        ac.ShippingState = 'Karnataka';
        ac.ShippingPostalCode = '560096';
        ac.ShippingCountry ='India';
        insert ac;
	       

        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = true;
        
        Leadins.Status ='Meeting Confirmed';
        Leadins.DC_Lead_Status__c ='Meeting Done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
       // Leadins.ConvertedAccountId = Acc.Id;
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;

        insert Leadins;

        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.Lead_Id__c = Leadins.id;
        opp.AccountId = ac.id;
        opp.StageName = 'Meeting Done';
        opp.CloseDate = system.today();
        insert opp;

        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void RRCallout4NoConUD() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","Messaging_Source":"Chat","Empcode":"test"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Junk';
		Leadins.Call_Stage__c ='undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		//Leadins.CreatedDate = system.today().addDays(-7);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void RRCallout4NoConUD1() {
		initiateVarsHelper();	
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Referral","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","Messaging_Source":"Chat"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Junk';
		Leadins.Call_Stage__c ='undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		//Leadins.CreatedDate = system.today().addDays(-7);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void lastelse() {
        initiateVarsHelper();
        String myJSON = '{"Mobile":"+910000000000","otpverified":"yes","Channel_Type":"Referral","Status":"Junk","Call_Stage":"Undialed","EmpCode":"testing","SalesAgentEmail":"test@tset.com"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Junk';
        Leadins.DC_Lead_Status__c ='Dead';
		Leadins.Call_Stage__c ='All attempts done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
       
      //  Leadins.MS_Date_Time__c= date.today();
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		//Leadins.CreatedDate = system.today().addDays(-2);
        Leadins.Messaging_Source__c = 'chat';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void mobilePheqMobileWrap() {
        initiateVarsHelper();
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","EmpCode":"testing"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Followup';
        Leadins.DC_Lead_Status__c ='Undialed';
		Leadins.Call_Stage__c ='Undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '0000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.Messaging_Source__c = 'chat';
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-31);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void mobilePheqMobileWrapJ() {
        initiateVarsHelper();
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","EmpCode":"testing","Last_Name": "AMIT SINGH","Email": "azar.siratek1@gmail.com","Region":"Mumbai","Whatsapp_OptIN": false,"Property_Possession_Status": "Other","Property_Possession_Date": "2020/08/05","Property_Type_for_Interior": "1 BHK","Scope_Of_Work": "Home interiors","Approx_Budget": "2L to 3L","Requirement_Details": "TV Unit","Street": "Beach Road,Mumbai","Civil_Work": true,"Lead_Type": "Direct","Campaign_Source1": "Direct","Lead_Source": "Direct","Messaging_Source": "Chat","Source_Journey": "Website","MS_Date_Time": "2020-10-05T07:02:00.000Z","Meeting_Type": "EC","Meeting_Venue": "WDC"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Country_Code__c = '+91';
        Leadins.Property_Possession_Status__c = 'Property in possession';
        Leadins.Home_Type__c = '4+ BHK / Duplex';
        Leadins.Scope_Of_Work__c = 'Home interiors';
        Leadins.Requirement_Details__c = 'Wardrobes';
        Leadins.Street = 'Colony';
        Leadins.IsConverted = false;
        Leadins.Status ='Junk';
		Leadins.Call_Stage__c ='Undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '0000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.Messaging_Source__c = 'chat';
        Leadins.Whatsapp_Opt_IN__c = true;
        Leadins.Follow_Up_Date_Time__c = system.today().adddays(-29);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void mobilePheqMobileWrapNoJF() {
        initiateVarsHelper();
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Referral","Status":"Junk","Call_Stage":"Undialed","EmpCode":"testing","Last_Name":"test","Region":"Bangalore"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Prospect';
        Leadins.DC_Lead_Status__c ='Pre-qualified';
		Leadins.Call_Stage__c ='Pre-qualified';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '0000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.Messaging_Source__c = 'chat';
        Leadins.Follow_Up_Date_Time__c = system.today();
        Leadins.Property_Possession_Date__c = system.today();
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void RRCalloutCon() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
      

        Design_User__c des  = [SELECT Id FROM Design_User__c WHERE Name = 'testdesigner' LIMIT 1];
        /*User usr = new User();
        usr.email = 'testdesigner@test.com';
        usr.Name = 'Name';
        insert usr;*/

        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = true;
        Leadins.Status ='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Confirmed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
       // Leadins.ConvertedAccountId = Acc.Id;
        Leadins.Email = 'test@test.com';
		Leadins.Design_User__c = des.ID;
        Leadins.Client_s_Budget__c = 1000;
        Leadins.Designer__c = UserInfo.getUserId();
        Leadins.Willingness_For_Meeting__c = system.today();
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        insert Leadins;
        Leadins.Status = 'Converted';
        Leadins.Whatsapp_Opt_IN__c = true;
        Leadins.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('DC Call Center').getRecordTypeId();

        //update Leadins;
        Acc.Whatsapp_Opt_IN__c = true;
        update Acc;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
	@isTest
    static void RRCalloutwhatsappLead() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Whatsapp_OptIN": true,"Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Confirmed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        insert Leadins;
        Leadins.Whatsapp_Opt_IN__c = true;
        update Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
      //  CallCenterAPI.basicAuthCallout(lList.id);
    }
    
    @isTest
    static void DiffMobileMsdate() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Source":"Paid","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","Messaging_Source":"chat","Email": "azar.siratek1@gmail.com","Region":"Mumbai","Whatsapp_OptIN": false,"Property_Possession_Status": "Other","Property_Possession_Date": "2020/08/05","Property_Type_for_Interior": "1 BHK","Scope_Of_Work": "Home interiors","Approx_Budget": "2L to 3L","Requirement_Details": "TV Unit","Street": "Beach Road,Mumbai","Civil_Work": true,"Lead_Type": "Direct","Campaign_Source1": "Direct","Lead_Source": "Direct","Source_Journey": "Website","Meeting_Type": "EC","Meeting_Venue": "WDC"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        //insert Acc;
		Design_User__c des = new Design_User__c();
        des.Name = 'testdesigner';
        des.Email__c = 'testdesigner@test.com';
        des.Designer_Dashboard_ID__c = 'ID';
        des.Role__c = 'Studio Manager';
        //insert des;

        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = true;
        Leadins.Status ='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.Old_Source__c = 'Direct';
        Leadins.DC_Campaign_Source__c = 'Direct';
        Leadins.DC_Lead_Source__c = 'Direct';
      //  Leadins.Designer_Name__c= 'imtiaz';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.YMURL__c = '';
        Leadins.FirstName = 'test';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Country_Code__c = '+91';
        Leadins.Property_Possession_Status__c ='Property in possession';
        Leadins.Home_Type__c = '4+ BHK / Duplex';
        Leadins.Scope_Of_Work__c = 'Bedroom';
        Leadins.Requirement_Details__c = 'Wardrobes';
        Leadins.Street = 'test';
       // Leadins.ConvertedAccountId = Acc.Id;
        Leadins.Client_s_Budget__c = 1000;
        Leadins.Designer__c = UserInfo.getUserId();
        Leadins.Design_User__c = des.Id;
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        Leadins.Whatsapp_Opt_IN__c = false;
        Leadins.Property_Possession_Date__c = date.today();
        //insert Leadins;
        Leadins.Status = 'Converted';
        Leadins.Whatsapp_Opt_IN__c = true;
        //update Leadins;
        Acc.Whatsapp_Opt_IN__c = true;
        //update Acc;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        //Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }

    @isTest
    static void DiffMobileNoMsdate() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","Messaging_Source":"chat","Email": "azar.siratek1@gmail.com","Region":"Mumbai","Whatsapp_OptIN": false,"Property_Possession_Status": "Other","Property_Possession_Date": "2020/08/05","Property_Type_for_Interior": "1 BHK","Scope_Of_Work": "Home interiors","Approx_Budget": "2L to 3L","Requirement_Details": "TV Unit","Street": "Beach Road,Mumbai","Civil_Work": true,"Lead_Type": "Direct","Campaign_Source1": "Direct","Lead_Source": "Direct","Source_Journey": "Website"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
       // Leadins.LastModifiedDate =date.today();
        
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        leadins.LastName = 'test';
        leadins.City = 'Mumbai';
        leadins.MobilePhone='1234567890';
        leadins.Email = 'imtiyaz@dc.com';
       // l.Status = 'new';
        //l.Channel__c = 'online';
        
        leadins.Whatsapp_Opt_IN__c = true;
        leadins.Willingness_For_Meeting__c = system.today();
        
        Lead l1 = new Lead();
        l1.LastName = 'test1';
        l1.City = 'Mumbai';
        l1.MobilePhone='1234567891';
        l1.Email = 'imtiyaz1@dc.com';
        l1.Whatsapp_Opt_IN__c = true;
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Civil_Work__c = true;
       // insert Leadins;
        Leadins.Whatsapp_Opt_IN__c = true;
       // update Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void DiffMobiledsaid() {
		initiateVarsHelper();        
        String myJSON = '{"Mobile":"1234567890","Channel_Type":"Offline","Lead_Type":"DSA","Source":"DSA","Status":"New","Call_Stage":"Undialed","Property_Possession_Date":"2020-11-05T14:48:54.000Z","dsaid":"DCREF-0014568","Email":"test@test.com","Region":"Mumbai","Project_Name":"test","Area":"test","Notes":"test","Area_Code":"560098"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Meeting Scheduled';
       //Leadins.DC_Lead_Status__c ='Undialed';
        Leadins.Call_Stage__c = 'Undialed';
        Leadins.Channel__c = 'Offline';
        Leadins.Source__c = 'DSA';
        Leadins.Old_Source__c = leadins.Source__c;
        Leadins.Project_Name__c = 'test';
        Leadins.Area__c = 'test';
        Leadins.DSA_Code__c = 'test';
        Leadins.Description = 'test';
        Leadins.PostalCode = '560098';
        Leadins.City = 'Mumbai';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '0000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        Leadins.Whatsapp_Opt_IN__c = true;
        insert Leadins;
        DC_RestResourceCls.doPost(); 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
     //   CallCenterAPI.basicAuthCallout(lList.id);
    }
    /* 
      @isTest
    static void RRCallout4NoConJOn() {
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Junk';
        Leadins.DC_Lead_Status__c ='Dead';
		Leadins.Call_Stage__c ='All attempts done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.CreatedDate = system.today().addDays(-2);
        Leadins.Page_URL_1__c = 'fjkiu6789kjf';
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
    @isTest
    static void RRCallout4NoConJRef() {
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Messaging_Source":"Chat","Channel_Type":"Referral","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","EmpCode":"testing"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Junk';
        Leadins.DC_Lead_Status__c ='Dead';
		Leadins.Call_Stage__c ='All attempts done';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
       // Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.CreatedDate = system.today().addDays(-2);
        insert Leadins;
        DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    }
*/
     /* @isTest
    static void RRCallout4NoConPMM() {
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","MS_Date_Time":"2020-11-05T14:48:54.000Z","Meeting_Type":"EC","Meeting_Venue":"MGDC"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; */
        /*Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;*/
        /*Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Prospect';
        Leadins.DC_Lead_Status__c ='Meeting Scheduled';
		Leadins.Call_Stage__c ='Meeting Scheduled';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        insert Leadins;
       // DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    } 
    @isTest
    static void RRCallout4NoConAnyStage() {
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
        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Referral","Status":"Connected","Call_Stage":"Undialed","empcode":"testing","Messaging_Source":"Chat"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Connected';
        Leadins.DC_Lead_Status__c ='Qualified';
		Leadins.Call_Stage__c ='undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.Follow_Up_Date_Time__c = system.today().adddays(-31);
        Leadins.Property_Possession_Date__c = system.today();
        insert Leadins;
       // DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
       // CallCenterAPI.basicAuthCallout(lList.id);
    } 
    @isTest
    static void RRCallout4NoConAnyStageChaOn() {
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage":"Undialed","empcode":"testing","Messaging_Source":"Chat"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.site.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Account Acc = new account();
        Acc.name = 'testing';
        insert Acc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='Prospect';
        Leadins.DC_Lead_Status__c ='Qualified';
		Leadins.Call_Stage__c ='undialed';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
		Leadins.Follow_Up_Date_Time__c = system.today().adddays(-32);
        Leadins.Property_Possession_Date__c = system.today();
        insert Leadins;
      //  DC_RestResourceCls.doPost();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        //CallCenterAPI.basicAuthCallout(lList.id);
    } */
    
    @isTest
    static void testCover(){
        OpportunityTriggerCMMhandler.testCoverage();
    }
    
}