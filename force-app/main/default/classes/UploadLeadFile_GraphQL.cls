public class UploadLeadFile_GraphQL {
    public static void uploadFile(Id leadID, Id oppId, String idType){
        list<ContentDocumentLink> files;
        list<Contentversion> filedetails;
        if (idType == 'lead')
        {
            files = [Select ContentDocumentId, LinkedEntityId
                    from ContentDocumentLink where LinkedEntityId IN (SELECT Id FROM Lead
                                                                      where Id = :leadID)];
        } else	// Opportunity
        {
            files = [Select ContentDocumentId, LinkedEntityId, ContentDocument.Title,
                    ContentDocument.createdDate, ContentDocument.FileType
                    from ContentDocumentLink where LinkedEntityId IN (SELECT Id FROM opportunity
                                                                      where Id = :oppId) LIMIT 1];
        }
        Set<String> ContentDocumentIdList = new Set<String>();
        if (files != null) {
            for(ContentDocumentLink ContentDocumentList: files) {
                if (ContentDocumentList.ContentDocumentId != null) {
                    ContentDocumentIdList.add(ContentDocumentList.ContentDocumentId);
                }
            }
        }
        System.debug('ContentDocumentIdList In UploadLeadFile Class::' +ContentDocumentIdList);
        filedetails = [Select id,ContentDocumentId,title,FileType,versionData from Contentversion where ContentDocumentId IN :ContentDocumentIdList];
        
        List<LeadAttachment> attachmentList = new List<LeadAttachment>();
        
        for(Contentversion ContentversionList: filedetails) {
            leadAttachment attachLeadwrp = new leadAttachment();
            attachLeadwrp.filename = ContentversionList.title;
            attachLeadwrp.Content_Type = ContentversionList.FileType;
            attachLeadwrp.base64 =  EncodingUtil.base64Encode(ContentversionList.versionData);
            system.debug('filename' +attachLeadwrp.filename +  'BASE64::' + attachLeadwrp.base64);
            attachmentList.add(attachLeadwrp);
        }
        system.debug('attachmentList in UploadLeadFile class::' + attachmentList);
        
        // Now call the API
        GraphQLNode uploadLeadFiles = new GraphQLNode('uploadLeadFiles')
            .withArgument('leadAttachment', attachmentList)
            .withArgument('leadid', leadId)
            .withArgument('opportunityid', oppId)
            .withField('code')
            .withField('message')
            .withField('data');
                
        GraphQLMutationNode uploadLeadFileMutation = new GraphQLMutationNode('uploadLeadFileMutation', uploadLeadFiles);
        GraphQLRequest request = uploadLeadFileMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('request: ' + request);
        system.debug('Response: ' + response); 
    }
    
    public class leadAttachment {
        String filename;
        String Content_Type;
        String base64;
    }
}