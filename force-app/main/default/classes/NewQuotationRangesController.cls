public with sharing class NewQuotationRangesController {
    @AuraEnabled(cacheable=true)
    public static String saveQuoteData(List<Map<String, Object>> quoteData) {
        try {
            List<Quote> quotesToUpdate = new List<Quote>();
            for (Map<String, Object> data : quoteData) {
                Quote quote = new Quote();
                quote.Id = (String)data.get('recordId'); // Assuming you're passing recordId from LWC
                quote.put((String)data.get('field'), data.get('newValue'));
                quotesToUpdate.add(quote);
            }
            update quotesToUpdate;
            
            return 'Success'; // Return success message
        } catch (Exception e) {
            return 'Error: ' + e.getMessage(); // Return error message
        }
    }

}