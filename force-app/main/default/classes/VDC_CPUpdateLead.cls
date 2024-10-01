/*
 * Code Modifier : V-Fory Team
 * Modified Date : 11th November 2021
 * Modified By   : Munna Shaik
 */ 
public class VDC_CPUpdateLead {
     public class leadCPDataWrap{
        public String id{get;set;}
        public String leadStatus{get;set;}
        public String leadStage{get;set;}
        public String name{get;set;}
        public String phoneNumber{get;set;}
        public String projectName{get;set;}
        public String city{get;set;}
        public String email{get;set;}
        public String areaCode{get;set;}
        public String note{get;set;}
        public String createdDate{get;set;}
        public string dateAndTimeOfMeetingScheduled{get;set;}
        public String meetingVenue{get;set;}
        public String dsaRefCode{get;set;}
        public String dsaAccountId{get;set;}
        public String convertedOpportunityId{get;set;}
        public String cmmName{get;set;}
        public string accountId{get;set;}  
    }
    public class responsedata{      
        public Integer statusCode;
        public String body;
     /*   public static responsedata parse(String json) {
            return (responsedata) System.JSON.deserialize(json, responsedata.class)
                }   */
    }
     @future(callout=true)
    public static void CPcallout(String id){
        CPPortal__c data1 = CPPortal__c.getvalues('cpportalupdate');
        Lead ld = [Select Id,Name,Email,Phone,Status,APIMOBILE__c,DSA_Code__c,Willingness_For_Meeting__c,DC_Lead_Status__c,Meeting_Type__c,
                   Meeting_Venue__c,City,Project_Name__c,CMM_Name__c,PostalCode,Description,CreatedDate,DSA__c,ConvertedOpportunityId,
                   ConvertedAccountId,channel__c,Source__c from Lead Where id=: id limit 1];
        System.debug('ld '+ld);
        leadCPDataWrap  leadcpdata = new  leadCPDataWrap ();
        if(ld.Id !=null){
            leadcpdata.id = ld.Id;
        }
        if(ld.DC_Lead_Status__c !=null){
            leadcpdata.leadStatus = ld.DC_Lead_Status__c;
        }else{
            leadcpdata.leadStatus = 'Null';
        }
        if(ld.Status !=null){
            leadcpdata.leadStage = ld.Status;
        }
        if(ld.Name !=null){
            leadcpdata.name = ld.Name;
        }
        if(ld.APIMOBILE__c !=null){
            leadcpdata.phoneNumber = ld.APIMOBILE__c;
        }       
        if(ld.Project_Name__c !=null){
            leadcpdata.projectName = ld.Project_Name__c;
        }else{
            leadcpdata.projectName = 'Null';
        }
        if(ld.City !=null){
            leadcpdata.city = ld.City;
        }
        if(ld.Email !=null){
            leadcpdata.email = ld.Email;
        }else{
             leadcpdata.email = 'Null';
        }
        if(ld.PostalCode !=null){
            leadcpdata.areaCode = ld.PostalCode;
        }else{
            leadcpdata.areaCode = 'Null'; 
        }
        if(ld.Description !=null){
            leadcpdata.note = ld.Description;
        }else{
            leadcpdata.note = 'Null';
        }
        if(ld.CreatedDate !=null){
            leadcpdata.createdDate = string.valueOf(ld.CreatedDate);
        }       
        if(ld.Willingness_For_Meeting__c !=null){
            leadcpdata.dateAndTimeOfMeetingScheduled = string.valueOf(ld.Willingness_For_Meeting__c);
        }else{
            leadcpdata.dateAndTimeOfMeetingScheduled = 'Null';
        }
        if(ld.Meeting_Venue__c !=null){
            leadcpdata.meetingVenue = ld.Meeting_Venue__c;
        }else{
            leadcpdata.meetingVenue = 'Null';
        }
        if(ld.DSA_Code__c !=null){
            leadcpdata.dsaRefCode = ld.DSA_Code__c;
        }else{
            leadcpdata.dsaRefCode = 'Null';
        }
        if(ld.DSA__c !=null){
            leadcpdata.dsaAccountId = ld.DSA__c;
        }else{
            leadcpdata.dsaAccountId = 'Null';
        }
        if(ld.ConvertedOpportunityId !=null){
            leadcpdata.convertedOpportunityId = ld.ConvertedOpportunityId;
        }else{
            leadcpdata.convertedOpportunityId = 'Null';
        }
        if(ld.CMM_Name__c !=null){
            leadcpdata.cmmName = ld.CMM_Name__c;
        }else{
            leadcpdata.cmmName = 'Null';
        }       
        if(ld.DSA__c !=null){
            leadcpdata.accountId = ld.DSA__c;
        }else{
            leadcpdata.accountId = 'Null';
        }
        String Fullbody = JSON.serialize(leadcpdata);
        System.debug('Fullbody '+Fullbody);
        HttpRequest request = new HttpRequest();
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