public class LatestQuoteTriggerController {

    @Future(callout=true)
    public static void LatestQuoteUpdateByApex(List<Id> quoteId) {
        System.debug('Id===>'+quoteId);
        List<Quote> quote = [SELECT Id, OpportunityId, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Latest_Quote__c, Opportunity.First_Modular_Milestone_Percentage__c, Opportunity.First_SiteService_Milestone_Pct__c FROM Quote WHERE Id =:quoteId[0]];
        Map<id,Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Id, Name, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Customer_ID__c, AccountId, StageName,
                                                Email__c, Quote_Id__c,Designer_Team_Name__c,EC_Name__c,UserId__c, Modular_Milestone_Type__c 
                                                FROM Opportunity
                                                WHERE Id = :quote[0].OpportunityId]);
        if(quote[0].Latest_Quote__c==true){
            System.debug('quote===>'+quote[0].OpportunityId);
            List<Request_Payment__c> paymReqList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                                                    LastActivityDate, LastViewedDate, LastReferencedDate, Category__c, Client_ID__c, Description__c, Opportunity__c, Payment_Received_Date__c, PymentID__c, 
                                                    Request_Amount__c, Request_Date__c, Request_Id__c, Status__c, FirstName_del__c, LastName_del__c, Customer_Phone_del__c, Email_del__c, Salesforce_Id_del__c, 
                                                    PAN_Card_No_del__c, GST_No_del__c, Customer_Type_del__c, Oppo_Id_del__c, Quote_Id_del__c, Billing_Street_del__c, Billing_City_del__c, Billing_Country_del__c, 
                                                    Billing_State_del__c, Billing_zip_del__c, Shipping_Street_del__c, Shipping_City_del__c, Shipping_Country_del__c, Shipping_State_del__c, Shipping_Zip_del__c, 
                                                    Team_Name_del__c, EC_Name_del__c, Billing_City__c, Billing_Country__c, Billing_State__c, Billing_Street__c, Billing_zip__c, Customer_Phone__c, Customer_Type__c, 
                                                    EC_Name__c, Email__c, First_Name__c, GST_No__c, Last_Name__c, Oppo_Id__c, Opportunity_Owner__c, PAN_Card_No__c, Quote_Id__c, Salesforce_Id__c, Shipping_City__c, 
                                                    Shipping_Country__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Team_Name__c, Account_ID__c, User_Id__c FROM Request_Payment__c 
                                                    WHERE Opportunity__c=:quote[0].OpportunityId];
            System.debug('paymReqList===>'+paymReqList);
            if(paymReqList.size()>0){
                Id recId = paymReqList[0].Id;
                System.debug('recId:::'+recId);
                    
                List<Request_Payment__c> reqPayList=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                                                    LastActivityDate, LastViewedDate, LastReferencedDate, Category__c, Client_ID__c, Description__c, Opportunity__c, Payment_Received_Date__c, PymentID__c, 
                                                    Request_Amount__c, Request_Date__c, Request_Id__c, Status__c, FirstName_del__c, LastName_del__c, Customer_Phone_del__c, Email_del__c, Salesforce_Id_del__c, 
                                                    PAN_Card_No_del__c, GST_No_del__c, Customer_Type_del__c, Oppo_Id_del__c, Quote_Id_del__c, Billing_Street_del__c, Billing_City_del__c, Billing_Country_del__c, 
                                                    Billing_State_del__c, Billing_zip_del__c, Shipping_Street_del__c, Shipping_City_del__c, Shipping_Country_del__c, Shipping_State_del__c, Shipping_Zip_del__c, 
                                                    Team_Name_del__c,EC_Name_del__c, Billing_City__c, Billing_Country__c, Billing_State__c, Billing_Street__c, Billing_zip__c, Customer_Phone__c, Customer_Type__c, 
                                                    EC_Name__c, Email__c, First_Name__c, GST_No__c, Last_Name__c, Oppo_Id__c, Opportunity_Owner__c, PAN_Card_No__c, Quote_Id__c, Salesforce_Id__c, Shipping_City__c, 
                                                    Shipping_Country__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Team_Name__c, Account_ID__c, User_Id__c FROM Request_Payment__c 
                                                    WHERE Id =: recId LIMIT 1];
                AuthenticationToken_GraphQL.ResponseDataOfAuth authToken = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
                authToken = AuthenticationToken_GraphQL.authorization();
                System.debug('reqpaylist===>'+reqPayList);
                List<Request_Payment__c> reqPayList2  = new List<Request_Payment__c>();
                // Double modAmount = ((quote[0].Modular_Amount_Dis_Incl_GST__c)/100) * quote[0].Opportunity.First_Modular_Milestone_Percentage__c;
                // Double siteAmount = ((quote[0].Site_Services_Amount_Dis_Incl_GST__c)/100) * quote[0].Opportunity.First_SiteService_Milestone_Pct__c;

                for(Request_Payment__c payReq : paymReqList){
                    Opportunity oppRec = opportunityMap.get(quote[0].OpportunityId);
                    payReq.Quote_Id__c = quoteId[0];
                    payReq.Updated_Request__c = true;

                    // if(payReq.Category__c == 'Modular'){
                    //     payReq.Request_Amount__c = modAmount;
                    // }
                    // else if(payReq.Category__c == 'Site Services'){
                    //     payReq.Request_Amount__c = siteAmount;
                    // }


                    reqPayList2.add(payReq);

                    //String authToken = AuthenticationToken_GraphQL.authorization();
                    GraphQLNode updatePaymentRequestsNode = new GraphQLNode('UpdatePaymentRequests')
                        .withArgument('requestID',payReq.Request_Id__c)
                        .withArgument('requestDate',String.ValueOf(payReq.Request_Date__c))
                        .withArgument('category', getCategory(oppRec))
                        .withArgument('requestAmount', getRequestAmount(oppRec))
                        .withArgument('description',getDescription(oppRec))
                        .withArgument('clientID',payReq.Client_ID__c)
                        .withArgument('status',payReq.Status__c)
                        .withArgument('appName','Salesforce')
                        .withArgument('quoteId',payReq.Quote_Id__c)
                        .withArgument('billingStreet',payReq.Billing_Street__c)
                        .withArgument('billingCity',payReq.Billing_City__c)
                        .withArgument('billingCountry',payReq.Billing_Country__c)
                        .withArgument('billingState',payReq.Billing_State__c)
                        .withArgument('billingZip',payReq.Billing_zip__c)
                        .withArgument('shippingStreet',payReq.Shipping_Street__c)
                        .withArgument('shippingCity',payReq.Shipping_City__c)
                        .withArgument('shippingCountry',payReq.Shipping_Country__c)
                        .withArgument('shippingState',payReq.Shipping_State__c)
                        .withArgument('shippingZip',payReq.Shipping_Zip__c)
                        .withField('statusCode')
                        .withField('message')
                        .withField('code');


                    
                    GraphQLMutationNode updPaymentRequestsMutation = new GraphQLMutationNode('UpdatePaymentRequests', updatePaymentRequestsNode);
                    GraphQLRequest request = updPaymentRequestsMutation.buildRequest()
                        .withHeader('Authorization', authToken.accessToken);
                    GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
                    GraphQLResponse response = client.send(request);
                    // upsert reqPayList;
                    system.debug('Request: ' + request);
                    system.debug('Response in update: ' + JSON.serialize(response));
                    system.debug('Endpoint: ' + System.label.GraphQLURL);
                }
                if(!Test.isRunningTest()){
                    System.debug('Request Payment List => '+reqPayList2);
                   // update reqPayList2;
                }
            }   
        }
    }

    
   @InvocableMethod(callout=true)
    public static void LatestQuoteUpdate(List<Id> quoteId) {
        System.debug('Id===>'+quoteId);
        List<Quote> quote = [SELECT Id, OpportunityId, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Latest_Quote__c, Opportunity.First_Modular_Milestone_Percentage__c, Opportunity.First_SiteService_Milestone_Pct__c FROM Quote WHERE Id =:quoteId[0]];
        Map<id,Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Id, Name, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Customer_ID__c, AccountId, StageName,
                                                Email__c, Quote_Id__c,Designer_Team_Name__c,EC_Name__c,UserId__c, Modular_Milestone_Type__c 
                                                FROM Opportunity
                                                WHERE Id = :quote[0].OpportunityId]);
        if(quote[0].Latest_Quote__c==true){
            System.debug('quote===>'+quote[0].OpportunityId);
            List<Request_Payment__c> paymReqList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                                                    LastActivityDate, LastViewedDate, LastReferencedDate, Category__c, Client_ID__c, Description__c, Opportunity__c, Payment_Received_Date__c, PymentID__c, 
                                                    Request_Amount__c, Request_Date__c, Request_Id__c, Status__c, FirstName_del__c, LastName_del__c, Customer_Phone_del__c, Email_del__c, Salesforce_Id_del__c, 
                                                    PAN_Card_No_del__c, GST_No_del__c, Customer_Type_del__c, Oppo_Id_del__c, Quote_Id_del__c, Billing_Street_del__c, Billing_City_del__c, Billing_Country_del__c, 
                                                    Billing_State_del__c, Billing_zip_del__c, Shipping_Street_del__c, Shipping_City_del__c, Shipping_Country_del__c, Shipping_State_del__c, Shipping_Zip_del__c, 
                                                    Team_Name_del__c, EC_Name_del__c, Billing_City__c, Billing_Country__c, Billing_State__c, Billing_Street__c, Billing_zip__c, Customer_Phone__c, Customer_Type__c, 
                                                    EC_Name__c, Email__c, First_Name__c, GST_No__c, Last_Name__c, Oppo_Id__c, Opportunity_Owner__c, PAN_Card_No__c, Quote_Id__c, Salesforce_Id__c, Shipping_City__c, 
                                                    Shipping_Country__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Team_Name__c, Account_ID__c, User_Id__c FROM Request_Payment__c 
                                                    WHERE Opportunity__c=:quote[0].OpportunityId AND Status__c!='Paid'];
            System.debug('paymReqList===>'+paymReqList);
            if(paymReqList.size()>0){
                Id recId = paymReqList[0].Id;
                System.debug('recId:::'+recId);
                    
                List<Request_Payment__c> reqPayList=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                                                    LastActivityDate, LastViewedDate, LastReferencedDate, Category__c, Client_ID__c, Description__c, Opportunity__c, Payment_Received_Date__c, PymentID__c, 
                                                    Request_Amount__c, Request_Date__c, Request_Id__c, Status__c, FirstName_del__c, LastName_del__c, Customer_Phone_del__c, Email_del__c, Salesforce_Id_del__c, 
                                                    PAN_Card_No_del__c, GST_No_del__c, Customer_Type_del__c, Oppo_Id_del__c, Quote_Id_del__c, Billing_Street_del__c, Billing_City_del__c, Billing_Country_del__c, 
                                                    Billing_State_del__c, Billing_zip_del__c, Shipping_Street_del__c, Shipping_City_del__c, Shipping_Country_del__c, Shipping_State_del__c, Shipping_Zip_del__c, 
                                                    Team_Name_del__c,EC_Name_del__c, Billing_City__c, Billing_Country__c, Billing_State__c, Billing_Street__c, Billing_zip__c, Customer_Phone__c, Customer_Type__c, 
                                                    EC_Name__c, Email__c, First_Name__c, GST_No__c, Last_Name__c, Oppo_Id__c, Opportunity_Owner__c, PAN_Card_No__c, Quote_Id__c, Salesforce_Id__c, Shipping_City__c, 
                                                    Shipping_Country__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Team_Name__c, Account_ID__c, User_Id__c FROM Request_Payment__c 
                                                    WHERE Id =: recId LIMIT 1];
                AuthenticationToken_GraphQL.ResponseDataOfAuth authToken = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
                authToken = AuthenticationToken_GraphQL.authorization();
                System.debug('reqpaylist===>'+reqPayList);
                List<Request_Payment__c> reqPayList2  = new List<Request_Payment__c>();
                // Double modAmount = ((quote[0].Modular_Amount_Dis_Incl_GST__c)/100) * quote[0].Opportunity.First_Modular_Milestone_Percentage__c;
                // Double siteAmount = ((quote[0].Site_Services_Amount_Dis_Incl_GST__c)/100) * quote[0].Opportunity.First_SiteService_Milestone_Pct__c;

                for(Request_Payment__c payReq : paymReqList){
                    Opportunity oppRec = opportunityMap.get(quote[0].OpportunityId);
                    payReq.Quote_Id__c = quoteId[0];
                    payReq.Updated_Request__c = true;

                    // if(payReq.Category__c == 'Modular'){
                    //     payReq.Request_Amount__c = modAmount;
                    // }
                    // else if(payReq.Category__c == 'Site Services'){
                    //     payReq.Request_Amount__c = siteAmount;
                    // }


                    reqPayList2.add(payReq);

                    //String authToken = AuthenticationToken_GraphQL.authorization();
                    GraphQLNode updatePaymentRequestsNode = new GraphQLNode('UpdatePaymentRequests')
                        .withArgument('requestID',payReq.Request_Id__c)
                        .withArgument('requestDate',String.ValueOf(payReq.Request_Date__c))
                        .withArgument('category', getCategory(oppRec))
                        .withArgument('requestAmount', getRequestAmount(oppRec))
                        .withArgument('description',getDescription(oppRec))
                        .withArgument('clientID',payReq.Client_ID__c)
                        .withArgument('status',payReq.Status__c)
                        .withArgument('appName','Salesforce')
                        .withArgument('quoteId',payReq.Quote_Id__c)
                        .withArgument('billingStreet',payReq.Billing_Street__c)
                        .withArgument('billingCity',payReq.Billing_City__c)
                        .withArgument('billingCountry',payReq.Billing_Country__c)
                        .withArgument('billingState',payReq.Billing_State__c)
                        .withArgument('billingZip',payReq.Billing_zip__c)
                        .withArgument('shippingStreet',payReq.Shipping_Street__c)
                        .withArgument('shippingCity',payReq.Shipping_City__c)
                        .withArgument('shippingCountry',payReq.Shipping_Country__c)
                        .withArgument('shippingState',payReq.Shipping_State__c)
                        .withArgument('shippingZip',payReq.Shipping_Zip__c)
                        .withField('statusCode')
                        .withField('message')
                        .withField('code');


                    
                    GraphQLMutationNode updPaymentRequestsMutation = new GraphQLMutationNode('UpdatePaymentRequests', updatePaymentRequestsNode);
                    GraphQLRequest request = updPaymentRequestsMutation.buildRequest()
                        .withHeader('Authorization', authToken.accessToken);
                    GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
                    GraphQLResponse response = client.send(request);
                    // upsert reqPayList;
                    system.debug('Request: ' + request);
                    system.debug('Response in update: ' + JSON.serialize(response));
                    system.debug('Endpoint: ' + System.label.GraphQLURL);
                }
                if(!Test.isRunningTest()){
                    System.debug('Request Payment List => '+reqPayList2);
                   // update reqPayList2;
                }
            }   
        }
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