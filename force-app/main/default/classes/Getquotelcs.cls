public class Getquotelcs {
    public class leadDataWrap{
        @AuraEnabled
        public String clientName{get;set;}
        @AuraEnabled
        public String emailId{get;set;}
        @AuraEnabled
        public String ProertyType{get;set;}
        @AuraEnabled
        public String propertyName{get;set;}
        @AuraEnabled
        public String phoneNo{get;set;}
        @AuraEnabled
        public String designerEmail {get;set;}
        @AuraEnabled
        public integer propertyBhk{get;set;}
        @AuraEnabled
        public integer isGetQuote{get;set;}
        @AuraEnabled
        public date posessionMonth{get;set;}
        @AuraEnabled
        public String designerName{get;set;}
        @AuraEnabled
        public String city{get;set;}
         @AuraEnabled
        public String SalesOwnerName{get;set;}
        @AuraEnabled
        public String SalesOwnerEmail{get;set;}
    }
    public class responsedata{
        public string code;
        public string message;
        public string status;
    }
    public class leadDataListWrap{
        public leadDataWrap leadData{get;set;}
    }
    
    @AuraEnabled
    public static string showbutton(String recId){
                system.debug('test'+recId);
        lead ld = [select id,Status,DC_Lead_Status__c from lead where id=: recId];
        List<lead> leadList = [select id, DC_Lead_Status__c from lead where id =: recId]; 
        if(leadList.size() != 0 && (ld.Status == 'Meeting Confirmed')){
            return 'Enabled';
        }
        else{
            return 'Disabled';
        }
    }
    
    @future(callout=true)
    @AuraEnabled
    public static void LCScallServer(String recId){
        Lead ld = [Select id,Name,Email,Home_Type__c,MobilePhone,DC_Lead_Status__C,Lead_Owner_Name__c,Lead_owner_Email__c,DesignerEmail__c,Project_Name__c,Property_Possession_Date__c,City,Design_User_Name__c from Lead Where id=: recId limit 1];
        leadDataWrap leaddata = new leadDataWrap();
        if(ld.Name !=null){
            leaddata.clientName = ld.Name;
        }
        if(ld.Email !=null){
            leaddata.emailId = ld.Email;
        }
        if(ld.Home_Type__c !=null){
            leaddata.ProertyType = ld.Home_Type__c;
        }
        if(ld.DesignerEmail__c!=null){
            leaddata.designerEmail = ld.DesignerEmail__c;
        }
        if(ld.MobilePhone !=null){
            leaddata.phoneNo = ld.MobilePhone;
        }
        if(ld.Project_Name__c !=null){
            leaddata.propertyName = ld.Project_Name__c;
        }
        if(ld.Lead_Owner_Name__c !=null){
            leaddata.SalesOwnerName = ld.Lead_Owner_Name__c;
        }
        if(ld.Lead_owner_Email__c !=null){
            leaddata.SalesOwnerEmail = ld.Lead_owner_Email__c;
        }
        leaddata.propertyBhk=0;
        leaddata.isGetQuote=1;
        if(ld.Property_Possession_Date__c !=null){
            leaddata.posessionMonth = ld.Property_Possession_Date__c;
        }
        if(ld.City !=null){
            leaddata.city = ld.City;
        }
        if(ld.Design_User_Name__c !=null){
            leaddata.designerName = ld.Design_User_Name__c;
        }
        system.debug('Json Serialize : '+JSON.serialize(leaddata));
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://ec2-52-24-188-139.us-west-2.compute.amazonaws.com/Dc_Lead4.0/dcservice/customer/customer');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(leaddata);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        
        Http http = new Http();
        if(!test.isRunningTest())
            HttpResponse response = http.send(request);
        
    }
}