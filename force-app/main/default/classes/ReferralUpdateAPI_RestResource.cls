@RestResource(urlMapping='/ReferralUpdateAPI')
global without sharing class ReferralUpdateAPI_RestResource {

    // Response class to structure the response
    public class ApiResponse {
        public String message;
        public String refereeName;
        public String refereeEmailId;
        public String refereeCode;
        public String phoneNumber;
        
    }

    @HttpPost 
    global static String referralDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        ApiResponse response = new ApiResponse();

        try {
            String requestBody = req.requestBody.toString();
            Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            String referralMobileNumber = (String) jsonData.get('referralMobileNumber');
            String referralCode = (String) jsonData.get('referralCode');
            System.debug('referralMobileNumber: ' + referralMobileNumber);
            System.debug('referralCode: ' + referralCode);
            List<Account> AccountList = [SELECT Id, Name, PersonMobilePhone, PersonEmail, Referee_Code_DC__c FROM Account WHERE PersonMobilePhone =: referralMobileNumber
                                        OR Referee_Code_DC__c =: referralCode ];
            if(AccountList != null && AccountList.size() > 0){
                response.message = 'Referral Updated Successfully!';
                response.refereeName = AccountList[0].Name;  
                response.refereeEmailId = AccountList[0].PersonEmail; 
                response.refereeCode = AccountList[0].Referee_Code_DC__c; 
                response.phoneNumber = AccountList[0].PersonMobilePhone; 
            }
            else{
                response.message = 'Refferal Details not found';
                response.refereeName = null;  
                response.refereeEmailId = null; 
                response.refereeCode = null; 
            }
        }catch (Exception e) {
            response.message = 'Exception: ' + e.getMessage();
            response.refereeName = null;  
            response.refereeEmailId = null; 
            response.refereeCode = null; 
        }
        return JSON.serialize(response);
    }
}