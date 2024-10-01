public class CallyzerCallHistoryCalloutFuture {
    
    @future(callout=true) 
    public static void calloutCallyzerCallHistoryAPI(){
        try{
            CallyzerCallHistoryDetails__c api = CallyzerCallHistoryDetails__c.getInstance('CallyzerCallHistoryDetails');
            List<User> listOfSalesExecutiveProfileUser = [SELECT Id, Name, MobilePhone FROM User WHERE Profile.Name IN:api.User_Profiles__c.split(',') AND IsActive = true AND MobilePhone != null AND MobilePhone IN: api.Registerd_Mobile__c.split(',')];
            List<String> mobilePhoneListOfSalesExecutiveUsers = new List<String>();
            for (User ur : listOfSalesExecutiveProfileUser) {
                mobilePhoneListOfSalesExecutiveUsers.add(ur.MobilePhone);
            }
            String mobilePhone =  '"' + String.join(mobilePhoneListOfSalesExecutiveUsers, ', ') + '"';
            System.debug('mobilePhone ==> ' + mobilePhone);
            
            HttpRequest request = new HttpRequest(); 
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + api.Access_Token__c);
            request.setHeader('Content-type', 'application/json');
            request.setEndpoint(api.Callyzer_CallHistory_Url__c);
            //request.setBody('{ "callStartDate": "2023-12-28", "callEndDate": "2023-12-28", "callStartTime": "17:37", "callEndTime": "19:07", "durationCondition": "between", "fromDuration": "", "toDuration": "", "employeeNumbers": "8123632919", "callTypes": "Incoming,Outgoing", "tags": "", "excludeNumbers": "", "recordFrom": "", "pageSize": "" }');
            request.setBody(getRequestBody(mobilePhone));
            response = http.send(request);   
            System.debug('Response code ==> ' + response.getStatusCode());
            String jsonResponse = response.getBody();
            System.debug('Response body ==> ' + jsonResponse);
            Map<String, Object> parsedJson = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            Integer recordsTotal = (Integer)parsedJson.get('recordsTotal');
            System.debug('recordsTotal ==> ' + recordsTotal);
            if (recordsTotal > 0 && response.getStatusCode() == 200) {
                jsonResponse = jsonResponse.replace('"date":', '"callDate":').replace('"time":', '"callTime":');
                CallyzerJsonResponse parsedResponse = (CallyzerJsonResponse) JSON.deserialize(jsonResponse, CallyzerJsonResponse.class);
                if(parsedResponse != null){
                    insertTask(parsedResponse);    
                }    
            }
        }catch(Exception e){
            System.debug('Error ==> ' + e.getMessage());
        }
    }
    
    public static Date convertStringToDate(String dateString){
        Map<String, Integer> monthMap = new Map<String, Integer>{
            'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4,
            'May' => 5, 'Jun' => 6, 'Jul' => 7, 'Aug' => 8,
            'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12
        };
        List<String> dateParts = dateString.split(' ');
        Integer day = Integer.valueOf(dateParts[0]);
        Integer month = monthMap.get(dateParts[1]);
        Integer year = Integer.valueOf(dateParts[2]);
        Date convertedDate = Date.newInstance(year, month, day);
        System.debug('convertedDate ==> ' + convertedDate); 
        return convertedDate;
    }
    
    public static String getRequestBody(String mobilePhone){
        String requestBody = '{"callStartDate" : "' + DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).format('yyyy-MM-dd') + '"';
        requestBody += ', "callEndDate" : "' + DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).format('yyyy-MM-dd') + '"';
        requestBody += ', "callStartTime" : "' + Datetime.now().addSeconds(UserInfo.getTimezone().getOffset(Datetime.now())/1000).format('HH:mm', 'GMT') + '"';
        requestBody += ', "callEndTime" : "' + Datetime.now().addSeconds(UserInfo.getTimezone().getOffset(Datetime.now())/1000).addMinutes(30).format('HH:mm', 'GMT') + '"';
        requestBody += ', "durationCondition" : ' + '"between"';
        requestBody += ', "fromDuration" : ' + '""';
        requestBody += ', "toDuration" : ' + '""';
        requestBody += ', "employeeNumbers" : ' + mobilePhone;
        requestBody += ', "callTypes" : ' + '"Incoming,Outgoing"';
        requestBody += ', "tags" : ' + '""';
        requestBody += ', "excludeNumbers" : ' + '""';
        requestBody += ', "recordFrom" : ' + '""';
        requestBody += ', "pageSize" : ' + '""';
        requestBody += '}';
        System.debug('requestBody ==> ' + requestBody);  
        
        return requestBody;
    }
    
    public static void insertTask(CallyzerJsonResponse parsedResponse){
        List<Task> listOfTask = new List<Task>();
        List<String> leadMobileNumber = new List<String>();
        if(parsedResponse != null){
        	Map<String, String> leadMobileNumberAndId = new Map<String, String>();
            for(CallyzerJsonResponse.Data item : parsedResponse.data) {
                leadMobileNumber.add(item.clientNumber);    
            }
            if(leadMobileNumber.size() > 0){
                for(Lead ld: [SELECT Id, MobilePhone FROM Lead WHERE MobilePhone IN:leadMobileNumber]){
                    leadMobileNumberAndId.put(ld.MobilePhone, ld.Id);    
                }    
            }
            if(leadMobileNumberAndId.size() > 0){
                for(CallyzerJsonResponse.Data item : parsedResponse.data) {
                    System.debug('item ' + item);
                    System.debug('Employee Name: ' + item.employeeName);
                    Task tsk = new Task();
                    tsk.Subject__c = item.employeeName+' Call '+ item.clientName;
                    tsk.Subject = item.employeeName+' Call '+ item.clientName;
                    tsk.Called_Number__c = item.clientNumber;
                    tsk.Caller_number__c = item.employeeNumber;
                    tsk.Description = 'Employe Code : ' + item.employeeCode;
                    tsk.CallyzerUniqueId__c = item.uniqueId;
                    tsk.WhoId = leadMobileNumberAndId.get(item.clientNumber);
                    tsk.CallType = item.callType;
                    tsk.Call_duration__c = item.duration;
                    tsk.CallDurationInSeconds = item.durationInSeconds;
                    tsk.Call_recording_URL__c = item.callRecordingPath;
                    tsk.Call_Date__c = convertStringToDate(item.callDate);
                    tsk.Call_time__c = item.callTime;
                    listOfTask.add(tsk);                
                }
                if(listOfTask.size() > 0){
                    INSERT listOfTask;
                    System.debug('listOfTask ==> ' + listOfTask);
                }     
            }
        }
    }
}