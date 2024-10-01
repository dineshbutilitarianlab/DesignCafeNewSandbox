global class DC_WebengageTaskMock implements HttpCalloutMock{
	 global HTTPResponse respond(HTTPRequest request) {
         List<task> taskRec = [SELECT Id, disposition_code__c, createddate, whoid FROM Task where  disposition_code__c = 'RNR-Comms' limit 1];
       //DC_WebnengageTask.taskDataWrap ld = new DC_WebnengageTask.taskDataWrap();
         
         string status = 'Queued';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(status));
        res.setStatusCode(200);
        return res;
    }
}