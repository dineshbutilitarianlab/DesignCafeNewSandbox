global class getLeadAttachmentMock implements HttpCalloutMock{

    global HttpResponse respond(HttpRequest req){
        HttpResponse resp = new HttpResponse();
//        String json =  '[DATA_FIELD=data, ERRORS_FIELD=errors, errors=(), responseJson={data={getLeadAttachments={code=200, data=({contenttype=application/pdf, filekey=sample.pdf, id=6, leadid=00QC3000000ceipMAA, location=https://dev-designcafe.s3.ap-south-1.amazonaws.com/sample.pdf}), message=success}}}]';
        String respJson = '{"errors":[], "data":{"getLeadAttachments":{"code":200, "data":[{"contenttype":"application/pdf", "filekey":"sample.pdf", "id":6, "leadid":"00QC3000000ceipMAA", "location":"https://dev-designcafe.s3.ap-south-1.amazonaws.com/sample.pdf"}], "message":"success"}}}';
//        String reqJson = '{"query":"query getLeadAttachments{getLeadAttachments(type:0,leadid:00QC3000000dfJTMAY){code,message,data{filekey,id,contenttype,location,leadid}}}"}';
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(200);
        resp.setBody(respJson);
        return resp;
    }
}