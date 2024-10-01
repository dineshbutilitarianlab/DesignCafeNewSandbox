//------Author Imtiyaz -------Created Date --19-05-2021-Webengage--\\
public class DC_Webengageupdate {
    public class OppdataWrap{
        public String userId{get;set;}
        @AuraEnabled
        public String firstName{get;set;}
        @AuraEnabled
        public String lastName{get;set;}
        @AuraEnabled
        public String email{get;set;}
        @AuraEnabled
        public String phone{get;set;}
        public Attributes attributes;
    } // opp to webengage
    public class Attributes {
        @AuraEnabled
        public String StageName{get;set;}
        @AuraEnabled
        public String OpportunityStatus{get;set;}
        @AuraEnabled
        public String SalesManagerName{get;set;}
        @AuraEnabled
        public String SalesManagerMobile{get;set;}
        @AuraEnabled
        public String SalesManagerEmail{get;set;}
        @AuraEnabled
        public date ProposalSentDate{get;set;}
        @AuraEnabled
        public String Woohoocard{get;set;}
        @AuraEnabled
        public Boolean UpdateBookingForm{get;set;}
        @AuraEnabled
        public Decimal ClientBudget{get;set;}
        @AuraEnabled
        public Decimal ProposedBudget{get;set;}
        @AuraEnabled
        public date Moveindate{get;set;}
        @AuraEnabled
        public String Region{get;set;}
        @AuraEnabled
        public String ProjectName{get;set;}
        @AuraEnabled
        public String CMMName{get;set;}
        @AuraEnabled
        public String DesignerName{get;set;}
        @AuraEnabled
        public String DesignerEmail {get;set;}
        @AuraEnabled
        public Decimal signupValue{get;set;}
        @AuraEnabled
        public String QualifiedFor{get;set;}
        
    }
    public class responsedata{
        public string code;
        public string message;
        public string status;
    }
    @future(callout=true)
    @AuraEnabled
    public static void Callout(String id){
        DCWebengage__c data1 = DCWebengage__c.getvalues('Dcwebengage');
        List<Opportunity> Opp = [Select id, Amount, Oppy_Qualified_for__c, Name,Email__c,StageName,Opportunity_status__c,Design_User_Name__c,Design_User__c,DesignerEmail__c,Client_s_Budget__c,Move_in__c,Proposed_Budget__c,Wohoo_Card__c,Update_Booking_Form__c,Region__c,SalesManagerEmail__c,Proposal_Sent_Date__c,SalesManagerName__c,SalesManagerMobile__c,Mobile__c,Project_Name__c,CMM_Name__c from Opportunity Where id=: id limit 1];
       IF(Opp.size() != 0){  
        OppdataWrap  Oppdata = new  OppdataWrap ();
        
        if(Opp[0].Mobile__c !=null){
            Oppdata.userId = Opp[0].Mobile__c;
        }
        if(Opp[0].Name !=null){
            Oppdata.firstName = Opp[0].Name;//Opp.FirstName;
        }
        if(Opp[0].Name !=null){
            Oppdata.lastName = Opp[0].Name;
        }
        if(Opp[0].Email__c !=null){
            Oppdata.email = Opp[0].Email__c;
        }
        if(Opp[0].Mobile__c !=null){
            Oppdata.phone = Opp[0].Mobile__c;
        }
        Attributes  attributes= new Attributes();       
        
        if(Opp[0].StageName!=null){
            Attributes.StageName = Opp[0].StageName;
        }
        if(Opp[0].Opportunity_status__c !=null){
            Attributes.OpportunityStatus = Opp[0].Opportunity_status__c;
        }
        if(Opp[0].SalesManagerName__c !=null){
            Attributes.SalesManagerName = Opp[0].SalesManagerName__c;
        }
        if(Opp[0].SalesManagerMobile__c !=null){
            Attributes.SalesManagerMobile = Opp[0].SalesManagerMobile__c;
        }
        if(Opp[0].SalesManagerEmail__c !=null){
            Attributes.SalesManagerEmail = Opp[0].SalesManagerEmail__c;
        }
        if(Opp[0].Project_Name__c !=null){
            Attributes.ProjectName = Opp[0].Project_Name__c;
        }
        if(Opp[0].Proposal_Sent_Date__c !=null){
            Attributes.ProposalSentDate = Opp[0].Proposal_Sent_Date__c;
        }
        if(Opp[0].Region__c !=null){
            Attributes.Region = Opp[0].Region__c;
        }
        if(Opp[0].Wohoo_Card__c !=null){
            Attributes.Woohoocard = Opp[0].Wohoo_Card__c;
        }
        if(Opp[0].Update_Booking_Form__c !=null){
            Attributes.UpdateBookingForm = Opp[0].Update_Booking_Form__c;
        }
        if(Opp[0].Client_s_Budget__c !=null){
            Attributes.ClientBudget = Opp[0].Client_s_Budget__c;
        }
        if(Opp[0].Proposed_Budget__c !=null){
            Attributes.ProposedBudget = Opp[0].Proposed_Budget__c;
        }
        if(Opp[0].Move_in__c !=null){
            Attributes.Moveindate = Opp[0].Move_in__c;
        }
        if(Opp[0].CMM_Name__c !=null){
            Attributes.CMMName = Opp[0].CMM_Name__c;
        }
        if(Opp[0].Design_User_Name__c !=null){
            Attributes.DesignerName = Opp[0].Design_User_Name__c;
        }
        if(Opp[0].DesignerEmail__c !=null){
            Attributes.DesignerEmail = Opp[0].DesignerEmail__c;
        }
        if(Opp[0].Amount != null && Opp[0].StageName != null && Opp[0].StageName == 'Closed Won'){
            Attributes.signupValue = Opp[0].Amount;
        }        
        if(Opp[0].Oppy_Qualified_for__c != null ){
            Attributes.QualifiedFor = Opp[0].Oppy_Qualified_for__c;
        }
        Oppdata.Attributes=attributes;
        String Fullbody = JSON.serialize(Oppdata);
        
        HttpRequest request = new HttpRequest();
        string jsonString = data1.url__c; 
        //request.setEndpoint(jsonString);
         request.setEndpoint('callout:WebEngageCredentials/accounts/76aa813/users');
        request.setMethod('POST');
       // request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
       // request.setHeader('Authorization','Bearer '+data1.BearerToken__c);
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = Fullbody;
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        if(!test.isRunningTest()){
            HttpResponse response = http.send(request);
            system.debug(response);
            system.debug(response.getBody());
        }
       }
    }
}