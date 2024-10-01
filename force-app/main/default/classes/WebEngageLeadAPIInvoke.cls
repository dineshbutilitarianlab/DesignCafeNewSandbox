public class WebEngageLeadAPIInvoke{
    @InvocableMethod(label='Get Lead Coverted' description='Returns the list of lead Status corresponding to the specified lead IDs.' category='Lead')
    public static  void getLeadStage(List<ID> ids) {  
        System.debug('executed'+ids);
        calloutmethod(ids);
    }
    
    @future(callout=true)
    public static void calloutmethod(List<Id> ids){
        System.debug('future'+ids);
        Lead leads = new Lead();
        if(ids.get(0) != null ){
            leads = [SELECT Status,Is_Lead_Update__c,MobilePhone,Call_Stage__c,DC_Lead_Status__c FROM Lead WHERE Id  = : ids.get(0) Limit 1];
        }
        System.debug('leads==='+leads);
        System.debug('leads.Is_Lead_Update__c=== '+leads.Is_Lead_Update__c);
        if(leads.Is_Lead_Update__c){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:WebEngageCredentials/v1/accounts/76aa813/events');           
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            String leadJson = '{ "userId": "'+leads.MobilePhone+'", "eventName": "'+leads.Status+' -  '+leads.DC_Lead_Status__c+' - '+leads.Call_Stage__c+' ", "eventData": { } }';
            System.debug('leadJson=='+leadJson.trim());
            String trimmed = leadJson.trim(); 
            request.setBody (trimmed);
            System.debug('request'+request);
            HttpResponse response = http.send(request);
            System.debug('response'+response);
            System.debug('code=='+response.getStatusCode() );
            // If the request is successful, parse the JSON response.
            
            if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('result'+results);
                // Cast the values in the 'animals' key as a list
                
                System.debug('leads'+leads);
            }
        }
    }
    
}