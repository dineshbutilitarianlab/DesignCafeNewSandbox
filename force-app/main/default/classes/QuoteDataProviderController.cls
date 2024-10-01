public class QuoteDataProviderController {
	@AuraEnabled
    public static Quote fetchData(Id recordId) {
        // Fetch the Quote record based on the provided Id
        // Example implementation, replace with your actual logic
        return [SELECT Id, BillingName, Modular_Fixed_Discount_New__c, Property_Type__c, Name, 
                       Site_Services_Amount__c, Modular_Or_Site_Service_Changes__c, Quote_Link__c
                FROM Quote
                WHERE Id = :recordId];
    }
    @AuraEnabled
    public static void updateQuote(String quoteJSON) {
        try {
            System.debug('quoteJSON '+quoteJSON);
            Map<String, Object> quoteMap = (Map<String, Object>) JSON.deserializeUntyped(quoteJSON);
            System.debug('quoteMap '+quoteMap);
            if (quoteMap != null) {
                Quote quote = new Quote(Id = (String) quoteMap.get('Id'));

                if (quoteMap.containsKey('BillingName') && quoteMap.get('BillingName') != null) {
                    quote.BillingName = (String) quoteMap.get('BillingName');
                }

                if (quoteMap.containsKey('Modular_Fixed_Discount_New__c') && quoteMap.get('Modular_Fixed_Discount_New__c') != null) {
                    quote.Modular_Fixed_Discount_New__c = (Decimal)quoteMap.get('Modular_Fixed_Discount_New__c');
                }

                if (quoteMap.containsKey('Property_Type__c') && quoteMap.get('Property_Type__c') != null) {
                    quote.Property_Type__c = (String) quoteMap.get('Property_Type__c');
                }

                if (quoteMap.containsKey('Name') && quoteMap.get('Name') != null) {
                    quote.Name = (String) quoteMap.get('Name');
                }

                if (quoteMap.containsKey('Site_Services_Amount__c') && quoteMap.get('Site_Services_Amount__c') != null) {
                    quote.Site_Services_Amount__c = (Decimal) quoteMap.get('Site_Services_Amount__c');
                }

                if (quoteMap.containsKey('Modular_Or_Site_Service_Changes__c') && quoteMap.get('Modular_Or_Site_Service_Changes__c') != null) {
                    quote.Modular_Or_Site_Service_Changes__c = (String) quoteMap.get('Modular_Or_Site_Service_Changes__c');
                }

                if (quoteMap.containsKey('QuoteLink') && quoteMap.get('QuoteLink') != null) {
                    quote.Quote_Link__c = (String) quoteMap.get('QuoteLink');
                }
                system.debug('quote '+quote);
                update quote;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error updating quote: ' + e.getMessage());
        }
    }
}