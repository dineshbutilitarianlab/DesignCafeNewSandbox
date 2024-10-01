@isTest
public class WebEngageLeadAPIInvokeTest {
    
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
        //insert Lead
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.FirstName = 'Test';
        
        Lea.Status = 'New';
        Lea.Design_User__c = du.Id;
        Lea.MobilePhone='1234567899';
        
        Lea.City = 'Mumbai';
        insert Lea;
        
         Lea.Is_Lead_Update__c = true;
        update Lea;
        WebEngageLeadAPIInvoke.getLeadStage(New String[]{Lea.Id});
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        
        Test.stopTest();
        
        //l = [Select OwnerID From Lead where ID = :l.id];
        //system.assertEquals(WHATYOUEXPECT, l.OwnerID);
        
    }
    
}