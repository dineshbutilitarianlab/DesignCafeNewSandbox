public class UpdateCustomer_GraphQL {
    @Future(Callout = true)
    public static void UpdateCustomer(String recId) {
        List<Account> accList =[Select Id, Name, PersonMobilePhone, PersonEmail, GST_No__c, PAN__c, FirstName, LastName,
                                Customer_type__c, l10n_in_gst_treatment__c, Region__c,
                                BillingCity, BillingCountry, BillingStreet, shippingCity,
                                shippingCountry, shippingStreet, shippingPostalCode, shippingState, DSA_Category__c,
                                BillingPostalCode, BillingState From Account Where id=:recId LIMIT 1];
        //,Country_Code__c
        list<Address> addlist = new list<Address>();
        Address billingAddress = new Address();
        billingAddress.city = accList[0].BillingCity;
        billingAddress.country = accList[0].BillingCountry;
        billingAddress.street = accList[0].BillingStreet;
        billingAddress.zip = accList[0].BillingPostalCode;
        billingAddress.state = accList[0].BillingState;
        billingAddress.addresstype = 1;
        //billingAddress.countrycode = accList[0].Country_Code__c;
        addlist.add(billingAddress);
        Address shippingAddress = new Address();
        shippingAddress.city = accList[0].shippingCity;
        shippingAddress.country = accList[0].shippingCountry;
        shippingAddress.street = accList[0].shippingStreet;
        shippingAddress.zip = accList[0].shippingPostalCode;
        shippingAddress.state = accList[0].shippingState;
        shippingAddress.addresstype = 2;
        addlist.add(shippingAddress);
                
        GraphQLNode updateCustomerDetailsNode = new GraphQLNode('updateCustomerDetails')
            .withArgument('customerPhone', accList[0].PersonMobilePhone)
            .withArgument('firstname', accList[0].FirstName)
            .withArgument('lastname', accList[0].LastName)
            .withArgument('address', addlist)
            //.withArgument('countrycode', accList[0].Country_Code__c)
            .withArgument('gstno', accList[0].GST_No__c)
            .withArgument('pancardno', accList[0].PAN__c)
            .withArgument('customeremail', accList[0].PersonEmail)
            .withArgument('customertype', accList[0].Customer_type__c)
            .withArgument('i10ingsttreatment', accList[0].l10n_in_gst_treatment__c)
            .withArgument('dsacategory', accList[0].DSA_Category__c)
            .withArgument('region', accList[0].Region__c)
            .withArgument('salesforceid', accList[0].Id)
            .withField('code')
            .withField('message');
        
        GraphQLMutationNode updateCustomerDetailsMutation = new GraphQLMutationNode('UpdateCustomerDetails', updateCustomerDetailsNode);
        GraphQLRequest request = updateCustomerDetailsMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Request: ' + request);
        system.debug('Response: ' + response);
        system.debug('Name: ' + accList[0].LastName);
    }
    public class Address {
        String city;
        String country;
        String street;
        String zip;
        String state;
        //String countrycode;
        Integer addresstype;
    }
}