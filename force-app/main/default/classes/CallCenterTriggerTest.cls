@Istest
public class CallCenterTriggerTest {
	@isTest
    public static void cccallout(){
        CallCenterAPI ccl = new CallCenterAPI();
    }
}


/*
 @isTest
public class CallCenterTriggerTest {
    @isTest
    public static void CallCentreTrigger(){
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Online';
        ld.LastName = 'test';
        ld.City = 'Mumbai';
        l.add(ld);
        insert l;
    }
    @isTest
    public static void CallCenterTrigger1(){
        CallCentreTrigger();
        Lead l = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        CallCenterAPI.basicAuthCallout(l.id);
        
    }
}   */