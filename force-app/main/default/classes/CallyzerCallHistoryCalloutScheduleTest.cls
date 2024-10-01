@isTest
private class CallyzerCallHistoryCalloutScheduleTest {
    
    @TestSetup
    Static void SetUpMethod(){
        TriggerControl__c tc = New TriggerControl__c();
        tc.name = 'LeadTrigger';
        tc.Run__c = false;
        INSERT tc;
        
        CallyzerCallHistoryDetails__c cchd = new CallyzerCallHistoryDetails__c();
        cchd.Name = 'CallyzerCallHistoryDetails';
        cchd.Access_Token__c = '543be4d7-c10d-40a9-b541-34197acf9ba5';
        cchd.Callyzer_CallHistory_Url__c = 'https://api1.callyzer.co/admin/api/call/callHistory';
        cchd.Registerd_Mobile__c = '8123632919,9731450210,9739058980';
        cchd.User_Profiles__c = 'Sales Executive, Sales Team Lead, FOFO';
        INSERT cchd;
    }
    
    static testMethod void testScheduleExecution() {
        Test.startTest();
		
        Test.setMock(HttpCalloutMock.class, new CallyzerCallHistoryMockResponseGenerator());
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.City = 'Mumbai';
        Lea.MobilePhone = '8056097090';
        Lea.Channel__c = 'Online';
        Lea.Source__c = 'Paid';
        insert Lea;
        
        String cronExp = '0 0 * * * ?';
        CallyzerCallHistoryCalloutSchedule sched = new CallyzerCallHistoryCalloutSchedule();
        System.schedule('TestCallyzerCallHistoryCallout', cronExp, sched);
        sched.execute(null);
        Test.stopTest();
    }
}