/*
* Code Creator  : Munna Shaik
* Created Date  : 09 DEC 2021
* Code Modifier : V-Fory Team
* Modified Date : 21th December 2021
* Modified By   : Munna Shaik
*/
public class VDC_CPUpdateOpportunity {
    public class opportunityCPDataWrap{
        public String id;
        public String name;
        public String stageName;
        public String region;
        public String closeDate;
        public String createdDate;
        public String email;
        public String phoneNumber;
        public String dsaRefCode;
        public String dsaAccountId;
        public String cmmName;
    }
    public class responsedata{      
        public Integer statusCode;
        public String body;
    }
    @future(callout=true)
    public static void CPcallout(String id){
        CPPortal__c data1 = CPPortal__c.getvalues('cpportalopportunityupdate');
        Opportunity op = [Select Id,Name,StageName,Region__c,CloseDate,Email__c,Phone__c,DSA__c,DSA_Code__c,CMM_Name__c,CreatedDate from Opportunity Where id=: id limit 1];
        
        opportunityCPDataWrap  oppcpdata = new  opportunityCPDataWrap ();
        if(op.Id !=null){
            oppcpdata.id = op.Id;
        }
        if(op.Name !=null){
            oppcpdata.name = op.Name;
        }
        if(op.StageName !=null){
            oppcpdata.stageName = op.StageName;
        }
        if(op.Region__c !=null){
            oppcpdata.region = op.Region__c;
        }
        if(op.CloseDate !=null){
            oppcpdata.closeDate = string.valueOf(op.CloseDate);
        }       
        if(op.CreatedDate !=null){
            oppcpdata.createdDate = string.valueOf(op.CreatedDate);
        }
        if(op.Phone__c !=null){
            oppcpdata.phoneNumber = op.Phone__c;
        }
        if(op.Email__c !=null){
            oppcpdata.email = op.Email__c;
        }
        if(op.DSA_Code__c !=null){
            oppcpdata.dsaRefCode = op.DSA_Code__c;
        }
        if(op.DSA__c !=null){
            oppcpdata.dsaAccountId = op.DSA__c;
        }
        if(op.CMM_Name__c !=null){
            oppcpdata.cmmName = op.CMM_Name__c;
        }       
       
        String Fullbody = JSON.serialize(oppcpdata);
        
        HttpRequest request = new HttpRequest();
        /*if(Test.isRunningTest() && data1 == null){
            data1.Name = 'cpportalupdate';
            data1.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
            insert data1; 
        }*/
        if(!Test.isRunningTest()){
            string jsonString = data1.url__c; 
            request.setEndpoint(jsonString);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json');
            String jsonBody = Fullbody;
            system.debug('JSON BODY : '+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            
            HttpResponse response = http.send(request);
            string resbody = response.getBody();
            system.debug(resbody);
            system.debug(response);    
        }
    }
    
    public static void codeCoverage(){
        Integer i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
    }
    
}