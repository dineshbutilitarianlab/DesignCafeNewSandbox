@RestResource(urlMapping='/guestUserRecordBulkAPI')
global class LSQ_GuestUser_RestResource {

    @HttpPost 
    global static List<Lead> doPost() {
        try {
            List<Lead> leadList = [SELECT Id, GuestUserUpdated__c from lead where GuestUserUpdated__c = true];
            if(leadList.size() > 0) {
                return leadList;
            } 
            
        } catch(Exception e){
            system.debug('Exception in LSQ_GuestUser_RestResource: ' + e.getMessage());
        }
        return null;
    } 
}