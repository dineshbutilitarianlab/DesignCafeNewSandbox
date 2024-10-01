public class FBConversionAPI {

    public class ActionRequest {
        @InvocableVariable(required = true) public String event_name;
        @InvocableVariable public String action_source;
        @InvocableVariable public String em;
        @InvocableVariable public String ph;
        @InvocableVariable public String stage;
        @InvocableVariable public String PropertyType;
        @InvocableVariable public String Location;
        @InvocableVariable public String fbclid;
    }

    @InvocableMethod( label='make facebook request')
    public static void fbConvertionApiRequest(List<ActionRequest> ac){
        doCallout(JSON.serialize(ac[0]));
    }

    @Future(callout=true)
    public static void doCallout(String flowData) {
        ActionRequest FlowDataObj = (ActionRequest)JSON.deserialize(flowData, ActionRequest.class);
        RequestData requestData = new RequestData(FlowDataObj);
        Facebook_Conversion_Api__c fbAPIObj = Facebook_Conversion_Api__c.getValues('FB Convertion Setting');
        system.debug(' myCS1 '+fbAPIObj);
        String baseURL = fbAPIObj.Endpoint__c;
        String pixelId = fbAPIObj.PixelId__c;
        String versionId = fbAPIObj.API_Version__c;
        String accessToken = fbAPIObj.access_token__c;
        String endpoint = baseURL+'/'+versionId+'/'+pixelId+'/events?access_token='+accessToken;
        System.debug('endpoint => '+endpoint);
       

        String requestBody = JSON.serialize(requestData);
        System.debug('requestBody => '+requestBody);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody(requestBody);

        HttpResponse res = h.send(req);
        System.debug('Header => '+res.getStatusCode());
        System.debug('Header => '+res);
    }

    class RequestData{
        public List<Eventdata> data;
        public RequestData(ActionRequest req){
            this.data = new List<Eventdata>{new Eventdata(req.event_name, req.action_source, req.em, req.ph, req.stage, req.PropertyType, req.Location, req.fbclid)};
        }
    }

    class Eventdata{
        public String event_name;
        public Decimal event_time;
        public String action_source;
        public UserData user_data;
        public CustomData custom_data;
        public Eventdata(String event_name, String action_source, String em, String ph, String stage, String PropertyType, String Location, String fbclid){
            this.event_name = event_name;
            this.event_time = Datetime.now().getTime()/1000;
            system.debug('this.event_time => '+this.event_time);
            this.action_source = 'system_generated';
            this.user_data = new UserData(em, ph);
            this.custom_data = new CustomData(stage, PropertyType, Location, fbclid);
        }
    }
    class UserData{
        public String em;
        public String ph;
        public UserData(String em, String ph){
            this.em = convertStringIntoSHA256(em);
            this.ph = convertStringIntoSHA256(ph);
        }
        
        public String convertStringIntoSHA256(String input){
            Blob myBlob = Blob.valueOf(input);
            Blob mySha = Crypto.generateDigest('SHA-256', myBlob);
            String myHex = EncodingUtil.convertToHex(mySha);
            return myHex;
        }
    }
    class CustomData{
        public String stage;
        public String PropertyType;
        public String Location;
        public String fbclid;
     
        public CustomData(String stage, String PropertyType, String Location, String fbclid){
            this.stage = stage;
            this.PropertyType = PropertyType;
            this.Location = Location;
            this.fbclid = fbclid;
        }
    }
}