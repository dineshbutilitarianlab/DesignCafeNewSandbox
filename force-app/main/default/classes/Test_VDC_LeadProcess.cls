@isTest
public class Test_VDC_LeadProcess {

    
    @TestSetup
    public static void testSetupMethod(){
        
        //insert Custom setting for LeadTrigger
        TriggerControl__c tc = New TriggerControl__c();
        tc.name = 'LeadTrigger';
        tc.Run__c = true;
        insert tc;
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
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

        SRR__c SRRWLMUM3 = new SRR__c();
        SRRWLMUM3.Name = 'RSPCO';
        SRRWLMUM3.index__c = 0;
        insert SRRWLMUM3;
        SRR__c SRRWLMUM4 = new SRR__c();
        SRRWLMUM4.Name = 'DNVIZ';
        SRRWLMUM4.index__c = 0;
        insert SRRWLMUM4; 
        
        
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
    //    testSetupMethod();
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
        List<lead> ldList =new List<Lead>();
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Scheduled';
        Lea.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        Lea.Broadcast_Status__c = '0';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        Lea.MobilePhone = '9890987654';
        Lea.Channel__c = 'Offline';
        Lea.Source__c = 'DSA';
       // insert Lea;
        ldList.add(Lea);
        insert ldList;
        Test.startTest();
        System.runAs(u){
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
        Test.stopTest();
        }
    }
    
    
    
  
    
