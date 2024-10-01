@isTest public class AccountTrigger_Test {
  @TestSetup
  static void makeData(){
            
    DCWebengage__c cuset2= new DCWebengage__c();
    cuset2.Name = 'Dcwebengage';
    cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
    cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
     insert cuset2;
      //
     CPPortal__c  cuset3= new CPPortal__c();
     cuset3.Name = 'cpportalopportunityinsert';
     cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
     insert cuset3; 
     CPPortal__c  cuset4= new CPPortal__c();
     cuset4.Name = 'cpportalopportunityupdate';
     cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
     insert cuset4;

     quickcilver__c  cusSet1 = new quickcilver__c();
     cusSet1.Name = 'quickcilver details';
     cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
     cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
     cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
     cusSet1.Token_Date__c = System.today();
     insert cusSet1;

     Offer__c testOffer = new Offer__c(
          Name = 'Test Offer',
          Start_Date__c = system.now(),
          End_Date__c = system.now()+7,
          Offer_Applicable_On__c = 'Modular;Site Services',
          Status__c = 'Active',
          Allowed_Cities__c = 'Bengaluru;Mysore;Chennai;Pune;Mumbai;Hyderabad;Outstation;Thane;Navi Mumbai;Coimbatore;Visakhapatnam',
          Description__c = 'Description__c',
          Business_Type__c = 'COCO;FOCO;FOFO',
          Type_Of_Offer__c = 'Discount Offer',
          Allowed_ECs__c = 'MGDC;WDC;Mumbai DC;Hyderabad DC;HSRDC;Chennai DC;Thane DC;KDRMYS;YERPUN;YERPUN;JPDC;SJPBLR;KHMUM;WLMUM;OMRCH;HRBRBLR;RSPCO;DNVIZ',
          Approval_Status__c = true,
          Min_Modular_Discount_less_5L__c = 3,
          Max_Modular_Discount_less_5L__c = 19,
          Min_Site_Services_Discount_less_5L__c = 2,
          Max_Site_Sevices_Discount_less_5L__c = 10
     );
     insert testOffer;
  }

    @isTest public static void accTest(){
        
      
        
    id RecordTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        Account acc =new Account();   
        acc.FirstName='TestAc';
        acc.LastName='Account';
        acc.PersonEmail='test@gmail.com';
        acc.Phone='9876543210';
        acc.PAN__c='ASDFG1234M';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street no 5';
        acc.BillingPostalCode='560001';
        acc.Customer_type__c='B2C';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        acc.Opportunity_Stage__c = 'Closed Won';
        acc.Channel_Marketing_Manager__c = uDesign.Id;
        insert acc;
        
        Account acc2 =new Account();   
        acc2.FirstName='TestAc';
        acc2.LastName='Account';
        acc2.PersonEmail='test@gmail.com';
        acc2.PersonMobilePhone='9008008765';
        acc2.Phone='9876543210';
        acc2.PAN__c='ASDFG1234M';
        acc2.l10n_in_gst_treatment__c='Regular';
        acc2.GST_No__c='06BZAHM6385P6Z2';        
        acc2.BillingCountry='India';
        acc2.BillingState='Karnataka';
        acc2.BillingCity='Bengaluru';
        acc2.BillingStreet='MG Road Street,no 5';
        acc2.BillingPostalCode='560001';
        acc2.ShippingStreet ='MG Road Street,no 5';
        acc2.Customer_type__c='B2C';
        acc2.Converted_Lead_ID__c='ASDFG45676GFD';
        insert acc2;
        acc2.Customer_type__c= 'B2B';
        update acc2;
               
        Design_User__c Design= new Design_User__c();
        Design.Name='Test Designer';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@gmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        insert Design;
        
       opportunity opty=new opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Design_User__c =Design.id;
        opty.Amount = 10000;
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
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Lead_Id__c='ASDF456789HJK';
        opty.Offer_and_discounts__c = 'No Offer';
        insert opty; 
        
        Opportunity opp = new Opportunity();
        opp.Name = 'ClosedWonOpp';
        opp.AccountId = acc.Id;
        opp.StageName = 'Closed Won';
        opp.Amount = 10000;
        opp.CloseDate = System.today();
        insert opp;
        
      	Request_Payment__c rp = new Request_Payment__c ();
        rp.Opportunity__c = opty.Id;
        insert rp;
		       
        Invoice_Payment__c InvPay = new Invoice_Payment__c();
        InvPay.Opportunity_Name__c = opty.id;
        InvPay.Mode_of_Receipt__c = 'Cash';
        InvPay.Date_of_Payment__c = system.today();
        InvPay.RP_Recipt_ID__c = 'TR456-73';
        InvPay.Modular_value__c=1000;
        InvPay.Site_Service_value__c=1000;
        InvPay.Receipt_Amount__c=1000;    
        InvPay.paymentID__c='';
        insert InvPay;  
        InvPay.paymentID__c='PI45678';
        update InvPay;
        
        opty.Update_Booking_Form__c = true;
        update opty;
    
        Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
    }
}