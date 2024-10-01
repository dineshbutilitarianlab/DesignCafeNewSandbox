public with sharing class PaymentRequestsHandler_GraphQL {
     @AuraEnabled
    public static Map<String,Object> addPaymentRequest( List<Request_Payment__c> paymReqList) {
        AuthenticationToken_GraphQL.ResponseDataOfAuth authToken = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
        authToken = AuthenticationToken_GraphQL.authorization();
        System.debug('authToken in 5: '+authToken);
        //String authToken = AuthenticationToken_GraphQL.authorization();
        String status ='Pending';
        String nodeName ='AddPaymentRequests';
        GraphQLNode addPaymentRequestsNode;
        List<GraphQLNode> graphQLNodeList = new List<GraphQLNode>();
        GraphQLMutationNode addPaymentRequestsMutation;
        List<Request_Payment__c> reqPayList = new List<Request_Payment__c>();
        Date d = Date.today();
        String reqdt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MM-YYYY');
        GraphQLRequest request;
        GraphQLHttpClient client;
        GraphQLResponse response;
        Map<String,Object> objectRespMap = new Map<String,Object>();
        Map<String,Map<String,String>> paymentReqRespMap = new Map<String,Map<String,String>>();
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
                    objectRespMap.put(paymReq.Category__c, response.getDataNode(nodeName));
                }
                
                
            }
        }//if ends
        
        if(!objectRespMap.isEmpty()){
            for(String objKey : objectRespMap.keySet()){
                Map<String,Object> responseObject = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(objectRespMap ?.get(objKey)));
                Map<String,String> payReqMap = (Map<String,String>)JSON.deserialize(JSON.serialize(responseObject ?.get('data')), Map<String,String>.class);
                if(payReqMap !=null){
                   paymentReqRespMap.put(objKey ,payReqMap); 
                }
                
            }
        }
        System.debug('PaymentReqResMap::'+paymentReqRespMap);
        if(!paymentReqRespMap.isEmpty() && paymReqList.size()>0){
            for(Request_Payment__c payReq : paymReqList){
                Map<String,String> tempMap = paymentReqRespMap ?.get(payReq.Category__c);
                Request_Payment__c reqPay = new Request_Payment__c();
                reqPay.Category__c = payReq.Category__c;
                reqPay.Request_Amount__c = payReq.Request_Amount__c;
                reqPay.Description__c = payReq.Description__c;
                reqPay.Client_ID__c = payReq.Client_ID__c;
                reqPay.Request_Date__c = System.Today();
                reqPay.Opportunity__c = payReq.Opportunity__c;
                reqPay.Status__c =status;
                reqPay.Request_Id__c = tempMap ?.get('requestID');
                reqPay.Account_ID__c = payReq.Account_ID__c;
                reqPayList.add(reqPay);
                reqPay.First_Name__c = payReq.First_Name__c;
                reqPay.Last_Name__c = payReq.Last_Name__c;
                reqpay.Customer_Phone__c = payReq.Customer_Phone__c;
                reqPay.Email__c = payReq.Email__c;
                reqPay.Salesforce_Id__c = payReq.Salesforce_Id__c;
                reqPay.PAN_Card_No__c = payReq.PAN_Card_No__c;
                reqpay.GST_No__c = payReq.GST_No__c;
                reqPay.Customer_Type__c = payReq.Customer_Type__c;
                reqPay.Quote_Id__c = payReq.Quote_Id__c;
                reqPay.User_Id__c = payReq.User_Id__c;
                reqPay.Billing_Street__c = payReq.Billing_Street__c;
                reqPay.Billing_City__c = payReq.Billing_City__c;
                reqPay.Billing_Country__c = payReq.Billing_Country__c;
                reqPay.Billing_State__c =payReq.Billing_State__c;
                reqPay.Billing_zip__c = payReq.Billing_zip__c;
                reqPay.Shipping_Street__c = payReq.Shipping_Street__c;
                reqPay.Shipping_City__c = payReq.Shipping_City__c;
                reqPay.Shipping_Country__c = payReq.Shipping_Country__c;
                reqPay.Shipping_State__c = payReq.Shipping_State__c;
                reqPay.Shipping_Zip__c = payReq.Shipping_Zip__c;
                reqPay.Team_Name__c = payReq.Team_Name__c;
                reqPay.EC_Name__c = payReq.EC_Name__c;
            }
        } 
        if(reqPayList.size()>0){
            upsert reqPayList;
        }
        System.debug('objectRespMap:: '+objectRespMap);
        return objectRespMap;
    }
     @future(Callout=True)
    public static void updatepaymentRequest(String recId) {
        System.debug('recId:::'+recId);
            
        List<Request_Payment__c> reqPayList=[Select Id, Name, Status__c, Request_Amount__c,Request_Id__c, Category__c,Request_Date__c, Description__c, Client_ID__c,
                                            First_Name__c,Last_Name__c,Customer_Phone__c,Email__c,PAN_Card_No__c,GST_No__c,Customer_Type__c,Opportunity__c,Quote_Id__c,
                                            User_Id__c,Billing_Street__c,Billing_City__c,Billing_Country__c,Billing_State__c,Billing_zip__c,Shipping_Street__c,
                                            Shipping_City__c,Shipping_Country__c,Shipping_State__c,Shipping_Zip__c,Team_Name__c,EC_Name__c From Request_Payment__c Where Id =: recId LIMIT 1];
        AuthenticationToken_GraphQL.ResponseDataOfAuth authToken = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
        authToken = AuthenticationToken_GraphQL.authorization();
        //String authToken = AuthenticationToken_GraphQL.authorization();
        GraphQLNode updatePaymentRequestsNode = new GraphQLNode('UpdatePaymentRequests')
            .withArgument('requestID',reqPayList[0].Request_Id__c)
            .withArgument('requestDate',String.ValueOf(reqPayList[0].Request_Date__c))
            .withArgument('category', reqPayList[0].Category__c)
            .withArgument('requestAmount',Integer.valueOf(reqPayList[0].Request_Amount__c))
            .withArgument('description',reqPayList[0].Description__c)
            .withArgument('clientID',reqPayList[0].Client_ID__c)
            .withArgument('status',reqPayList[0].Status__c)
            .withArgument('appName','Salesforce')
            .withArgument('quoteId',reqPayList[0].Quote_Id__c)
            .withArgument('billingStreet',reqPayList[0].Billing_Street__c)
            .withArgument('billingCity',reqPayList[0].Billing_City__c)
            .withArgument('billingCountry',reqPayList[0].Billing_Country__c)
            .withArgument('billingState',reqPayList[0].Billing_State__c)
            .withArgument('billingZip',reqPayList[0].Billing_zip__c)
            .withArgument('shippingStreet',reqPayList[0].Shipping_Street__c)
            .withArgument('shippingCity',reqPayList[0].Shipping_City__c)
            .withArgument('shippingCountry',reqPayList[0].Shipping_Country__c)
            .withArgument('shippingState',reqPayList[0].Shipping_State__c)
            .withArgument('shippingZip',reqPayList[0].Shipping_Zip__c)
            .withField('statusCode')
            .withField('message')
            .withField('code');
        
        GraphQLMutationNode updPaymentRequestsMutation = new GraphQLMutationNode('UpdatePaymentRequests', updatePaymentRequestsNode);
        GraphQLRequest request = updPaymentRequestsMutation.buildRequest()
            .withHeader('Authorization', authToken.accessToken);
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Request: ' + request);
        system.debug('Response in update: ' + JSON.serialize(response));
        system.debug('Endpoint: ' + System.label.GraphQLURL); 
    }
     @future(Callout=True)
    public static void deletepaymentRequest(String recId) {
        system.debug('RecordId::'+recId);
        //List<Request_Payment__c> reqPayList=[Select Id,Request_Id__c From Request_Payment__c Where Request_Id__c =: recId LIMIT 1];
        AuthenticationToken_GraphQL.ResponseDataOfAuth authToken = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
        authToken = AuthenticationToken_GraphQL.authorization();
        //String authToken = AuthenticationToken_GraphQL.authorization();
        GraphQLNode deletePaymentRequestsNode = new GraphQLNode('DeletePaymentRequests')
            .withArgument('requestID',recId)
            .withField('statusCode')
            .withField('message')
            .withField('code');
        
        GraphQLMutationNode delPaymentRequestsMutation = new GraphQLMutationNode('DeletePaymentRequests', deletePaymentRequestsNode);
        GraphQLRequest request = delPaymentRequestsMutation.buildRequest()
            .withHeader('Authorization', authToken.accessToken);
        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
        GraphQLResponse response = client.send(request);
        system.debug('Response in delete: ' + JSON.serialize(response));
        system.debug('Endpoint: ' + System.label.GraphQLURL); 
    }
    
    @AuraEnabled
    public static List<Quote> getQuotes(String recId){  // Class for fetching all quotes related to opportunity.
        List<Quote> quotes = [SELECT Id,Name,QuoteNumber,Latest_Quote__c,Opportunity.Name FROM Quote WHERE OpportunityId =:recId];
        return quotes;
    }   

    @AuraEnabled
    public static Quote getQuoteDetails(String quoteId){    // Class for fetching specific quotes.
        Quote quote = [SELECT Id,Name,Accountid,Site_Services_Amount_Incl_GST__c,Account.Name,OpportunityId,Latest_Quote__c,ShippingAddress,BillingAddress,QuoteNumber,Opportunity.Name,Opportunity.Amount,Opportunity.StageName,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingPostalCode,Account.ShippingCountry,Modular_Discount__c,Total_calculated_value__c FROM Quote WHERE Id =:quoteId];
        return quote;
    }

    @AuraEnabled
    public static List<Request_Payment__c> getPaymentRequest(String oppId){  // Class for fetching all quotes related to opportunity.
        List<Request_Payment__c> reqPay = [SELECT Id FROM Request_Payment__c WHERE Opportunity__c =:oppId];
        return reqPay;
    }
}