public with sharing class CreateCustomer {
   public static CreateCustomerDataWrap createCustomerOnOdooBody(String recId){
        
        Opportunity opp = [Select id,Account.Name, AccountId, Account.BillingAddress, Account.BillingPostalCode,
                           Account.BillingCountry, Account.BillingCity, Account.BillingStreet, Account.BillingState,
                           Account.PersonEmail, Account.PersonMobilePhone, Account.GST_No__c, Account.PAN__c,
                           Account.Customer_Type__c From Opportunity where id =: recId];
        
        CreateCustomerDataWrap cusWrp = new CreateCustomerDataWrap();
        cusWrp.customerName=opp.Account.Name;
        cusWrp.customerEmail=opp.Account.PersonEmail;
        cusWrp.customerPhone=opp.Account.PersonMobilePhone;
        cusWrp.billingAddressCountry=opp.Account.BillingCountry;
        cusWrp.billingAddressShippingState=opp.Account.BillingState;
        cusWrp.billingAddressCity=opp.Account.BillingCity;
        cusWrp.billingAddressStreet=opp.Account.BillingStreet;
        cusWrp.billingAddressZipOrPostalCode=opp.Account.BillingPostalCode; 
        cusWrp.SF_Account_ID =opp.AccountId;
        cusWrp.GST=opp.Account.GST_No__c;
        cusWrp.PAN=opp.Account.PAN__c;
        
        System.debug('CreateCustomer: opp.Account.Customer_Type__c:' + opp.Account.Customer_Type__c);
        if (opp.Account.Customer_Type__c == 'B2C'){
            cusWrp.l10n_in_gst_treatment = 'unregistered';
        }
        else if (opp.Account.Customer_Type__c == 'B2B'){  
            cusWrp.l10n_in_gst_treatment = 'regular';
        }
        else {	// Set Default to unregistered.
            cusWrp.l10n_in_gst_treatment = 'unregistered';
        }
        return cusWrp;
    }

    public static UpdateCustomerDataWrap updateCustomerOnOdooBody(String recId){
        
        Opportunity opp = [Select id,Account.Name, AccountId, Account.BillingAddress, Account.BillingPostalCode,
                           Account.BillingCountry, Account.BillingCity, Account.BillingStreet, Account.BillingState,
                           Account.PersonEmail, Account.PersonMobilePhone, Account.GST_No__c, Account.PAN__c,
                           Account.Customer_Type__c From Opportunity where id =: recId];
        
        UpdateCustomerDataWrap cusWrp = new UpdateCustomerDataWrap();
        cusWrp.customerBillingAddress = new CustomerBillingAddress();
        cusWrp.customerName = opp.Account.Name;
        cusWrp.customerEmail = opp.Account.PersonEmail;
        cusWrp.customerPhone = opp.Account.PersonMobilePhone;
        cusWrp.customerBillingAddress.country = opp.Account.BillingCountry;
        cusWrp.customerBillingAddress.state = opp.Account.BillingState;
        cusWrp.customerBillingAddress.city = opp.Account.BillingCity;
        cusWrp.customerBillingAddress.street = opp.Account.BillingStreet;
        cusWrp.customerBillingAddress.zipOrPostalCode = opp.Account.BillingPostalCode; 
        cusWrp.GST = opp.Account.GST_No__c;
        cusWrp.PAN = opp.Account.PAN__c;
        
        System.debug('CreateCustomer: opp.Account.Customer_Type__c:' + opp.Account.Customer_Type__c);
        if (opp.Account.Customer_Type__c == 'B2C'){
            cusWrp.l10n_in_gst_treatment = 'unregistered';
        }
        else if (opp.Account.Customer_Type__c == 'B2B'){  
            cusWrp.l10n_in_gst_treatment = 'regular';
        }
        else {	// Set Default to unregistered.
            cusWrp.l10n_in_gst_treatment = 'unregistered';
        }
        return cusWrp;
    }
    
    
    
    public static CreateCustomerResponse addCustomer(String recId){
        
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        CreateCustomerResponse createCustResp;
        
        if(MicroAuthResp.accessToken != null){
            CreateCustomerDataWrap createCustBody = new CreateCustomerDataWrap();
            createCustBody = createCustomerOnOdooBody(recId);        
            //Caling create customer API
            HttpRequest request = new HttpRequest();
            String endpoint = System.label.CreateCustomerAPIURL;
            system.debug('endPoint:'+ endpoint);
            request.setTimeout(90000);
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            String jsonBody = JSON.serialize(createCustBody);
            System.debug('AddCustomer: SendAddCustomerReq: ---Insert--jsonBody----'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            System.debug('AddCustomer: SendAddCustomerReq: ---Insert--request----'+request);
            HttpResponse response = http.send(request);
            System.debug('AddCustomer: SendAddCustomerReq: ---Insert--response----'+response.getBody());
            createCustResp = (CreateCustomerResponse)JSON.deserialize(response.getBody(), CreateCustomerResponse.class);
            System.debug('createCustResp:: '+createCustResp);
            
            if((createCustResp != null) && (createCustResp.data != null) && (createCustResp.data.requestId != null)) {
                System.debug('createCustResp.data.requestId$$$:: '+createCustResp.data.requestId);
            }
            else {
                system.Debug('AddCustomer: SendAddCustomer: Null Response!');
                createCustResp.code='400';
                
            }  
        }
        
        if (MicroAuthResp.accessToken == null){
            system.debug('Authentication: Customer Authentication: Null Response! ');
            createCustResp.code = MicroAuthResp.code;
        }
        return createCustResp;
    }
    @future(callout=true)
    //If the Customer is Update on Odoo 
    public static void updateCustomerOnOddo(String recId){
        
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        CreateCustomerResponse createCustResp;
        
        if(MicroAuthResp.accessToken != null){
            UpdateCustomerDataWrap createCustBody = new UpdateCustomerDataWrap();
            createCustBody = updateCustomerOnOdooBody(recId);        
            //Caling create customer API
            HttpRequest request = new HttpRequest();
            String endpoint = System.label.UpdateCustomerAPIURL;
            system.debug('endPoint:'+ endpoint);
            request.setTimeout(90000);
            request.setEndpoint(endpoint);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            String jsonBody = JSON.serialize(createCustBody);
            System.debug('AddCustomer: SendUpdateCustomerReq: ---Insert--jsonBody----'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            System.debug('UpdateCustomer: SendUpdateCustomerReq: ---Insert--request----'+request);
            HttpResponse response = http.send(request);
            System.debug('UpdateCustomer: SendUpdateCustomerReq: ---Insert--response----'+response.getBody());
            createCustResp = (CreateCustomerResponse)JSON.deserialize(response.getBody(), CreateCustomerResponse.class);
            System.debug('createCustResp:: '+createCustResp);
            
            if((createCustResp != null) && (createCustResp.data != null) && (createCustResp.data.requestId != null)) {
                System.debug('respData.data.requestId$$$:: '+createCustResp.data.requestId);     
            }
            else {
                system.Debug('AddCustomer: SendAddCustomer: Null Response!');
                createCustResp.code='400';             
            }  
        }
        
        if (MicroAuthResp.accessToken == null){
            system.debug('Authentication: Customer Authentication: Null Response! ');
            createCustResp.code = MicroAuthResp.code;
        }
        //return createCustResp;
    }
    
    public class CreateCustomerDataWrap{
        @AuraEnabled
        public String customerName{get;set;} 	//VinithaTest19
        @AuraEnabled
        public String customerEmail{get;set;} 	//vinithatest19@gamil.com
        @AuraEnabled
        public String customerPhone{get;set;} 	//7690865467
        @AuraEnabled
        public String billingAddressCountry{get;set;} 	//India
        @AuraEnabled
        public String billingAddressShippingState{get;set;} 	//Tamil Nadu
        @AuraEnabled
        public String billingAddressCity{get;set;} 	//Hosur BA
        @AuraEnabled
        public String billingAddressStreet{get;set;} //#H1, SDA Colony, Mathigiri Road BA
        @AuraEnabled
        public String billingAddressZipOrPostalCode{get;set;} 	//635110
        @AuraEnabled
        public String SF_Account_ID{get;set;} 	//DC-5500
        @AuraEnabled
        public String l10n_in_gst_treatment{get;set;}	//Consumer
        @AuraEnabled
        public String GST{get;set;} 	//sample vat
        @AuraEnabled
        public String PAN{get;set;} 	//9856789087
    }

    public class UpdateCustomerDataWrap {
        @AuraEnabled
        public String customerName{get;set;} 	//VinithaTest19
        @AuraEnabled
        public String customerEmail{get;set;} 	//vinithatest19@gamil.com
        @AuraEnabled
        public String customerPhone{get;set;} 	//7690865467
        @AuraEnabled
        public CustomerBillingAddress customerBillingAddress{get;set;}
        @AuraEnabled
        public String l10n_in_gst_treatment{get;set;}	//Consumer
        @AuraEnabled
        public String GST{get;set;} 	//sample vat
        @AuraEnabled
        public String PAN{get;set;} 	//9856789087
    }
    public class CustomerBillingAddress {
        @AuraEnabled
        public String country{get;set;} 	//India
        @AuraEnabled
        public String state{get;set;} 	//Tamil Nadu
        @AuraEnabled
        public String city{get;set;} 	//Hosur BA
        @AuraEnabled
        public String street{get;set;} //#H1, SDA Colony, Mathigiri Road BA
        @AuraEnabled
        public String zipOrPostalCode{get;set;} 	//635110
    }

    Public class CustAuthwrap{
        @AuraEnabled
        Public string clientId {get;set;}   
    }
    
    Public class CreateCustomerResponse{
        @AuraEnabled
        public string statusCode;
        @AuraEnabled
        public string code;
        @AuraEnabled
        public string message;
        @AuraEnabled
        public responsedata data;
        @AuraEnabled
        public string accessToken;
    }
    public class responsedata{
        @AuraEnabled
        public string requestId;
    }
}