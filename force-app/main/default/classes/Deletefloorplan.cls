@RestResource(urlMapping='/Deletefloorplan')
global without sharing class Deletefloorplan {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap Leaddata = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        List<Lead> ld = [Select id from Lead where id =:Leaddata.id limit 1];
        for(DocumentWrap d :Leaddata.documents){
            List<ContentDocumentLink> contentLinkList = [Select Id, LinkedEntityId, LinkedEntity.name, ContentDocumentId , ContentDocument.title from ContentDocumentLink WHERE LinkedEntityId in (SELECT Id FROM Lead Where id = :Leaddata.id) AND ContentDocument.title =:d.fileName ];
            system.debug('cdl : '+contentLinkList);
            if(ld.size()!=0)
            {
                if(contentLinkList.size()!=0 ){
                    delete contentLinkList;
                    response.StatusCode = '200';
                    response.status = 'Success';
                    response.Message = 'Floor plan Deleted';
                }
                else{
                    response.StatusCode = '400';
                    response.status = 'Error';
                    response.message = 'File not found';
                }
            }
        }
        //Calling ApiCallLogger class
      ApiCallLogger.method(system.UserInfo.getUserId(), '/Deletefloorplan', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    global class DetailsWrap{
        public string id;
        public List<DocumentWrap> documents;
    }
    global class DocumentWrap{
        public String fileName;
    }
    global class PostResponseWrapper {
        String status;
        String Message;
        String StatusCode;
    }
}