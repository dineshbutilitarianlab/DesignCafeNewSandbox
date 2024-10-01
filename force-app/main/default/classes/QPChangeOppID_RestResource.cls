@RestResource(urlMapping='/QPChangeOppID')
global without sharing class QPChangeOppID_RestResource {

    // Response class to structure the response
    public class ApiResponse {
        public String message;
        public String customerId;
    }

    @HttpPost 
    global static String doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        ApiResponse response = new ApiResponse();

        try {
            String requestBody = req.requestBody.toString();
            Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            String opportunityId = (String) jsonData.get('opportunityId');
            System.debug('Id opportunityId: ' + opportunityId);

            List<Opportunity> opportunityList = [SELECT Id, Is_Qarpentri_Project__c FROM Opportunity WHERE Id = :opportunityId];
            if (opportunityList.size() > 0) {
                System.debug('opportunityList ==> ' + opportunityList);
                Opportunity opportunityRecord = opportunityList[0]; 

                if (!opportunityRecord.Is_Qarpentri_Project__c) {
                    opportunityRecord.Is_Qarpentri_Project__c = true;
                }
                update opportunityRecord;

                // Re-query to get the updated Customer_ID__c value
                opportunityRecord = [SELECT Customer_ID__c FROM Opportunity WHERE Id = :opportunityRecord.Id];
                response.message = 'CustomerId Updated Successfully!';
                response.customerId = opportunityRecord.Customer_ID__c;
            } else {
                response.message = 'Opportunity not found';
                response.customerId = null;
            }
        } catch (Exception e) {
            response.message = 'Exception: ' + e.getMessage();
            response.customerId = null;
        }

        return JSON.serialize(response);
    }
}