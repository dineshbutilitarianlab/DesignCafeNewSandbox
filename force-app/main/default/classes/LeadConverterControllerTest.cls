@isTest
public class LeadConverterControllerTest {
    
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
        SRR__c SRRThane = new SRR__c();
        SRRThane.Name = 'Thane DC';
        SRRThane.index__c = 0;
        insert SRRThane;
        SRR__c SRRJPDC = new SRR__c();
        SRRJPDC.Name = 'JPDC';
        SRRJPDC.index__c = 0;
        insert SRRJPDC;
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        insert SRRCHE;
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;       
        
        
        SRR__c SRRWLMUM1 = new SRR__c();
        SRRWLMUM1.Name = 'OMRCH';
        SRRWLMUM1.index__c = 0;
        insert SRRWLMUM1; 
        SRR__c SRRWLMUM2 = new SRR__c();
        SRRWLMUM2.Name = 'HRBRBLR';
        SRRWLMUM2.index__c = 0;
        insert SRRWLMUM2; 
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
    
    testMethod static void test(){
       
        Id p1 = [select id from profile where name='FOFO'].id;
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
        //Lea1.LastModifiedById = user1.Id;
        Lea1.City = 'Mumbai';
        Lea1.Channel__c = 'Online';
        Lea1.Source__c = 'Paid';
        insert Lea1;
        
        FeedItem fi = new FeedItem(ParentId = Lea1.Id, Body = 'Test Body');
        INSERT fi;
        System.debug('fi ==> ' + fi);
        
        LeadConverterController.postFeed(Lea1.Id);
        
    }
}