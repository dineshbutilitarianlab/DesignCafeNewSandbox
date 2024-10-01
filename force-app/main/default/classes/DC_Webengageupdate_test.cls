@isTest
public class DC_Webengageupdate_test {
    @istest
    Public static void web1(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        DCWebengage__c  cuset3= new DCWebengage__c();
        cuset3.Name = 'DCWebengageTask';
        cuset3.BearerToken__c = '9f5db61d-b95b-4dc7-a1ea-885b0a96ad6e';
        cuset3.url__c= 'https://api.webengage.com/v1/accounts/76aa813/events';
        insert cuset3; 
        
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
        
         SRR__c SRRChennai = new SRR__c();
        SRRChennai.Name = 'Chennai';
        SRRChennai.index__c = 0;
        insert SRRChennai;
        List<SRR__c> ssrRec = new List<SRR__c>();
        for(integer i = 0; i < = 11; i++){
             SRR__c ssrRecord = new SRR__c();
            if(i == 0)
              	 ssrRecord.Name = 'JPDC';
            if(i == 1)
         	 	 ssrRecord.Name = 'Thane DC';
     	    if(i == 2)
         	 	 ssrRecord.Name = 'KDRMYS';
            if(i == 3)
         	 	 ssrRecord.Name = 'YERPUN';
             if(i == 4)
          		 ssrRecord.Name = 'BHHYD';
             if(i == 5)
          		 ssrRecord.Name = 'SJPBLR';
             if(i == 6)
         		  ssrRecord.Name = 'KHMUM';
             if(i == 7)
        		   ssrRecord.Name = 'WLMUM';
             if(i == 8)
         		  ssrRecord.Name = 'OMRCH';
             if(i == 9)
         		  ssrRecord.Name = 'RSPCO';
            if(i == 10)
                 ssrRecord.Name = 'HRBRBLR';
      	   ssrRecord.index__c = 0;
            if(i == 11)
                 ssrRecord.Name = 'DNVIZ';
            ssrRec.add(ssrRecord);
        }
        	if(ssrRec.size() > 0)
                	insert ssrRec;
        
        Account acc =new Account();
        acc.Name='TestAccount1';
        insert acc;
        
          Lead Leadins = new lead();  
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.Email= 'Awdhesh1214@gmail.com';
        Leadins.Property_Type__c='villa';
        Leadins.Property_Possession_Date__c=System.today();
        Leadins.Project_Name__c='Awdhesh test';
        Leadins.Property_Type__c='0';
        leadins.Messaging_Source__c = '';
        leadins.CMM_Name__c = 'Harsh Gangawal';
        Leadins.Willingness_For_Meeting__c = system.today();
        leadins.Campagin__c = 'google';
        leadins.Home_Type__c= '2 BHK';
       leadins.OTP_Verified__c = 'YES';
        leadins.Wohoo_Card__c ='sevenfourzero';
      //  leadins.DesignerMobile__c= '9000000000';
        leadins.Date_When_Meeting_is_Scheduled__c = system.today()+2;
        Leadins.Call_Stage__c='';
        Leadins.DC_Lead_Status__c ='Recontacted';
        leadins.Re_Contact_Date__c = system.today();
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        leadins.Property_Usage__c ='Self';
        leadins.DSA_Code__c ='DC005643';
        leadins.Property_Possession_Date__c = system.today();
        leadins.Client_Site_visit__c ='Requested';
        leadins.Call_Stage__c = 'Low Budget';
        Leadins.Meeting_Type__c='EC';
        Leadins.Meeting_Venue__c='MGDC';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.DC_Campaign_Source__c ='Email';
        leadins.DC_Lead_Source__c ='Email';
        Leadins.Scope_Of_Work__c='Home interiors';
        Leadins.Interior_work_needed_for__c='Living Room';
        Leadins.Requirement_Details__c='Wardrobes';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        leadins.FirstName = 'testeasy';
        leadins.Email='imtiyaz043@dc.com';
        leadins.City= 'Bengaluru';
        leadins.CMM_Name__c='Harsh Gangwal';
        leadins.Meeting_Type__c = 'EC';
        leadins.Meeting_Venue__c= 'MGDC';
        leadins.Property_Address__c =' Mysore road Bengaluru';
        leadins.Messaging_Source__c= 'WhatsApp';
        leadins.Status= 'Meeting Scheduled';
        leadins.Source__c='Paid';
        leadins.LeadSource='Google adwards';
        Leadins.Description='test';
        Leadins.MobilePhone = '+910000000000';
        insert Leadins;
        
        
        Opportunity Opp= new Opportunity(); 
        Opp.AccountId= acc.id;
        Opp.Amount = 90000;
        Opp.Approx_Budget__c = '2L to 3L';
        Opp.StageName='Meeting Done';
       // Opp.Email__c= 'Awdhesh1214@gmail.com';
        Opp.Home_Type__c='villa';
       // Opp.Property_Possession_Date__c=System.today();
       // Opp.Design_User__c='';
      // Opp.DesignerEmail__c='test@ddc.com';
        Opp.Project_Name__c='Awdhesh test';
        Opp.Messaging_Source__c = '';
       // Opp.Opportunity_status__c ='Not Connected';
        Opp.Proposal_Sent_Date__c =system.today();
        Opp.Client_s_Budget__c = 1;
        Opp.Proposed_Budget__c = 1;
        Opp.Wohoo_Card__c='ghfdgtdresf';
        Opp.Project_Name__c='siri';
        Opp.CMM_Name__c ='Harsh Gangwal';
        Opp.Move_in__c = system.today();
        Opp.CMM_Name__c = 'Harsh Gangawal';
        Opp.Meeting_Date_and_Time__c = system.today();
        Opp.Campaign_Source__c= 'Referral';
        Opp.Home_Type__c= '2 BHK';
      // Opp.OTP_Verified__c = 'YES';
        Opp.Wohoo_Card__c ='sevenfourzero';
      //  Oppdata.DesignerMobile__c= '9000000000';
        Opp.Meeting_Scheduled_Date_Time__c = system.today()+2;
       // Opp.Call_Stage__c='';
        Opp.Channel__c = 'Online';
        Opp.Source__c = '';
        Opp.Region__c = 'Mumbai';
        Opp.Property_Usage__c ='Self';
        Opp.DSA_Code__c ='DC005643';
       // Opp.Property_Possession_Date__c = system.today();
        Opp.Client_Site_visit__c ='Requested';
     //   Opp.Call_Stage__c = 'Low Budget';
        Opp.Meeting_Type__c='EC';
        opp.CloseDate=System.today()+2;
        Opp.Meeting_Venue__c='MGDC';
        Opp.Campaign_Source__c ='Email';
        Opp.LeadSource='Email';
        Opp.Scope_Of_Work__c='Home interiors';
        Opp.Interior_work_needed_for__c='Living Room';
        Opp.Requirement_Details__c='Wardrobes';
        Opp.Knew_about_Design_Cafe_Because__c ='';
        Opp.Name = 'test';
        Opp.CMM_Name__c='Harsh Gangwal';
        Opp.Meeting_Type__c = 'EC';
        Opp.Meeting_Venue__c= 'MGDC';
        Opp.Property_Address__c =' Mysore road Bengaluru';
        Opp.Messaging_Source__c= 'WhatsApp';
        Opp.Source__c='Paid';
        Opp.LeadSource='Google adwards';
        Opp.Phone__c= '+910000000000';
        Opp.Lead_Id__c = Leadins.Id;
        insert Opp;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        DC_Webengageupdate.callout(Opp.id);
        Test.stopTest();
        
        Task taskRec = new Task();
        taskRec.whoid = Leadins.id;
        taskRec.subject = 'test webengae4';
        taskRec.disposition_code__c = 'RNR-Comms';
        insert taskRec;
        Set<Id> tskId = new Set<Id>();
        tskId.add(taskRec.id);
        Test.setMock(HttpCalloutMock.class, new DC_WebengageTaskMock());
        DC_WebnengageTask.callout(tskId);
    }
}