public class UpdateBookingFormStatus_GraphQL {
    
    @future(callout=true)
    public static void UpdateBookingFormStatus(String Id) {
        /*
mutation UpdateBookingFormStatus($customerid: Int! ,$bookingformstatus: String!)
updateBookingFormStatus(customerid: $customerid, bookingformstatus: $bookingformstatus) {
code
message
}
}
Variables
{
"customerid": 13,
"bookingformstatus": "Generated"
}
*/
        list<opportunity> opplist = [SELECT id, name, Booking_Form_Status__c, Mobile__c FROM opportunity where id =: Id LIMIT 1];
        GraphQLNode updateBookingFormStatusNode = new GraphQLNode('updateBookingFormStatus')
            .withArgument('customerphone', opplist[0].Mobile__c)
            .withArgument('bookingformstatus', opplist[0].Booking_Form_Status__c)
            .withArgument('opportunityId', opplist[0].Id)
            .withField('code')
            .withField('message');
        String IntType = 'Int!';
        String StrType = 'String!';
        GraphQLMutationNode updateBookingFormMutation = new GraphQLMutationNode('UpdateBookingFormStatus', updateBookingFormStatusNode);
        GraphQLRequest request = updateBookingFormMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Request for UpdateBookingFormStatus: ' + request);
        system.debug('Response for UpdateBookingFormStatus: ' + response);
    }
    
}