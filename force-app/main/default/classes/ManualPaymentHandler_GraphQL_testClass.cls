@isTest
public class ManualPaymentHandler_GraphQL_testClass {
    @isTest
    public static void addPayment() {
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
		
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
		
		Account acc =new Account();
        acc.FirstName='TestAc';
        acc.LastName='Account';
        acc.PersonEmail='test@gmail.com';
        acc.PersonMobilePhone='9008008765';
        acc.Phone='9876543210';
        acc.PAN__c='BAQMW1254Z';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='34CIPPS5925M1ZF';
        acc.Customer_type__c = 'B2B';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street';
        acc.BillingPostalCode='560001';
    	acc.ShippingCountry='India';
        acc.ShippingState='Karnataka';
        acc.ShippingCity='Bengaluru';
        acc.ShippingStreet='MG Road Street';
        acc.ShippingPostalCode='560001';
    	acc.Converted_Lead_ID__c='ASDFG45676GFD';
    	insert acc;
        
    	
		Opportunity opty=new opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.Region__c = 'Bengaluru';
        opty.CloseDate = system.today();
        opty.Amount=3124;
        opty.OwnerId =userinfo.getUserId();
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Requirement_Details__c='Wardrobes';
    	opty.Modular_Amount_Dis_Incl_GST__c=3000;
        opty.Flooring_is_completed_Required__c=true;
    	opty.IsNewPaymentProject__c=true;
    	opty.Lead_Id__c='ASDF456789HJK';
        insert opty;
		
        Opportunity opty1=new opportunity();
        opty1.Name='TestOpp';
        opty1.AccountId=acc.Id;
        opty1.stagename = 'Meeting Done';
        opty1.Wohoo_Card__c = '567';
        opty1.Signup_Amount__c = 88788;
        opty1.Client_s_Budget__c = 8989;
        opty1.Probability = 100;
        opty1.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty1.X1st_Meeting_Date__c = system.today();
        opty1.Meeting_Type__c = 'EC';
        opty1.Region__c = 'Bengaluru';
        opty1.CloseDate = system.today();
        opty1.Amount=3124;
        opty1.OwnerId =userinfo.getUserId();
        opty1.Is_Pm_Site__c=True;
        opty1.Meeting_Venue__c='Mumbai Dc';
        opty1.Modular_Milestone_Type__c='3 Stage';
        opty1.Requirement_Details__c='Wardrobes';
    	opty1.Modular_Amount_Dis_Incl_GST__c=3000;
        opty1.Flooring_is_completed_Required__c=false;
    	opty1.IsNewPaymentProject__c=false;
    	opty1.Lead_Id__c='ASDF456789HJK';
        Insert opty1;
        
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
        InvPay.Receipt_Amount__c=2000;    
        InvPay.paymentID__c = null;
        InvPay.Request_Payment_Modular__c = rp.Id;
        InvPay.Request_Payment_SiteService__c = rp.Id;
        insert InvPay;
        test.startTest();
      
		Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        ManualPaymentHandler_GraphQL.addPayment(opty.Id);
        ManualPaymentHandler_GraphQL.addPayment(opty1.id);
    	test.stopTest();
    }
   @isTest
    public static void UpdatePaymentReceipts() {
        
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalopportunityinsert';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalopportunityupdate';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
		
		Id RecordTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		opportunity opty;       
        Account acc;
        Account acc1;
		acc =new Account();
        acc.RecordTypeId=RecordTypeAcc;   
        acc.FirstName='TestAc';
        acc.LastName='Account';
        acc.PersonEmail='test@gmail.com';
        acc.PersonMobilePhone='9008008765';
        acc.Phone='9876543210';
        acc.PAN__c='BAQMW1254Z';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='34CIPPS5925M1ZF';
        acc.Customer_type__c = 'B2B';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.BillingCity='Bengaluru';
        acc.BillingStreet='MG Road Street';
        acc.BillingPostalCode='560001';
    	acc.ShippingCountry='India';
        acc.ShippingState='Karnataka';
        acc.ShippingCity='Bengaluru';
        acc.ShippingStreet='MG Road Street';
        acc.ShippingPostalCode='560001';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
    	insert acc;
    	
		opty=new opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.Region__c = 'Bengaluru';
        opty.CloseDate = system.today();
        opty.Amount=3124;
        opty.OwnerId =userinfo.getUserId();
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
        opty.Requirement_Details__c='Wardrobes';
    	opty.Modular_Amount_Dis_Incl_GST__c=3000;
        opty.Flooring_is_completed_Required__c=false;
    	opty.IsNewPaymentProject__c=true;
        opty.Lead_Id__c='ASDF456789HJK';
        insert opty;
		
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
        InvPay.Receipt_Amount__c=2000;    
        InvPay.paymentID__c = null;
        InvPay.Request_Payment_Modular__c = rp.Id;
        InvPay.Request_Payment_SiteService__c = rp.Id;
        insert InvPay;
    
        InvPay.Modular_value__c=1500;
        InvPay.Site_Service_value__c=1400;
        //InvPay1.RP_Recipt_ID__c ='TR456-79';
        InvPay.Receipt_Amount__c=5001;    
        Update InvPay; 
    	test.startTest();
        Test.setMock(HttpCalloutmock.class, new AuthorizationTokenMock());
        ManualPaymentHandler_GraphQL.UpdatePaymentReceipts(InvPay.Id,InvPay.paymentID__c);
    	test.stopTest();
    }
}