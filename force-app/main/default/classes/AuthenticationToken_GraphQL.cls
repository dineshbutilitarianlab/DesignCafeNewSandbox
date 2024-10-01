public class AuthenticationToken_GraphQL {
    //@future (callout=true)
    public static ResponseDataOfAuth authorization() {
        
        GraphQLNode AuthNode = new GraphQLNode('AuthenticationToken')
            .withArgument('clientId',System.label.MS_Auth_Token_GraphQL)
            .withField('code')
            .withField('message')
            .withField('accessToken');
        
        GraphQLMutationNode authMutationNode = new GraphQLMutationNode('AuthenticationToken', AuthNode);
        GraphQLRequest request = authMutationNode.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Request auth: ' + request);
        system.debug('Response auth: ' + response);
        system.debug('Response auth json: ' + JSON.serialize(response));
        Object dataAsMap = response.getDataNode('AuthenticationToken');
        system.debug('dataAsMap: auth:' +dataAsMap);
        ResponseDataOfAuth respData = new ResponseDataOfAuth();
        if (dataAsMap != null){
            respData = (ResponseDataOfAuth)JSON.deserialize(JSON.serialize(dataAsMap), ResponseDataOfAuth.class);
        }
        //Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(dataAsMap));
        system.debug('responseMap: auth:' +respData);
        return respData;
    }
    public class ResponseDataOfAuth {
        public Integer code;
        public Integer statusCode;
        public String message;
        public string accessToken;        
    }
}