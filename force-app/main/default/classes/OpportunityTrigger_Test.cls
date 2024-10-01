/*
* Modified : 27th Jan 2022 - Colbridge - added whoohooTest(), portalUpdateTest
*/
@isTest
public class OpportunityTrigger_Test {

    @TestSetup
    public static void makeData(){
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

        UserRole r = [SELECT Id FROM UserRole WHERE Name='Designer'];
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

        Lead leadA = new Lead(
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
        insert leadA;
    }

    @IsTest
    static void methodName(){
        
        Test.startTest();

       
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];

        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

		CPPortal__c data = new CPPortal__c();
		data.Name = 'cpportalopportunityupdate';
		data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;
        
        Account acc =new Account();
        acc.Name='TestAccount';
        insert acc;
        
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        
        
        Opportunity opty = new Opportunity();
        opty.Name='OppTest';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.Remarks_For_Marketing__c = 'test 26-day delivery, My offer';
        opty.Offer_and_discounts__c = 'No Offer;Superply upgrade Offer';
        insert opty;
        opty.Remarks_For_Marketing__c = 'test remark';
        opty.Offer_and_discounts__c = 'Superply upgrade Offer';

        update opty;
        test.stopTest();
        
    }

    @IsTest
    static void testoffersPicklistChange(){
        
        Test.startTest();

       
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];

        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

		CPPortal__c data = new CPPortal__c();
		data.Name = 'cpportalopportunityupdate';
		data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;
        
        Account acc =new Account();
        acc.Name='TestAccount';
        insert acc;
        
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        
        
        Opportunity opty = new Opportunity();
        opty.Name='OppTest';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.Remarks_For_Marketing__c = 'test 26-day delivery';
        opty.Offer_and_discounts__c = 'No Offer';
        insert opty;
        opty.Remarks_For_Marketing__c = 'test remark';
        opty.Offer_and_discounts__c = 'Superply upgrade Offer';

