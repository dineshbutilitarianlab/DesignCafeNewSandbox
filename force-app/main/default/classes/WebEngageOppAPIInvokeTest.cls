@isTest
public class WebEngageOppAPIInvokeTest {
     private static testMethod void doTest() {
        
        Test.startTest();
        
        //insert DU user
            TriggerControl__c setting = new TriggerControl__c();
        setting.Name ='LeadTrigger';
        setting.Run__c = true;
        insert setting;
         
        DCWebengage__c dcWeb = new DCWebengage__c();
        dcWeb.Name = 'Dcwebengage';
        dcWeb.url__c ='https://api.webengage.com/v1/accounts/76aa813/users';        
        insert dcWeb;
      
        
        Design_User__c du = new Design_User__c();
        du.name = 'test du user';
        du.Designer_Dashboard_ID__c = 'test du';
        du.Email__c = 'test@test.com';
        du.Role__c = 'Design Partner';
        insert du;
         //insert lead
         //insert Lead
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.FirstName = 'Test';        
        Lea.Status = 'New';
        Lea.Design_User__c = du.Id;
        Lea.MobilePhone='1234567899';        
        Lea.City = 'Mumbai';
        insert Lea;
         
         
       //insert account
      Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
         acc.Converted_Lead_ID__c	= Lea.id;
            insert acc;
         
         
         
         
         
         
         
         //insert Lead
        Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Discussion';
         opp.Lead_Id__c = Lea.Id;
         opp.Client_s_Budget__c = 0;
         //opp.Reason__c ='Low Budget';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
        
         opp.Is_Opportunity_Update__c = true;
        update opp;
        WebEngageOppAPIInvoke.getOppStage(New String[]{opp.Id});
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        
        Test.stopTest();
        
        //l = [Select OwnerID From Lead where ID = :l.id];
        //system.assertEquals(WHATYOUEXPECT, l.OwnerID);
        
    }

}