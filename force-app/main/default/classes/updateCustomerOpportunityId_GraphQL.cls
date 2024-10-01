public class updateCustomerOpportunityId_GraphQL {
    @InvocableMethod(callout=true)
    public static void updateCustomerOpportunityId(List<Id> recId) {
        System.debug('recordId::'+recId);
        List<Opportunity> oppList =[Select Id, Name, Mobile__c From Opportunity Where id=:recId LIMIT 1];
        GraphQLNode updateCustomerOpportunityIdNode = new GraphQLNode('updateCustomerOpportunityId')
            .withArgument('opportunityID',recId[0])
            .withArgument('customerPhone',oppList[0].Mobile__c)
            .withField('code')
            .withField('message');
        
        
        GraphQLMutationNode updateCustomerOpportunityIdMutation = new GraphQLMutationNode('updateCustomerOpportunityId', updateCustomerOpportunityIdNode);
        GraphQLRequest request = updateCustomerOpportunityIdMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Request: ' + request);
        system.debug('Response: ' + response);
    }

}