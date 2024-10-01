@RestResource(urlMapping='/followupcount')
global without sharing class FollowupCount_RestResource {
    
    @HttpPost 
    global  static String doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            String resquestBody = req.requestBody.toString();
            Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(resquestBody);
            String leadId = (String) jsonData.get('Id');
            // Added By Muskan on 4 March 2024 for attemptCount value in lead by an API
            String attemptCount = (String) jsonData.get('AttemptCount');
            String followupCount = (String) jsonData.get('FollowupCount');
            System.debug('Id leadId: ' + leadId);
            System.debug('followupCount: ' + followupCount);
            System.debug('attemptCount: ' + attemptCount);
            List<Lead> leadList = [SELECT Id, Name,Follow_Up_Count__c,Attempt_Count__c FROM Lead WHERE Id =: leadId];
            if(leadList.size() > 0){
                System.debug('leadList ==> ' + leadList);
                for(Lead ld: leadList){
                    //Added By Muskan on 4 March 2024 for either the value of attemptCount, followupcount in lead by an API
                    if(followupCount !=null){
                    	 ld.Follow_Up_Count__c = Decimal.valueOf(followupCount);        	
                    }
                    if(attemptCount !=null){
                    	 ld.Attempt_Count__c = Decimal.valueOf(attemptCount);   	
                    }
                   
                }
                UPDATE leadList;
                
                return 'Followup Count Updated Successfully!';
            }else{
                return 'Lead not exist with the provided Id!';
            }
            
        }catch(Exception e){
            return 'Exception : ' + e.getMessage();   
        }
    }
}