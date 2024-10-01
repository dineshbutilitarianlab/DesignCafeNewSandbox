public class LeadTraceValidationOpportunityBatch implements Database.Batchable<SObject> {
    public Database.querylocator start(Database.BatchableContext aContext) {
        return Database.getQueryLocator([SELECT id FROM Opportunity]);
    }

	public void execute(Database.BatchableContext BC, List<Opportunity> aScope) {
        Savepoint sp = Database.setSavepoint();
        
        try {
            processRecords(aScope);
        }
        catch(Exception e) {
            Database.rollback(sp);
            throw new CustomException(e.getMessage());
        }
    }
    
    private void processRecords(Opportunity [] aScope) {
        Set<ID> lOppIDSet = new Set<ID>();
        Map<ID, ID> lOppIDToLeadIdMap = new Map<ID, ID>();
        
        for(Opportunity lOpp : aScope) {
            lOppIDSet.add(lOpp.id);
        }
        
        for(Lead lLead : [SELECT id, ConvertedOpportunityId FROM Lead WHERE ConvertedOpportunityId IN:lOppIDSet]) {
            lOppIDToLeadIdMap.put(lLead.ConvertedOpportunityId, lLead.id);
        }
        
        Set<ID> lTraceIdForSharingDeletion = new Set<ID>();
        Lead_Trace__c [] lTracesToInsert = new List<Lead_Trace__c>();
        Lead_Trace__c [] lTracesForUpdation = new List<Lead_Trace__c>();
        Lead_Trace__c [] lDuplicatesToDelete = new List<Lead_Trace__c>();
        
        for(Opportunity lOpp : [SELECT id, OwnerId, StageName, (SELECT id, OwnerId, Status__c, Lead__c, Opportunity__c FROM Lead_Traces__r WHERE 
                                      Status__c IN ('Converted - Pending Sign-up', 'Signed-up') ORDER BY CreatedDate ASC) FROM Opportunity WHERE id IN:lOppIDSet]) {
            Boolean lTraceRecordPresent = false;
            
			for(Lead_Trace__c lTrace : lOpp.Lead_Traces__r) {
                if(lTraceRecordPresent) {
                    lDuplicatesToDelete.add(lTrace);
                    continue;
                }
				
                Boolean lUpdate = false;
                Lead_Trace__c lTraceForUpdation = new Lead_Trace__c(id=lTrace.id);
                
                if(lTrace.OwnerId != lOpp.OwnerId) {
                    lUpdate = true;
                    lTraceForUpdation.OwnerId = lOpp.OwnerId;
                }
                
                if(lOpp.StageName != 'Closed Won' && lTrace.Status__c == 'Signed-up') {
                    lUpdate = true;
                    lTraceForUpdation.Status__c = 'Converted - Pending Sign-up';
                }
                
				if(lOpp.StageName == 'Closed Won' && lTrace.Status__c == 'Converted - Pending Sign-up') {
                    lUpdate = true;
                    lTraceForUpdation.Status__c = 'Signed-up';
                }
                    
                if(lUpdate) {
                    lTraceIdForSharingDeletion.add(lTrace.id);
                    lTracesForUpdation.add(lTraceForUpdation);
                }
                
                lTraceRecordPresent = true;
            }
                                          
			ID lLeadID = lOppIDToLeadIdMap.get(lOpp.id);
                                          
			if(lTraceRecordPresent == false) {
                if(lOpp.StageName == 'Closed Won') {
                    lTracesToInsert.add(new Lead_Trace__c(OwnerId=lOpp.OwnerId, Lead__c=lLeadID, Opportunity__c=lOpp.id, 
                                                          Status__c='Signed-up', Tmestamp__c=Date.today()));
                }
                else {
                    lTracesToInsert.add(new Lead_Trace__c(OwnerId=lOpp.OwnerId, Lead__c=lLeadID, Opportunity__c=lOpp.id, 
                                                          Status__c='Converted - Pending Sign-up', Tmestamp__c=Date.today()));
                }
            }
        }

		if(!lDuplicatesToDelete.isEmpty()) {
        	delete lDuplicatesToDelete;
        }
        
        if(!lTraceIdForSharingDeletion.isEmpty()) {
        	delete [SELECT id FROM Lead_Trace__share WHERE ParentId IN:lTraceIdForSharingDeletion AND RowCause='Manual'];
        }
        
        Lead_Trace__c [] lCombined = new List<Lead_Trace__c>();
        lCombined.addAll(lTracesForUpdation);
        lCombined.addAll(lTracesToInsert);
        
        if(!lCombined.isEmpty()) {
        	Database.upsert(lCombined, false);
        }
        
        Set<ID> lLeadTraceIDSetForRecalculation = new Set<ID>();
        
        for(Lead_Trace__c lTrace : lCombined) {
            lLeadTraceIDSetForRecalculation.add(lTrace.id);
        }
        
        LeadTraceTrigger_Handler.leadTraceShareAccessSync(lLeadTraceIDSetForRecalculation);
    }

	public void finish(Database.BatchableContext aContext) {
        
    }
}