@isTest
public class LSQ_GuestUser_RestResourceTest {

    @isTest
    static void testDoPost() {
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
		List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            Lead lead = new Lead(
                LastName = 'Test Lead ' + i,
                GuestUserUpdated__c = true,
                city = 'Mumbai',
                Channel__c = 'Online',
                Source__c = 'Direct'
            );
            testLeads.add(lead);
        }
        insert testLeads;
   
        Test.startTest();
        List<Lead> leads = LSQ_GuestUser_RestResource.doPost();
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        Test.stopTest();
    }
    
    @isTest
    static void testDoPostNoLeads() {
        List<Lead> leads = LSQ_GuestUser_RestResource.doPost();      
    }
    
     /*@isTest
    static void testDoPost1() {
        
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        try{
		List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            System.debug('try');
            Lead lead = new Lead(
                LastName = 'Test Lead ' + i,
                GuestUserUpdated__c = false,
                city = 'Mumbai'
            );
            testLeads.add(lead);
        }
        //insert testLeads;
        }
        catch(Exception e){
              system.debug('Exception in test class: ' + e.getMessage());
        }
   
        Test.startTest();
        List<Lead> leads = LSQ_GuestUser_RestResource.doPost();
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        Test.stopTest();
    }*/
    
}