public class LeadTraceTrigger_Handler {
    @future
    public static void leadTraceShareAccess(SET<Id> leadTraceIds) {
        leadTraceShareAccessSync(leadTraceIds);
    }
        
    public static void leadTraceShareAccessSync(SET<Id> leadTraceIds) {
    //public static void leadTraceShareAccess(MAP<Id,Lead_Trace__c> newleadTraceMap){
        MAP<ID,Lead_Trace__c> newleadTraceMap = new MAP<ID,Lead_Trace__c> ([select id,name,lead__c,opportunity__c from Lead_Trace__c where id IN: leadTraceIds]);
        SET<ID> setLeadIds                          = new SET<ID>();
        SET<ID> setOptyIds                          = new SET<ID>();
        list<Lead_Trace__share> listLTshare         = new LIST<Lead_Trace__share>();
        for(Lead_Trace__c each : newleadTraceMap.values()){
            setLeadIds.add(each.Lead__c);
            setOptyIds.add(each.Opportunity__c);
        }
        
        system.debug(setOptyIds);
        MAP<Id,LIST<LeadShare>> mapLeadToleadShare 			= new MAP<Id,LIST<LeadShare>>();
        MAP<Id,LIST<OpportunityShare>> mapOptyToOptyShare 	= new MAP<Id,LIST<OpportunityShare>>();
        for(LeadShare each : [select id, UserOrGroupId,UserOrGroup.Name, LeadAccessLevel,RowCause,leadId From LeadShare where leadId IN : setLeadIds]){
            if(each != null && !mapLeadToleadShare.containsKey(each.leadId)){
                mapLeadToleadShare.put(each.leadId , new LIST<LeadShare>());
            }
            mapLeadToleadShare.get(each.leadId).add(each);
        }
        for(OpportunityShare each : [select id, UserOrGroupId,UserOrGroup.Name, RowCause,OpportunityAccessLevel,OpportunityId From OpportunityShare where OpportunityId IN : setOptyIds]){
            if(each != null && !mapOptyToOptyShare.containsKey(each.OpportunityId)){
                mapOptyToOptyShare.put(each.OpportunityId , new LIST<OpportunityShare>());
            }
            mapOptyToOptyShare.get(each.OpportunityId).add(each);
        }
        system.debug('-------' + mapLeadToleadShare);
        system.debug('-------' + mapOptyToOptyShare);
        if(mapLeadToleadShare != null){
            for(Id eachLTId : newleadTraceMap.keyset()){
                if(newleadTraceMap.get(eachLTId) != null && newleadTraceMap.get(eachLTId).lead__c != null && mapLeadToleadShare.get(newleadTraceMap.get(eachLTId).lead__c) != null){
                    for(LeadShare eachLeadShare : mapLeadToleadShare.get(newleadTraceMap.get(eachLTId).lead__c)){
                        if(eachLeadShare.RowCause != 'Owner' && eachLeadShare.UserOrGroup.Name != 'Unassigned'){
                            Lead_Trace__share CS    = new Lead_Trace__share();
                            CS.parentId             = eachLTId;
                            CS.UserOrGroupId        = eachLeadShare.UserOrGroupId;
                            CS.RowCause             = Schema.leadshare.rowcause.Manual;
                            CS.AccessLevel          = 'Read' ;
                            listLTshare.add(CS);
                        }
                    }
                }
                system.debug(mapOptyToOptyShare.get(newleadTraceMap.get(eachLTId).opportunity__c));
                if(newleadTraceMap.get(eachLTId) != null && newleadTraceMap.get(eachLTId).opportunity__c != null && mapOptyToOptyShare.get(newleadTraceMap.get(eachLTId).opportunity__c) != null){
                    for(OpportunityShare eachOptyShare : mapOptyToOptyShare.get(newleadTraceMap.get(eachLTId).opportunity__c)){
                        if(eachOptyShare.RowCause != 'Owner' && eachOptyShare.UserOrGroup.Name != 'Unassigned'){
                            Lead_Trace__share CS    = new Lead_Trace__share();
                            CS.parentId             = eachLTId;
                            CS.UserOrGroupId        = eachOptyShare.UserOrGroupId;
                            CS.RowCause             = Schema.Opportunityshare.rowcause.Manual;
                            CS.AccessLevel          = 'Read';
                            listLTshare.add(CS);
                        }
                    }
                }
            } 
            system.debug(listLTshare);
        }
        if(listLTshare.size() > 0){
            database.Upsert(listLTshare,false); 
        }
    }
}