public class AssignDesignTeam_GraphQL {

    @InvocableMethod(callout=true)
    public static void assignDesignerTeam(list<id> leadId) {
        System.debug('AssignDesignTeam_GraphQL | assignDesignerTeam Call');
        System.debug('leadId ==> ' + leadId);
/*
mutation AssignTeamsToLead($leadId: String) {
assignTeamsToLead(leadId: $leadId) {
code
message
}
}

Arguments
{
"leadId": "00QC3000000WFjtMAG"
}
*/
        GraphQLNode assignTeamsToLeadNode = new GraphQLNode('assignTeamsToLead')
            .withArgument('leadId', '$leadId')
            .withField('code')
            .withField('message');
        GraphQLMutationNode assignTeamsToLeadMutation = new GraphQLMutationNode('AssignTeamsToLead', assignTeamsToLeadNode)
            .withVariable('leadId', 'String');        
        GraphQLRequest request = assignTeamsToLeadMutation.buildRequest()
            .withVariable('leadId', leadId[0]);
        
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        System.debug('Client : ' + client);
        System.debug('Response : ' + response);
        System.debug('Request : ' + request);
    }

}