public class SMSIntegration_Handler {
    public static Design_Cafe_Settings__c dcSetting;    
    public static string countryCode                        = '91';
    public static SMS_Template__mdt[] smsTemplatesMdt       = [SELECT MasterLabel,Object_Name__c,Triggering_field_API__c,Phone_Field_API__c,Broadcast__c,Broadcast_to_Role__c,Triggering_field_Value__c, Message_body__c,DeveloperName FROM SMS_Template__mdt];
    
    public static MAP<String,LIST<SMS_Template__mdt>> objToSMSMdtMap            = new MAP<String,LIST<SMS_Template__mdt>>(); // Map of Obj - > Metadata
    // public static MAP<String,Set<String>> objToAdditionalFields              = new MAP<String,Set<String>>();  // Map of Obj - > Additional fields
   	public static MAP<String,List<User>> mapRoleToUser                          = new MAP<String,List<User>>(); // mapRoleToUser
    
    
    // ******** Main function calling out All functions******
    public static void calloutToSendSMSMainFunct(String objectName , Set<Id> recordIdsToSendSMS , Boolean dateChangedEvent){
        initialFetchingMdt();        
        if(objectName != null && objectName != ''){
            LIST<sObject> queriedRecords                    = allRecordsToProcess(objectName,recordIdsToSendSMS);
            SMSWrapper smsBody                              = createSMSBody(objectName,queriedRecords,dateChangedEvent);
            integrationCallout(smsBody);
        }    	
    }    
    
    // ******** calling out integration************************
    public static void integrationCallout( SMSWrapper smsBody ){
        if(Test.isRunningTest()) {
            Test.setMock(HttpCalloutMock.class, new TestSMS());
        }
        else {
            String body = JSON.serialize(smsBody);
            HTTP auth = new HTTP();
            HTTPRequest r = new HTTPRequest();
            r.setHeader('authkey',dcSetting.Msg91_Auth_Key__c);
            r.setHeader('Content-Type',dcSetting.Content_Type__c);
            r.setEndpoint(dcSetting.Msg91_URL__c);
            r.setMethod('POST'); 
            r.setTimeout(120000);
            r.setBody(body);
            HTTPResponse authresp=new HttpResponse();
            authresp = auth.send(r);
            
            if(authresp.getStatusCode() != 200 || authresp.getStatus() != 'OK'){
                createLogOnFailure(authresp);
            }
        }
    }
    
