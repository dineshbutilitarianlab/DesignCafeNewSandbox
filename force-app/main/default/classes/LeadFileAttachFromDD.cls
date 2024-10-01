@RestResource(urlMapping='/Leadattach')
global without sharing class LeadFileAttachFromDD {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap Leaddata = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        try{
            List<Lead> ld = [Select id from Lead where id =:Leaddata.id limit 1];
            if(ld.size()!=0)
            {
                Lead l = new Lead();
                l.id = Leaddata.id;
                if(Leaddata.documents[0].PPT_Document ==true){
                    l.PPT_Uploaded__c =true;
                }
                update l;
                if(l.id != null){
                    for(DocumentWrap d :Leaddata.documents){
                        ContentVersion attach=new ContentVersion();
                        String attachbody = d.data;
                       // if(!Test.isRunningTest())
                        {
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
                        System.debug('*****'+attach);
                        System.debug('*****'+attach.id);
                        string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
                        ContentDocumentLink DocLink = new ContentDocumentLink();
                        DocLink.ContentDocumentId = Versid;
                        docLink.ShareType='V';
                        DocLink.LinkedEntityId = l.id;
                        DocLink.Visibility='AllUsers';
                        insert DocLink;
                    }
                }
                response.StatusCode = '200';
                response.status = 'Success';
                response.Lead_id = l.id;
                response.Message = 'File added successfully';
            }
            else{
                response.StatusCode = '400';
                response.status = 'Error';
                response.message = 'Please check recordId';
            }
        }
        catch(Exception exc) {
            system.debug(exc.getmessage());
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
    //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(),'/Leadattach', req.requestBody.toString(), Response.message, 'in');
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
        String Lead_id;
        String StatusCode;
    }
}