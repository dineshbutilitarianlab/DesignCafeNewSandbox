/*
* Code Modifier : V-Fory Team
* Modified Date : 13th October 2021
* Modified By   : Munna
*/ 
@istest
public class Test_SalesRoundRobin {
    
    public static void test_setup() {
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
        
        SRR__c SRRRSPCO = new SRR__c();
        SRRRSPCO.Name = 'RSPCO';
        SRRRSPCO.index__c = 0;
        insert SRRRSPCO;
        
        SRR__c SRRDNVIZ = new SRR__c();
        SRRDNVIZ.Name = 'DNVIZ';
        SRRDNVIZ.index__c = 0;
        insert SRRDNVIZ;
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        Leadtogenesys__c lts = new Leadtogenesys__c();
        lts.Name = 'genesysapi';
        lts.url__c = 'LeadTrigger';
        insert lts;
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
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
        lnumbCust.Mumbai_Thane_User_Count__c    =5;
        lnumbCust.Lead_Number_Navi_Mumbai__c = 4;
        lnumbCust.Navi_Mumbai_User_Count__c = 2;
        insert lnumbCust; 
        
    }
    
    public static Lead prepareLead() {
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Mumbai';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Type__c='EC';
        ld.Meeting_Venue__c = 'Mumbai DC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';    
        return ld;
    }
    /*@istest 
    public static void SRRmum(){
        test_setup();        
        List<String> meetingVenues = new List<String>();
        meetingVenues.add('Mumbai DC');
        meetingVenues.add('MGDC');
        meetingVenues.add('HSRDC');
        meetingVenues.add('Chennai DC');
        meetingVenues.add('Hyderabad DC');
        meetingVenues.add('WDC');
        meetingVenues.add('JPDC');
        meetingVenues.add('Thane DC');
        meetingVenues.add('KDRYMS');
        meetingVenues.add('YERPUN');
        meetingVenues.add('BHHYD');
        meetingVenues.add('SJPBLR');
        meetingVenues.add('KHMUM');
        meetingVenues.add('WLMUM');
        meetingVenues.add('OMRCH');
        meetingVenues.add('HRBR');
        meetingVenues.add('RSPCO');
        
        //        
        for (String meetingVenue : meetingVenues) {
            List<Lead> leadList = new List<Lead>();
            Map<Id,Lead> LdOldMap = new Map<Id,Lead>();
            
            Lead ld = prepareLead();
            ld.Meeting_Venue__c = meetingVenue;
            insert ld;
            leadList.add(ld);
            LdOldMap.put(ld.id,ld);
            Lead_SalesRoundRobin.assignSalesuserByRR(leadList,LdOldMap);
            Test.setMock(HttpCalloutMock.class, new CCMockUp());  
        }
    } */  
    @istest 
    public static void SRRHyd(){
        test_setup();
        
        List<Lead> l = new List<Lead>();       
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Hyderabad';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='Hyderabad DC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;    
        l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }  
    @istest 
    public static void SRRMGDC(){
        test_setup();
        
        List<Lead> l = new List<Lead>();       
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld; 
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }   
    @istest 
    public static void SRRWDC(){
        test_setup();
        
        List<Lead> l = new List<Lead>();       
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='WDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld; 
        l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    } 
    @istest 
    public static void SRRHSRDC(){
        test_setup();
        
        List<Lead> l = new List<Lead>();      
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='HSRDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;    
        l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRche(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Chennai';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='Chennai DC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRROMRCH(){
    test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='OMRCH';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRjpdc(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='JPDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRthanedc(){
        test_setup();
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Thane';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='Thane DC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRKDRMYS(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Mysore';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='KDRMYS';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRYERPUN(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Pune';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='YERPUN';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
   /* @istest 
    public static void SRRmum(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Mumbai';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='Mumbai DC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
       // l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } */
    @istest 
    public static void SRRBHHYD(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Hyderabad';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='BHHYD';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRSJPBLR(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='SJPBLR';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
    @istest 
    public static void SRRWLMUM(){
        test_setup();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Navi Mumbai';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='WLMUM';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';     
        insert ld;
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
     @istest 
    public static void SRRHRBR(){
        test_setup();
        
        List<Lead> l = new List<Lead>();       
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='HRBR';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld; 
        l.add(ld);
        //  Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }
      @istest 
    public static void SRRDNVIZ(){
        test_setup();
        
        List<Lead> l = new List<Lead>();       
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Visakhapatnam';
        ld.Channel__c = 'Online';
        ld.Source__c = 'Paid';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='DNVIZ';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Meeting Scheduled';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;    
        l.add(ld);
        // Lead_SalesRoundRobin.assignSalesuserByRR(l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());  
    }  
    
}