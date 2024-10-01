public class MeetingHistoryOpportunity {
    @AuraEnabled
    public static OppReturnData getDefaultValue(string recId){
        system.debug('recIdrecId '+recId);
        if(recId != null){
            Opportunity o = [select id,meeting_Type__c,meeting_venue__c,Meeting_Scheduled_Date_Time__c from Opportunity where id = : recId]; 
            OppReturnData ord = new OppReturnData();
            ord.opportunityId = o.id;
            ord.meetingType = o.meeting_Type__c;
            ord.meetingVenue = o.meeting_venue__c;
            ord.meetingDateTime = o.Meeting_Scheduled_Date_Time__c;
            return ord;
        }
        else{
            return null;
        }
    }
    @AuraEnabled
    public static void saveDataTOLead(string records){
        system.debug('records '+records); 
        List<OppReturnData> oppData = (List<OppReturnData>)System.JSON.deserialize(records, List<OppReturnData>.class);
        system.debug(oppData);
        Opportunity o = new Opportunity();
        o.Id = oppData[0].opportunityId;
        o.meeting_Type__c = oppData[0].meetingType;
        o.meeting_venue__c = oppData[0].meetingVenue;
        o.Meeting_Scheduled_Date_Time__c = oppData[0].meetingDateTime;
        update o;
    }
    public class OppReturnData{
        @AuraEnabled
        public string opportunityId;
        @AuraEnabled
        public string meetingType;
        @AuraEnabled
        public string meetingVenue;
        @AuraEnabled
        public DateTime meetingDateTime;
        
    }   
}