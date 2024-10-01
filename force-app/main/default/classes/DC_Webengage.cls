//------Author Imtiyaz  -------Created Date --12-05-2021-Webengage--\\
public class DC_Webengage {
    public class leadDataWrap{
        public String userId{get;set;}
        @AuraEnabled
        public String firstName{get;set;}
        @AuraEnabled
        public String lastName{get;set;}
        @AuraEnabled
        public String email{get;set;}
        @AuraEnabled
        public String phone{get;set;}
        @AuraEnabled
        public Boolean whatsappOptIn{get;set;}
        @AuraEnabled
        public Boolean smsOptIn{get;set;}        
        @AuraEnabled
        public Boolean emailOptIn{get;set;}
        public Attributes attributes;
    }
    public class Attributes {
        @AuraEnabled
        public String LeadStage{get;set;}
        @AuraEnabled
        public String LeadStatus{get;set;}
        @AuraEnabled
        public String Reason{get;set;}
        @AuraEnabled
        public String Meetingtype{get;set;}
        @AuraEnabled
        public String MeetingVenue{get;set;}
        @AuraEnabled
        public String DesignerName{get;set;}
        @AuraEnabled
        public String DesignerEmail {get;set;}
        @AuraEnabled
        public String City{get;set;}
        @AuraEnabled
        public String Channel{get;set;}
        @AuraEnabled
        public String Source{get;set;}
        @AuraEnabled
        public String MessagingSource{get;set;}
        @AuraEnabled
        public String CampaignSource{get;set;}
        @AuraEnabled
        public String LeadSource{get;set;}
        @AuraEnabled
        public String ProjectName{get;set;}
        @AuraEnabled
        public String ProjectAddress{get;set;}
        @AuraEnabled
        public String CMMName{get;set;}
        @AuraEnabled
        public String DSAName{get;set;}
        @AuraEnabled
        public String SalesManagerName{get;set;}
        @AuraEnabled
        public String SalesManagerMobile{get;set;}
        @AuraEnabled
        public String SalesManagerEmail{get;set;}
         @AuraEnabled
        public datetime MeetingScheduleddatetime{get;set;}
        @AuraEnabled
        public String DesignerMobile{get;set;}
        @AuraEnabled
        public String OTPVerified{get;set;}
        @AuraEnabled
        public datetime Datewhenmeetingisscheduled{get;set;}
        @AuraEnabled
        public String PropertyType{get;set;}
        @AuraEnabled
        public String ScopeOfWork{get;set;}
        @AuraEnabled
        public datetime RecontactedDate{get;set;}
        @AuraEnabled
        public String Interiorworkneededfor{get;set;}
        @AuraEnabled
        public String PropertyUsage{get;set;}
        @AuraEnabled
        public String SiteServicesWork{get;set;}
        @AuraEnabled
        public String DSACode{get;set;}
         @AuraEnabled
        public date PossesionDate{get;set;}
        @AuraEnabled
        public String ApproxBudget{get;set;}
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
        Lead ld;
        List<Lead> leadList =  [SELECT id,Name,Lead_Qualified_for__c,Email,Phone,Status,FirstName,Approx_Budget__c,Design_User_Name__c,
                                    APIMOBILE__c,DSA_Code__c,Interior_work_needed_for__c,Property_Possession_Date__c,Client_Site_visit__c,
                                    Re_Contact_Date__c,OTP_Verified__c,Scope_Of_Work__c,Home_Type__c,Date_When_Meeting_is_Scheduled__c,
                                    Property_Usage__c,Whatsapp_Opt_IN__c,DesignerMobile__c,Lead_Owner_Mobile__c,Willingness_For_Meeting__c,
                                    Lead_Owner_Name__c,Lead_owner_Email__c,LastName,DC_Lead_Status__c,Call_Stage__c,UserID__c,Meeting_Type__c,
                                    Meeting_Venue__c,Designer_Name__c,DesignerEmail__c,City,Channel__c,Source__c,Project_Name__c,Messaging_Source__c,
                                    DC_Campaign_Source__c,DC_Lead_Source__c,Property_Address__c,CMM_Name__c,DSAname__c 
                                FROM Lead 
                                WHERE id=: id limit 1];

        if(leadList.size() > 0){
            ld = leadList.get(0);
        }else {
            return ;
        }
        //Lead ld = [Select id,Name,Lead_Qualified_for__c,Email,Phone,Status,FirstName,Approx_Budget__c,Design_User_Name__c,APIMOBILE__c,DSA_Code__c,Interior_work_needed_for__c,Property_Possession_Date__c,Client_Site_visit__c,Re_Contact_Date__c,OTP_Verified__c,Scope_Of_Work__c,Home_Type__c,Date_When_Meeting_is_Scheduled__c,Property_Usage__c,Whatsapp_Opt_IN__c,DesignerMobile__c,Lead_Owner_Mobile__c,Willingness_For_Meeting__c,Lead_Owner_Name__c,Lead_owner_Email__c,LastName,DC_Lead_Status__c,Call_Stage__c,UserID__c,Meeting_Type__c,Meeting_Venue__c,Designer_Name__c,DesignerEmail__c,City,Channel__c,Source__c,Project_Name__c,Messaging_Source__c,DC_Campaign_Source__c,DC_Lead_Source__c,Property_Address__c,CMM_Name__c,DSAname__c from Lead Where id=: id limit 1];
        
