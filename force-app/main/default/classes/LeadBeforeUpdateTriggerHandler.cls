public class LeadBeforeUpdateTriggerHandler extends TriggerHandlerBase {
    public static Boolean isBeforeUpdateExecuted = false;
    public override void mainEntry(TriggerParameters tp) {
        try{
            Set<ID> lDesigerIDSet = new Set<ID>();
            Set<String> centerSet = New Set<String>();
            for(SObject lSObj : tp.newList) {
                Lead lLead = (Lead)lSObj;
                IF(lLead.Meeting_Venue__c!=Null){
                   centerSet.add(lLead.Meeting_Venue__c);  
                }

                if(lLead.Designer__c != null) {
                    lDesigerIDSet.add(lLead.Designer__c);
                }
            }
            
            Map<ID, User> lDesignerToUserMap = new Map<ID, User>([SELECT id, Team__c FROM User WHERE id IN:lDesigerIDSet]); 
            
            for(SObject lSObj : tp.newList) {
                Lead lLead = (Lead)lSObj;
                
                if(lLead.DSA__c != null) {
                    //lLead.DC_Lead_Source__c = 'Direct';---
                    //lLead.Channel__c = 'Offline';
                    //lLead.Source__c = 'Direct';
                   // lLead.Campaign_Source__c = lLead.DSA_Code__c;---
                }
                
              //  lLead.Is_Designer_Assigned__c = false;
                
                if(lLead.Designer__c != null) {
                   // lLead.Is_Designer_Assigned__c = true;
                    
                    User lDesigner = lDesignerToUserMap.get(lLead.Designer__c);
                    
                    if(lDesigner != null) {
                      //  lLead.Designer_Team_Name__c = lDesigner.Team__c; ------
                    // ********************disabling for designer dashboard on 30/11/2020*******************
                    }
                }
            }
            
            Application_Settings__c recordOwner = Application_Settings__c.getValues('CRASH_RECORD_OWNER');
            //updateOwner((List < Lead > ) tp.newList);
            updateLeadOwnerRegionAndTeam((Map <Id,Lead > ) tp.oldMap,(Map <Id,Lead > ) tp.newMap);
            if(isBeforeUpdateExecuted == false) {
                LeadTrigger_Handler.updateRefereeAndDSA((List < Lead > ) tp.newList);
                LeadTrigger_Handler.miscUpdatesOnLeads((Map <Id,Lead > ) tp.newMap, (Map <Id,Lead > ) tp.oldMap);
                LeadTrigger_Handler.updateFollowUpTime((Map <Id,Lead > ) tp.newMap, (Map <Id,Lead > ) tp.oldMap);
             //   LeadTrigger_Handler.distributeLeadToSalesOnMtngScheduled((Map <Id,Lead > ) tp.newMap, (Map <Id,Lead > ) tp.oldMap,centerSet);
             
                
                try {
                 //   LeadAssignmentHandler.assignDesignerByRR(tp.newList, (Map <Id,Lead > ) tp.oldMap);
                }
                catch(Exception e) {
                    if(recordOwner != Null){
                Database.insert(new Error_Log__c(Error_Message__c=e.getMessage(),Error_Type__c='Lead Designer Round Robin',Entity_Info__c =tp.newList[0].Id, OwnerId=recordOwner.value__c),false);
                    }
                }
                isBeforeUpdateExecuted = true;
            }
            
            LeadTrigger_Handler.handleLeadCustomSharing(tp.oldList, tp.newList);
        }catch(Exception e) {
            System.debug('^^^ e=' + e);
               throw new CustomException('There is an issue with this record.' + e.getMessage() + ' Please contact your System Admin');
        }
    }
    
    
    private static void updateLeadOwnerRegionAndTeam(Map<Id,Lead> oldMap,Map<Id,Lead> newMap){
        List<Lead> LeadListToBeUpdated = New List<Lead>();
        Set<Id> ownerIdSet = New Set<Id>();
        For(Id leadKey:newMap.keyset()){
            If((oldMap.get(leadKey).ownerId!=newMap.get(leadKey).ownerId ||
                oldMap.get(leadKey).Call_Center_Agent__c!=newMap.get(leadKey).Call_Center_Agent__c) && 
                newMap.get(leadKey).ownerId.getSObjectType().getDescribe().getName().equalsIgnoreCase('User')){
                LeadListToBeUpdated.add(newMap.get(leadKey));
                ownerIdSet.add(newMap.get(leadKey).ownerId);
                    If(newMap.get(leadKey).Call_Center_Agent__c!=Null){
                        ownerIdSet.add(newMap.get(leadKey).Call_Center_Agent__c);
                    }
            }
        }
        If(LeadListToBeUpdated.size()>0){
            LeadTrigger_Handler.updateLeadTeamAndRegion(LeadListToBeUpdated,ownerIdSet);
        }
    }
    
    
}