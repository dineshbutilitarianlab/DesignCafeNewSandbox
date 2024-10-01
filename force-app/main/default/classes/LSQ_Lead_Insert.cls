public class LSQ_Lead_Insert {

    
    public class fieldsJSON {
        public String Attribute;
        public String Value;
        
        public fieldsJSON(String attribute, String value) {
            this.Attribute = attribute;
            this.Value = value;
        }
    }
    
    // Define a public static method as a future method
    
    public static void sendUpdatedDataToLSQ(List<Id> leadIds) {
        // Query Lead records based on the extracted IDs
        System.debug('method call ');
        List<Lead> leadList = [SELECT Id,Approx_Budget__c,DC_campaign_Source__c,Channel__c,CMM_Name__c,Country_code__c,Customer_Pincode__c,
                               DSA__c,DSA_category__c,DSA_code__c,DSA_Email__c,DSAname__c,Email,Home_Type__c,LARR__c,Lead_Owner_Profile__c,
                               Lead_Owner_Role__c,DC_Lead_Source__c,Status,DC_Lead_Status__c,Willingness_For_Meeting__c,
                               Meeting_Type__c,Meeting_Venue__c,Messaging_Source__c,MobilePhone,Name,LastName,Project_Name__c,
                               Property_Address__c,Property_Possession_Date__c,Property_Possession_Status__c,Call_Stage__c,
                               Referee_Account__c,Referrer_city__c,Referee_code__c,Referee_Email_ID__c,Referee_Name__c,Referee_Number__c,
                               Region__c,Requirement_Details__c,Scope_Of_Work__c,Site_Service_Needed_for__c,Source__c,Source_Journey__c,
                               User_Details__c,YMUrl__c FROM Lead WHERE Id IN :leadIds];
        
        // Map to easily fetch Lead records by ID
        Map<Id, Lead> leadMap = new Map<Id, Lead>(leadList);
        
        // Create a list to hold fieldsJSON objects
        List<fieldsJSON> fieldsList = new List<fieldsJSON>();
        
        // Process only the changed fields for each Lead
        System.debug('method call for loop');
        for (Id leadId : leadIds) {
            Lead leadRecord = leadMap.get(leadId);
            if (leadRecord.Client_s_Budget__c != null) {
            	fieldsList.add(new fieldsJSON('mx_Client_Budget',String.valueof(leadRecord.Client_s_Budget__c)));
            }
            
        }
        String jsonPayloadSerialize = JSON.serialize(fieldsList);
        makeCallout(jsonPayloadSerialize);
        System.debug('jsonPayload '+jsonPayloadSerialize);
        
    }
    @future(callout=true)
    public static void makeCallout(String jsonPayload) {
        
        System.debug('jsonPayload '+jsonPayload);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.LSQ_Lead_Update);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonPayload);
        
        Http http = new Http();
        HttpResponse jsonResponse = http.send(request);
        System.debug('Response Status: ' + jsonResponse.getStatus());
        System.debug('Response Body: ' + jsonResponse.getBody());
        String jsonResponseStringType = jsonResponse.getBody();
        if (jsonResponse.getStatusCode() == 200) {
        } else {
            System.debug('Error: ' + jsonResponse.getBody());
        }
    }
    
    
}