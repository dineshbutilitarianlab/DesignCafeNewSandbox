public class PaymentRequestQueueable implements Queueable, Database.AllowsCallouts{
    private List<Request_Payment__c> paymReqList;
    private Set<Id> opportunityIds;
  
    public PaymentRequestQueueable( List<Request_Payment__c> records, Set<Id> opportunityset) {
        System.debug('PaymentRequestQueueable call');
        System.debug('opportunityset ==> ' + opportunityset);
        System.debug('records ==> ' + records);
        this.paymReqList = records;
        this.opportunityIds = opportunityset;
       
    }

    public void execute(QueueableContext context) {
        List<opportunity> updateOpportunity = new List<opportunity>();
        Map<id,Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Id, Name, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Customer_ID__c, AccountId, StageName,
                                                Email__c, Quote_Id__c,Designer_Team_Name__c,EC_Name__c,UserId__c, Modular_Milestone_Type__c 
                                                FROM Opportunity
                                                WHERE Id IN :opportunityIds]);
        
        for (Request_Payment__c variable : paymReqList) {
            Opportunity oppRec = opportunityMap.get(variable.Opportunity__c);
            if(oppRec != Null){
                        variable.Request_Amount__c = getRequestAmount(oppRec);
                        variable.Description__c = getDescription(oppRec);
                        variable.Category__c = getCategory(oppRec);
            
                        variable.Email__c = oppRec.Email__c;
                        variable.User_Id__c = oppRec.UserId__c;
                        variable.Team_Name__c = oppRec.Designer_Team_Name__c;
                        variable.EC_Name__c = oppRec.EC_Name__c;
                        }

        }
         
        
        // awesome code here
        System.debug('this.paymReqList => '+ paymReqList);
        AuthenticationToken_GraphQL.ResponseDataOfAuth authToken = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
        authToken = AuthenticationToken_GraphQL.authorization();
        System.debug('authToken in 5: '+authToken);
        //String authToken = AuthenticationToken_GraphQL.authorization();
        String status ='Pending';
        String nodeName ='AddPaymentRequests';
        GraphQLNode addPaymentRequestsNode;
        GraphQLMutationNode addPaymentRequestsMutation;
        Date d = Date.today();
        String reqdt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MM-YYYY');
        GraphQLRequest request;
        GraphQLHttpClient client;
        GraphQLResponse response;
        //('firstname',paymReq.First_Name__c)
        if(paymReqList.size()>0){
            for(Request_Payment__c paymReq : paymReqList){
                addPaymentRequestsNode = new GraphQLNode(nodeName)
                .withArgument('requestDate',reqdt)
                .withArgument('category',paymReq.Category__c)
                .withArgument('requestAmount',Integer.ValueOf(paymReq.Request_Amount__c))
                .withArgument('description',paymReq.Description__c)
                .withArgument('clientID',paymReq.Client_ID__c)
                .withArgument('status',status)
                .withArgument('appName','Salesforce')
                .withArgument('firstname',paymReq.First_Name__c)  
                .withArgument('lastname',paymReq.Last_Name__c)
                .withArgument('customerphone',paymReq.Customer_Phone__c)
                .withArgument('customeremail',paymReq.Email__c)
                .withArgument('salesforceid',paymReq.Account_ID__c)
                .withArgument('pancardno',paymReq.PAN_Card_No__c)
                .withArgument('gstno',paymReq.GST_No__c)
                .withArgument('customerType',paymReq.Customer_Type__c)
                .withArgument('opportunityId',paymReq.Oppo_Id__c)
                .withArgument('quoteId',paymReq.Quote_Id__c)
                .withArgument('userId',paymReq.User_Id__c)
                .withArgument('billingStreet',paymReq.Billing_Street__c)
                .withArgument('billingCity',paymReq.Billing_City__c)
                .withArgument('billingCountry',paymReq.Billing_Country__c)
                .withArgument('billingState',paymReq.Billing_State__c)
                .withArgument('billingZip',paymReq.Billing_zip__c)
                .withArgument('shippingStreet',paymReq.Shipping_Street__c)
                .withArgument('shippingCity',paymReq.Shipping_City__c)
                .withArgument('shippingCountry',paymReq.Shipping_Country__c)
                .withArgument('shippingState',paymReq.Shipping_State__c)
                .withArgument('shippingZip',paymReq.Shipping_Zip__c)
                .withArgument('teamName',paymReq.Team_Name__c)
                .withArgument('ecName',paymReq.EC_Name__c)
                .withField('statusCode')
                .withField('message')
                .withField('data')
                .withField('code');
                addPaymentRequestsMutation = new GraphQLMutationNode(nodeName, addPaymentRequestsNode);
                request = addPaymentRequestsMutation.buildRequest()
                    .withHeader('Authorization', authToken.accessToken);
                client = new GraphQLHttpClient(System.label.GraphQLURL);
                response = client.send(request);
                system.debug('Request1: ' + request);
                system.debug('Response1: ' + JSON.serialize(response));
                system.debug('Endpoint1: ' + System.label.GraphQLURL);
                if(response.hasData()){
                    System.debug('response data:: '+response.getDataNode(nodeName));
                }
               
            }
        }//if ends
    }

    public static Decimal getRequestAmount(Opportunity oppRec) {
        Decimal modularCost, siteServiceCost, requestAmount = 0;
        
        if (oppRec.Modular_Milestone_Type__c == '4 Stage') {
            System.debug('oppRec.Modular_Amount_Dis_Incl_GST__c  '+oppRec );
            modularCost = oppRec.Modular_Amount_Dis_Incl_GST__c != null ? oppRec.Modular_Amount_Dis_Incl_GST__c * 0.05 : 0;
            siteServiceCost = oppRec.Site_Services_Amount_Dis_Incl_GST__c != null ? oppRec.Site_Services_Amount_Dis_Incl_GST__c * 0.05 : 0;
            requestAmount = modularCost + siteServiceCost;
            requestAmount = requestAmount.setScale(2);
            System.debug('Modular_Amount_Dis_Incl_GST__c '+oppRec.Modular_Amount_Dis_Incl_GST__c);
            System.debug('Site_Services_Amount_Dis_Incl_GST__c '+oppRec.Site_Services_Amount_Dis_Incl_GST__c);
            System.debug('modularCost '+modularCost);
            System.debug('siteServiceCost '+siteServiceCost);
            System.debug('requestAmount '+requestAmount);
        }else if(oppRec.Modular_Milestone_Type__c == '4 Stage 2'){
            modularCost = oppRec.Modular_Amount_Dis_Incl_GST__c != null ? oppRec.Modular_Amount_Dis_Incl_GST__c * 0.1 : 0;
            siteServiceCost = oppRec.Site_Services_Amount_Dis_Incl_GST__c != null ? oppRec.Site_Services_Amount_Dis_Incl_GST__c * 0.1 : 0;
            requestAmount = modularCost + siteServiceCost;
            requestAmount = requestAmount.setScale(2);
            System.debug('Modular_Amount_Dis_Incl_GST__c '+ oppRec.Modular_Amount_Dis_Incl_GST__c);
            System.debug('Site_Services_Amount_Dis_Incl_GST__c '+ oppRec.Site_Services_Amount_Dis_Incl_GST__c);
            System.debug('modularCost '+modularCost);
            System.debug('siteServiceCost '+siteServiceCost);
            System.debug('requestAmount '+requestAmount);
        }
        return requestAmount;
    }

    public static String getDescription(Opportunity oppRec) {
        String description = '';
        if (oppRec.Modular_Milestone_Type__c == '4 Stage') {
            if (oppRec.Modular_Amount_Dis_Incl_GST__c != null && oppRec.Site_Services_Amount_Dis_Incl_GST__c != null && oppRec.Modular_Amount_Dis_Incl_GST__c > 0 && oppRec.Site_Services_Amount_Dis_Incl_GST__c > 0) {
                description = '5% Modular & Site Service';
            }else if(oppRec.Modular_Amount_Dis_Incl_GST__c != null && oppRec.Modular_Amount_Dis_Incl_GST__c > 0){
                description = '5% Modular';
            }else if(oppRec.Site_Services_Amount_Dis_Incl_GST__c != null && oppRec.Site_Services_Amount_Dis_Incl_GST__c > 0){
                description = '5% Site Service';
            }
            
        }else if(oppRec.Modular_Milestone_Type__c == '4 Stage 2'){
            if (oppRec.Modular_Amount_Dis_Incl_GST__c != null && oppRec.Site_Services_Amount_Dis_Incl_GST__c != null && oppRec.Modular_Amount_Dis_Incl_GST__c > 0 && oppRec.Site_Services_Amount_Dis_Incl_GST__c > 0) {
                description = '10% Modular & Site Service';
            }else if(oppRec.Modular_Amount_Dis_Incl_GST__c != null && oppRec.Modular_Amount_Dis_Incl_GST__c > 0){
                description = '10% Modular';
            }else if(oppRec.Site_Services_Amount_Dis_Incl_GST__c != null && oppRec.Site_Services_Amount_Dis_Incl_GST__c > 0){
                description = '10% Site Service';
            }
        }
        return description;
    }

    public static String getCategory(Opportunity oppRec) {
        String category;
        if (oppRec.Modular_Amount_Dis_Incl_GST__c != null && oppRec.Site_Services_Amount_Dis_Incl_GST__c != null && oppRec.Modular_Amount_Dis_Incl_GST__c > 0 && oppRec.Site_Services_Amount_Dis_Incl_GST__c > 0) {
            category = 'Modular & Site Service';
        }else if(oppRec.Modular_Amount_Dis_Incl_GST__c != null && oppRec.Modular_Amount_Dis_Incl_GST__c > 0){
            category = 'Modular';
        }else if(oppRec.Site_Services_Amount_Dis_Incl_GST__c != null && oppRec.Site_Services_Amount_Dis_Incl_GST__c > 0){
            category = 'Site Service';
        }
        return category;
    }
}