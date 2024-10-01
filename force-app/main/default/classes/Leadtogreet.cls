public class Leadtogreet {
    public class leadDataWrap{
        @AuraEnabled
        public String PHONE{get;set;}
        @AuraEnabled
        public String NAME{get;set;}
        @AuraEnabled
        public String MAIL_ID{get;set;}
        @AuraEnabled
        public String SOURCE{get;set;}
        @AuraEnabled
        public String REGION{get;set;}
        @AuraEnabled
        public String CHANNEL{get;set;}
        @AuraEnabled
        public String LAST_MODIFIED_BY {get;set;}
        @AuraEnabled
        public String LEAD_SOURCE{get;set;}
        @AuraEnabled
        public String CAMPAIGN_SOURCE{get;set;}
        @AuraEnabled
        public datetime CREATE_DATE{get;set;}
        @AuraEnabled
        public String PROJECT_NAME{get;set;}
        @AuraEnabled
        public datetime LEAD_ID{get;set;}
        @AuraEnabled
        public String LEAD_STAGE{get;set;}
        @AuraEnabled
        public String LEAD_STATUS{get;set;}
        @AuraEnabled
        public String CALL_STAGE {get;set;}
        @AuraEnabled
        public date PP_DATE{get;set;}
        @AuraEnabled
        public String SF_LEAD_ID{get;set;}
        @AuraEnabled
        public String DSA_Name{get;set;}
        @AuraEnabled
        public datetime Followup_Date{get;set;}
        @AuraEnabled
        public String Agent_Name{get;set;}
        @AuraEnabled
        public Boolean LARR{get;set;}
        @AuraEnabled
        public Boolean IS_UPDATED{get;set;}
        
    }
    public class responsedata{
        public string code;
        public string message;
        public string status;
    }
    
    @future(callout=true)
    @AuraEnabled
    public static void Callout(List<String> leadIdSet){
        try{
            system.debug('LeadTOGReet == 2'+leadIdSet);
            Map<Id, String> responseMap = new Map<Id, String>();
            Map<Id, String> requestBodyMap = new Map<Id, String>();
            /** 
* To send any region leads directly to Sales Managers in Experience Centers without sending them 
to Call center, include those region names in the SOQL below.

* Logic For sending leads to greet :-
Any FOFO lead:
Leads will NEVER go to greet.
All other centers (FOCO and COCO):
Sunday, Monday: All leads will go to greet.
Other days: Only Offline leads will go to greet.
Make these restrictions using the Query itself.
*/              
            Boolean hitApi = true; 
            Id own = [select Id From user where Name = 'Dinesh Baddawar' limit 1].Id;
            String ownerId = own != null ? own : UserInfo.getUserId();
            List<Lead> ld = [SELECT Id, Name, Email, MobilePhone, APIMOBILE__c, Source__c,
                             Project_Name__c, Region__c, Channel__c, Model_of_Business__c, City, DC_Lead_Source__c,
                             LastModifiedDate, Follow_Up_Date_Time__c, LastModifiedBy__c, 
                             DC_Campaign_Source__c, DSA__c, DSAname__c, Lead_Owner_Name__c, 
                             CreatedBy.id, DC_Lead_Status__c, Status, Call_Stage__c, CreatedDate,
                             Property_Possession_Date__c,LARR__c,OwnerId
                             FROM Lead 
                             WHERE Id IN: leadIdSet
                             AND ( ((OwnerId =: ownerId) OR (Region__c = 'Outstation') OR(Region__c = 'Unknown')) OR (
                                 ((day_in_week(CreatedDate) < 3) OR (Channel__c = 'Affiliate') OR (Channel__c = 'Offline') OR (Channel__c = 'Referral')  OR ((day_in_week(CreatedDate) = 1) AND Region__c = 'Chennai' AND Channel__c != 'Online'))      
                                 AND Model_of_Business__c != 'FOFO' AND Channel__c != ''
                                 AND Status != 'Meeting Scheduled'
                             )
                                 )];
            system.debug('ld Lea == 3 >' + ld);
            
            for(Lead l : ld){  
                if(hitApi == true){
                    system.debug('apihit  === >'+hitApi);
                    leadDataWrap leaddata = new leadDataWrap();
                    if(l.APIMOBILE__c!=null){
                        leaddata.PHONE = l.APIMOBILE__c;
                    }
                    if(l.Name!=null){
                        leaddata.NAME = l.Name ;
                        leaddata.LARR = l.LARR__c;
                    }
                    if(l.Email !=null){
                        leaddata.MAIL_ID = l.Email;
                    }
                    if(l.Source__c !=null){
                        leaddata.SOURCE = l.Source__c;
                    }
                    if(l.Follow_Up_Date_Time__c !=null){
                        leaddata.Followup_Date = l.Follow_Up_Date_Time__c;
                    } 
                    if(l.City !=null){
                        leaddata.REGION = l.City;
                    }
                    if(l.Channel__c !=null){
                        leaddata.CHANNEL = l.Channel__c;
                    }
                    if(l.LastModifiedBy__c !=null){
                        leaddata.LAST_MODIFIED_BY = l.LastModifiedBy__c;
                        system.debug('LastModi:'+ l.LastModifiedBy__c);
                    }
                    if(l.DC_Lead_Source__c !=null){
                        leaddata.LEAD_SOURCE = l.DC_Lead_Source__c;
                    }
                    if(l.DC_Campaign_Source__c !=null){
                        leaddata.CAMPAIGN_SOURCE = l.DC_Campaign_Source__c;
                    }
                    if(l.CreatedDate!=null){
                        leaddata.CREATE_DATE = l.CreatedDate;
                    }
                    if(l.Project_Name__c !=null){
                        leaddata.PROJECT_NAME = l.Project_Name__c;
                    }
                    if(l.LastModifiedDate !=null){
                        leaddata.LEAD_ID = l.LastModifiedDate;
                    }
                    if(l.Status !=null){
                        leaddata.LEAD_STAGE = l.Status;
                    }
                    if(l.DC_Lead_Status__c !=null){
                        leaddata.LEAD_STATUS = l.DC_Lead_Status__c;
                    }
                    if(l.Call_Stage__c !=null){
                        leaddata.CALL_STAGE = l.Call_Stage__c;
                    }
                    if(l.Property_Possession_Date__c !=null){
                        leaddata.PP_DATE = l.Property_Possession_Date__c;
                    }
                    if(l.id !=null){
                        leaddata.SF_LEAD_ID = l.id;
                    }
                    if(l.DSAname__c !=null){
                        leaddata.DSA_Name = l.DSAname__c;
                    }
                    if(l.Lead_Owner_Name__c !=null){
                        leaddata.Agent_Name = l.Lead_Owner_Name__c;
                    }
                    system.debug('Json Serialize == > '+JSON.serialize(leaddata));
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(System.Label.LeadtoGreetAPIURL);
                    request.setTimeout(120000);
                    request.setMethod('POST');
                    request.setHeader('Content-Type', 'application/json');
                    String jsonBody = JSON.serialize(leaddata);
                    system.debug('JSON BODY : '+jsonBody);
                    request.setBody(jsonBody);
                    Http http = new Http();
                    if(!test.isRunningTest()){
                        HttpResponse response = http.send(request);
                        system.debug('response == > ' + response);
                        responseMap.put(l.Id, 'Response : ' + response);    
                        requestBodyMap.put(l.Id, jsonBody);
                        if(response.getStatusCode() != 200 && System.Label.Lead_To_Greet_Trigger_Point == 'Code'){
                            LeadtogreetSecondryAPI callout = new LeadtogreetSecondryAPI(jsonBody);
                            System.enqueueJob(callout);
                        }
                    }
                    //Calling ApiCallLogger class
                    //ApiCallLogger.method(Id, request.getEndpoint(), jsonBody,null , 'out');
                }
            }
            System.debug('responseMap ==> ' + responseMap);
            if(responseMap.size() > 0){
                insertResponse(responseMap, requestBodyMap); 
            }
            
        }
        catch(Exception exc){
            system.debug('Exception in LeadtoGreet: ' + exc.getMessage());
        }
    }
    
    @future(callout=true) 
    public static void CalloutOnUpdate(List<String> leadIdSet){
        Map<Id, String> responseMap = new Map<Id, String>();
        Map<Id, String> requestBodyMap = new Map<Id, String>();
        try{
            System.debug('LeadTOGReet On Update');     
            Id own = [select Id From user where Name = 'Varun C S' limit 1].Id;
            List<Lead> ld = [SELECT Id, Name, Email, MobilePhone, APIMOBILE__c, Source__c,
                             Project_Name__c, Region__c, Channel__c, Model_of_Business__c, City, DC_Lead_Source__c,
                             LastModifiedDate, Follow_Up_Date_Time__c, LastModifiedBy__c, 
                             DC_Campaign_Source__c, DSA__c, DSAname__c, Lead_Owner_Name__c, 
                             CreatedBy.id, DC_Lead_Status__c, Status, Call_Stage__c, CreatedDate,
                             Property_Possession_Date__c,LARR__c,OwnerId, LastModifiedBy.Name
                             FROM Lead 
                             WHERE Id IN: leadIdSet];
            System.debug('ld Lead' + ld);
            for(Lead l : ld){  
                if(!l.LARR__c){
                    Datetime dt = DateTime.newInstance(Date.valueOf(l.createddate), Time.newInstance(0, 0, 0, 0));
                    String dayOfWeek=dt.format('EEEE');
                    System.debug('Day : ' + dayOfWeek);
                    leadDataWrap leaddata = new leadDataWrap();
                    if(l.APIMOBILE__c!=null){
                        leaddata.PHONE = l.APIMOBILE__c;
                    }
                    if(l.Name!=null){
                        leaddata.NAME = l.Name ;
                        leaddata.LARR = l.LARR__c;
                    }
                    if(l.Email !=null){
                        leaddata.MAIL_ID = l.Email;
                    }
                    if(l.Source__c !=null){
                        leaddata.SOURCE = l.Source__c;
                    }
                    if(l.Follow_Up_Date_Time__c !=null){
                        leaddata.Followup_Date = l.Follow_Up_Date_Time__c;
                    }
                    if(l.City !=null){
                        leaddata.REGION = l.City;
                    }
                    if(l.Channel__c !=null){
                        leaddata.CHANNEL = l.Channel__c;
                    }
                    if(l.LastModifiedBy__c !=null){
                        leaddata.LAST_MODIFIED_BY = l.LastModifiedBy__c;
                        system.debug('LastModi:'+ l.LastModifiedBy__c);
                    }
                    if(l.DC_Lead_Source__c !=null){
                        leaddata.LEAD_SOURCE = l.DC_Lead_Source__c;
                    }
                    if(l.DC_Campaign_Source__c !=null){
                        leaddata.CAMPAIGN_SOURCE = l.DC_Campaign_Source__c;
                    }
                    if(l.CreatedDate!=null){
                        leaddata.CREATE_DATE = l.CreatedDate;
                    }
                    if(l.Project_Name__c !=null){
                        leaddata.PROJECT_NAME = l.Project_Name__c;
                    }
                    
                    if(l.LastModifiedDate !=null){
                        leaddata.LEAD_ID = l.LastModifiedDate;
                    }
                    if(l.Status !=null){
                        leaddata.LEAD_STAGE = l.Status;
                    }
                    if(l.DC_Lead_Status__c !=null){
                        leaddata.LEAD_STATUS = l.DC_Lead_Status__c;
                    }
                    if(l.Call_Stage__c !=null){
                        leaddata.CALL_STAGE = l.Call_Stage__c;
                    }
                    
                    if(l.Property_Possession_Date__c !=null){
                        leaddata.PP_DATE = l.Property_Possession_Date__c;
                    }
                    if(l.id !=null){
                        leaddata.SF_LEAD_ID = l.id;
                    }
                    if(l.DSAname__c !=null){
                        leaddata.DSA_Name = l.DSAname__c;
                    }
                    if(l.LastModifiedBy.Name !=null){
                        leaddata.Agent_Name = l.LastModifiedBy.Name;
                    }
                    System.debug('Json Serialize : '+JSON.serialize(leaddata));
                    System.debug('endpoint url ==> ' + System.Label.LeadtoGreetUpdateAPIURL);
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(System.Label.LeadtoGreetUpdateAPIURL);
                    request.setTimeout(120000);
                    request.setMethod('POST');
                    request.setHeader('Content-Type', 'application/json');
                    String jsonBody = JSON.serialize(leaddata);
                    system.debug('JSON BODY : '+jsonBody);
                    request.setBody(jsonBody);
                    Http http = new Http();
                    if(!test.isRunningTest()){
                        HttpResponse response = http.send(request);
                        system.debug('get response :'+response.getBody());
                        System.debug('code ==> ' + response.getStatusCode());
                        responseMap.put(l.Id, 'Response : ' + response);    
                        requestBodyMap.put(l.Id, jsonBody);
                        if(response.getStatusCode() == 200 && System.Label.Lead_To_Greet_Trigger_Point == 'Code'){
                            LeadtogreetSecondryAPI callout = new LeadtogreetSecondryAPI(jsonBody);
                            System.enqueueJob(callout);
                        }
                    }
                }
            }
            if(responseMap.size() > 0){
                insertResponse(responseMap, requestBodyMap); 
            }
        }
        catch(Exception exc){
            system.debug('Exception in LeadtoGreet: ' + exc.getMessage());
        }
    } 
    
    public static void insertResponse(Map<Id, String> responseMap, Map<Id, String> requestBodyMap){
        System.debug('insertResponse | responseMap ==> ' + responseMap);
        System.debug('insertResponse | requestBodyMap ==> ' + requestBodyMap);
        
        if(RecursiveTriggerHandler.isFirstTime){
            RecursiveTriggerHandler.isFirstTime = false;
            List<Intergration_Request__c> irList = [SELECT Id, LeadId__c, Responce__c, Request_Body__c  FROM Intergration_Request__c WHERE LeadId__c IN: responseMap.keySet()];
            if(irList.size() > 0){
                for(Intergration_Request__c ir: irList){
                    ir.Responce__c = responseMap.get(ir.LeadId__c);  
                    ir.Request_Body__c = requestBodyMap.get(ir.LeadId__c);
                    ir.Type__c = 'LeadToGreet';
                    ir.Lead_To_Greet_Response__c = responseMap.get(ir.LeadId__c);  
                    ir.Lead_To_Greet_1st_API__c = true;
                    String responseString = responseMap.get(ir.LeadId__c);
                    Integer statusCode;
                    if(responseString != null && responseString.contains('StatusCode=')) {
                        Integer startIndex = responseString.indexOf('StatusCode=') + 'StatusCode='.length();
                        Integer endIndex = responseString.indexOf(']', startIndex);
                        if (endIndex > startIndex) {
                            String statusCodeStr = responseString.substring(startIndex, endIndex);
                            statusCode = Integer.valueOf(statusCodeStr);
                        }
                    }
                    System.debug('StatusCode: ' + statusCode);
                    ir.Responce_Code__c = statusCode;
                }    
            }else{
                for(String leadId: responseMap.keySet()){
                    Intergration_Request__c irObj = new Intergration_Request__c();
                    irObj.LeadId__c = leadId;
                    irObj.Responce__c = responseMap.get(leadId);
                    irObj.Request_Body__c = requestBodyMap.get(leadId);
                    irObj.Type__c = 'LeadToGreet';
                    irObj.Lead_To_Greet_Response__c = responseMap.get(leadId);
                    irObj.Lead_To_Greet_1st_API__c = false;
                    String responseString = responseMap.get(leadId);
                    Integer statusCode;
                    if(responseString != null && responseString.contains('StatusCode=')) {
                        Integer startIndex = responseString.indexOf('StatusCode=') + 'StatusCode='.length();
                        Integer endIndex = responseString.indexOf(']', startIndex);
                        if (endIndex > startIndex) {
                            String statusCodeStr = responseString.substring(startIndex, endIndex);
                            statusCode = Integer.valueOf(statusCodeStr);
                        }
                    }
                    System.debug('StatusCode: ' + statusCode);
                    irObj.Responce_Code__c = statusCode;
                    irList.add(irObj); 
                }
            }
            System.debug('irList ==> ' + irList);   
            UPSERT irList;    
        }
    }
    
}