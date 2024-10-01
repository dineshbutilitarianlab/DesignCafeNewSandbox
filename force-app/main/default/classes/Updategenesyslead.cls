@RestResource(urlMapping='/updatelead')
global without sharing class Updategenesyslead {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap allDetails = (DetailsWrap)JSON.deserialize(req.requestBody.toString(),DetailsWrap.class);
        try{
            List<Lead> ld = [SELECT id,Region__c,Channel__c, Status, MobilePhone,DC_Lead_Status__c,DC_Lead_Source__c,Campagin__c,Call_Stage__c,Callrecording__c,createddate,APIMOBILE__c 
                             FROM Lead 
                             Where APIMOBILE__c =:allDetails.PHONE  Limit 200];
          
            if(ld.size() !=0){
                
                Lead l = new Lead();
                l.id=ld[0].id;
                if(allDetails.SOURCE !=null){
                    l.Source__c=allDetails.SOURCE;
                }
                if(allDetails.REGION !=null){
                    l.Region__c=allDetails.REGION;
                }
                if(allDetails.CHANNEL !=null){
                    l.Channel__c=allDetails.CHANNEL;
                }
                if(allDetails.LEAD_SOURCE !=null){
                    l.DC_Lead_Source__c=allDetails.LEAD_SOURCE;
                }
                if(allDetails.CAMPAIGN_SOURCE !=null){
                    l.Campagin__c=allDetails.CAMPAIGN_SOURCE;
                }
                System.debug('Status==>'+l.Status);
                System.debug('Status1'+ld[0].Status);
                if(ld[0].Status == 'New' || ld[0].Status == 'Connected' || ld[0].Status == 'Not Connected'){
                    l.Status=allDetails.LEAD_STAGE;
                }
                if(ld[0].Status == 'New' || ld[0].Status == 'Connected' || ld[0].Status == 'Not Connected'){
                   l.DC_Lead_Status__c=allDetails.LEAD_STATUS;
                }
                if(allDetails.Callrecording !=null){
                    l.Callrecording__c=allDetails.Callrecording;
                }
                if(ld[0].Status == 'New' || ld[0].Status == 'Connected' || ld[0].Status == 'Not Connected'){
                   l.Call_Stage__c=allDetails.CALL_STAGE;
               }
                System.debug('l '+l);
                update l;              
                response.StatusCode = '200';
                response.status = 'Success';
                response.message = 'Lead updated successfully';
            }
        }
        catch(Exception exc) {
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
      //Api Call Logger 
      ApiCallLogger.method(system.UserInfo.getUserId(), '/updatelead', 'REQ', response.message, 'in');
        return response;
    }
    
    global class DetailsWrap{
        Public String PHONE;
        Public String RECORD_ID;
        Public String NAME;
        Public String MAIL_ID;
        Public String SOURCE;
        Public String REGION;
        Public String CHANNEL;
        Public String LEAD_SOURCE;
        Public String CAMPAIGN_SOURCE;
        Public Date CREATE_DATE;
        Public String LEAD_ID;
        Public String LEAD_STAGE;
        Public String LEAD_STATUS;
        Public String CALL_STAGE;
        Public Date PP_DATE;
        Public String SF_LEAD_ID; 
        Public String Callrecording;   
        
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String StatusCode;
    }
}