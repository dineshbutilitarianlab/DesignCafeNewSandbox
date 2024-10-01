@RestResource(urlMapping='/dcleadsUpdate')
global without sharing class DC_UpdateVerifiedLead {
    //wrapper class for Mobile and IsVerified checkbox
    global class leadWrap{
        global string mobile{get;set;}
        global string otpverified{get;set;}
    }
    //wrapper class to capture server message
    global class messageWrap{
        global string status{get;set;}
        global string message{get;set;}
    }
    
    //request response + authorization + JSON deserialization
    @httppost
    global static messageWrap updateVerifiedLead(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        system.debug('testData'+req.requestBody.toString());
        System.debug('header'+req.headers.get('Authorization'));
        leadWrap data = (leadWrap)JSON.deserialize(req.requestBody.toString(),leadWrap.class);
        
        
        system.debug(data);
        Lead orgData;
        String message;
        try{
            orgData = [select id,MobilePhone,OTP_Verified__c from Lead where MobilePhone =: data.mobile limit 1]; 
        }catch(Exception e){
            system.debug(e.getMessage());
            messageWrap mm = new messageWrap();
            mm.status='Error';
            mm.message = e.getMessage();
            //return mm;
            message = mm.message;
        }
        if(message == 'List has no rows for assignment to SObject'){
            messageWrap mm = new messageWrap();
            mm.status='Error';
            mm.message ='Mobile number not found';
            //Calling ApiCallLogger class
        	ApiCallLogger.method(system.UserInfo.getUserId(), '/dcleadsUpdate', req.requestBody.toString(),mm.message, 'in');
            return mm;
            
        }
        else{
            try{
                Lead updateData = new Lead();
                updateData.id = orgData.id;
               updateData.OTP_Verified__c = String.valueOf(data.otpverified);
                update updateData;
            }Catch(Exception e){
                message = e.getMessage();
            }
            if(message!= null){
                messageWrap mm = new messageWrap();
                mm.status='Error';
                mm.message =message;
                //Calling ApiCallLogger class
        		ApiCallLogger.method(system.UserInfo.getUserId(), '/dcleadsUpdate', req.requestBody.toString(),mm.message, 'in');
                return mm;
            }else{
                messageWrap mm = new messageWrap();
                mm.status='Success';
                mm.message ='Updated Successfully';
                //Calling ApiCallLogger class
        		ApiCallLogger.method(system.UserInfo.getUserId(), '/dcleadsUpdate', req.requestBody.toString(),mm.message, 'in');
                return mm;
            }
        }
        
    }
    
}