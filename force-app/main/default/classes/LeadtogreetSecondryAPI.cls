public class LeadtogreetSecondryAPI implements Queueable, Database.AllowsCallouts {
    String body;
    
    public LeadtogreetSecondryAPI(String body){
        System.debug('body ==> ' + body);
        this.body = body;
    }
    
    public void execute(QueueableContext context) {     
        System.debug('body in execute '  + body);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.SecondryGreetAPI);
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = body;
        System.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        if(!test.isRunningTest()){
        	HttpResponse response = http.send(request);
            system.debug('body ==> ' + response.getBody());
            System.debug('code ==> ' + response.getStatusCode());
        }
    }
}