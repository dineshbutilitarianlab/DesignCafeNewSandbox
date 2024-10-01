public class updateaccounttodesignerdashboard{
    public class accountdatawrap{
        public string sfID{get;set;}
        public string customerName{get;set;}
        public string customerEmail{get;set;} 
        public string customerPhone{get;set;}
        public string shippingAddressStreet{get;set;}
        public string shippingAddressCity{get;set;}
        public string shippingAddressShippingState{get;set;}
        public string shippingAddressCountry{get;set;}
        public string shippingAddressZipOrPostalCode{get;set;}
        public string billingAddressStreet{get;set;}
        public string billingAddressCity{get;set;}
        public string billingAddressShippingState{get;set;}
        public string billingAddressCountry{get;set;}
        public string billingAddressZipOrPostalCode{get;set;}
    }
    @future(callout=true)
    @AuraEnabled
    public static void callServer(String id){
        Account acc = [select id,name,PersonEmail,PersonMobilePhone,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry from Account where id=: id limit 1];
        Opportunity opp = [select id,Customer_ID__c,CreatedDate FROM Opportunity where AccountId =:id ORDER BY CreatedDate DESC LIMIT 1];
        accountdatawrap accdata = new accountdatawrap();
        if(acc.Name !=null){
            accdata.customerName = acc.name; 
        }
        if(opp.Customer_ID__c !=null){
            accdata.sfID = opp.Customer_ID__c;
			}
        if(acc.PersonEmail !=null){
            accdata.customerEmail = acc.PersonEmail;
        }
        if(acc.PersonMobilePhone !=null){
            accdata.customerPhone = acc.PersonMobilePhone;
        }
        if(acc.ShippingStreet !=null){
            accdata.shippingAddressStreet = acc.ShippingStreet;
        }
        if(acc.ShippingCity !=null){
            accdata.shippingAddressCity = acc.ShippingCity;
        }
        if(acc.ShippingState !=null){
            accdata.shippingAddressShippingState = acc.ShippingState;
        }
        if(acc.ShippingCountry !=null){
            accdata.shippingAddressCountry = acc.ShippingCountry;
        }
        if(acc.ShippingPostalCode !=null){
            accdata.shippingAddressZipOrPostalCode = acc.ShippingPostalCode;
        }
        if(acc.BillingStreet !=null){
            accdata.billingAddressStreet = acc.BillingStreet;
        }
        if(acc.BillingCity !=null){
            accdata.billingAddressCity = acc.BillingCity;
        }
        if(acc.BillingState !=null){
            accdata.billingAddressShippingState = acc.BillingState;
        }
        if(acc.BillingCountry !=null){
            accdata.billingAddressCountry = acc.BillingCountry;
        }
        if(acc.BillingPostalCode !=null){
            accdata.billingAddressZipOrPostalCode = acc.BillingPostalCode;
        }
        String customLabelValue = Label.PostAccountToCD;
        system.debug('Json Serialize : '+JSON.serialize(accdata));
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customLabelValue);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(accdata);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        if(!test.isRunningTest())
        HttpResponse response = http.send(request);
    //    system.debug('get response :'+response);
    }
}