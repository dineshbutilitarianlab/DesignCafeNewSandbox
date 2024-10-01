public class updateQuote_graphQL {
    public class ActionRequest {
        @InvocableVariable(required = true)
        public String recId;

        @InvocableVariable
        public Boolean modular_discount_changed;

        @InvocableVariable
        public Boolean site_Service_Discount_changed;
        
        @InvocableVariable
        public Boolean modular_amount_discount;
        
        @InvocableVariable
        public Boolean site_service_amount_discount;

    }

    @InvocableMethod (callout=true label='UpdateQuoteDetails API')
    public static void UpdateQuote(List < ActionRequest > requests) {

        System.debug('Enter into updateQuote_graphQL');
        String recId = requests[0].recId;
        Boolean modular_discount_changed = requests[0].modular_discount_changed;
        Boolean site_Service_Discount_changed = requests[0].site_Service_Discount_changed;

        List<Quote> qutList =[Select Id, Name, OpportunityId,
                              Modular_Discount__c, Modular_Fixed_Discount__c, Modular_Fixed_Discount_New__c, DC_modular_xml__c,
                              Site_Services_Discount__c, Site_Service_Fixed_Discount__c, Site_Service_Fixed_Discount_New__c,
                              DC_site_services_xml__c, PM_Fee__c
                              from Quote Where Id =:recId LIMIT 1];
        system.debug('RecordId::'+recId +'Value::'+Integer.ValueOf(qutList[0].Modular_Discount__c));
        if (qutList.size() <= 0)
            return;
        GraphQLNode updateQuoteDetailsNode = new GraphQLNode('UpdateQuoteDetails')
            .withArgument('name', qutList[0].Name)
            .withArgument('quoteId', recId)
            .withArgument('opportunityId', qutList[0].OpportunityId)
			.withArgument('pmFeePercentage ', qutList[0].PM_Fee__c)
            .withArgument('updateModular', modular_discount_changed)
            .withArgument('modularDiscount', qutList[0].Modular_Discount__c)
            //.withArgument('modularDiscount', Integer.ValueOf(qutList[0].Modular_Discount__c))
            .withArgument('modularFixedDiscount', Integer.ValueOf(qutList[0].Modular_Fixed_Discount__c))
            .withArgument('modularFixedDiscountNew', Integer.ValueOf(qutList[0].Modular_Fixed_Discount_New__c))
            .withArgument('modulerXmlLink',qutList[0].DC_modular_xml__c)
            
            .withArgument('updateSiteService', site_Service_Discount_changed)
            .withArgument('siteServiceDiscount', qutList[0].Site_Services_Discount__c )
            //.withArgument('siteServiceDiscount', Integer.ValueOf(qutList[0].Site_Services_Discount__c ))
            .withArgument('siteServiceFixedDiscount', Integer.ValueOf(qutList[0].Site_Service_Fixed_Discount__c))
            .withArgument('siteServiceFixedDiscountNew', Integer.ValueOf(qutList[0].Site_Service_Fixed_Discount_New__c))
            .withArgument('siteServiceXmlLink',qutList[0].DC_site_services_xml__c)

            .withField('code')
            .withField('message')
            .withField('data');
      //Added by muskan jain on 18 March 2023 for Price Hike
        GraphQLMutationNode updateQuoteDetailsMutation = new GraphQLMutationNode('UpdateQuoteDetails', updateQuoteDetailsNode);
        GraphQLRequest request = updateQuoteDetailsMutation.buildRequest();
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        insertResponse(qutList[0].id, response, request);
        system.debug('request: ' + request);
        system.debug('Response: ' + response);
    }
    
    public static void insertResponse(String quoteId, GraphQLResponse response, GraphQLRequest jsonBody){
        Intergration_Request__c irObj = new Intergration_Request__c();
        //string resp = response.toString();
        irObj.Quote__c = quoteId;
        irObj.Responce__c = response.toString();
        irObj.Request_Body__c = JSON.serialize(jsonBody);
        irObj.Type__c = 'Update Quote API'; 
        System.debug('irObj ==> ' + irObj);
        if(irObj != null){
            INSERT irObj;
        }
    }
}