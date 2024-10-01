public class ReferralPageOppty {
 @AuraEnabled
    public static OpportunityReturnData getDefaultValue(string recId){
        system.debug('recIdrecId '+recId);
        if(recId != null){
            Opportunity o = [select id,ST_Referee_Name__c,ST_Referee_Number__c,ST_Referee_Code__c,Referee_Email_ID__c from Opportunity where id = : recId]; 
            OpportunityReturnData ord = new OpportunityReturnData();
            ord.OpportunityId = o.Id;
            ord.RefereeName = o.ST_Referee_Name__c;
            ord.RefereeNumber = o.ST_Referee_Number__c;
            ord.RefereeCode = o.ST_Referee_Code__c;
            ord.RefereeEmail = o.Referee_Email_ID__c;
            return ord;
        }
        else{
            return null;
        }
    }
    @AuraEnabled
    public static void saveDataTOOpportunity(string records){
        system.debug('records '+records); 
        List<OpportunityReturnData> OpportunityData = (List<OpportunityReturnData>)System.JSON.deserialize(records, List<OpportunityReturnData>.class);
        system.debug(OpportunityData);
        Opportunity o = new Opportunity();
        o.id = OpportunityData[0].OpportunityId;
        o.ST_Referee_Name__c = OpportunityData[0].RefereeName;
        o.ST_Referee_Number__c = OpportunityData[0].RefereeNumber;
        o.ST_Referee_Code__c = OpportunityData[0].RefereeCode;
        o.Referee_Email_ID__c = OpportunityData[0].RefereeEmail;
        update o;
    }
    public class OpportunityReturnData{
        @AuraEnabled
        public string OpportunityId;
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