        leadDataWrap  leaddata = new  leadDataWrap ();
        if(ld.APIMOBILE__c !=null){
            leaddata.userId = ld.APIMOBILE__c;
        }
        if(ld.FirstName !=null){
            leaddata.firstName = ld.LastName;//ld.FirstName;
        }
        if(ld.LastName !=null){
            leaddata.lastName = ld.LastName;
        }
        if(ld.Email !=null){
            leaddata.email = ld.Email;
        }
        if(ld.APIMOBILE__c   !=null){
            leaddata.phone = ld.APIMOBILE__c;
        }
        
        if(ld.Whatsapp_Opt_IN__c   !=null){
            leaddata.whatsappOptIn = ld.Whatsapp_Opt_IN__c;
        }
        if(ld.Channel__c !=null && ld.Channel__c == 'Offline'){
            leaddata.smsOptIn = false;
            leaddata.emailOptIn = false;
        }

        
        Attributes  attributes= new Attributes();       
        
        if(ld.Status !=null){
            Attributes.LeadStage = ld.Status;
        }
        if(ld.DC_Lead_Status__c !=null){
            Attributes.LeadStatus = ld.DC_Lead_Status__c;
        }
        if(ld.Call_Stage__c !=null){
            Attributes.Reason = ld.Call_Stage__c;
        }
        if(ld.Meeting_Type__c !=null){
            Attributes.Meetingtype = ld.Meeting_Type__c;
        }
        if(ld.Meeting_Venue__c !=null){
            Attributes.MeetingVenue = ld.Meeting_Venue__c;
        }
        if(ld.Design_User_Name__c !=null){
            Attributes.DesignerName = ld.Design_User_Name__c;
        }
        if(ld.Project_Name__c !=null){
            Attributes.ProjectName = ld.Project_Name__c;
        }
        if(ld.DesignerEmail__c !=null){
            Attributes.DesignerEmail = ld.DesignerEmail__c;
        }
        if(ld.City !=null){
            Attributes.City = ld.City;
        }
        if(ld.Channel__c !=null){
            Attributes.Channel = ld.Channel__c;
        }
        if(ld.Source__c !=null){
            Attributes.Source = ld.Source__c;
        }
        if(ld.Messaging_Source__c !=null){
            Attributes.MessagingSource = ld.Messaging_Source__c;
        }
        if(ld.DC_Campaign_Source__c !=null){
            Attributes.CampaignSource = ld.DC_Campaign_Source__c;
        }
        if(ld.DC_Lead_Source__c !=null){
            Attributes.LeadSource = ld.DC_Lead_Source__c;
        }
        if(ld.CMM_Name__c !=null){
            Attributes.CMMName = ld.CMM_Name__c;
        }
        if(ld.DSAname__c !=null){
            Attributes.DSAName = ld.DSAname__c;
        }
        if(ld.Property_Address__c !=null){
            Attributes.ProjectAddress = ld.Property_Address__c;
        }
        if(ld.Lead_Owner_Name__c !=null){
            Attributes.SalesManagerName = ld.Lead_Owner_Name__c ;
        }
        if(ld.Lead_Owner_Mobile__c !=null){
            Attributes.SalesManagerMobile = ld.Lead_Owner_Mobile__c;
        }
        if(ld.Lead_owner_Email__c !=null){
            Attributes.SalesManagerEmail = ld.Lead_owner_Email__c   ;
        }
        if(ld.Willingness_For_Meeting__c !=null){
            Attributes.MeetingScheduleddatetime = ld.Willingness_For_Meeting__c;
        }
         if(ld.DesignerMobile__c !=null){
            Attributes.DesignerMobile = ld.DesignerMobile__c;
        }
        if(ld.OTP_Verified__c !=null){
            Attributes.OTPVerified = ld.OTP_Verified__c;
        }
        
        if(ld.Date_When_Meeting_is_Scheduled__c  !=null){
            Attributes.Datewhenmeetingisscheduled = ld.Date_When_Meeting_is_Scheduled__c;
        }
        if(ld.Home_Type__c !=null){
            Attributes.PropertyType = ld.Home_Type__c;
        }
        if(ld.Scope_Of_Work__c !=null){
            Attributes.ScopeOfWork = ld.Scope_Of_Work__c;
        }
        if(ld.Re_Contact_Date__c !=null){
            Attributes.RecontactedDate = ld.Re_Contact_Date__c;
        }
        if(ld.Interior_work_needed_for__c !=null){
            Attributes.Interiorworkneededfor = ld.Interior_work_needed_for__c;
        }
        if(ld.Property_Usage__c  !=null){
            Attributes.PropertyUsage = ld.Property_Usage__c ;
        }
        if(ld.Client_Site_visit__c !=null){
            Attributes.SiteServicesWork = ld.Client_Site_visit__c;
        }
        if(ld.DSA_Code__c !=null){
            Attributes.DSACode = ld.DSA_Code__c;
        }
        if(ld.Property_Possession_Date__c !=null){
            Attributes.PossesionDate = ld.Property_Possession_Date__c;
        }
        if(ld.Approx_Budget__c !=null){
            Attributes.ApproxBudget = ld.Approx_Budget__c;
        }
        if (ld.Lead_Qualified_for__c  != null) {
            Attributes.QualifiedFor = ld.Lead_Qualified_for__c;
        }
        leaddata.Attributes=attributes;
        String Fullbody = JSON.serialize(leaddata);
        
        HttpRequest request = new HttpRequest();
       
       
			 string jsonString  = data1.url__c; 
         
        request.setEndpoint(jsonString);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Authorization','Bearer '+data1.BearerToken__c);
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