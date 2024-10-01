public class updateCustomerSFID_GraphQL {
    @future (callout=true)
    public static void UpdateCustomer(String recId) {
        List<Account> accList =[Select Id, Name,(Select Id from Opportunities Limit 1), PersonMobilePhone From Account where Id =:recId LIMIT 1];
        GraphQLNode updateCustomerDetailsNode = new GraphQLNode('')
            .withArgument('sfid',recId)
            .withArgument('customerMobile',accList[0].PersonMobilePhone)
            .withArgument('opportunityId',String.valueOf(accList[0].Opportunities[0].Id))
            .withField('code')
            .withField('message');
        
        
        GraphQLMutationNode updateCustomerDetailsMutation = new GraphQLMutationNode('updateCustomerSFID', updateCustomerDetailsNode);
        GraphQLRequest request = updateCustomerDetailsMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Response: ' + response);
        system.debug('Request: ' + request);
    }
    
    @InvocableMethod(callout=true)
    public static void UpdateCustomerNewOppId(List<Id> recId) {
        List<Opportunity> oppList =[Select Id, Name,AccountId,Account.PersonMobilePhone From Opportunity Where id=:recId LIMIT 1];
        GraphQLNode updateCustomerDetailsNode = new GraphQLNode('updateCustomerSFID')
            .withArgument('sfid',oppList[0].AccountId)
            .withArgument('customerMobile',oppList[0].Account.PersonMobilePhone)
            .withArgument('opportunityId',oppList[0].Id)
            .withField('code')
            .withField('message');
        
        
        GraphQLMutationNode updateCustomerDetailsMutation = new GraphQLMutationNode('updateCustomerSFID', updateCustomerDetailsNode);
        GraphQLRequest request = updateCustomerDetailsMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Response: ' + response);
        system.debug('Request: ' + request);
    }
   
}