@isTest
public class GraphQLHttpClient_test {

    @isTest
    public static void errors1() 
    {
        GraphQLNode AuthNode = new GraphQLNode('AuthenticationToken')
            .withArgument('clientId',System.label.MS_Auth_Token_GraphQL)
            .withField('code')
            .withField('message')
            .withField('accessToken');
        
        GraphQLMutationNode authMutationNode = new GraphQLMutationNode('AuthenticationToken', AuthNode);
        GraphQLRequest request = authMutationNode.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient();
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        GraphQLResponse response = client.send(request);
    }
    @isTest
    public static void errors2() 
    {
        GraphQLNode AuthNode = new GraphQLNode('AuthenticationToken')
            .withArgument('clientId',System.label.MS_Auth_Token_GraphQL)
            .withField('code')
            .withField('message')
            .withField('accessToken');
        
        GraphQLMutationNode authMutationNode = new GraphQLMutationNode('AuthenticationToken', AuthNode);
        GraphQLRequest request = authMutationNode.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient('http://asdf.com');
		IGraphQLResponseCallback callback;
        Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        Id id = client.sendAsync(request, callback);
    }
}