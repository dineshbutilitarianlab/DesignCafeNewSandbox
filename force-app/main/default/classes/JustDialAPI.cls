@RestResource (urlMapping = '/JustDial_API')
global class JustDialAPI {
    @HttpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        if (String.isNotBlank(req.requestBody.toString())) {
            try {
                JustDialWrapper justDialObj = (JustDialWrapper)JSON.deserialize(req.requestBody.toString(),JustDialWrapper.class);
                Lead leadRecord = new Lead();
                if (String.isNotBlank(justDialObj.mobile)) {
                    List<Lead> leadList = [SELECT Id FROM Lead WHERE MobilePhone = :justDialObj.mobile];
                    if (leadList.size() > 0) {
                        res.responseBody = getResponceMessage('Lead Already Exist In SF');
                    }else {
                        leadRecord.Status = 'New';
                        leadRecord.DC_Lead_Status__c = 'Undialed';
                        leadRecord.Call_Stage__c = 'Undialed';
                        leadRecord.Channel__c = 'Online';
                        leadRecord.Source__c = 'Paid';
                        leadRecord.DC_Lead_Source__c = 'Justdial Ads';
                        leadRecord.DC_Campaign_Source__c = 'Justdial';
                        leadRecord.Title = justDialObj.prefix;
                        leadRecord.LastName = justDialObj.name;
                        leadRecord.MobilePhone = justDialObj.mobile;
                        leadRecord.Email = justDialObj.email;
                        leadRecord.City = justDialObj.city;
                        leadRecord.Company = justDialObj.company;
                        leadRecord.Customer_Pincode__c = justDialObj.pincode;

                        insert leadRecord;

                        res.responseBody = getResponceMessage('Record Created Successfully');
                            
                    }
                }else {
                    res.responseBody = getResponceMessage('Mobile Number Is Required');
                }
            } catch (Exception e) {
                res.responseBody = getResponceMessage(e.getMessage());
            }

        }else {
            System.debug('req.requestBody.toString() => '+req.requestBody.toString());
            res.responseBody = getResponceMessage('Request Body is Missing');
            return;            
        }
    }

    public static Blob getResponceMessage(String responceMessage) {
        Map<String, String> responceMap = new Map<String, String>{
            'result' => responceMessage
        };
        return Blob.valueOf(JSON.serialize(responceMap));
    }

    public class JustDialWrapper {
        public String prefix;
        public String name;
        public String mobile;
        public String email;
        public String city;
        public String company;
        public String pincode;
    }

}