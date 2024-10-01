public class LeadBeforeInsertTriggerHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        Set<ID> lDesigerIDSet = new Set<ID>();
        
        for(SObject lSObj : tp.newList) {
            Lead lLead = (Lead)lSObj;
            
            if(lLead.Designer__c != null) {
                lDesigerIDSet.add(lLead.Designer__c);
            }
        }
        
        Map<ID, User> lDesignerToUserMap = new Map<ID, User>([SELECT id, Team__c FROM User WHERE id IN:lDesigerIDSet]); 
        
        for(SObject lSObj : tp.newList) {
            Lead lLead = (Lead)lSObj;
            lLead.put('Follow_Up_Count__c', 0);
            
            if(lLead.DSA__c != null) {
                lLead.Region__c = lLead.City;
                //lLead.DC_Lead_Source__c = 'Direct';
                //lLead.Campaign_Source__c = lLead.DSA_Code__c;
            }
            
            if(lLead.Designer__c != null) {
              //  lLead.Is_Designer_Assigned__c = true;
                
                User lDesigner = lDesignerToUserMap.get(lLead.Designer__c);
                
                if(lDesigner != null) {
                   // lLead.Designer_Team_Name__c = lDesigner.Team__c;
                }
            }
        }
        
        LeadTrigger_Handler.updateLeadTeamAndRegion((List < Lead > ) tp.newList,New Set<Id> ());
        LeadTrigger_Handler.updateRefereeAndDSA((List < Lead > ) tp.newList);
        LeadTrigger_Handler.preventDuplicates((List < Lead > ) tp.newList);
        LeadTrigger_Handler.updateOCMTeam((List < Lead > ) tp.newList);
        
    }
}