public class MeetingHistoryLead {
    @AuraEnabled
    public static leadReturnData getDefaultValue(string recId){
        system.debug('recIdrecId '+recId);
        List<String> acceptedStatus = new List<String>{'New', 'Not Connected', 'Connected'};
        if(recId != null){
            Lead l = [SELECT id, Status, meeting_Type__c, meeting_venue__c, Willingness_For_Meeting__c FROM Lead WHERE id = : recId]; 
            leadReturnData lrd = new leadReturnData();
            lrd.leadId = l.id;
            lrd.meetingType = l.meeting_Type__c;
            lrd.meetingVenue = l.meeting_venue__c;
            lrd.meetingDateTime = l.Willingness_For_Meeting__c;
            //lrd.editModeVisibility = !acceptedStatus.contains(l.Status) ;
            return lrd;
        }
        else{
            return null;
        }
    }
    @AuraEnabled
    public static void saveDataTOLead(string records){
        system.debug('records '+records); 
        List<leadReturnData> leadData = (List<leadReturnData>)System.JSON.deserialize(records, List<leadReturnData>.class);
        system.debug(leadData);
        Lead l = new Lead();
        l.id = leadData[0].leadId;
        l.meeting_Type__c = leadData[0].meetingType;
        l.meeting_venue__c = leadData[0].meetingVenue;
        l.Willingness_For_Meeting__c = leadData[0].meetingDateTime;
        update l;
    }
    public class leadReturnData{
        @AuraEnabled
        public string leadId;
        @AuraEnabled
        public string meetingType;
        @AuraEnabled
        public string meetingVenue;
        @AuraEnabled
        public DateTime meetingDateTime;
        @AuraEnabled
        public Boolean editModeVisibility;
        
    }    
}