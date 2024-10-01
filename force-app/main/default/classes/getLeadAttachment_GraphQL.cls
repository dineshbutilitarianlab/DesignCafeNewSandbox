public class getLeadAttachment_GraphQL {
    @AuraEnabled 
    public static Integer LeadAttachment(String recId) {
        List<Lead> leadList = [Select Id, File_Name__c, File_Url__c From Lead Where Id =:recId LIMIT 1];
        system.debug('RecordId::'+recId);
        
        GraphQLNode dataNode = new GraphQLNode('data')
            .withField('filekey')
            .withField('id') 
            .withField('contenttype')
            .withField('location')
            .withField('leadid');
        
        GraphQLNode leadAttachmentNode = new GraphQLNode('getLeadAttachments')
            .withArgument('type', 0)
            .withArgument('leadid', recId)
            .withField('code')
            .withField('message')
            .withNode(dataNode);
        
        system.debug('leadAttachmentNode::'+leadAttachmentNode);
        GraphQLQueryNode leadAttachmentMutation = new GraphQLQueryNode('getLeadAttachments', leadAttachmentNode);
        system.debug('leadAttachmentMutation::'+leadAttachmentMutation);
        GraphQLRequest request = leadAttachmentMutation.buildRequest();
        System.debug('Request: ' + request);
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        
        system.debug('Raw Response::'+ response);
        System.debug('Data:hasError:' +response.hasErrors());
        System.debug('Data:has Data:'+response.hasData());
        Integer Code;
        
        if (response.hasData()) {
            Object dataAsMap = response.getDataNode('getLeadAttachments');
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(dataAsMap));
            List<Object> responseList = (List<Object>) JSON.deserializeUntyped(JSON.serialize(responseMap.get('data')));
            system.debug('responseList11::'+responseList);
            Map<String, Object> ExactValueMap = new Map<String, Object>();
            if (!responseList.isEmpty()) {
                ExactValueMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(responseList[0]));
                system.debug('ResponseMap::'+ExactValueMap.get('filekey'));
                String FileName = String.valueOf(ExactValueMap.get('filekey'));
                String URL = String.valueOf(ExactValueMap.get('location'));
                Code = Integer.valueOf(responseMap.get('code'));
                leadList[0].File_Name__c = FileName;
                leadList[0].File_Url__c = URL;
                system.debug('FileName::'+ FileName+'URL::'+ URL + 'Code' + Code);
            }
            else {
                Code = 400;
            } 
        }
        else if (response.hasErrors()) {
            Code = 500;
        }
        update leadList;
        return Code;
    }
}