public class ValidationOnPaymi {
    public class ResponseToBeSentToAura{
        @AuraEnabled
        public string errorMessage;
        @AuraEnabled
        public string invoiceType;
        @AuraEnabled
        public Boolean validationPass;
    }
    
    public static ResponseToBeSentToAura validationMethod(String recId) {
        Opportunity opp = [Select Id, Name, Account.BillingCountry, Account.BillingState, Account.BillingCity,Account.BillingStreet, Account.BillingPostalCode,
                           Account.ShippingCountry, Account.ShippingState, Account.ShippingCity,Account.ShippingStreet, Account.ShippingPostalCode,
                           Account.PAN__c, Account.GST_No__c, Account.Customer_type__c, Modular_Amount_Dis_Incl_GST__c, Modular_Milestone_Type__c, Site_Services_Amount_Dis_Incl_GST__c From Opportunity where Id =: recId LIMIT 1];
        Pattern MyPattern = Pattern.compile('^(\\S+\\s+)+.*');
        
        
        ResponseToBeSentToAura errorResponseToBeSentToAura = new ResponseToBeSentToAura();
        errorResponseToBeSentToAura.errorMessage = '';
        errorResponseToBeSentToAura.invoiceType = 'Validation';
        errorResponseToBeSentToAura.validationPass = true;
        if (opp.Account.BillingCountry == null || opp.Account.BillingState == null || opp.Account.BillingCity == null || opp.Account.BillingStreet == null || opp.Account.BillingPostalCode == null) {
            errorResponseToBeSentToAura.errorMessage += 'Please fill the Billing address details on Account. ';
            errorResponseToBeSentToAura.validationPass = false;
        }
       
         if (opp.Account.ShippingCountry == null || opp.Account.ShippingState == null || opp.Account.ShippingCity == null || opp.Account.ShippingStreet == null || opp.Account.ShippingPostalCode == null) {
            errorResponseToBeSentToAura.errorMessage += 'Please fill the Shipping address details on Account. ';
            errorResponseToBeSentToAura.validationPass = false;
        }
        if (opp.Account.PAN__c == null) {
            errorResponseToBeSentToAura.errorMessage += 'Please fill the PAN details on Account. ';
            errorResponseToBeSentToAura.validationPass = false;
        }
        if ((opp.Account.Customer_type__c == 'B2B') && (opp.Account.GST_No__c == null)) {
            errorResponseToBeSentToAura.errorMessage += 'Please fill the GST details on Account. ';
            errorResponseToBeSentToAura.validationPass = false;
        }
        if (opp.Account.Customer_type__c == null) {
            errorResponseToBeSentToAura.errorMessage += 'Please fill the CustomerType details on Account. ';
            errorResponseToBeSentToAura.validationPass = false;
        }
        if (opp.Modular_Amount_Dis_Incl_GST__c == 0 || opp.Modular_Amount_Dis_Incl_GST__c == null)  {
            errorResponseToBeSentToAura.errorMessage += 'Modular Amount should not be Zero Or Null on opportunity. ';
            errorResponseToBeSentToAura.validationPass = false;
        }
        if (opp.Account.ShippingStreet != null) {
            Matcher ShippingStreetMatcher = MyPattern.matcher(opp.Account.ShippingStreet);
            if ((((opp.Account.ShippingStreet).length()) < 10) || (!(ShippingStreetMatcher.matches()))) {
                errorResponseToBeSentToAura.errorMessage += 'Invalid Shipping street. Should be more than two words and at least 10 chars on opportunity. ';
                errorResponseToBeSentToAura.validationPass = false;
            }
        }
        if (opp.Account.BillingStreet != null) {
            Matcher BillingStreetMatcher = MyPattern.matcher(opp.Account.BillingStreet);
            if ((((opp.Account.BillingStreet).length()) < 10) || (!(BillingStreetMatcher.matches()))) {
                errorResponseToBeSentToAura.errorMessage += 'Invalid Billing street. Should be more than two words and at least 10 chars on opportunity. ';
                errorResponseToBeSentToAura.validationPass = false;
            }
        }
        if (opp.Modular_Milestone_Type__c == null) {
            errorResponseToBeSentToAura.errorMessage += 'Please fill the Modular Milestone Type on opportunity.';
            errorResponseToBeSentToAura.validationPass = false;
        }
        
        return errorResponseToBeSentToAura;
    }
    
}