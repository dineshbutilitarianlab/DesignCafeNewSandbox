public class LeadtoGenesys {
    @future(callout=true)
    public static void Callout(String LeadId){
        try{
            Leadtogenesys__c data1 = Leadtogenesys__c.getvalues('genesysapi');
            Lead l = [select id,Name,Email,MobilePhone,Source__c,Project_Name__c,Region__c,Channel__c,City,DC_Lead_Source__c,LastModifiedDate,Follow_Up_Date_Time__c,LastModifiedBy__c,DC_Campaign_Source__c,DSA__c,DSAname__c,Lead_Owner_Name__c,CreatedBy.id,DC_Lead_Status__c,Status,Call_Stage__c,CreatedDate,Property_Possession_Date__c from Lead Where id=: LeadId LIMIT 1];
            string jsonString = data1.url__c; 
            String toSend = jsonString +'?PHONE='+l.MobilePhone+'&NAME='+l.Name+'&MAIL_ID='+l.Email+'&SOURCE='+l.Source__c+'&REGION='+l.City+'&CHANNEL='+l.Channel__c+'&LAST_MODIFIED_BY='+l.LastModifiedBy__c+'&LEAD_SOURCE='+l.DC_Lead_Source__c+'&CAMPAIGN_SOURCE='+l.DC_Campaign_Source__c+'&CREATE_DATE='+l.CreatedDate+'&PROJECT_NAME='+l.Project_Name__c+'&LEAD_ID='+l.LastModifiedDate+'&LEAD_STAGE='+l.Status+'&LEAD_STATUS='+l.DC_Lead_Status__c+'&CALL_STAGE='+l.Call_Stage__c+'&PP_DATE='+l.Property_Possession_Date__c+'&SF_LEAD_ID='+l.Id+'&DSA_Name='+l.DSAname__c+'&Followup_Date='+l.Follow_Up_Date_Time__c+'&Agent_Name='+l.Lead_Owner_Name__c;
            system.debug(toSend);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setMethod('POST');
            req.setEndpoint(toSend);
            req.setTimeout(120000);
            res = http.send(req);
            System.debug(res);
      System.debug(res.getBody());
        }catch(Exception exc){
            
        }
       
    }
   
}