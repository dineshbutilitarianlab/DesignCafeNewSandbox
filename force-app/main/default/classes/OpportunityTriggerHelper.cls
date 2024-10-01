public class OpportunityTriggerHelper {
    public static Map<String, String> getPickListValuesIntoMap(){
        Map<String, String> pickListValuesMap= new Map<String, String>();
         Schema.DescribeFieldResult fieldResult = Opportunity.Offer_and_discounts__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
            if (pickListVal.isActive()) {
                pickListValuesMap.put(pickListVal.getLabel().toLowerCase(), pickListVal.getLabel());
                //pickListValuesList.add(pickListVal.getLabel().toLowerCase());
            } 
         }     
         return pickListValuesMap;
     }

    public static String getFilterPicklist(Opportunity newOpportunity) {
        String updatedOffers;
        Map<String,String> activeOffersMap = getPickListValuesIntoMap();
        Set<String> activeOffers = activeOffersMap.keySet();
        if (String.isNotBlank(newOpportunity.Remarks_For_Marketing__c)) {
            for (String variable : newOpportunity.Remarks_For_Marketing__c.split(',')) {
                if ( checkSubstring(variable.trim().toLowerCase(), activeOffers)){
                    if (!activeOffers.contains(variable.trim().toLowerCase())){
                        String remark;
                        for (String offerAndDiscount : activeOffers) {
                            if (variable.trim().toLowerCase().contains(offerAndDiscount)) {
                                offerAndDiscount = activeOffersMap.get(offerAndDiscount);
                                remark = variable.replace(offerAndDiscount, '').trim();
                                break;
                            }
                        }
                        if (String.isNotBlank(remark)) {
                            updatedOffers = String.isBlank(updatedOffers) ? remark: updatedOffers + ', ' +remark;
                        }
                    }
                }else {
                    updatedOffers = String.isBlank(updatedOffers) ? variable: updatedOffers + ', ' +variable;
                }
            }
        }        
        if (String.isNotBlank(newOpportunity.Offer_and_discounts__c)) {
            for (String variable : newOpportunity.Offer_and_discounts__c.split(';')) {
                updatedOffers = String.isBlank(updatedOffers) ? variable: updatedOffers + ', ' +variable;
            }
        }
        return updatedOffers;
    }

    public static Boolean checkSubstring(String remark, Set<String> activeOffers) {
        Boolean result = false;
        for (String offerAndDiscount : activeOffers) {
            if (remark.contains(offerAndDiscount)) {
                result = true;
                break;
            }
        }
        return result;
    }
    public static void updateOffers(List<Opportunity> newOpportunity, Map<Id,Opportunity> oldMap) {
        
        for (Opportunity opportunityRecord : newOpportunity) {
            if (oldMap == null ) {
                opportunityRecord.Remarks_For_Marketing__c = getFilterPicklist(opportunityRecord);// before Insert
            }else {
                Opportunity oldOpportunity = oldMap.get(opportunityRecord.Id);
                if (oldOpportunity.Offer_and_discounts__c != opportunityRecord.Offer_and_discounts__c) {
                    opportunityRecord.Remarks_For_Marketing__c = getFilterPicklist(opportunityRecord); // before Update
                }
            }

        }
    }

}