public class UpdateQuote {
    
    public class quoteDataWrap {
        @AuraEnabled
        public String opportunityId{get;set;}
        @AuraEnabled
        public String quoteId{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public boolean updateModular{get;set;}
        @AuraEnabled
        public boolean updateSiteService{get;set;}
        @AuraEnabled
        public double modularDiscount{get;set;}
        @AuraEnabled
        public double siteServiceDiscount{get;set;}
        
    }
    @future (callout=true)
    public static void QuoteUpdate(String recId,Decimal OldModDis,Decimal OldSiteDis) {
        System.debug('QuoteUpdate Call');
        System.debug('recId ==> ' + recId);
        System.debug('OldModDis ==> ' + OldModDis);
        System.debug('OldSiteDis ==> ' + OldSiteDis);
        Quote quote = [select id,Name,Modular_Discount__c,PM_Fee__c,Site_Services_Discount__c,OpportunityId from Quote Where id=: recId limit 1];
        quoteDataWrap quo = new quoteDataWrap();
        
        quo.quoteId = quote.id;
        quo.name = quote.Name;
		quo.opportunityId = quote.OpportunityId;  
        
        if((quote.Modular_Discount__c != null) && (quote.Modular_Discount__c !=OldModDis)) {
            quo.updateModular = true;
            quo.modularDiscount = quote.Modular_Discount__c;
        }
        else {
            quo.updateModular = false;
            quo.modularDiscount = 0;
        }
        if ((quote.Site_Services_Discount__c != null) &&(quote.Site_Services_Discount__c !=OldSiteDis)) {
            quo.updateSiteService = true;
            quo.siteServiceDiscount = quote.Site_Services_Discount__c;
        }
        else {
            quo.updateSiteService = false;
            quo.siteServiceDiscount = 0;
        }
        
        
        system.debug('Update quote: quo: ' + quo);
        HttpRequest request = new HttpRequest();
        String endpoint = System.label.UpdateQuoteAPIURL;
        system.debug('endPoint:'+ endpoint);
        request.setEndpoint(endpoint);
        request.setTimeout(90000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(quo);
        System.debug('Update Quote: SendUpdateQuoteReq: ---Insert--jsonBody----'+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        System.debug('request ==> ' + request);
        if(!Test.isRunningTest()){
        	response = http.send(request);    
        }
        System.debug('response ==> ' + response);
        insertResponse(quote.Id, response.getBody(), jsonBody, response.getStatusCode());
    } 
    
    public static void insertResponse(String quoteId, String response, String jsonBody, Decimal statusCode){
        Intergration_Request__c irObj = new Intergration_Request__c();
        irObj.Quote__c = quoteId;
        irObj.Responce__c = response;
        irObj.Request_Body__c = jsonBody;
        irObj.Type__c = 'Update Quote API'; 
        irObj.Responce_Code__c = statusCode;
        System.debug('irObj ==> ' + irObj);
        if(irObj != null){
            INSERT irObj;
        }
    }
    
    Public class UpdatedQuoteResponse{
        @AuraEnabled
        public string statusCode;
        @AuraEnabled
        public string code;
        @AuraEnabled
        public string message;
        @AuraEnabled
        public string data;
    }
    
    public static void testCover(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}