@RestResource(urlMapping='/Opptyattach')
global without sharing class OppFileAttachFromDD {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap Oppdata = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        try{
            List<Opportunity> opp = [Select id from Opportunity where id =:Oppdata.id limit 1];
            if(opp.size()!=0)
            {
                Opportunity o = new Opportunity();
                o.id = Oppdata.id;
                update o;
                if(o.id != null){
                    for(DocumentWrap d :Oppdata.documents){
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
                        DocLink.LinkedEntityId = o.id;
                        DocLink.Visibility='AllUsers';
                        insert DocLink;
                    }
                }
                response.StatusCode = '200';
                response.status = 'Success';
                response.id = o.id;
                response.Message = 'File added successfully';
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
     ApiCallLogger.method(system.UserInfo.getUserId(),'/Opptyattach', req.requestBody.toString(),'Res', 'in');
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