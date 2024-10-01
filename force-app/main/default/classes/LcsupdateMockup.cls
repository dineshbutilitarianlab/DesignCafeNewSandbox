global class LcsupdateMockup implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
       Opportunity Opp = [Select id,Name,Email__c,Home_Type__c,Project_Name__c, Region__c,Designer__c from Opportunity limit 1];
       LcsAPIupdate.OppdataWrap Oppdata = new LcsAPIupdate.OppdataWrap();        
        Opp.Name='awdhesh';
        Opp.Home_Type__c='villa';
        Opp.Project_Name__c='Awdhesh test';
   
     //  Opp.Designer__c='';
       Opp.Region__c='Bengaluru';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       response.setBody(JSON.serialize(Opp));
        response.setStatusCode(200);
        return response;
    }
}