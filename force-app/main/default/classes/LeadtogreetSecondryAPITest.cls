@isTest
private class LeadtogreetSecondryAPITest {
    @isTest
    static void testLeadtogreetSecondryAPI() {
       
        String testBody = '{"key": "value"}';
        
        Test.startTest();
        LeadtogreetSecondryAPI queueableInstance = new LeadtogreetSecondryAPI(testBody);
        System.enqueueJob(queueableInstance);
        Test.stopTest();
        
    }
}