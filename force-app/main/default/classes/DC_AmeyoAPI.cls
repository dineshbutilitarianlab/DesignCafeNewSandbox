@RestResource(urlMapping='/ameyoapi')
global without sharing class DC_AmeyoAPI {
    
    @HttpPost
    global static PostResponseWrapper doPost1() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        Intergration_Request__c integrationObj = New Intergration_Request__c();
        try {
            leadWrapper leadWrapperObj = (leadWrapper)JSON.deserialize(req.requestBody.toString(), leadWrapper.class);
            integrationObj.Request_Body__c = req.requestBody.toString();
            List<lead> ld = [Select id,LastName,Email,FirstName,Lead_Owner_Name__c,Lead_owner_Email__c,Alternate_Contact_Number__c,MobilePhone,UserID__c,APIMOBILE__c from Lead WHERE (APIMOBILE__c =:leadWrapperObj.Mobile or  Alternate_Contact_Number__c =:leadWrapperObj.Mobile ) Limit 1];
            if(ld.size() != 0){
                leadWrapperObj.UserID = ld[0].UserID__c;
                leadWrapperObj.Lead_Owner_Name = ld[0].Lead_Owner_Name__c;
                leadWrapperObj.Alternate_Contact_Number = ld[0].Alternate_Contact_Number__c;
                leadWrapperObj.Lead_owner_Email = ld[0].Lead_owner_Email__c;
                response.recordId          =  ld[0].id;
            }
            response.message                                = 'OwnerId Sent Successfully';
            response.status                                 = 'Success';
            string Jsonbody                                 = Json.serialize(leadWrapperObj);
            response.body                                   = Jsonbody;
            integrationObj.Responce__c                      = Json.serialize(response);
            integrationObj.Responce_Code__c                 = res.statusCode;
            insert integrationObj;    
            
        } 
        catch(Exception exc) {
        }
        //Calling ApiCallLogger class
        ApiCallLogger.method(system.UserInfo.getUserId(), '/ameyoapi', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String recordId;  
        string body;
    }
    public class leadWrapper {
        public String Mobile;
        public String UserID;
        public String Lead_Owner_Name;
        Public String Lead_owner_Email;
        Public String Alternate_Contact_Number;
    }  
}