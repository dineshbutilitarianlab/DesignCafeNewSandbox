public class ReferralPage {
    @AuraEnabled
    public static leadReturnData getDefaultValue(string recId){
        system.debug('recIdrecId '+recId);
        if(recId != null){
            Lead l = [select id,Referee_Name__c,Referee_Email_ID__c,Referee_Number__c,Referee_Code__c from Lead where id = : recId]; 
            leadReturnData lrd = new leadReturnData();
            lrd.leadId = l.Id;
            lrd.RefereeName = l.Referee_Name__c;
            lrd.RefereeNumber = l.Referee_Number__c;
            lrd.RefereeCode = l.Referee_Code__c;
            lrd.RefereeEmail = l.Referee_Email_ID__c;
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
        l.Referee_Name__c = leadData[0].RefereeName;
        l.Referee_Number__c = leadData[0].RefereeNumber;
        l.Referee_Code__c = leadData[0].RefereeCode;
        l.Referee_Email_ID__c = leadData[0].RefereeEmail;
        update l;
    }
    public class leadReturnData{
        @AuraEnabled
        public string leadId;
        @AuraEnabled
        public string RefereeName;
        @AuraEnabled
        public string RefereeNumber;
        @AuraEnabled
        public string RefereeCode;
        @AuraEnabled
        public string RefereeEmail;
        
    }    
}