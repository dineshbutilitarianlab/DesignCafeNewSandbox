public class ApiCallLogger {
    
    public static void method(String ID, String apiUrl, String reqBody, String respBody, String direction) {
        
        List<Api_Call_logger__c> callApiList = new List<Api_Call_logger__c>();
        
       if ((System.Label.API_logger_enabled == 'TRUE') && (direction == 'in')) {
            Api_Call_logger__c cp = new Api_Call_logger__c();
            cp.RecordId__c = ID;
            cp.URL__c = apiUrl;
            cp.Request_Body__c = reqBody;
            cp.Response_Message__c = respBody;
            cp.Direction__c = direction;	
            callApiList.add(cp);   
            insert callApiList;
        }
        /*
        if (System.Label.API_logger_enabled == 'TRUE') {
            system.debug('KKKUUUNNNAAALLL');
            List<APILogger__e> process2 = new List<APILogger__e>();
            APILogger__e process;
            process = new APILogger__e();
            process.LeadID__c = 'Lead334455';
            process2.add(process);
            EventBus.publish(process);
        } */
    }
}