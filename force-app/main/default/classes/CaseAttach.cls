@RestResource(urlMapping='/caseattach')
global without sharing class CaseAttach {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap Casedata = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        List<Case> cs = [Select id from case where id =:Casedata.id limit 1];
        System.debug('****'+cs);
        if(cs.size()!=0)
        {
            Case c = new Case();
            c.id = Casedata.id;
            update c;
            if(c.id != null){
                for(DocumentWrap d :Casedata.documents){
                    ContentVersion attach=new ContentVersion();
                    String attachbody = d.data;
                    if(!Test.isRunningTest()){
                        attach.ContentLocation ='S';
                    }
                    attach.Title = d.fileName;
                    attach.PathOnClient = d.fileName;
                    attach.VersionData  = EncodingUtil.base64Decode(attachbody);
                    insert attach;
                    System.debug('attach'+attach.ContentDocumentId);
                    System.debug('****'+attach);
                    string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
                   // System.debug('Versid'+Versid);
                    ContentDocumentLink DocLink = new ContentDocumentLink();
                    DocLink.ContentDocumentId = Versid;
                    docLink.ShareType='V';
                    DocLink.LinkedEntityId = c.id;
                    DocLink.Visibility='AllUsers';
                    insert DocLink;
                }
            }
            res.StatusCode                              = 201;
            response.status                             = 'Success';
            response.id                           	= c.id;
        }
        
           
      //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(),'/caseattach', req.requestBody.toString(),'Res', 'in');
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
    }
}