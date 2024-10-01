public class DC_WebnengageTask {
    public class taskDataWrap{
        Public string userId{get;set;}
        Public String eventName{get;set;}
        Public String eventTime{get;set;}
    }
    @Future(callout=true)
    public static void callout(Set<id> taskIds){
        List<Task> taskRecords = [SELECT Id, disposition_code__c, createddate, whoid FROM Task Where Id IN: taskIds and whoid != null];
        if(taskRecords.size() > 0){
        system.debug('taskRecords=> '+taskRecords);
            Set<Id> whoids = new Set<Id>();
            Map<Id,String> leadMap = new Map<Id,String>();
            DCWebengage__c webengageCall = DCWebengage__c.getValues('DCWebengageTask');
            for(Task taskRec : taskRecords){
                whoids.add(taskRec.whoid);
            }
            List<Lead> leadRecords = [Select Id, APIMOBILE__c From Lead Where Id IN: whoids and APIMOBILE__c != null];
            if(leadRecords.size() > 0){
            system.debug('leadRecords => '+leadRecords );
                for(Lead leadRec : leadRecords){
                    leadMap.put(leadRec.id, leadRec.APIMOBILE__c);
                }        
                for(Task taskRec : taskRecords){
                    taskDataWrap tskWrap = new taskDataWrap();
                    system.debug('leadMap=> '+leadMap);
        
                   if(taskRec.disposition_code__c != null && leadMap!= null && leadMap.containsKey(taskRec.whoid)){
                        system.debug('leadMapkey '+leadMap.containsKey(taskRec.Id));
                       tskWrap.eventName = taskRec.disposition_code__c;
                       tskWrap.eventTime = taskRec.createddate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss-SSSS');
                       system.debug('createddate :'+taskRec.createddate);
                        // tskWrap.eventTime= '2022-11-20T16:24:00-0800';
                       tskWrap.userId= leadMap.get(taskRec.whoid);
                       String jsonBody = JSON.Serialize(tskWrap);
                       HttpRequest request = new HttpRequest();
                       HttpResponse response = new HttpResponse();
                       request.setEndpoint(webengageCall.url__c);
                       //request.setHeader('Authorization','Bearer ' + UserInfo.getSessionID());
                       system.debug('webengageCall.BearerToken__c'+webengageCall.BearerToken__c);
                       request.setHeader('Authorization','Bearer '+webengageCall.BearerToken__c);
                       request.setHeader('Content-Type','application/json');
                       request.setMethod('POST');
                       request.setBody(jsonBody);
                       system.debug('jsonBody'+request.getBody());
                       system.debug('request'+request);
                       Http http = new Http();
                       response = http.Send(request);
                       System.Debug('webengage task response :'+response.getBody());
                   }
                }
            }
            
        }       
        
    }
}