@RestResource(urlMapping='/supportapi')
global without sharing class DC_SupportApiClass {
    
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        Intergration_Request__c integrationObj = New Intergration_Request__c();
        try {
            LeadWrapper LeadWrapperObj = (LeadWrapper)JSON.deserialize(req.requestBody.toString(), LeadWrapper.class);
            integrationObj.Request_Body__c = req.requestBody.toString();
            List<lead> ld = [Select id,LastName,Email,FirstName,APIMOBILE__c,Region__c,convertedAccountId,convertedOpportunityId,isconverted,Phone,Country_Code__c,
                             Civil_Work__c,Meeting_Type__c,Meeting_Venue__c,MS_Date_Time__c,Property_Possession_Status__c,Property_Possession_Date__c,Property_Type_For_Interior__c,
                             Scope_Of_Work__c,Approx_Budget__c,Requirement_Details__c,Channel__c,LeadSource,DC_Campaign_Source__c,Messaging_Source__c,Source_Journey__c,Status,DC_Lead_Status__c,
                             YMUrl__c,Page_URL__c,Home_Type__c,Source__c,Lead_Owner_Mobile__c from Lead WHERE APIMOBILE__c =:LeadWrapperObj.Mobile Limit 1];
            IF(ld.size() != 0){
                if(ld[0].IsConverted!= true){
                    LeadWrapperObj.First_Name      =  ld[0].FirstName;
                    LeadWrapperObj.Last_Name       =  ld[0].LastName;
                    LeadWrapperObj.Email           =  ld[0].Email;
                    LeadWrapperObj.Region          =  ld[0].Region__c;
                    LeadWrapperObj.Country_Code    =  ld[0].Country_Code__c;
                    //LeadWrapperObj.Whatsapp_OptIN  =  ld[0].Whatsapp_Opt_IN__c;
                    LeadWrapperObj.Civil_Work 	   = ld[0].Civil_Work__c;
                    LeadWrapperObj.Meeting_Type    = ld[0].Meeting_Type__c;
                    LeadWrapperObj.Meeting_Venue   = ld[0].Meeting_Venue__c;
                    LeadWrapperObj.MS_Date_Time    = ld[0].MS_Date_Time__c;
                    LeadWrapperObj.Property_Possession_Status = ld[0].Property_Possession_Status__c;
                    LeadWrapperObj.Property_Possession_Date = ld[0].Property_Possession_Date__c;
                    LeadWrapperObj.Property_Type_for_Interior = ld[0].Home_Type__c;
                    LeadWrapperObj.Scope_Of_Work   = ld[0].Scope_Of_Work__c;
                    LeadWrapperObj.Approx_Budget   = ld[0].Approx_Budget__c;
                    LeadWrapperObj.Requirement_Details = ld[0].Requirement_Details__c;
                    LeadWrapperObj.Channel_Type    = ld[0].Channel__c;
                    LeadWrapperObj.Lead_Source     = ld[0].LeadSource;
                    LeadWrapperObj.Campaign_Source1 = ld[0].DC_Campaign_Source__c;
                    LeadWrapperObj.Messaging_Source = ld[0].Messaging_Source__c;
                    LeadWrapperObj.Source_Journey  = ld[0].Source_Journey__c;
                    LeadWrapperObj.YM_Url          = ld[0].YMUrl__c;
                    LeadWrapperObj.Page_URL1       = ld[0].Page_URL__c;
                    LeadWrapperObj.Lead_Type       = ld[0].Source__c;
                    LeadWrapperObj.Lead_Stage	   = ld[0].Status;
                    LeadWrapperObj.Lead_Status		= ld[0].DC_Lead_Status__c;
                    LeadWrapperObj.IsLead_Converted = False;
                    response.recordId              =  ld[0].id;
                    LeadWrapperObj.LeadOwnerMobile = ld[0].Lead_Owner_Mobile__c;
                }
                else{
                    List<account> ac = [Select id,LastName,FirstName,PersonEmail,Region__c from Account WHERE id=:ld[0].convertedAccountId Limit 1];
                    IF(ac.size() !=0){
                        LeadWrapperObj.First_Name  =  ac[0].FirstName;
                        LeadWrapperObj.Last_Name   =  ac[0].LastName;
                        LeadWrapperObj.Email       =  ac[0].PersonEmail;
                        LeadWrapperObj.Region      =  ac[0].Region__c;
                        LeadWrapperObj.Country_Code    =  ac[0].Country_Code__c;
                        LeadWrapperObj.IsLead_Converted = True;
                        /*LeadWrapperObj.Whatsapp_OptIN  =  ac[0].Whatsapp_Opt_IN__c;
LeadWrapperObj.Civil_Work = ac[0].Civil_Work__c;
LeadWrapperObj.Meeting_Type = ac[0].Meeting_Type__c;
LeadWrapperObj.Meeting_Venue = ac[0].Meeting_Venue__c;
LeadWrapperObj.MS_Date_Time = ac[0].MS_Date_Time__c;
LeadWrapperObj.Property_Possession_Status = ac[0].Property_Possession_Status__c;
LeadWrapperObj.Property_Possession_Date = ac[0].Property_Possession_Date__c;
LeadWrapperObj.Property_Type_for_Interior = ac[0].Property_Type_For_Interior__c;
LeadWrapperObj.Scope_Of_Work = ac[0].Scope_Of_Work__c;
LeadWrapperObj.Approx_Budget = ac[0].Approx_Budget__c;
LeadWrapperObj.Requirement_Details = ac[0].Requirement_Details__c;
LeadWrapperObj.Channel_Type = ac[0].Channel__c;
LeadWrapperObj.Lead_Source = ac[0].LeadSource;
LeadWrapperObj.Campaign_Source1 = ac[0].DC_Campaign_Source__c;
LeadWrapperObj.Messaging_Source = ac[0].Messaging_Source__c;
LeadWrapperObj.Source_Journey = ac[0].Source_Journey__c;
LeadWrapperObj.YM_Url = ac[0].YMUrl__c;
LeadWrapperObj.Page_URL1 = ac[0].Page_URL__c;*/
                        response.recordId          =  ac[0].id;
                    }     
                }
            } 
            response.message                                = 'Sent Successfully';
            response.status                                 = 'Success';
            string Jsonbody                                 = Json.serialize(LeadWrapperObj);
            response.body                                   = Jsonbody;
            integrationObj.Responce__c                      = Json.serialize(response);
            integrationObj.Responce_Code__c                 = res.statusCode;
            insert integrationObj;    
            
        }
        catch(Exception exc) {
            res.StatusCode                                  = 500;
            response.status                                 = 'Error';
            response.message                                = 'Your request failed with the following error: '+ exc.getMessage();
            integrationObj.Responce__c                      = Json.serialize(response);
            integrationObj.Responce_Code__c                 = res.statusCode;
            insert integrationObj;
        }
        //Calling ApiCallLogger class
        ApiCallLogger.method(system.UserInfo.getUserId(), '/supportapi', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String recordId;  
        string body;
    }
    public class LeadWrapper {
        public String Mobile;
        public String Email;
        public String First_Name;
        public String Last_Name;
        public String Region;
        public string Country_Code;
        //public string Whatsapp_OptIN;
        public boolean Civil_Work;
        public string Meeting_Type;
        public string Meeting_Venue;
        public Datetime MS_Date_Time;
        public string Property_Possession_Status;
        public Datetime Property_Possession_Date;
        public string Property_Type_for_Interior;
        public string Scope_Of_Work;
        public string Approx_Budget;
        public string Requirement_Details;
        public string Channel_Type;
        public string Lead_Source;
        public string Campaign_Source1;
        public string Messaging_Source;
        public string Source_Journey;
        public string YM_Url;
        public string Page_URL1;
        public string Lead_Type;
        public string Lead_Stage;
        public string Lead_Status;
        Public Boolean IsLead_Converted;
        public string LeadOwnerMobile;
    }  
}