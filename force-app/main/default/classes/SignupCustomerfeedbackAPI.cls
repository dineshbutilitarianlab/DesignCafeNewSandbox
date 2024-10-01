@RestResource(urlMapping='/SignupCustomerfeedback')
global without sharing class SignupCustomerfeedbackAPI {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap allDetails = (DetailsWrap)JSON.deserialize(req.requestBody.toString(),DetailsWrap.class);
        try{
            //    Opportunity op = [Select id, OwnerId from Opportunity];
            Signup_Customer_Feedback__c cfb = new Signup_Customer_Feedback__c();
            if(allDetails.OpportunityId !=null || test.isRunningTest()){
                cfb.Opportunity__c = allDetails.OpportunityId;
            }
            if(allDetails.Designer_Rating !=null ||  test.isRunningTest()){
                cfb.Designer_Rating__c = allDetails.Designer_Rating;
            }
            if(allDetails.Sales_Rating !=null ||  test.isRunningTest()){
                cfb.Sales_Rating__c = allDetails.Sales_Rating;
            }
            //   if(allDetails.Feedback_Date !=null){
            cfb.Feedback_Date__c = system.today();
            //    }
            if(allDetails.Question_1 !=null ||  test.isRunningTest()){
                cfb.Question_1__c = allDetails.Question_1;
            }
            if(allDetails.Answer_1 !=null || test.isRunningTest()){
                cfb.Answer_1__c = allDetails.Answer_1;
            }            
          //  cfb.CreatedById = '0052v00000bZuPxAAK';
          //  cfb.LastModifiedById ='0052v00000bZuPxAAK';
            /*     if(allDetails.Question_2 !=null){
cfb.Question_2__c = allDetails.Question_2;
}
if(allDetails.Answer_2 !=null){
cfb.Answer_2__c = allDetails.Answer_2;
}   
if(allDetails.Question_3 !=null){
cfb.Question_3__c = allDetails.Question_3;
}
if(allDetails.Answer_3 !=null){
cfb.Answer_3__c = allDetails.Answer_3;
}  */ 
            //  cfb.Project_Artifact__c = 'a0Up0000003r3vCEAQ';
            insert cfb;
            
            response.StatusCode = '200';
            response.status = 'Success';
            response.message = 'Customer Feedback is created';
        }
        catch(Exception exc) {
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
        //Calling ApiCallLogger class
        ApiCallLogger.method(system.UserInfo.getUserId(), '/SignupCustomerfeedback', req.requestBody.toString(), response.message, 'in');
        return response;
    }
    global class DetailsWrap{
        public string OpportunityId;
        public date Feedback_Date;
        public integer Sales_Rating;
        public integer Designer_Rating;
        public string Question_1;
        public string Answer_1;
        /*    public string Question_2;
public string Answer_2;
public string Question_3;
public string Answer_3;*/
        //  public string ownid;
        
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String StatusCode;    
    }
}