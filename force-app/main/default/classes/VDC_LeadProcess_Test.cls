@IsTest
public class VDC_LeadProcess_Test {
    @TestSetup
    Static void SetUpMethod(){
        //insert Custom setting for LeadTrigger
        TriggerControl__c tc = New TriggerControl__c();
        tc.name = 'LeadTrigger';
        tc.Run__c = true;
        insert tc;
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
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
        
        SRR__c SRRKHM = new SRR__c();
        SRRKHM.Name ='KHMUM';
        SRRKHM.index__c = 0;
        insert SRRKHM; 
        
        SRR__c SRRWL = new SRR__c();
        SRRWL.Name ='WLMUM';
        SRRWL.index__c = 0;
        insert SRRWL; 
        
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name ='OMRCH';
        SRROMRCH.index__c = 0;
        insert SRROMRCH;         
  
        DC_Center_To_Group_Mapping__c Dcgm = new DC_Center_To_Group_Mapping__c();
        Dcgm.Name = 'testing';
        Dcgm.Venue_Name__c = 'MGDC';
        Dcgm.Public_Group_Name__c = 'Sales MGDC_1';
        insert Dcgm;
        Leadtogenesys__c lts = new Leadtogenesys__c();
        lts.Name = 'genesysapi';
        lts.url__c = 'LeadTrigger';
        insert lts;
        Design_User__c Duser = new Design_User__c();
        Duser.Name = 'testing';
        Duser.Designer_Dashboard_ID__c = '123456789';
        Duser.Role__c = 'Design Partner';
        Duser.Email__c = 'test@test.com';
        Duser.Mobile__c = '9876543210';
        Duser.Region__c = 'mumbai';
        Duser.Experience_Center__c = 'WDC';
        insert Duser;
    }
    static TestMethod Void BroadcastIs0(){
        
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
        
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Scheduled';
        Lea.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        Lea.Broadcast_Status__c = '0';
        //Lea.LastModifiedById = u.Id;
        lea.Approx_Budget__c = '2L to 3L';
        lea.Channel__c = 'Online';
        lea.Source__c = 'Referral';
        lea.MobilePhone = '1234567890';
        lea.Email = 'testlead@gmail.com';   
        Lea.City = 'Mumbai';
        Lea.Region__c='Mumbai';
        lea.Client_s_Budget__c =560000;
        insert Lea;
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void BroadcastIs1(){
        
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
        
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.Broadcast_Status__c = '1';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void BroadcastDesignerUserNoNull(){
        //insert DU user
        Design_User__c du = new Design_User__c();
        du.name = 'test du user';
        du.Designer_Dashboard_ID__c = 'test du';
        du.Email__c = 'test@test.com';
        du.Role__c = 'Design Partner';
        insert du;
        
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
        
        
        //insert Lead
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.Design_User__c = du.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void BroadcastDesignerUserNull(){
        
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
        
        //insert Lead
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.PB_BS_1_or_3_or_4__c = true;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void CCerror(){
        
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
        Id ccAgentId = [select Id from Profile where Name = 'DesignCafe Profile' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        Lead Lea;
        //Lead Creation
        system.runAs(u){
            Design_User__c du = new Design_User__c();
            du.name = 'test du user';
            du.Designer_Dashboard_ID__c = 'test du';
            du.Email__c = 'test@test.com';
            du.Role__c = 'Design Partner';
            insert du;
            Lea = new Lead();      
            Lea.LastName  = 'testing Lead';
            Lea.Status = 'Meeting Scheduled';
            Lea.DC_Lead_Status__c = 'CC Error';
            Lea.Meeting_Venue__c = 'MGDC';
            Lea.Messaging_Source__c='Chat';
            Lea.Region__c='Mumbai';
            Lea.Willingness_For_Meeting__c = system.now();
            Lea.Meeting_Type__c = 'EC';
            Lea.Broadcast_Status__c = '0';
            Lea.Channel__c='Referral';
            Lea.Source__c='Referral';
            Lea.OwnerId=u.id;
            lea.MobilePhone = '1234567890';
            lea.Email = 'testlead@gmail.com';   
            Lea.City = 'Mumbai';
            lea.Client_s_Budget__c =560000;
            lea.Approx_Budget__c = '2L to 3L';
            Lea.Call_Stage__c ='Not Interested';
            insert Lea;
        }
      /*  Test.startTest();        
        FeedItem feed = new FeedItem (
            parentid = Lea.id,
            type = 'ContentPost',
            Body = 'Hello'
        );
        try {
            insert feed;    
        } catch (exception e) {
            System.assert(e.getMessage().contains('Sorry..!! You cannot attach this file format'));
        } */
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
       // Test.stopTest();      
        
    } 
    static TestMethod Void ConnectedChat(){
        
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
        
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Messaging_Source__c = 'Chat';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void ConnectedNotChat(){
        
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
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        //Lead Creation
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Meeting_Type__c = 'EC';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void ConnectedCCAgent(){
        
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
        
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        Id ccTeamLeadId = [select Id from Profile where Name = 'Call Center Team Lead' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'CCTeamLead@designer.com', 
                          Username = 'CCTeamLead@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccTeamLeadId); 
        insert u;
        //User Creation
        user u1 = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'designeruser@designer.com', 
                           Username = 'designeruser@designer.com', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = 'deus', 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = ccAgentId); 
        insert u1;
        //Lead Creation
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void ConnectedCCTeamLead(){
        
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
        
        Id ccTeamLeadId = [select Id from Profile where Name = 'Call Center Team Lead' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'CCTeamLead@designer.com', 
                          Username = 'CCTeamLead@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccTeamLeadId); 
        insert u;
        //Lead Creation
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
      //  Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void DCMeetingScheduled(){
        
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
        
        Id DCId = [select Id from Profile where Name = 'DesignCafe Profile' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = DCId); 
        insert u;
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Scheduled';
        Lea.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    
    static TestMethod Void MsByCC(){
        
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
        
        Id p = [select id from profile where name='Call Center Agent'].id;
        Id p1 = [select id from profile where name='Call Center Team Lead'].id;
        String orgId=UserInfo.getOrganizationId(); 
        
        User user = new User(alias = 'test8008', email='test8008@gmail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='test8008@noemail.com');
        
        insert user;
        
        Lead Lea1 = new Lead();
        Lea1.LastName  = 'testing Lead';
        Lea1.Status = 'Meeting Scheduled';
        Lea1.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea1.Meeting_Venue__c = 'MGDC';
        Lea1.Messaging_Source__c = 'Chat';
        Lea1.Willingness_For_Meeting__c = system.today();
        Lea1.Meeting_Type__c = 'EC';
        Lea1.Meeting_Scheduled_by__c = 'Call Center';  
        Lea1.Broadcast_Status__c = '1';
       // Lea1.LastModifiedById = user.Id;
        Lea1.City = 'Mumbai';
        insert Lea1;
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());   
        system.runAs(user)  {
        }
    }
    
    static TestMethod Void MsByAffiliate(){
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
        
        Id p = [select id from profile where name='Affiliate'].id;
        Id p1 = [select id from profile where name='FOFO'].id;
        String orgId=UserInfo.getOrganizationId(); 
        
        User user1 = new User(alias = 'test8009', email='test8009@gmail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p1, country='United States',IsActive =true,
                              timezonesidkey='America/Los_Angeles', username='test8009@noemail.com');      
        
        insert user1;
        
        Lead Lea1 = new Lead();
        Lea1.LastName  = 'testing Lead';
        Lea1.Status = 'Meeting Scheduled';
        Lea1.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea1.Meeting_Venue__c = 'MGDC';
        Lea1.Messaging_Source__c = 'Chat';
        Lea1.Willingness_For_Meeting__c = system.today();
        Lea1.Meeting_Type__c = 'EC';
        Lea1.Meeting_Scheduled_by__c = 'Affiliate';  
        Lea1.Broadcast_Status__c = '1';
       // Lea1.LastModifiedById = user1.Id;
        Lea1.City = 'Mumbai';
        insert Lea1;
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());   
        system.runAs(user1)  {
            
        }
    }
}