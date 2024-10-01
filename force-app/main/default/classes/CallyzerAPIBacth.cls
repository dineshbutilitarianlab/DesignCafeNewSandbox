public class CallyzerAPIBacth implements Database.Batchable<CallyzerResponse.Data>, Database.AllowsCallouts, Database.Stateful, Schedulable{
    String Mobile;
    private List<User> users; // Hold queried users
    private List<CallyzerResponse.Data> calloutResponses; // Hold callout responses
    private Integer responseBatchSize = 200; // Batch size for processing callout responses
    CallyzerAPIDetails__c cs = CallyzerAPIDetails__c.getInstance('CallyzerDetails');
    private List<String> errors = new List<String>(); // Instance variable to hold errors
    
    public Iterable<CallyzerResponse.Data> start(Database.BatchableContext BC){
        String query = 'SELECT LastName, FirstName, Id, Username, Name, MobilePhone, Profile.name, IsActive FROM User WHERE Profile.name IN (\'Sales Team Lead\', \'FOFO\', \'Sales Executive\') AND IsActive = true';
        users = Database.query(query);
        Mobile = getMobileNos(users);
        calloutResponses = calloutCallyzer(Mobile);
        system.debug('users=>'+users);
        system.debug('Mobile=>'+Mobile);
        system.debug('calloutResponses=>'+calloutResponses);
        return calloutResponses ;
    }
    public void execute(Database.BatchableContext BC, List<CallyzerResponse.Data> usersRecords){
        for(CallyzerResponse.Data u : usersRecords){
            
        }
        
        system.debug('usersRecords'+usersRecords);
        createActivity(usersRecords);
        
    }
    public void finish(Database.BatchableContext BC){
        //CallyzerAPIDetails__c cs = CallyzerAPIDetails__c.getInstance('CallyzerDetails');
        if(system.today() != cs.Execution_Date__c && cs.Normal_Flow__c){
            cs.Execution_Date__c = system.today();
            cs.No_Of_Execution__c = 2;
            update cs;
        }
        else{
            cs.No_Of_Execution__c =  cs.No_Of_Execution__c + 1;
            update cs;
        }
        
        if (!this.errors.isEmpty()) {
            System.debug('Errors in finish method: ' + this.errors);
        }
    }
    public void execute(SchedulableContext sc){
        //   CallyzerAPIBacth bc = new CallyzerAPIBacth
        Database.executeBatch(new CallyzerAPIBacth(),responseBatchSize);
        
    }
    String getMobileNos(List<User> usersRecords){
        Integer currentPosition = 0;
        String Mobile = '';
        for(User currentUser : usersRecords){
            currentPosition++;
            if(currentUser.MobilePhone != null){
                Mobile = Mobile + currentUser.MobilePhone;
                if(usersRecords.size() > currentPosition)
                    Mobile = Mobile + ',';
            }
        }
        return Mobile;
    }
    String calculateTime(String startOrEnd){
        //CallyzerAPIDetails__c cs = CallyzerAPIDetails__c.getInstance('CallyzerDetails');
        string calculatedTime;
        Integer addMin;
        if(cs != null) {
            if(system.today() != cs.Execution_Date__c){
                addMin = (Integer)cs.Duration__c;              
            }
            else{
                addMin = (Integer)cs.No_Of_Execution__c * (Integer)cs.Duration__c;
            }
            DateTime newDateTime = cs.Start_Time__c.addMinutes((Integer)cs.Duration__c);
            if(startOrEnd == 'End')
                newDateTime = newDateTime.addMinutes((Integer)cs.Duration__c);
            Time newTime = newDateTime.time();
            calculatedTime = newTime.hour()+':'+newTime.minute();
            System.debug('Custom Setting Value: ' + cs.Callyzer_Url__c);
            
            
        }
        DateTime callyzerTime;
        return calculatedTime;
    }
    String getJsonBody(){
        CallyzerWrapper callWrap = new CallyzerWrapper();
        if(cs.Normal_Flow__c){
            callWrap.callStartDate = system.today();
            callWrap.callEndDate = system.today();
            callWrap.callStartTime = calculateTime('Start');
            callWrap.callEndTime = calculateTime('End'); 
            callWrap.employeeNumbers = Mobile;
        }else{
            callWrap.callStartDate = cs.Start_Time__c.date();
            callWrap.callEndDate = cs.End_Time__c.date();
            // callWrap.callStartTime = cs.Start_Time__c.hour() + ':' + String.format('{0,number,00}', cs.Start_Time__c.minute());
            callWrap.callStartTime = cs.Start_Time__c.hour() + ':' + (cs.Start_Time__c.minute() == 0 ? '00' : String.valueOf(cs.Start_Time__c.minute()).leftPad(2, '0'));
            callWrap.callEndTime = cs.End_Time__c.hour() + ':' + (cs.End_Time__c.minute() == 0 ? '00' : String.valueOf(cs.End_Time__c.minute()).leftPad(2, '0'));
            
            // callWrap.callEndTime = cs.End_Time__c.hour()+':'+cs.End_Time__c.minute() == 0 ? 00 : cs.End_Time__c.minute();
            callWrap.employeeNumbers = Mobile;
            if(cs.Mobile__c != null || cs.Mobile__c != '')
                callWrap.employeeNumbers = cs.Mobile__c;
            
            
        }
        callWrap.durationCondition = 'between';
        callWrap.pageSize = cs.Page_Size__c;
        callWrap.callTypes = 'Incoming,Outgoing'; 
        string jsonbody = JSON.serialize(callWrap);
        return jsonbody;
    }
    
    
    Public class CallyzerWrapper{
        Date callStartDate;
        Date callEndDate;
        String callStartTime;
        String callEndTime;
        String durationCondition;
        String fromDuration;
        String toDuration;
        String employeeNumbers;
        String callTypes;
        String tags;
        String excludeNumbers;
        Integer recordFrom;
        String pageSize;
    }
    
    public List<CallyzerResponse.Data> calloutCallyzer(String Mobiles){
        //CallyzerAPIDetails__c cs = CallyzerAPIDetails__c.getInstance('CallyzerDetails');
        CallyzerResponse callyzerResponses = new CallyzerResponse();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Try{
            request.setHeader('Authorization', 'Bearer ' + cs.Access_Token__c);
            request.setHeader('Content-type', 'application/json');
            request.setEndPoint(cs.Callyzer_Url__c);
            request.setBody(getJsonBody());
            //request.setBody('{ "callStartDate": "2023-12-28", "callEndDate": "2023-12-28", "callStartTime": "17:37", "callEndTime": "19:07", "durationCondition": "between", "fromDuration": "", "toDuration": "", "employeeNumbers": "8123632919", "callTypes": "Incoming,Outgoing", "tags": "", "excludeNumbers": "", "recordFrom": "", "pageSize": "" }');
            system.debug('json body'+getJsonBody()); 
            request.setMethod('POST');
            response = http.send(request);
            // Deserialize JSON response into CallyzerResponse list
            system.debug('response111==>'+response.getBody());
            if (response.getStatusCode() == 200) { // Assuming 200 for success
                String jsonResponse =response.getBody();
                jsonResponse = jsonResponse.replace('date','callDate');
                jsonResponse = jsonResponse.replace('time','callTime');
                system.debug('response==>'+jsonResponse);
                callyzerResponses = (CallyzerResponse)JSON.deserialize(jsonResponse, CallyzerResponse.class);
                System.debug('callyzerResponses=>'+callyzerResponses);
            }
            else{
                system.debug('response==>'+response.getBody());
                throw new CalloutException('Callyzer API Call failed with status code: ' + response.getStatusCode() + ' and response: ' + response.getBody());
            }
        }
        Catch(Exception e){
            system.debug('Exception during api call'+e.getMessage());
            system.debug('Exception during api line'+e.getStackTraceString());
            throw new calloutException('Exception during api call : '+ e.getMessage());
        }
        return callyzerResponses.Data;
    }
    public void createActivity(List<CallyzerResponse.Data> callyzerRecords){
        Map<String, String> leadMobileMap = new Map<String, String>();
        Map<String, String> leadPhoneMap = new Map<String, String>();
        Map<String, String> oppMobileMap = new Map<String, String>();
        Map<String, String> oppPhoneMap = new Map<String, String>();
        
        Set<String> MobileNos =  new Set<String>();
        String mobilenoss='';
        for(CallyzerResponse.Data cr : callyzerRecords){
            mobilenoss += '\'' + cr.clientNumber + '\',';
            MobileNos.add(cr.clientNumber);
            
        }
        system.debug(mobilenoss);
        List<Lead> leadAndMobile = [SELECT Id, IsConverted, MobilePhone, Phone FROM lead WHERE (MobilePhone IN :MobileNos OR Phone IN:MobileNos) AND IsConverted = false];
        List<Opportunity> oppList = [SELECT Id, Mobile__c, Phone__c FROM Opportunity WHERE (Mobile__c IN: MobileNos OR Phone__c IN:MobileNos)];
        system.debug('leadAndMobile=> '+leadAndMobile);
        system.debug('oppList=> '+oppList);
        if(leadAndMobile.size() > 0){
            for(Lead leadRec :leadAndMobile){
                if(leadRec.MobilePhone != null){
                	leadMobileMap.put(leadRec.MobilePhone, leadRec.Id);    
                }
                if(leadRec.Phone != null){
                	leadMobileMap.put(leadRec.Phone	, leadRec.Id);    
                }
            }
        }if(oppList.size() > 0){
            for(Opportunity opp :oppList){
                if(opp.Mobile__c != null){
                	oppMobileMap.put(opp.Mobile__c, opp.Id);    
                }
                if(opp.Phone__c != null){
                	oppMobileMap.put(opp.Phone__c, opp.Id);    
                }
            }    
        }
        
        if(leadMobileMap.size() > 0){
            insertTask(leadMobileMap, callyzerRecords);   
            system.debug('leadMobileMap size ==> ' + leadMobileMap.size());
        }
        
        if(oppMobileMap.size() > 0){
            insertTask(oppMobileMap, callyzerRecords);   
            system.debug('oppMobileMap size ==>' + oppMobileMap.size());
        }
    }
    
    public static void insertTask(Map<String, String> leadMobileMap, List<CallyzerResponse.Data> callyzerRecords){
        System.debug('leadMobileMap in insert task ==> ' + leadMobileMap);
        System.debug('callyzerRecords==> ' + callyzerRecords);
        
        List<Task> insertTasks = new  List<Task>();
        List<String> errors = new List<String>(); // Hold error messages
        for(CallyzerResponse.Data cr : callyzerRecords){
            if (leadMobileMap.containsKey(cr.clientNumber)) {
                Task tsk = new Task(); 
                tsk.Subject__c = 'callyzer calls';
                tsk.Subject = 'callyzer calls';
                tsk.Called_Number__c = cr.clientNumber;
                tsk.Caller_number__c = cr.employeeNumber;
                tsk.Description = 'Employe Code : '+cr.employeeCode;
                tsk.CallyzerUniqueId__c = leadMobileMap.get(cr.clientNumber) +' : '+cr.uniqueId;
                Id recId = leadMobileMap.get(cr.clientNumber);
                if(recId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Opportunity'))
                    tsk.WhatId = leadMobileMap.get(cr.clientNumber);
                else if(recId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Lead'))
                    tsk.WhoId = leadMobileMap.get(cr.clientNumber);
                tsk.Type = cr.callType;
                tsk.Call_duration__c = cr.duration;
                tsk.CallDurationInSeconds = cr.durationInSeconds;
                tsk.Call_recording_URL__c = cr.callRecordingPath;
                tsk.Call_Date__c = parseDate(cr.callDate);
                tsk.Call_time__c = cr.callTime;
                insertTasks.add(tsk);   

            }
            else {
                errors.add('Number not exist in  SF : ' + cr.clientNumber);
            }
        }
        system.debug('current insertTasks==>'+insertTasks);
        if(insertTasks.size() > 0 || !insertTasks.isEmpty()){
            
            try{
                
                //INSERT insertTasks;
                upsert insertTasks Task.CallyzerUniqueId__c; 
                
                //database.upsert(insertTasks, Schema.getGlobalDescribe().get('Task').getDescribe().fields.getMap().get('callyzeruniqueid__c'), false);
                System.debug('insertTasks == > ' + insertTasks);
            }
            catch (DMLException e) {
                 for(Task tsk : insertTasks){
                     if(tsk.WhoId != null && tsk.WhatId != null)
           				 system.debug('error tskk=>'+tsk);
            	}
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    errors.add('DML Error: ' + e.getDmlMessage(i));
                    System.debug('DML Error: ' + e.getDmlMessage(i));
                    System.debug('DML Error: id ' + e.getDmlId(i));
                    System.debug('DML Error type: ' + e.getDmlType(i));
                    System.debug('DML Error getDmlField: ' + e.getDmlFields(i));
                    System.debug('DML Error getDmlFieldNames: ' + e.getDmlFieldNames(i));
                     System.debug('DML Error getDmlIndex: ' + insertTasks[e.getDmlIndex(i)]);
                    
                }
            }
        }
        if (!errors.isEmpty()) {
            // Add the errors to the instance variable for later retrieval
            errors.addAll(errors); // Assuming "this" refers to the current batch class instance
            // Process or log errors for failed task creation
            // For instance: Log errors in a custom object or debug log
            System.debug('Errors encountered in task creation: ' + errors);
            // You might also add further error handling or logging mechanisms here
        }
    }
    
    private class ResponseIterable implements Iterable<CallyzerResponse> {
        private List<CallyzerResponse> responses;
        
        public ResponseIterable(List<CallyzerResponse> responses) {
            this.responses = responses;
        }
        
        public Iterator<CallyzerResponse> iterator() {
            return new ResponseIterator(responses);
        }
    }
    
    private class ResponseIterator implements Iterator<CallyzerResponse> {
        private Integer currentIndex = 0;
        private List<CallyzerResponse> responseList;
        
        public ResponseIterator(List<CallyzerResponse> responseList) {
            this.responseList = responseList;
        }
        
        public boolean hasNext() {
            return currentIndex < responseList.size();
        }
        
        public CallyzerResponse next() { 
            if (!hasNext()) {
                throw new NoSuchElementException();
            }
            return responseList.get(currentIndex++);
        }
    }
    public static Date parseDate(String dateString) {
        // Split the date string into components
        String[] dateParts = dateString.split(' ');
        Integer day = Integer.valueOf(dateParts[0]);
        Integer month;
        Integer year = Integer.valueOf(dateParts[2]);
        
        // Map of month abbreviations to their numeric values
        Map<String, Integer> months = new Map<String, Integer>{
            'Jan' => 1, 'Feb' => 2, 'Mar' => 3,
                'Apr' => 4, 'May' => 5, 'Jun' => 6,
                'Jul' => 7, 'Aug' => 8, 'Sep' => 9,
                'Oct' => 10, 'Nov' => 11, 'Dec' => 12
                };
                    
                    // Get the numeric value of the month
                    month = months.get(dateParts[1]);
        
        // Create the Date object
        return Date.newInstance(year, month, day);
    }
}