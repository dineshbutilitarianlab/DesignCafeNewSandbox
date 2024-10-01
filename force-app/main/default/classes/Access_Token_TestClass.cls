@isTest
public class Access_Token_TestClass {
    
    @isTest static void testCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new AccessTokenMock());  
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
       // PageReference pageRef = new WebserviceCall().getaccesstoken();
    }
}