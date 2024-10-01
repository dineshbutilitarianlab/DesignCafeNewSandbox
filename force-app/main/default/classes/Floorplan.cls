@RestResource(urlMapping='/Floorplan')
global without sharing class Floorplan {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap Leaddata = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        try{
            List<Lead> ld = [Select id from Lead where id =:Leaddata.id limit 1];
            List<ContentDocumentLink> contentLinkList = [Select Id, LinkedEntityId, LinkedEntity.name, ContentDocumentId , ContentDocument.title from ContentDocumentLink WHERE  LinkedEntityId in (SELECT Id FROM Lead Where id = :Leaddata.id)];
            system.debug('CD :'+contentLinkList);
            if(ld.size()!=0)
            {
                if(contentLinkList.size()!=0){
                    delete contentLinkList;
                }
       /*         Lead l = new Lead();
                l.id = Leaddata.id;
                update l;
                if(l.id != null){  */
                    for(DocumentWrap d :Leaddata.documents){
                        ContentVersion attach=new ContentVersion();
                        String attachbody = d.data;
                        if(!Test.isRunningTest()){
                            attach.ContentLocation ='S';
                        }
                        if(d.fileName != null){
                            attach.Title = d.fileName;
                        }
                        if(d.fileName != null){
                            attach.PathOnClient = d.fileName;
                        }
                        attach.VersionData  =  EncodingUtil.base64Decode(attachbody);
                        insert attach;
                        string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
                        ContentDocumentLink DocLink = new ContentDocumentLink();
                        DocLink.ContentDocumentId = Versid;
                        docLink.ShareType='V';
                        DocLink.LinkedEntityId = ld[0].id;
                        DocLink.Visibility='AllUsers';
                        insert DocLink;
                    }
             //   }
                response.StatusCode = '200';
                response.status = 'Success';
                response.id = ld[0].id;
                response.Message = 'Floor plan added successfully';
                
     
            }
            else{
                response.StatusCode = '400';
                response.status = 'Error';
                response.message = 'File not added';
            }
        }
        catch(Exception exc) {
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
       //Api Call Logger  
     ApiCallLogger.method(system.UserInfo.getUserId(), '/Floorplan', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    global class DetailsWrap{
        public string id;
        public List<DocumentWrap> documents;
    }
    global class DocumentWrap{
        public String fileName;
        public String Content_Type;
        public String data;
    }
    global class PostResponseWrapper {
        String status;
        String Message;
        String id;
        String StatusCode;
    }
}