@isTest
      public class TestAutoConvertLeads1 {
      static testMethod void createnewlead () {
      //User userToCreate = [Select id from user where profile.Name ='System Administrator' AND IsActive = TRUE Limit 1];

      Test.startTest();
             List<Lead> l = new List<Lead>();       
        Lead ld = new Lead();
        List<Id> Ids = New List<Id>();
       // ld.ownerid = userToCreate.id;
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
        ld.Willingness_For_Meeting__c = date.today()-1;
        ld.Client_s_Budget__c = 500000;
        ld.Email = 'test@gmail.com';
        ld.Status = 'Meeting Confirmed';
        ld.DC_Lead_Status__c = 'Meeting Done';
        insert ld; 
        l.add(ld);

      List< AutoConvertLeads1.Requests>  requests = new List<  AutoConvertLeads1.Requests >();
      AutoConvertLeads1.Requests request = new AutoConvertLeads1.Requests ();
      request.LeadId = ld.id;
      requests.add (request);

      AutoConvertLeads1.LeadAssign (requests);

      Test.stopTest ();
   }
}