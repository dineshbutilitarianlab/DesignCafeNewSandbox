@isTest
public class LSQAPIThroughDifferentUserTest {

    @isTest
    static void testCallout() {
        
        // Set the mock callout
    //  Test.setMock(HttpCalloutMock.class, new LSQMockCallout());

        List<String> leadIdList = new List<String>();
        Lead leadRecord = createLead('test');
        leadIdList.add(leadRecord.Id);
        
        Test.startTest();
        System.debug('leadIdList '+leadIdList);
        LSQAPIThroughDifferentUser.Callout(leadIdList);
        Test.stopTest();
        
        
        List<Lead> updatedLeads = [SELECT Id, GuestUserUpdated__c FROM Lead WHERE Id IN :leadIdList];
        for (Lead lead : updatedLeads) {
            System.assertEquals(true, lead.GuestUserUpdated__c);
        }
        RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/guestUserRecordBulkAPI';
            req.httpMethod = 'POST';
    
            RestContext.request = req;
            RestContext.response = res;
        
            List<Lead> leads = LSQ_GuestUser_RestResource.doPost();
            
            System.assertEquals(1, leads.size(), 'The number of leads with GuestUserUpdated__c = true should be 1');
            for (Lead lead : leads) {
                System.assertEquals(true, lead.GuestUserUpdated__c, 'The GuestUserUpdated__c field should be true');
            }
    }
   	@isTest
    static void testDoPostException() {
   		List<Lead> leads = LSQ_GuestUser_RestResource.doPost(); 
        RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/guestUserRecordBulkAPI';
            req.httpMethod = 'PUT';
    
            RestContext.request = req;
            RestContext.response = res;
    }

    
    private static Lead createLead(String name) {
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = false;
        insert cuset1;
        
        User guestUser = [SELECT Id, Name,ProfileId FROM User WHERE IsActive = true And Name LIKE '%Site Guest User%' Limit 1];
        System.debug('guestUser Id: ' + guestUser.Id);
        System.debug('guestUser Id: ' + guestUser.Name);
        System.debug('guestUser ProfileId: ' + guestUser.ProfileId);
        
        Profile systemAdminProfile = [SELECT Id, Name FROM Profile where Name = 'System Administrator'];
        User systemAdminUser = [SELECT Id, Name,ProfileId FROM User WHERE ProfileId =: systemAdminProfile.Id Limit 1];
        
        System.runAs(guestUser){
            Lead leadRecord = new Lead(
            FirstName = name,
            Lastname = 'test',
            Email = 'test@example.com',
            MobilePhone = '9876543291',
            Source__c = 'Organic',
            Region__c = 'Hyderabad',
            Channel__c = 'Online',
            City = 'Hyderabad',
            DC_Lead_Source__c = 'Google Search Organic',
           // LastModifiedDate = DateTime.now(),
            Follow_Up_Date_Time__c = DateTime.now(),
            DC_Campaign_Source__c = 'Organic Search',
            //CreatedById = guestUser.Id,
           // LastModifiedById = guestUser.Id,
            DC_Lead_Status__c = 'Organic Search',
            Status = 'New',
            Call_Stage__c = 'Undialed',
           // CreatedDate = Date.valueOf(System.now()),
            Property_Possession_Date__c = Date.today()
            
        	);
            insert leadRecord;   
            return leadRecord;
        }
        return null;
    } 
    @isTest
    public static void dopost_Cover1(){
      
       	RestRequest request = new RestRequest();
        request.requestUri ='https://dc--int.sandbox.my.salesforce-sites.com/guestUserRecordBulkAPI/services/apexrest/guestUserRecordBulkAPI';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        LSQ_GuestUser_RestResource.doPost(); 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        
    }
}