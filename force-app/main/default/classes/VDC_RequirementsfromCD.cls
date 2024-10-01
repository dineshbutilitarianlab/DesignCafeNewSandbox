@RestResource(urlMapping='/requirementsapi')
global without sharing class VDC_RequirementsfromCD {
    
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        Intergration_Request__c integrationObj = New Intergration_Request__c();
        try {
            LeadWrapper LeadWrapperObj = (LeadWrapper)JSON.deserialize(req.requestBody.toString(), LeadWrapper.class);
            integrationObj.Request_Body__c = req.requestBody.toString();
            List<lead> ld = [Select id,Home_Type__c,Floor_Area__c,Scope_Of_Work__c,Civil_Work__c,Site_Service_Needed_for__c,Interior_work_needed_for__c,
                             Requirement_Details__c,Property_Usage__c,Where_are_you_currently_located__c,When_would_you_like_to_have_the_home__c,
                             Which_language_are_you_most_comfortable__c,If_other_languages_please_specify__c,Who_will_be_staying_in_the_house__c,
                             How_many_kids_do_you_have__c,Gender_of_First_kid__c,Gender_of_Second_kid__c,Gender_of_Third_kid__c,Gender_of_Fourth_kid__c,
                             Age_of_First_kid__c,Age_of_Second_kid__c,Age_of_Third_kid__c,Age_of_Fourth_kid__c,Do_you_have_pets__c,Live__c,Others_for_Live__c,
                             Work__c,Eat__c,Play__c,Others_for_Play__c,APIMOBILE__c from Lead WHERE APIMOBILE__c =:LeadWrapperObj.mobile Limit 1];
            IF(ld.size() != 0){
                if(LeadWrapperObj.mobile!=null){
                    Lead LeadObj = new Lead();
                    LeadObj.id = LeadWrapperobj.leadid;
                    LeadObj.Home_Type__c = LeadWrapperobj.property_type;
                    LeadObj.Floor_Area__c =LeadWrapperobj.floor_area;                          
                    LeadObj.Scope_Of_Work__c = LeadWrapperobj.scope_of_work;
                    LeadObj.Civil_Work__c = LeadWrapperobj.site_services;
                    LeadObj.Site_Service_Needed_for__c = LeadWrapperobj.site_service_needed_for;
                    LeadObj.Interior_work_needed_for__c = LeadWrapperobj.interior_work_needed_for;
                    LeadObj.Requirement_Details__c = LeadWrapperobj.interior_details;
                    LeadObj.Property_Usage__c = LeadWrapperobj.property_usage;
                    LeadObj.Where_are_you_currently_located__c = LeadWrapperobj.where_are_you_currently_located;
                    LeadObj.When_would_you_like_to_have_the_home__c = LeadWrapperobj.when_would_you_like_to_have_the_home;
                    LeadObj.Which_language_are_you_most_comfortable__c = LeadWrapperobj.which_language_are_you_most_comfortable;
                    LeadObj.If_other_languages_please_specify__c = LeadWrapperobj.if_other_languages_please_specify;
                    LeadObj.Who_will_be_staying_in_the_house__c = LeadWrapperobj.who_will_be_staying_in_the_house;
                    LeadObj.How_many_kids_do_you_have__c  = LeadWrapperobj.how_many_kids_do_you_have;
                    LeadObj.Gender_of_First_kid__c = LeadWrapperobj.gender_of_first_kid;
                    LeadObj.Gender_of_Second_kid__c = LeadWrapperobj.gender_of_second_kid;                          
                    LeadObj.Gender_of_Third_kid__c = LeadWrapperobj.gender_of_third_kid;
                    LeadObj.Gender_of_Fourth_kid__c = LeadWrapperobj.gender_of_fourth_kid;
                    LeadObj.Age_of_First_kid__c = LeadWrapperobj.age_of_first_kid;
                    LeadObj.Age_of_Second_kid__c = LeadWrapperobj.age_of_second_kid;
                    LeadObj.Age_of_Third_kid__c = LeadWrapperobj.age_of_third_kid;
                    LeadObj.Age_of_Fourth_kid__c = LeadWrapperobj.age_of_fourth_kid;
                    LeadObj.Do_you_have_pets__c = LeadWrapperobj.do_you_have_pets;
                    LeadObj.Live__c = LeadWrapperobj.live;
                    LeadObj.Others_for_Live__c = LeadWrapperobj.others_for_live;
                    LeadObj.Work__c = LeadWrapperobj.work;
                    LeadObj.Eat__c = LeadWrapperobj.eat;
                    LeadObj.Play__c  = LeadWrapperobj.play;
                    LeadObj.Others_for_Play__c  = LeadWrapperobj.others_for_play;
                    update LeadObj;
                    response.message = 'Requirements Updated Successfully';
                    response.status  = 'Success';
                    response.recordId = LeadObj.id;
                }
                
                response.message                                = 'Requirements Updated Successfully';
                response.status                                 = 'Success';
                string Jsonbody                                 = Json.serialize(LeadWrapperObj);
                response.body                                   = Jsonbody;
                integrationObj.Responce__c                      = Json.serialize(response);
                integrationObj.Responce_Code__c                 = res.statusCode;
                insert integrationObj;    
            }ELSE{
                response.message = 'No Record Found';
                response.status  = 'Success';
            } 
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
        ApiCallLogger.method(system.UserInfo.getUserId(), '/requirementsapi', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String recordId;  
        string body;
    }
    public class LeadWrapper {
        public String leadid;
        public String mobile;
        public String property_type;
        public String floor_area;
        public String scope_of_work;
        public Boolean site_services;
        public String site_service_needed_for;
        public String interior_work_needed_for;
        public String interior_details;
        public String property_usage;
        public String where_are_you_currently_located;
        public String when_would_you_like_to_have_the_home;
        public String which_language_are_you_most_comfortable;
        public String if_other_languages_please_specify;
        public String who_will_be_staying_in_the_house;
        public String how_many_kids_do_you_have;
        public String gender_of_first_kid;
        public String gender_of_second_kid;
        public String gender_of_third_kid;
        public String gender_of_fourth_kid;
        public String age_of_first_kid;
        public String age_of_second_kid;
        public String age_of_third_kid;
        public String age_of_fourth_kid; 
        public String do_you_have_pets;
        public String live;
        public String others_for_live;
        public String work;
        public String eat;
        public String play;
        public String others_for_play;
    }  
}