    // ******Log Creation on failure
    public static void createLogOnFailure( HTTPResponse authresp){
        MAP<String,Object> mapOfBody        = (Map<String, Object>)JSON.deserializeUntyped(authresp.getBody()); 
        SMS_Integration_Log__c	logError    = new SMS_Integration_Log__c();
        logError.Status_Code__c             = String.valueOf(authresp.getStatusCode());
        logError.Status_Message__c          = string.valueOf(mapOfBody.get('message'));        
        insert logError;
    }
    
    
    //****** Fetch metadata and users initially.
    public static void initialFetchingMdt(){        
        dcSetting 								= Design_Cafe_Settings__c.getInstance(); // Fetching custom settings;
        
        // fetching custom Metadata	
        LIST<SMS_Template__mdt> listMdt         = new LIST<SMS_Template__mdt>();
        Set<String> setAddFields                = new Set<String>();
        
        for(SMS_Template__mdt each : smsTemplatesMdt){
            listMdt                     		= new LIST<SMS_Template__mdt>();
            setAddFields                		= new Set<String>();
            
            // Map of Obj - > Metadata
            if(objToSMSMdtMap.containsKey(each.Object_Name__c) && objToSMSMdtMap.get(each.Object_Name__c) != null){
                listMdt = objToSMSMdtMap.get(each.Object_Name__c);
            }
            listMdt.add(each);
            objToSMSMdtMap.put(each.Object_Name__c , listMdt);
            
            // Map of Obj - > Additional fields
            // if(each.Additional_Fields__c != '' && each.Additional_Fields__c != null){
            //     if(objToAdditionalFields.containsKey(each.Object_Name__c) && objToAdditionalFields.get(each.Object_Name__c) != null){
            //         setAddFields = objToAdditionalFields.get(each.Object_Name__c);
            //     }
                
            //     LIST<String> currentAddFields = each.Additional_Fields__c.deleteWhitespace().split(',');
            //     setAddFields.addAll(currentAddFields);
            //     objToAdditionalFields.put(each.Object_Name__c , setAddFields);
            // }
        }
                
        /// -----------------Map Role To users        
        Set<String> userRoleId = new Set<String>();
        for(UserRole each : [SELECT Id,Name FROM UserRole where Name IN ('Finance' , 'Designer' ,  'Internal Sales Agent')]){
            userRoleId.add(each.Id);
        }
        if(userRoleId != null){
            for(User eachUsr : [select id,name,Phone,UserRole.Name from User where UserRoleID IN : userRoleId]){
                List<User> lisUsers = new List<User>();
                if(mapRoleToUser.get(eachUsr.UserRole.Name) != null){
                    lisUsers = mapRoleToUser.get(eachUsr.UserRole.Name);
                }
                lisUsers.add(eachUsr);
                mapRoleToUser.put(eachUsr.UserRole.Name , lisUsers);
            }
        }
        
    }
    
    
    //****** Records of sObject queried - Dynamic
    public static LIST<sObject> allRecordsToProcess(String objectName , Set<Id> recordIdsToSendSMS){
        // suppose lead
        // -----------------------------------
        String recordIds = '(';
        for(String each : recordIdsToSendSMS){
            recordIds+= '\''+each+'\''+',';
        }
        system.debug(recordIds);
        recordIds = recordIds.removeEnd(',');
        system.debug(recordIds);
        recordIds += ') ';
        String condition = 'id IN '+ recordIds;
        
        // -----------------------
        // String additionalFields = '';
        // if(objToAdditionalFields != null && objToAdditionalFields.get(objectName) != null){
        //     for(String each : objToAdditionalFields.get(objectName)){
        //         additionalFields+= ','+each;
        //     }
        //     additionalFields = additionalFields.removeStart(',');
        // }
        // system.debug(additionalFields);
        
        String queryString = getQueryStringToFetchAllFields(objectName  , condition);   
        system.debug(queryString);
        LIST<sObject> queriedRecords = Database.query(queryString);
        //system.debug(queriedRecords.get(0).Owner.Name); //-------------------------TODO
        return queriedRecords;
    }
    
    
    //******
    public static SMSWrapper createSMSBody(String objectName,LIST<sObject> queriedRecords ,  Boolean dateChangedEvent){
        
        LIST<SMSWrapper.SMSDetail> smsDetailsList       = new LIST<SMSWrapper.SMSDetail>();
        List<String> listPhoneNumbers                   = new List<String>();
        
    	for(sObject eachRec : queriedRecords){
    	    for(SMS_Template__mdt eachMdt : objToSMSMdtMap.get(objectName)){
    	        if(eachMdt.Triggering_field_Value__c == 'Changed' && dateChangedEvent == true){ // In case of date change    	            
    	            system.debug('Yay');
    	            system.debug(eachMdt);
	                listPhoneNumbers.add(String.valueOf(eachRec.get(eachMdt.Phone_Field_API__c)));
	                String formattedMsgBody         = formatMsg(eachMdt.Message_body__c , eachRec);
            	    SMSWrapper.SMSDetail newSMS     = new SMSWrapper.SMSDetail(formattedMsgBody , listPhoneNumbers); //------ TODO
            	    smsDetailsList.add(newSMS);
	            }
    	        else if(eachRec.get(eachMdt.Triggering_field_API__c) == eachMdt.Triggering_field_Value__c  && dateChangedEvent == false){
    	            listPhoneNumbers                    = new List<String>();
    	            // Broadcast of msgs based on Roles
    	            if(eachMdt.Broadcast__c){
                        User [] lUsers = mapRoleToUser.get(eachMdt.Broadcast_to_Role__c);
                        
                        if(lUsers != null && lUsers.size() >= 0) {
                            for(User eachUsr : mapRoleToUser.get(eachMdt.Broadcast_to_Role__c)){
                                listPhoneNumbers.add(String.valueOf(eachUsr.Phone));
                            }
                        }
    	            }
    	            
    	            // To Specific records' phone
    	            else{
            	        system.debug('Yes');
            	        listPhoneNumbers.add(String.valueOf(eachRec.get(eachMdt.Phone_Field_API__c)));
    	            }
    	            String formattedMsgBody = formatMsg(eachMdt.Message_body__c , eachRec);
            	    SMSWrapper.SMSDetail newSMS = new SMSWrapper.SMSDetail(formattedMsgBody , listPhoneNumbers); //------ TODO
            	    smsDetailsList.add(newSMS);
        	    }
    	    }
    	}
        system.debug('dcSetting'+dcSetting);
    	SMSWrapper entrireSMSBody = new SMSWrapper(dcSetting.Sender_Name__c , dcSetting.Route__c , countryCode , smsDetailsList);
    	return entrireSMSBody;
    }
    
    
    //Parse the msg from Metadata
    public static string formattedMsg;
    public static String formatMsg (String rawMsg , sObject objRec){
        formattedMsg                            = rawMsg;
        Integer startIndex                      = rawMsg.indexOf('{!');
        Integer endIndex                        = rawMsg.indexOf('}');
        system.debug( startIndex + '--' + endIndex + '---' + rawMsg.length());
        if(startIndex > -1 && endIndex > -1 && endIndex < rawMsg.length() && startIndex < endIndex){
            String textToBeReplaced             = rawMsg.substring(startIndex , endIndex+1);
            system.debug(textToBeReplaced); 
            String mergeFieldName               = textToBeReplaced.deleteWhitespace().removeStart('{!').removeEnd('}');
            system.debug(objRec.get(mergeFieldName)); 
            system.debug(mergeFieldName); 
            if(objRec.get(mergeFieldName) != null ){
                formattedMsg                        = rawMsg.replace(textToBeReplaced, String.valueOf(objRec.get(mergeFieldName)));
            }
            else{
                formattedMsg                        = rawMsg.replace(textToBeReplaced, '');
            }
             // Recursive call
             return formatMsg(formattedMsg , objRec);
        }
        else{
            return formattedMsg;
        }
    }
    
    // Query String for Fetching all Fields given the sObject name and Condition
    public static string getQueryStringToFetchAllFields(String SobjectApiName , String condition){
        String query = '';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();        
        String strFields = '';        
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields =='')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }        
        query = 'select ' + strFields;
        // if(additionalFields != '' && additionalFields != null){
        //     query+=  ','+additionalFields;
        // }
        query+= ' from ' + SobjectApiName + ' where ' + condition;
        return query;
    }
}