@isTest
public class Lead_Workflowupdates_test{
    @isTest
    static void Lead_Workflowupdates(){
        List<SRR__c> SRRList = new List<SRR__c>();
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
         Leadtogenesys__c lts = new Leadtogenesys__c();
        lts.Name = 'genesysapi';
        lts.url__c = 'LeadTrigger';
        insert lts;
        
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
        
        
        Lead olead = new Lead(LastName='Test',FirstName='Tester',Channel__c = 'Online',Approx_Budget__c = '2L to 3L',Meeting_Type__c = 'EC',Status='Meeting Scheduled',Willingness_For_Meeting__c = system.today(),Meeting_Venue__c = 'Chennai DC',City = 'Chennai',DC_Lead_Status__c = 'Meeting Scheduled');
        insert olead;
        Lead_Workflowupdates.MSCheckneedtocheck(new List<Lead>{olead});
        Lead_Workflowupdates.Leadstageconverted(new List<Lead>{olead});
       
        
       /* 
        Test.startTest();
       Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='prospect';
        Leadins.Call_Stage__c='Meeting Scheduled';
        Leadins.DC_Lead_Status__c ='Meeting Scheduled';
        Leadins.Meeting_Type__c = 'EC';
        leadins.Date_When_Meeting_is_Scheduled__c=system.today();
        Leadins.Meeting_Venue__c = 'Mumbai DC';
        Leadins.Willingness_For_Meeting__c = system.today();
        Leadins.City = 'Mumbai';
        Leadins.LastName = 'test';
        Leadins.Email='aba@gmail.com';
        Leadins.MobilePhone = '+910000000000';
        Leadins.Whatsapp_Opt_IN__c = true;
        Leadins.Is_MS__c = true;
      // Leadins.ConvertedOpportunityId='00Q5D000002uUgtUAE';
     //  Leadins.ConvertedOpportunityId= opp.Lead_Id__c;
        insert Leadins;
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Lead_Stage__c = 'New';
        opp.CloseDate = System.today()+10;
        opp.StageName = 'Meeting Done';
        opp.Id=Leadins.ConvertedOpportunityId;
        opp.Lead_Id__c = Leadins.Id;
        Update opp;
        
       
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
     //   CallCenterAPI.basicAuthCallout(lList.id);
        Test.stopTest();*/
        
      
    }
}