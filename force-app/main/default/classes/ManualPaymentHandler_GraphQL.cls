public class ManualPaymentHandler_GraphQL {
    
    @AuraEnabled
    public static Boolean checkPaymentRequestCreated(String oppId) {
    	List<Request_Payment__c> reqPaymentList = [SELECT Id, Name, Opportunity__c FROM Request_Payment__c WHERE Opportunity__c =: oppId];   
        System.debug('reqPaymentList ==> ' + reqPaymentList);
        if(reqPaymentList.size() > 0){
            return true;
        }else{
            return false;
        }
    }
    
    @AuraEnabled
    public static List<ResponseToBeSentToAura> addPayment(String oppId) {
        Boolean deleteRecord = false;
        List<ResponseToBeSentToAura> responsesToBeSentToAuraList = new List<ResponseToBeSentToAura>();
        Map<String,Object> integrationResponseMap = new Map<String,Object>();
        List<Invoice_Payment__c> InvPayList = [Select Id, Name, RP_Recipt_ID__c, Received_amount__c, Mode_of_Receipt__c,
                                               Date_of_Payment__c, Request_Payment_Modular__c, Request_Payment_SiteService__c, 
                                               Opportunity_Name__r.Customer_ID__c, paymentID__c, Modular_value__c,
                                               Site_Service_value__c,Customer_Type__c,CUstomer_GST_Treatment__c,Billing_Street__c,
                                               Billing_City__c,Billing_State__c,Billing_Country__c,Billing_Zip__c,Shipping_Street__c,Shipping_City__c,Shipping_Country__c,
                                               Shipping_State__c,Shipping_Zip__c,Team_Name__c,EC_Name__c,Quote_Id__c From Invoice_Payment__c 
                                               where Opportunity_Name__r.Id =: oppId ORDER BY CreatedDate DESC LIMIT 1];
        ResponseToBeSentToAura errorResponseToBeSentToAura = new ResponseToBeSentToAura();
        ValidationOnPaymi.ResponseToBeSentToAura ValidationMessage = new ValidationOnPaymi.ResponseToBeSentToAura();
        ValidationMessage = ValidationOnPaymi.validationMethod(oppId);
        errorResponseToBeSentToAura.errorMessage = ValidationMessage.errorMessage;
        responsesToBeSentToAuraList.add(errorResponseToBeSentToAura);
        
        if (ValidationMessage.validationPass && InvPayList != null && !InvPayList.isEmpty()) {
            ResponseToBeSentToAura AuthenticationToBeSentToAura = new ResponseToBeSentToAura();
            ResponseToBeSentToAura ExceptionToBeSentToAura = new ResponseToBeSentToAura();
            try {
                
                AuthenticationToken_GraphQL.ResponseDataOfAuth GraphQLAuth = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
                GraphQLAuth = AuthenticationToken_GraphQL.authorization();
                system.debug('GraphQL Auth response::' +GraphQLAuth);
                ManualPaymentResponse respData;
                system.debug('Auth respData::' +respData);
                if (Test.isRunningTest() || (GraphQLAuth != null && GraphQLAuth.accessToken != null)) {
                    List<Object> payReqList = new List<Object>();
                    if (InvPayList[0].Request_Payment_Modular__c != null) {
                        payReqList.add(InvPayList[0].Request_Payment_Modular__c);
                    }
                    if (InvPayList[0].Request_Payment_SiteService__c != null) {
                        payReqList.add(InvPayList[0].Request_Payment_SiteService__c);
                    }
                    
                    GraphQLNode AddPaymentReceiptsNode = new GraphQLNode('AddPaymentReceipts')
                        .withArgument('transactionId',InvPayList[0].RP_Recipt_ID__c)
                        .withArgument('receivedAmount',HelperClass.getInteger(InvPayList[0].Received_amount__c))
                        //.withArgument('projectID',InvPayList[0].Opportunity_Name__r.Customer_ID__c)
                        .withArgument('paymentRequests',payReqList)
                        .withArgument('paymentReceivedDate',String.ValueOf(InvPayList[0].Date_of_Payment__c))
                        .withArgument('paymentMode',InvPayList[0].Mode_of_Receipt__c)
                        .withArgument('siteServicesAmount',HelperClass.getInteger(InvPayList[0].Site_Service_value__c))
                        //.withArgument('clientID',InvPayList[0].Opportunity_Name__r.Customer_ID__c)
                        .withArgument('modularAmount',HelperClass.getInteger(InvPayList[0].Modular_value__c))
                        .withArgument('customerType',InvPayList[0].Customer_Type__c)
                        .withArgument('customerGstTreatment',InvPayList[0].CUstomer_GST_Treatment__c)
                        .withArgument('billingStreet',InvPayList[0].Billing_Street__c)
                        .withArgument('billingCity',InvPayList[0].Billing_City__c)
                        .withArgument('billingCountry',InvPayList[0].Billing_Country__c)
                        .withArgument('billingState',InvPayList[0].Billing_State__c)
                        .withArgument('billingZip',InvPayList[0].Billing_Zip__c)
                        .withArgument('shippingStreet',InvPayList[0].Shipping_Street__c)
                        .withArgument('shippingCity',InvPayList[0].Shipping_City__c)
                        .withArgument('shippingCountry',InvPayList[0].Shipping_Country__c)
                        .withArgument('shippingState',InvPayList[0].Shipping_State__c)
                        .withArgument('shippingZip',InvPayList[0].Shipping_Zip__c)
                        .withArgument('teamName',InvPayList[0].Team_Name__c)
                        .withArgument('ecName',InvPayList[0].EC_Name__c)
                        .withArgument('quoteId',InvPayList[0].Quote_Id__c)
                        .withField('statusCode')
                        .withField('code')
                        .withField('data')
                        .withField('message');
                    system.debug('PaymentId::'+ InvPayList[0].paymentID__c);
                    system.debug('Formula Field -->' + InvPayList[0].Customer_Type__c);
                    if(InvPayList[0].paymentID__c == null) {
                        GraphQLMutationNode AddPaymentReceiptsMutation = new GraphQLMutationNode('AddPaymentReceipts', AddPaymentReceiptsNode);
                        GraphQLRequest request = AddPaymentReceiptsMutation.buildRequest()
                            .withHeader('Authorization', GraphQLAuth.accessToken);
                        GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
                        GraphQLResponse response = client.send(request);
                        List<GraphQLResponseError> check= new List<GraphQLResponseError>();
                        check =response.getErrors();
                        system.debug('Request: ' + request);
                        system.debug('Response: ' + response);
                        
                        ResponseToBeSentToAura PaymentRespToBeSentToAura = new ResponseToBeSentToAura();
                        Map<String,String> paymentRespMap = new Map<String,String>();
                        if (response.hasData()) {
                            Object dataAsMap = response.getDataNode('AddPaymentReceipts');
                            System.debug('dataAsMap: '+dataAsMap);
                            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(dataAsMap));
                            integrationResponseMap = responseMap.clone();
                            //System.debug('responseMap: '+responseMap);
                             //system.debug('responseMap code'+responseMap.get('code'));
                                    system.debug('responseMap message'+responseMap.get('message'));
                            if (responseMap != null && !responseMap.isEmpty() ) {
                                if (responseMap.get('data') != null) {  // Successful
                                    //system.debug('responseMap data'+responseMap.get('data'));
                                    paymentRespMap = (Map<String,String>)JSON.deserialize(JSON.serialize(responseMap.get('data')), Map<String,String>.class);
                                   system.debug('responseMap paymentRespMap'+paymentRespMap);
                                    paymentRespMap.put('code', String.valueOf(responseMap.get('code')));
                                    paymentRespMap.put('message', (String)responseMap.get('message'));
                                }
                                else {  // ERROR
                                    if (responseMap.get('message') != null) {
                                        paymentRespMap.put('message', (String)responseMap.get('message'));
                                      //  integrationResponseMap.put('message', (String)responseMap.get('message'));
                                    }
                                    if (responseMap.get('code') != null) {
                                        paymentRespMap.put('code', String.valueOf(responseMap.get('code')));
                                      //  integrationResponseMap.put('code', (String)responseMap.get('code'));
                                    }
                                    deleteRecord = true;
                                }
                                //System.debug('paymentRespMap:: '+paymentRespMap);
                            }
                            else {
                                errorResponseToBeSentToAura.errorMessage = 'API issue';
                                deleteRecord = true;
                            }
                            //System.debug('paymentRespMap::message '+paymentRespMap.get('message'));
                            //System.debug('paymentRespMap::code '+paymentRespMap.get('code'));
                             //System.debug('paymentRespMap::payid '+paymentRespMap.get('paymentID'));
                            
                            if(!paymentRespMap.isEmpty() && paymentRespMap.containsKey('paymentID') && paymentRespMap ?.get('code') =='200'){
                                PaymentRespToBeSentToAura.APIresptoAura = paymentRespMap.get('message');
                                PaymentRespToBeSentToAura.APIcodetoAura = paymentRespMap.get('code');
                                InvPayList[0].paymentID__c = paymentRespMap ?.get('paymentID');
                                update InvPayList;
                            }
                            else {
                                PaymentRespToBeSentToAura.APIresptoAura = paymentRespMap.get('message');
                                PaymentRespToBeSentToAura.APIcodetoAura = paymentRespMap.get('code');
                                deleteRecord = true;
                            }
                        }
                        else if (response.hasErrors()) {
                            deleteRecord = true;
                            if (!paymentRespMap.isEmpty()) {
                                PaymentRespToBeSentToAura.APIresptoAura = paymentRespMap.get('message');
                                PaymentRespToBeSentToAura.APIcodetoAura = '400';
                            }
                        }
                        responsesToBeSentToAuraList.add(PaymentRespToBeSentToAura);
                    }
                    else {
                        errorResponseToBeSentToAura.errorMessage = 'PaymentId is already generated';
                        deleteRecord = true;
                    }
                    responsesToBeSentToAuraList.add(errorResponseToBeSentToAura);
                }
                else {
                    system.debug('Authentication: Customer Authentication: Null Response! ');
                    deleteRecord = true;
                    AuthenticationToBeSentToAura.AuthenticationMsg = 'Authentication Failed(API issue)';
                    AuthenticationToBeSentToAura.AuthenticationCode = '400';
                    responsesToBeSentToAuraList.add(AuthenticationToBeSentToAura);
                }
            }
            catch (Exception ex) {
                ExceptionToBeSentToAura.AuthenticationMsg = 'API Error: ' + ex.getMessage();
                ExceptionToBeSentToAura.AuthenticationCode = '400';    
                responsesToBeSentToAuraList.add(ExceptionToBeSentToAura);
            }
        }
        else if (!Test.isRunningTest()) {
            deleteRecord = true;

        }
        if (deleteRecord == true) {
            system.debug('integrationResponseMap'+integrationResponseMap);
            delete InvPayList[0];
            if(integrationResponseMap != NULL && !integrationResponseMap.isEmpty() && integrationResponseMap.containsKey('message') || integrationResponseMap.containsKey('statusCode')){
                Intergration_Request__c integrationObj = New Intergration_Request__c();
                integrationObj.Type__c = 'Payment Receipt';
                integrationObj.Request_Body__c = (String)integrationResponseMap.get('message');
                integrationObj.Responce_Code__c = (Integer)integrationResponseMap.get('statusCode');
                integrationObj.Opportunity__c = oppId;
                insert integrationObj;
            }
        }
        return responsesToBeSentToAuraList;
    }
    @future(callout = true)
    public static void UpdatePaymentReceipts(String oppId, String oldId){
        System.debug('UpdatePaymentReceipts call ');
        System.debug('oppId ==> ' + oppId);
        System.debug('oldId ==> ' + oldId);
        
        AuthenticationToken_GraphQL.ResponseDataOfAuth GraphQLAuth = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
        GraphQLAuth = AuthenticationToken_GraphQL.authorization();
        system.debug('RecId::'+oppId);
        
        if (Test.isRunningTest() || (GraphQLAuth != null && GraphQLAuth.accessToken != null)) {
            List<Invoice_Payment__c> InvPayList = [Select Id, Name, RP_Recipt_ID__c, Received_amount__c, Mode_of_Receipt__c,
                                                   Date_of_Payment__c, Request_Payment_Modular__c, Request_Payment_SiteService__c, 
                                                   Opportunity_Name__r.Customer_ID__c, paymentID__c, Modular_value__c,
                                                   Site_Service_value__c, Payment_confirmation_status__c, Customer_Type__c,CUstomer_GST_Treatment__c,
                                                   Billing_Street__c,Billing_City__c,Billing_State__c,Billing_Country__c,Billing_Zip__c,Shipping_Street__c,
                                                   Shipping_City__c,Shipping_Country__c,Shipping_State__c,Shipping_Zip__c,Team_Name__c,EC_Name__c, Quote_Id__c
                                                   From Invoice_Payment__c 
                                                   where Opportunity_Name__r.Id =: oppId ORDER BY CreatedDate DESC];
            for (Invoice_Payment__c InvPay : InvPayList) {
                List<Object> payReqList = new List<Object>();
                payReqList.add(InvPay.Request_Payment_Modular__c);
                payReqList.add(InvPay.Request_Payment_SiteService__c);
                System.debug('listofIP::' + InvPayList);
                GraphQLNode updPaymentReceiptsNode = new GraphQLNode('UpdatePaymentReceipts')
                    .withArgument('transactionId',InvPay.RP_Recipt_ID__c)
                    .withArgument('receivedAmount',HelperClass.getInteger(InvPay.Received_amount__c))
                    .withArgument('projectID',InvPay.Opportunity_Name__r.Customer_ID__c)
                    .withArgument('paymentRequests',payReqList)
                    .withArgument('paymentReceivedDate',String.ValueOf(InvPay.Date_of_Payment__c))
                    .withArgument('paymentMode',InvPay.Mode_of_Receipt__c)
                    .withArgument('siteServicesAmount',HelperClass.getInteger(InvPay.Site_Service_value__c))
                    .withArgument('clientID',InvPay.Opportunity_Name__r.Customer_ID__c)
                    .withArgument('modularAmount',HelperClass.getInteger(InvPay.Modular_value__c))
                    //.withArgument('closureType',InvPay.Opportunity_Name__r.Closure_Type__C)
                    //.withArgument('customerType',InvPay.Customer_Type__c)
                        //.withArgument('customerGstTreatment',InvPay.CUstomer_GST_Treatment__c)
                        //.withArgument('billingStreet',InvPay.Billing_Street__c)
                        //.withArgument('billingCity',InvPay.Billing_City__c)
                        //.withArgument('billingCountry',InvPay.Billing_Country__c)
                        //.withArgument('billingState',InvPay.Billing_State__c)
                        //.withArgument('billingZip',InvPay.Billing_Zip__c)
                        //.withArgument('shippingStreet',InvPay.Shipping_Street__c)
                        //.withArgument('shippingCity',InvPay.Shipping_City__c)
                        //.withArgument('shippingCountry',InvPay.Shipping_Country__c)
                        //.withArgument('shippingState',InvPay.Shipping_State__c)
                        //.withArgument('shippingZip',InvPay.Shipping_Zip__c)
                        //.withArgument('teamName',InvPay.Team_Name__c)
                        //.withArgument('ecName',InvPay.EC_Name__c)
                    .withArgument('appName','Salesforce')
                    //.withArgument('quoteId',InvPay.Quote_Id__c)
                    .withArgument('paymentId',InvPay.paymentID__c)
                    .withArgument('status',InvPay.Payment_confirmation_status__c)
                    //.withArgument('odoo_payment_id',10048)
                    .withField('statusCode')
                    .withField('code')
                    .withField('message');
                system.debug('oldId::'+oldId);
                if(InvPay.paymentID__c == oldId) {
                    system.debug('I am in 139');
                    GraphQLMutationNode updPaymentReceiptsMutation = new GraphQLMutationNode('UpdatePaymentReceipts', updPaymentReceiptsNode);
                    GraphQLRequest request = updPaymentReceiptsMutation.buildRequest()
                        .withHeader('Authorization', GraphQLAuth.accessToken);
                    GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
                    GraphQLResponse response = client.send(request);
                    system.debug('Request: ' + request);
                    system.debug('Response: ' + response);
                    system.debug('Endpoint: ' + System.label.GraphQLURL);
                }
            }
        }
    }
    public class ResponseToBeSentToAura{
        @AuraEnabled
        public integer status;
        @AuraEnabled
        public String APIresptoAura;
        @AuraEnabled
        public String APIcodetoAura;
        @AuraEnabled
        public string errorMessage;
        @AuraEnabled
        public string invoiceType;
        @AuraEnabled
        public string accessToken;
        @AuraEnabled
        public string AuthenticationMsg;
        @AuraEnabled
        public string AuthenticationCode;
        
    }
    
    Public class ManualPaymentResponse{
        @AuraEnabled
        public String code;
        @AuraEnabled
        public string message;
        @AuraEnabled
        public responsedata data;
        @AuraEnabled
        public string accessToken;
    }
    public class responsedata{
        @AuraEnabled
        public string paymentID;
    }
    
}