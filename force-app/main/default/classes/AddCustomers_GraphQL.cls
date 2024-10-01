global class AddCustomers_GraphQL {
    
    @InvocableMethod(callout=true)
    global static List<List<Lead>> addCustomers(List<List<Id>> listOfListOfIds) {
        System.debug('AddCustomers_GraphQL | addCustomers Call');
        System.debug('listOfListOfIds ==> ' + listOfListOfIds);
        List<List<Lead>> results = new List<List<Lead>>();
        Map<Id, String> responseMap = new Map<Id, String>();
        Map<Id, String> requestBodyMap = new Map<Id, String>();
        
        List<Id> listOfIds = new List<Id>();
        for(List<Id> ids : listOfListOfIds){
            listOfIds.addAll(ids);
        }
        List<String> fieldsList = new List<String>{'customerid', 'otp', 'generatedotptimestamp', 'firstname', 'customeremail', 'lastname', 'customerphone', 'salesforceid', 'pancardno', 'gstno', 'odoocontactid'};
            //'countrycode',
            GraphQLNode dataNode = new GraphQLNode('data')
            .withFields(fieldsList);
        System.debug('listOfIds ==> ' + listOfIds);
        Integer index = 0;
        for(Lead leadRecord : [SELECT Id , Is_Customer_Created__c, FirstName, LastName, Email, MobilePhone, city, country, street, PostalCode, state FROM Lead where id IN: listOfIds]){
            //,Country_Code__c
            //String customerVar = '{firstname:Test,lastname:graphql,customeremail:asdf@yopmail.com}';
            System.debug('leadRecord ==> ' + leadRecord);
            if(!leadRecord.Is_Customer_Created__c){
                
                results.add(new List<Lead>());
                
                Customers customerObj = new Customers();
                customerObj.firstname = leadRecord.FirstName;
                customerObj.lastname = leadRecord.LastName;
                customerObj.customeremail = leadRecord.Email;
                customerObj.customerphone = leadRecord.MobilePhone;
                //customerObj.countrycode = leadRecord.Country_Code__c;
                customerObj.addresses = new List<Address>();
                
                Address leadAddress = new Address();
                leadAddress.city = leadRecord.City;
                leadAddress.country = leadRecord.Country;
                leadAddress.street = leadRecord.Street;
                leadAddress.zip = leadRecord.PostalCode;
                leadAddress.state = leadRecord.State;
                leadAddress.addresstype = 1;
                
                customerObj.addresses.add(leadAddress);
                
                GraphQLNode addCustomers = new GraphQLNode('addCustomers')
                    .withArgument('customer', '$customer')
                    .withField('code')
                    .withField('message')
                    .withNode(dataNode);
                
                GraphQLMutationNode addCustomersMutation = new GraphQLMutationNode('addCustomersMutation', addCustomers)
                    .withVariable('customer', 'CustomerToBeAdded');
                GraphQLRequest request = addCustomersMutation.buildRequest()
                    .withVariable('customer', customerObj);
                GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
                GraphQLResponse response = client.send(request);
                System.debug('Response : ' + response); 
                System.debug('Request : ' + request);
                Map<String, Object> data = response.getData();
                System.debug('Response in GraphQL : ' + data);
                responseMap.put(leadRecord.Id, 'Response of GraphQL : ' + data);    
                requestBodyMap.put(leadRecord.Id, 'Request Body of GraphQL : ' + request);
                if(data != null){
                    System.debug('data not null'+data);
                    if (!(data.isEmpty())) {
                       System.debug('check ==> ' + String.isNotBlank(String.valueof(data.get('addCustomers'))));
                        if(data.containsKey('addCustomers') && String.isNotBlank(String.valueof(data.get('addCustomers')))){
                            Map<String, Object> data1 = (Map<String, object>) data.get('addCustomers');
                            String message = (String) data1.get('message');
                            System.debug('message ==> ' + message);
                            if(!(data1.isEmpty()) && data1.containsKey('data') && String.isNotBlank(String.valueof(data1.get('data')))){
                                Map<String, Object> data2 = (Map<String, object>) data1.get('data');
                                if(!(data2.isEmpty()) && data2.containsKey('customerid') && String.isNotBlank(String.valueof(data2.get('customerid')))){
                                    system.debug('in is customer created');
                                    leadRecord.Is_Customer_Created__c = true;
                                    results[index].add(leadRecord);
                                }
                            }else if(message != null){
                                if(message.containsIgnoreCase('Customer already Created in Database') ){
                                    leadRecord.Is_Customer_Created__c = true;
                                    results[index].add(leadRecord);    
                                }    
                            }
                        }
                    }
                }
                index++;
                
                System.debug('responseMap ==> ' + responseMap.size());
                if(responseMap.size() > 0){
                    insertResponseGraphQL(responseMap, requestBodyMap); 
                }
            }
            
        }
        return results;
    }     
    
    public static void insertResponseGraphQL(Map<Id, String> responseMap, Map<Id, String> requestBodyMap){
        System.debug('insertResponse | responseMap ==> ' + responseMap);
        System.debug('insertResponse | requestBodyMap ==> ' + requestBodyMap);
        System.debug('RecursiveTriggerHandler.isFirstTime' + RecursiveTriggerHandler.isFirstTime);
        if(RecursiveTriggerHandler.isFirstTime){
            RecursiveTriggerHandler.isFirstTime = false;
            List<Intergration_Request__c> irList = [SELECT Id, LeadId__c, Responce__c, Request_Body__c  FROM Intergration_Request__c WHERE LeadId__c IN: responseMap.keySet()];
            System.debug('irList ==> ' + irList);
            if(irList.size() > 0){
                return;  
            }else{
                for(String leadId: responseMap.keySet()){
                    Intergration_Request__c irObj = new Intergration_Request__c();
                    irObj.LeadId__c = leadId;
                    irObj.Responce__c = responseMap.get(leadId);
                    irObj.Request_Body__c = requestBodyMap.get(leadId);
                    irList.add(irObj); 
                }
            }
            System.debug('irList ==> ' + irList);   
            INSERT irList;    
        }
    }
    
    public class Address {
        String city;
        String country;
        String street;
        String zip;
        String state;
        Integer addresstype;
    }
    
    public class Customers {
        String firstname;
        String lastname;
        String customeremail;
        String customerphone;
        //String countrycode;
        List<Address> addresses;
    }
    
}