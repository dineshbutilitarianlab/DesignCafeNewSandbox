@RestResource(urlMapping='/Quoteattach')
global without sharing class QuoteAttachFromDD {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap Quotedata = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        try{
            List<Quote> qt = [Select id from Quote where id =:Quotedata.id limit 1];
            if(qt.size()!=0)
            {
                Quote q = new Quote();
                q.id = Quotedata.id;
                update q;
                if(q.id != null){
                    for(DocumentWrap d :Quotedata.documents){
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
                        if(d.Civil_Work_Proposal !=null){
                            attach.WhatsApp_Civil_Proposal__c = d.Civil_Work_Proposal;
                        }
                        if(d.Interior_Work_Proposal != null){
                            attach.WhatsApp_Int_Proposal__c = d.Interior_Work_Proposal;
                        }
                        if(d.PPT_Document !=null){
                            attach.Whatsapp_PPT__c = d.PPT_Document;
                        }
                        attach.VersionData  = EncodingUtil.base64Decode(attachbody);
                        insert attach;
                        string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
                        ContentDocumentLink DocLink = new ContentDocumentLink();
                        DocLink.ContentDocumentId = Versid;
                        docLink.ShareType='V';
                        DocLink.LinkedEntityId = q.id;
                        DocLink.Visibility='AllUsers';
                        insert DocLink;
                    }
                }
                response.StatusCode = '200';
                response.status = 'Success';
                response.id = q.id;
                response.Message = 'Quote added successfully';
            }
            else{
                response.StatusCode = '400';
                response.status = 'Error';
                response.message = 'Please check recordId';
            }
        }
        catch(Exception exc) {
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
        
         //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(), '/Quoteattach', req.requestBody.toString(),  Response.Message, 'in');
        return response;
    }
    global class DetailsWrap{
        public string id;
        public List<DocumentWrap> documents;
    }
    global class DocumentWrap{
        public String fileName;
        public String Content_Type;
        public Boolean Civil_Work_Proposal;
        public Boolean Interior_Work_Proposal;
        public Boolean PPT_Document;
        public String data;
    }
    global class PostResponseWrapper {
        String status;
        String Message;
        String id;
        String StatusCode;
    }
}