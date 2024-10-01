@RestResource(urlMapping='/designeruser')
global without sharing class DesignerUserCreation {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap allDetails = (DetailsWrap)JSON.deserialize(req.requestBody.toString(),DetailsWrap.class);
        try{
            List<Design_User__c> desuser = [SELECT id,Name,Designer_Dashboard_ID__c from Design_User__c WHERE Designer_Dashboard_ID__c =:allDetails.designer_dashboard_ID Limit 1];
            if(desuser.size() !=0){
                Design_User__c du = new Design_User__c();
                du.Id = desuser[0].id;
                if(allDetails.name !=null){
                du.Name = allDetails.name;
                }
                if(allDetails.salutation !=null){
                du.Salutation__c = allDetails.salutation;
                }
                if(allDetails.designer_dashboard_ID !=null){
                du.Designer_Dashboard_ID__c = allDetails.designer_dashboard_ID;
                }
                if(allDetails.isActive !=null){
                du.Active__c = allDetails.isActive;
                }
                if(allDetails.email !=null){
                du.Email__c = allDetails.email;
                }
                if(allDetails.mobile !=null){
                du.Mobile__c = allDetails.mobile;
                }
                if(allDetails.role !=null){
                du.Role__c = allDetails.role;
                }
                if(allDetails.region !=null){
                du.Region__c = allDetails.region;
                }
                if(allDetails.experience_center !=null){
                du.Experience_Center__c = allDetails.experience_center;
                }
                if(allDetails.designer_team !=null){
                du.Designer_Team__c = allDetails.designer_team;
                }
                update du;
                
                response.StatusCode = '200';
                response.status = 'Success';
                response.Designer_User_Id = du.id;
                response.message = 'Designer User updated successfully';
                response.Designer_Name = du.Name;
            }
            else{
                Design_User__c du1 = new Design_User__c();
                   if(allDetails.name !=null){ 
                      du1.Name = allDetails.name;
                }
                if(allDetails.salutation !=null){
                du1.Salutation__c = allDetails.salutation;
                }
                if(allDetails.designer_dashboard_ID !=null){
                du1.Designer_Dashboard_ID__c = allDetails.designer_dashboard_ID;
                }
                if(allDetails.isActive !=null){
                du1.Active__c = allDetails.isActive;
                }
                if(allDetails.email !=null){
                du1.Email__c = allDetails.email;
                }
                if(allDetails.mobile !=null){
                du1.Mobile__c = allDetails.mobile;
                }
                if(allDetails.role !=null){
                du1.Role__c = allDetails.role;
                }
                if(allDetails.region !=null){
                du1.Region__c = allDetails.region;
                }
                if(allDetails.experience_center !=null){
                du1.Experience_Center__c = allDetails.experience_center;
                }
                if(allDetails.designer_team !=null){
                du1.Designer_Team__c = allDetails.designer_team;
                }
                insert du1;
                
                response.StatusCode = '200';
                response.status = 'Success';
                response.Designer_User_Id = du1.id;
                response.message = 'Designer User created successfully';
                response.Designer_Name = du1.Name;
            }
        }
        catch(Exception exc) {
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
    //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(),'/designeruser', req.requestBody.toString(), Response.message, 'in');
        return response;
    }
    
    global class DetailsWrap{
        public string salutation;
        public string name;
        public string designer_dashboard_ID;
        public string designer_team;
        public string email;
        public string experience_center;
        public string mobile;
        public string region;
        public boolean isActive;
        public string role;      
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String StatusCode;
        String Designer_User_Id;
        String Designer_Name;
    }
}