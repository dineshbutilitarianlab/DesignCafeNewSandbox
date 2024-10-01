public class WebEngageOppAPIInvoke {
@InvocableMethod(label='Get Opp Coverted' description='Returns the list of Opportunity Status corresponding to the specified lead IDs.' category='Lead')
    public static  void getOppStage(List<ID> ids) {  
        System.debug('executed'+ids);
        calloutmethod(ids);
    }
    
    @future(callout=true)
    public static void calloutmethod(List<Id> ids){
        System.debug('future'+ids);
        Opportunity opps = new Opportunity();
        if(ids.get(0) != null ){
            opps = [SELECT StageName,Opportunity_status__c,Reason__c,Phone__c,Is_Opportunity_Update__c FROM Opportunity WHERE Id  = : ids.get(0) Limit 1];
        }
        System.debug('opps==='+opps);
        if(opps.Is_Opportunity_Update__c){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:WebEngageCredentials/v1/accounts/76aa813/events');           
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            String oppJson = '{ "userId": "'+opps.Phone__c+'", "eventName": "'+opps.StageName+' -  '+opps.Opportunity_status__c+' - '+opps.Reason__c+' ", "eventData": { } }';
            System.debug('oppJson=='+oppJson.trim());
            String trimmed = oppJson.trim(); 
            request.setBody (trimmed);
            HttpResponse response = http.send(request);
            System.debug('response'+response);
            System.debug('code=='+response.getStatusCode() );
            // If the request is successful, parse the JSON response.
            
            if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('result'+results);
                // Cast the values in the 'animals' key as a list
                
                System.debug('opps'+opps);
            }
        }
    }
}