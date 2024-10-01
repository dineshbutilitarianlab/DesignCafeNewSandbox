@isTest 
public class ApiCallLogger_Test {
    
    @isTest 
    public static void apiTestMethods(){
        
        Api_Call_logger__c cp = new Api_Call_logger__c();
        cp.RecordId__c = 'WE345678XIo';
        cp.URL__c = 'www.google.com';
        cp.Request_Body__c = '{"name": "Foo","description": "An optional description", "price": 45.2,"tax": 3.5}';
        cp.Response_Message__c = 'Created Sucessfully';
        cp.Direction__c = 'In';	
       	insert cp;
        
        test.startTest();
        ApiCallLogger.method(cp.RecordId__c , cp.URL__c, cp.Request_Body__c, cp.Response_Message__c  , cp.Direction__c); 
        test.stopTest();
    }
    
    
}