        update opty;
        test.stopTest();

        
    }

    @isTest  
    public static void opportunityTest(){
        test.startTest();
       
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];

        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

		CPPortal__c data = new CPPortal__c();
		data.Name = 'cpportalopportunityupdate';
		data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;
        
        Account acc =new Account();
        acc.Name='TestAccount';
        insert acc;
        
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        
        
        Opportunity opty = new Opportunity();
        opty.Name='OppTest';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.Remarks_For_Marketing__c = 'test 26-day delivery';
        opty.Offer_and_discounts__c = 'No Offer';
        insert opty;
        opty.Remarks_For_Marketing__c = 'test remark';
        opty.Offer_and_discounts__c = 'Superply upgrade Offer';

        update opty;
        test.stopTest();
        
        
    }
    
    @isTest static void oppTest2(){

        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());

        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        CPPortal__c data = new CPPortal__c();
		data.Name = 'cpportalopportunityupdate';
		data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;

        Account acc =new Account();
        acc.Name='TestAccount1';
        
        insert acc;
        test.startTest();
        
        Contact con = new Contact();
        con.FirstName='testcon';
        con.AccountId =acc.Id;
        con.LastName='emily';
        con.Email='conemail@testemail.com';
        insert con;
        
       
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer1';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        System.debug('Design:: '+Design);
        
        Opportunity opty = new Opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c =userinfo.getUserId(); //'0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = Design.Id;
        opty.Is_Pm_Site__c=True;
        //opty.Lead_Id__c = leadRecord.Id;
        opty.Meeting_Venue__c='Mumbai Dc';
        
        insert opty;
         Quote qt = new Quote();
        qt.Name ='test';
        qt.OpportunityId = opty.id;
        qt.Latest_Quote__c=false;
        insert qt;
        qt.Latest_Quote__c=true;
        qt.Modular_Discount__c = 2;
        qt.Site_Services_Discount__c = 3;
        qt.Site_Service_Fixed_Discount__c = 2;
        qt.Modular_Fixed_Discount__c = 4;
        qt.Status ='Approved';
        //qt.Name = 'Updated Test';
        try{
        update qt;
        }catch(Exception e){}
        
        System.debug('###'+opty.Email__c+'::opty: '+opty.Design_User_Name__c+'### '+opty.Region__c+'### '+opty.SalesManagerName__c+'##### '+opty.SalesManagerEmail__c);
        
        
        opty.stagename='Proposal Sent';        
        
        update opty;
        Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup());
        test.stopTest();
    }
    
    
    // Test oppty. stage Closed Won for whoohoo card
    @isTest static void whoohooTest(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        CPPortal__c data = new CPPortal__c();
		data.Name = 'cpportalopportunityupdate';
		data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;

        quickcilver__c  cusSet1 = new quickcilver__c();
        cusSet1.Name = 'quickcilver details';
        cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
        cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
        cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
        
        cusSet1.Token_Date__c = System.today();
        insert cusSet1;
        
        Account acc =new Account();
        acc.Name='TestAccount1';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName='testcon';
        con.AccountId =acc.Id;
        con.LastName='emily';
        con.Email='conemail@testemail.com';
        insert con;
        
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer1';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        System.debug('Design:: '+Design);
        test.startTest();
        Opportunity opty = new Opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c =userinfo.getUserId(); //'0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = Design.Id;
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Project_Created_On_Odoo__c = true; 
        opty.Update_Booking_Form__c = true; 
        opty.Offer_and_discounts__c = 'No Offer';
        insert opty;
        
        Quote qt = new Quote();
        qt.Name ='test';
        qt.OpportunityId = opty.id;
        qt.Latest_Quote__c=false;
        insert qt;
        qt.Latest_Quote__c=true;
        qt.Modular_Discount__c = 2;
        qt.Site_Services_Discount__c = 3;
        qt.Site_Service_Fixed_Discount__c = 2;
        qt.Modular_Fixed_Discount__c = 4;
        qt.Status ='Approved';
        //qt.Name = 'Updated Test';
        try{
        update qt;
        }catch(exception e){}
        
        System.debug('###'+opty.Email__c+'::opty: '+opty.Design_User_Name__c+'### '+opty.Region__c+'### '+opty.SalesManagerName__c+'##### '+opty.SalesManagerEmail__c);
        
        
        opty.stagename='Closed Lost'; 
        opty.Opportunity_status__c = 'Lost';
        opty.Reason__c = 'Low Budget';
        
        update opty;
        Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup());
        test.stopTest();
    }
    
    // Test portal update api
    @isTest static void portalUpdateTest(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];

        CPPortal__c data = new CPPortal__c();
		data.Name = 'cpportalopportunityupdate';
		data.url__c = 'https://uat-designerbackenddc.herokuapp.com/updateOpportunity';
        insert data;

        quickcilver__c  cusSet1 = new quickcilver__c();
        cusSet1.Name = 'quickcilver details';
        cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
        cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
        cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
        
        cusSet1.Token_Date__c = System.today();
        insert cusSet1;
        
        Account acc =new Account();
        acc.Name='TestAccount1';
        // acc.DSA__c = '0015D00000g3JsHQAU';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName='testcon';
        con.AccountId =acc.Id;
        con.LastName='emily';
        con.Email='conemail@testemail.com';
        insert con;
        
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer1';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        System.debug('Design:: '+Design);
        
        Opportunity opty = new Opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c =userinfo.getUserId(); //'0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = Design.Id;
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Project_Created_On_Odoo__c = true; 
        opty.Update_Booking_Form__c = true; 
        opty.Client_s_Budget__c = 100;
        opty.Proposed_Budget__c = 100;
        opty.Offer_and_discounts__c = 'No Offer';
        // opty.DSA__c = '0015D00000g3JsHQAU';
        test.startTest();
        insert opty;
         Quote qt = new Quote();
        qt.Name ='test';
        qt.OpportunityId = opty.id;
        qt.Latest_Quote__c=false;
        qt.Oppty_Customer_email__c = 'puser000@amamama.com';
        qt.oppty_Designer_Email_add__c = 'puser000@amamama.com';
        insert qt;
        qt.Latest_Quote__c=true;
        qt.Modular_Discount__c = 2;
        qt.Site_Services_Discount__c = 3;
        qt.Site_Service_Fixed_Discount__c = 2;
        qt.Modular_Fixed_Discount__c = 4;
        qt.Status ='Approved';
        //qt.Name = 'Updated Test';
        try{
        update qt;
        }catch(exception e){}
        
        
        System.debug('###'+opty.Email__c+'::opty: '+opty.Design_User_Name__c+'### '+opty.Region__c+'### '+opty.SalesManagerName__c+'##### '+opty.SalesManagerEmail__c);
        
        
        opty.stagename='Closed Lost';
        opty.Opportunity_status__c = 'Lost';
        opty.Reason__c = 'Low Budget';
        opty.Region__c='Bengaluru'; 
        
        update opty;
        Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup());
        test.stopTest();
    }
    
        /*
        @isTest static void deleteOpp(){

        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;

        //   quickcilver__c  cusSet1 = new quickcilver__c();
        //     cusSet1.Name = 'quickcilver details';
        //    cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjMyOTgxNzIxLCJ0b2tlbiI6IjE4N2QzYTMxMzFkOGFhNThjMGFlZGQ1Y2ZmMDBhNzcyIn0.9RvHRlS--EXp-f950oNlwesW3nc3g9SDBhlOr2LlNfM';
        //     cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
        //     cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
        //     cusSet1.Token_Date__c = System.today();
        //    insert cusSet1; 

        Account acc =new Account();
        acc.Name='TestAccount1';
        insert acc;
        Contact con = new Contact();
        con.FirstName='testcon';
        con.AccountId =acc.Id;
        con.LastName='emily';
        con.Email='conemail@testemail.com';
        insert con;

        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer1';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;

        insert Design;


        Opportunity opty = new Opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = design.Id;
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';


        test.startTest();
        insert opty;  	  

        opty.StageName ='Closed Won';
        opty.Update_Booking_Form__c =true;

        // Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup());
        test.stopTest();
        }
        */
       /*@isTest static void oppDeleteTest(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        Lead leadRecord = [SELECT Id FROM LEAD LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());

        quickcilver__c  cusSet1 = new quickcilver__c();
        cusSet1.Name = 'quickcilver details';
        cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
        cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
        cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
        
        cusSet1.Token_Date__c = System.today();
        insert cusSet1;
        
        Account acc =new Account();
        acc.Name='TestAccount1';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName='testcon';
        con.AccountId =acc.Id;
        con.LastName='emily';
        con.Email='conemail@testemail.com';
        insert con;
        
        Design_User__c Design= new Design_User__c(); 
        //Design.DesignUserNumber__c='DES-USER0698';
        Design.Name='Test Designer1';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        insert Design;
        
        Opportunity opty = new Opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = leadRecord.Id;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = design.Id;
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Project_Created_On_Odoo__c = true; 
        opty.Update_Booking_Form__c = true; 
        opty.Client_s_Budget__c = 100;
        opty.Proposed_Budget__c = 100;
        insert opty;  
        
        test.startTest();
        List<Opportunity> lstOpty = [Select Id, Name From Opportunity Where Id = :opty.Id];
        delete lstOpty;
        // Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup());
        RecursiveTriggerHandler.runOnce();
        RecursiveTriggerHandler.runOnceAfter();
        RecursiveTriggerHandler.runOnceLead();
        RecursiveTriggerHandler.runOnceLeadAfter();
        test.stopTest();
    }*/
    
}