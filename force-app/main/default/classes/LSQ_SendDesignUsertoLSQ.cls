public class LSQ_SendDesignUsertoLSQ {
	// Inner class to represent the Column structure
    public class Column {
        public String ColumnId;
        public String ColumnValue;
        
        public Column(String columnId, String columnValue) {
            this.ColumnId = columnId;
            this.ColumnValue = columnValue;
        }
    }

    // Inner class to represent the Data wrapper
    public class DataWrapper {
        public List<List<Column>> Data;
        
        public DataWrapper(List<List<Column>> data) {
            this.Data = data;
        }
    }

	// Class to parse the inner Data structure of the API response
    public class ApiResponseData {
        public String RequestId;
    }
    
    // Class to parse the API response
    public class ApiResponse {
        public String Message;
        public ApiResponseData Data;
    }
    
    @future(callout=true)
    public static void createandUpdateDesignUserData(List<String> designUserIdSet){
        try{
            system.debug('DesignUser');
            List<Design_User__c> designUserUpdateList = new List<Design_User__c>();
            List<Design_User__c> designUserList = [SELECT Id, OwnerId, IsDeleted, Name,
                             Active__c, DesignUserNumber__c, Designer_Dashboard_ID__c,
                             Designer_Team__c, Email__c, Experience_Center__c, Mobile__c, 
                             Region__c, Role__c, Salutation__c, 
                             LSQ_Design_User_ID__c FROM Design_User__c
                             WHERE Id IN: designUserIdSet];
            system.debug('designUserList' + designUserList);
            
            if(designUserList.size() > 0){
            	for(Design_User__c designUserRecord : designUserList){  
            		//DataWrapper dataWrapper = new DataWrapper();
                    List<Column> columns = new List<Column>();
                    if(designUserRecord.DesignUserNumber__c !=null){
                        columns.add(new Column('Design_User_Number', String.valueOf(designUserRecord.DesignUserNumber__c)));
                    }
                    if(designUserRecord.Name !=null){
                        columns.add(new Column('Design_User__Design_User_Name', designUserRecord.Name));
                    }
                    /*if(designUserRecord.Email__c !=null){
                        columns.add(new Column('Design_User_Owner_Name', designUserRecord.Email__c));
                    }*/
                    if(designUserRecord.Designer_Dashboard_ID__c !=null){
                        columns.add(new Column('Designer_Dashboard_ID', String.valueOf(designUserRecord.Designer_Dashboard_ID__c)));
                    }
                    if(designUserRecord.Role__c !=null){
                        columns.add(new Column('Role', designUserRecord.Role__c));
                    }
                    if(designUserRecord.Designer_Team__c !=null){
                        columns.add(new Column('Designer_Team', designUserRecord.Designer_Team__c));
                    }
                    if(designUserRecord.Email__c !=null){
                        columns.add(new Column('Email', String.valueOf(designUserRecord.Email__c)));
                    }
                    if(designUserRecord.Active__c !=null){
                        columns.add(new Column('Active', String.valueOf(designUserRecord.Active__c)));
                    }
                    if(designUserRecord.Mobile__c !=null){
                        columns.add(new Column('Mobile', String.valueOf(designUserRecord.Mobile__c)));
                    }
                    if(designUserRecord.Region__c !=null){
                        columns.add(new Column('Region', designUserRecord.Region__c));
                    }
                    if(designUserRecord.Experience_Center__c !=null){
                        columns.add(new Column('Experience_Center', designUserRecord.Experience_Center__c));
                    }
                    List<List<Column>> data = new List<List<Column>>();
        			data.add(columns);
        			DataWrapper dataWrapper = new DataWrapper(data);
                    system.debug('Json Serialize : '+JSON.serialize(dataWrapper));
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(System.Label.LSQ_Mavis_API);
                    //request.setTimeout(120000);
                    request.setMethod('POST');
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('x-api-key', 'V0H6A2RVUs9Vs5A30BwN719Z1VT06HfT30L7sMF3');
                    String jsonBody = JSON.serialize(dataWrapper);
                    system.debug('JSON BODY : '+jsonBody);
                    request.setBody(jsonBody);
                    Http http = new Http();
                    HttpResponse jsonResponse = http.send(request);
                    System.debug('Response Status: ' + jsonResponse.getStatus());
                    System.debug('Response Body: ' + jsonResponse.getBody());
                    String jsonResponseStringType = jsonResponse.getBody();
                    if (jsonResponse.getStatusCode() == 200) {
                        String requestId = (String) ((Map<String, Object>) ((Map<String, Object>)
                                                                            JSON.deserializeUntyped(jsonResponse.getBody())).get('Data')).get('RequestId');
            			designUserRecord.LSQ_Design_User_ID__c = requestId;
						System.debug('designUserRecord.LSQ_Design_User_ID__c '+designUserRecord.LSQ_Design_User_ID__c);
						designUserUpdateList.add(designUserRecord);
                    } else {
                        System.debug('Error: ' + jsonResponse.getBody());
                    }
                }
            }
            if(designUserUpdateList != null && designUserUpdateList.size() > 0){
             	update designUserUpdateList;   
            }
        }
        catch(Exception exc){
            system.debug('Exception in LSQ_SendDesignUsertoLSQ: ' + exc.getMessage());
        }
    }           
}