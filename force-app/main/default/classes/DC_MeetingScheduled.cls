@RestResource(urlMapping='/meetingscheduled')
global without sharing class DC_MeetingScheduled {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        Intergration_Request__c integrationObj = New Intergration_Request__c();
        try {
            LeadWrapper LeadWrapperObj = (LeadWrapper)JSON.deserialize(req.requestBody.toString(), LeadWrapper.class);
            integrationObj.Request_Body__c = req.requestBody.toString();
            List<lead> ld = [Select id,MS_Date_Time__c,MobilePhone,Willingness_For_Meeting__c,APIMOBILE__c from Lead WHERE APIMOBILE__c =:LeadWrapperObj.Mobile Limit 1];
            IF(ld.size() != 0){
                lead Leadins = new lead();
               Leadins.id                               = ld[0].Id;
                Leadins.MobilePhone                      = LeadWrapperObj.Mobile;
                Leadins.Willingness_For_Meeting__c       = LeadWrapperObj.MS_Date_Time;
                update Leadins; 
                response.message                     = 'Update Successfully';
                response.status                      = 'Success';
                response.recordId                    =  ld[0].id;
            }
            ELSE{
                Lead LdObj  = New Lead();
                LdObj.MobilePhone                    = LeadWrapperObj.Mobile;
                LdObj.Status                         = 'Assigned';
                LdObj.DC_Lead_Status__c              = 'Undialed';
                LdObj.Call_Stage__c                  = 'Undialed';
                LdObj.Willingness_For_Meeting__c     = LeadWrapperobj.MS_Date_Time;
                insert LdObj;
               // Database.SaveResult svobj = Database.Insert(LdObj);
               // res.StatusCode                       = 201;
               // response.status                      = 'Success';
              //  response.recordId                    = LdObj.id;   
               // response.message                     = 'Inserted Successfully'; 
            }
        }
        catch(Exception exc) {
            res.StatusCode                           = 500;
            response.status                          = 'Error';
            response.message                         = 'Your request failed with the following error: '+ exc.getMessage();
            integrationObj.Responce__c               = Json.serialize(response);
            integrationObj.Responce_Code__c          = res.statusCode;
            insert integrationObj;
        }
        if(response.message.contains('duplicate') && res.StatusCode==500){
           // response.message = 'You\'re creating a duplicate lead. We recommend you use an existing one instead';
        }
     //Api Call Logger  
     ApiCallLogger.method(system.UserInfo.getUserId(), '/meetingscheduled', req.requestBody.toString(), response.message, 'in');
        return response;
    }   
    global class PostResponseWrapper {
        String status;
        String message;
        String recordId;  
    }
    public class LeadWrapper {
        public String Mobile;
        public datetime MS_Date_Time;
    }  
}