    static TestMethod Void BroadcastIs1(){
        
    // testSetupMethod();
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
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
        List<lead> ldList1 =new List<Lead>();
        Lead Lea1 = new Lead();
        Lea1.LastName  = 'testing Lead';
        Lea1.Status = 'New';
        Lea1.MobilePhone = '9890987654';
        Lea1.Broadcast_Status__c = '1';
       // Lea1.LastModifiedById = u1.Id;
        Lea1.City = 'Mumbai';
        Lea1.Channel__c = 'Offline';
        Lea1.Source__c = 'DSA';
       	// insert Lea;
        ldList1.add(Lea1);
        insert ldList1;
        Test.startTest();
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList1);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Test.stopTest();
    }
    static TestMethod Void BroadcastDesignerUserNoNull(){
        //insert DU user
        Design_User__c du = new Design_User__c();
        du.name = 'test du user';
        du.Designer_Dashboard_ID__c = 'test du';
        du.Email__c = 'test@test.com';
        du.Role__c = 'Design Partner';
        insert du;
        
    //  testSetupMethod();
        //insert Lead
        List<Lead> ldList2 =new List<Lead>();
        Lead Lea2 = new Lead(MobilePhone = '8987667876', LastName  = 'testing Lead', Status = 'New', Design_User__c = du.Id, City = 'Mumbai',Channel__c = 'Offline', Source__c = 'DSA');
        /*Lea2.LastName  = 'testing Lead';
        Lea2.Status = 'New';
        Lea2.Design_User__c = du.Id;
        Lea2.City = 'Mumbai';
        Lea2.Channel__c = 'Offline';
        Lea2.Source__c = 'DSA';
       // insert Lea;*/
        ldList2.add(Lea2);
        insert ldList2;
        List<Lead> testLead = [SELECT Id, LastName,Design_User__c,City,Channel__c, Source__c,LastModifiedById,DC_Lead_Status__c,Willingness_For_Meeting__c,Broadcast_Status__c,PB_BS_1_or_3_or_4__c,OwnerId,Status,PB_Current_user_ID__c From Lead Where Id =: ldList2[0].Id ];
        Test.startTest();
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(testLead); 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Test.stopTest();
    }
    static TestMethod Void BroadcastDesignerUserNull(){
    //     testSetupMethod();
        
        //insert Lead
       List<lead> ldList3 =new List<Lead>();
        Lead Lea3 = new Lead();
        Lea3.LastName  = 'testing Lead';
        Lea3.Status = 'New';
        Lea3.PB_BS_1_or_3_or_4__c = true;
        Lea3.City = 'Mumbai';
        Lea3.MobilePhone = '9890987654';
        Lea3.Channel__c = 'Offline';
        Lea3.Source__c = 'DSA';
       
        // insert Lea;
        ldList3.add(Lea3);
        insert ldList3;
        List<Lead> testLead1 = [SELECT Id, LastName,Status,PB_BS_1_or_3_or_4__c,City,Channel__c,Source__c,LastModifiedById,OwnerId,Willingness_For_Meeting__c,Broadcast_Status__c,PB_Current_user_ID__c,Design_User__c, DC_Lead_Status__c From Lead Where Id =: ldList3[0].Id ];
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(testLead1);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
   static TestMethod Void CCerror(){
    //   testSetupMethod();
       Id SysId = [select Id from Profile where Name = 'System Administrator' limit 1].Id;
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
                          ProfileId = SysId); 
        insert u;
        //Lead Creation
        system.runAs(u){
            List<lead> ldList =new List<Lead>();
            Lead Lea = new Lead();
            Lea.LastName  = 'testing Lead';
            Lea.Status = 'New';
            Lea.DC_Lead_Status__c = 'CC Error';
            Lea.Meeting_Venue__c = 'MGDC';
            Lea.Willingness_For_Meeting__c = system.now();
            Lea.Meeting_Type__c = 'EC';
            Lea.Broadcast_Status__c = '0';
            Lea.Call_Stage__c = 'Low Budget';
            Lea.City = 'Mumbai';
            Lea.MobilePhone = '9890987654';
            Lea.Channel__c = 'Offline';
        	Lea.Source__c = 'DSA';
		// insert Lea;
        ldList.add(Lea);
        insert ldList;
            
            List<Lead> testLead2 = [SELECT Id,LastName,Status,DC_Lead_Status__c,Meeting_Venue__c,Willingness_For_Meeting__c,PB_BS_1_or_3_or_4__c,Design_User__c,Meeting_Type__c,Source__c,OwnerId, LastModifiedById,Channel__c,City,Call_Stage__c,Broadcast_Status__c From Lead Where Id =: ldList[0].Id];
            Test.startTest();
         VDC_LeadProcesstoApex.BroadcastAndOwnerChange(testLead2);
         Test.setMock(HttpCalloutMock.class, new CCMockUp());
            Test.stopTest();
        }
        
    } 
    //Modification Start   
       static TestMethod Void CCerror1(){
       //testSetupMethod();
            
            Id CCA = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
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
                          ProfileId = CCA); 
        insert u1;
        //Lead Creation
        system.runAs(u1){
            List<lead> ldList1 =new List<Lead>();
            Lead Lea1 = new Lead();
            Lea1.LastName  = 'testing Lead';
            Lea1.Status = 'New';
            Lea1.DC_Lead_Status__c = 'CC Error';
            Lea1.Meeting_Venue__c = 'MGDC';
            Lea1.Willingness_For_Meeting__c = system.now();
            Lea1.Meeting_Type__c = 'EC';
            Lea1.Broadcast_Status__c = '0';
            Lea1.Call_Stage__c = 'Low Budget';
            Lea1.City = 'Mumbai';
            Lea1.MobilePhone = '9890987654';
            Lea1.Channel__c = 'Offline';
        	Lea1.Source__c = 'DSA';
		// insert Lea;
        ldList1.add(Lea1);
        insert ldList1;
         VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList1);
        }
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    
    static TestMethod Void CCerror2(){
      // testSetupMethod();
            
        Id AffiliateId = [select Id from Profile where Name = 'Affiliate' limit 1].Id;
        
        //User Creation
        user u2 = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = AffiliateId); 
        insert u2;
        //Lead Creation
        system.runAs(u2){
            List<lead> ldList2 =new List<Lead>();
            Lead Lea2 = new Lead();
            Lea2.LastName  = 'testing Lead';
            Lea2.Status = 'Meeting Scheduled';
            Lea2.DC_Lead_Status__c = 'CC Error';
            Lea2.Meeting_Venue__c = 'MGDC';
            Lea2.Willingness_For_Meeting__c = system.now();
            Lea2.Meeting_Type__c = 'EC';
            Lea2.Broadcast_Status__c = '0';
            Lea2.Call_Stage__c = 'Low Budget';
            Lea2.City = 'Mumbai';
            Lea2.Channel__c = 'Offline';
            Lea2.MobilePhone = '9890987654';
        	Lea2.Source__c = 'DSA';
            //Lea2.Call_Center_Agent__c = u2.Id;
			Lea2.Meeting_Scheduled_by__c = Null;
            
		// insert Lea;
        ldList2.add(Lea2);
        try {
            insert ldList2;
            VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList2);
        } catch (Exception e) {
            
        }
        
        }
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
 static TestMethod Void CCerror3(){
    //   testSetupMethod();
            
        Id CMMId = [select Id from Profile where Name = 'CMM' limit 1].Id;
        
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
                          ProfileId = CMMId); 
        insert u;
        //Lead Creation
        system.runAs(u){
            List<lead> ldList =new List<Lead>();
            Lead Lea = new Lead();
            Lea.LastName  = 'testing Lead';
            Lea.Status = 'Meeting Scheduled';
            Lea.DC_Lead_Status__c = 'CC Error';
            Lea.Meeting_Venue__c = 'MGDC';
            Lea.Willingness_For_Meeting__c = system.now();
            Lea.Meeting_Type__c = 'EC';
            Lea.Broadcast_Status__c = '0';
            Lea.Call_Stage__c = 'Low Budget';
            Lea.City = 'Mumbai';
            Lea.Channel__c = 'Offline';
            Lea.MobilePhone = '9890987654';
        	Lea.Source__c = 'DSA';
			Lea.Meeting_Scheduled_by__c = Null;
		// insert Lea;
        ldList.add(Lea);
        try {
            insert ldList;
            VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        } catch (Exception e) {
            
        }

        }
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
static TestMethod Void CCerror4(){
       //testSetupMethod();
            
        Id SEId = [select Id from Profile where Name = 'Sales Executive' limit 1].Id;
        
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
                          ProfileId = SEId); 
        insert u;
        //Lead Creation
        system.runAs(u){
            List<lead> ldList =new List<Lead>();
            Lead Lea = new Lead();
            Lea.LastName  = 'testing Lead';
            Lea.Status = 'Meeting Scheduled';
            Lea.DC_Lead_Status__c = 'CC Error';
            Lea.Meeting_Venue__c = 'MGDC';
            Lea.Willingness_For_Meeting__c = system.now();
            Lea.Meeting_Type__c = 'EC';
            Lea.Broadcast_Status__c = '0';
            Lea.Call_Stage__c = 'Low Budget';
            Lea.City = 'Mumbai';
            Lea.Channel__c = 'Offline';
            Lea.MobilePhone = '9890987654';
        	Lea.Source__c = 'DSA';
			Lea.Meeting_Scheduled_by__c = Null;
		// insert Lea;
        ldList.add(Lea);
        // insert ldList;
        //  VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        }
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    
    // Modification End
            
    static TestMethod Void ConnectedChat(){
    //     testSetupMethod();
       List<lead> ldList =new List<Lead>(); 
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Messaging_Source__c = 'Chat';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        Lea.City = 'Mumbai';
        Lea.Channel__c = 'Offline';
        Lea.MobilePhone = '9890987654';
        Lea.Source__c = 'DSA';
       // insert Lea;
        ldList.add(Lea);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void ConnectedNotChat(){
    //     testSetupMethod();   
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
       string ProfileName = [Select Id, Name from Profile where Id=:u.profileId].Name;
        system.debug('ProfileName'+profileName);
       List<lead> ldList =new List<Lead>();
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Scheduled_by__c = null;
        Lea.Meeting_Venue__c = 'HSRDC';
        Lea.Meeting_Type__c = 'EC';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Bengaluru';
        Lea.Channel__c = 'Offline';
        Lea.MobilePhone = '9890987654';
        Lea.Source__c = 'DSA';
       // insert Lea;
       
        ldList.add(Lea);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void ConnectedCCAgent(){
    //    testSetupMethod();
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
        List<lead> ldList =new List<Lead>();
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
     //   Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        Lea.Channel__c = 'Offline';
        Lea.MobilePhone = '9890987654';
        Lea.Source__c = 'DSA';
       // insert Lea;
        ldList.add(Lea);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void ConnectedCCTeamLead(){
    //    testSetupMethod();
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
        List<lead> ldList =new List<Lead>();
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
      //  Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        Lea.Channel__c = 'Offline';
        Lea.MobilePhone = '9890987654';
        Lea.Source__c = 'DSA';
        //insert Lea;
        ldList.add(Lea);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void DCMeetingScheduled(){
    //    testSetupMethod();
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
        List<lead> ldList =new List<Lead>();
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Scheduled';
        Lea.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        Lea.Channel__c = 'Offline';
        Lea.MobilePhone = '9890987654';
        Lea.Source__c = 'DSA';
       // insert Lea;
        ldList.add(Lea);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    
  
 static TestMethod Void MsByCC(){
  //   testSetupMethod();           
          
    Id p = [select id from profile where name='Call Center Agent'].id;
    Id p1 = [select id from profile where name='Call Center Team Lead'].id;
   String orgId=UserInfo.getOrganizationId(); 
   
    User user = new User(alias = 'test8008', email='test8008@gmail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                timezonesidkey='America/Los_Angeles', username='test8008@noemail.com');
          
     insert user;
        
        List<lead> ldList =new List<Lead>();
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
        //Lea1.LastModifiedById = user.Id;
        Lea1.City = 'Mumbai';
        Lea1.MobilePhone = '9890987654';
        Lea1.Channel__c = 'Offline';
        Lea1.Source__c = 'DSA';
    
       // insert Lea1;
        ldList.add(Lea1);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
                    
        Test.setMock(HttpCalloutMock.class, new CCMockUp());   
    system.runAs(user)  {
             
    }
    
      }
    
static TestMethod Void MsByAffiliate(){
       // testSetupMethod();
    Id p = [select id from profile where name='Affiliate'].id;
    Id p1 = [select id from profile where name='FOFO'].id;
   String orgId=UserInfo.getOrganizationId(); 

         
     User user1 = new User(alias = 'test8009', email='test8009@gmail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p1, country='United States',IsActive =true,
                timezonesidkey='America/Los_Angeles', username='test8009@noemail.com');      
          
    insert user1;
          
         List<lead> ldList =new List<Lead>();
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
    	Lea1.Channel__c = 'Offline';
        Lea1.MobilePhone = '9890987654';
        Lea1.Source__c = 'DSA';
    
       // insert Lea1;
        ldList.add(Lea1);
        insert ldList;
        VDC_LeadProcesstoApex.BroadcastAndOwnerChange(ldList);
          
        Test.setMock(HttpCalloutMock.class, new CCMockUp());   
    system.runAs(user1)  {
      
    }
    
      }    
     
}