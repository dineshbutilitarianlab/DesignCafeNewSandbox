@isTest
public class AuthorizationTokenMock_Test {
   @isTest static void testCallout() {
        // Set mock callout class
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());  
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
       // PageReference pageRef = new WebserviceCall().getaccesstoken();
       AuthenticationToken_GraphQL.authorization();
       Test.stopTest();
      
    }
}