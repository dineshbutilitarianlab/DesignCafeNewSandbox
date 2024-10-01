public with sharing class UploadPaymentDoc {
    @future(Callout = true)
    public static void uploadFile(Id oppId , Id ContentDocumentId) {
        list<ContentDocumentLink> files;
        list<Contentversion> filedetails;
        

        System.debug('ContentDocumentId In UploadLeadFile Class::' +ContentDocumentId);
        filedetails = [Select id,ContentDocumentId,title,FileType,versionData from Contentversion where ContentDocumentId = :ContentDocumentId];
        List<AttachmentWrapper> attachmentList = new List<AttachmentWrapper>();
        for(Contentversion ContentversionList: filedetails) {
            AttachmentWrapper attachLeadwrp = new AttachmentWrapper();
            attachLeadwrp.filename = ContentversionList.title;
            attachLeadwrp.contenttype = ContentversionList.FileType;
            attachLeadwrp.base64 =  EncodingUtil.base64Encode(ContentversionList.versionData);
            system.debug('filename' +attachLeadwrp.filename +  'BASE64::' + attachLeadwrp.base64);
            attachmentList.add(attachLeadwrp);
        }
        system.debug('attachmentList in UploadLeadFile class::' + attachmentList);
        
        // Now call the API
        GraphQLNode uploadLeadFiles = new GraphQLNode('UploadPaymentDoc')
            .withArgument('attachment', attachmentList)
            .withField('code')
            .withField('message')
            .withField('data');
                
        GraphQLMutationNode uploadLeadFileMutation = new GraphQLMutationNode('UploadPaymentDoc', uploadLeadFiles);
        GraphQLRequest request = uploadLeadFileMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('request: ' + request);
        system.debug('Response: ' + response); 

        // if(response.data != null){
        //     String jsonString = response.data.toString();
        //     Response responseWrapper = (Response) JSON.deserialize(jsonString, Response.Class);
        //     if (String.isNotBlank(responseWrapper.data.location) ) {
        //         Opportunity opportunityRecord = new Opportunity();
        //         opportunityRecord.Id = oppId;
        //         opportunityRecord.location = responseWrapper.data.location;
        //         update opportunityRecord;
        //     }
        // }

        
    
    }

    public class AttachmentWrapper {
        public String filename;
        String contenttype;
        String base64;
    }
    public class Response {
        public String code;
        public ResponseData data;
        public String message;
    }
    public class ResponseData {
        public String filekey;
        public String contenttype;
        public String location;
    }

}