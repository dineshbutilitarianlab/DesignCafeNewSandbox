public class LcsAPIupdate {
    public class OppdataWrap{
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
        public integer propertyBhk{get;set;}
        @AuraEnabled
        public String designerEmail {get;set;}
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
    @future(callout=true)
    @AuraEnabled
    public static void LcscallServer(String id){
        Opportunity Opp = [Select id,Name,Email__c,Mobile__c,AccountId,account.name,account.PersonMobilePhone,SalesManagerEmail__c,SalesManagerName__c,DesignerEmail__c,Home_Type__c,Design_User_Name__c,Project_Name__c,Region__c  from Opportunity Where id=: id limit 1];
        
        OppdataWrap Oppdata = new OppdataWrap();
        if(Opp.Name !=null){
            Oppdata.clientName = Opp.Name;
        }
        if(Opp.Email__c !=null){
            Oppdata.emailId = Opp.Email__c;
        }
        if(Opp.Home_Type__c !=null){
            Oppdata.ProertyType = Opp.Home_Type__c;
        }
        if(Opp.Mobile__c !=null){
            Oppdata.phoneNo = Opp.account.PersonMobilePhone ;
        }
        if(Opp.DesignerEmail__c !=null){
           Oppdata.designerEmail = Opp.DesignerEmail__c;
        }
        if(Opp.Project_Name__c !=null){
            Oppdata.propertyName = Opp.Project_Name__c;
        }
        Oppdata.propertyBhk=0;
   
       // }
        if(Opp.Region__c !=null){
            Oppdata.city = Opp.Region__c;
        }
        if(Opp.SalesManagerEmail__c!=null){
            Oppdata.SalesOwnerName = Opp.SalesManagerName__c;
        }
        if(Opp.SalesManagerName__c!=null){
            Oppdata.SalesOwnerEmail = Opp.SalesManagerEmail__c;
        }
        if(Opp.Design_User_Name__c   !=null){
            Oppdata.designerName = Opp.Design_User_Name__c;
        }
        system.debug('Json Serialize : '+JSON.serialize(Oppdata));
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://thedesigncafe.in/Dc_Lead4.0/dcservice/customer/customer');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(Oppdata);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        if(!test.isRunningTest())
        HttpResponse response = http.send(request);
        
    }
}